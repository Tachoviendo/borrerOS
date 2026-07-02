5. Estructura de Carpetas
=========================

5.1 Repositorio del proyecto
-----------------------------

.. code-block:: text

   borrerOS/
   ├── build_borreros.sh          # Script maestro de construcción de la distro
   ├── flash_usb.sh               # Script para flashear la imagen en USB
   ├── run_qemu.sh                # Script de arranque de la VM en QEMU
   ├── borreros.img               # Imagen de disco generada (no se sube al repo)
   ├── kernel/
   │   └── compile_kernel.sh      # Compilación del kernel personalizado
   ├── rootfs/                    # Sistema de archivos raíz (generado por debootstrap)
   └── scripts/
       ├── bootstrap_base.sh      # Creación del sistema base con debootstrap
       ├── build_image.sh         # Empaquetado de rootfs en imagen .img
       ├── setup_host.sh          # Instalación de dependencias en el host WSL
       ├── update_borreros.sh     # Actualización incremental de la imagen
       └── modules/
           ├── install_audio.sh   # Módulo de I/O: Audio (PipeWire + ALSA)
           └── *(otros módulos)*

5.2 Estructura interna del MiniSO (``/miniso``)
------------------------------------------------

Dentro del sistema instalado, BorrerOS organiza sus recursos en el
directorio ``/miniso``:

.. code-block:: text

   /miniso/
   ├── bin/
   │   └── menu_principal.sh      # Script central del menú interactivo
   ├── scripts/
   │   ├── reporte_sistema.sh     # Generador de logs de rendimiento
   │   ├── gestion_io.sh          # Gestión de I/O (Bluetooth / Audio)
   │   └── backup_sistema.sh      # Herramienta de respaldos comprimidos
   ├── logs/
   │   └── reporte_sistema.log    # Persistencia de datos de monitoreo
   ├── backups/                   # Almacenamiento de respaldos .tar.gz
   └── users/                     # Directorio compartido entre usuarios
