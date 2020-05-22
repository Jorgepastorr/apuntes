# PER

## patrons expresio regular

Regular expresion --> regex

grep "per" file[...]
buscar/filtrar lineas mediante un patron

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

```bash
[:alnum:], [:alpha:], [:cntrl:], [:digit:],  [:graph:],  [:lower:],  [:print:],
       [:punct:],  [:space:],  [:upper:],  and  [:xdigit:].   For  example,  [[:alnum:]]
```

```bash
echo "hola hole holi" | grep  "hol[^ae]"
holi holi

echo "hola hole holi holiesto" | grep  "hol[^ae]."
holi holie

echo "hola hole holi holiesto" | grep  "hol[^ae]*"
hol hol holi holie

echo "hola hole holi holiesto" | grep  "hol[^ae].*"
holi holiesto

echo "hola hole holi holiesto" | grep  ".*holi"
hola hole holi holi
```

El `*` busca lo mas a la derecha posible 

```bash
echo "aa:cc:bb:cc:dd" | grep ".*:cc:"
aa:cc:bb:cc:
```

```bash
grep 
-i ignore case ( ignorarv casec sensitive )
-v invert match ( revertir busquerda )
-n numero de lineas
-E aceptar expresiones regulares {}, |, [], etc... o egrep
```

Buscando coincidencias con grep tenemos que acotar bien, indicando principios, finales etc..
`^[^:]* :` Buscar desde el principio hasta el primer `:`

```bash
 echo "a:b:c:d:b:y:" | grep "^[^:]*:b:"
a:b:
# busqueda del 3er campo 
 grep "^[^:]*:[^:]*:1:" passwd
bin:x:1:
```

Linea del /etc/passwd

- **login:passwd:uid:gid:gecos:home:shell**
- gecos: descripcion

Validar matriculas actuales y antiguas.

```bash
9999 AAA
A[A]-9999-AA
```

```bash
format1="^[0-9]{4} [A-Z]{3}$" 
format2="^[A-Z][A-Z]?-[0-9]{4}-[A-Z]{2}$"
grep -E "$format1|$format2" matriculas
```

## CUT

cut recorta caracteres, columnas etc..

```bash
# filtrar por caracteres de las filas
cut -c1-10,12,40- passwd

# filtrar por columnbas con un delimitador :
cut -d: -f1-3,5,7
```

## TR

```bash
tr "" ""
 que y porqué
substitución de cada letra por letra no sirve para palabras

echo "la mar estaba salada, merda" | tr "mar" "cel"
le cel estebe selede, celde
```

- En el anterior caso visualmente funciona mal, pero realment sustituye por letra. m => c, a=>e y la r=>l.

- En el caso de querer substituir palabras se tiene que utilizar otros comandos como, sed, awk, etc..



## Blank

blank son espacios. tabulador un espcio en blanco sin dfefinir en anchura.
cuando el delimitador es un blanco se a de normalizar.

Ejemplo de normalizar la salida de fstab, creo separadores para poder filtrar por columnas facilmente. ( El delimitador no puede estar en el contenido por defecto (un blanco o un tabulador) )

En el siguiente ejemplo se ve la salida de fstab, pero no sabemos cuantos espacios o tabuladores hay entre campo y campo. De esta manera resulta imposible crear una salida en condiciones, por lo tanto la normalizo a un blanco único entre campos.

```bash
grep -v "^#" fstab
/dev/sda5         /                ext4 defaults        1   1
/dev/sda7 swap                    swap    defaults        0 0

grep -v "^#" fstab | tr -s "[:blank:]" " "
/dev/sda5 / ext4 defaults 1 1
/dev/sda7 swap swap defaults 0 0
```

- `-s` ,`--squeeze-repeats` 

## SORT

```bash
sort -n -t: -k3,3 passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
```

- `-n` Ordena numericamente
- `-k` Ordena por campo
  - `-k3` campo 3 hasta final de la línea
  - `-k3,3` especificamente campo 3
  - `-k3n,3` campo 3 ordenado numericamente
- `-t` delimitador entre campos



Ordenar campo 4 orden descendente numericamente

```bash
passwd |  sort  -t: -k4rn,4
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
```

Ordenación --> estable ( propiedad )
En ordenaciones siempre a de ver un campo clave, esto significa que si filtras por un campo en el que puede aber resultados iguales, se tiene que filtrar por un segundo o mas campos.

```bash
ll / | head | tr -s "[:blank:]" ' ' | cut -d" " -f2,3,5,6 | sort -t' ' -k3n,3 -k1n,1

18 root 3,3K ene
2 root 4,0K ene
2 root 4,0K ene
3 root 4,0K ene
5 root 4,0K ene
19 root 4,0K ene
162 root 12K ene
1 root 30 ene
1 root 30 ene
```

- Normalizo la salida con tr

- recorto las filas que me interesan con cut

- Ordeno numericamente, ascendente, por la columna 3 y los que coinciden por la 1



## SED

Sintaxis

```bash 
sed <seleccio de linies> 's/<que busco>/<por que cambio>/<numero de veces>'
```

```bash
 echo "hola mama que tal" | sed 's/mama/papa/'
hola papa que tal
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

# sustitulle en las lineas que contengan elfo bin por BIN
sed '/elfo/ s/bin/BIN/g' text

# desde la linea que contenga capitulo 1 hasta capitulo 2 sustitulle bin por BIN
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

## JOIN 

Join relaciona dos ficheros según un campo.

**archivos base.** 
```bash 
cat adats.txt
pere 12
marta 25
juan 10
```

```bash
cat notes.txt
pere 6
marta 10
juan 8.5
lluis 4
```

Hay que tener en cuenta  que el primer archivo se indica como `-1` y el segundo archivo `-2` 
```bash
# relacion automatica
join adats.txt notes.txt 
pere 12 6
marta 25 10
juan 10 8.5

# Relacionar por campo 1 del archivo 1
join -1 1 adats.txt notes.txt
pere 12 6
marta 25 10
juan 10 8.5

# relacionar por campo 1 del archivo 1 y 2
join -1 1 -2 1 adats.txt notes.txt
pere 12 6
marta 25 10
juan 10 8.5

# idem anteror + mostrar salida archivo 2 campo 2
join -o2.2  -1 1 -2 1 adats.txt notes.txt
6
10
8.5

# idem anterior + salida campo 1 del archivo 1
join -o2.2,1.1  -1 1 -2 1 adats.txt notes.txt
6 pere
10 marta
8.5 juan
```
- `-o` se creiere a output, que quiees mostrar y de donde.

Left y right join. indicamos left join con `-a 1` y right join con `-a 2`.  
```bash 
# left join
join -a 1 -o2.2,1.1  -1 1 -2 1 adats.txt notes.txt
6 pere
10 marta
8.5 juan

# right join
join -a 2 -o2.2,1.1  -1 1 -2 1 adats.txt notes.txt
6 pere
10 marta
8.5 juan
4 
```


## Chattr

Protegemos nuestros archivos de un posible borrado chattr, con este comando no podremos borrar dicho archivo o carpeta ni siendo root.

Al protegerlo no nos dejará crear clonaciones tipo hard, solo accesos directos tipo Soft aunque no podremos editarlo de ninguna manera.

**Proteger**

```bash
sudo chattr +i <archivo/carpeta>
```



**Liberar**

```bash
sudo chattr +i <archivo/carpeta>
```

















