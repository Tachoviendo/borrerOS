#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOTFS_DIR="${PROJECT_DIR}/rootfs"
ISO_DIR="${PROJECT_DIR}/iso"
ISO_FILE="${PROJECT_DIR}/borreros.iso"
SQUASHFS_FILE="${PROJECT_DIR}/filesystem.squashfs"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

echo "=== BorrerOS - Generación de ISO ==="

echo "[1/4] Creando estructura del ISO..."
mkdir -p "${ISO_DIR}/live" "${ISO_DIR}/boot/grub"

echo "[2/4] Comprimiendo rootfs en SquashFS..."
rm -f "$SQUASHFS_FILE"
mksquashfs "$ROOTFS_DIR" "$SQUASHFS_FILE" -comp xz -noappend \
    -wildcards \
    -e "proc/*" \
    -e "sys/*" \
    -e "dev/*" \
    -e "run/*" \
    -e "root/*"

echo "[3/4] Copiando archivos al ISO..."
cp "$SQUASHFS_FILE" "${ISO_DIR}/live/"
cp "${ROOTFS_DIR}/boot/vmlinuz-6.12.35" "${ISO_DIR}/live/vmlinuz"
cp "${ROOTFS_DIR}/boot/initrd.img-6.12.35" "${ISO_DIR}/live/initrd.img"

cat > "${ISO_DIR}/boot/grub/grub.cfg" << 'EOF'
set timeout=5
set default=0

menuentry "BorrerOS" {
    linux /live/vmlinuz boot=live console=tty0 console=ttyS0,115200n8
    initrd /live/initrd.img
}
EOF

echo "[4/4] Generando ISO con grub-mkrescue..."
grub-mkrescue -o "$ISO_FILE" "${ISO_DIR}/"

echo ""
echo "=== ISO generada exitosamente ==="
echo "Archivo: ${ISO_FILE}"
echo "Para testear: qemu-system-x86_64 -cdrom borreros.iso -m 2G -enable-kvm"
