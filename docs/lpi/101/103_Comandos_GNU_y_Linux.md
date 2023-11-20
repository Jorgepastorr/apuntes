# 103 Comandos GNU y Linux



## Entorno de ejecucion en bash

`set` muestra o modifica la configuración de nuestro entorno. Sin parametros visualiza variables del sistema y con `-o` una lista de las opciones y sus estados. 

`export` crea o modifica variables de entorno `export NOMBRE=jorge`

`unset` Elimina una variable del entorno `unset NOMBRE`

`env` Sin parametros muestra variables de entorno. Lo podemos usar para  ejecutar un comando modificando el valor de variables de entorno `env PATH=/new/path /bin/bash`

```bash
set -o	# mostrar estado de las opciones
set +o history	# desactivar historial
set -o history	# activar historial
```



## Procesar secuencias texto usando filtros



### cut

**Cut** muestra sólo una parte de cada linea. hace un corte en vertical

`-c` recorta teniendo en cuenta caracteres y `-f` tiene en cuenta columnas , por defecto cut delimita ppor tabuladores pero con `-d` se puede modificar

```bash
cut -c 1,2 /etc/passwd # muestra el caracter 1 y 2 de todas las lineas
cut -c -3 /etc/passwd	# mestra del  primer caracter al tercero
cut -c 2- /etc/passwd	# mestra del segundo al final de linea
cut -c 2-4 /etc/passwd	# muestra del segundo al cuarto caracter

# muestra fila 1 y 2 delimitando las filas por :
cut -d":" -f 1,2
```



### wc

wc cuenta lineas, bytes, caracteres y palabras

```bash
➜ wc /etc/passwd
  57   87 3133 /etc/passwd

➜ wc -l /etc/passwd
57 /etc/passwd

➜ wc -m /etc/passwd
3133 /etc/passwd

➜ wc -w /etc/passwd
87 /etc/passwd

➜ wc -
--bytes            -c  -- print byte counts             
--chars            -m  -- print character counts        
--lines            -l  -- print line counts
--max-line-length  -L  -- print longest line lengths
--words            -w  -- print word counts           
```



### rev

rev invierte las lineas de caracteres

```bash
➜ cat pr_rev 
/share/doc/mydoc
/doc/otherdoc
/usr/share/doc/masdoc

➜ rev pr_rev 
codym/cod/erahs/
codrehto/cod/
codsam/cod/erahs/rsu/

➜ rev pr_rev | cut -d"/" -f1 | rev
mydoc
otherdoc
masdoc
```



### tr

tr sustitulle letras, en sus filtros también acepta caracteres especiales como `\t`  o clases.

```bash
➜ echo "casa" | tr "a" "e"
cese

➜ echo "casa" | tr -d "a" 
cs

➜ echo "caaasaaaa" | tr -s "a" 
casa

➜ echo "Mi    casa    tiene 10 lamparas" | tr -s "[:blank:]" " "
Mi casa tiene 10 lamparas

➜ echo "Mi casa tiene 10 lamparas" | tr "[:alpha:]" "X"
XX XXXX XXXXX 10 XXXXXXXX

➜ echo "Mi casa tiene 10 lamparas" | tr "[:digit:]" "X"
Mi casa tiene XX lamparas
```



Tipos de **clases**: representan un conjunto predefinido de caracteres

| clases     | descripcion                                              |
| ---------- | -------------------------------------------------------- |
| [:alnum:]  | Las letras y Dígitos                                     |
| [:alpha:]  | Letras                                                   |
| [:blank:]  | Espacios en Blanco                                       |
| [:cntrl:]  | Caracteres de control                                    |
| [:space:]  | Los Espacios en Blanco verticales y horizontales         |
| [:graph:]  | Caracteres imprimibles, sin incluir el Espacio en Blanco |
| [:print:]  | Caracteres imprimibles, incluyendo el Espacio en Blanco  |
| [:digit:]  | Dígitos                                                  |
| [:lower:]  | Letras minúsculas.                                       |
| [:upper:]  | Letras mayúsculas.                                       |
| [:punct:]  | Signos de puntuación.                                    |
| [:xdigit:] | DígitosHexadecimales.                                    |



