# 107 tareas de administración

## Usuarios y grupos

### Archivos de configuración

```bash
/etc/shadow		# archivo de passwords
/etc/passwd		# archivo de usuarios
/etc/group  	# archivo de grupos
/etc/default/useradd  # opciones por defecto al crear un usuario
/etc/login.defs  # fichero de configuración de login
/etc/shells  	# shells disponibles en el sistema
/etc/skel		# esqueleto del home
```

`~/.bashlogout`: acciones que quiero que haga cuando cierro sessión del usuario  

`~/.bash_profile` 

- carga las opciones especificas del usuario
- contiene variables de entorno y startup programs ( programas que ejecutara al acceder a la sesión )
- variables que han de perdurar, si queremos que perduren en subsesiones se han de exportar dentro del archivo.
- programas que arrancar al iniciar sesion

`~/.bashrc`: contiene las alias y funciones especificas del usuario

`/etc/bashrc`: alias y funciones de todos los usuarios del sistema

`/etc/profile`: contiene los startups y las variables globales del sistema  

`/etc/profile.d`: las configuraciones personales para todos los usuarios en un script.sh  



**skel** es el directorio principal  plantilla del que se crearán los home de los usuarios. Si desea personalizar los archivos y carpetas que se crean automáticamente en el directorio de inicio de las nuevas cuentas de usuario, debe  agregar estos nuevos archivos y carpetas al directorio principal `/etc/skel`. 



**login.defs** `/etc/login.defs`archivo especifica los parámetros de configuración que controlan la creación de usuarios y grupos. Además, los comandos que se muestran en las secciones siguientes toman valores predeterminados de este archivo.

Las directivas más importantes son:

- `UID_MIN, UID_MAX`: El rango de ID de usuario que se pueden asignar a nuevos usuarios normales.
- `GID_MIN, GID_MAX`: El rango de ID de grupo que se pueden asignar a nuevos grupos ordinarios.
- `CREATE_HOME`: Especifique si se debe crear un directorio de inicio de forma predeterminada para los nuevos usuarios.
- `USERGROUPS_ENAB`: Especifique si el sistema debe crear de forma predeterminada un nuevo grupo para  cada nueva cuenta de usuario con el mismo nombre que el usuario.
- `MAIL_DIR`: directorio de cola de correo
- `PASS_MAX_DAYS`: El número máximo de días que se puede utilizar una contraseña.
- `PASS_MIN_DAYS`: La cantidad mínima de días permitidos entre cambios de contraseña.
- `PASS_MIN_LEN`: La longitud mínima aceptable de la contraseña.
- `PASS_WARN_AGE`: El número de días de advertencia antes de que caduque una contraseña.



### usuarios

`/etc/passwd` cada linea es la información de un usuario

- `login:passwd:Uid:GID:gecos:home:shell`

Al crear un usuario siempre se  crea y  luego se añade la pasword si quieres una sesión interactiva.   

- por defecto asigna home de usuario en el directorio home del sistema
- RH(fedora) por defecto crea los usuarios en un grupo propio
- el archivo `/etc/passwd`solo guarda el grupo principal del usuario



opciones más comunes.

```bash
useradd [opciones] user
-s /bin/sh			# shell especifica
-p password     	# pasword especifica
-g gid              # gid o nombre del grupo
-d /home/user       # destino home dir especifico 
-b /home            # destino home dir en basedir
-u uid              # uid especifico
-G grupo1,grupo2    # grupos secundarios
-m                  # asegurar que crea homedir
-M					# no crear home
-N                   # crear con grupo default ( no con el propio )
-m -k /etc/skel-propio # crear usuario con esqueleto propio
-D					# ver o modificar opciones por defecto
-e 'YYYY-MM-DD'		# establecer fecha de desactivación
-f	10				# establecer dias de periodo despues de max			

usermod [opciones] user	# modificar opciones de usuario, los argumentos son los mismos que useradd
-G grupo    # indica que grupos secundarios pertenecera ( se come los anteriores )
-aG grupo   # añade grupo secundario
-L			# blockear usuario
-U			# desbloquer usuario

userdel [opciones] user
-r	# eliminar usuario y todos sus datos, home, grupo, mail

chsh -s /bin/sh	# usuario ordinario puede cambiar su shell

getent database key
getent passwd user		# informacion de usuario en /etc/passwd
getent group name_group	# informacion de grupo
getent shadow user		# informacion de contraseña
```



### passwords

Las contraseñas de los usuarios se almacenan  en `/etc/shadow`

todas las fechas unix empiezan en **1 de enero de 1970** 

```
login_name:Pasword:last:min:max:warning:inactiviti_period:expiracion_cuenta:uso_futuro

user01:$6$6XgEAWH512FHpWFT$tavhsijiwTOKJG7bxnGlaFhvFWp7YEnf3pLA2SI6SBsA1TNmgjNS9s7f0yWvk6dL1QjH22k1raSOBMXQbq/8E1:18388:0:99999:7:::
```

