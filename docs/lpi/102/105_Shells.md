# 105 Shells



## Personalizar y usar el entorno de shell

Existen diferentes tipos de shell y estas tienen diversos archivos para configurar. Lo primero que hace Bash, o cualquier  otro shell, es ejecutar una serie de scripts de inicio. Estos scripts  personalizan el entorno de  la sesión. Hay secuencias de comandos  específicas para el usuario y  para todo el sistema. Podemos poner  nuestras preferencias o  configuraciones personales que mejor se adapten a las necesidades de  nuestros usuarios en estos scripts en forma de  variables, alias y  funciones.



**Shell con inicio de sesión / Shells sin inicio de sesión**. Este tipo de shell se refiere al caso de que un usuario acceda a un  sistema informático proporcionando sus credenciales, como nombre de  usuario y  contraseña.

**shell interactivas / shell no interactivas**. Este  tipo de shell se refiere a la interacción que tiene lugar entre el  usuario y el shell: el usuario proporciona entrada escribiendo  comandos en el terminal usando el teclado; el shell proporciona salida   imprimiendo mensajes en la pantalla.



Tanto los shells interactivos como los no interactivos pueden ser  de  inicio de sesión o sin inicio de sesión y cualquier combinación  posible  de estos tipos tiene sus usos específicos.

- shell **interactivo con inicio de sesión** es el típico  al iniciar el sistema e iniciar sesión
- shell **interactivo sin inicio de sesión** se refiere a otro shell abierto cuando ya se a iniciado sesión, por ejemplo al ejecutar `bash` en un terminal.
- shell **no interactivo sin inicio de sesión** , no requieren de interacción humana, son usados para automatización de tareas, etc..
- shell **no interactivo con inicio de sesión**, son muy raros y poco prácticos. Sus usos son prácticamente inexistentes. `/bin/bash --login <script>`



lanzamiento de shells:

```bash
bash -l o bash --login	# invocar shell de inicio de sesión
bash -i					# invocar shell interactivo
bash --noprofile		# con shell de inicio de sesion, ignora archivos de configuración(todos)
bash --norc				# con shell interactivos, ignora archivos de configuración(toda)
bash --rcfile <file>	# con shell interactivo, re,mplaza configuración
```



### archivos de configuración

**Nivel global** 

- `/etc/profile /etc/profile.d`  se ejecuta para cada usuario que inicia sesión. Se usa para  iniciar configuración de entorno, mostrar mensajes, etc..

- `/etc/bashrc /etc/bash.bashrc` afecta a todos los usuarios del sistema. su propósito también es crear elementos que deben estar en todos los shell

**Nivel local**

- `~/.bash_profile ~/.bash_login ~/.profile` archivo de usuario que le permite personalizar el shell según sus preferencias 

>  Si los archivos `~/.bash_profile ~/.bash_login` existen `~/.profile` no se ejecutará

- `~/.bashrc`  archivo de usuario, se usa para crear elementos que el usuario quiere tener en cada shell como variables locales, alias, ...
- `~/.bash_aliases` este archivo se usa normalmente para almacenar los alias y funciones específicos de los usuarios.

Los archivos de nivel local se generan a partir de la plantilla que encontramos en `/etc/skel`, esta directorio se utiliza como plantilla al crear un nuevo usuario. `SKEL`y otras variables relacionadas se almacenan en `/etc/adduser.conf`, que es el archivo de configuración para `adduser`:

```bash
user2@debian:~$ ls -a /etc/skel/
.  ..  .bash_logout  .bashrc  .profile
```



### su y sudo

`su`  Cambie el ID de usuario o conviértase en superusuario ( `root`). Con este comando podemos invocar shells tanto de inicio de sesión como  de no inicio de sesión: 

```bash
# iniciará un shell de inicio de sesión interactivo como user2.
su - user2
su -l user2
su --login user2 

# iniciará un shell interactivo sin inicio de sesión como user2. 
su user2 
```

​             

`sudo`   Ejecute comandos como otro usuario (incluido  el superusuario). Debido a que este comando se usa principalmente para  obtener privilegios de  root temporalmente, el usuario que lo usa debe  estar en el `sudoers` archivo. 

