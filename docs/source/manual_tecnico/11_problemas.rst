11. Problemas Encontrados y Soluciones
=======================================

Durante el desarrollo y pruebas de BorrerOS se encontraron los siguientes
problemas, todos resueltos.

11.1 ``bluez-utils`` no existe en Debian Bookworm
---------------------------------------------------

**Error:**

.. code-block:: text

   E: Package 'bluez-utils' has no installation candidate

**Causa:** El paquete ``bluez-utils`` no existe en los repositorios de
Debian Bookworm. El nombre correcto del paquete es simplemente ``bluez``.

**Solución:** Corregir el nombre del paquete en el script de instalación:

.. code-block:: bash

   #  Incorrecto
   apt install bluez-utils

   #  Correcto
   apt install bluez

----

11.2 ``bzmenu`` sin paquete ``apt`` disponible
-----------------------------------------------

**Error:**

.. code-block:: text

   E: Unable to locate package bzmenu

**Causa:** ``bzmenu`` no está empaquetado para los repositorios oficiales
de Debian Bookworm.

**Solución:** Utilizar ``bluetoothctl`` (incluido en ``bluez``) como
alternativa para gestionar dispositivos Bluetooth desde la terminal, sin
dependencias externas.

----

11.3 KVM no disponible bajo WSL2
----------------------------------

**Error:**

.. code-block:: text

   qemu-system-x86_64: -enable-kvm: accel layer "kvm" is not supported

**Causa:** WSL2 no expone la virtualización por hardware (KVM) al
sistema huésped. QEMU cae a emulación por software pura, que es
considerablemente más lenta.

**Solución:** Reemplazar ``-enable-kvm`` por ``-accel tcg,thread=multi``
y agregar ``-smp 2`` para habilitar multithreading en el emulador TCG:

.. code-block:: bash

   #  No funciona en WSL2
   qemu-system-x86_64 -hda borreros.img -m 2G -enable-kvm

   #  Funciona en WSL2
   qemu-system-x86_64 -hda borreros.img -m 2G -smp 2 -accel tcg,thread=multi

----

11.4 ``systemctl --global enable`` no funciona dentro de chroot
----------------------------------------------------------------

**Error:** El paso ``[2/2]`` del módulo de audio no habilitaba los
servicios porque dentro de un entorno ``chroot`` no hay un daemon de
systemd corriendo, por lo que ``systemctl`` no puede ejecutarse.

**Solución:** Crear los symlinks de habilitación directamente en el
sistema de archivos, sin llamar a ``systemctl``:

.. code-block:: bash

   mkdir -p /etc/systemd/user/default.target.wants
   for svc in pipewire pipewire-pulse wireplumber; do
       ln -sf /usr/lib/systemd/user/${svc}.service \
           /etc/systemd/user/default.target.wants/${svc}.service
   done

----

11.5 Ruta incorrecta de la imagen al lanzar QEMU desde MSYS2
--------------------------------------------------------------

**Error:**

.. code-block:: text

   Could not open '//wsl$/Ubuntu/home/TU_USUARIO/borrerOS/borreros.img':
   El sistema no puede encontrar la ruta especificada.

**Causa:** El usuario de MSYS2 (Windows) es distinto al usuario de WSL.
La ruta ``//wsl$/Ubuntu/home/TU_USUARIO`` tenía el usuario de Windows
en lugar del usuario real de WSL.

**Solución:** Correr QEMU directamente desde la terminal WSL, donde la
ruta ``~/borrerOS/borreros.img`` resuelve correctamente:

.. code-block:: bash

   cd ~/borrerOS && qemu-system-x86_64 -hda borreros.img -m 2G -smp 2 -accel tcg,thread=multi
