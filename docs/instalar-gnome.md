# Agregando GNOME a borrerOS

La idea es que al bootear la iso, el sistema levante directamente con **GNOME** (la versión liviana, `gnome-core`) y el display manager **GDM3** manejando el login.

---

## ¿Qué tuvimos que cambiar?

Dos cosas: el **kernel** y un **módulo nuevo** en `scripts/modules/`.

---

## 1. El kernel (`kernel/kernel.config`)

El kernel que teníamos compilado no tenía soporte para framebuffer ni para emulación fbdev, que son cosas que GNOME necesita para poder dibujar en pantalla, especialmente al arrancar y mientras el compositor Mutter todavía no levantó.

Las opciones que estaban desactivadas eran estas tres:

```
# CONFIG_FB is not set                  ← soporte para framebuffer
# CONFIG_DRM_FBDEV_EMULATION is not set ← emulación fbdev sobre DRM
```

Y `CONFIG_FRAMEBUFFER_CONSOLE` ni siquiera estaba en el archivo porque depende de `CONFIG_FB`.

Las buenas noticias: `CONFIG_DRM=y` y `CONFIG_DRM_VIRTIO_GPU=y` ya estaban activadas, así que QEMU no debería tener problema para renderizar.

### Los cambios

En `kernel.config` reemplazamos esto:

```
# CONFIG_FB is not set
```

por esto:

```
CONFIG_FB=y
CONFIG_FRAMEBUFFER_CONSOLE=y
```

Y esto:

```
# CONFIG_DRM_FBDEV_EMULATION is not set
```

por esto:

```
CONFIG_DRM_FBDEV_EMULATION=y
```

Tres líneas. Nada más.

### IMPORTANTE: hay que recompilar el kernel

Después de cambiar el `.config` no alcanza con volver a correr `bootstrap_base.sh`. Hay que recompilar el kernel desde cero:

```bash
./kernel/compile_kernel.sh
```

Esto tarda un rato (depende del hardware, entre 10 y 40 minutos). Después de eso sí se puede continuar con el bootstrap.

---

## 2. El módulo (`scripts/modules/install_gnome.sh`)

En vez de meterle la instalación gráfica directo al `bootstrap_base.sh`, lo separamos en un módulo independiente. La idea de los módulos es que cada funcionalidad extra sea opcional y se ejecute entre el bootstrap y el build de la imagen, pasándole la ruta del rootfs como argumento.

El módulo hace dos cosas dentro del chroot: instala los paquetes gráficos y habilita GDM3 con systemctl.

```bash
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y \
        xorg \
        gnome-core \
        gdm3
"

chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    systemctl enable gdm3
"
```

`DEBIAN_FRONTEND=noninteractive` es importante para que `apt` no se quede esperando confirmación de teclado o locale dentro del chroot. Sin eso el script se cuelga en silencio y uno se queda mirando la pantalla sin entender qué pasó (me pasó).

### ¿Por qué `gnome-core` y no `gnome`?

El metapaquete `gnome` instala absolutamente todo: juegos, editores, aplicaciones de oficina, etc. Para un sistema educativo como borrerOS es demasiado y pesa varios gigas extra. `gnome-core` instala solo lo esencial: el escritorio, el gestor de archivos Nautilus y una terminal. Es suficiente para lo que necesitamos.

---

## 3. El tamaño de la imagen (`scripts/build_image.sh`)

GNOME necesita espacio. La imagen original era de 4 GB y con todo el entorno gráfico eso no alcanza.

Se cambió esta línea en `build_image.sh`:

```bash
# Antes
IMG_SIZE_MB=4000

# Ahora
IMG_SIZE_MB=10000
```

10 GB es suficiente con margen para el sistema base, el kernel, GNOME y los archivos del proyecto.

---

## Orden de ejecución actualizado

```bash
1. sudo ./scripts/setup_host.sh
2. ./kernel/compile_kernel.sh                                  ← recompilar con el nuevo .config
3. sudo ./scripts/bootstrap_base.sh
4. sudo ./scripts/modules/install_gnome.sh rootfs             ← módulo GNOME
5. sudo chroot rootfs passwd root                             ← setear contraseña de root
6. sudo ./scripts/build_image.sh
7. ./run_qemu.sh
```
