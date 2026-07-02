10. Capturas de Funcionamiento
==============================

.. note::
   Esta sección se completo con capturas de pantalla reales del
   sistema funcionando. Se agrego las imágenes en la carpeta
   ``_static/capturas/`` y referenciarlas con la directiva ``.. image::``.

10.1 Arranque de BorrerOS en QEMU
-----------------------------------

*(Agregar captura del arranque de la VM)*

.. code-block:: bash

   # Comando usado para arrancar
   cd ~/borrerOS && qemu-system-x86_64 -hda borreros.img -m 2G -smp 2 -accel tcg,thread=multi

10.2 Menú principal — Usuario ``estudiante``
---------------------------------------------

*(Agregar captura del menú interactivo logueado como estudiante)*

El menú muestra las opciones disponibles según el rol del usuario.
Las opciones exclusivas de ``adminso`` aparecen en rojo e inaccesibles
para roles menores.

10.3 Menú principal — Usuario ``adminso``
------------------------------------------

*(Agregar captura del menú completo con todas las opciones habilitadas)*

10.4 Módulo de I/O — Gestión de Audio
---------------------------------------

*(Agregar captura de ``pavucontrol`` o de la salida de ``pactl info``)*

Verificación del servidor de audio activo dentro de BorrerOS:

.. code-block:: text

   Server Name: PulseAudio (on PipeWire 0.3.65)

10.5 Problemas encontrados durante las pruebas
------------------------------------------------

*(Ver sección 11 para el detalle de errores y sus capturas)*

.. tip::
   Para agregar una imagen en Sphinx RST:

   .. code-block:: rst

      .. image:: ../_static/capturas/nombre_captura.png
         :alt: Descripción de la captura
         :width: 80%
         :align: center