### nl

nl muestra el contenido de un fichero de texto añadiendo el numero de linea. Por defecto no cuenta las lineas en planco (para eso añade `-b a`)

```bash
➜ nl texto 
     1	Yo sé que existo
     2	Porque tú me imaginas.
       
     3	Soy alto porque tú me crees
     4	Alto, y limpio porque tú me miras
     5	Con buenos ojos,
     6	Con mirada limpia.
       
➜ nl -b a texto
     1	Yo sé que existo
     2	Porque tú me imaginas.
     3	
     4	Soy alto porque tú me crees
     5	Alto, y limpio porque tú me miras
     6	Con buenos ojos,
     7	Con mirada limpia.
     8	
```

```bash
a	# numera todas las lineas
t   # numera solo lines con contenido(opcion default)
```



### od

od muestra un fichero en formato numerico octal

```bash
➜ od texto 
0000000 067531 071440 124703 070440 062565 062440 064570 072163
0000020 005157 067520 070562 062565 072040 135303 066440 020145
...

➜ od -c text
0000000   b   z   c   a   t  \n   c   a   t  \n   c   u   t  \n   h   e
0000020   a   d  \n   l   e   s   s  \n   m   d   5   s   u   m  \n   n
...
```

En ocasiones es útil ver los caracteres ocultis de un archivo como el salto de línea, con la opción `-c` se muestran.

### split

split divide un fichero en varios  según unos limites

```bash
split -l 5 texto d1 # divide el archivo en archivos de 5 lineas
split -b 50 texto d1 # divide el archivo en archivos de 50 bytes
split -C 50 texto d1 # divide el archivo en archivos de 50 bytes sin partir lineas

➜ ll
total 64K
-rw-r--r-- 1 debian debian   43 feb 19 12:46 d1aa
-rw-r--r-- 1 debian debian   29 feb 19 12:46 d1ab
-rw-r--r-- 1 debian debian   35 feb 19 12:46 d1ac
-rw-r--r-- 1 debian debian   38 feb 19 12:46 d1ad
-rw-r--r-- 1 debian debian  145 feb 19 12:34 texto

➜ cat d1* > texto2 # reagrupar archivos divididos
➜ diff texto texto2
```



### paste

paste concatena linea a linea la informacion de dos ficheros

```bash
➜ cat notas 
1
2
5
9
➜ cat nombres 
juan
anna
pedro
lucia

➜ paste nombres notas 
juan	1
anna	2
pedro	5
lucia	9
```



### cat

Cat esta diseñado para visualizar archivos pero entre otras cosas, tiene la particulidad de visualizar archivos comprimidos, aquí se muestran algunas de las  opciones

```bash
➜ gzip -c texto > texto.gz
➜ zcat texto.gz 
Yo sé que existo
Porque tú me imaginas.
...

➜ bzip2 -z texto
➜ bzcat texto.bz2 
Yo sé que existo
Porque tú me imaginas.
...

➜ xz texto
➜ xzcat texto.xz 
Yo sé que existo
Porque tú me imaginas.
...

cat -b file.txt # numerar lineas del contenido
```



### checksum 

Podemos obtener una marca digital de la información de un fichero. Será basada en su contenido, mientras el contenido no sea modificado la marca siempre será la misma.

Algunas opciones para crer marcas:

- md5sum (md5 obsoleto)

- sha256sum (sha es mejor, cuantos más bit, mas fuerte)

- sha512sum

```bash
$ sha256sum text 
d3f8ac7a0b45657fdd4f2e1f55a0d8f7b4fc9341eb94b2fcf1f6551bac37e133  text

$ sha256sum text > sha256.txt
$ sha256sum -c sha256.txt
text: La suma coincide
```

