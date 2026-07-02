7. Permisos Aplicados
=====================

BorrerOS implementa permisos octales estrictos sobre la estructura
``/miniso`` para garantizar el aislamiento entre roles de usuario.

7.1 Tabla de permisos por directorio
--------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 35 25 40

   * - Directorio
     - Propietario
     - Descripción
   * - ``/miniso/``
     - ``root:root``
     - Raíz del sistema educativo. Legible por todos, modificable solo por root.
   * - ``/miniso/bin/``
     - ``adminso:root``
     - Ejecutable por todos los usuarios, modificable solo por ``adminso``.
   * - ``/miniso/scripts/``
     - ``adminso:sudo``
     - Scripts de soporte. Solo accesibles por ``adminso`` y el grupo ``sudo``.
   * - ``/miniso/logs/``
     - ``adminso:estudiante``
     - Lectura y escritura para ``adminso`` y ``estudiante``. Auditoría compartida.
   * - ``/miniso/backups/``
     - ``adminso:adminso``
     - Acceso exclusivo para ``adminso``. Respaldos protegidos.
   * - ``/miniso/users/``
     - ``root:root``
     - Directorio compartido para intercambio de archivos entre usuarios.

7.2 Permisos del menú principal
---------------------------------

.. code-block:: bash

   # El binario del menú es ejecutable por todos pero solo adminso puede modificarlo
   chmod 755 /miniso/bin/menu_principal.sh
   chown adminso:root /miniso/bin/menu_principal.sh