```bash
sudo -u user2 -s	#  iniciará un shell interactivo sin inicio de sesión como user2.
sudo -i 	# iniciará un shell de inicio de sesión interactivo como root.
sudo -i <some_command> # iniciará un shell de inicio de sesión interactivo como root, ejecutará el comando y volverá al usuario original.
sudo -s o sudo -u root -s # iniciará un shell sin inicio de sesión como root.
```

> Al usar `su` o `sudo`, es importante considerar nuestro escenario de caso particular para   iniciar un nuevo shell: ¿Necesitamos el entorno del usuario de destino o no?



### Tipo de shell

Para averiguar en qué tipo de shell estamos trabajando, podemos escribir `echo $0`en la terminal y obtener el siguiente resultado:

```bash
-bash o -su 		# Inicio de sesión interactivo
bash o /bin/bash	# Sin inicio de sesión interactivo
<name_of_script>	# Sin inicio de sesión ni interactivo (scripts)
```



### source o .

Podemos invocar un script o un fichero de configuración  anteponiendo a la ruta del fichero la palabra `source` o un simple `.` , esto es similar a importar un modulo en lenguaje de programación.

Esto indica que se  ejecute en *aprovisionamiento*, o lo que es lo mismo, que no se cree otro subshell. Lo que implica:

- tendrá acceso a las variables del shell que lo lanzó aunque no se hayan exportado

- si crea una variable estará disponible en el shell que lanzó

```bash
# vemos vcontenido del script y que la variable nombre no existe
➜ cat script.sh 
#!/bin/bash
nombre=jorge

➜ echo $nombre

# invocamos el script y vemos como aparece la variable
➜ . ./script.sh 
➜ echo $nombre      
jorge
```

> Si en vez de `.` utilizamos `source` para invocar, es exactamente lo mismo.



### Variables

Piense en una variable como un cuadro imaginario en el que colocar temporalmente un dato.  Bash clasifica las variables como *shell/local* (aquellas que viven solo dentro de los límites del shell en el que fueron creadas) o *entorno/global* (aquellas que son heredadas por shells y/o procesos secundarios) 

El nombre de una variable puede contener letras ( `a-z`, `A-Z`), números ( `0-9`) y guiones bajos ( `_`), pero no puede empezar por un número:

```bash
$ distro=zorinos
$ DISTRO=zorinos
$ distro_1=zorinos
$ _distro=zorinos

$ 1distro=zorinos
-bash: 1distro=zorinos: command not found
```

Con respecto a la referencia o valor de las variables, también es importante considerar una serie de reglas.

Las variables pueden contener caracteres alfanuméricos ( `a-z`, `A-Z`, `0-9`), así como la mayoría de los otros caracteres ( `?`, `!`, `*`, `.`, `/`, etc.). Si los valores contienen espacios, símbolos de redirección o barra vertical (`< > | `) tienen que ir entre comillas. También hay que tener en cuenta que las comillas simples y dobles tienen diferente significado.

```bash
$ distro=zorin12.4?
$ distro="zorin 12.4"
$ distro=">zorin"

$ mypath="$PATH"
$ echo $mypath
/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/snap/bin
$ mypath='$PATH'
$ echo $mypath
$PATH
```



Las **variables locales** o de shell existen solo en el shell en el que se crean. Por convención, las variables locales se escriben en minúsculas.

```bash
set 	# ver variables locales
```



Existen **variables globales** o de entorno para el shell actual, así como para  todos los procesos posteriores generados a partir de él. Por convención, las variables de entorno se escriben en mayúsculas.

una variable local se convierte en global utilizando `export`

```bash
export variable		# pasar variable local a global
declare -x variable	# igual al anterior
export -n variable		# pasar variable global a local

declare -r var=value	# crear variable read-only
export variable=valor	# crear variable global

unset var var2 var3		# eliminar variable
unset -v variable	# eliminar variable
env -u var			# eliminar variable
unset -f funcion	# eliminar función

export -p	# ver variables de entorno
env			#	""
printenv	#	""
```



#### Variables communes

`DISPLAY` En relación con el servidor X, el valor de esta variable normalmente se compone de tres elementos: `host separador pantalla` 

```bash
$ printenv DISPLAY
:0
```

