# virt

## Virt-builder

Una manera rápida de crear discos de máquinas virtuales es con `virt-builder`, esta se descarga una plantilla y la customiza y crea un nueva máquina.

VM disponibles.

```bash  
virt-builder --list
```



Por defecto la plantilla se descara en `~/.cache/virt-builder/`  y los discos se generan como `.img` .

En el ejemplo muestro como genero un disco con ubuntu, en formato qcow2, pasword de root jupiter, escritorio xfce4, y actualizo.

```bash
virt-builder ubuntu-18.04 \
    --root-password password:jupiter \
    --format qcow2 -o /home/vms/ubuntu18.qcow2 \
    --hostname ubuntuvm \
    --update \
    --install "xfce4" \
    --network
```

Esto genera el disco solo queda asignarlo a una máquina virtual.



## Virt-install

virt-install sirve para generar maquinas virtuales.

generar desde disco existente.

```bash
virt-install --name ubuntu-18.04 \
    --memory 2048 \
    --vcpus 1 \
    --import \
    --disk path=/home/vms/ubuntu-18.04.qcow2,format=qcow2 \
    --os-type=linux \
    --os-variant ubuntu-18.04 \
    --graphics none
```

generar con iso de instalación.

```bash
 virt-install \ 
  --name guest1-rhel7 \ 
  --memory 2048 \ 
  --vcpus 2 \ 
  --disk size=8 \ 
  --cdrom /path/to/rhel7.iso \ 
  --os-variant rhel7 
```



## Gestionar Máquinas  

```bash
virsh shutdown archlinux # apagar
virsh destroy archlinux   # forzar apagado
virsh reboot archlinux	 # reiniciar
virsh suspend archlinux # suspender
virsh resume archlinux # despertar de suspensión
virsh save archlinux archivo_hibernacion # hibernar
virsh restore  archivo_hibernacion # desperta de hibernacion
virsh domstate archlinux  # estado de maquina
virsh dominfo archlinux # informacion de una maquina
virsh undefine archlinux # eliminar maquina
virsh undefine archlinux --remove-all-storage # eliminar maquina y disco
```

