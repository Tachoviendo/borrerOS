8. Scripts Implementados
========================

8.1 Scripts de construcción (host)
------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Script
     - Función
   * - ``build_borreros.sh``
     - Script maestro. Ejecuta los 6 pasos de construcción en orden:
       kernel, debootstrap, módulos, contraseña root, imagen de disco.
   * - ``scripts/bootstrap_base.sh``
     - Genera el sistema base mínimo con ``debootstrap`` sobre Debian Bookworm.
   * - ``scripts/build_image.sh``
     - Empaqueta el ``rootfs/`` en una imagen de disco ``.img`` booteable.
   * - ``scripts/setup_host.sh``
     - Instala las dependencias necesarias en el host WSL para poder buildear.
   * - ``scripts/update_borreros.sh``
     - Actualización incremental de la imagen sin rebuildeár todo desde cero.
   * - ``run_qemu.sh``
     - Lanza BorrerOS en QEMU con los parámetros correctos.

8.2 Módulos de instalación (``scripts/modules/``)
--------------------------------------------------

Cada módulo es un script independiente ejecutado automáticamente durante
el build. Reciben el path del ``rootfs`` como argumento ``$1``.

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Script
     - Función
   * - ``install_audio.sh``
     - **Módulo de I/O.** Instala ``alsa-utils``, ``pipewire``,
       ``pipewire-alsa``, ``pipewire-pulse``, ``wireplumber`` y
       ``pavucontrol`` dentro del chroot. Habilita los servicios de
       PipeWire vía symlinks en ``/etc/systemd/user/``.

8.3 Scripts internos del MiniSO (``/miniso/scripts/``)
--------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Script
     - Función
   * - ``menu_principal.sh``
     - Menú interactivo central. Se lanza automáticamente al iniciar sesión
       y bloquea el acceso a la terminal convencional según el rol del usuario.
   * - ``reporte_sistema.sh``
     - Genera un reporte automático de rendimiento (CPU, RAM, disco) y lo
       persiste en ``/miniso/logs/reporte_sistema.log``.
   * - ``gestion_io.sh``
     - Gestión de dispositivos de Entrada/Salida. Incluye el simulador de
       cola de impresión y la interfaz de control de audio.
   * - ``backup_sistema.sh``
     - Genera respaldos comprimidos en formato ``.tar.gz`` en
       ``/miniso/backups/``. Solo accesible para ``adminso``.