Esto se suele utilizar para vrificar paquetes descargados o transferidos de alguna manera.



## Administración básica de archivos

uso  de comandos `rm, cp, mv, mkdir, touch`



### tar

opciones para copia de seguridad

- Totales: se copian todos los datos

- Diferenciales: se copian sólo los que se hayan modificado desde una fecha indicada. Se utiliza la opción `-N` seguido de la fecha
- incrementales: se copian sólo los ficheros que se han modificado desde la última copia. Se utiliza la opción `-g` seguido de la ruta del fichero de registro.

```bash
-c # comprime
-x # descomprime
-z # gzip
-J # xz
-j # bzip2
-p # conserva permisos
-h # conservar softlinks
-v # muestra informacion vervose
-P # conserva ruta absoluta
-f # referencia a archivos       
-r # añade elementos a un fichero compacto
-t # ver interior tar
-u # añadir archivo a tar
--exclude # Excluir directorio o fichero
--delete # borrar ruta del interior del tar
```

```bash
tar cf file.tar files*
tar xf file.tar

tar czf file.tar.gz files*
tar xzf file.tar.gz

find /etc -type f -print0 | tar -cJ -f /srv/backup/etc.tar.xz -T - --null
```

La opción `-T` indica que son nombres extraidos de un fichero o comando, y la opción `--null` que el caracter separador es nulo.

### cpio

cpio tiene una función parecida a `tar`. Copia ficheros  y desde n solo archivo. Utiliza la enttrada y salida estándar para el origen y destino de datos.

```bash
-o	# crear un archivo  con el contenido que le indiquemos
-i 	# extrae el contenido de un fichero
-p	# copia una estructura de directorios a otro lugar

find /etc/ | cpio -o > copia_etc.cpio
cpio -i < copia_etc.cpio

find /etc/ | cpio -o | gzip > copia_etc.cpio.ggz
```



### dd

dd copia información a bajo nivel.

```bash
if=origen
of=destino
bs 	# tamaño del bloque a copiar
count	# cantidad de bloques a copiar

dd if=/dev/sdb1 of=/home/alumno/usb.img
dd if=/dev/zero of=fichero bs=1M count=100
```

El comando `dd` normalmente no mostrará nada en la pantalla hasta que el comando haya finalizado. A l proporcionar la opción `status=progress`, la consola mostrará la cantidad de trabajo que realiza el comando. Por ejemplo: `dd status=progress if=oldfile of=newfile`.



### comprimir

Hay varios comandos para comprimir y descomprimir ficheros. El funcionamiento básico es el mismo en los más conocidos: `gzip, bzip, xz`

Si indicamos comprimir el archivo original desaparece, para conservar el original indicamos la opción `-k`. para descomprimir se indica la opción `-d` o el comando `gunzip, bunzip, unxz`

| comprimir       | descomprimir       |                    |
| --------------- | ------------------ | ------------------ |
| gzip fichero    | gzip -d fichero.gz | gunzip fichero.gz  |
| bzip -k fichero | bzip -d fichero.bz | bunzip  fichero.bz |
| xz -k fichero   | xz -d fichero.xz   | unxz  fichero.xz   |

Tambien esta la opción de descomprimir mezclando comandos.

```bash
bzcat file.tar.gz2 | tar -xvf -
```



## Uso secuencias de texto, tuberias y redireccionamiento

Los procesos estándar de Linux tienen tres canales de comunicación  abiertos de manera predeterminada: el canal de entrada estándar (la  mayoría de las veces llamado simplemente *stdin*) `0`, el *canal de salida* estándar (*stdout*) `1` y el *canal de error* estándar (*stderr*)`2`.   Los canales de comunicación también son accesibles a través de los dispositivos especiales `/dev/stdin`, `/dev/stdout` y `/dev/stderr`.

### redireccion

