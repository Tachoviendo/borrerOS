# Instalar ALSA con PipeWire como servidor de audio #10

La idea es que BorrerOS cuente con soporte nativo de audio mediante **ALSA** como capa de bajo nivel y **PipeWire** como servidor de audio encargado de gestionar los dispositivos.

---

## ¿Qué tuvimos que cambiar?

Dos cosas: la configuración del **kernel** y el **script de bootstrap**.

---

## 1. El kernel (`kernel/kernel.config`)

El kernel básico que veníamos usando no tenía soporte completo para los drivers de sonido estándar (ALSA/Sound Core), que es la base sobre la cual trabaja PipeWire para comunicarse con el hardware.

Las opciones que estaban desactivadas eran estas:

```
# CONFIG_SOUND is not set              (Subsistema de sonido ALSA)
```

### Los cambios

En `kernel.config` habilitamos el soporte de audio nativo reemplazando la línea anterior por estas:

```
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_HDA_INTEL=y     (Driver de audio Intel HD, estándar para virtualizadores)
```

### IMPORTANTE: hay que recompilar el kernel

Al modificar el archivo estructural `.config`, no basta con reconstruir el rootfs. Es obligatorio recompilar el kernel desde cero para que incluya estos drivers:

```bash
./kernel/compile_kernel.sh
```

Esto puede demorar entre 10 y 40 minutos dependiendo de tu hardware.

---

## 2. El script de bootstrap (`scripts/bootstrap_base.sh`)

En el paso de aprovisionamiento por `chroot` (donde se instalan los paquetes mediante `apt`), añadimos las herramientas de ALSA y el stack de PipeWire.

### Lo que se agregó

```bash
# ALSA + PipeWire como servidor de audio
apt install -y \
    alsa-utils \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber

# Habilitar los servicios de PipeWire para que inicien con el sistema
systemctl --global enable pipewire pipewire-pulse wireplumber
```

### ¿Por qué `pipewire-pulse`?

Si bien el servidor de audio es PipeWire, muchas aplicaciones todavía esperan encontrarse con la API de PulseAudio. `pipewire-pulse` provee esa capa de compatibilidad, permitiendo que esas aplicaciones funcionen sin cambios mientras PipeWire gestiona el audio por debajo.

### ¿Por qué `wireplumber`?

PipeWire necesita una política de sesión que decida cómo se conectan los dispositivos y los streams entre sí. `wireplumber` es el gestor de sesión recomendado para PipeWire y se encarga de esa lógica de enrutamiento automático.

---

## Orden de ejecución actualizado

```bash
1. sudo ./scripts/setup_host.sh
2. ./kernel/compile_kernel.sh       ← RECOMPILAR con el nuevo .config de audio
3. sudo ./scripts/bootstrap_base.sh  ← Instala alsa-utils, pipewire y wireplumber
4. sudo ./scripts/build_image.sh
5. ./run_qemu.sh -soundhw hda       ← Habilitar hardware de audio en QEMU
```

Si todo salió bien, tras instalar el audio base PipeWire quedará gestionando los dispositivos de sonido del sistema, con soporte de compatibilidad para aplicaciones que dependan de la API de PulseAudio.
