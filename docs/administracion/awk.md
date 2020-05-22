# Uso básico de AWK

  

## Qué es awk

  AWK es una herramienta de procesamiento de patrones en líneas de texto.  Su utilización estándar es la de filtrar ficheros o salida de comandos  de UNIX, tratando las líneas para, por ejemplo, mostrar una determinada  información sobre las mismas. 

  Por ejemplo: 

```bash
  Mostrar sólo los nombres y los tamaños de los ficheros:
  # ls -l | awk '{ print $8 ":" $5 }'

  Mostrar sólo los nombres y tamaños de ficheros .txt:
  # ls -l | awk '$8 ~ /\.txt/ { print $8 ":" $5 }'

  Imprimir las líneas que tengan más de 4 campos/columnas:
  # awk 'NF > 4 {print}' fichero
```

## Formato de uso

  El uso básico de AWK es: 

```
 awk [condicion] { comandos }
```

  Donde: 

-  **[condicion]** representa una condición de matcheo de líneas o parámetros.
-  **comandos** : una serie de comandos a ejecutar:
  -  $0       → Mostrar la línea completa
  -  $1-$N    → Mostrar los campos (columnas) de la línea especificados.
  -  FS       → Field Separator (Espacio o TAB por defecto)
  -  NF       → Número de campos (fields) en la línea actual
  -  NR       → Número de líneas (records) en el stream/fichero a procesar.
  -  OFS      → Output Field Separator (" ").
  -  ORS      → Output Record Separator ("\n").
  -  RS       → Input Record Separator ("\n").
  -  BEGIN    → Define sentencias a ejecutar antes de empezar el procesado.
  -  END      → Define sentencias a ejecutar tras acabar el procesado.
  -  length   → Longitud de la línea en proceso.
  -  FILENAME → Nombre del fichero en procesamiento.
  -  ARGC     → Número de parámetros de entrada al programa.
  -  ARGV     → Valor de los parámetros pasados al programa.

  Las funciones utilizables en las condiciones y comandos son, entre otras:  

-  close(fichero_a_reiniciar_desde_cero)
-  cos(x), sin(x)
-  index()
-  int(num)
-  lenght(string)
-  substr(str,pos,len)
-  tolower()
-  toupper()
-  system(orden_del_sistema_a_ejecutar)
-  printf()

  Los operadores soportados por awk son los siguientes:  

-  *, /, %, +, -, =, ++, --, +=, -=, *=, /=, %=.

  El control de flujo soportado por AWK incluye: 

-  if ( expr ) statement
-  if ( expr ) statement else statement
-  while ( expr ) statement
-  do statement while ( expr )
-  for ( opt_expr ; opt_expr ; opt_expr ) statement
-  for ( var in array ) statement
-  continue, break
-  (condicion)? a : b → if(condicion) a else b;

  Las operaciones de búsqueda son las siguientes: 