La redirección se utiliza para gestionar según que salidas queramos obtener. En ocasiones se quiere redireccionar una salida a un archivo o  simplemente descartarla

```bash
>	# redirige salida estandar reescribiendo el final
>>	# redirige salida estandar añadiendo
2>	# redirige stderr
2>>
&>	# redirige stdout y stderr
&>>
>&2	# redirige stdout a stderr
2>&1	# redirige stderr a stdout
<<EOF	# stdin hasta contener una linea con EOF
<<< "cadena de texto" # enviar a stdin una cadena y finalizar
```

### tuberias

Las tuberias son muy utiles para enlazar comandos con la salida del anterior

```bash
➜ du -sh /* 2> /dev/null | sort -h | tail -1
73G	/var
```



### tee

El comando `tee` recoge la salida estandar y duplica la salida de la información ya que guarda en un fichero y también  la envia por salida estándar.

```bash
➜  uptime | tee info_lunes.txt
 10:58:40 up  2:59,  1 user,  load average: 0,56, 0,57, 0,52
➜  cat info_lunes.txt 
 10:58:40 up  2:59,  1 user,  load average: 0,56, 0,57, 0,52
```



### xargs

El comando `xargs` permite ejecutar cualquier comando usando como parámetros la información que recoge de una tubería.

```bash
-d	# establece un delimitador para dividir la cadena de entrada
-t	# muestra la orden antes de ejecutarla
-p	# pregunta antes de ejecutar cada orden
-I 	# permite definir donde se van a poner los parametros
```



ejemplos:

```bash
echo pera manzana uva | xargs touch
# se transforma en:
touch pera manzana uva

# hacer copia de ficheros mayores de 5M de /root a backups
find /root/ -type f -size +5M | xargs -I ARG cp ARG /backups/

# crear directorios con los nombres de los ultimos 5 usuarios
tail -5 /etc/passwd | cut -d":" -f1 | xargs mkdir
```



## Crear, supervisar y matar procesos

los procesos son las tareas que va ejecutando nuestro pc, por ejemplo si abres una pestaña del navegador, una terminal y muchos otros que se ejecutan en segundo plano.

Para visualizar tenemos diversos comandos:

```bash
ps		# visualizar
pstree	 # visualizar en arbol
pgrep	# visualizar pid y nombre
pidof	# visualizar pid de proceso
top		# visualizar en tiempo real
htop
```

cada uno tiene sus opciones

```bash
ps 
-u # formato orientado a usuario
-a # procesos conectados tty actual
-x # procesos que no estan conectado a un tty
-aux # opcion mas usual  


pstree -ps <num proceso>  
-p  # proceso
-s  # arbol  
-a  # mostrar todo sin agrupaciones

pgrep
-u 	# usuario
-l	# mostrar proceso
-d	 # delimitador stdout

➜ pgrep  -u debian -l "^Web*"
8282 WebExtensions
16688 Web Content
16734 Web Content
17580 Web Content
➜ pgrep  -u debian  "^Web*" -d , 
8282,16688,16734,17580
```



### Matar procesos

kill envia señales, las señales se envian entre procesos `kill -l` lista los diferentes tipos de señales disponibles

- 15 SIGTERM ( señal terminar procesos, es la señal por defecto de kill)
- 9 SIGKILL  ( señal matar ) Solo si se queda colgado, puedes perder información al matar a lo bestia.
- 19 y 20 (señal stop ) parar un proceso, poner en pausa
- 18 (CONT) reanudar un proceso parado

```bash
kill <numero proceso>
killall <nombre proceso>
pkill <nombre proceso>
killall -u user1 # matar todos los procesos de un usuario especifico
kill %2 # matar segundo proceso de backgroud
xkill # (clicar con el cursor encima ventana)
```



### Procesos en segundo plano

Ejecutar ordenes en segundo plano con `&` al final de la orden. Hay que tener en cuenta  que el proceso en segundo plano no a de tener salida estandar y si la tiene hay que redirigirla.

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
- `[1]` número de proceso en background.

