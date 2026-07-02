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

*(Completar con la reflexión del equipo sobre el proyecto en su conjunto)*

.. note::
   Completar esta sección con las conclusiones grupales antes de la entrega.
