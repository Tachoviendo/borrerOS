#!/bin/bash
# =============================================================================
# BorrerOS - Backup del Sistema
# UCU Campus Salto - Sistemas Operativos 2026
# =============================================================================

BACKUPS_DIR="/miniso/backups"
LOGS_DIR="/miniso/logs"
LOG_FILE="${LOGS_DIR}/accesos.log"
USUARIO_ACTUAL=$(whoami)
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

# Verificar que solo adminso puede ejecutar esto
if ! groups "$USUARIO_ACTUAL" | grep -qw "adminso"; then
    echo "ERROR: Solo el administrador (adminso) puede ejecutar backups."
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] USUARIO=$USUARIO_ACTUAL ACCION=BACKUP_DENEGADO" >> "$LOG_FILE"
    exit 1
fi

mkdir -p "$BACKUPS_DIR"

echo ""
echo "=== BorrerOS - Sistema de Backup ==="
echo ""
echo "¿Qué querés respaldar?"
echo "  [1] Solo /miniso/scripts  (scripts del sistema)"
echo "  [2] Solo /miniso/logs     (registros)"
echo "  [3] /miniso completo      (todo el sistema)"
echo "  [0] Cancelar"
echo ""
read -rp "Opción: " opcion

case $opcion in
    1)
        ORIGEN="/miniso/scripts"
        NOMBRE="backup_scripts_${TIMESTAMP}.tar.gz"
        ;;
    2)
        ORIGEN="/miniso/logs"
        NOMBRE="backup_logs_${TIMESTAMP}.tar.gz"
        ;;
    3)
        ORIGEN="/miniso"
        NOMBRE="backup_completo_${TIMESTAMP}.tar.gz"
        ;;
    0)
        echo "Backup cancelado."
        exit 0
        ;;
    *)
        echo "Opción inválida. Backup cancelado."
        exit 1
        ;;
esac

DESTINO="${BACKUPS_DIR}/${NOMBRE}"

echo ""
echo "Origen  : $ORIGEN"
echo "Destino : $DESTINO"
echo ""
echo "Creando backup..."

if tar -czf "$DESTINO" "$ORIGEN" 2>/dev/null; then
    TAMANIO=$(du -sh "$DESTINO" | cut -f1)
    echo ""
    echo "✓ Backup creado exitosamente."
    echo "  Archivo : $DESTINO"
    echo "  Tamaño  : $TAMANIO"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] USUARIO=$USUARIO_ACTUAL ACCION=BACKUP_OK ARCHIVO=$DESTINO TAMANIO=$TAMANIO" >> "$LOG_FILE"
else
    echo ""
    echo "✗ Error al crear el backup."
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] USUARIO=$USUARIO_ACTUAL ACCION=BACKUP_ERROR" >> "$LOG_FILE"
    exit 1
fi

echo ""
echo "=== Backups existentes ==="
ls -lh "$BACKUPS_DIR"
echo ""
