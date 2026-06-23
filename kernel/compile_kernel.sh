#!/bin/bash
set -e

KERNEL_VERSION="6.12.35"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KERNEL_DIR="${SCRIPT_DIR}/linux-${KERNEL_VERSION}"
CONFIG_FILE="${SCRIPT_DIR}/kernel.config"
NPROC="$(nproc)"

echo "=== BorrerOS - Compilación del Kernel ${KERNEL_VERSION} ==="

# Descargar el kernel si no existe
if [ ! -f "${SCRIPT_DIR}/linux-${KERNEL_VERSION}.tar.xz" ]; then
    echo "[1/4] Descargando kernel ${KERNEL_VERSION}..."
    wget -P "$SCRIPT_DIR" "$KERNEL_URL"
else
    echo "[1/4] Tarball ya existe, saltando descarga."
fi

# Descomprimir si no existe el directorio
if [ ! -d "$KERNEL_DIR" ]; then
    echo "[2/4] Descomprimiendo..."
    tar xf "${SCRIPT_DIR}/linux-${KERNEL_VERSION}.tar.xz" -C "$SCRIPT_DIR"
else
    echo "[2/4] Directorio ya existe, saltando descompresión."
fi

# Aplicar configuración
echo "[3/4] Aplicando configuración del kernel..."
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "${KERNEL_DIR}/.config"
    make -C "$KERNEL_DIR" olddefconfig
else
    echo "No se encontró kernel.config, usando defconfig."
    make -C "$KERNEL_DIR" defconfig
fi

# Compilar
echo "[4/4] Compilando con ${NPROC} núcleos..."
make -C "$KERNEL_DIR" -j"$NPROC"

echo ""
echo "=== Kernel compilado exitosamente ==="
echo "Binario: ${KERNEL_DIR}/arch/x86/boot/bzImage"
