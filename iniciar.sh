#!/bin/bash

# Script bash para iniciar el contenedor lxc y establecer las reglas iptables.
# Script creado por Francisco José Romero Morillo.

#Levantamos el contenedor:
lxc-start -n postgres-lxc
sleep 2

#Asociamos el volumen:
lxc-device -n postgres-lxc add /dev/vg-inferno/lxc-volumen1g

#Paramos postgresql:
lxc-attach -n postgres-lxc -- systemctl stop postgresql
sleep 2

#Montamos el volumen:
lxc-attach -n postgres-lxc -- mount /dev/vg-inferno/lxc-volumen1g /mnt

#Iniciamos postgresql:
lxc-attach -n postgres-lxc -- systemctl start postgresql

#Activamos el enrutamiento:
echo "1" > /proc/sys/net/ipv4/ip_forward

#Obtenemos la dirección ip del contenedor
iplxc=`lxc-info -n postgres-lxc | grep IP | sed 's/\s\+/,/g' | cut -d "," -f2`

#Añadimos las reglas iptables:
iptables -t nat -A PREROUTING -p tcp --dport 5432 -j DNAT --to $iplxc:5432
iptables -t nat -A POSTROUTING -j MASQUERADE
