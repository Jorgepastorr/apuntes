# Systemd  

Systemd es la actualización de init, este proceso se encarga de arrancar todos los servicios, targets y componentes necesarios para poder trabajar con la terminal. La mejora de systemd respecto a init es que en el  arranque del sistema inicia todos los demonios a la vez y trabajan en paralelo, a esto se le denomina ( concurrencia ).



```bash
system-analyze blame # analizar tiempos de arranque
systemd-analyze dot "basic.target" | dot -Tsvg > /tmp/basic.svg
```

grafico de dependencias

```bash
systemd-analyze dot "basic.target" | dot -Tsvg > /tmp/basic.svg
systemd-analyze dot --to-pattern="*.target" --from-pattern="httpd.service" | dot -Tsvg > /tmp/gpm.svg
```



## Units

Systemd se configura exclusivamente a trabes de archivos de texto, registra las instrucciones de inicialización para cada daemon en un archivo de configuración (conocido como 'unit file'). 

Estos ficheros de configuración se encuentran en:

- Redhad y derivados: `/usr/lib/systemd/system/`  
- Debian: `/lib/systemd/system/` 

Algunos tipos de units:

```
.service
.target
.socket
.mount
.automount
.path
.slice
.timer
```

Información sobre los units

```bash
systyemctl list-units
systemctl list-unit-files
```

El contenido de estos archivos unit tienen una estructura simple, una descripción, que ejecutar, antes o después de quien voy  si es que dependen de algún otro demonio es lo mas básico.



## Niveles de arranque

| unit           | systemd                                 | Description                |
| -------------- | --------------------------------------- | -------------------------- |
| `0`            | `runlevel0.target`, `poweroff.target`   | apagar sistema             |
| `1`            | `runlevel1.target`, `rescue.target`     | Modo rescate               |
| `2`            | `runlevel2.target`  `multi-user.target` | rescat con red             |
| `3`            | `runlevel3.target`, `multi-user.target` | Multi usuario sin grafico  |
| `4`            | `runlevel4.target`  `multi-user.target` | custom                     |
| `5`            | `runlevel5.target`, `graphical.target`  | Multi usuario con grafico  |
| `6`            | `runlevel6.target`, `reboot.target`     | apagar y reiniciar sistema |
| init=/bin/bash | `emergency.target`                      | shell root                 |

Por defecto en una máquina de usuario la opción esta indicada en `graphical.target`, lo podemos mirar con.

La opción `init=/bin/bash` y `emergency.target` no son quivalentes ya que emergenci arranca systemd y init solo arranca el kernel y el bash.

```bash
debian  ➜  systemctl get-default
graphical.target
# modificar la opcion por defecto
systemctl set-default multi-user.target
# cambiar al modo rescue
systemctl isolated rescue.target
```

Todos estos target u objetivos, dependen  de diferentes units para su ejecución completa. Para alcanzar el objetivo x hay que arrancar primero n units que son sus dependencias.

```bash
systemctl list-dependencies multi-user.target
```



El directorio targe.wants es el que define la estructura del arranque, es decir para arrancar multi-user tienes que arrancar primero todos los units incluidos en el directorio `multi-user.target.wants`.

```bash
ls /etc/systemd/system/multi-user.target.wants/
abrtd.service
abrt-journal-core.service
abrt-oops.service
abrt-vmcore.service
abrt-xorg.service
atd.service
auditd.service
avahi-daemon.service
chronyd.service
crond.service
cups.path
dbxtool.service
gpm.service
libvirtd.service
mcelog.service
mdmonitor.service
ModemManager.service
NetworkManager.service
nfs-client.target
postgresql.service
remote-fs.target
rngd.service
sssd.service
vmtoolsd.service
```

Son demonios a arrancar en ese target, todos estos archivos que se ven son enlaces simbólicos a `/usr/lib/systemd/system/` , que es realmente donde se encuentra el demonio.







## Demonios

Los demonios ( servicios ) son programas tipo especial de proceso no interactivo, es decir, que se ejecuta en segundo plano.

Actualmente los demonios se gestionan con `systemctl`  podemos ver si un demonio esta activo o no con `is-active` o si esta habilitado con `is-enable`.

```bash
systemctl is-active httpd
```

Al instalar un demonio crea un archivo unit `.service`dentro de `/usr/lib/systemd/system/` ,en el archivo de configuración .service la opción `wantedby` indica en que objetivo se añadirá al habilitarlo.