- `Password` `$id$salt$hashed.` el `$id` indica el algoritmo de cifrado: `$1$` MD5, `$2a$ o $2y$` Blowfish, `$5$` SHA-256, `$6$` SHA512.
- `last`: Indica la ultima vez que se cambió la contraseña. 0 obliga a cambiar password y si es un numero, Es el numero de dias desde  **1 de enero de 1970** 
- `min`: Mínimo de dias que deben transcurrir para poder cambiar la contraseña. Campo en 0 o vacio, indica que no hay mínimo. 
- `max`: maximo tiempo para cambiar el password, si no te  obliga a cambiar. Entre min y max es el periodo que debes cambiar  password una vez pasado max te obligará. Campo vacio periodo infinito.
- `warning`: dias de aviso para cambiar el password respecto al max, x dias antres avisa que deves cambiar pasword antes que caduque. Campo en 0 no hay periodo de aviso.
- `inactiviti period`: días de periodo de gracia que podras cambiarte el password, una vez pasado max. valor 0 infinito. Campo vacio no hay periodo extra.
- `expiracion cuenta`: dias para la expiracion de cuenta,  una vez finalizado bloqueara el usuario no podra acceder ni poner  contraseña, solo admin podra activarlo.

**Explicación gráfica:**

```
                                                 period
              min                      warning  +------+
             +---------+                +-------+      |
    +-----------------------------------------------------------+
             +                                  +
        passwd
                                              max
```

Una vez puesta la password, en el periodo min no se podra cambiar la  password, en el periodo warning te avisara que deves cambiar, una vez  finalizado el periodo de warning te obligara a cambiar la password  mientras estes dentro del periodo period. una vez finalizado period no  podras acceder a tu sessión y sera un admin quien te adjunte una nueva  pasword.



```bash
passwd -S user    # informacion pasword usuario
passwd -l user # bloquear usuario :!!passwd:
passwd -u user # desbloquear
passwd -d user # dejar usuartio sin passwd ::
passwd -e user	# obligar a cambiar contraseña
passwd -i 3 user	# establecer periodo de gracia en 3 dias
passwd -n 2 user	# user podra cambiar password de aqui a 2 dias
passwd -x 5 user	# password caducara en 5 dias
passwd -w 7 user	# periodo de dias que avisa para cambiar el password

chage  -l user # muestra info mas bonito
chage -m 2 user # user podra cambiar password de aqui a 2 dias
chage -M 5 user # password caducara en 5 dias
chage -W 2 user # periodo de dias que avisa para cambiar el password
chage -I 3 user # establecer periodo de gracia en 3 dias
chage -E 2 user # expiracion cuenta de user en 2 dias
chage -E YYYY-MM-DD user # expiracion cuenta de user en dia indicado
chage -E -1 user # desbloquear user que a expirado y esta bloqueado
chage -d '2020-05-10' user	# cambiar fecha del ultimo cambio de contraseña
```



### grupo

`/etc/group` almacena la información de cada grupo

```
gname:contraseña:gid:lista de usuarios
```

- El último campo de cada línea guarda que usuarios pertenecen a dicho grupo como secundario.

**ejemplo:**

```bash
/etc/group
sudo:x:27:debian
id debian
uid=1000(debian) gid=1000(debian) grupos=1000(debian),27(sudo)
```

- el usuario debian tiene como secundario el grupo `sudo` y en el archivo group lo muestra como se ve en el paso anterior.

```bash
groupadd [opciones] grupo
-g	# giu especifico
-p	# contraseña

groupmod [opciones] grupo
-n nuevo_nombre	# cambiar nombre

groupdel grupo
```



`/etc/gshadow`  Este archivo  contiene contraseñas de grupo encriptadas, cada una en una línea separada.

Cada línea consta de cuatro campos delimitados por dos puntos:

```bash
nombre_grupo:contraseña:admin_de_grupo:Miembro_de_grupo
webmaster:!::debian
```

- La contraseña se usa cuando un usuario, que no es miembro del grupo, quiere unirse al grupo usando el `newgrp`comando;
- Los administradores de grupo son: Una lista delimitada por comas de los administradores del grupo (pueden  cambiar la contraseña del grupo y pueden agregar o eliminar miembros del grupo con el `gpasswd`comando).

- Miembros: Una lista delimitada por comas de los miembros del grupo.



## Tareas programadas

### Cron 

Permite programar tareas para que se ejecuten en un momento determinado o de forma periodica.

consta de:

