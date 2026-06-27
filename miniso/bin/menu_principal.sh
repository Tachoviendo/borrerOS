#!/bin/bash
# =============================================================================
# BorrerOS - Menú Principal
# UCU Campus Salto - Sistemas Operativos 2026
# =============================================================================

LOGS_DIR="/miniso/logs"
SCRIPTS_DIR="/miniso/scripts"
BACKUPS_DIR="/miniso/backups"
USUARIO_ACTUAL=$(whoami)
LOG_ACCESO="${LOGS_DIR}/accesos.log"

# --- Colores ---
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
CIAN='\033[0;36m'
BLANCO='\033[1;37m'
RESET='\033[0m'

# --- Determinar rol del usuario ---
determinar_rol() {
    if groups "$USUARIO_ACTUAL" | grep -qw "adminso"; then
        echo "ADMIN"
    elif groups "$USUARIO_ACTUAL" | grep -qw "estudiantes"; then
        echo "ESTUDIANTE"
    else
        echo "INVITADO"
    fi
}

ROL=$(determinar_rol)

# --- Registrar acceso ---
registrar_log() {
    local accion="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] USUARIO=$USUARIO_ACTUAL ROL=$ROL ACCION=$accion" >> "$LOG_ACCESO"
}

# --- Cabecera ---
mostrar_cabecera() {
    clear
    echo -e "${CIAN}=================================================${RESET}"
    echo -e "${BLANCO}          BorrerOS - Sistema Educativo          ${RESET}"
    echo -e "${CIAN}=================================================${RESET}"
    echo -e "  Usuario : ${VERDE}${USUARIO_ACTUAL}${RESET}"
    echo -e "  Rol     : ${AMARILLO}${ROL}${RESET}"
    echo -e "  Fecha   : $(date '+%d/%m/%Y %H:%M:%S')"
    echo -e "${CIAN}=================================================${RESET}"
}

# =============================================================================
# FUNCIONES DEL MENÚ
# =============================================================================

ver_info_sistema() {
    registrar_log "VER_INFO_SISTEMA"
    echo ""
    echo -e "${CIAN}--- Información del Sistema ---${RESET}"
    echo -e "Hostname    : $(hostname)"
    echo -e "Kernel      : $(uname -r)"
    echo -e "Arquitectura: $(uname -m)"
    echo -e "Uptime      : $(uptime -p 2>/dev/null || uptime)"
    echo -e "Fecha/Hora  : $(date)"
    echo -e "Usuario     : $USUARIO_ACTUAL ($(id))"
    echo ""
    read -rp "Presioná ENTER para continuar..." _
}

ver_procesos() {
    registrar_log "VER_PROCESOS"
    echo ""
    echo -e "${CIAN}--- Procesos Activos (Top 15) ---${RESET}"
    ps aux --sort=-%cpu | head -16
    echo ""
    if [ "$ROL" = "ADMIN" ]; then
        echo -e "${AMARILLO}[Admin] ¿Querés terminar algún proceso? (s/n):${RESET} "
        read -r respuesta
        if [ "$respuesta" = "s" ] || [ "$respuesta" = "S" ]; then
            read -rp "Ingresá el PID a terminar: " pid
            if kill "$pid" 2>/dev/null; then
                echo -e "${VERDE}Proceso $pid terminado.${RESET}"
                registrar_log "KILL_PID=$pid"
            else
                echo -e "${ROJO}No se pudo terminar el proceso $pid.${RESET}"
            fi
        fi
    fi
    read -rp "Presioná ENTER para continuar..." _
}

ver_memoria() {
    registrar_log "VER_MEMORIA"
    echo ""
    echo -e "${CIAN}--- Uso de Memoria ---${RESET}"
    free -h
    echo ""
    echo -e "${CIAN}--- Uso de Disco ---${RESET}"
    df -h
    echo ""
    echo -e "${CIAN}--- Dispositivos de Bloque ---${RESET}"
    lsblk
    echo ""
    read -rp "Presioná ENTER para continuar..." _
}

