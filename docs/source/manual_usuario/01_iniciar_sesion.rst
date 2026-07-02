1. Cómo Iniciar Sesión
======================

Al arrancar BorrerOS verás una pantalla de login en la terminal.
Ingresá el usuario y la contraseña cuando el sistema lo solicite:

.. code-block:: text

   BorrerOS login: adminso
   Password: ********

Una vez autenticado, el sistema lanza automáticamente el **menú
interactivo** correspondiente a tu rol. No tenés que ejecutar ningún
comando adicional.

.. warning::
   Si intentás salir del menú con ``Ctrl+C`` o ``exit``, el sistema
   cerrará la sesión automáticamente. Esto es intencional — BorrerOS
   no permite acceso libre a la terminal convencional.

Para iniciar QEMU y acceder a BorrerOS, ejecutá desde WSL:

.. code-block:: bash

   cd ~/borrerOS && qemu-system-x86_64 -hda borreros.img -m 2G -smp 2 -accel tcg,thread=multi
