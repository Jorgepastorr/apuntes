# 108 Servicios esenciales del sistema

## Hora del sistema

### date

administra la hora del sistema operativo. Se puede mostrar de distintas formas con `date +cadena_formato`

```bash
date +
%d	# día del mes
%H	# hora en formaro 24h
%I	# hora en formato 12h
%m	# mes
%M	# minutos
%S	# segundos
%T	# %H:%M:%S
%u	# día de la semana
%Y	# año
%F	# %Y-%m-%d

date  -s "YYYY-MM-DD HH:MM:SS"	# establecer hora
date -u	# hora UTC
date --debug --date="wed, 07 apr 2021 18:33 +0200"	# comprobar formato correcto
```



### hwclock 

administra la hora del hardware del sistema.

```bash
hwclock	# ver hora del sistema
hwclock --set --date="2020-10-28 20:00" --utc	# establecer hora hardware
-s --hctosys	# copiar en el sistema la hora de la BIOS
-w --systohc	# copiar en el hardware la hora del sistema
```



### timedatectl 

```bash
timedatectl		# ver configuracion actual
	status		# ver configuracion actual
	set-time "YYYY-MM-DD HH:MM"	# establecer feche y hora sistema	
	list-timezones	# listar zonas horarias
	set-timezone Europe/Madrid	# establecer zona horria
	set-ntp	[BOOL]	# habilitar o desabilitar sincronización ntp
```

Cuando `timedatectl`  cambia o visualiza la zona horaria, simplemente esta trabajando sobre el *soft-link* de `/etc/localtime` 

```bash
➜ ll /etc/localtime 
lrwxrwxrwx 1 root root 33 feb  6 12:05 /etc/localtime -> /usr/share/zoneinfo/Europe/Madrid
```



### Servidores de hora

#### NTP

Es un protocolo de tiempo de red que sirve para sincronizar la hora del sistema operativo con la hora proporcionada por los servidores de tiempo principales. Utiliza el sistema UTC pero el cliente lo adaptará a la zona horaria apropiada.

En NTP hay que tener en cuenta los siguientes términos:

- `Offset`: es la diferencia entre la hora del sistema y la hora NTP.
- `Step`: Si la diferencia de tiempo entre el proveedor de NTP y un consumidor es  superior a 128 ms, NTP realizará un único cambio significativo en la  hora del sistema
- `Slew`: se refiere a los cambios realizados en la hora del sistema cuando el  desfase entre la hora del sistema y el NTP es inferior a 128 ms. Si este es el caso, los cambios se realizarán gradualmente. 
- `Insane Time`: Si el desfase es superior a 17 minutos, se considera que la hora del sistema es una locura y no se realizarán cambios.
- `Drift`:  se refiere al fenómeno en el que dos relojes se desincronizan con el tiempo.
- `Jitter`:  se refiere a la cantidad de desviación desde la última vez que se consultó un reloj. 



El demonio `ntpd` establece y actualiza la hora del sistema en sincronización con uno o más servidores. El proyecto llamado `pool.ntp.org` es un conjunto de servidores que ofrecen un servicio NTP fiable y fácil de usar.

```bash
ntpq	# consultar el funcionamiento de ntpd
-p		# ver servidores ntp

ntpdate <server_ntp>	# sincronización puntual con un  servidor
```

El archivo de configuración de ntpd es `/etc/ntp.conf`

```bash
# servidores a consultar, entre 3 y 5
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org

restrict default  ignore	# actuar solo de cliente
restrict 127.0.0.1			# host local puede acceder

# ajusta la hora basandose en diferencias de sincronización anteriores
driftfile /var/lib/ntp/ntp.drift	
logfile /var/log/ntpuser.log
```



#### chrony

Es otra posibilidad de para sincronizar el sistema que utiliza el protocolo y los servidores NTP. Es mejor alternativa en equipos que no están siempre activos  o con conexiones de red intermitentes.

El demonio es `chronyd` y los archivos de configuración `/etc/chrony.conf` o `/etc/chrony/chrony.conf`