```bash
-l	# muestra ID de proceso (PID)
-p	# muestra ID de proceso
-r	# procesos en ejecución
-s	# procesos detenidos
%sl	# filtra trabajos que empiecen por "sl" en el omando
%?le	# filtra trabajos que contengan "le"
```



Para traer de foregraund a background `fg %2` número de proceso si quieres luego que vuelva a backgroud `Ctrl Z`  y se muestra como stopped  y se pueden reanudar ( poner en running ) con `bg`. Otra manera de parar un proceso en background es con la señal stoped SIGSTOP `kill -19 %5`  

```bash
➜  ~ sleep 77777 &
[1] 18991

➜  ~ jobs
[1]  + running    sleep 77777

# traigo proceso a primer plano con fg
➜  ~ fg %1
[1]  + 18991 running    sleep 77777

# suspendo proceso con ctrl+z
^Z
[1]  + 18991 suspended  sleep 77777

➜  ~ jobs 
[1]  + suspended  sleep 77777

# reanudo proceso en segundo plano
➜  ~ bg %1
[1]  + 18991 continued  sleep 77777

➜  ~ jobs 
[1]  + running    sleep 77777

# mato proceso
➜  ~ kill %1
[1]  + 18991 terminated  sleep 77777                                                       
```



### Proceso desasociado

Con nohub permite desasociar un proceso de la sesión actual, así se podrá cerrar la sesión y el comando  seguira en marcha.

```bash
➜  nohup sleep 1547857 &
[1] 7033
nohup: se descarta la entrada y se añade la salida a 'nohup.out'    

# una vez cerrada la sesión y avierta otra
➜  ps ax | grep sleep
 7033 ?        SN     0:00 sleep 1547857
```



### Prioridades

Linux reserva prioridades estáticas que van de 0 a 99 para procesos en  tiempo real y los procesos normales se asignan a prioridades estáticas  que van de 100 a 139, lo que significa que hay 39 niveles de prioridad  diferentes para procesos normales.  Los valores más bajos significan una prioridad más alta. La prioridad  estática de un proceso activo se puede encontrar en el archivo `sched`, ubicado en su directorio respectivo dentro del sistema de archivos `/proc`:

```bash
$ grep ^prio /proc/1/sched
prio                   :       120
```

Las prioridades mostradas por `ps` varían de -40 a 99 por defecto, por lo que la prioridad real se obtiene agregando 40 (en particular, 80 + 40 = 120).

```bash
$ ps -el
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0     1     0  0  80   0 -  9292 -      ?        00:00:00 systemd
4 S     0    19     1  0  80   0 -  8817 -      ?        00:00:00 systemd-journal
...
```



#### Niceness de Procesos

Todo proceso normal comienza con un valor *nice* predeterminado de 0 (prioridad 120).  La columna `NI` en la salida de `ps` indica el número *nice*.

Nos es útil si queremos que un programa vaya más o menos rápido según el momento.

La prioridad va de:

- Máxima -20
- Mínima +19
- Por defecto 0

Formas de cambiar prioridades.

nice nos permite cambiar prioridades mediante un comando y si queremos renombrar la prioridad utilizaremos renice

```bash
nice -n prioridad comando
renice -n prioridad  PID

nice comando # prioridad por defeccto 10
```

Es posible cambiar la prioridad a los procesos de un usuario o grupo, el siguiente ejemplo cambia la prioridad de todos los procesos del grupo users a 5.

```bash
renice +5 -g users
-g	# grupo
-u	# user
```



Una forma de ver la proridad es la columna de `NI` de ps

```bash
➜ ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S  1000  8634  8596  0  80   0 -  3866 -      pts/0    00:00:00 zsh
4 R  1000 10092  8634  0  80   0 -  2637 -      pts/0    00:00:00 ps
```

