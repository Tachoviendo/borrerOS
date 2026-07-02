3. Cómo Abrir el Menú
=====================

El menú se abre **automáticamente** al iniciar sesión. No necesitás
hacer nada extra. Si por alguna razón no apareció, podés ejecutarlo
manualmente:

.. code-block:: bash

   /miniso/bin/menu_principal.sh

----

4. Qué Hace Cada Opción
========================

El menú varía según el usuario logueado. Las opciones en **rojo** son
exclusivas de ``adminso`` y no están disponibles para otros roles.

.. list-table::
   :header-rows: 1
   :widths: 10 35 55

   * - Opción
     - Nombre
     - Descripción
   * - ``[1]``
     - Ver información del sistema
     - Muestra datos del sistema: hostname, kernel, uptime, IP.
   * - ``[2]``
     - Ver procesos activos
     - Lista los procesos en ejecución (equivalente a ``ps aux``).
   * - ``[3]``
     - Ver uso de memoria
     - Muestra el uso actual de RAM y swap (``free -h``).
   * - ``[4]``
     - Ver uso de disco
     - Muestra el espacio disponible en los discos (``df -h``).
   * - ``[5]``
     - Crear archivo personal
     - Permite crear un archivo de texto en tu directorio home.
   * - ``[6]``
     - Ver logs del sistema
     - Muestra el contenido de ``/miniso/logs/reporte_sistema.log``.
   * - ``[7]``
     - Gestión de I/O
     - Gestión de dispositivos de entrada/salida (audio, impresión).
       Ver sección de I/O para más detalle.
   * - ``[8]``
     - Backup/Reporte *(Solo ADMIN)*
     - Genera un reporte del sistema y un backup comprimido.
       Solo disponible para ``adminso``.
   * - ``[9]``
     - Apagar *(Solo ADMIN)*
     - Apaga el sistema de forma segura.
       Solo disponible para ``adminso``.
   * - ``[0]``
     - Cerrar sesión
     - Cierra la sesión actual y vuelve al login.
