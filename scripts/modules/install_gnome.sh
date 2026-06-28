#!/bin/bash
set -e

ROOTFS_DIR="$1"

if [ -z "$ROOTFS_DIR" ]; then
    echo "Error: Tenés que pasarle la ruta del rootfs como argumento."
    echo "Uso: sudo ./scripts/modules/install_gnome.sh rootfs"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

echo "=== BorrerOS - Módulo: GNOME ==="

echo "[1/2] Instalando xorg, gnome-core y gdm3 dentro del chroot..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y \
        xorg \
        gnome-core \
        gdm3
"

echo "[2/2] Habilitando GDM3 como display manager..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    systemctl enable gdm3
"

echo ""
echo "=== Módulo GNOME instalado exitosamente ==="
echo "Al bootear, el sistema arrancará directo en la pantalla de login de GDM3."
