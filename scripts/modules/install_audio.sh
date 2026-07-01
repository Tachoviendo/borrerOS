#!/bin/bash
set -e

ROOTFS_DIR="$1"

if [ -z "$ROOTFS_DIR" ]; then
    echo "Error: Tenés que pasarle la ruta del rootfs como argumento."
    echo "Uso: sudo ./scripts/modules/install_audio.sh rootfs"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

echo "=== BorrerOS - Módulo: Audio (ALSA + PipeWire) ==="

echo "[1/2] Instalando alsa-utils, pipewire y pavucontrol dentro del chroot..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y \
        alsa-utils \
        pipewire \
        pipewire-alsa \
        pipewire-pulse \
        wireplumber \
        pavucontrol
"

echo "[2/2] Habilitando servicios de PipeWire..."
chroot "$ROOTFS_DIR" /bin/bash -c "
    mkdir -p /etc/systemd/user/default.target.wants
    for svc in pipewire pipewire-pulse wireplumber; do
        ln -sf /usr/lib/systemd/user/\${svc}.service \
            /etc/systemd/user/default.target.wants/\${svc}.service
    done
"

echo ""
echo "=== Módulo de audio instalado exitosamente ==="
