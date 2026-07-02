3. Sistema Base Utilizado
=========================

BorrerOS fue construido sobre **Debian 12 (Bookworm)** como sistema base,
utilizando ``debootstrap`` para generar el sistema de archivos raíz (rootfs)
mínimo desde cero.

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Característica
     - Detalle
   * - Distribución base
     - Debian GNU/Linux 12 (Bookworm)
   * - Arquitectura
     - x86_64 (amd64)
   * - Gestor de paquetes
     - APT (``apt``)
   * - Repositorio
     - ``http://deb.debian.org/debian bookworm``
   * - Herramienta de construcción
     - ``debootstrap``
   * - Entorno de ejecución
     - CLI (sin entorno gráfico de escritorio)
   * - Init system
     - systemd

La elección de Debian Bookworm se debe a su estabilidad, amplia
disponibilidad de paquetes educativos y documentación extensa, lo que
facilita el aprendizaje de administración de sistemas.
