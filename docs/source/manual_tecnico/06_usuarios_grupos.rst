6. Usuarios y Grupos Creados
============================

BorrerOS implementa un modelo de **Control de Acceso AAA** (Identificación,
Autenticación y Autorización) mediante tres usuarios obligatorios con roles
diferenciados.

6.1 Usuarios del sistema
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 20 20 45

   * - Usuario
     - Rol
     - Shell
     - Descripción
   * - ``adminso``
     -  Administrador
     - ``/bin/bash``
     - Acceso total al sistema con privilegios ``sudo``. Puede ejecutar
       todas las opciones del menú, incluyendo backup y apagado.
   * - ``estudiante``
     -  Usuario común
     - ``/bin/bash``
     - Permisos estándar para tareas académicas. Acceso a las opciones
       de información, procesos, memoria, disco, archivos personales,
       logs y gestión de I/O.
   * - ``invitado``
     -  Usuario restringido
     - ``/bin/rbash``
     - Acceso mínimo al sistema. Solo puede ver información básica.
       No puede instalar paquetes ni modificar archivos del sistema.

6.2 Grupos
-----------

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Grupo
     - Propósito
   * - ``sudo``
     - Permisos de administración — solo ``adminso``
   * - ``audio``
     - Acceso a dispositivos de audio (``/dev/snd``)
   * - ``bluetooth``
     - Acceso al stack Bluetooth
