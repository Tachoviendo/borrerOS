4. Herramienta de Virtualización
=================================

BorrerOS se ejecuta y prueba mediante **QEMU** (Quick Emulator), un
emulador y virtualizador de código abierto.

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Característica
     - Detalle
   * - Herramienta
     - QEMU (``qemu-system-x86_64``)
   * - Entorno host
     - Windows 11 con WSL2 (Ubuntu) o MSYS2 UCRT64
   * - Formato de imagen
     - ``.img`` (imagen de disco raw)
   * - RAM asignada
     - 2 GB (``-m 2G``)
   * - CPUs asignadas
     - 2 (``-smp 2``)
   * - Aceleración
     - TCG multihilo (``-accel tcg,thread=multi``)
   * - Modo de pantalla
     - Ventana gráfica (GTK)

Comando de arranque utilizado:

.. code-block:: bash

   qemu-system-x86_64 -hda borreros.img -m 2G -smp 2 -accel tcg,thread=multi

.. note::
   KVM no está disponible bajo WSL2, por lo que se utiliza el acelerador
   TCG en modo multihilo como alternativa. Esto produce mayor consumo de
   CPU pero permite ejecutar la VM sin salir del entorno de desarrollo.

El script ``run_qemu.sh`` en la raíz del repositorio automatiza el arranque
de la VM con los parámetros correctos.
