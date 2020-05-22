# umask 

Es la máscara simbólica de permisos que tiene un archivo o directorio por defecto.

tiene 2 formas de cambiarse.

máscara de directorios tiene valor de 777

máscara de archivos tiene valor de 666

**<u>Modo simbólico.</u>** 

```bash
umask u=rwx,g=rwx,o= <archivo>

 d rwx rwx --- 2 dave 512 Sep  1 20:59 foo
 - rw- rw- --- 1 dave   0 Sep  1 20:59 bar
```



<u>**Modo octal ( solo válida en la sesión actual )**</u>

El octal funciona justo al revés que chmod colocas los números en función de lo que quieres quitar.

```bash
umask 0174

 d rw- --- -wx 2 dave 512 Sep  1 20:59 foo
 - rw- --- -w- 1 dave   0 Sep  1 20:59 bar
```



Para configurar el valor de umask por defecto para un usuario en concreto hay que añadir en el fichero .bashrc_profile el comando umask 077, peor además también se puede modificar el valor de umask en el fichero global /etc/profile para que el cambio sea efectivo para todos los usuarios.



<u>**Evitar cambio de máscara en el copiado**</u>

Para evitar el cambio tenemos que hacer un cp -p y preservara la máscara por defecto como estaba.

```bash
cp -p archivo archivo(copiado)
```



