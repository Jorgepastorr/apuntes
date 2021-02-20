# Shell  

`orden && orden `

- `and`: si va bien la primera orden ara la segunda.

`orden || orden `

- `or`: si no va bien la primera ejecuta la segunta   



### Comand substitution  

Ejecutar una orden para ser ejecutada por otra orden:  `file $(ls)`  

Ejemplo:
- `finger $(whoami)`    

`rpm -ql $(rpm -qf $( which $orden ) )` 

- Primero se ejecuta orden
- Segundo which
- Tercero rpm queri file con todo el resultado   
- cuarto rpm queri list



### Brace Expansion  

**Sintaxis**  
```bash
echo nom{1,2,3} # crea 3 resultado acabados en 1 2 3
echo nom{1..10} # crea 10 resultados acavados del 1 al 10
echo nom{1,2,{30..35},hola} # crea resultado acabados en 1 2 hola y u rango de 30 al 35
echo nom{1,2,{a..h}} # crea resultado acabados en 1 2 y un rango de a, a la h
```


```bash
echo nom{1,2,3}
nom1 nom2 nom3
```



### Aritmetic expansion  

Calculos matematicos  
```bash
echo $(( 2 * 4 ))
8
max=30
echo $(( 365 - $max )) 
335
```



### Tilde expansion 

- `~` El home de usuario actual
- `~root` El home de usuario indicado



### Quoting  

- `""` expansion  
- `''` literal  
- `\`  escapar caracteres de significado especial  ( por ejemplo espacios, comillas, etc..



### Ordenes  

Que pasa al apretar enter. 

1. Expansion / interpretación
1. Ejecución
	- alias  
	- internas 
	- externas ( path )   

Si la expansión falla la ejecución no ejecuta. 
```bash
rm *
```
- Primero interpreta el asterisco con todos los archivos del directorio
- Despues los pasa al rm para que procese.   



#### Internas Externas

- Ordenes externas son las que tienen ruta en el PATH.
- Ordenes internas son las ordenes del sistema.
  ```bash   
  enable -a # mirar internas
  enable -n logout # deshabilitar interna
  enable logout # volver a habilitar
  ```



#### rpm  

Ver paquete de un fichero:
```bash
rpm -qf /usr/bin/ps
```
ver contenido del paquete
```bash
rpl -ql paquete  
```



## Bash Scripting

## Estructura de un script

La primera línea de un script siempre sera, que tipo de código lo interpreta, a esta línea se le denomina:

**shebang**

```bash
#!/bin/bash
```

## ejecutar

```bash
bash prog.sh
# si tiene permisos de ejecución, ejecuta y mata shell
. ./prog.sh
```

- bash ejecuta en un subproceso
- . ejecuta el programa y mata la shell

### Argumentos

```bash
$#    # numero total de argumentos
$*    # lista de argumentos
$@    # lista de argumentos
# argumento numero tal
$0
$1
$2
$3
${10}
```

> La diferencia entre `$*`  y `$@` es que al encapsular-los entre `""`,  `"$*"`  ignora los espacios entre argumentos y lo muestra como uno, y `"$@"` representa cada espacio como argumento separado.

`-e` interpretar expansiones tipo `\n \t etc...`
`-n` salida sin salto de linea.
los programas de administración no seran interactivos.

### Test

Test cheque tipo de archivos y compara valores.

todas sus opciones en `man test` 

```bash
# algunas de sus opciones para ficheros
-L es link
-f fichers regulares
-d directorio
-e existe
-o dispositivo de bloques
-x archivo ejecutable
-w permisos de escritura
-r permisos de lectura
-n not null

# en cadenas
-n "algo"    cadena no vacia true
-z ""    cadena vacia true
=    iguales
!=    diferentes
=~    conpara con expresion regular

# comparadores numericos
-gt    >
-lt    <
-ge    >=
-le    <=
-eq    ==
-ne    !=
-a    and
-o    or
!     not

