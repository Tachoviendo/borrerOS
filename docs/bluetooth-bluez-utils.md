# Bluetooth y Audio (`bluez-utils` + `pavucontrol`) #24

La idea es que BorrerOS cuente con soporte nativo de audio y conectividad **Bluetooth** administrada mediante **pavucontrol**, permitiendo conectar dispositivos y controlarlos una vez que el sistema de sonido esté instalado.

---

## ¿Qué tuvimos que cambiar?

Dos cosas: la configuración del **kernel** y el **script de bootstrap**.

---

## 1. El kernel (`kernel/kernel.config`)

El kernel básico que veníamos usando no tenía activos los módulos del subsistema de Bluetooth (que `bluez` necesita para interactuar con el hardware) ni soporte completo para los drivers de sonido estándar (ALSA/Sound Core).

Las opciones que estaban desactivadas o en modo modular incompleto eran estas:

```
# CONFIG_BT is not set                 (Soporte general de Bluetooth)
# CONFIG_SOUND is not set              (Subsistema de sonido ALSA)
```

### Los cambios

En `kernel.config` habilitamos el stack de red para Bluetooth y el soporte de audio nativo reemplazando las líneas anteriores por estas:

```
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_HCIBTUSB=y       (Soporte para dongles y placas Bluetooth USB en QEMU)
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

En el paso de aprovisionamiento por `chroot` (donde se instalan los paquetes mediante `apt`), añadimos las herramientas de conectividad y el stack de control de audio.

### Lo que se agregó

```bash
# Herramientas de conectividad Bluetooth, control de audio y lanzadores visuales
apt install -y \
    rofi \
    bzmenu \
    bluez \ este no agregar porque no esta como paquete apt, estoy viendo como lo puedo instalarlo vía pipx/cargo.
    bluez-utils \
    pulseaudio \
    pavucontrol

# Habilitar los servicios de Bluetooth para que inicien con el sistema
systemctl enable bluetooth
```

### ¿Por qué `pavucontrol`?

Nos permite gestionar de manera interactiva y gráfica los flujos de entrada y salida de audio, facilitando la redirección del sonido hacia los periféricos Bluetooth que se conecten al sistema, sin necesidad de lidiar con configuraciones complejas de ALSA por consola.

### ¿Por qué `rofi` y `bzmenu`?

`pavucontrol` es una aplicación gráfica y necesita un lanzador para que el usuario pueda invocarla cómodamente desde la interfaz. Se agrega `rofi` con los themes del repositorio [adi1090x/rofi](https://github.com/adi1090x/rofi) como menú visual de acceso rápido, y `bzmenu` como menú específico para gestionar los dispositivos Bluetooth (buscar, emparejar y conectar) sin salir del entorno gráfico. Entre ambos cumplen el criterio de aceptación de la tarjeta que pide instalar `bzmenu` y `rofi` con dichos themes.

---

## Orden de ejecución actualizado

```bash
1. sudo ./scripts/setup_host.sh
2. ./kernel/compile_kernel.sh       ← RECOMPILAR con el nuevo .config de audio/BT
3. sudo ./scripts/bootstrap_base.sh  ← Instala rofi, bzmenu, bluez-utils y pavucontrol
4. Clonar los temas de adi1090x en el directorio de configuración correspondiente
5. sudo ./scripts/build_image.sh
6. ./run_qemu.sh -soundhw hda       ← Habilitar hardware de audio en QEMU
```

Si todo salió bien, tras instalar el audio base podrás emparejar tus dispositivos Bluetooth y controlar todo el flujo multimedia directamente desde la interfaz de pavucontrol.