### Archivo de servicio

El archivo de configuración de un demonio denominado *unit file*  con extensión `.service` .

archivo básico:

```bash
[Unit]
Description=Descripcion corta del programa

[Service]
ExecStart=binario o script que ejecuta
PidFile=escrivir un pid para dominarlo

[install]
WantedBy=donde instalarse multi-user.target, rescue.target etc..
```



Existen muchas opciones para este tipo de archivos por ejemplo:

`ExecStop`: que quieres que haga al apagar el servicio.

`RemainAfterExit=true`: una vez ejecutado muestra que esta activo ( esto sirve para ejecuciones que no son continuas )

`Type=oneshot` : se ejecuta solo una vez



Cada vez que modifiquemos algún servicio, objetivo o archivo unit es muy recomendable ejecutar `systemctl daemon-reload` para asegurarse que lee correctamente los demonios.





#### Targets  

Targets son los objetivos que se marca el arranque en el inicio del sistema. Los target guardan su configuración en `/usr/lib/systemd/system/` en archivos `.target` y la lista de unitsa arrancar en ese objetivo se guarda en `/etc/systemd/system/objetivo.target.wants/` .

Ejemplo configuración. 

```bash
[Unit]
Description=Rescue Mode
Documentation=man:systemd.special(7)
Requires=sysinit.target rescue.service
After=sysinit.target rescue.service
AllowIsolate=yes

[Install]
Alias=kbrequest.target
```

- `Requires`:  exige que las opciones indicadas estén activas para iniciarse
- `After`: me tengo que arrancar después de las opciones dadas
- `allowisolate`:  yes, indica si es un punto de sesión, es decir asociado a un target indica al sistema que una vez llegado a este objetivo puede ofrecer una sesión de usuario.



## Analizar el estado del sistema

Para mostrar el **estado del sistema** utilice: 

```bash
systemctl status
```

Para **listar unidades en ejecución**: 

```bash
systemctl
```

o: 

```bash
systemctl list-units
```

Para **listar unidades que han fallado**: 

```bash
systemctl --failed
```

Los archivos de las unidades disponibles se pueden ver en `/usr/lib/systemd/system/` y `/etc/systemd/system/` (este último tiene prioridad). Puede ver un **listado de las unidades instaladas** con: 

```
systemctl list-unit-files
```



### Gestionar la energía

