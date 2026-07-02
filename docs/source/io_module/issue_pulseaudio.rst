Issue 3 — PulseAudio
=====================

PulseAudio y PipeWire cumplen el mismo rol y no deben correr juntos.
En Debian Bookworm, ``pipewire-pulse`` ya actúa como PulseAudio de cara
a todas las aplicaciones del sistema.

Verificación
-------------

.. code-block:: bash

   pactl info | grep "Server Name"
   # Server Name: PulseAudio (on PipeWire 0.3.65)

Esto confirma que el criterio está cumplido sin instalar el daemon
clásico de PulseAudio. ``pavucontrol`` y cualquier otra herramienta
que espere PulseAudio funcionan correctamente con esta configuración.