```bash
chronyc	# consulta el estado de chronyd y modifica
chronyc	sources		# información sobre servidores
chronyc	tracking	# estado del sistema de configuración
chronyc makestep	# sincronizar reloj del sistema manualmente

chrony ntpdata		# ver información sobre la ultima actualización NTP válida
```



#### SNTP

Es un protocolo similar a NTP pero simplificado. Significa que la máquina con SNTP no podrá servir la hora a otras máquinas, solo captarla. Las distribuciones que implementan `timedatectl` de manera predeterminada utilizan SNTP.

En este caso, SNTP no funcionará a menos que el `timesyncd`servicio se esté ejecutando.

```bash
timedatectl show-timesync --all	# ver configuración de timesyncd
```



## Registros del Sistema

Mantener un  registro de lo que sucede en el sistema es de vital importancia para conocer y optimizar su funcionamiento, así como para solucionar posibles problemas en el mismo. Las dos maneras más populares de gestionar estos registros son:

- `rsyslog` es un gestor tradicional gestiona diversos ficheros en texto plano.
- `systemd-journal` mantiene un registro más sofisticado y seguro, pero menos abierto a otros programas.

> otros programas más antiguos eran `syslog` y `syslog-ng`, que tenían un funcionamiento parecido a `rsyslog`



**Lectura de registros**

El sistema suele guardar los registros en `/var/log` donde puede haber a su vez  diversos subdirectorios.

La mayoría de registros generados por el sistema son de texto plano, pero Hay algunos ejemplos en los que los registros no son texto, sino archivos  binarios y, en consecuencia, debe usar comandos especiales para  analizarlos:

`var/log/wtmp` inicios de sesión exitosos  `who o w`

`/var/log/btmp` intentos de inicio de sesión fallidos, por ejemplo fuerza bruta ssh

```bash
sudo utmpdump /var/log/btmp
sudo last -f
```

 `/var/log/faillog`  fallos en la autentificación fallidos

```bash
sudo faillog -a
```

`/var/log/lastlog` fecha y tiempo de los últimos login

```bash
sudo lastlog
```



**Cómo se convierten los mensajes en registros** 

El siguiente proceso ilustra cómo se escribe un mensaje en un archivo de registro:

1. Las aplicaciones, los servicios y el kernel escriben mensajes en archivos  especiales (sockets y búferes de memoria), por ejemplo, `/dev/log`o `/dev/kmsg`.
2. `rsyslogd` obtiene la información de los sockets o búferes de memoria.
3. Dependiendo de las reglas que se encuentren en `/etc/rsyslog.conf`y / o de los archivos `/etc/ryslog.d/`, `rsyslogd`mueve la información al archivo de registro correspondiente (normalmente se encuentra en `/var/log`).



### rsyslog 

tiene su fichero de configuración en `/etc/rsyslog.conf` o en ficheros dentro de `/etc/rsyslog.d/` . Sus lineas principales seleccionan el tipo de mensaje y le indican dónde se tiene que guardar. El selector de mensajes consta de dos partes `facility.priority`

- `facility` es el origen de los mensajes `auth, authpriv, cron, daemon, ftp, mail, user, local0-7,  ...`
- `priority` el tipo de log `debug, info, notice, warning, err, crit, alert y emerg` siendo esta la prioridad ascendiente.



selectores:

```bash
*.*				# todos los mensajes
*.info			# todos los mensajes de info
kern.*			# mensajes del kernel
mail.err		# mensajes de err de mail
cron,lpr.warn	# warning de lpr y cron
cron.err,cron.!alert	# los errores de cron pero no las alertas
mail.=err		# solo los errores de mail
*.info;mail.none;lpr.none	# todolos los mensajes de info excepto los de mail y lpr
```

En el archivo de configuración podemos ver como  utilizando estos selectores redirige información a distintos ficheros.

```bash
# First some standard log files.  Log by facility.
auth,authpriv.*                 /var/log/auth.log
*.*;auth,authpriv.none          -/var/log/syslog
kern.*                          -/var/log/kern.log
mail.*                          -/var/log/mail.log
user.*                          -/var/log/user.log
...
# Logging for the mail system.
mail.info                       -/var/log/mail.info
mail.warn                       -/var/log/mail.warn
mail.err                        /var/log/mail.err
...
```



