#!/bin/bash

# Script para levantar la máquina virtual kvm y establecer las reglas iptables.
# Script creado por Francisco José Romero Morillo.

#Levantamos la máquina virtual kvm
virsh create /home/francisco/debian.xml &>/dev/null
sleep 2

#Paramos postgres en el contenedor:
lxc-attach -n postgres-lxc -- systemctl stop postgresql
sleep 2

#Desmontamos el volumen:
lxc-attach -n postgres-lxc -- umount /mnt
sleep 1

#Redimensionamos el volumen:
lvextend -L2G /dev/vg-inferno/lxc-volumen1g

#Asociamos el volumen a la máquina kvm:
virsh attach-disk debian9 --source /dev/vg-inferno/lxc-volumen1g --target vda &>/dev/null

#Montamos el volumen en la máquina kvm:
ssh -i ~/.ssh/id_rsa root@192.168.1.163 mount /dev/vda /mnt

#Reiniciamos postgresql en la máquina kvm:
ssh -i ~/.ssh/id_rsa root@192.168.1.163 systemctl restart postgresql

#Obtenemos la dirección ip del contenedor
iplxc=`lxc-info -n postgres-lxc | grep IP | sed 's/\s\+/,/g' | cut -d "," -f2`

#Cambiamos las reglas iptables:
iptables -t nat -D PREROUTING -p tcp --dport 5432 -j DNAT --to-destination $iplxc:5432
iptables -t nat -A PREROUTING -p tcp --dport 5432 -j DNAT --to 192.168.1.163:5432

