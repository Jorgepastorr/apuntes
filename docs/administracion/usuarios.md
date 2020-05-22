## Usuarios

Todo usuario tiene un UID y un GID nº grupo principal. Opcionalmente puede pertenecer a  x grupos secundarios.

las opciones por defecto se encuentra en `/etc/login.defs`

### Archivos de configuración

Creación ( add del mod )  

```bash
/etc/passwd  
/etc/group  
/etc/default/useradd  
/etc/login.defs  
/etc/shells  
/etc/skel
```

`~/.bashlogout`

- acciones que quiero que haga cuando cierro sessión del usuario  

`~/.bash_profile` 

- carga las opciones especificas del usuario
- contiene variables de entorno y startup programs ( programas que ejecutara al acceder a la sesión )
- variables que han de perdurar, si queremos que perduren en subsesiones se han de exportar dentro del archivo.
- programas que arrancar al iniciar sesion

`~/.bashrc`

- contiene las alias y funciones especificas del usuario

`/etc/bashrc`

- alias y funciones de todos los usuarios del sistema

`/etc/profile`

- contiene los startups y las variables globales del sistema  

  `/etc/profile.d`  
- las configuraciones personales para todos los usuarios en un script.sh  

Un directorio acabado en .d significa que es un dirtectorio que contiene configuraciones

### usuario

`/etc/passwd` cada linea es la información de un usuario

- `login:passwd:Uid:GID:gecos:home:shell`

Al crear un usuario siempre se  crea y  luego se añade la pasword, si quieres una sesión interactiva.   

- por defecto asigna home de usuario en el directorio home del sistema
- RH(fedora) por defecto crea los usuarios en un grupo propio
- el archivo `passwd`solo guarda el grupo principal del usuario

### grupo

`/etc/group` almacena la información de cada grupo

`gname:contraseña:gid:lista de usuarios`  

- El último campo de cada línea guarda que usuarios pertenecen a dicho grupo como secundario.

**ejemplo:**

```bash
/etc/group
sudo:x:27:debian
id debian
uid=1000(debian) gid=1000(debian) grupos=1000(debian),27(sudo),999(docker)
```

- el usuario debian tiene como secundario el grupo `sudo` y en el archivo group lo muestra como se ve en el paso anterior.

### passwords

Se almacenan  en `/etc/shasow`

todas las fechas unix empiezan en 1 de enero de 1970

`login_name:Pasword:last:min:max:warning:inactiviti_period:expiracion_cuenta:uso_futuro`

- `last`: fecha_ultimo_cambio. 0 obliga a cambiar password y si es un numero, numero de dias desde 1970
- `min`: dias_para_poder_cambiar_password desde el dia impuesto. 
  - campo en 0 o vacio no hay mínimo. 
- `max`: maximo tiempo para cambiar el password, si no te obliga a cambiar. Entre min y max es el periodo que debes cambiar password una vez pasado max te obligara.
  - campo vacio periodo infinito.
- `warning`: dias de aviso para cambiar el password respecto al max, x dias antres avisa que deves cambiar pasword antes que caduque.
  - campo en 0 no hay periodo de aviso.
- `inactiviti period`: dias de periodo de gracia que podras cambiarte el password, una vez pasado max. valor 0 infinito.
  - campo vacio no hay periodo extra.
- `expiracion cuenta`: dias para la expiracion de cuenta, una vez finalizado bloqueara el usuario no podra acceder ni poner contraseña, solo admin podra activarlo.

**Explicación gráfica:**

```bash
                                                 period
              min                      warning  +------+
             +---------+                +-------+      |
    +-----------------------------------------------------------+
             +                                  +
        passwd
                                              max
```

Una vez puesta la password, en el periodo min no se podra cambiar la password, en el periodo warning te avisara que deves cambiar, una vez finalizado el periodo de warning te obligara a cambiar la password mientras estes dentro del periodo period. una vez finalizado period no podras acceder a tu sessión y sera un admin quien te adjunte una nueva pasword.

