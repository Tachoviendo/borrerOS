# Setup en windows 

Para trabajar con el kernel en windows tenemos que hacer lo siguiente: 

1. Instalar wsl (Windows subsystem linux): 
  `wsl --install -d Ubuntu`
  Una vez instalado reiniciamos windows, acá ya instalamos el subsistema pero aún no descargamos ninguna distro, abrimos terminal y ejecutamos:
  `wsl.exe --install Ubuntu`
  Esto comenzará la instalación de la distro, probablemente se nos abra una ventana de bienvenida a wsl en windows, en la terminal nos va a pedir un usuario y contraseña, una vez
  introducimos dichas credenciales de nuestras preferencias deberíamos tener nuestro subsistema vivito y coleando.


2. Clonar el repo al raiz del wsl: 
  Probablemente en estos momentos te encuentres parado en `tuusuario@Tu-PC:/mnt/c/Users/tuusuario$`, queremos movernos a la carpeta
raíz de wsl y clonar el repositorio, para eso, ejecutamos: `cd ~/ && git clone https://github.com/Tachoviendo/borrerOS.git` una vez hecho esto nos movemos a la carpeta
borrerOS y checkeamos que todo se haya clonado bien: `cd borrerOS & ls`.

3. Ejecutar `setup_host.sh`: ahora nos movemos a la carpeta scripts y ejecutamos `setup_host.sh`, para eso ejecuta el siguiente comando: `cd scripts && sudo ./setup_host.sh`
obviamente la usar sudo nos va a pedir la contraseña, ingresamos la misma que pusimos cuando instalamos ubuntu (si te la olvidaste problema tuyo jajka), esto va a tardar unos minutos.
Si llegamos a `=== Dependencias instaladas ===` estamos en la gloria.

4. Instalar qemu: Tenemos dos opciones, la primera es instalarlo desde la web oficial con `MSYs2` https://www.qemu.org/download/#windows, pero primero te recomiendo probar lo siguiente en nuestra terminal de wsl, para ahorrarnos dolores de cabeza, probamos instalar directamente con: `sudo apt install qemu-system-x86`, una vez se instale checkeamos que este todo OK con `qemu-system-x86_64 --version`

4. Si esta todo ok, ahora pasamos a `scripts-basicos.md`, mucha suerte!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