Un valor vacío para esta variable significa un servidor sin un sistema X Window. Un número adicional, como en `my.xserver:0:1` , se referiría al número de pantalla si existe más de uno.

`HISTCONTROL`  Esta variable controla qué comandos se guardan en `HISTFILE`(ver más abajo). Hay tres valores posibles: `ignorespace, ignoredups, ignoreboth`

`HISTSIZE` Esto establece el número de comandos que se almacenarán en la memoria mientras dure la sesión de shell.

`HISTFILESIZE` Esto establece la cantidad de comandos que se guardarán `HISTFILE`tanto al inicio como al final de la sesión.

`HISTFILE` El nombre del archivo que almacena todos los comandos a medida que se escriben. De forma predeterminada, este archivo se encuentra en `~/.bash_history`

`HOME` Esta variable almacena la ruta absoluta del directorio de inicio del usuario actual y se establece cuando el usuario inicia sesión.

`HOSTNAME` Esta variable almacena el nombre TCP/IP de la computadora host

`HOSTTYPE` Esto almacena la arquitectura del procesador de la computadora host

`LANG` Esta variable guarda la configuración regional del sistema

`LD_LIBRARY_PATH` Esta variable consta de un conjunto de directorios separados por dos puntos  donde los programas comparten las bibliotecas compartidas

`MAIL` Esta variable almacena el archivo en el que Bash busca correo electrónico

`MAILCHECK` Esta variable almacena un valor numérico que indica en segundos la frecuencia con la que Bash busca correo nuevo

`PATH` Esta variable de entorno almacena la lista de directorios donde Bash busca  archivos ejecutables cuando se le indica que ejecute cualquier programa. 

`PS1` Esta variable almacena el valor del Prompt Bash.



### alias y  funciones

Si frecuentemente realizamos comandos o tareas largas de escribir y queremos facilitarnos el trabajo podemos usar alias o funciones.

El poder de los **Alias** es crear un comando corto de uno( o varios ) largo o difícil de recordar

```bash
alias ls='ls --color'
alias git_info='whitch git; git --version'
unalias git_info # eliminar alias
```

Según las comillas que se utilizan el alias se comportará de manera diferente `''`dinámicamente, `""` estaticamente.

En el siguiente ejemplo se muestra un alias creado estaticamente, quiere decir que una vez creado no se ejecuta posteriormente solo guarda el resultado.

```bash
$ alias donde="echo $PWD"
$ donde
/home/user2

$ cd Music
$ donde
/home/user2
```

Para crear la **persistencia** de un alias se ha de crear en  `~/.bashrc`  o aún mejor en el archivo `~/.bash_aliases` 



En comparación con los alias, las **funciones** son más programáticas y  flexibles, especialmente cuando se trata de explotar todo el potencial  de las variables especiales integradas de *Bash* y los parámetros posicionales. 

Las funciones se pueden crear directamente desde la linea de comandos, pero es mas habitual crear un script e invocarlo con `.` o `source`

```bash
function nombre_función {
comando # 1
comando # 2
}
# o también
nombre_función() {
comando # 1
comando # 2
}
```

Al igual que con las variables y los alias, si queremos que las funciones  sean persistentes al reinicio del sistema, tenemos que ponerlas en  scripts de inicialización de shell como `/etc/bash.bashrc`(global) o `~/.bashrc`(local).





### Variables especiales de bash

El *Bourne Again Shell* viene con un conjunto de variables especiales que son particularmente útiles para las funciones y scripts. Estos son especiales porque solo se pueden hacer referencia a ellos, no asignados. A continuación, se muestra una lista de los más relevantes:

```bash
$?	# Muestra si el comando anterior se ejecuto correctamente `0` correcto, diferente a `0` erroneo
$$		# Se expande al shell PID (ID de proceso)
$!		# Se expande al PID del último trabajo en segundo plano
$0-9	# argumentos pasados a una finción $0 nombre del script 
$#		# Se expande al número de argumentos pasados al comando
$@, $*	# Se expanden a los argumentos pasados al comando
$_		# Se expande hasta el último parámetro o el nombre del script
```

> La diferencia entre `$*`  y `$@` es que al encapsular-los entre `""`,  `"$*"`  ignora los espacios entre argumentos y lo muestra como uno, y `"$@"` representa cada espacio como argumento separado.

