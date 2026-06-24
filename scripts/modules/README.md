# Módulos de BorrerOS

Acá van los scripts que agregan funcionalidad sobre el sistema base.

Cada módulo es independiente y se ejecuta **después** de `bootstrap_base.sh` y **antes** de `build_image.sh`.

## Cómo crear un módulo

1. Creá un archivo `install_<nombre>.sh` en esta carpeta.
2. El script recibe la ruta del rootfs como primer argumento (`$1`).
3. Usá `chroot` para instalar paquetes con apt.

Ejemplo mínimo:

```bash
#!/bin/bash
set -e
ROOTFS_DIR="$1"

echo "=== Instalando mi-modulo ==="
chroot "$ROOTFS_DIR" /bin/bash -c "
    export PATH=\$PATH:/usr/sbin
    export DEBIAN_FRONTEND=noninteractive
    apt update
    apt install -y mi-paquete
"
```

## Flujo completo

```
1. ./kernel/compile_kernel.sh
2. sudo ./scripts/bootstrap_base.sh
3. sudo ./scripts/modules/install_gnome.sh rootfs    ← módulos opcionales
4. sudo chroot rootfs passwd root
5. sudo ./scripts/build_image.sh
6. ./run_qemu.sh
```
