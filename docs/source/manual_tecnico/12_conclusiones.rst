12. Conclusiones Técnicas
=========================

El desarrollo de BorrerOS permitió al equipo aplicar en la práctica los
conceptos fundamentales de administración de sistemas operativos vistos
durante la asignatura.

12.1 Aprendizajes del módulo de I/O
-------------------------------------

La implementación del módulo de **Bluetooth y Audio** evidenció varios
aspectos importantes de la administración de sistemas Linux modernos:

- **Los nombres de paquetes varían entre distribuciones y versiones.**
  Asumir que un paquete existe en todos los repos (como ``bluez-utils``)
  lleva a errores en producción. La verificación en ``packages.debian.org``
  antes de scripting es una práctica esencial.

- **PipeWire reemplaza a PulseAudio en Debian Bookworm.** El stack de audio
  moderno de Linux tiene varias capas (ALSA como driver de kernel,
  PipeWire como servidor, WirePlumber como gestor de sesión,
  ``pipewire-pulse`` como capa de compatibilidad). Entender cada capa
  es clave para diagnosticar problemas de audio.

- **``systemctl`` no funciona dentro de un chroot.** Habilitar servicios
  durante la construcción de la imagen requiere manipulación directa del
  sistema de archivos (symlinks en ``/etc/systemd/``), no llamadas a
  ``systemctl``.

- **WSL2 tiene limitaciones de virtualización.** La ausencia de KVM
  impone el uso de emulación por software (TCG), lo que reduce el
  rendimiento. Conocer las limitaciones del entorno de desarrollo es
  parte del trabajo de un administrador de sistemas.

12.2 Conclusión general del proyecto
--------------------------------------

El desarrollo de **BorrerOS** permitió comprender de manera práctica y profunda la estructura interna de un sistema operativo basado en Linux. A través de la selección, depuración y compilación manual del Kernel, junto con la estructuración del sistema de archivos desde la raíz, se logró consolidar un entorno funcional, minimalista y seguro que responde a los requerimientos técnicos planteados.

Este proyecto no solo demostró la importancia de la gestión precisa de usuarios, permisos y scripts de automatización para la experiencia del usuario final, sino que también evidenció la complejidad detrás del soporte de hardware y la configuración de servicios esenciales como el subsistema de audio. En conclusión, el desarrollo con éxito de BorrerOS representa una base sólida para el entendimiento de la administración de sistemas y la personalización avanzada de distribuciones GNU/Linux.