#### rsyslog servidor central

[Separado en archivo adicional](./108_rsyslog_server.md) 



### logger

Es un comando  que sirve para insertar lineas en los ficheros de logs, es comúnmente utilizado por scripts y/o programas.

```bash
logger "Hola mundo"
logger -p user.warning -t  misavisos "ha ocurrido algo raro"
```

La opción `-p` indica la `facilidad.prioridad` del mensaje ( por defecto `user.notice`) . Con `-t` indica la etiqueta en el mensaje.

```bash
sudo tail -f /var/log/user.log
...
Apr 10 10:23:53 localhost debian: hola mundo
Apr 10 10:24:48 localhost misavisos: ha ocurrido algo raro
```



### logrotate

Se utiliza para "rotar" los ficheros de log. Es decir, para aplicar unas determinadas políticas según vaya pasando el tiempo: borrar, comprimir, mover, ...

Los propósitos principales de esto son:

- Evite que los archivos de registro más antiguos utilicen más espacio en disco del necesario.
- Mantenga los registros a una longitud manejable para facilitar la consulta.



Sus ficheros de configuración son `/etc/logrotate.conf, /etc/logrotate.d/`

Ejemplo de fichero de configuración

```bash
{
	rotate 7		# número de vrotaciones
	daily			# frecuencia
	missingok		# no producir error si el fichero no existe
	notifempty		# no rotar si esta vacio
	delaycompress	# no comprimir la ultima rotación, pero sí la anterior
	compress		# comprimir log rotado (gzip por defecto)
	size 50M		# tamaño máximo fichero log
	postrotate		# lanzar ordenes despues de rotar
		invoke-rc.d rsyslog rotate > /dev/null
	endscript
}
```



### Journal

Su fichero de configuración se encuentra en `/etc/systemd/journal.conf` 

Las directivas que empiezan por `System` hacen referencia al almacenaje en disco y las `Runtime` a memoria

- `Storage`: puede tomar los valores:
  - `volatile`: los mensajes solo se guardan nen memoria `/run/log/journal`
  - `persistent`: los ficheros de log se guardan nen disco
  - `auto`: se guardan nen disco si existe `/var/log/journal`
  - `none`: no se almacenan
- `Compres`: indica que los ficheros de los se comprimen. por defecto sí
- `(S/R)Maxusage`: máximo espacio que se puede consumir
- `(S/R)KeepFree`: cuanto tamaño debe mantener libre
- `ForwardToSyslog`: enviar los mensajes a `rsyslog`
- `RateLimitInterval/RateLimitBurst`: Limita la cantidad de mensajes seguidos.

> Estas son solo algunas de las opciones para más ver `man 5 journald.conf`



Para que `rsyslog` pueda leer los mensajes de journal se debe cargar el módulo `imjournal` en el fichero `/etc/rsyslog.conf`

```bash
module(load="imjournal") 
```



**Limpieza de datos** antiguos de journal

```bash
journalctl --vacuum-time=5d		# limpiar datos mas antiguos  a 5 días
journalctl --vacuum-size=100M	# borrar todo a partir de los 100M más recientes
```



**Enviar mensajes** al registro de journal

```bash
echo "Hola Mundo" | systemd-cat -t user -p warning

sudo journalctl -t user           
-- Logs begin at Sat 2021-04-10 09:15:29 CEST, end at Sat 2021-04-10 11:49:33 CEST. --
abr 10 11:47:08 localhost.localdomain user[13506]: Hola Mundo
```



#### Consultas

`systemctl` es el programa para consultar los logs de journal.

- **-S -U**: permite especificar desde (since) y/o  hasta cuando (until)
  - YYYY-MM-DD [ HH:MM:SS], yesterday, today, tomorrow, N day ago, - / + NhMmin (-1h15min)
- **-u** unit: mensage de una unidad en concreto
- **-k** : mensajes del kernel
- **-p** por tipo ( emerg, alert, crit, err, warning, notice, info, debug )
- PARAM=VALUE : parámetros como `_PID, _UID, _COMM,_HOSTNAME, _EXE`  ( man systemd.journal-fields )
- **-D --directory** leer un archivo de log de journal

 

