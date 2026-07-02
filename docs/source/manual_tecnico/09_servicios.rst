9. Servicios Configurados
=========================

BorrerOS configura los siguientes servicios de systemd para que se
inicien automáticamente al arrancar el sistema.

9.1 Servicios de audio (Módulo I/O)
-------------------------------------

Habilitados como servicios de usuario (``systemd --user``) vía symlinks
en ``/etc/systemd/user/default.target.wants/``:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Servicio
     - Función
   * - ``pipewire.service``
     - Servidor principal de audio y video. Gestiona el hardware de
       sonido a través de ALSA.
   * - ``pipewire-pulse.service``
     - Capa de compatibilidad con PulseAudio. Permite que herramientas
       como ``pavucontrol`` funcionen sin cambios.
   * - ``wireplumber.service``
     - Gestor de sesión de PipeWire. Administra qué dispositivos están
       disponibles y cuál es la salida por defecto.

Verificación del estado de los servicios de audio:

.. code-block:: bash

   systemctl --user status pipewire pipewire-pulse wireplumber

Verificación del servidor de audio activo:

.. code-block:: bash

   pactl info | grep "Server Name"
   # Salida esperada: Server Name: PulseAudio (on PipeWire 0.3.65)

9.2 Servicios de sistema
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Servicio
     - Función
   * - ``bluetooth.service``
     - Stack Bluetooth del sistema (``bluez``). Gestiona el hardware
       Bluetooth y permite emparejar dispositivos.

Verificación del servicio Bluetooth:

.. code-block:: bash

   systemctl status bluetooth.service