Las contraseñas se *"encriptan"*  con un algoritmo que no tiene reversión, la manera de autentificación es añadiendo un texto, este se encripta y si coincide con el encriptado anterior es que la contraseña es correcta.

```bash
passwd -S user    # informacion pasword usuario
chage  -l user # lo mismo mas bonito
passwd -l user # bloquear usuario :!!passwd:
passwd -u user # desbloquear
passwd -d user # dejar usuartio sin passwd ::

chage -m 2 user # user podra cambiar password de aqui a 2 dias
chage -M 5 user # password caducara en 5 dias
chage -W 2 user # periodo de dias que avisa para cambiar el password
chage -I 3 user # establecer periodo de gracia en 3 dias
chage -E 2 user # expiracion cuenta de user en 2 dias
chage -E YYYY-MM-DD user # expiracion cuenta de user en dia indicado
chage -E -1 user # desbloquear user que a expirado y esta bloqueado
```

### Crear, eliminar y modificar

#### Crear

Al crear un usuario por defecto se crea: la cuenta, una password, se crear home y mail

opciones más comunes.

```bash
useradd user

-s /bin/sh             # shell especifica
-p password         # pasword especifica
-g gid                 # gid o nombre del grupo
-d /home/user         # destino home dir especifico 
-b /home             # destino home dir en basedir
-u uid                 # uid especifico
-G grupo1,grupo2     # grupos secundarios
-m                     # asegurar que crea homedir
-N                    # crear con grupo default ( no con el propio )
-m -k /etc/skel-propio # crear usuario con esqueleto propio
```

##### Default

`useradd -D` opcioners por defecto al crear un usuario
Las opciones se guardan en `/etc/default/useradd`

##### Esqueleto

Al crear un directorio de usuario se crea el esqueleto por defecto y ese esqueleto se encuentra en `/etc/skel`
Si tenemos diferentes tipos de usuarios a veces queremos que tengan distintos esqueletos de home, podemos asignar manualmente al crear el usuario o cambiarlo por defecto.

Al crear usuario:

- se crea la cuenta en `/etc/passwd`
- se crea el grupo en `/etc/group`
- se crea el mail en `/var/spool/mail/`

##### login.defs

`/etc/login.defs` fichero de configuración de login guarda datos de: password,num maximo y minimo de usuarios, grupos autistas o por defect, home por defecto, umask, encriptacion, mail.    

formatos encryptacion:

- SHA512
- MD5

#### Borrar

La opción `userdel -r` borra la cuenta, grupo primario si no es primario en otro user, el home y el mail.  
Pero para hacerlo correctamente debemos considerar diferentes aspectos.

- `home` si se quiere hacer una backup de ese home, para un futuro.
- `mail` si nel mail nos interesa conservarlo. 
- `archivos` y directorios del usuario repartidos por el sistema, hacer backups o borrar, etc..
- `procesos`  en marcha siempre hay que matarlos, por posible malware intencionado.
- `impresion` trabajos de impresion es posible que se quieran guardar, podría haber algo importante.

Para estas acciones extra se puede crear un script que al ejecutar `userdel` se inicialize automaticamente. La opción la encontramos en `/etc/login.defs`.

```bash
...
USERDEL_CMD /usr/sbin/script
...
```

borrar usuario y sus datos

```bash
userdel -r user
```

#### Modificar

Al modificar utilizamos las mismas opciones que creando, excepto en parámetros múltiples que añades `-a`  (append)  a no ser que quieras reescribir.

```bash
usermod user
-G grupo     # indica que grupos secundarios pertenecera ( se come los anteriores )
-aG grupo    # añade grupo secundario
```

`chfn` cambiar informacion usuario

- El mismo usuario no podra cambiar la informacion de usuario a no ser que en `/etc/login.defs`  este `CHFN_RESTRICT yes`.

  lo que si podra hacer es editar la información adicional de finger, desde `.plan` donde se inserta en formato texto.

ver shells del sistema.

- `cat /etc/shells`