```bash
sudo journalctl

# filtrar entre dias, o horas
sudo journalctl -S 2021-02-14 -U 2021-02-16
sudo journalctl -S today
sudo journalctl -S yesterday
sudo journalctl -S '2 day ago'
sudo journalctl -S -1h10min

# filtrar por servicio
sudo journalctl -u networking.service

# logs del kernel
sudo journalctl -k

# filtrar po tipo de alerta
sudo journalctl -p err
sudo journalctl -p warning
sudo journalctl -p emerg
sudo journalctl -p alert
sudo journalctl -p info

# filtrar por parametro
sudo journalctl _COMM=anacron
sudo journalctl _UID=1000

# filtrar los ultimos logs, con una corta esplicación
sudo journalctl -xe

# leer logs de un directorio alternativo
sudo journalctl --directory /mnt/var/log/journal

sudo journalctl -r	# orden inverso,  de mas actual a menos
sudo journalctl -f	# ultimos mensajes y simil a tail -f
sudo journalctl --disk-usage 

```



## Mail Transfer Agent básico

```
                        ┌─────────────────────┐               ┌───────────────────────────────┐
                        │  Sender Mail server │               │   Reciever Mail Server        │
                        ├─────────────────────┤               ├───────────────────────────────┤
                SMTP    │                     │               │   ┌───────┐     ┌─────────┐   │
   ┌──────────┬─────────┼───►┌────────────┐   │               │   │ MDA   ├──►  │  mailbox│   │
   │ MUA gmail│         │    │   MSA      │   │               │   └───────┘     └─────────┘   │
   └──────────┘         │    └─────┬──────┘   │               │       ▲                 ▲     │
                        │          │ SMTP     │               │ SMTP  │                 │     │
                        │          │          │               │       │                 │     │
                        │          ▼          │               │   ┌───┴───┐      ┌──────┴───┐ │             ┌──────────┐
                        │    ┌────────────┐   │               │   │ MTA   │      │ POP3/IMAP│ │             │ MUA      │
                        │    │   MTA      ├───┼───────────────┼──►└───────┘      │  server  │ │ ◄────────── │ outlook  │
                        │    └────────────┘   │    SMTP       │                  └──────────┘ │  POP3/IMAP  └──────────┘
                        └─────────────────────┘               └───────────────────────────────┘
```



**MUA** (Mail User Agent). Crea, envia, recibe y visualiza el correo. (thunderbird, gmail, outlook, ...)

**MSA** (Mail Submission Agent). Recibe, chequea y envía al MTA

**MTA** (Mail Transfer Agent). transfiere el correo (con SMTP) a otro MTA o, si se ha alcanzado el servidor del destinatario, al MDA.

**MDA** (Mail Delivery Agent). recibe el correo y lo almacena en el buzón.

**IMAP/POP3**. Protocolos utilizados por MUA para recuperar correos electrónicos de un buzón del servidor.



Una manera de entender un mensaje de correo es enviarlo directamente mediante SMTP al MTA.

```bash
$ nc lab2.campus 25
220 lab2.campus ESMTP Sendmail 8.15.2/8.15.2; Sat, 16 Nov 2019 00:16:07 GMT
HELO lab1.campus
250 lab2.campus Hello lab1.campus [10.0.3.134], pleased to meet you
MAIL FROM: emma@lab1.campus
250 2.1.0 emma@lab1.campus... Sender ok
RCPT TO: dave@lab2.campus
250 2.1.5 dave@lab2.campus... Recipient ok
DATA
354 Enter mail, end with "." on a line by itself
Subject: Recipient MTA Test

Hi Dave, this is a test for your MTA.
.
250 2.0.0 xAG0G7Y0000595 Message accepted for delivery
QUIT
221 2.0.0 lab2.campus closing connection
```

Una vez establecida la conexión te identificas con `HELO` , los siguientes dos campos `MAIL FROM, RCPT TO` indican el remitente y el destinatario. El mensaje de correo empieza después de la linea en blanco después de  `DATA` , y el mensaje acaba en la linea que solo hay un `.` 



