Descripción del Rol
===================

Mi responsabilidad dentro de BorrerOS es habilitar y documentar la
**conectividad de dispositivos Bluetooth** y su integración con el
**stack de audio**, de forma que los usuarios puedan conectar auriculares
o parlantes y controlar el volumen desde el sistema.

Estado de los issues
--------------------

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Issue
     - Estado
   * - Bluetooth (``bluez`` + ``bluetoothctl``)
     - ⚠️ Parcial — ``bzmenu`` sin paquete apt en Bookworm
   * - Audio — ALSA + PipeWire
     - ✅ Funcional
   * - PulseAudio
     - ✅ Cubierto por ``pipewire-pulse``

Orden de dependencia
--------------------

El audio debe instalarse **antes** de probar Bluetooth con audio,
porque ``pavucontrol`` necesita el servidor de audio activo para
mostrar los dispositivos Bluetooth conectados.
