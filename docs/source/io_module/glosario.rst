Glosario
========

.. glossary::

   ALSA
      *Advanced Linux Sound Architecture.* Capa de bajo nivel del kernel
      Linux que interactúa directamente con el hardware de audio.

   PipeWire
      Servidor de audio moderno para Linux. Reemplaza a PulseAudio y JACK.
      Soporta audio Bluetooth de forma nativa via ``libspa-0.2-bluetooth``.

   pipewire-pulse
      Capa de compatibilidad que hace que PipeWire exponga la misma
      interfaz que PulseAudio. Permite usar ``pavucontrol`` sin cambios.

   WirePlumber
      Gestor de sesión de PipeWire. Administra qué dispositivos están
      disponibles y cuál es la salida de audio por defecto.

   pavucontrol
      *PulseAudio Volume Control.* Interfaz gráfica para gestionar
      volúmenes y dispositivos de audio. Funciona con PipeWire vía
      ``pipewire-pulse``.

   bluez
      Implementación oficial del stack Bluetooth para el kernel Linux.
      Incluye ``bluetoothctl`` para gestionar dispositivos desde la terminal.

   bluetoothctl
      Herramienta CLI incluida en ``bluez`` para emparejar, conectar y
      administrar dispositivos Bluetooth manualmente.

   A2DP
      *Advanced Audio Distribution Profile.* Perfil Bluetooth de alta
      calidad para reproducción de audio (sin micrófono).

   chroot
      Mecanismo de Linux que cambia el directorio raíz aparente de un
      proceso. Usado durante el build de BorrerOS para instalar paquetes
      dentro del ``rootfs`` sin arrancar el sistema completo.

   TCG
      *Tiny Code Generator.* Motor de emulación por software de QEMU,
      usado cuando KVM no está disponible (como en WSL2).
