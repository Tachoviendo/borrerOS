#!/bin/bash
set -e

echo "=== BorrerOS - Instalación de Dependencias ==="

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

if command -v apt-get &>/dev/null; then
    echo "Detectado: Debian/Ubuntu (WSL2)"
    apt-get update
    apt-get install -y \
        build-essential bc fdisk flex bison libelf-dev dwarves \
        perl python3 cpio xmlto libssl-dev \
        debootstrap \
        qemu-system-x86 \
        grub-pc-bin grub-common dosfstools mtools \
        wget dos2unix
    echo ""
    echo "=== Dependencias instaladas ==="

elif command -v pacman &>/dev/null; then
    echo "Detectado: Arch Linux"
    pacman -S --needed base-devel bc flex bison libelf pahole \
        perl python cpio xmlto \
        debootstrap \
        qemu-full \
        grub dosfstools mtools \
        wget
    echo ""
    echo "=== Dependencias instaladas ==="
    echo "NOTA: Si debootstrap falla con 'Unknown architecture', corré:"
    echo "  sudo sed -i 's/CARCH=\$(pacman-conf Architecture)/CARCH=\$(pacman-conf Architecture | head -1)/' /usr/bin/debootstrap"

else
    echo "Error: No se detectó apt ni pacman. Distro no soportada."
    exit 1
fi