- **crond** Demonio que ejecutará las tareas
- Fichero `/etc/crontab` donde se guardan las  tareas programadas del sistema
- `var/spool/cron` directorio de crontabs de usuario
- Comando **crontab** para administrar las tareas. 

```bash
crontab 
-l	# listar tareas
-e	# editar tareas
-r	# borrar tareas
-u user	# privilegios de root, junto alguna de las anteriores modificar crontab de otro user
```

Las tareas de  cron tienen una sintaxi especifica para asignar cuando se ejecutará dicha tarea.

```bash
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
```

Ejemplos:

```bash
0 5 * * 0		# a las 5:00 los domingos
30 17 * * 1,3,5	# los lunes, miercoles y jueves a las 17:30
5-15 * 1 2,5 *	# el dia 1 de febrero y mayo los minutos del 5 al 15 de todas las horas
*/5 * * * *		# cada 5 minutos

# también admite:
@reboot		# especifica una vez despues de reiniciar
@hourly		# al comienzo de cada hora
@daily o  @midnight	# una vez al día a media noche
@weekly		# una vez a la semana, meia noche vdel domingo
@monthly	# una vez al mes, medianoche primer día del mes
@yaerly o @annually	# una vez al año, medianoche 1 de enero
```

> La salida de una tarea de crontab se envia por defecto al correo del usuaro, por eso es bueno reenviar la salida a un archivo de log o asignar la variable `MAILTO` vacia.



Las tareas repetitivas son muy habituales en linux y para facilitar su administración hay directorios que ejecutarán todos los script que contengan en un momento determinado.

- `/etc/cron.hourly`
- `/etc/cron.daily`
- `/etc/cron.weekly`
- `/etc/cron.mouthly`

Para controlar quién puede utilizar cron se utilizan los ficheros:

- `/etc/cron.allow` Si sólo existe este fichero, únicamente los usuarios que figuren en él podrán ejecutar cron.
- `/etc/cron.deny`  Si sólo existe este fichero, únicamente los usuarios que figuren en él tendrán denegado ejecutar cron.

> Si no existe ninguno de los dos según la distribución podra ejeecutar cron todos los usuarios o solo root. En caso de que existan los dos se ejecuta allow y se ignora deny.



#### Variables crontab

Dentro de un archivo crontab, a veces hay asignaciones de variables definidas antes de que se declaren las tareas programadas. Las variables de entorno que se establecen comúnmente son:

- `HOME` directorio donde `cron` invoca los comandos( por defecto el directorio de inicio del usuario).
- `MAILTO` El nombre del usuario o la dirección a la que se envía la salida estándar y el error (de forma predeterminada, el propietario de crontab). 
- `PATH`  La ruta donde se pueden encontrar los comandos.
- `SHELL`  El shell a usar (por defecto `/bin/sh`).



### At

Está pensado para ejecutar una tarea en un momento concreto, se utiliza para tareas puntuales

Primero se ejecuta `at` y la hora. después se inserta los comandos que se van a ejecutar y se sal con `ctrl + d`.

La hora se puede expresar de las siguientes maneras:

```bash
at 14:30		# HH:MM
at 2021-05-01	# YYYY-MM-DD, MMDDYY, MM/DD/YY, DD.MM.YY 
at now +5 minutes	# en 5 minutos (minutes, hours, days, weeks)
at midnight		# today, tomorrow, midnight, noon (12:00), teatime (16:00)

atq			# muestra tareas
atrm N		# eliminar tarea

at -c N		# muestra el contenido de la tarea
at -d N		# eliminar trabajo segun su id, alias de atrm
at -f script	# lee las tareas desde el script
at -l		# alias atq
at -m		# enviar mail al final del trabajo
at -v		# vervose
```

Igual que cron, `at` utiliza los archivos `/etc/at.allow y /etc/at.deny` y el comportamiento es el mismo, excepto que si no existe ninguno de los dos solo root podrá utilizar `at`.

#### Batch

batch permite no cargar el systema en caso de que este por encima de un porcentaje concreto.

Aunque at le diga que ejecute el script batch esperara a ejecutar  este mismo hasta que el systema este por debajo del porcentaje indicado.

En el siguiente ejemplo le indicamos a batch que se ejecute cuando el systema esté por debajo del 10% y  en un intervalo entre script y  script de 60 segundos

```bash
atd -l 0.1 # cambiar nivel de carga de batch
atd -b  60 # número de segundos que tardará en ejecutar entre tareas segundos
```

**Ejemplo**

Ejecutar un script en 5 minutos

```bash
at now +5 minutes
warning: commands will be executed using /bin/sh
at> batch -f script
```



### Timers

Los timers de systemd permiten programar tareas de forma periodica o que se ejecute de forma puntual. Son unidades dentro del ecosistema de systemd.

**Monolítico** Son para ejecutar tareas tras el inicio del sistema.

