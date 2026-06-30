#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_FILE="${PROJECT_DIR}/borreros.img"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con sudo."
    exit 1
fi

if [ ! -f "$IMG_FILE" ]; then
    echo "Error: No se encontró borreros.img. Ejecutá scripts/build_image.sh primero."
    exit 1
fi

echo "=== BorrerOS - Flashear a USB ==="
echo ""
echo "Dispositivos disponibles:"
lsblk -d -o NAME,SIZE,MODEL | grep -v loop
echo ""
read -rp "Ingresá el dispositivo USB (ej: sdb, sdc): " DISPOSITIVO

USB_DEV="/dev/${DISPOSITIVO}"

if [ ! -b "$USB_DEV" ]; then
    echo "Error: ${USB_DEV} no es un dispositivo válido."
    exit 1
fi

TAMANIO=$(lsblk -d -o SIZE --noheadings "$USB_DEV" | xargs)
echo ""
echo "ADVERTENCIA: Esto va a borrar TODO el contenido de ${USB_DEV} (${TAMANIO})."
read -rp "¿Estás seguro? [s/N]: " CONFIRMACION

if [ "$CONFIRMACION" != "s" ] && [ "$CONFIRMACION" != "S" ]; then
    echo "Cancelado."
    exit 0
fi

echo ""
echo "Escribiendo imagen en ${USB_DEV}..."
dd if="$IMG_FILE" of="$USB_DEV" bs=4M status=progress conv=fsync

echo ""
echo "BorrerOS flasheado exitosamente en ${USB_DEV}."
echo "Ya podés bootear desde el USB."
