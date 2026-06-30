#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOTFS_DIR="${PROJECT_DIR}/rootfs"

echo "Build BorrerOS"
echo ""

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

echo "[1/6] Compilando kernel..."
bash "${PROJECT_DIR}/kernel/compile_kernel.sh"

echo "":
echo "[2/6] Creando sistema base (debootstrap)..."
bash "${PROJECT_DIR}/scripts/bootstrap_base.sh"

echo ""
echo "[3/6] Instalando módulos..."
for modulo in "${PROJECT_DIR}/scripts/modules"/install_*.sh; do
    echo "  → $(basename "$modulo")"
    bash "$modulo" "$ROOTFS_DIR"
done

echo ""
echo "[4/6] Configurando contraseña de root..."
echo "Ingresá la contraseña para root:"
chroot "$ROOTFS_DIR" passwd root

echo ""
echo "[5/6] Construyendo imagen de disco..."
bash "${PROJECT_DIR}/scripts/build_image.sh"

echo ""
echo "[6/6] Listo."
echo ""
echo "Para probar BorrerOS:"
echo "  ./run_qemu.sh"
