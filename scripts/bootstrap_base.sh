#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOTFS_DIR="${PROJECT_DIR}/rootfs"
KERNEL_DIR="${PROJECT_DIR}/kernel/linux-6.12.35"
KERNEL_VERSION="6.12.35"

echo "=== BorrerOS - Bootstrap del Sistema Base ==="

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

# Crear rootfs con debootstrap
if [ ! -d "$ROOTFS_DIR/bin" ]; then
    echo "[1/6] Creando rootfs con debootstrap..."
    debootstrap --arch=amd64 --variant=minbase bookworm "$ROOTFS_DIR" http://deb.debian.org/debian/
else
    echo "[1/6] rootfs ya existe, saltando debootstrap."
fi

# Copiar kernel y módulos
echo "[2/6] Instalando kernel y módulos..."
mkdir -p "${ROOTFS_DIR}/boot"
cp "${KERNEL_DIR}/arch/x86/boot/bzImage" "${ROOTFS_DIR}/boot/vmlinuz-${KERNEL_VERSION}"
cp "${KERNEL_DIR}/.config" "${ROOTFS_DIR}/boot/config-${KERNEL_VERSION}"
make -C "$KERNEL_DIR" INSTALL_MOD_PATH="$ROOTFS_DIR" modules_install

# Montar filesystems virtuales para chroot
echo "[3/6] Montando filesystems virtuales..."
mount --bind /proc "${ROOTFS_DIR}/proc"
mount --bind /sys "${ROOTFS_DIR}/sys"
mount --bind /dev "${ROOTFS_DIR}/dev"
mount --bind /dev/pts "${ROOTFS_DIR}/dev/pts"

# Configurar el sistema dentro del chroot
echo "[4/6] Configurando hostname y fstab..."
echo "borreros" > "${ROOTFS_DIR}/etc/hostname"
echo "/dev/sda1  /  ext4  defaults  0  1" > "${ROOTFS_DIR}/etc/fstab"

echo "[5/6] Instalando initramfs, GRUB, Entorno Gráfico, Audio y Bluetooth dentro del chroot..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    export DEBIAN_FRONTEND=noninteractive
    
    apt update
    apt install -y initramfs-tools grub-pc xorg rofi pulseaudio pavucontrol bluez bluez-utils bzmenu
    
    # Activar el servicio de Bluetooth para que arranque con BorrerOS
    systemctl enable bluetooth
    
    mkinitramfs -o /boot/initrd.img-${KERNEL_VERSION} ${KERNEL_VERSION}
"

# Desmontar filesystems virtuales
echo "[6/6] Desmontando filesystems virtuales..."
umount "${ROOTFS_DIR}/dev/pts"
umount "${ROOTFS_DIR}/dev"
umount "${ROOTFS_DIR}/sys"
umount -l "${ROOTFS_DIR}/proc"

echo ""
echo "=== Sistema base creado exitosamente ==="
echo "IMPORTANTE: Configurá la contraseña de root manualmente:"
echo "  sudo chroot ${ROOTFS_DIR} /bin/bash -c 'passwd root'"
