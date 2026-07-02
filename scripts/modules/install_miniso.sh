#!/bin/bash
# =============================================================================
# BorrerOS - Módulo de Instalación del MiniSO
# UCU Campus Salto - Sistemas Operativos 2026
#
# Uso: sudo ./scripts/modules/install_miniso.sh <ruta_rootfs>
# Ejemplo: sudo ./scripts/modules/install_miniso.sh rootfs
# =============================================================================

set -e

ROOTFS_DIR="${1:-rootfs}"
SCRIPT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

# --- Colores ---
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
ROJO='\033[0;31m'
RESET='\033[0m'

ok()   { echo -e "${VERDE}  ✓ $1${RESET}"; }
info() { echo -e "${AMARILLO}  → $1${RESET}"; }
err()  { echo -e "${ROJO}  ✗ $1${RESET}"; exit 1; }

echo ""
echo "================================================="
echo "  BorrerOS - Instalación del MiniSO"
echo "================================================="
echo ""

if [ "$(id -u)" -ne 0 ]; then
    err "Este script debe ejecutarse con sudo."
fi

if [ ! -d "${ROOTFS_DIR}/bin" ]; then
    err "No se encontró rootfs en '${ROOTFS_DIR}'. Ejecutá bootstrap_base.sh primero."
fi

# =============================================================================
# PASO 1 - Estructura de directorios /miniso
# =============================================================================
echo "[1/6] Creando estructura de directorios /miniso..."

for dir in bin scripts logs backups docs users tmp; do
    mkdir -p "${ROOTFS_DIR}/miniso/${dir}"
    ok "Creado /miniso/${dir}"
done

# =============================================================================
# PASO 2 - Copiar scripts
# =============================================================================
echo ""
echo "[2/6] Copiando scripts al rootfs..."

# Copiar miniso/bin y miniso/scripts desde el repo
if [ -d "${SCRIPT_DIR}/miniso/bin" ]; then
    cp -r "${SCRIPT_DIR}/miniso/bin/"* "${ROOTFS_DIR}/miniso/bin/"
    ok "Scripts de bin copiados"
else
    err "No se encontró ${SCRIPT_DIR}/miniso/bin. ¿Ejecutaste install_miniso.sh desde la raíz del repo?"
fi

if [ -d "${SCRIPT_DIR}/miniso/scripts" ]; then
    cp -r "${SCRIPT_DIR}/miniso/scripts/"* "${ROOTFS_DIR}/miniso/scripts/"
    ok "Scripts del sistema copiados"
fi

# Hacer ejecutables todos los scripts
chmod +x "${ROOTFS_DIR}/miniso/bin/"*.sh
chmod +x "${ROOTFS_DIR}/miniso/scripts/"*.sh
ok "Permisos de ejecución aplicados"

# =============================================================================
# PASO 3 - Usuarios, grupos y contraseñas
# =============================================================================
echo ""
echo "[3/6] Configurando usuarios y grupos..."

chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin:/usr/bin

    apt-get install -y sudo 2>/dev/null

    # Crear grupos
    groupadd -f adminso
    groupadd -f estudiantes
    groupadd -f invitados
    echo '  Grupos creados: adminso, estudiantes, invitados'

    # Crear usuario adminso (administrador)
    if ! id adminso &>/dev/null; then
        useradd -m -s /bin/bash -G adminso,sudo adminso
        echo 'adminso:Admin2026!' | chpasswd
        echo '  Usuario adminso creado (pass: Admin2026!)'
    fi

    # Crear usuario estudiante
    if ! id estudiante &>/dev/null; then
        useradd -m -s /bin/bash -G estudiantes estudiante
        echo 'estudiante:Est2026!' | chpasswd
        echo '  Usuario estudiante creado (pass: Est2026!)'
    fi

    # Crear usuario invitado
    if ! id invitado &>/dev/null; then
        useradd -m -s /bin/bash -G invitados invitado
        echo 'invitado:Inv2026!' | chpasswd
        echo '  Usuario invitado creado (pass: Inv2026!)'
    fi
"
ok "Usuarios y grupos configurados"

# =============================================================================
# PASO 3.5 - Forzar visibilidad de usuarios en GDM (AccountsService)
# =============================================================================
echo ""
echo "[3.5/6] Registrando usuarios en AccountsService para que aparezcan en GDM..."

chroot "$ROOTFS_DIR" /bin/bash -c "
    mkdir -p /var/lib/AccountsService/users
    chmod 0700 /var/lib/AccountsService/users

    for u in adminso estudiante invitado; do
        cat > /var/lib/AccountsService/users/\$u <<EOF
[User]
Language=
XSession=
SystemAccount=false
EOF
        chown root:root /var/lib/AccountsService/users/\$u
        chmod 0644 /var/lib/AccountsService/users/\$u
    done
"
ok "Usuarios registrados en AccountsService (SystemAccount=false)"