### Principales MTA

**Sendmail** es el mas tradicional pero está en desuso. Ha tenido diversos fallos de seguridad que lo han cuestionado nen el terreno.

**Exim** fue desarrollado para sistemas Unix. Tiene bastante flexibilidad y abarca todas las funciones necesarias (control de spam, virus, dominios virtuales, ...). Es el MTA  por defecto en distribuciones Debian.

**Postfix** fue creado por IBM para que fuera más rápido, fácil de administrar y seguro que Sendmail.



### Comandos manejo de correo

**Mail** es un programa de linea de comanmdos que trabaja como MUA, por lo  tanto podrémos visualizar nuestro correo y enviar mails desde el.

```bash
# enviar correo
mail [-v] [-s asunto] [-c direcciones] [-b direcciones] destinatario
-v 	# activa modo depuración
-s	# el asunto del mensaje
-c	# destinatarios en copia
-b	# destinatarios en copia oculta
-a	# archivo adjunto

# enviar en modo script
mail -s "asunto" < /tmp/aviso.txt destinatario@mail.org

# visualizar correo
mail 
mail -u user
n	# leer siguiente mensaje
h	# ver lista de mensaje
q	# salir y guardar cambios
x	# salir sin guardar cambios
r [num_message] #responder mensaje actual (indicado por >) o indicar nuúmero 
p	# mostrar el mmensaje otra vez
d [num_message o lista]	# borrar mensaje actual o indicado por un número 2  4,9 1-4
```

mail guarda los mensajes en

```bash
/home/debian/mbox	# mensajes vistos
/var/mail/debian	# mensajes aun no vistos
```

 **mailq** gestiona las colas de correo, es decir los mail que no se han podido enviar y están pendientes. La ubicación predeterminada para la cola de la bandeja de  salida es `/var/spool/mqueue/` 



###  Alias de correo

Para establecer alias de correo se utiliza el fichero `/etc/aliases o /etc/mail/aliases` . De esta forma un correo dirigido a un usuario puede ser redirigido a  uno o varios diferentes (también a programas). cada linea tendrá un usuario de destino y a dónde se reenvía.

Siempre que este configurado en el MTA se podrá reenviar a usuarios locales como a externos

*/etc/aliases*

```bash
...
www: root
root: debian
webmaster: pedro, anna
clientes: julian@empresa.es;silvia@gmail.com
avisos: |/usr/local/bin/log_warning
```

> Los servidores MTA necesitan que se ejecute el comando `newaliases` para procesar este fichero y manejarlo de forma más eficiente. también se puede ejecutar `sendmail -I o sendmail -bi`



Un usuario del sistema puede editar `~/.fordward`  en su home para reenviar los correos que vayan dirigidos a él. Este fichero contendrá los lugares a los que redirigir el correo.

En este caso en el archivo solo se indica a donde reenviar el correo, por ejemplo todo lo que llegue a este usuario se reenviará a suport y a avisos.

```bash
support, avisos
```



## Gestion de impresión



**CUPS** (Common Unix Printing System) Es un servidor de impresión  que  acepta peticiones, las procesa y las envía a las colas de impresión.

**IPP** (Internet Printing Protocol) protocolo soportado por CUPS para imprimir a través de la red. Soporta control de acceso, autenticación, cifrado, etc.

**PostScript** formato preferido por linux para enviar un documento a imprimir.  la impresora debe ser compatible ( debe tener un interprete de este lenguaje )

**GhostScript** programa que transforma un documento de PostScript a otro formato compatible con las impresoras que no poseen PostScript. Normalmente  se transforma a mapas de bit por lo que los ficheros resultantes puedes ser muy pesados.



**Ficheros de configuración**  de cups se encuentran en `/etc/cups/`. los mas importantes son:

`cupsd.conf` donde se encuentran las opciones del servidor

`printers.conf` donde se definen las impresoras

En `/etc/cups/ppd/`  podemos encontrar los ficheros que definen las características de las impresoras, si el fabricante no los proporcionan podemos buscar en los siguientes proyectos.

