#!/bin/bash
# =============================================================================
# BorrerOS - Generador de Reporte del Sistema
# UCU Campus Salto - Sistemas Operativos 2026
# =============================================================================

LOGS_DIR="/miniso/logs"
LOG_FILE="${LOGS_DIR}/reporte_sistema.log"
USUARIO_ACTUAL=$(whoami)

# Verificar que el directorio de logs existe
mkdir -p "$LOGS_DIR"

echo ""
echo "=== Generando reporte del sistema... ==="
echo ""

# Escribir reporte
{
echo "============================================================"
echo " REPORTE DEL SISTEMA - BorrerOS"
echo "============================================================"
echo " Fecha y hora  : $(date '+%Y-%m-%d %H:%M:%S')"
echo " Usuario       : $USUARIO_ACTUAL"
echo " Hostname      : $(hostname)"
echo " Kernel        : $(uname -r)"
echo "============================================================"
echo ""
echo "--- USO DE MEMORIA ---"
free -h
echo ""
echo "--- USO DE DISCO ---"
df -h
echo ""
echo "--- TAMAÑO DE DIRECTORIOS /miniso ---"
du -sh /miniso/* 2>/dev/null
echo ""
echo "--- PROCESOS ACTIVOS (Top 10 por CPU) ---"
ps aux --sort=-%cpu | head -11
echo ""
echo "--- PARTICIONES Y DISPOSITIVOS ---"
lsblk
echo ""
echo "--- PARTICIONES MONTADAS ---"
mount | grep "^/dev"
echo ""
echo "--- ESTADO GENERAL ---"
echo " Uptime: $(uptime)"
echo " Carga : $(cat /proc/loadavg)"
echo ""
echo "============================================================"
echo " Fin del reporte"
echo "============================================================"
} | tee "$LOG_FILE"

echo ""
echo "Reporte guardado en: $LOG_FILE"