# =============================================================================
# PASO 4 - Permisos de directorios
# =============================================================================
echo ""
echo "[4/6] Aplicando permisos diferenciados..."

chroot "$ROOTFS_DIR" /bin/bash -c "
    # /miniso/bin     - todos pueden ejecutar, solo adminso modifica
    chown -R adminso:adminso /miniso/bin
    chmod 755 /miniso/bin
    chmod 755 /miniso/bin/*.sh

    # /miniso/scripts - solo adminso modifica, todos ejecutan
    chown -R adminso:adminso /miniso/scripts
    chmod 755 /miniso/scripts
    chmod 755 /miniso/scripts/*.sh

    # /miniso/logs    - escritura controlada (adminso y estudiantes)
    chown -R adminso:estudiantes /miniso/logs
    chmod 750 /miniso/logs

    # /miniso/backups - solo administrador
    chown -R adminso:adminso /miniso/backups
    chmod 700 /miniso/backups

    # /miniso/users   - acceso para usuarios comunes
    chown -R root:estudiantes /miniso/users
    chmod 775 /miniso/users

    # /miniso/tmp     - todos pueden escribir
    chmod 1777 /miniso/tmp

    # /miniso/docs    - lectura para todos
    chmod 755 /miniso/docs

    echo '  Permisos aplicados correctamente'
"
ok "Permisos diferenciados aplicados"

# =============================================================================
# PASO 5 - Configurar .bashrc para lanzar el menú automáticamente
# =============================================================================
echo ""
echo "[5/6] Configurando inicio de sesión automático al menú..."

# Función que agrega el lanzador del menú al .bashrc del usuario
configurar_bashrc() {
    local usuario="$1"
    local home_dir="${ROOTFS_DIR}/home/${usuario}"

    if [ ! -d "$home_dir" ]; then
        mkdir -p "$home_dir"
    fi

    # Agregar al .bashrc solo si no está ya configurado
    if ! grep -q "menu_principal" "${home_dir}/.bashrc" 2>/dev/null; then
        cat >> "${home_dir}/.bashrc" << 'BASHRC_EOF'

# BorrerOS - Lanzar menú principal al iniciar sesión
if [ -f /miniso/bin/menu_principal.sh ]; then
    bash /miniso/bin/menu_principal.sh
    # Al salir del menú, cierra la sesión
    exit 0
fi
BASHRC_EOF
    fi
}

configurar_bashrc "adminso"
configurar_bashrc "estudiante"
configurar_bashrc "invitado"
ok ".bashrc configurado para los 3 usuarios"

# Dar permiso de sudo a adminso para shutdown (necesario para opción apagar)
chroot "$ROOTFS_DIR" /bin/bash -c "
    echo 'adminso ALL=(ALL) NOPASSWD: /sbin/shutdown, /usr/sbin/shutdown' \
        > /etc/sudoers.d/borreros
    chmod 440 /etc/sudoers.d/borreros
    echo '  sudo configurado para adminso'
"
ok "sudoers configurado"

# =============================================================================
# PASO 6 - Crear archivos iniciales
# =============================================================================
echo ""
echo "[6/6] Creando archivos iniciales..."

# Crear log de accesos vacío con permisos correctos
chroot "$ROOTFS_DIR" /bin/bash -c "
    touch /miniso/logs/accesos.log
    chown adminso:estudiantes /miniso/logs/accesos.log
    chmod 664 /miniso/logs/accesos.log

    # Mensaje de bienvenida en docs
    cat > /miniso/docs/LEEME.txt << 'EOF'
BorrerOS - Mini distribución educativa Linux
UCU Campus Salto - Sistemas Operativos 2026

Usuarios del sistema:
  adminso    - Administrador (pass: Admin2026!)
  estudiante - Usuario común (pass: Est2026!)
  invitado   - Usuario restringido (pass: Inv2026!)

Al iniciar sesión se lanza automáticamente el menú principal.
Para salir del menú usá la opción 0.
EOF
    echo '  Archivos iniciales creados'
"
ok "Archivos iniciales creados"

# =============================================================================
# RESUMEN
# =============================================================================
echo ""
echo "================================================="
echo -e "${VERDE}  ✓ Instalación del MiniSO completada${RESET}"
echo "================================================="
echo ""
echo "  Estructura creada:"
echo "    /miniso/bin/      → menu_principal.sh"
echo "    /miniso/scripts/  → reporte_sistema.sh, backup_sistema.sh, gestion_io.sh"
echo "    /miniso/logs/     → accesos.log"
echo "    /miniso/backups/  → (solo adminso)"
echo "    /miniso/users/    → carpetas personales"
echo "    /miniso/docs/     → LEEME.txt"
echo ""
echo "  Usuarios:"
echo "    adminso    / Admin2026! → Administrador"
echo "    estudiante / Est2026!   → Usuario común"
echo "    invitado   / Inv2026!   → Usuario restringido"
echo ""
echo "  Siguiente paso:"
echo "    sudo ./scripts/build_image.sh"
echo ""
