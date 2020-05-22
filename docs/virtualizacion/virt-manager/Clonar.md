# Clonar de virtual a físico y de físico a virtual.

## Virtual a físico

### clonar disco virtual automáticamente kvm

```bash
sudo virt-clone -o antergos --auto-clone
Asignando 'antergos-clone.qcow2'                            |  20 GB  03:22  
```



### preparar disco clonado para ejecutarse

Virt-sysprep elimina mac y uuid especificas para que no coincida 2 veces y den problemas al arrancar la maquina clonada.

```bash
sudo virt-sysprep -a /var/lib/libvirt/images/antergos-clone.qcow2
[   0,0] Examining the guest ...
[   7,7] Performing "abrt-data" ...
---
---
[   8,1] Setting a random seed
[   8,4] Performing "lvm-uuids" ...
```



### clonar imagen del clon a partición /dev/sda12

```bash
sudo qemu-img convert -f qcow2 -O raw  /var/lib/libvirt/images/antergos-clone.qcow2  /dev/sda12
```



### abriendo partición /sda12 con kvm

```bash
sudo kvm /dev/sda12 -m 1G
```





## Físico a virtual

### clonar particion /dev/sda12 a imagen .raw

```bash
sudo dd if=/dev/sda12 | pv | dd of=/home/debian/Descargas/and-4-3.raw
5,72GiB 0:03:32 26,7MiB/s
15360000+0 registros leídos
15360000+0 registros escritos
7864320000 bytes (7,9 GB, 7,3 GiB) copied, 272,937 s, 28,8 MB/s
```



### convertir imagen .raw a .qcow2

```bash
sudo qemu-img convert -f raw -O qcow2 and-4-3.raw and-4-3.qcow2
```



### mover a libreria de virt-manager

```bash
sudo mv and-4-3.qcow2  /var/lib/libvirt/images/and-4-3.qcow2
```



### preparar disco clonado para ejecutarse

```bash
sudo virt-sysprep -a /var/lib/libvirt/images/and-4-3.qcow2
```



### Comprobar

comprobar que funciona, hay que crear una máquina y escoger la iso .qcow2 de la librería 



## Virtual a virtual

### De .qcow2 a .qcow2

#### clonar disco virtual automáticamente kvm

```bash
sudo virt-clone -o antergos --auto-clone
Asignando 'antergos-clone.qcow2'                            |  20 GB  03:22  
```



#### preparar disco clonado para ejecutarse

```bash
sudo virt-sysprep -a /var/lib/libvirt/images/antergos-clone.qcow2
```

- abrir desde virt-manager



### De .qcow2 a .vmdk

```bash
sudo qemu-img convert -f qcow2 -O vmdk imagen_origen.qcow2 imagen_destino.vmdk
```



### preparar disco clonado para ejecutarse

```bash
sudo virt-sysprep -a /home/debian/Descargas/antergos.vmdk
```



### De .qcow2 a .vdi

```bash
sudo qemu-img convert -f qcow2 <qcow2_VM_filename> -O vdi <RAW_file_VM_filename>
```





### preparar disco clonado para ejecutarse

```bash
sudo virt-sysprep -a /home/debian/Descargas/antergos.vdi
```

