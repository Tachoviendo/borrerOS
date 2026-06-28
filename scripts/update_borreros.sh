#!/bin/bash
# =============================================================================
# BorrerOS - Script de Actualización desde GitHub
# UCU Campus Salto - Sistemas Operativos 2026
#
# Uso: sudo bash update_borreros.sh
#
# Qué hace:
#   1. Hace git pull de la rama main
#   2. Monta la imagen existente (borreros.img)
#   3. Aplica los scripts y permisos actualizados al rootfs montado
#   4. Desmonta todo limpiamente
#   No recompila el kernel ni recrea el rootfs.
# =============================================================================

set -e

# --- Configuración ---
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMG_FILE="${PROJECT_DIR}/borreros.img"
MOUNT_POINT="/mnt/borreros"
LOOP_DEV=""

# --- Colores ---
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
ROJO='\033[0;31m'
CIAN='\033[0;36m'
RESET='\033[0m'

ok()   { echo -e "${VERDE}  ✓ $1${RESET}"; }
info() { echo -e "${CIAN}  → $1${RESET}"; }
warn() { echo -e "${AMARILLO}  ! $1${RESET}"; }
err()  { echo -e "${ROJO}  ✗ ERROR: $1${RESET}"; cleanup; exit 1; }

# =============================================================================
# Limpieza en caso de error o salida
# =============================================================================
cleanup() {
    if [ -n "$LOOP_DEV" ]; then
        warn "Limpiando montajes..."
        umount "${MOUNT_POINT}/dev/pts" 2>/dev/null || true
        umount "${MOUNT_POINT}/dev"     2>/dev/null || true
        umount "${MOUNT_POINT}/sys"     2>/dev/null || true
        umount -l "${MOUNT_POINT}/proc" 2>/dev/null || true
        umount "$MOUNT_POINT"           2>/dev/null || true
        losetup -d "$LOOP_DEV"         2>/dev/null || true
        ok "Limpieza completada."
    fi
}
trap cleanup EXIT

# =============================================================================
# VERIFICACIONES PREVIAS
# =============================================================================
echo ""
echo -e "${CIAN}=================================================${RESET}"
echo -e "${CIAN}      BorrerOS - Actualización desde GitHub      ${RESET}"
echo -e "${CIAN}=================================================${RESET}"
echo ""

if [ "$(id -u)" -ne 0 ]; then
    err "Ejecutá con sudo: sudo bash update_borreros.sh"
fi

if [ ! -f "$IMG_FILE" ]; then
    err "No se encontró borreros.img en ${PROJECT_DIR}.\n  Primero construí la imagen con: sudo ./scripts/build_image.sh"
fi

if ! command -v git &>/dev/null; then
    err "git no está instalado. Instalalo con: sudo apt install git"
fi

# =============================================================================
# PASO 1 - Git pull
# =============================================================================
echo "[1/4] Descargando cambios desde GitHub..."
info "Directorio del proyecto: $PROJECT_DIR"

cd "$PROJECT_DIR"

# Guardar el commit actual para mostrar diff después
COMMIT_ANTES=$(git rev-parse --short HEAD 2>/dev/null || echo "desconocido")

# Verificar si hay cambios locales sin commitear
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    warn "Hay cambios locales sin commitear. Se aplicará stash temporalmente."
    git stash
    STASH_APLICADO=true
fi

git pull origin main 2>&1 | sed 's/^/  /'

COMMIT_DESPUES=$(git rev-parse --short HEAD 2>/dev/null || echo "desconocido")

if [ "$COMMIT_ANTES" = "$COMMIT_DESPUES" ]; then
    warn "Ya estás en el último commit ($COMMIT_ANTES). No hay cambios nuevos."
    warn "¿Querés aplicar los scripts igual? (por si cambiaste algo manualmente)"
    read -rp "  [s/n]: " forzar
    if [ "$forzar" != "s" ] && [ "$forzar" != "S" ]; then
        echo "  Cancelado. La imagen ya está al día."
        exit 0
    fi
else
    ok "Actualizado: $COMMIT_ANTES → $COMMIT_DESPUES"
    echo ""
    echo "  Cambios aplicados:"
    git log --oneline "${COMMIT_ANTES}..${COMMIT_DESPUES}" | sed 's/^/    /'
fi

# Restaurar stash si se aplicó
if [ "${STASH_APLICADO:-false}" = "true" ]; then
    git stash pop 2>/dev/null || warn "No se pudo restaurar el stash automáticamente."
fi

echo ""

# =============================================================================
# PASO 2 - Montar la imagen
# =============================================================================
echo "[2/4] Montando imagen borreros.img..."

mkdir -p "$MOUNT_POINT"

# Verificar si ya está montada
if mountpoint -q "$MOUNT_POINT" 2>/dev/null; then
    warn "La imagen ya estaba montada en $MOUNT_POINT. Reutilizando."
    LOOP_DEV=$(losetup -j "$IMG_FILE" | cut -d: -f1 | head -1)
else
    LOOP_DEV=$(losetup -fP --show "$IMG_FILE")
    ok "Loop device: $LOOP_DEV"
    mount "${LOOP_DEV}p1" "$MOUNT_POINT"
    ok "Imagen montada en $MOUNT_POINT"
fi

# Montar filesystems virtuales para chroot
mount --bind /proc "${MOUNT_POINT}/proc"
mount --bind /sys  "${MOUNT_POINT}/sys"
mount --bind /dev  "${MOUNT_POINT}/dev"
mount --bind /dev/pts "${MOUNT_POINT}/dev/pts"
ok "Filesystems virtuales montados"
echo ""

