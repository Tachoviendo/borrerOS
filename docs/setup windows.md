# Setup en windows 

Para trabajar con el kernel en windows tenemos que hacer lo siguiente: 

1. Instalar wsl (Windows subsystem linux) 
`wsl --install -d Ubuntu`
Una vez instalado reiniciamos windows, acá ya instalamos el subsistema pero aún no descargamos ninguna distro, abrimos terminal y ejecutamos:
`wsl.exe --install Ubuntu`
Esto comenzará la instalación de la distro, probablemente se nos abra una ventana de bienvenida a wsl en windows, en la terminal nos va a pedir un usuario y contraseña, una vez
introducimos dichas credenciales de nuestras preferencias deberíamos tener nuestro subsistema vivito y coleando.


3. Clonar el repo al raiz del wsl 

`cd ~/ && git clone https://github.com/Tachoviendo/borrerOS.git`

3. Ejecutar `setup_host.sh`

4. Instalar qemu desde la web oficinal utilizando `MSYs2` https://www.qemu.org/download/#windows

4. y despues seguir en `scripts-basicos.md`
