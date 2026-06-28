#!/bin/bash
# =============================================================================
# BorrerOS - Gestión de Entrada/Salida
# UCU Campus Salto - Sistemas Operativos 2026
# =============================================================================

LOGS_DIR="/miniso/logs"
COLA_FILE="${LOGS_DIR}/cola_impresion.log"
USUARIO_ACTUAL=$(whoami)

registrar_log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] USUARIO=$USUARIO_ACTUAL ACCION=IO_$1" >> "${LOGS_DIR}/accesos.log"
}

mostrar_menu_io() {
    clear
    echo "================================================="
    echo "    BorrerOS - Gestión de I/O"
    echo "================================================="
    echo "  [1] Ver dispositivos de bloque (lsblk)"
    echo "  [2] Ver particiones y montajes"
    echo "  [3] Eventos del kernel (dmesg)"
    echo "  [4] Simular cola de impresión"
    echo "  [5] Ejecutar proceso en segundo plano"
    echo "  [6] Ver trabajos en background"
    echo "  [0] Volver al menú principal"
    echo "================================================="
    read -rp "  Opción: " op
    echo ""
    echo "$op"
}

ver_dispositivos() {
    registrar_log "VER_DISPOSITIVOS"
    echo "--- Dispositivos de Bloque ---"
    lsblk
    echo ""
    echo "--- Información de disco ---"
    df -h | grep "^/dev"
    echo ""
}

ver_particiones() {
    registrar_log "VER_PARTICIONES"
    echo "--- Particiones Montadas ---"
    mount | grep "^/dev"
    echo ""
    echo "--- Tabla de Particiones (fdisk) ---"
    fdisk -l 2>/dev/null | grep -E "^Disk|^/dev" || echo "(requiere permisos de root)"
    echo ""
}

ver_dmesg() {
    registrar_log "VER_DMESG"
    echo "--- Eventos del Kernel (últimas 20 líneas) ---"
    dmesg | tail -20 2>/dev/null || echo "(sin acceso a dmesg en este entorno)"
    echo ""
}

# Cola de impresión simulada
cola_impresion() {
    registrar_log "COLA_IMPRESION"
    mkdir -p "$LOGS_DIR"
    touch "$COLA_FILE"

    while true; do
        clear
        echo "================================================="
        echo "    BorrerOS - Cola de Impresión"
        echo "================================================="
        echo "  [1] Agregar trabajo a la cola"
        echo "  [2] Procesar siguiente trabajo"
        echo "  [3] Ver cola actual"
        echo "  [4] Limpiar cola"
        echo "  [0] Volver"
        echo "================================================="
        read -rp "  Opción: " op_cola
        echo ""

        case $op_cola in
            1)
                read -rp "Nombre del documento a imprimir: " doc
                read -rp "Número de copias: " copias
                TRABAJO="JOB_$(date '+%H%M%S') | DOC=$doc | COPIAS=$copias | USUARIO=$USUARIO_ACTUAL | ESTADO=EN_ESPERA"
                echo "$TRABAJO" >> "$COLA_FILE"
                echo "✓ Trabajo agregado a la cola."
                ;;
            2)
                if [ ! -s "$COLA_FILE" ]; then
                    echo "La cola está vacía."
                else
                    PRIMER_TRABAJO=$(head -1 "$COLA_FILE")
                    echo "Procesando: $PRIMER_TRABAJO"
                    echo -n "  Imprimiendo"
                    for i in 1 2 3; do
                        sleep 1
                        echo -n "."
                    done
                    echo ""
                    echo "✓ Trabajo completado."
                    # Eliminar primera línea
                    sed -i '1d' "$COLA_FILE"
                fi
                ;;
            3)
                echo "--- Cola de Impresión Actual ---"
                if [ -s "$COLA_FILE" ]; then
                    cat -n "$COLA_FILE"
                else
                    echo "(cola vacía)"
                fi
                echo ""
                ;;
            4)
                > "$COLA_FILE"
                echo "✓ Cola limpiada."
                ;;
            0) break ;;
            *) echo "Opción inválida." ;;
        esac
        echo ""
        read -rp "Presioná ENTER para continuar..." _
    done
}

proceso_background() {
    registrar_log "PROCESO_BACKGROUND"
    echo "--- Lanzar proceso en segundo plano ---"
    echo "Se lanzará un proceso de monitoreo por 30 segundos."
    echo ""

    # Proceso en background: escribe al log cada 5 segundos
    (
        for i in $(seq 1 6); do
            echo "[$(date '+%H:%M:%S')] Monitor tick $i - CPU: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.1f%%", usage}')" \
                >> "${LOGS_DIR}/monitor_bg.log"
            sleep 5
        done
    ) &

    BG_PID=$!
    echo "✓ Proceso lanzado con PID: $BG_PID"
    echo "  Escribiendo en: ${LOGS_DIR}/monitor_bg.log"
    echo "  Duración: 30 segundos"
    echo ""
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] USUARIO=$USUARIO_ACTUAL ACCION=BG_PROCESO PID=$BG_PID" >> "${LOGS_DIR}/accesos.log"
}

ver_jobs() {
    registrar_log "VER_JOBS"
    echo "--- Trabajos en Background (jobs) ---"
    jobs -l
    echo ""
    echo "--- Procesos del usuario actual ---"
    ps -u "$USUARIO_ACTUAL" --forest
    echo ""
}

# --- Loop del submenú I/O ---
while true; do
    opcion=$(mostrar_menu_io)

    case $opcion in
        1) ver_dispositivos ;;
        2) ver_particiones ;;
        3) ver_dmesg ;;
        4) cola_impresion ;;
        5) proceso_background ;;
        6) ver_jobs ;;
        0) exit 0 ;;
        *) echo "Opción inválida." ;;
    esac

    read -rp "Presioná ENTER para continuar..." _
done
