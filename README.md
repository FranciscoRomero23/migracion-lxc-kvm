# migracion-lxc-kvm
Estos dos script los he utilizado para realizar la siguiente práctica:

# Migración en vivo entre LXC y KVM #

Realiza el proceso de migración de un servidor ofreciendo una base de datos postgreSQL entre un contenedor en LXC y una máquina virtual en KVM/libvirt, estando en todo momento la base de datos sobre un volumen lógico.

Pasos a realizar:

FASE 1:

* Crear un contenedor a partir de una plantilla conectado a un bridge interior.
* Limitar la RAM disponible en el contenedor a 500 MiB
* Crear un volumen de 1 GiB en formato xfs y conectarlo al contenedor.
* Instalar PostgreSQL en el contenedor y ubicar el directorio /var/lib/postgresql en el volumen lógico (muy importante comprobar permisos y propietarios)
* Poblar la base de datos.
* Crear una regla de iptables que redirija las peticiones al puerto 5432/tcp que se realicen desde fuera al contenedor para que la base de datos sea accesible desde el exterior.
* Comprobar el funcionamiento.

Para realizar esta fase, utilize el script "iniciar.sh".

FASE 2:

Comienza cuando aumente el uso de la RAM por encima del 90% de la RAM asignada al contenedor

* Crear una máquina virtual en KVM a partir de una imagen base qcow2 previamente existente conectada al bridge interior.
* Instalar y configurar apropiadamente PostgreSQL.
* Parar el servicio PostgreSQL en LXC.
* Desconectar el volumen de LXC, redimensionarlo a 2 GiB y conectarlo a KVM.
* Lanzar el servicio PostgreSQL en KVM verificando permisos y propietarios.
* Modificar la regla de iptables para que el servicio lo proporcione ahora la máquina KVM.
* Comprobar el funcionamiento.

Para realizar esta fase, utilize el script "migracion.sh".

FASE 3:

Comienza cuando el contenedor necesita utilizar más de 1 GiB de RAM

* Aumentar en vivo la RAM asignada a la máquina virtual a 2 GiB

