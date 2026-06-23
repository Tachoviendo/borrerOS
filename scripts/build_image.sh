#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOTFS_DIR="${PROJECT_DIR}/rootfs"
IMG_FILE="${PROJECT_DIR}/borreros.img"
IMG_SIZE_MB=4000
MOUNT_POINT="/mnt/borreros"

echo "=== BorrerOS - Construcción de Imagen de Disco ==="

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

if [ ! -d "${ROOTFS_DIR}/bin" ]; then
    echo "Error: No se encontró rootfs. Ejecutá bootstrap_base.sh primero."
    exit 1
fi

# Crear imagen vacía
echo "[1/7] Creando imagen de ${IMG_SIZE_MB}MB..."
dd if=/dev/zero of="$IMG_FILE" bs=1M count=$IMG_SIZE_MB status=progress

# Particionar con MBR
echo "[2/7] Creando tabla de particiones MBR..."
printf "o\nn\np\n1\n\n\na\nw\n" | fdisk "$IMG_FILE"

# Asociar a loop device
echo "[3/7] Asociando loop device..."
LOOP_DEV=$(losetup -fP --show "$IMG_FILE")
echo "    Usando ${LOOP_DEV}"

# Formatear partición
echo "[4/7] Formateando partición como ext4..."
mkfs.ext4 "${LOOP_DEV}p1"

# Montar y copiar rootfs
echo "[5/7] Copiando rootfs a la imagen..."
mkdir -p "$MOUNT_POINT"
mount "${LOOP_DEV}p1" "$MOUNT_POINT"
cp -a "${ROOTFS_DIR}"/* "$MOUNT_POINT"/

# Instalar GRUB
echo "[6/7] Instalando GRUB..."
mount --bind /proc "${MOUNT_POINT}/proc"
mount --bind /sys "${MOUNT_POINT}/sys"
mount --bind /dev "${MOUNT_POINT}/dev"
mount --bind /dev/pts "${MOUNT_POINT}/dev/pts"

chroot "$MOUNT_POINT" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    grub-install --target=i386-pc --boot-directory=/boot ${LOOP_DEV}
    update-grub
"

# Desmontar todo
echo "[7/7] Desmontando..."
umount "${MOUNT_POINT}/dev/pts"
umount "${MOUNT_POINT}/dev"
umount "${MOUNT_POINT}/sys"
umount -l "${MOUNT_POINT}/proc"
umount "$MOUNT_POINT"
losetup -d "$LOOP_DEV"

echo ""
echo "=== Imagen creada exitosamente ==="
echo "Archivo: ${IMG_FILE}"
echo "Para probar: ./run_qemu.sh"
