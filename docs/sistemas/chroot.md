# Chroot

Chroot nos permite acceder a una partición como root de la misma.

**Montamos la partición como /mnt**

```bash
sudo mount /dev/<partición> /mnt
```



**Montamos las carpetas necesarias para ser root en /mnt**

```bash
 for i in /dev /dev/pts /proc /sys; do sudo mount -B i /mnti; done 
```



**Nos convertimos en root y accedemos a la carpeta.**

- chroot /mnt
- cd /mnt

Ya somos root en la partición indicada.