- [Openprinting](https://openprinting.github.io/projects/02-foomatic/)
- [Foomatic](https://wiki.linuxfoundation.org/openprinting/database/foomatic)
- [Gutenprint](http://gimp-print.sourceforge.net/)
- Web del fabricante

`/var/log/cups/` directorio de logs



### Interfaz web

La interfaz web de CUPS facilita la administración y configuración de las impresoras .

El archivo de configuración  `/etc/cups/cupsd.conf` determina si la interfaz web para el sistema CUPS está habilitada. 

```bash
WebInterface Yes
```

Si la interfaz web está habilitada, CUPS se puede administrar desde un navegador en la URL predeterminada de `http://localhost:631`.

 De forma predeterminada, un usuario del sistema puede ver las impresoras y las colas de impresión, pero cualquier forma de modificación de la  configuración requiere que un usuario con acceso de root se autentique  con el servicio web. 

```bash
# All administration operations require an administrator to authenticate...
<Limit CUPS-Add-Modify-Printer CUPS-Delete-Printer CUPS-Add-Modify-Class CUPS-Delete-Class CUPS-Set-Default>
  AuthType Default
  Require user @SYSTEM
  Order deny,allow
</Limit>
```

- `AuthType Default` autenticación básica
- `Require user @SYSTEM` requiere user con privilegios administrativos. puede cambiarse por `@groupname` o `require user carol, tim` entre otros.
- `Order deny,alloy`  la acción se deniega de forma predeterminada a menos que un usuario (o miembro de un grupo) esté autenticado.



### Administración de consola

#### Instalación

También se puede instalar una cola de impresora utilizando los comandos LPD/LPR heredados.

```bash
sudo lpadmin -p ENVY-4510 -L "office" -v socket://192.168.150.25 -m everywhere

-p	# nombre para identificar impresora
-L	# ubicación de la impresora
-v	# URI de la impresora
-m	# modelo de la impresora (everywhere) detección automatica

lpoptions -d ENVY-4510 # asignar impresora predeterminada
```

Es  mejor dejar que CUPS determine que archivo PPD usar para una impresora. Sin embargo `lpinfo` se puede utilizar para ver los archivos PPD instalados

```bash
lpinfo --make-and-modl "HP Envy 4510" -m
```



#### Configuración

```bash
# compartir impresora en la red
sudo lpadmin -p FRONT-DESK -o printer-is-shared=true

# permitir a usuario, grupos o denegar
sudo lpadmin -p FRONT-DESK -u allow:carol,frank,grace
sudo lpadmin -p FRONT-DESK -u deny:dave
sudo lpadmin -p FRONT-DESK -u deny:@sales,@marketing

# eliminar impresora
sudo lpadmin -x FRONT-DESK

# asignar politica en caso de error
sudo lpadmin -p FRONT-DESK -o printer-error-policy=abort-job
# politicas
about-job			# cancela el trabajo
retry-job			# intentalo mas tarde
stop-printer		# parar impresora
retry-current-job	# intentalo de nuevo inmediatamente

# rechazar todos los trabajos nuevos de una impresora
sudo cupsreject -r "Impresora que se eliminará" FRONT-DESK

lpstat -p -d
-p	# impresoras disponibles
-d	# impresora predeterminada
-v	# vervose
```





### Gestionar cola de impresión

Los comandos `lpr, lpq, lprm`  son los utilizados para la gestión de la cola.

```bash
lpr -P impresora_coloer -# 5 documento.txt
lpr	# envia fichero a la cola por defecto
-P	# especifica una cola en concreto
-#	# númro de impresiones

lpq	# muestra la cola de impresión
-l	# muestra más detalles
-P	# especificar cola
-a	# mostrar todas las colas

lprm	# elimina un trabajo de la cola especificando su id de trabajo
-	# eliminar todos los trabajos
lprm -P PRINT-DESK 5	# eliminar tarea 5 de la impresora indicada

# mover trabajo con id 2 entre impresoras
lpmove PRINT-DESK-2 PRINT-LASERJET

cupsenable -c PRINT-DESK	# eliminar cola de impresora
```