#  operadores aritmeticos
+    suma
-     resta
\*   multiplicar
/     dividir  
%   modulo (resto )
```

La condición realmente ejecuta un test, que devuelve true o false.

**sintaxis:**

```bash
test $n -lt 18
[ $n -lt 18 ]
```

test se a actualizado y trae  algunas funcionalidades extra, como:

```bash
# si un archivo tiene espacios en su nombre
if [ -f "$file" ]
if [[ -f $file ]]
# aceptar expresiones regulares
if [ "$answer" = y -o "$answer" = yes ]
if [[ $answer =~ ^y(es)?$ ]]
# acepta parentesis y las expresiones && || !
[ 5 -lt 7 -a ! 5 -gt 7 ]
[[ 5 -lt 7 && !(5 -gt 7) ]] 
# permite comparar texto segun su numero asci
[[ "a" < "z" ]]
```

## Condicionales

**Sentencia `if`** 

```bash
if [ $edad -ge 18 ]
then
    echo "Mayor de edad"
else
    echo "Menor de edad"
fi
```

**Sentencia `elif`** 

```bash
if [ $edad -lt 18 ]
then
    echo "Menor edad"
elif [ $edad -lt 65 ]
then
    echo "Edad laboral"
else
    echo "jubilat"
fi
```

Prohibido repetir la misma instrucción dentro de if, elif, else, etc..  a no se que sea absolutamiento necesario.

## Case

Case evalua valores

```bash
lletra=$1
case $lletra in
   'a'|'e'|'i'|'o'|'u')
        echo "$lletra es una vocal";;
    *) 
        echo "$lletra es una constant";;
esac
exit 0
```

- indicas los valores a evaluar  y si no existe el `*` es el comodín, como si fuera un else.

## Bucles

### for

Itera per a cada element d'una llista finita

hay errores irrecuperables y recuperables 

- las irrecuperables -- plegas
- las recuperables -- continuar pero:
  - 1 informando que se a generado un error    por stderr
  - $? status error final especifico

```bash
# coge la lista como 1 elemento al insertar la variable entre ""
llista="per pau edu anna"
for nom in "$llista"
do
    echo $nom
done

# diferencia cada nombre por separado
llista="per pau edu anna"
for nom in $llista 
do
    echo $nom
done
```

```bash
for i in $(seq 1 1 5); # ( inicio incremento final ) 
do
    echo $i
done
```

```bash
for ((  i = 0 ;  i <= 5;  i++  ))  # ( inicio ; final ; incremento ) 
do
  echo " $i "
done
```

Listando tipos de ficheros:

```bash
dirs=$*
for dir in $dirs
do
    if ! [ -d $dir ]
    then
        echo "Error: el argument a de ser un directori" >> /dev/stderr 
        echo "Usage: prog dir[...]" >> /dev/stderr
    else
        cont=1
        llistatDir=$(ls $dir)
        for line in $llistatDir
        do
            line=$(echo $dir/$line | tr -s '/' '/')

            if [ -L $line ]
            then
                tipus="Link"
            elif [ -d $line ]
            then
                tipus="Directori"
            elif [ -f $line ]
            then
                tipus="Fitxer"
            else
                tipus="Otra cosa"
            fi

            echo "$cont: $tipus: $line"
            cont=$((cont+1))
        done
    fi
done
```

### while

```bash
CONTADOR=0
while [  $CONTADOR -lt 5 ]; do
       echo El contador es $CONTADOR
       let CONTADOR++
done    


# leer lineas por entrada estandar hasta que encuentre FI
read -r line
while [ $line != "FI" ]
do
    echo "$line"
    read -r line
done
exit 0


# ller lineas por entrada estandar y numerarlas
cont=1
while read -r line
do
    echo "$cont: $line"
    cont=$((cont+1))
done
exit 0
```

leer linea por entrada estandar o argumento

```bash
# bash iterar.sh noms.txt
# cat noms.txt | bash iterar.sh
# bash iterar.sh < noms.txt

