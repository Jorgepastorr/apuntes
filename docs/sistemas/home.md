# Cambiar /home

## Cambiar /home de partición

Crear la carpeta /home en una partición sirve para seguridad de pérdida de datos y poderla compartir con diferentes sistemas operativos UNIX.

Mirar el espacio que usa tu /home con du o ncdu.

Crear partición relativa al tamaño del /home piensa que crecerá en un futuro, crearla el doble de grande.

```bash 
sudo fdisk /dev/<partción>
```

- o desde gráfico con  gparted



Montar la partición nueva como /tmp o /mnt por ejemplo

```bash
sudo mount /dev/<partición> /mnt
```



Copiar el /home con:

```bash
sudo cp -af <origen> <destino>
sudo cp -af /home/* /mnt
```



Desmontar /tmp o lo que hayas montado en la partición nueva.

```bash 
sudo umount /mnt
```



Montar el /home de la partición nueva

```bash 
sudo mount /dev/<partición> /home
```



Añadirlo al archivo ***/etc/fstab***

```bash
---
UUID=1abaa252-48c7-4002-957b-68de8fbed75f /home         ext4    defaults    1 1
```



Desmontar la partición /home creada, para comprobar el cambio de fstab este bien hecho. 

Y comprobar con *sudo mount -a*  que la detecte bien.

```bash
sudo mount -a
```



## Cambiar /home de windows

- crear una partición ntfs de un tamaño considerable que preveas que cabrán todos tus documentos.

- Ir a disco local C:

- - Usuarios.

  - - <Usuario> en mi caso jorge.

    - En cada archivo que haya dentro tipo, descargas, docs, imágenes etc..

    - - propiedades
      - ubicación
      - cambiar ubicación C: por destino deseado en mi caso F:

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/home-win-1.png)

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/home-win-2.png)

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/home-win-3.png)

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/home-win-4.png)