-  **/cadena/** → Búsqueda de cadena.
-  **/^cadena/** → Búsqueda de cadena al principio de la línea.
-  **/cadena$/** → Búsqueda de cadena al final de la línea.
-  **$N ~ /cadena/** → Búsqueda de cadena en el campo N.
-  **$N !~ /cadena/** → Búsqueda de cadena NO en el campo N.
-  **/(cadena1)|(cadena2)/** → Búsqueda de cadena1 OR cadena2.
-  **/cadena1/,/cadena2>/** → Todas las líneas entre cadena1 y cadena2.

## Ejemplos de selección de columnas

```bash
 Mostrar una determinada columna de información:
 # ls -l | awk '{ print $5 }'
 176869
 12
 4096
 4096

 Mostrar varias columnas, así como texto adicional (entre comillas):
 # ls -l | awk '{ print $8 ":" $5 }'
 AEMSolaris7.pdf:176869
 fich1:12
 Desktop:4096
 docs:4096

 Imprimir campos en otro orden:
 # awk '{ print $2, $1 }' fichero

 Imprimir último campo de cada línea:
 # awk '{ print $NF }' fichero

 Imprimir los campos en orden inverso:
 # awk '{ for (i = NF; i > 0; --i) print $i }' fichero

 Imprimir última línea:
 # awk '{line = $0} END {print line}'

 Imprimir primeras N líneas:
 # awk 'NR < 100 {print}' 

 Mostrar las líneas que contienen valores numéricos mayor o menor que uno dado:
 # ls -l | awk '$5 > 1000000 { print $8 ":" $5 }'

 # ls -l | awk '$5 > 1000000 || $5 < 100 { print $8 ":" $5 }'
 fich1:12
 z88dk-src-1.7.tgz:2558227
 (También hay operaciones &&)

 Mostrar la línea con el valor numérico más grande en un campo determinado:
 # awk '$1 > max { max=$1; linea=$0 }; END { print max, linea }' fichero

 Mostrar aquellos ficheros cuya longitud es mayor que 10 caracteres:
 # ls -l | awk 'length($8) > 10 { print NR " " $8 }'
 2 AEMSolaris7.pdf
 10 function_keys.txt
 14 notas_solaris.txt
 19 z88dk-src-1.7.tgz
 (Campo $8 -nombrefichero- > 10 caracteres, y numero de record)

 Mostrar líneas con más o menos de N caracteres:
 # awk 'length > 75' fichero
 # awk 'length < 75' fichero

 Mostrar campos/líneas que cumplan determinadas condiciones entre campos:
 # awk '$2 > $3 {print $3}' fichero
 # awk '$1 > $2 {print length($1)}' fichero

 Mostrar y el número de campos de un fichero además de la línea:
 # awk '{ print NF ":" $0 } ' fichero

 Mostrar y numerar sólo las líneas no vacías (no en blanco):
 # awk 'NF { $0=++a " :" $0 }; { print }'
 
 Imprimir las líneas que tengan más de N campos:
 # awk 'NF > 5 { print $0 }' fichero

 Mostrar el número de línea de cada fichero de una lista iniciando 
 desde cero la cuenta de líneas al empezar cada fichero:
 # awk '{print FNR "\t:" $0}' *.txt

 Mostrar el número de línea de cada fichero de una lista sin resetear
 la cuenta de líneas al empezar cada nuevo fichero:
 # awk '{print FNR "\t:" $0}' *.txt
```

## Matcheo/Sustitución de cadenas

```bash
 Mostrar las líneas que contengan una determinada cadena
 # awk '/cadena/ { print }' fichero

 Mostrar las líneas que NO contengan una determinada cadena
 # awk '! /cadena/ { print }' fichero

 # ls -l | awk '/4096/ { print $8 ":" $5 }'
   Desktop:4096
   docs:4096

 Mostrar todas las líneas que aparezcan entre 2 cadenas:
 # awk '/cadena_inicio/, /cadena_fin/' fichero

 Comparaciones exactas de cadenas:
 # awk '$1 == "fred" { print $3 }' fichero

 Líneas que contengan cualquier numero en punto flotante:
 # awk '/[0-9]+\.[0-9]*/ { print }' fichero

 Busqueda de cadenas en un campo determinado
 # awk '$5 ~ /root/ { print $3 }' fichero

 # ls -l | awk '$8 ~ /txt/ { print $8 ":" $5 }'
 apuntes.txt:9342
 function_keys.txt:2252
 notas_solaris.txt:57081
 (Nota, con ~ hemos buscado sólo /txt/ en el campo $8)

 Sustituir cadena1 por cadena2:
 # awk '{ gsub(/cadena1/,"cadena2"); print }' fichero

 Sustituir 1 por 2 sólo en las líneas que contengan "cadena3".
 # awk '/cadena3/ { gsub(/1/, "2") }; { print }' fichero

 Sustituir una cadena en las líneas que no contengan "cadena3".
 # awk '!/cadena3/ { gsub(/1/, "2") }; { print }' fichero

 Sustituir una cadena u otra:
 # awk '{ gsub(/cadena1|cadena2/, "nueva"); print}' fichero