[polkit](https://wiki.archlinux.org/index.php/Polkit) es necesario para gestionar la energía. Si se encuentra en una sesión local de *systemd-logind*  y ninguna otra sesión está activa, las órdenes siguientes funcionarán  sin requerir privilegios de root. Si no es así (por ejemplo, debido a  que otro usuario ha iniciado otra sesión tty), *systemd* automáticamente le requerirá la contraseña de root. 

Apagado y reinicio del sistema: 

```
$ systemctl reboot
```

Apagado del sistema: 

```
$ systemctl poweroff
```

Suspensión del sistema: 

```
$ systemctl suspend
```

Poner el sistema en hibernación: 

```
$ systemctl hibernate
```

Poner el sistema en estado de reposo híbrido —*«hybrid-sleep»* 	— (o suspensión combinada —*«suspend-to-both»*—): 

```
$ systemctl hybrid-sleep
```



<br>  

## Gestión servicios  

Systemd es la actualización de init, en la siguiente tabla muestro sus equivalencias.

| Init                     | Systemd                                                      | Description                                                  |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| service name start       | systemctl start name.service                                 | Inicia un servicio                                           |
| service name stop        | systemctl stop name.service                                  | Detiene un servicio                                          |
| service name restart     | systemctl restart name.service                               | Reinicia un servicio                                         |
| service name condrestart | systemctl try-restart name.service                           | Reinicia un servicio solo si está en funcionamiento          |
| service name reload      | systemctl reload name.service                                | Recarga la configuración de un servcio                       |
| service name status      | systemctl status name.service systemctl is-active name.service | Comprueba si un servicio está funcionando.                   |
| service –status-all      | systemctl list-units type service all                        | Muestra el estado de todos los servicios.                    |
| chkconfig name on        | systemctl enable name.service                                | Habilita un servicio                                         |
| chkconfig name off       | systemctl disable name.service                               | Deshabilita un servicio                                      |
| chkconfig –list name     | systemctl status name.service systemctl is-enabled name.service | Comprueba si un servición está habilitado                    |
| chkconfig –list          | systemctl list-unit-files –type service                      | Lista todos los servicios y comprueba si están habilitados   |
| chkconfig –list          | systemctl list-dependencies –after                           | Lista los servicios que tienen que iniciarse antes de una unidad |
| chkconfig –list          | systemctl list-dependencies –before                          | Lista los servicios que tienen que iniciarse después de una unidad |



### Activar, Habilitar y Enmascarar  

#### Activar  

Ver,  activar, desactivar, recargar o mirar si esta activo:

```bash
sudo systemctl status servicio
sudo systemctl is-active servicio
sudo systemctl start servicio
sudo systemctl stop servicio
sudo systemctl restart servicio
sudo systemctl try-restart servicio # solo activa el servicio si anteriormente estaba activo
sudo systemctl reload servicio # recarga la configuración sin reiniciarse
```



#### Habilitar  

```bash
sudo systemctl is-enabled servicio
sudo systemctl enable servicio
sudo systemctl disable servicio
```



#### Enmascarar

Un servicio está enmascarado cuando no se puede iniciar de forma manual o por medio de otro servicio. Por supuesto, cuando un servicio está  enmascarado no puede ser iniciado en el arranque de la máquina. Es 
decir, un servicio enmascarado puede estar activo, pero no puede estar  habilitado. Ahora bien, si el servicio no está activo y está enmascarado, no se podrá iniciar.

Para ver si un servicio esta enmascarado no hay ningún comando, así que habrá que tirar de bash.

```bash
ans=`systemctl status ntp | grep masked`; if [ ${#ans} -gt 0 ];then echo "masked";else echo "Not masked";fi
```

```bash
sudo systemctl mask servicio # enmascarar
sudo systemctl unmask servicio # desenmascarar
```



<br>  

## Crear un servicio  



Servicio simple, se ejecuta una vez al iniciar el sistema.

***/lib/systemd/system/test.service***    

```bash
[Unit]
Description=Una prueba

[Service]
Type=oneshotExecStart=/bin/bash /home/lorenzo/test.sh
```

***/lib/systemd/system/backup.service***    

```bash
[Unit]
Description=Backup of my apache website

[Service]
Type=simple
ExecStart=/var/www/backup/backup.sh

[Install]
WantedBy=multi-user.target
```



Ahora simulamos que nuestro servicio arranca una api 

***/lib/systemd/system/sample.service*** 

```bash
[Unit]
Description=Ejemplo
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=lorenzo
ExecStart=/usr/bin/env python3 /home/lorenzo/temporal/sample/sample.py

[Install]
WantedBy=multi-user.target
```

- `Descripcion` la descripción del servicio
- `After` tiene que esperarse a que el servicio indicado se haya iniciado.
- `ExecStart` ruta del ejecutable
- `Type`  permite configurar el inicio del ejecutable.
  - `simple`. El proceso empieza con `ExecStart` y es el principal proceso del servicio.
  - `forking`. En este caso se lanza un proceso hijo, que se convierte en el proceso principal.
  - `oneshot`. El proceso termina antes de comenzar con las siguientes unidades.
  - `dbus`. Las siguientes unidades empezarán cuando el proceso principal tegan el D-Bus.
  - `notify`. En este caso depende de un mensaje de notificación enviado por `sd_notify`.
  - `idle`. La ejecución del servicio se retrasa hasta que todos los trabajos han terminado.
- `Restart` 
  - `Restart=always` reinicia el servicio si se cae
  - `Restart=on-failure` reinicia el servicio si se a parado por error.
- `Restartsec` Tiempo que tardara en reiniciar el servicio, por defecto es 100ms.
- `StartLimitBurst` y `StartLimitIntervalSec`  definen los intentos de arranques del servicio y en que intervalo.
  - `StartLimitIntervalSec=0` reiniciar el servicio tantas veces como sea necesario.
- `WantedBy` *runlevel*  en el que se debe iniciar el servicio.



```bash
systemctl get-default # ver target por defecto 8 normalmente el grafico )
systemctl list-units --type target # lista de targets
```



## Timer  

Timer es una funcionalidad de systemd para automatizar servicios en fechas concretas, similar a cron pero con systemd.  

Consiste en crear un `servicio.timer` que contiene cuando debe ejecutarse y ejecuta otro servicio.

***Ejemplo:*** 

***/usr/lib/systemd/system/backup.service*** 

```bash
[Unit]
Description=Backup of my apache website

[Service]
Type=simple
ExecStart=/var/www/backup/backup.sh

[Install]
WantedBy=multi-user.target
```

***/usr/lib/systemd/system/backup.timer***  

```bash
[Unit]
Description=Execute backup every day at midnight

[Timer]
OnCalendar=*-*-* 00:00:00
Unit=backup.service

[Install]
WantedBy=multi-user.target
```

>  Así de fácil indicas hora y fecha a ejecutar, servicio y nivel de ejecución.  

  

#### Sintaxis fechas

El formato de la fecha es `DiaDeLaSemana Año-Mes-Día Hora:Minuto:Segundo`. Se puede utilizar,

- `*` para indicar cualquier valor
- valores separados por comas para indicar un listado de posibles
- `..` para indicar un rango continuo de valores
- `/` seguido por un valor. Esto indica que se ejecutará en ese valor y en los múltiplos correspondientes. Así `*:0/10` indica que se ejecutará cada 10 minutos.

Algunos ejemplos,

- `OnCalendar=Mon,Tue *-*-01..04 12:00:00` indica que se ejecutará los cuatro primeros días de cada mes las 12 horas siempre y cuando sea lunes o martes.
- `OnCalendar=*-*-* 20:00:00` se ejecutará todos los días a las 20 horas.
- `OnCalendar=Mon..Fri *-*-* 20:00:00` se ejecutará de lunes a vierne a las 20 horas.
- `OnCalendar=*-*-* *:0/15` o `OnCalendar=*:0/15` se ejecutará cada 15 minutos



```
Minimal form                   Normalized form
Sat,Thu,Mon-Wed,Sat-Sun    ==> Mon-Thu,Sat,Sun *-*-* 00:00:00
Mon,Sun 12-*-* 2,1:23      ==> Mon,Sun 2012-*-* 01,02:23:00
Wed *-1                    ==> Wed *-*-01 00:00:00
Wed-Wed,Wed *-1            ==> Wed *-*-01 00:00:00
Wed, 17:48                 ==> Wed *-*-* 17:48:00
Wed-Sat,Tue 12-10-15 1:2:3 ==> Tue-Sat 2012-10-15 01:02:03
*-*-7 0:0:0                ==> *-*-07 00:00:00
10-15                      ==> *-10-15 00:00:00
monday *-12-* 17:00        ==> Mon *-12-* 17:00:00
Mon,Fri *-*-3,1,2 *:30:45  ==> Mon,Fri *-*-01,02,03 *:30:45
12,14,13,12:20,10,30       ==> *-*-* 12,13,14:10,20,30:00
mon,fri *-1/2-1,3 *:30:45  ==> Mon,Fri *-01/2-01,03 *:30:45
03-05 08:05:40             ==> *-03-05 08:05:40
08:05:40                   ==> *-*-* 08:05:40
05:40                      ==> *-*-* 05:40:00
Sat,Sun 12-05 08:05:40     ==> Sat,Sun *-12-05 08:05:40
Sat,Sun 08:05:40           ==> Sat,Sun *-*-* 08:05:40
2003-03-05 05:40           ==> 2003-03-05 05:40:00
2003-03-05                 ==> 2003-03-05 00:00:00
03-05                      ==> *-03-05 00:00:00
minutely 				   ==> *-*-* *:*:00
hourly                     ==> *-*-* *:00:00
daily                      ==> *-*-* 00:00:00
monthly                    ==> *-*-01 00:00:00
weekly                     ==> Mon *-*-* 00:00:00
yearly 					   ==> *-01-01 00:00:00
quarterly 				   ==> *-01,04,07,10-01 00:00:00
semiannually 			   ==> *-01,07-01 00:00:00
*:0/15 					   ==> *-*-* *:0/15
```



Por ultimo activarlo.

```bash
sudo systemctl enable backup.timer
sudo systemctl start backup.timer
```



#### Reeditar

si después editas el timer y cambias la fecha hay que recargar el servicio.

```bash
sudo systemctl daemon-reload
```



#### Listar Timers

```bash
sudo systemctl list-timers
```





### Más información

https://wiki.archlinux.org/index.php/Systemd

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-managing_services_with_systemd-services

https://www.atareao.es/tutorial/trabajando-con-systemd/

https://www.certdepot.net/rhel7-use-systemd-timers/