ver_disco() {
    registrar_log "VER_DISCO"
    echo ""
    echo -e "${CIAN}--- Espacio en Disco ---${RESET}"
    df -h
    echo ""
    echo -e "${CIAN}--- Uso por directorio en /miniso ---${RESET}"
    du -sh /miniso/* 2>/dev/null
    echo ""
    echo -e "${CIAN}--- Particiones montadas ---${RESET}"
    mount | grep -E "^/dev"
    echo ""
    read -rp "Presioná ENTER para continuar..." _
}

crear_archivo_personal() {
    registrar_log "CREAR_ARCHIVO"
    local dir_personal="/miniso/users/${USUARIO_ACTUAL}"
    mkdir -p "$dir_personal"

    echo ""
    echo -e "${CIAN}--- Crear Archivo Personal ---${RESET}"
    echo -e "Tus archivos se guardan en: ${VERDE}${dir_personal}${RESET}"
    echo ""
    read -rp "Nombre del archivo (sin ruta): " nombre
    if [ -z "$nombre" ]; then
        echo -e "${ROJO}Nombre vacío. Cancelado.${RESET}"
    else
        local ruta="${dir_personal}/${nombre}"
        echo -e "Escribí el contenido. Terminá con ${AMARILLO}CTRL+D${RESET}:"
        cat > "$ruta"
        echo ""
        echo -e "${VERDE}Archivo creado: ${ruta}${RESET}"
        registrar_log "ARCHIVO_CREADO=$ruta"
    fi
    echo ""
    read -rp "Presioná ENTER para continuar..." _
}

ver_logs() {
    registrar_log "VER_LOGS"
    echo ""
    echo -e "${CIAN}--- Logs del Sistema ---${RESET}"
    echo ""
    echo -e "${AMARILLO}[1] Últimos 20 accesos al menú${RESET}"
    echo -e "${AMARILLO}[2] Último reporte del sistema${RESET}"
    if [ "$ROL" = "ADMIN" ]; then
        echo -e "${AMARILLO}[3] Logs del kernel (dmesg)${RESET}"
        echo -e "${AMARILLO}[4] Logs de autenticación${RESET}"
    fi
    echo -e "${AMARILLO}[0] Volver${RESET}"
    echo ""
    read -rp "Opción: " op_log
    case $op_log in
        1)
            echo ""
            echo -e "${CIAN}--- Últimos accesos ---${RESET}"
            tail -20 "$LOG_ACCESO" 2>/dev/null || echo "Sin registros aún."
            ;;
        2)
            echo ""
            echo -e "${CIAN}--- Último reporte ---${RESET}"
            cat "${LOGS_DIR}/reporte_sistema.log" 2>/dev/null || echo "No hay reporte generado aún. Usá la opción 'Ejecutar backup / reporte'."
            ;;
        3)
            if [ "$ROL" = "ADMIN" ]; then
                echo ""
                echo -e "${CIAN}--- dmesg (últimas 30 líneas) ---${RESET}"
                dmesg | tail -30 2>/dev/null || echo "Sin acceso a dmesg."
            fi
            ;;
        4)
            if [ "$ROL" = "ADMIN" ]; then
                echo ""
                echo -e "${CIAN}--- Logs de autenticación ---${RESET}"
                tail -20 /var/log/auth.log 2>/dev/null || \
                journalctl -u ssh --no-pager -n 20 2>/dev/null || \
                echo "Log de auth no disponible."
            fi
            ;;
        0) return ;;
        *) echo -e "${ROJO}Opción inválida.${RESET}" ;;
    esac
    echo ""
    read -rp "Presioná ENTER para continuar..." _
}

ejecutar_backup() {
    if [ "$ROL" != "ADMIN" ]; then
        echo ""
        echo -e "${ROJO}Acceso denegado. Esta función es solo para administradores.${RESET}"
        registrar_log "INTENTO_BACKUP_DENEGADO"
        echo ""
        read -rp "Presioná ENTER para continuar..." _
        return
    fi
    registrar_log "EJECUTAR_BACKUP"
    echo ""
    echo -e "${CIAN}--- Menú de Backup / Reporte ---${RESET}"
    echo -e "${AMARILLO}[1] Generar reporte del sistema${RESET}"
    echo -e "${AMARILLO}[2] Ejecutar backup de /miniso${RESET}"
    echo -e "${AMARILLO}[3] Ver backups existentes${RESET}"
    echo -e "${AMARILLO}[0] Volver${RESET}"
    echo ""
    read -rp "Opción: " op_bk
    case $op_bk in
        1)
            bash "${SCRIPTS_DIR}/reporte_sistema.sh"
            ;;
        2)
            bash "${SCRIPTS_DIR}/backup_sistema.sh"
            ;;
        3)
            echo ""
            echo -e "${CIAN}--- Backups disponibles ---${RESET}"
            ls -lh "$BACKUPS_DIR" 2>/dev/null || echo "Sin backups."
            ;;
        0) return ;;
        *) echo -e "${ROJO}Opción inválida.${RESET}" ;;
    esac
    echo ""
    read -rp "Presioná ENTER para continuar..." _
}

gestion_io() {
    registrar_log "GESTION_IO"
    bash "${SCRIPTS_DIR}/gestion_io.sh"
    read -rp "Presioná ENTER para continuar..." _
}

apagar_sistema() {
    if [ "$ROL" != "ADMIN" ]; then
        echo ""
        echo -e "${ROJO}Acceso denegado. Solo el administrador puede apagar el sistema.${RESET}"
        registrar_log "INTENTO_APAGADO_DENEGADO"
        echo ""
        read -rp "Presioná ENTER para continuar..." _
        return
    fi
    echo ""
    echo -e "${AMARILLO}¿Qué querés hacer?${RESET}"
    echo -e "  [1] Apagar"
    echo -e "  [2] Reiniciar"
    echo -e "  [0] Cancelar"
    echo ""
    read -rp "Opción: " op_ap
    case $op_ap in
        1)
            registrar_log "APAGADO"
            echo -e "${VERDE}Apagando BorrerOS...${RESET}"
            sleep 1
            sudo shutdown -h now
            ;;
        2)
            registrar_log "REINICIO"
            echo -e "${VERDE}Reiniciando BorrerOS...${RESET}"
            sleep 1
            sudo shutdown -r now
            ;;
        0) return ;;
        *) echo -e "${ROJO}Opción inválida.${RESET}" ;;
    esac
}

# =============================================================================
# MENÚ PRINCIPAL - LOOP PRINCIPAL
# =============================================================================

registrar_log "INICIO_SESION"

while true; do
    mostrar_cabecera

    echo ""
    echo -e "  ${BLANCO}[1]${RESET} Ver información del sistema"
    echo -e "  ${BLANCO}[2]${RESET} Ver procesos activos"
    echo -e "  ${BLANCO}[3]${RESET} Ver uso de memoria"
    echo -e "  ${BLANCO}[4]${RESET} Ver uso de disco"
    echo -e "  ${BLANCO}[5]${RESET} Crear archivo personal"
    echo -e "  ${BLANCO}[6]${RESET} Ver logs del sistema"

    # Opciones restringidas según rol
    if [ "$ROL" = "ADMIN" ]; then
        echo -e "  ${VERDE}[7]${RESET} Ejecutar backup / reporte ${VERDE}[ADMIN]${RESET}"
        echo -e "  ${VERDE}[8]${RESET} Gestión de I/O ${VERDE}[ADMIN]${RESET}"
        echo -e "  ${VERDE}[9]${RESET} Apagar o reiniciar ${VERDE}[ADMIN]${RESET}"
    elif [ "$ROL" = "ESTUDIANTE" ]; then
        echo -e "  ${AMARILLO}[7]${RESET} Gestión de I/O"
        echo -e "  ${ROJO}[8] Backup/Reporte [Solo ADMIN]${RESET}"
        echo -e "  ${ROJO}[9] Apagar [Solo ADMIN]${RESET}"
    else
        echo -e "  ${ROJO}[7] Backup/Reporte [Solo ADMIN]${RESET}"
        echo -e "  ${ROJO}[8] I/O [Solo ESTUDIANTE o ADMIN]${RESET}"
        echo -e "  ${ROJO}[9] Apagar [Solo ADMIN]${RESET}"
    fi

    echo ""
    echo -e "  ${BLANCO}[0]${RESET} Cerrar sesión"
    echo ""
    echo -e "${CIAN}=================================================${RESET}"
    read -rp "  Seleccioná una opción: " opcion
    echo ""

    case $opcion in
        1) ver_info_sistema ;;
        2) ver_procesos ;;
        3) ver_memoria ;;
        4) ver_disco ;;
        5) crear_archivo_personal ;;
        6) ver_logs ;;
        7)
            if [ "$ROL" = "ADMIN" ]; then
                ejecutar_backup
            elif [ "$ROL" = "ESTUDIANTE" ]; then
                gestion_io
            else
                echo -e "${ROJO}Acceso denegado.${RESET}"
                registrar_log "ACCESO_DENEGADO_OP7"
                sleep 2
            fi
            ;;
        8)
            if [ "$ROL" = "ADMIN" ]; then
                gestion_io
            else
                echo -e "${ROJO}Acceso denegado.${RESET}"
                registrar_log "ACCESO_DENEGADO_OP8"
                sleep 2
            fi
            ;;
        9)
            apagar_sistema
            ;;
        0)
            registrar_log "CIERRE_SESION"
            echo -e "${VERDE}Hasta luego, ${USUARIO_ACTUAL}!${RESET}"
            sleep 1
            exit 0
            ;;
        *)
            echo -e "${ROJO}Opción inválida. Intentá de nuevo.${RESET}"
            sleep 1
            ;;
    esac
done