```

## Filtrado / Eliminación de información

```bash
 Filtrar las líneas en blanco (numero campos ==0):
 # cat file.txt | awk {' if (NF != 0) print $0 '}

 Contar número de líneas donde la columna 3 sea mayor que la 1:
 # awk '$3 > $1 {print i + "1"; i++}' fichero

 Eliminar campo 2 de cada línea:
 # awk '{$2 = ""; print}' fichero

 Eliminar líneas duplicadas aunque sean no consecutivas:lines.
 # awk '!temp_array[$0]++' fichero

 Eliminar líneas que tengan una columna duplicada (usando un separador de columna).
 Usamos _ como temp_array. Usamos -F para indicar el separador de columnas.
 En este ejemplo miramos que la columna 3 sea diferente. Es el equivalente de un
 comando "uniq" comparando sólo una columna determinada.
 # awk -F',' '!_[$3]++' fichero

 (Se basa en utilizar un array de tipo hash/diccionario temporal donde
 las líneas que aún no han aparecido valen 0, y las que han aparecido !=0)

 Saltar 1000 Líneas de un fichero:
 # awk '{if ( NR > 1000 ) { print $0 }}' fichero

 Saltar líneas < 10 y > 20:
 # awk '(NR >= 0) && (NR <= 20) { print $0 }'
```

## Cálculos de tamaños / longitudes

```bash
 Imprimir el número de líneas que contienen una cadena:
 # awk '/cadena/ {nlines = nlines + 1} END {print nlines}' fichero
  
 Sumar todos los tamaños de ficheros de un ls -l, o con una condición:
 # ls -l | awk '{ sum += $5 } END { print sum }'
 3660106
 # ls -l | awk ' $3 == "sromero" { sum += $5 } END { print sum }'
 3660106

 Contar número de líneas del fichero:
 # awk 'END {print NR}' infile

 Contar el número de líneas vacías de un fichero:
 # awk 'BEGIN { x=0 } /^$/ {x=x+1} END { print "Lineas vacias:", x }' fichero
 
 NOTA: Expandido para leerlo mejor:
    BEGIN { x=0 } 
    /^$/  { x=x+1 } 
    END   { print "Lineas vacias:", x } 

 Contar el número de palabras / campos en un fichero:
 # awk '{ total = total + NF }; END { print total+0 }' fichero

 Contar el número total de líneas que contienen una cadena:
 # awk '/cadena/ { total++ }; END { print total+0 }' fichero

 Imprimir con formato:
 yes | head -10 | awk '{printf("%2.0f", NR)}'

 Calcular la suma de todos los campos de cada línea
 # awk '{suma=0; for (i=1; i<=NF; i++) suma=suma+$i; print suma}' fichero

 Calcular la suma y la media de todas las primeras columnas del fichero:
 # awk '{ suma += $1 } END { print "suma:", s, " media:", s/NR }
```

## Cambio de IFS (Field Separator)

```bash
 Sacar campos 1 y 3 de /etc/passwd: 
 # awk -F":" '{ print $1 "\t" $3 }' /etc/passwd

 Sacar datos de un fichero CSV separado por comas:
 # awk -F"," '$1=="Nombre" { print $2 }' fichero.csv
```

## Otros

```bash
 Tabular líneas con 3 espacios:
 # awk '{ sub(/^/, "   "); print }'

 Obtener 1 números aleatorio:
 # awk '{print rand()}'

 Generar 40 número aleatorio (0-100) sustituyendo la línea por el número:
 # yes | head -40 | awk '{ print int(101*rand())}'

 Generar 40 números aleatorios sólo con awk:
 # awk 'BEGIN { for (i = 1; i <= 40; i++) print int(101 * rand()) }'

 Reemplazar cada campo por su valor absoluto:
 # awk '{ for (i=1; i<=NF; i=i+1) if ($i<0) $i=-$i print}' fichero

 Definición y utilización de funciones propias (sólo nawk):
 # awk '{for (field=1; field<=NF; ++field) 
        {print EsPositivo($field)}};

     function EsPositivo(n) {
       if (n<0) return 0
       else     return 1 }'
      
 Partir un mbox en ficheros individuales (Ben Okopnik en Linux Gazzette #175).
 # awk '{if (/^From /) f=sprintf("%%03d",++a);print>>f}' mail_file
```