file=/dev/stdin
if [ $# -eq 1 ];then
	file=$1
fi

cont=0
while read -r line
do
    let cont++
    echo "$cont $line"
# redirijo stdin o el argumento dentro del while
done < $file

exit 0
```



## Shift

shift (desplazar) los argumentos una posición a la izquierda, el argumento en primera posición al hacer shift desaparecerá y el 2 estará en la posición 1.

los argumentos los trata como una cadena por lo tanto hay que encapsular-los con "" para su correcto funcionamiento.

```bash
# -n not null
while [ -n "$1" ]
do 
    echo "$#: $1"
    shift
done
exit 0
```

## Listas

contar caracteres 

${#variable}

```bash
lista=(2 8 5 7 6)
echo ${lista[@]} 
2 8 5 7 6   # muestra lista completa

echo ${lista[2]}
5  # muestra el item de la posición 2

echo ${#lista[@]}  
5  # items dentro de la lista

echo ${!lista[@]}  
0 1 2 3 4  # posiciones de la lista ocupadas
```

#### Slicing

```bash
echo ${lista[@]:2}
5 7 6  # muestra de posición 2 hasta el final  

echo ${lista[@]:1:2}
8 5  # muestra desde la posición 1 dos números
```

#### Sustituir

```bash
lista=(uno dos tres cuatro)
echo ${lista[@]#c*o}
uno dos tres # borra lo que comienza por c cualquier cosa y o

echo ${lista[@]/cua/CUA}
uno dos tres CUAtro  # substitulle
echo ${lista[@]//ua/UA}                          # con 2 // lo hace recursivamente 
uno dos tres cUAtro  # substituye

echo ${lista[@]/%o/XX}
unXX dos tres cuatrXX  # substituye lo que acaba en o
```

### Añadir items

```bash
lista=(uno dos tres)
lista[3]=cuatro

echo ${lista[@]}  
uno dos tres cuatro

lista[${#lista[@]}]=”algo”       # añade al final de la lista
echo ${lista[@]}  
uno dos tres cuatro algo
```

### Quitar item

```bash
lista=(uno dos tres)
unset lista[2]

echo ${lista[@]}  
uno dos
```

#### Invertir lista

```bash
l1=("h" "o" "l" "a")
invertida=()
for i in $( seq ${#l1[*]} -1 0 );
do
    invertida[${#invertida[*]}]=${l1[*]:$i:1}
done
echo ${invertida[*]}
```

- `invertida[${#invertida[*]}]=${l1[*]:$i:1}`
  - `${#invertida[*]}` Extrae el número de items dentro de la lista, para asignar siempre en la ultima posición.
  - `${l1[*]:$i:1}` slicing de posición de la vuelta `$i` mostrar 1 carácter

#### invertir cadena

En cadenas es muy similar con la ventaja que no hay que indicar en que posición añadir el item.

```bash
l1="hola"
invertida=""                                 
for i in $( seq ${#l1} -1 0 );
do 
    invertida+=${l1:$i:1}
done
echo $invertida
aloh
```

- `${#l1}` numero del largo de la cadena
- `${l1:$i:1}` slicing de posición de la vuelta `$i` mostrar 1 carácter

## Funciones

```bash
tabla(){
    for variable in {0..10}
    do
        echo "$variable * $1 = $((variable*$1))"
    done
}

case $1 in
    1) tabla 5;;
    2) tabla 6;;
esac
```

- si dentro de la función asignamos una variable con **local** num=2 no lo guarda al salir de la función.

```bash
suma(){
    result=$(($1 + $2))
    return $result
}
suma 10 20
echo $result
-------
30
```

- para devolver un valor tenemos que utilizar return

### Modulo de funciones

Para usar un modulo personalizado creamos un archivo con todas las funciones y lo exportamos al shell actual.

***funciones.sh***  

```bash
#!/bin/bash
# modulo funcions
# ----------------------------

function hola(){
    echo "hola, bon dia"
    return 0
}

function suma(){
    echo $(($1 + $2))
    return 0
}
```

Exporto el archivo funciones con "`.` ", una vez exportado puedo utilizar sus funciones en el shell.

```bash
debian  ➜ . ./funciones.sh
debian  ➜ hola
hola
debian  ➜ suma 5 5
10
```

## Getops

getops crea un menú de opciones a pasar a un script, indicando por argumento la opción requerida ca ejecutar

***getops.sh***

```bash
while getopts "hct:" opcion
do
    case $opcion in
        h)
            echo "ayuda de como usar"
            ;;
        c)
            echo "actuaremos"
            ;;
        t)
            fichero="$OPTARG"
            ;;
        *)    
            echo "no has usado bien el script"
            ;;
    esac
done
```

> Si en las opciones colocas letras + “:” Le indicas que añades un argumento que luego puedes usar con: `$OPTARG`

```bash
bash getops.sh -h
ayuda de como usar
```
