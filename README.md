# BorrerOS 🐧

¡Bienvenido a **BorrerOS**, una mini-distribución educativa de Linux desarrollada como el **Trabajo Obligatorio Final (2026)** para la asignatura **Sistemas Operativos** en la **Universidad Católica del Uruguay (UCU) - Campus Salto**!

---

## 🏫 Origen e Inspiración

El nombre **BorrerOS** es un homenaje académico y afectuoso al director de la carrera de Informática del Campus Salto de la Universidad Católica del Uruguay (Armando Borrero). Este sistema operativo ha sido diseñado y construido desde cero sobre una base Linux CLI (Línea de Comandos) por un equipo de 4 estudiantes, bajo la supervisión y consigna del profesor **Jorge Martínez**.

El objetivo principal de este proyecto es integrar y demostrar de forma práctica los conceptos fundamentales de la administración de sistemas operativos: gestión de procesos, seguridad y permisos de archivos, automatización mediante scripting en Bash, manejo de ciclos de vida de usuarios y administración de Entrada/Salida (I/O).

---

## 🛠️ Características Principales

BorrerOS transforma un sistema base Linux en un entorno educativo restringido y controlado mediante la arquitectura `/miniso`. Sus características principales incluyen:

1. **Doble Formato de Despliegue:** Disponible tanto en formato de Máquina Virtual preconfigurada (`.ova`) como en una imagen **ISO booteable e instalable** con soporte para gestión de paquetes vía `apt`.
2. **Control de Acceso Estricto (AAA):** Implementación nativa de Identificación, Autenticación y Autorización basada en roles específicos mediante tres usuarios obligatorios:
   * 👑 `adminso`: Administrador del sistema con privilegios totales (`sudo`).
   * 🎓 `estudiante`: Usuario común con permisos estándar para tareas académicas.
   * 👥 `invitado`: Usuario ultra-restringido con acceso mínimo para pruebas.
3. **Estructura de Archivos Segura:** Creación del directorio aislado `/miniso/` con permisos octales estrictos y asignación segregada de propietarios y grupos:
   * `/miniso/bin/` — Contiene el binario del menú principal (ejecutable por todos, modificable solo por `adminso`).
   * `/miniso/scripts/` — Scripts de soporte del sistema (automatización restringida).
   * `/miniso/logs/` — Registros de auditoría y reportes dinámicos con escritura controlada.
   * `/miniso/backups/` — Almacenamiento seguro de respaldos en formato `.tar.gz` (exclusivo para `adminso`, permisos `700`).
   * `/miniso/users/` — Directorio compartido para el intercambio de archivos entre usuarios.
4. **Entorno de Consola Interactivo (Menú en Bash):** Al iniciar sesión, el sistema bloquea la terminal convencional y lanza automáticamente un menú interactivo adaptado al rol del usuario logueado, garantizando que nadie ejecute herramientas para las que no está autorizado.

---

## 📂 Estructura del Repositorio

El código fuente y la arquitectura de scripts se organizan de la siguiente manera:

```text
├── miniso/
│   ├── bin/
│   │   └── menu_principal.sh      # Script central interactivo Bash
│   ├── scripts/
│   │   ├── reporte_sistema.sh     # Generador automático de logs de rendimiento
│   │   ├── gestion_io.sh          # Simulador de cola de impresión (Gestión I/O)
│   │   └── backup_sistema.sh      # Herramienta de respaldos comprimidos
│   └── logs/
│       └── reporte_sistema.log    # Archivo de persistencia de datos de monitoreo
├── docs/
│   ├── Manual_Tecnico.pdf         # Documentación de arquitectura y configuración
│   └── Manual_Usuario.pdf         # Guía de uso y comandos del MiniSO
└── README.md                      # Este archivo informativo
```
## 👥 El equipo.
<img src="assets/cards/Ignacio_Silva_Card.png" width="300" alt="Ignacio Silva" align="center">
<img src="assets/cards/Lucas_Chiappini_Card.png" width="300" alt="Lucas Chiappini" align="center">
<img src="assets/cards/Nicolas_Dia_Card.png" width="300" alt="Nicolas Diaz" align="center">
<img src="assets/cards/Emmanuel_Aristov_Card.png" width="300" alt="Emmanuel Aristov" align="center">
