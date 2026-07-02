Issue 2 — ALSA + PipeWire (Audio)
===================================

.. note::
   Este es el issue principal del módulo. Con ``bzmenu`` bloqueado,
   **dejar andando el audio** es el objetivo central del ticket.

Criterios de aceptación
------------------------

- ☑ ``alsa-utils`` instalado
- ☑ ``pipewire`` + ``pipewire-alsa`` + ``pipewire-pulse`` + ``wireplumber`` instalados
- ☑ Servicios habilitados al arranque
- ☑ ``pavucontrol`` instalado y funcional
- ☑ Audio funciona — "Anda todo" 🎉

Instalación (dentro del chroot / script de módulo)
----------------------------------------------------

.. code-block:: bash

   apt install -y \
       alsa-utils \
       pipewire \
       pipewire-alsa \
       pipewire-pulse \
       wireplumber \
       dbus-user-session \
       rtkit \
       pavucontrol

Habilitación de servicios (via symlinks, sin systemctl)
--------------------------------------------------------

Dentro de un ``chroot`` no hay systemd corriendo, por lo que los
servicios se habilitan creando los symlinks directamente:

.. code-block:: bash

   mkdir -p /etc/systemd/user/default.target.wants
   for svc in pipewire pipewire-pulse wireplumber; do
       ln -sf /usr/lib/systemd/user/${svc}.service \
           /etc/systemd/user/default.target.wants/${svc}.service
   done

Verificación dentro de BorrerOS
---------------------------------

.. code-block:: bash

   pactl info | grep "Server Name"

Salida esperada:

.. code-block:: text

   Server Name: PulseAudio (on PipeWire 0.3.65)

Prueba de audio:

.. code-block:: bash

   speaker-test -c2 -twav -l1

Troubleshooting
----------------

Si no hay audio después del arranque:

.. code-block:: bash

   systemctl --user restart wireplumber pipewire pipewire-pulse
   pactl info | grep "Server Name"
