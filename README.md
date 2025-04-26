<!--Vagrant-Puppet-Wordpress--> 
<h1 align="center"> Vagrant-Puppet-Wordpress </h1>

>Desde la creación de la VM, instalación del stack 
necesario, hasta la generación de una plantilla inicial
de WordPress, todo el proceso ha sido automatizado para 
demostrar la eficiencia y la escalabilidad que estas tecnologías ofrecen.

>Este tipo de prácticas son esenciales para impulsar entornos DevOps, mejorar
los tiempos de despliegue y asegurar consistencia en la infraestructura.

>[!TIP]
>🔥 ¿Cómo se aplica IaaC en tu proyecto?
Vagrant → Define una máquina virtual de forma declarativa en un Vagrantfile → (Infraestructura declarada como código).
Puppet → Define configuraciones del sistema (instalación de Apache, PHP, MySQL, WordPress) como "manifiestos" → (Configuraciones codificadas y automatizadas).
VirtualBox → Actúa como motor de virtualización, gestionado automáticamente por Vagrant → (Infraestructura física virtualizada, controlada por código).
En conjunto:
La creación de la VM
La instalación del servidor web
La configuración del entorno WordPress
TODO se realiza sin intervención manual, solo ejecutando código o scripts = Infrastructure as Code (IaaC) puro y real.

## 🛠️ Aplicación de Infrastructure as Code (IaaC) en el Proyecto

Este proyecto demuestra la aplicación real de los principios de **Infrastructure as Code (IaaC)** para el aprovisionamiento automático de un entorno WordPress funcional sobre una máquina virtual.

### ✅ ¿Cómo se aplica IaaC?

- **Vagrant**  
  Define y gestiona una máquina virtual a través de un `Vagrantfile`, permitiendo la creación de entornos reproducibles de manera automatizada.

- **Puppet**  
  Utiliza manifiestos para declarar la configuración del servidor, instalar el stack necesario (Apache, PHP, MySQL) y aprovisionar automáticamente WordPress.

- **VirtualBox**  
  Proporciona el motor de virtualización gestionado de forma programática mediante Vagrant, eliminando la necesidad de configuraciones manuales.

### 🔥 Proceso Automatizado:

1. Creación y configuración automática de la máquina virtual.
2. Instalación automatizada de servicios necesarios (LAMP stack).
3. Aprovisionamiento de WordPress y despliegue de una plantilla inicial.

### 🧠 Resumen:

> Este proyecto es un **ejemplo práctico de IaaC**, donde toda la infraestructura y su configuración son definidas como código, asegurando:
> 
> - Consistencia en los entornos
> - Reducción de errores manuales
> - Aceleración en los tiempos de despliegue
> - Facilidad de escalado y mantenimiento

---