# =============================================================================
# PASO 3 - Aplicar cambios al rootfs montado
# =============================================================================
echo "[3/4] Aplicando cambios al sistema..."
echo ""

# --- 3a. Copiar scripts actualizados ---
info "Copiando scripts actualizados..."

MINISO_SRC="${PROJECT_DIR}/miniso"

if [ ! -d "${MINISO_SRC}/bin" ]; then
    err "No se encontró ${MINISO_SRC}/bin. ¿El zip de scripts está en el repo?"
fi

cp -v "${MINISO_SRC}/bin/"*.sh    "${MOUNT_POINT}/miniso/bin/"    2>/dev/null | sed 's/^/    /' || warn "Sin cambios en bin/"
cp -v "${MINISO_SRC}/scripts/"*.sh "${MOUNT_POINT}/miniso/scripts/" 2>/dev/null | sed 's/^/    /' || warn "Sin cambios en scripts/"

# Hacer ejecutables
chmod +x "${MOUNT_POINT}/miniso/bin/"*.sh    2>/dev/null || true
chmod +x "${MOUNT_POINT}/miniso/scripts/"*.sh 2>/dev/null || true
ok "Scripts copiados y marcados como ejecutables"

# --- 3b. Reaplicar permisos (por si alguien los rompió) ---
info "Reaplicando permisos..."

chroot "$MOUNT_POINT" /bin/bash -c "
    chown -R adminso:adminso    /miniso/bin      2>/dev/null
    chmod 755                   /miniso/bin
    chmod 755                   /miniso/bin/*.sh 2>/dev/null

    chown -R adminso:adminso    /miniso/scripts
    chmod 755                   /miniso/scripts
    chmod 755                   /miniso/scripts/*.sh 2>/dev/null

    chown -R adminso:estudiantes /miniso/logs
    chmod 750                    /miniso/logs

    chown -R adminso:adminso    /miniso/backups
    chmod 700                   /miniso/backups

    chown -R root:estudiantes   /miniso/users
    chmod 775                   /miniso/users

    chmod 1777                  /miniso/tmp
    chmod 755                   /miniso/docs
" 2>/dev/null
ok "Permisos reaplicados"

# --- 3c. Verificar usuarios (crearlos si no existen) ---
info "Verificando usuarios del sistema..."

chroot "$MOUNT_POINT" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin

    # Crear grupos si no existen
    groupadd -f adminso
    groupadd -f estudiantes
    groupadd -f invitados

    # adminso
    if ! id adminso &>/dev/null; then
        useradd -m -s /bin/bash -G adminso,sudo adminso
        echo 'adminso:Admin2026!' | chpasswd
        echo '    [NUEVO] adminso creado'
    else
        echo '    [OK] adminso ya existe'
    fi

    # estudiante
    if ! id estudiante &>/dev/null; then
        useradd -m -s /bin/bash -G estudiantes estudiante
        echo 'estudiante:Est2026!' | chpasswd
        echo '    [NUEVO] estudiante creado'
    else
        echo '    [OK] estudiante ya existe'
    fi

    # invitado
    if ! id invitado &>/dev/null; then
        useradd -m -s /bin/bash -G invitados invitado
        echo 'invitado:Inv2026!' | chpasswd
        echo '    [NUEVO] invitado creado'
    else
        echo '    [OK] invitado ya existe'
    fi

    # sudoers para adminso
    echo 'adminso ALL=(ALL) NOPASSWD: /sbin/shutdown, /usr/sbin/shutdown' \
        > /etc/sudoers.d/borreros
    chmod 440 /etc/sudoers.d/borreros
" 2>/dev/null
ok "Usuarios verificados"

# --- 3d. Actualizar .bashrc de cada usuario ---
info "Actualizando configuración de inicio de sesión..."

BASHRC_BLOQUE='
# BorrerOS - Lanzar menú principal al iniciar sesión
if [ -f /miniso/bin/menu_principal.sh ]; then
    bash /miniso/bin/menu_principal.sh
    exit 0
fi'

for usuario in adminso estudiante invitado; do
    BASHRC="${MOUNT_POINT}/home/${usuario}/.bashrc"
    mkdir -p "${MOUNT_POINT}/home/${usuario}"
    if ! grep -q "menu_principal" "$BASHRC" 2>/dev/null; then
        echo "$BASHRC_BLOQUE" >> "$BASHRC"
        echo "    [actualizado] .bashrc de $usuario"
    else
        echo "    [ok] .bashrc de $usuario ya configurado"
    fi
done
ok ".bashrc verificados"

echo ""

# =============================================================================
# PASO 4 - Desmontar
# =============================================================================
echo "[4/4] Desmontando imagen..."

umount "${MOUNT_POINT}/dev/pts"
umount "${MOUNT_POINT}/dev"
umount "${MOUNT_POINT}/sys"
umount -l "${MOUNT_POINT}/proc"
umount "$MOUNT_POINT"
losetup -d "$LOOP_DEV"

# Limpiar la variable para que el trap no intente desmontar de nuevo
LOOP_DEV=""

ok "Imagen desmontada limpiamente"

# =============================================================================
# RESUMEN
# =============================================================================
echo ""
echo -e "${CIAN}=================================================${RESET}"
echo -e "${VERDE}  ✓ BorrerOS actualizado correctamente${RESET}"
echo -e "${CIAN}=================================================${RESET}"
echo ""
echo "  Versión aplicada : $COMMIT_DESPUES"
echo "  Imagen           : $IMG_FILE"
echo ""
echo "  Para probar los cambios:"
echo "    sudo ./run_qemu.sh"
echo ""
