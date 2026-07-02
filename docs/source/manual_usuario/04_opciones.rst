5. Cómo Generar Reportes
========================

Los reportes del sistema se generan desde la opción ``[8]`` del menú
(solo ``adminso``).

El reporte incluye:

- Uso de CPU y carga del sistema
- Uso de memoria RAM y swap
- Espacio disponible en disco
- Procesos activos al momento del reporte
- Fecha y hora de generación

El archivo se guarda automáticamente en:

.. code-block:: text

   /miniso/logs/reporte_sistema.log

Para verlo desde el menú, usá la opción ``[6] Ver logs del sistema``.

Para verlo directamente desde la terminal (solo ``adminso``):

.. code-block:: bash

   cat /miniso/logs/reporte_sistema.log

----

6. Cómo Ejecutar Backups
=========================

Los backups se generan desde la opción ``[8]`` del menú, disponible
únicamente para ``adminso``.

El sistema genera un archivo comprimido ``.tar.gz`` con el contenido
de los directorios importantes y lo guarda en:

.. code-block:: text

   /miniso/backups/

El nombre del archivo incluye la fecha y hora de generación para
identificarlo fácilmente.

.. warning::
   El directorio ``/miniso/backups/`` tiene permisos ``700`` —
   solo ``adminso`` puede acceder a los backups. Otros usuarios
   recibirán un error de permiso denegado si intentan acceder.

----

7. Cómo Apagar Correctamente el Sistema
========================================

Usá siempre la opción ``[9] Apagar`` del menú (solo ``adminso``).
Esto garantiza que el sistema se apague de forma limpia, sin corromper
el sistema de archivos.

.. danger::
   **No cerrar la ventana de QEMU directamente** sin apagar el sistema
   desde el menú. Hacerlo es equivalente a cortar la corriente y puede
   corromper la imagen ``borreros.img``.

Si por alguna razón necesitás apagar desde la terminal:

.. code-block:: bash

   sudo shutdown -h now

O desde fuera de la VM, podés enviar la señal de apagado a QEMU con
``Ctrl+A`` seguido de ``X`` si estás en modo ``-nographic``.
