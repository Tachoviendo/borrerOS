# Scripts básicos y necesarios

Estos scripts automatizan todo el proceso documentado en `firstSteps.md` y `hacer una .img.md`.

## Scripts disponibles

| Script | Descripción |
|--------|-------------|
| `kernel/compile_kernel.sh` | Compila el kernel Linux desde el código fuente |
| `scripts/bootstrap_base.sh` | Crea el sistema de archivos raíz (rootfs) con debootstrap |
| `scripts/build_image.sh` | Genera la imagen `.img` booteable con GRUB instalado |
| `run_qemu.sh` | Lanza la imagen en QEMU para pruebas |

---

## Orden de ejecución

### 1. Compilar el kernel

```bash
./kernel/compile_kernel.sh
```

Puede tardar varios minutos dependiendo del hardware.

---

### 2. Crear el sistema base

```bash
sudo ./scripts/bootstrap_base.sh
```

Al finalizar, configurar la contraseña de root manualmente:

```bash
sudo chroot /home/<usuario>/borrerOS/rootfs /bin/bash -c 'passwd root'
```

> **⚠️ Importante:** el script no instala `systemd` por defecto. Sin él, el kernel arranca pero no puede iniciar el sistema. Antes de continuar al paso 3, ejecutar:
>
> ```bash
> sudo chroot rootfs /bin/bash -c "apt-get update && apt-get install -y systemd systemd-sysv"
> ```

---

### 3. Construir la imagen

```bash
sudo ./scripts/build_image.sh
```

Crea `borreros.img` con partición ext4, copia el rootfs e instala GRUB.

---

### 4. Arrancar en QEMU

```bash
sudo ./run_qemu.sh
```

> **⚠️ Nota WSL:** el flag `-enable-kvm` requiere acceso a `/dev/kvm`. En WSL ejecutar siempre con `sudo`.

---

## Troubleshooting

### El kernel arranca pero el sistema no inicia

**Síntoma:**
```
run-init: can't execute '/sbin/init': No such file or directory
/bin/sh: 0: can't access tty: job control turned off
```

**Causa:** el rootfs no tiene `systemd` instalado. El kernel bootea bien pero no encuentra ningún proceso de init.

**Solución:**
```bash
# Remontar la imagen
sudo losetup -fP borreros.img
sudo mount /dev/loop0p1 /mnt/borreros

# Instalar systemd
sudo chroot /mnt/borreros /bin/bash -c "apt-get update && apt-get install -y systemd systemd-sysv"

# Desmontar y volver a correr
sudo umount /mnt/borreros
sudo losetup -d /dev/loop0
sudo ./run_qemu.sh
```

---

### Warning de fsck al final del bootstrap

**Síntoma:**
```
W: Couldn't identify type of root file system for fsck hook
```

**Causa:** advertencia esperada de debootstrap, no es un error. El script termina exitosamente igual. Continuar normalmente con el paso 3.

---

*Ignacio Silva / Emmanuel Aristov*
