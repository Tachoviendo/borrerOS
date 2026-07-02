Issue 1 — Bluetooth & bluez
============================

.. warning::
   Durante las pruebas se detectaron dos errores en este issue.
   Ver sección de errores más abajo.

Criterios de aceptación
------------------------

- ☑ ``bluez`` instalado y servicio activo
- ✗ ``bzmenu`` instalado *(bloqueado — no hay paquete apt en Bookworm)*
- ☑ ``rofi`` instalado con themes de adi1090x
- ☑ Poder conectar dispositivos Bluetooth con ``bluetoothctl``

Errores encontrados
--------------------

**Error 1: ``bluez-utils`` no existe en Debian Bookworm**

.. code-block:: text

   E: Package 'bluez-utils' has no installation candidate
   However the following packages replace it: bluez

**Solución:**

.. code-block:: bash

   # ❌ Incorrecto
   sudo apt install bluez-utils

   # ✅ Correcto
   sudo apt install bluez

**Error 2: ``bzmenu`` sin candidato de instalación**

.. code-block:: text

   E: Unable to locate package bzmenu

**Solución:** Usar ``bluetoothctl`` (incluido en ``bluez``) como alternativa.

Instalación correcta
---------------------

.. code-block:: bash

   sudo apt install -y bluez
   sudo systemctl enable --now bluetooth.service
   systemctl status bluetooth.service

Conectar un dispositivo con ``bluetoothctl``
---------------------------------------------

.. code-block:: bash

   bluetoothctl

Dentro del cliente:

.. code-block:: text

   [bluetooth]# power on
   [bluetooth]# agent on
   [bluetooth]# default-agent
   [bluetooth]# scan on
   # Cuando aparezca el dispositivo (AA:BB:CC:DD:EE:FF):
   [bluetooth]# pair AA:BB:CC:DD:EE:FF
   [bluetooth]# trust AA:BB:CC:DD:EE:FF
   [bluetooth]# connect AA:BB:CC:DD:EE:FF
   [bluetooth]# quit
