#!/bin/bash
set -e

ROOTFS_DIR="$1"

if [ -z "$ROOTFS_DIR" ]; then
    echo "Error: Tenés que pasarle la ruta del rootfs como argumento."
    echo "Uso: sudo ./scripts/modules/install_bluetooth.sh rootfs"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

echo "=== BorrerOS - Módulo: Bluetooth ==="

echo "[1/2] Instalando bluez, bluez-utils y bzmenu dentro del chroot..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y \
        bluez 
"

echo "[2/2] Habilitando servicio de bluetooth..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    systemctl enable bluetooth
"

echo ""
echo "=== Módulo Bluetooth instalado exitosamente ==="
