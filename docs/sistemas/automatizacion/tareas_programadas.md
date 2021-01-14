# Tareas Programadas

## Cron

Administrador de tareas

Se utiliza para reproducir un script en un momento concreto , entre otras cosas.

Su carpeta se encuentra en:

Fichero:  /etc/crontab  (ahí guardaremos los scripts)

Tabla de referencia imaginaria para el comando.

| Minutos | Horas | Día del mes | Mes  | Día semana |
| ------- | ----- | ----------- | ---- | ---------- |
| 01      | *     | *           | *    | *          |

Ejecutar cada minuto 1 de cada hora de cada día del mes, mes y día de la semana.

| */5  | *    | *    | *    | *    |
| ---- | ---- | ---- | ---- | ---- |
|      |      |      |      |      |

Ejecutar cada 5 minutos.

| 15   | 20   | *    | *    | *    |
| ---- | ---- | ---- | ---- | ---- |
|      |      |      |      |      |

Ejecutar a las 20:15 horas de cada día, mes, etc..

| 45   | 19   | 1    | *    | *    |
| ---- | ---- | ---- | ---- | ---- |
|      |      |      |      |      |

Ejecutar cada 1er día del mes a las 19:45

| 30   | *    | 10 - 25 | *    | 6 - 7 |
| ---- | ---- | ------- | ---- | ----- |
|      |      |         |      |       |

Ejecutar cada 30m de cada hora los días del 10 al 25 todos los meses sábados y domingos

| 00   | 18 - 20 | 25   | 3 - 7 | 1,3,6 |
| ---- | ------- | ---- | ----- | ----- |
|      |         |      |       |       |

Ejecutar cada hora entre las 18:00 y 20:00 el día 25 del mes entre marzo y julio si es lunes(1), miércoles(3) o sábado(6).

<u>Los guiones marcan rangos y las comas para números específicos.</u>

**Comando:**

15 20 * * * “user” “ruta absoluta del script”

**(Importante)**  Respetar los espacios, user y ruta no llevan asteriscos””.   

Tabla de referencia imaginaria para el comando.

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



***Ejemplos*** 

```bash  
| Minutos | Horas | Día del mes | Mes  | Día semana |

#Ejecutar cada minuto 1 de cada hora de cada día del mes, mes y día de la semana.
01 * * * *

#Ejecutar cada 5 minutos.
*/5 * * * *

#Ejecutar a las 20:15 horas de cada día, mes, etc..
15 20 * * *

#Ejecutar cada 1er día del mes a las 19:45
45 19 1 * *

#Ejecutar cada 30m de cada hora los días del 10 al 25 todos los meses sábados y domingos
30 * 10-25 * 6-7

#Ejecutar cada hora entre las 18:00 y 20:00 el día 25 del mes entre marzo y julio si es lunes(1), miércoles(3) o sábado(6).
00 18-20 25 3-7 1,3,6

#viernes 12:15 de la noche
15 00 * * 6
```

```bash   
crontab -l 
crontab -e
crontab -r 
■  ~ sudo cat /var/spool/cron/isx47787241  
crontab fichero
```





## At 

at programa tareas a una hora y dia determinados, esta tarea se ejecutara siempre que el pc este encendido en la fecha indicada, de no ser así se perderá la tarea.

Dentro del directorio `/var/spool/at/` crea un fichero con cada una de las tareas por hacer.



### ejemplos 

ver tareas adjudicadas

```bash 
atq
```

borrar una tarea del at programada

```bash  
atrm 3  
```

Ejecutar un script a una hora determinada

```bash  
at -f backup.sh 10:22
```



Programa una tarea para dentro de 5 minutos que elimine de un directorio todos los ficheros con extensión .tmp .

```
at now +5 minutes
find /tmp/ -name *.tmp -exec rm {} \;
```



Programa una tarea con at a las 17:00 de hoy para que elimine los ficheros del directorio descargas de tu sistema.

```
at 17:00 
sudo find /tmp/descargas/* -exec rm {} \;
```



Denegar a un usuario utilizar at 

```bash
echo "user" >> /etc/at.deny

at 11:00
You do not have permission to use at.
```



Diferentes formatos de usar at

- formato HH:MM

```bash
at 11:00 # proramas a una hora especifica
```

- midnight

```bash
at midnight # se ejecuta a media noche 00:00
```

- noon

```bash
at moon # medio día 12:00
```

- teatime

```bash
at 4pm 0 am # formato 12 horas
```

- formato del nombre-mes, día y año

```bash
at -v jan 30 2018
Tue Jan 30 10:40:00 2018
```

- formato MMDDYY, MM/DD/YY, o MM.DD.YY

```bash
at -v 12/10/2017
Sun Dec 10 10:42:00 2017

at -v 12102017  
Sun Dec 10 10:44:00 2017

```

- now + time

```bash
at -v now + 5 days
Wed Dec  6 10:46:00 2017

t -v now + 60 minutes
Fri Dec  1 11:47:00 2017

at -v 2:30 PM 21.10.20
Wed Oct 21 14:30:00 2020

```



Crea un script que abra un nuevo terminal dentro de 5 minutos. 

```bash
at -v now +5 minutes   
Fri Dec  1 11:13:00 2017

at> export DISPLAY=:0
at> gnome-terminal

```



Programa una tarea que muestre la fecha mañana y 5 minutos .

```bash
at -v tomorrow +5 minutes
date >> /dev/pts/0

```





### Batch

batch permite no cargar el systema en caso de que este por encima de un porcentaje concreto.

Aunque at le diga que ejecute el script batch esperara a ejecutar este mismo hasta que el systema este por debajo del porcentaje indicado.



En el siguiente ejemplo le indicamos a batch que se ejecute cuando el systema esté por debajo del 10% y  en un intervalo entre script y script de 60 segundos

```bash
atd -l 0.1 # cambiar nivel de carga de batch
atd -b  60 # número de segundos que tardará en ejecutar entre tareas segundos

```



#### Ejemplo

Ejecutar un script en 5 minutos

```bash
at now +5 minutes
warning: commands will be executed using /bin/sh
at> batch -f script
```