**htop** también nos permite cambiar prioridades con las opciones inferiores nice+F8 y nice-F7

Modo gráfico tenemos monitor de sistema, te muestra los procesos gráficamente



## Expresiones regulares

[web practica de regex](https://regexone.com/) 

```bash
^    # principio dev linea
$    # final de linea
[]      # lista que contenga [aei] a,e,i
[0-9a-Z] # rangos
[^]    # lista que no contenga
.    # un caracter
 *    # junto al caracter anterior 0 o n veces 
.*    # 0 o cualquier caracter
{}    # numero de repeticiones {n}{n,m}{n,}{,n}
?    # reperticion del caracter anterior cero o una vez
+    # reperticion del caracter anterior una o mas veces
```

abreviaturas

```bash
\w	# cualquier caracter alfanumerico y el guion bajo
\W	# lo contrario a \w, signos de puntuación, epacios, etc...
```

limites de palabra

```bash
\<	# inicio de palabra
\>	# fin de palabra
\b	# limite de palagra (inicio o fin)
\B	# lo contrario a \b
\s	# espacio en blanco
\S	# cualquier caracter menos espacio
```



### grep

```bash
grep 
-i # ignore case ( ignorar casec sensitive )
-v # invert match ( revertir busquerda )
-n # numero de lineas
-E # aceptar expresiones regulares {}, |, [], etc... o egrep
-l # solo indica el nombre del fichero donde ha encontrado alguna coincidencia
-w # el patron es una palabra independiente
-r # busqueda recursiva
-c # muestra el numero de coincidencias
-H # muestra tambien el nombre del archivo que coincide
-o # solo mostrar coincidencia
```



### sed

```bash
-n	# suprimir salida estandar
-e	# indica que se ejecute el script que viene a continuacion.
	# si no se emplea la opción -f se puede omitir -e
-f	# las ordenes se tomaran de un archivo
-r	# utilizar expresiones regulares
-i	# guardar cambios

i\	# insertar linea antes de la linea actual
a\	# insertar linea despues de la linea actual
c\	# sustitulle linea por la especificada a continuacion
d	# borrar linea actual
p	# imprimir linea actual, salida estandar
s	# sustituir
!	# aplicar instruccion a las lineas no coincidentes
q	# abandonar proceso al alcanzar cierta linea
```

```bash
sed <seleccio de linies> 's/<que busco>/<por que cambio>/<numero de veces>'
```



```bash
# sustituir una vez
sed 's/mama/papa/'

# sustituir recursivamente
sed 's/mama/papa/g'

# desde la linea 3 hasta el final  
sed '3,$ s/bin/BIN/g' text

# desde linea 1 hasta 7 incluida
sed '1,7 s/bin/BIN/g' text

# sustitulle en las lineas que contengan elfo, bin por BIN
sed '/elfo/ s/bin/BIN/g' text

# desde la linea que contenga capitulo 1 hasta capitulo 2 sustituye bin por BIN
sed '/capitulo 1/,/capitulo 2/ s/bin/BIN/g' text

# desde la linea que contenga  capitulo 2 hasta el final
sed '/capitulo 2/,$ s/bin/BIN/g' text
```

**Sed con expresiones** 

```bash
# dejar linea 3 en blanco
sed '3 /^.*$//g'

# eliminar el primer campo
echo "Nom:Cognom:Adreça:email"  | sed 's/^[^:]*://g'  
Cognom:Adreça:email

# Reordenar primer y segundo campo. "\1 y \2" se refiere a parentesi 1 y 2
echo "Nom:Cognom:Adreça:email"  | sed -r 's/^([^:]*):([^:]*):/\2:\1:/g'  
Cognom:Nom:Adreça:email

# eliminar un campo y redistribuir los otros.
echo "Nom:Grup:Nota"  | sed -r 's/^([^:]*):([^:]*):(.*)$/\3--\1/g'   
Nota--Nom

# modificar un valor. "&" se refiere al contenido a substituir
echo "Nom:Grup:Nota"  | sed -r 's/Grup/ASI-&/g'  
Nom:ASI-Grup:Nota

# utilizando variables 
NOMBRE="Jorge"
echo "Nom:Grup:Nota"  | sed -r "s/Nom/$NOMBRE/g"  
Jorge:Grup:Nota

# poner separador de millares
echo "45200"  | sed -r "s/[0-9]{3}$/.&/g"   
45.200
```

```bash
sed -r -e 's/(^[^.]*)\.(crt|key)$/cat \1.\2/e' < client.template > client.ovpn
```

reemplaza cualquier línea que termine en `.crt` o `.key` por el contenido de un archivo cuyo nombre es igual a la línea. La opción `-r` indica a `sed` que use expresiones regulares extendidas, mientras que `s` al inicio de la expresion indica remplazar `/OLDpatern/NewPatern/`, la `e` al final de la expresión indica que ejecute `cat \1.\2`  en el bash y el resulado se adiera como input en el `NewPatern`



## Terminales multiplexores

### screnn

```bash
ctrl + a w	# ver listado ventanas
ctrl + a c	# crear ventana nueva
ctrl + a A	# camviar nombre a ventana

# moverse entre ventanas
ctrl + a p	# anterior
ctrl + a numero
ctrl + a "	# lista de ventanas

ctrl + a S	# crear region horizontal
ctrl + a L	# crear region vertical
ctrl + a tab	# cambiar region

ctrl + a k	# matar ventana
ctrl + a X	# matar region
ctrl + a Q	# matar todas las regiones excepto actual

ctrl + a d	# salir y dejar en segundo plano
```



```bash
screen -list	# listar sesiones abiertas
screen -ls
screen -S "second sesion"	# crear sesion con nombre
screen -S ID -X quit	# matar sesion
screen -r session-id	# entrar en una sesion abierta
```

Copiar  texto

1. Ingrese al modo de copia/scrollback: `Ctrl+a-[`.
2. Vaya al principio del texto que desea copiar usando las teclas de flecha.
3. Marque el comienzo del fragmento de texto que desea copiar: Espacio.
4. Vaya al final del fragmento de texto que desea copiar usando las teclas de flecha.
5. Marque el final del fragmento de texto que desea copiar: Espacio.
6. Vaya a la ventana de su elección y pegue el fragmento de texto: `Ctrl+a-]`.



### tmux

```bash
ctrl + b c	# crear ventana
ctrl + b ,	# cambiar nombre ventana
ctrl + b d	# detach

ctrl + b n	# siguiente
ctrl + b p	# anterior
ctrl + b numero

ctrl + b &	# cerrar ventana
ctrl + b x	# cerrar region

ctrl + b "	# dividir horizontalmente
ctrl + b %	# dividir verticalmente
ctrl + b flecha	# moverse entre subventanas

ctrl + b z	# zoom, max y min
ctrl + b s	# cambiar de sesion
ctrl + b $	# cambiar nombre sesion
```

```bash
tmux	# iniciar una sesion
tmux ls	# ver sesiones abiertas
tmux new -s "LPI" -n "Window zero"	# crear sesion con nombre de sesión y ventana
tmux kill-session -t "Second Session" # matar sesion abierta
tmux a -t ID-sesion	# acceder a sesion abierta
```

Copiar  texto

1. ingrese al modo de copia/scrollback: `Ctrl+a-[`.
2. Vaya al principio del texto que desea copiar usando las teclas de flecha.
3. Marque el comienzo del fragmento de texto que desea copiar: `Ctrl + espacio`.
4. Vaya al final del fragmento de texto que desea copiar usando las teclas de flecha.
5. Marque el final del fragmento de texto que desea copiar: `alt + w`.
6. Vaya a la ventana de su elección y pegue el fragmento de texto: `Ctrl+a-]`.

