# webdav

### Que es webdav?

Es un servidor de apache que nos permite administrar archivos estilo samba pero más globalizado, se puede administrar mediante un navegador web, explorador de archivos, y más programas que harán de cliente webdav.



Indica los pasos para hacerlo funcionar:

**Añadimos en /etc/httpd/conf/httpd.conf **

```bash
DocumentRoot /var/www/webdav/
<Directory /var/www/webdav/>
Options Indexes MultiViews
AllowOverride None
Order allow,deny
allow from all
</Directory>
Alias /webdav /var/www/webdav/
DAVLockDB /var/lib/webdav/DAVLock
<Location /webdav>
DAV On
AuthType Basic
AuthName "webdav"
AuthUserFile /var/www/passwd.dav
Require valid-user
</Location>
```





#### Instalar

```bash
sudo dnf install -y httpd httpd-tools mod_ssl
sudo mkdir /var/www/webdav
sudo chown apache:apache /var/www/webdav
sudo mkdir /var/lib/webdav
sudo chown apache:apache /var/lib/webdav

sudo touch /var/www/passwd.dav
sudo htpasswd /var/www/passwd.dav jorge
```



- Con esto crearemos todas las carpetas, hacemos el chown a las mismas y definimos una contraseña de webdav.



#### Como montar las carpetas desde fstab:

***/etc/fstab***

Añadir:

```bash
http://192.168.4.2/webdav/ /home/users/inf/wism2/ism47787241/webdav-companero davfs defaults,rw,uid=fran,gid=fran,_netdev,auto,dir_mode=777   0 0
http://localhost/webdav/ /home/users/inf/wism2/ism47787241/webdav davfs defaults,rw,uid=jorge,gid=jorge,_netdev,auto,dir_mode=777  0 0
```



***/etc/davfs2/secrets***

Añadir:

```bash
http://192.168.4.2 fran fran
http://localhost jorge jorge
```



**Con esto ya podriamos montar las 2 carpetas**

```bash
sudo  mount  -a
```



###  Montar carpetas en windows

webdav conectar con windows

inicio → servicios → cliente web --> general → tipo de arranque automatico

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/webdab-1.png)

inicio → regedit → HKEY_LOCAL_MACHINE--> SYSTEM → current control set → services → webclient → parameters --> BasicAuthLevel → informacion del valor 2

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/webdav-2.png)



Desde el navegador de archivos equipo:

- conectar a una unidad de red.
  - en carpeta:
    - http://192.168.4.3/webdav

​        ![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/webdav-3.png)





###  Webdav 2 carpeta personal

#####  Creo carpetas y doi permisos

```bash
sudo mkdir -p /var/www/webdav/home/jorge
sudo mkdir -p /var/www/webdav/home/pastor
sudo chown apache:apache /var/www/webdav/home/pastor
sudo chown apache:apache /var/www/webdav/home/jorge
```



#####  Añado usuarios y pasword al archivo de configuración

```bash
sudo htpasswd  -b /var/www/passwd.dav jorge jorge
sudo htpasswd  -b /var/www/passwd.dav pastor pastor
```



#####  Añado parametros de entreada a cada carpeta

```bash
<Location /webdav/home/pastor>
        DAV On
	AuthType Basic
        AuthName "webdav"
        AuthUserFile /var/www/passwd.dav
        Require user pastor
</Location>

<Location /webdav/home/jorge>
        DAV On
	AuthType Basic
        AuthName "webdav"
        AuthUserFile /var/www/passwd.dav
        Require user jorge
</Location>
```





##  Script autamatizado

```bash
#!/bin/bash

clear
echo "En el siguiente escript crearas una carpeta personal en webdav"
echo ""
echo -n "Introduce el nombre de usuario la password sera la misma: "
read user

sed -r 's/^(.*):.*/\1/' /var/www/passwd.dav  | egrep -w $user

if [ $? == 0 ]; then
  echo "Ese usuario ya existe crea otro."

else
  # creo user en archivo de acceso
  sudo htpasswd  -b /var/www/passwd.dav $user $user

  # creo directorio en webdav
  sudo mkdir -p /var/www/webdav/home/$user


  # añado configuración en /etc/httpd/conf/httpd.conf
  echo "
  <Location /webdav/home/$user>
          DAV On
  	      AuthType Basic
          AuthName webdav
          AuthUserFile /var/www/passwd.dav
          Require user $user
  </Location>" >> /etc/httpd/conf/httpd.conf

  # reinicio servicios
  sudo systemctl restart httpd.service
fi


```

