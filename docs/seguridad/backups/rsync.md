# rsync

Sincroniza, contenido/mirroring.  Tiene dos modos de uso, **modo copi** sincroniza contenido de directorio a directorio y **modo samba** que se enciende como servidor y tiene recursos, igual que samba.

rsync se puede utilizar de:

```
local - local
local - remoto
remoto - local
```

Manuales

```bash
man rsync
man rsyncd.conf
```



## modo copi

Es el método estándar, se utiliza similar al `scp` .

```bash
rsync -a m04-lm  /tmp/proves/ # copia el directorio
rsync -a m04-lm/ /tmp/proves/ # copia el contenido del directorio
rsync -a m04-lm/  localhost:/tmp/proves/ # remoto
rsync -av m04-lm/  localhost:/tmp/proves/ # visualizar cambios
-n --dry-run # acer test
rsync -a ~/dir1 username@remote_host:destination_directory
rsync -a --delete  m04-lm/  /tmp/proves/ # sincronizar borrando si hay cambios
```



## modo samba

Como servidor se definen los recursos en `/etc/rsyncd.conf` y en caso de querer añadir usuarios `/etc/rsyncd.secrets` 



Usuarios que podrán conectar al recurso de usuarios.

```bash
[isx47787241@i09 repositorios]$ sudo cat /etc/rsyncd.secrets 
jorge:jorge

[isx47787241@i09 repositorios]$ ll /etc/rsyncd.secrets 
-rw-------. 1 root root 12 dic 16 09:50 /etc/rsyncd.secrets
```

> **Importante:** los permisos del fichero `/etc/rsyncd.secrets` han de ser 0600.



Ejemplo de fichero de configuración, con:

- public: solo permite descargas.
- read: solo permite descargas igual que public.
- privat: permite descargas y subidas desde el usuario jorge.
- write: solo permite subidas y no puede verse su contenido.

```bash
[isx47787241@i09 repositorios]$ cat /etc/rsyncd.conf 
log file = /var/log/rsync.log
pid file = /var/run/rsyncd.pid

[public]
        comment = recurso publico
        path = /home/debian/rsync/public

[read]
        comment = recurso solo lectura
        path = /home/debian/rsync/read
	    read only = yes

[privat]
        comment = recurso de escritura
        path = /home/debian/rsync/privat
	    list = no
	    read only = no
	    write only = no
	    auth users = jorge
    	secrets file = /etc/rsyncd.secrets

[write]
        comment = recurso de escritura
        path = /home/debian/rsync/write
	    read only = no
     	write only = yes

```



`write only` regla que determina la descarga, si es verdadero la descarga fallara, si es falso, se podan descargar si el sistema lo permite,( por defecto es no).

`read only` si es verdadero las subidas fallaran , si es falso se podrán hacer subidas si el sistema lo permite, (por defecto es yes).



### demonio

```bash
sudo rsync --daemon  # arrancar servicio
sudo killall rsync # detenr servicio
```



### conexión

```bash
rsync  localhost:: # listar recursos
rsync  localhost::public  # listar contenido de public
rsync  -a file localhost::write # subir contenido
rsync  -a localhost::public . # descargar contenido
```

