#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_FILE="${PROJECT_DIR}/borreros.img"

if [ ! -f "$IMG_FILE" ]; then
    echo "Error: No se encontró borreros.img. Ejecutá scripts/build_image.sh primero."
    exit 1
fi

echo "=== Iniciando BorrerOS en QEMU ==="
qemu-system-x86_64 -hda "$IMG_FILE" -m 2G -enable-kvm
