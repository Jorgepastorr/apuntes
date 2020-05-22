# Procesos 

Todo proceso tiene un PID ( ID del proceso )
PPID  padre del proceso
Los procesos se ejecutan en orden gerarquico.

```bash
■ ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S 101377 1627  1185  0  80   0 - 32936 -      pts/2    00:00:00 bash
0 S 101377 1668  1627  0  80   0 - 41373 -      pts/2    00:00:00 zsh
0 R 101377 1858  1668  0  80   0 - 35775 -      pts/2    00:00:00 ps
■ ps
  PID TTY          TIME CMD
 1627 pts/2    00:00:00 bash
 1668 pts/2    00:00:00 zsh
 1863 pts/2    00:00:00 ps
```

- ps tiene como padre zsh
- zsh tiene como padre bash



**Árbol de procesos**   

```bash  
pstree -ps <num proceso>  
-p  proceso
-s arbol  
-a mostrar todo sin agrupaciones

ps 
-u mi usuario
-a all e toria
-ax parta ver todos x para ver del sistema  
```

> Proceso numero 1 es el systemd ( initd ) padre de todos los procesos
> Los procesos que empiezan por K son del kernel  



**Ver identificadores de los procesos bash** 

```bash 
pgrep -l bash  # veo numero de proceso y proceso
pidof bash  
```

  

## Matar procesos

kill envia señales, las señales se envian entre procesos `pkill -l` lista los diferentes tipos de señales disponibles

- 15 SIGTERM ( señal terminar procesos, es la señal por defecto de kill)
- 9 SIGKILL  ( señal matar ) Solo si se queda colgado, puedes perder información al matar a lo bestia.

```bash 
kill <numero proceso>
killall <nombre proceso>
pkill <nombre proceso>
killall -u user1 # matar todos los procesos de un usuario especifico
kill %2 # matar segundo proceso de backgroud
xkill (clicar con el cursor encima ventana)
```

  

## Backgroud/Foregraund  

Background ejecutar ordenes en segundo plano con `&` al final de la orden.

Ejemplo: `$ sleep 154856 &`  

`jobs` ver procesos en segundo plano

```bash 
■  prova jobs
[1]    running    tree / &> /dev/null 
[2]  - running    sleep 145879       
[3]  + running    sleep 145879      
```

- signo `+` indica el ultimo proceso.
- signo `-` indica el penúltimo proceso.
- `[1] ` número de proceso en background.

Jobs esta asociado a una sesion de trabajo
La orden que esta en background no tiene que generar salida en stdout ni stderr, porque al mostrar por la terminal el resultado te molesta en la ejecución de los siguientes comandos.
Los programas que están en background no pueden utilizar stdin

Para traer de foregraund a background `fg %2` número de proceso si quieres luego que vuelva a backgroud `Ctrl Z`  y se muestra como stopped  y se pueden reanudar ( poner en running ) con `bg`.
Otra manera de parar un proceso en background es con la señal stoped SIGSTOP `kill -19 %5`  

***Ejemplo:***    

```bash  
# creo tres procesos en backgroud
debian  ➜  sleep 12345678 &
[1] 1886
debian  ➜  sleep 12345678 &
[2] 1895
debian  ➜  sleep 5555555 & 
[3] 1967
# compruebo
debian  ➜  jobs
[1]    running    sleep 12345678
[2]  - running    sleep 12345678
[3]  + running    sleep 5555555
# traigo a forgraund el proceso 3 
debian  ➜  fg %3
[3]  - 1967 running    sleep 5555555
# lo vuelvo a mandar a background con Ctrl Z
^Z
[3]  + 1967 suspended  sleep 5555555
# Al mandarlo a background se suspende
debian  jobs
[1]    running    sleep 12345678
[2]  - running    sleep 12345678
[3]  + suspended  sleep 5555555
# reactivo  el proceso
debian  ➜  bg %3
[3]  - 1967 continued  sleep 5555555

debian  ➜  curs git:(master) ✗ jobs
[1]    running    sleep 12345678
[2]  + running    sleep 12345678
[3]  - running    sleep 5555555

```

<br> 

## bacgkround des-asociado

Para realizar un proceso y des-asociarlo de nuestra sesión se puede utilizar `nohup` , este comando te permite lanzar un comando des-asociado y así poder cerrar tu sesión, que el comando seguirá ejecutándose hasta que acabe o apagues el pc.

> Útil para backups  



Obviamente el comando no puede tener stdout ni stderr

`nohup du -h / > du.txt 2> /dev/null &   ` 

```bash
debian  ➜  nohup sleep 1547857 &
[1] 7033
nohup: se descarta la entrada y se añade la salida a 'nohup.out'    

# una vez cerrada la sesión y avierta otra
debian  ➜  ps ax | grep sleep
 7033 ?        SN     0:00 sleep 1547857
```



Con `disown` podemos des-asociar un proceso que este en background.

```bash   
disown -a # todos los procesos en backgroud
disown %3 #  proceso especifico

debian  ➜ ps ax | grep  sleep
 1886 pts/1    SN     0:00 sleep 12345678
 1895 pts/1    SN     0:00 sleep 12345678
 1967 pts/1    SN     0:00 sleep 5555555
 
debian  ➜  disown %3

# cierro y abro otra sesión
debian  ➜  ps ax | grep sleep  
 1967 ?        SN     0:00 sleep 5555555
```

<br>

## uptime 

Muestra la hora y el tiempo que está encendida la máquina, cuantos usuarios conectados y el promedio de uso de la cpu ( un promedio de rendimiento)

## Top

Nos muestra los procesos que hay en marcha

Atributos del top

- top -p < número de identificador del proceso > 

- - muestra sólo esa línea

- top -d < se refresca cada número de segundos que introduzcas >

- top -n < sale del top al actualizar el número de veces que le has indicado.>

Dentro del top tiene otros atributos.

- p → ordena por cpu
- m → ordena por memoria
- shit + L → filtra por lo que escribas  

También tenemos la opción de htop

Básicamente es lo mismo pero más claro y con ciertas opciones en la parte inferior como matar procesos, subir o bajar prioridad, filtrados, etc…

iotop → lista procesos y transferencia de Bytes que escribe o lee en la cpu 



## Prioridades

Las prioridades son la importancia que le da el kernel a los procesos para ejecutarse.

Nos es útil si queremos que un programa vaya más o menos rápido según el momento.

La prioridad va de:

- Máxima -20
- Mínima +19
- Por defecto 0

Formas de cambiar prioridades.

nice nos permite cambiar prioridades mediante un comando y si queremos renombrar la prioridad utilizaremos renice

```bash
nice -n <NºPrioridad> -p <proceso>                                                             
```

**htop** también nos permite cambiar prioridades con las opciones inferiores nice+F8 y nice-F7

Modo gráfico tenemos monitor de sistema, te muestra los procesos gráficamente