```bash
OnBootSec=15min
OnUnitActiveSec=1w
```

**Tiempo Real** Para ejecutar tareas de forma periodica

```bash
OnCalendar=Sat *-*-1..7 18:00:00 (DayOfWeek Year-Month-Day Hour:Minute:Second)
```

Será necesario crear un fichero `.timer` y otro `.service` con el mismo nombre para el servicio que ejecutará el timer.

[Doc de arch](https://wiki.archlinux.org/index.php/Systemd_(Espa%C3%B1ol)/Timers_(Espa%C3%B1ol))

Ejemplo Tiempo real:

*/usr/lib/systemd/system/backup.timer*

```bash
[Unit]
Description=Execute backup every day at midnight

[Timer]
OnCalendar=*-*-* 00:00:00
Unit=backup.service

[Install]
WantedBy=multi-user.target
```

*/usr/lib/systemd/system/backup.service* 

```bash
[Unit]
Description=Backup of my apache website

[Service]
Type=simple
ExecStart=/var/www/backup/backup.sh

[Install]
WantedBy=multi-user.target
```

**Unidades transitorias** con el comando `systemctl-run` se puede indicar el momento determiado para la ejecución de una tarea. de esta forma no hace falta crear un archivo `.timer` ni un service creado a dicho timer.

```bash
systemd-run --on-active="5h" /bin/touch /tmp/foo # se ejecutara dentro de 5h
systemd-run --on-active=30 --unit someunit.service # en 30 segundos
```



## Localización e internacionalización

Antiguamente se gestionaba la hora en GMT *Greenwich Mean Time*  basándose en las lineas imaginarias de la tierra, pero ahora esto se a actualizado a UTC *Coordinated Universal Time*  basándose en relojes atómicos mas precisos, la cuestión es que según  el sistema operativo utilizado utiliza una u otra linux, mac: UTC,  windows: GMT.

La zona horaria se establece en el fichero `/etc/localtime` que este es un enlace simbolico a un archivo de zona dentro de `/usr/share/zoneinfo`

```bash
➜ ll /etc/localtime 
lrwxrwxrwx 1 root root 33 feb  6 12:05 /etc/localtime -> /usr/share/zoneinfo/Europe/Madrid
```

También  podemos encontrar los datos de la zona horaria en:

- `/etc/timezone` en debian y derivados
- `/etc/sysconfig/clock` en redhad y derivados

En ocasiones se tiene que administrar servidores de otra región pero para tu usuario no es realmente esa hora. Se puede establecer una zona horaria para un usuario mediante la variable `$TZ` o desde el comando `tzselect`.

Los comandos `date` y `timedatectl` se utilizan para mostrar y modificar la hora del sistema.

### Codificación de caracteres e idiomas

Hay datos que se interpretan de forma distinta según el lugar donde nos encontremos como: codificación del texto, representación de decimales, de fecha, etc. El sistema guarda esta información en `/etc/default/locale` y en distintas variables locales.

```bash
# sintaxis: [idioma[_territorio][.codeset][@modificador]]
cat /etc/default/locale
LANG="es_ES.UTF-8"
```

- **idioma y territorio** representan el idioma principal y alguna variante territorial
- **codeset** es la codificación de caracteres (ASCI, UTF-8, etc..)
- **modificador** es poco frecuente afecta a cuestiones especificas como forma de ordenar elementos o alguna moneda en particular (`ES_ES.UTF-8@preeuro`)

La codificación se puede modificar forma predeterminada desde el archivo `/etc/default/locale` o con el comando `localectl set-locale LANG=en_US.UTF-8` 

El comando `locale` muestra las variables del sistema que guardan información sobre la configuración local

`LANG`: configuración regional predeterminada

`LC_ALL`:  Si se establece esta variable anulas todas las variables `LC_*` incuida `LANG`

`LC_COLLATE`: Especifica el orden se a de usar para ordenar y comparar cadenas

`LC_CTYPE`: configuración regional a usar para los conjuntos de caracteres

`LC_MESSAGES`: Se usa para imprimir mensajes y analizar respuestas

`LC_MONETARY`: configuración regional para formatear valores monetarios

`LC_NUMERIC`: configuración regional para formatear números

`LC_TIME`: configuración regional para formatear fechas

`LC_MEASUREMENT`: Unidades de medida (Métricas u otras)



Una configuración particular es `LANG=C`, esto aplica una configuración POSIX lo más estandar posible para el manejo de información en programas o script y no causen problemas.

```bash
locale		# ver variables
locale -a --all-locales	# ver opciones disponibles
locale-gen	# actualizar contenido de opciones disponibles del archivo /etc/locale.gen
```



Con `iconv` podemos cambiar la codificación de un archivo.

```bash
iconv -f old-encoding [-t new-encoding] file.txt > newfile.txt
```



