# Python fundamentos

## Textos (cadenas de caracteres)

##### Acepta carácteres especiales como las tabulaciones /t o los saltos de línea /n

```python
print("Un texto\tuna tabulación")
```

```
Un texto	una tabulación
```



```python
print("Un texto\nuna nueva línea")
```

```
Un texto
una nueva línea
```



##### Para evitar los carácteres especiales, debemos indicar que una cadena es cruda (raw)

```python
print(r"C:\nombre\directorio")  # r => raw (cruda)
```

```
C:\nombre\directorio
```



##### Podemos utilizar """ *(triple comillas)* para cadenas multilínea

```python
print("""Una línea
otra línea
otra línea\tuna tabulación""")
```

```
Una línea
otra línea
otra línea	una tabulación
```



##### También es posible utilizar la multiplicación de cadenas

```python
diez_espacios = " " * 10
print(diez_espacios + "un texto a diez espacios")
```

```
          un texto a diez espacios
```



##### Índices en las cadenas

Los índices nos permiten posicionarnos en un carácter específico de una cadena.

Representan un número [índice], que empezando por el 0 indica el carácter de la primera posición, y así sucesivamente.

```python
palabra = "Python"
palabra[0] # carácter en la posición 0
```



```
'P'
```



```python
palabra[3]
```

```
'h'
```



##### Slicing en las cadenas

El slicing es una capacidad de las cadenas que devuelve un subconjunto o subcadena utilizando dos índices [inicio:fin]:

- El primer índice indica donde empieza la subcadena (se incluye el carácter).
- El segundo índice indica donde acaba la subcadena (se excluye el carácter).

```python
palabra = "Python"
palabra[0:2]
```

```
'Py'
```



```python
palabra[2:]
```

```
'thon'
```



```python
palabra[:2]
```

```
'Py'
```





```python
cadena = "zeréP nauJ,01"

# Voltear una cadena
cadena_volteada = cadena[::-1]
print(cadena_volteada[3:], "ha sacado un", cadena_volteada[:2], "de nota.")
```

```
Juan Pérez ha sacado un 10 de nota.
```



* Para voltear una cadena rápidamente utilizando slicing podemos utilizar un tercer índice -1: **cadena[::-1]** *

```python
cadena = "zeréP nauJ,01"

cadena_volteada = cadena[::-1]
print(cadena_volteada)
```

```
10,Juan Pérez
```



## Las listas

Tipo compuesto de dato que puede almacenar distintos valores (llamados ítems) ordenados entre [ ] y separados con comas.

```python
numeros = [1,2,3,4]
```

```python
datos = [4,"Una cadena",-15,3.14,"Otra cadena"]
```

##### Índices y slicing

Funcionan de una forma muy similar a las cadenas de caracteres.

```python
datos[0]
```

```
4
```



```python
datos[-1]
```

```
'Otra cadena'
```



##### Suma de listas

Da como resultado una nueva lista que incluye todos los ítems.

```python
numeros + [5,6,7,8]
```

```
[1, 2, 3, 4, 5, 6, 7, 8]
```



##### Son modificables

A diferencia de las cadenas, en las listas sí podemos modificar sus ítems utilizando índices:

```python
pares = [0,2,4,5,8,10]
pares[3]= 6
print(pares)
```

```
[0, 2, 4, 6, 8, 10]
```



##### Integran funcionalidades internas, como el método .append() para añadir un ítem al final de la lista

```python
pares.append(12)
print(pares)
```

```
[0, 2, 4, 6, 8, 10, 12]
```



##### Y una peculiaridad, es que también aceptan asignación con slicing para modificar varios ítems en conjunto

```python
letras = ['a','b','c','d','e','f']
print(letras[:3])
```

```
['a', 'b', 'c']
```



```python
letras[:3] = ['A','B','C']
print(letras)
```

```
['A', 'B', 'C', 'd', 'e', 'f']
```



##### Asignar una lista vacía equivale a borrar los ítems de la lista o sublista

```python
letras[:3] = []
print(letras)
```

```
['d', 'e', 'f']
```



```python
letras = []
print(letras)
```

```
[]
```



##### La función len() también funciona con las listas del mismo modo que en las cadenas:

```python
print(len(pares))
```

```
8
```



##### Listas dentro de listas (anidadas)

Podemos manipular fácilmente este tipo de estructuras utilizando múltiples índices, como si nos refieréramos a las filas y columnas de una tabla.

```python
a = [1,2,3]
b = [4,5,6]
c = [7,8,9]
r = [a,b,c]
print(r)
```

```
[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
```



```python
print(r[0])  # Primera sublista
```

```
[1, 2, 3]
```



```python
print(r[0][0])  # Primera sublista, y de ella, primer ítem
```

```
1
```

##### Diversas listas dentro de una lista se denomina Matriz.

modificare cada lista para que el ultimo número sume el total de los primeros 3 números.

```python
matriz = [ 
    [1, 1, 1, 5],
    [2, 2, 2, 7],
    [3, 3, 3, 2],
    [4, 4, 4, 13]
]

matriz[0][-1] = sum(matriz[0][:-1])
matriz[1][-1] = sum(matriz[1][:-1])
matriz[2][-1] = sum(matriz[2][:-1])
matriz[3][-1] = sum(matriz[3][:-1])

print(matriz)
```

```
[[1, 1, 1, 3], [2, 2, 2, 6], [3, 3, 3, 9], [4, 4, 4, 12]]
```



## Tupla 

Es un lista que no es modificable

```python
t = (2,8,10,20)
```

```python
t
```

```
(2, 8, 10, 20)
```



```python
t[0] = 80
```

```
---------------------------------------------------------------------------

TypeError                                 Traceback (most recent call last)

<ipython-input-9-b7272d63ab5a> in <module>()
----> 1 t[0] = 80
```

```
TypeError: 'tuple' object does not support item assignment
```



## Tuplas con nombres

Subclase de las tuplas utilizada para crear pequeñas estructuras inmutables, parecidas a una clase y sus objetos pero mucho más simples.

```python
t = (20,40,60)
```

```python
t[0]
```

```
20
```



```python
t[-1]
```

```
60
```



```python
from collections import namedtuple
```

```python
Persona = namedtuple('Persona','nombre apellido edad')
```

```python
p = Persona(nombre="Hector",apellido="Costa",edad=27)
```

```python
p.nombre
```

```
'Hector'
```



```python
p.apellido
```

```
'Costa'
```



```python
p.edad
```

```
27

```



```python
p
```

```
Persona(nombre='Hector', apellido='Costa', edad=27)

```



```python
p[0]
```

```
'Hector'

```



```python
p[1]
```

```
'Costa'

```



```python
p[-1]
```

```
27

```

Al ser una tupla, no se puede modificar

```python
p.nombre = "Hola"
```

```
---------------------------------------------------------------------------

AttributeError                            Traceback (most recent call last)

<ipython-input-91-5cd7aba08457> in <module>()
----> 1 p.nombre = "Hola"

```

```
AttributeError: can't set attribute

```



## Leyendo valores por teclado

Se consigue utilizando la instrucción input() que lee y devuelve una cadena:



```python
# Podemos mostrar un mensaje antes de leer el valor
valor = input("Introduce un valor: ")
```

```
Introduce un valor: 100
```



```python
# Aunque leemos un número, en realidad es una cadena de texto
valor 
```



```python
# Una cadena y un número no se pueden operar
valor + 100  
```

```
---------------------------------------------------------------------------

TypeError                                 Traceback (most recent call last)

<ipython-input-6-5071d551e583> in <module>()
----> 1 valor + 100
TypeError: Can't convert 'int' object to str implicitly
```



##### Cast con int(), de cadena a entero

```python
# La función int() de entero, devuelve un número entero a partir de una cadena
valor = int(valor)  
print(valor)
```

```
500
```



```python
valor + 1000  # Ahora ya es operable
```

```
1500
```



##### Cast con float(), de cadena a flotante

```python
# La función float() de flotante, devuelve un número flotante a partir de una cadena
valor = float( input("Introduce un número decimal o entero: ") )
```

```ter
Introduce un número decimal o entero: 3.14
```

```python
print(valor)
```

```
3.14
```



## Los operadores relacionales

Sirven para comparar dos valores, dependiendo del resultado de la comparación pueden devolver:

- Verdadero (True), si es cierta
- Falso (False), si no es cierta

```python
3 == 2	 # Igual que
3 != 2	 # Distinto de
3 > 2	 # Mayor que
3 < 2	 # Menor que
3 >= 4	 # Mayor o igual que
3 <= 4	 # Menor o igual que
```



##### También podemos comparar variables

```python
a = 10
b = 5
a > b
```

```
True
```



##### Y otros tipos, como cadenas, listas, el resultado de algunas funciones o los propios tipos lógicos

```python
"Hola" == "Hola"
```

```
True
```



```python
"Hola" != "Hola"
```

```
False
```



```python
c = "Hola"
c[0] == "H"
```

```
True
```



```python
l1 = [0,1,2]
l2 = [2,3,4]
l1 == l2
```

```
False
```



##### La representación aritmética de True y False equivale a 1 y 0 respectivamente

```python
True == 1	 # True
False == 0	 # True
```



## Operadores de asignación

Actúan directamente sobre la variable actual modificando su valor.

```python
a += 5 # suma en asignación
a -= 10 # resta en asignación
a *= 2 # producto en asignación
a /= 2 # división en asignación
a %= 2 # módulo en asignación
a **= 5 # potencia en asignación
```



## Condiciones

### Sentencia If (Si)

Permite dividir el flujo de un programa en diferentes caminos. El if se ejecuta siempre que la expresión que comprueba devuelva True

```python
if True:  # equivale a if not False
    print("Se cumple la condición")
    print("También se muestre este print")
```

```
Se cumple la condición
También se muestre este print
```

##### O también anidar If dentro de If

```python
a = 5
b = 10
if a == 5:
    print("a vale",a)
    if b == 10:
        print("y b vale",b)
```

```
a vale 5
y b vale 10
```

##### Como condición podemos evaluar múltiples expresiones, siempre que éstas devuelvan True o False

```python
if a==5 and b == 10:
    print("a vale 5 y b vale 10")
```

```
a vale 5 y b vale 10
```

#### Sentencia Else (Sino)

Se encadena a un If para comprobar el caso contrario (en el que no se cumple la condición).

```python
n = 11
if n % 2 == 0:
    print(n,"es un número par")
else:
    print(n,"es un número impar")
```

```
11 es un número impar
```

### Sentencia Elif (Sino Si)

Se encadena a un if u otro elif para comprobar múltiples condiciones, siempre que las anteriores no se ejecuten.

```python
nota = float(input("Introduce una nota: "))
if nota >= 9:
    print("Sobresaliente")
elif nota >= 7 and nota < 9:
    print("Notable")
elif nota >= 6 and nota < 7:
    print("Bien")
elif nota >= 5 and nota < 6:
    print("Suficiente")
else:
    print("Insuficiente")
```

```
Introduce una nota: 8
Notable
```



### Instrucción Pass

Sirve para finalizar un bloque, se puede utilizar en un bloque vacío.

```python
if True:
    pass
```



## Iteraciones

Iterar significa realizar una acción varias veces. Cada vez que se repite se denomina iteración.

#### Sentencia While (Mientras)

Se basa en repetir un bloque a partir de evaluar una condición lógica, siempre que ésta sea True.

Queda en las manos del programador decidir el momento en que la condición cambie a False para hacer que el While finalice.



```python
c = 0
while c <= 5:
    c+=1
    print("c vale",c)
```

```
c vale 1
c vale 2
c vale 3
c vale 4
c vale 5
c vale 6
```

#### Sentencia Else en bucle While

Se encadena al While para ejecutar un bloque de código una vez la condición ya no devuelve True (normalmente al final).

```python
c = 0
while c <= 5:
    c+=1
    print("c vale",c)
else:
    print("Se ha completado toda la iteración y c vale",c)
```

```
c vale 1
c vale 2
c vale 3
c vale 4
c vale 5
c vale 6
Se ha completado toda la iteración y c vale 6
```

#### Instrucción Break

Sirve para "romper" la ejecución del While en cualquier momento. No se ejecutará el Else, ya que éste sólo se llama al finalizar la iteración.

```python
c = 0
while c <= 5:
    c+=1
    if (c==4):
        print("Rompemos el bucle cuando c vale",c)
        break
    print("c vale",c)
else:
    print("Se ha completado toda la iteración y c vale",c)
```

```
c vale 1
c vale 2
c vale 3
Rompemos el bucle cuando c vale 4
```

#### Instrucción Continue

Sirve para "saltarse" la iteración actual sin romper el bucle.

```python
c = 0
while c <= 5:
    c+=1
    if c==3 or c==4:
        # print("Continuamos con la siguiente iteración",c)
        continue
    print("c vale",c)
else:
    print("Se ha completado toda la iteración y c vale",c)
```

```
c vale 1
c vale 2
c vale 5
c vale 6
Se ha completado toda la iteración y c vale 6
```

#### Creando un menú interactivo

```python
print("Bienvenido al menú interactivo")
while(True):
    print("""¿Qué quieres hacer? Escribe una opción
    1) Saludar
    2) Sumar dos números
    3) Salir""")
    opcion = input()
    if opcion == '1':
        print("Hola, espero que te lo estés pasando bien")
    elif opcion == '2':
        n1 = float(input("Introduce el primer número: "))
        n2 = float(input("Introduce el segundo número: "))
        print("El resultado de la suma es: ",n1+n2)
    elif opcion =='3':
        print("¡Hasta luego! Ha sido un placer ayudarte")
        break
    else:
        print("Comando desconocido, vuelve a intentarlo")
```



#### Sentencia For (Para) con listas

```python
for numero in numeros:  # Para [variable] en [lista]
    print(numero)
```

```
1
2
3
4
```



##### Modificar ítems de la lista al vuelo

###### La forma correcta de hacerlo es haciendo referencia al índice de la lista en lugar de la variable:

```python
indice = 0
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for numero in numeros:
    numeros[indice] *= 10
    indice+=1
print(numeros)
```

```
[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
```



##### Podemos utilizar la función enumerate() para conseguir el índice y el valor en cada iteración fácilmente:

```python
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for indice,numero in enumerate(numeros):
    numeros[indice] *= 10
numeros
```

```
[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
```



##### La función range()

Sirve para generar una lista de números que podemos recorrer fácilmente, pero no ocupa memoria porque se interpreta sobre la marcha:

```python
for i in range(10):
    print(i)
```

```
0
1
2
3
4
5
6
7
8
9
```



##### Si queremos conseguir la lista literal podemos transformar el range a una lista:

```python
print( list(range(10)) )
```

```
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

##### Si queremos conseguir la suma de todos los numeros pares del 0 al 100

```python
suma = sum( range(0, 101, 2) )
print(suma)
```

```
2550
```





# Las excepciones

Son bloques de código excepcionales que nos permiten continuar con la ejecución de un programa pese a que ocurra un error.



## Try - Except

##### Creando la excepción - Bloques try y except

Para prevenir el error, debemos poner el código propenso a error un bloque **try** y luego encadenaremos un bloque **except** para tratar la excepción:

```python
try:
    n = float(input("Introduce un número: "))
    m = 4
    print("{}/{}={}".format(n,m,n/m))
except:
    print("Ha ocurrido un error, introduce bien el número")
```

```
Introduce un número: aaa
Ha ocurrido un error, introduce bien el número
```



## Excepciones en bucle

##### Utilizando un while(true), podemos asegurárnos de que el usuario introduce bien el valor

Repitiendo la lectura por teclado hasta que lo haga bien, y entonces rompemos el bucle con un break:

```python
while(True):
    try:
        n = float(input("Introduce un número: "))
        m = 4
        print("{}/{}={}".format(n,m,n/m))
        break  # Importante romper la iteración si todo ha salido bien
    except:
        print("Ha ocurrido un error, introduce bien el número")
```

```
Introduce un número: aaa
Ha ocurrido un error, introduce bien el número
Introduce un número: 10
10.0/4=2.5
```



#### Bloque else en excepciones

Es posible encadenar un bloque else después del *except* para comprobar el caso en que **todo funcione correctamente** (no se ejecuta la excepción).

El bloque *else* es un buen momento para romper la iteración con *break* si todo funciona correctamente:

```python
while(True):
    try:
        n = float(input("Introduce un número: "))
        m = 4
        print("{}/{}={}".format(n,m,n/m))
    except:
        print("Ha ocurrido un error, introduce bien el número")
    else:
        print("Todo ha funcionado correctamente")
        break  # Importante romper la iteración si todo ha salido bien
```

```
Introduce un número: 10
10.0/4=2.5
Todo ha funcionado correctamente
```



#### Bloque finally en excepciones

Por último es posible utilizar un bloque *finally* que se ejecute al final del código, **ocurra o no ocurra un error**:

```python
while(True):
    try:
        n = float(input("Introduce un número: "))
        m = 4
        print("{}/{}={}".format(n,m,n/m))
    except:
        print("Ha ocurrido un error, introduce bien el número")
    else:
        print("Todo ha funcionado correctamente")
        break  # Importante romper la iteración si todo ha salido bien
    finally:
        print("Fin de la iteración") # Siempre se ejecuta
```

```
Introduce un número: aaa
Ha ocurrido un error, introduce bien el número
Fin de la iteración
Introduce un número: 10
10.0/4=2.5
Todo ha funcionado correctamente
Fin de la iteración
```



## Capturando múltiples excepciones

#### Guardando la excepción

Podemos asignar una excepción a una variable (por ejemplo e). De esta forma haciendo un pequeño truco podemos analizar el tipo de error que sucede gracias a su identificador:

```python
try:
    n = input("Introduce un número: ")
    5/n
except Exception as e:
    print( type(e).__name__ )
```

```
Introduce un número: 10
TypeError
```



#### Encadenando excepciones

Gracias a los identificadores de errores podemos crear múltiples comprobaciones, siempre que dejemos en último lugar la excepción por defecto *Excepcion* que engloba cualquier tipo de error (si la pusiéramos al principio, las demas excepciones nunca se ejecutarían):

```python
try:
    n = float(input("Introduce un número: "))
    5/n
except TypeError:
    print("No se puede dividir el número por una cadena")
except ValueError:
    print("Debes introducir una cadena que sea un número")
except ZeroDivisionError:
    print("No se puede dividir por cero, prueba otro número")
except Exception as e:
    print( type(e).__name__ )
```

```
Introduce un número: aaaa
ValueError
```



## Invocación de excepciones

#### La instrucción raise

Gracias a raise podemos lanzar un error manual pasándole el identificador. Luego simplemente podemos añadir un except para tratar esta excepción que hemos lanzado:

```python
def mi_funcion(algo=None):
    try:
        if algo is None:
            raise ValueError("Error! No se permite un valor nulo")
    except ValueError:
        print("Error! No se permite un valor nulo (desde la excepción)")
mi_funcion()
```

```
Error! No se permite un valor nulo (desde la excepción)
```





## Ejercicio

Realiza una función llamada agregar_una_vez() que reciba una lista y un elemento. La función debe añadir el elemento al final de la lista con la condición de no repetir ningún elemento. Además si este elemento ya se encuentra en la lista se debe invocar un error de tipo ValueError que debes capturar y mostrar este mensaje en su lugar:

```
  Error: Imposible añadir elementos duplicados => [elemento].
```

** Pueba de agregar los elementos 10, -2, "Hola" a la lista de elementos con la función una vez la has creado y luego muestra su contenido. **

```python
elementos = [1, 5, -2]

# Completa el ejercicio aquí
def agregar_una_vez(lista, el):
    try:
        if el in lista:
            raise ValueError
        else:
            lista.append(el)
    except ValueError:
        print("Error: Imposible añadir elementos duplicados =>", el)
        

agregar_una_vez(elementos, 10)
agregar_una_vez(elementos, -2)
agregar_una_vez(elementos, "Hola")
print(elementos)
```

```
Error: Imposible añadir elementos duplicados => -2
[1, 5, -2, 10, 'Hola']
```





# Python manejo de datos



## Los conjuntos  

Son colecciones desordenadas de elementos únicos utilizados para hacer pruebas de pertenencia a grupos y eliminación de elementos duplicados.

```python
conjunto = set()
conjunto = {1,2,3}
print(conjunto)
```

```
{1, 2, 3}
```



#### Método add()

Sirve para añadir elementos al conjunto. Si un elemento ya se encuentra, no se añadirá de nuevo.

```python
conjunto.add(4)
print(conjunto)
```

```
{1, 2, 3, 4}
```



```python
conjunto.add(0)
print(conjunto)
```

```
{0, 1, 2, 3, 4}
```



##### Auto-eliminación de elementos duplicados

```python
test = {'Hector','Hector','Hector'}
print(test)
```

```
{'Hector'}
```



##### Cast de lista a conjunto y viceversa

Es muy útil transformar listas a conjuntos para borrar los elementos duplicados automáticamente.

```python
l = [1,2,3,3,2,1]
print(l)
```

```
[1, 2, 3, 3, 2, 1]
```



#### **Convertir lista en conjunto ** 

```python
c = set(l)
```

```python
print(c)
```

```
{1, 2, 3}
```



**Convertir conjunto en lista **  

```python
l = list(c)
print(l)
```

```
[1, 2, 3]
```



**Conversion en una linea, lista --> conjunto --> lista**  

```python
l = [1,2,3,3,2,1]
# En una línea
l = list( set( l ) )
print(l)
```

```
[1, 2, 3]
```



#### Cast de cadena a conjunto

Sirve para crear un conjunto con todos los caracteres de la cadena.

```python
s = "Al pan pan y al vino vino"
print( set(s) )
```

```
{' ', 'A', 'a', 'i', 'l', 'n', 'o', 'p', 'v', 'y'}
```



## Los diccionarios

Son junto a las listas las colecciones más utilizadas. Se basan en una estructura mapeada donde cada elemento de la colección se encuentra identificado con una clave única. Por tanto, no puede haber dos claves iguales. En otros lenguajes se conocen como arreglos asociativos.

```python
vacio = {}
print(vacio)
```

```
{}
```

##### Tipo de una variable

```python
type(vacio)
```

```
dict
```



#### Sintaxis

##### Para cada elemento se define la estructura -> clave:valor

```python
colores = {'amarillo':'yellow','azul':'blue'}
```

##### También se pueden añadir elementos sobre la marcha

```python
colores['verde'] = 'green'
print(colores)
```

```
{'amarillo': 'yellow', 'azul': 'blue', 'verde': 'green'}
```



```python
print(colores['azul'])
```

```
'blue'
```



##### Modificación de valor a partir de la clave

```python
colores['amarillo'] = 'white'
print(colores)
```

```
{'amarillo': 'white', 'azul': 'blue', 'verde': 'green'}
```



#### Función del()

Sirve para borrar un elemento del diccionario.

```python
del(colores['amarillo'])
print(colores)
```

```
{'azul': 'blue', 'verde': 'green'}

```



##### Trabajando directamente con registros

```python
edades = {'Hector':27,'Juan':45,'Maria':34}
edades['Hector']+=1
print(edades)
```

```
{'Hector': 28, 'Juan': 45, 'Maria': 34}

```



#### Lectura secuencial con for .. in ..

Es posible utilizar una iteraciín for para recorrer los elementos del diccionario:

```python
for edad in edades:
    print(edad)
```

```
Maria
Hector
Juan

```

##### El problema es que se devuelven las claves, no los valores

Para solucionarlo deberíamos indicar la clave del diccionario para cada elemento.

```python
for clave in edades:
    print(clave,edades[clave])
```

```
Maria 34
Hector 28
Juan 45

```

#### El método .items()

Nos facilita la lectura en clave y valor de los elementos porque devuelve ambos valores en cada iteración automáticamente:

```python
for c,v in edades.items():
    print(c,v)
```

```
Maria 34
Hector 28
Juan 45

```

#### Ejemplo utilizando diccionarios y listas a la vez

Podemos crear nuestras propias estructuras avanzadas mezclando ambas colecciones. Mientras los diccionarios se encargarían de manejar las propiedades individuales de los registros, las listas nos permitirían manejarlos todos en conjunto.

```python
personajes = []
```

```python
p = {'Nombre':'Gandalf','Clase':'Mago','Raza':'Humano'} 
personajes.append(p)
print(personajes)
```

```
[{'Clase': 'Mago', 'Nombre': 'Gandalf', 'Raza': 'Humano'}]

```



```python
p = {'Nombre':'Legolas','Clase':'Arquero','Raza':'Elfo'}
personajes.append(p)
p = {'Nombre':'Gimli','Clase':'Guerrero','Raza':'Enano'}
personajes.append(p)
print(personajes)
```

```
[{'Clase': 'Mago', 'Nombre': 'Gandalf', 'Raza': 'Humano'},
 {'Clase': 'Arquero', 'Nombre': 'Legolas', 'Raza': 'Elfo'},
 {'Clase': 'Guerrero', 'Nombre': 'Gimli', 'Raza': 'Enano'}]

```



```python
for p in personajes:
    print(p['Nombre'], p['Clase'], p['Raza'])
```

```
Gandalf Mago Humano
Legolas Arquero Elfo
Gimli Guerrero Enano



```



## Diccionarios con valor por defecto

Se utilizan para crear diccionarios con un valor por defecto aunque el registro no haya sido definido anteriormente.

```python
d = {}
```

```python
d['algo']
```

```
---------------------------------------------------------------------------

KeyError                                  Traceback (most recent call last)

<ipython-input-38-c4e2998bb821> in <module>()
----> 1 d['algo']
```

```
KeyError: 'algo'
```



```python
from collections import defaultdict
```

```python
d = defaultdict(float)
d['algo']
```

```
0.0
```



```python
d
```

```
defaultdict(float, {'algo': 0.0})
```



```python
d = defaultdict(str)
d['algo']
```

```
''
```



```python
d
```

```
defaultdict(str, {'algo': ''})

```



```python
d = defaultdict(object)
d['algo']
```

```
<object at 0x1ad7f3201f0>

```



```python
d
```

```
defaultdict(object, {'algo': <object at 0x1ad7f3201f0>})

```



```python
d = defaultdict(int)
d['algo'] = 10.5
```

```python
d['algo']
```

```
10.5

```



```python
d['algomas']
```

```
0

```



```python
d
```

```
defaultdict(int, {'algo': 10.5, 'algomas': 0})

```



```python
n = {}
```

```python
n['uno'] = 'one'
n['dos'] = 'two'
n['tres'] = 'three'
```

```python
n
```

```
{'dos': 'two', 'tres': 'three', 'uno': 'one'}

```



## Diccionarios ordenados

Otra subclase de diccionario que conserva el orden en que añadimos los registros.

```python
from collections import OrderedDict
```

```python
n = OrderedDict()
```

```python
n['uno'] = 'one'
n['dos'] = 'two'
n['tres'] = 'three'
```

```python
n
```

```
OrderedDict([('uno', 'one'), ('dos', 'two'), ('tres', 'three')])
```



```python
n1 = {}
n1['uno'] = 'one'
n1['dos'] = 'two'

n2 = {}
n2['dos'] = 'two'
n2['uno'] = 'one'
```

```python
n1 == n2
```

```
True
```



```python
n1 = OrderedDict()
n1['uno'] = 'one'
n1['dos'] = 'two'

n2 = OrderedDict()
n2['dos'] = 'two'
n2['uno'] = 'one'
```

```python
n1 == n2
```

```
False
```



## Las pilas

Son colecciones de elementos ordenados que únicamente permiten dos acciones:

- Añadir un elemento a la pila
- Sacar un elemento de la pila

La peculiaridad es que el último elemento en entrar es el primero en salir. En inglés se conocen como estructuras *LIFO (Last In First Out)*.

#### Las podemos crear como listas normales y añadir elementos al final con el append():

```python
pila = [3,4,5]
pila.append(6)
pila.append(7)
print(pila)
```

```
[3, 4, 5, 6, 7]

```



#### Para sacar los elementos utilizaremos el método .pop():

Al utilizar pop() devolveremos el último elemento, pero también lo borraremos. Si queremos trabajar con él deberíamos asignarlo a una variable o lo perderemos:

```python
pila.pop()
```

```
7

```



```python
print(pila)
```

```
[3, 4, 5, 6]

```



##### Si hacemos pop() de una pila vacía, devolverá un error:

Debemos asegurarnos siempre de que la len() de la pila sea mayor que 0 antes de extraer un elemento automáticamente.

```python
pila.pop()
```

```
---------------------------------------------------------------------------

IndexError                                Traceback (most recent call last)

<ipython-input-14-3900970cfbef> in <module>()
----> 1 pila.pop()

```

```
IndexError: pop from empty list

```



## Las colas

Son colecciones de elementos ordenados que únicamente permiten dos acciones:

- Añadir un elemento a la cola
- Sacar un elemento de la cola

La peculiaridad es que el primer elemento en entrar es el primero en salir. En inglés se conocen como estructuras *FIFO (First In First Out)*.

##### Debemos importar la colección *deque* manualmente para crear una cola:

```python
from collections import deque

cola = deque()
print(cola)
```

```
deque([])

```



##### Podemos añadir elemento directamente pasando una lista a la cola al crearla:

```python
cola = deque(['Hector','Juan','Miguel'])
print(cola)
```

```
deque(['Hector', 'Juan', 'Miguel'])

```



##### Y también utilizando el método .append():

```python
cola.append('Maria')
cola.append('Arnaldo')
print(cola)
```

```
deque(['Hector', 'Juan', 'Miguel', 'Maria', 'Arnaldo'])

```



#### popleft() en lugar de pop()

A la hora de sacar los elementos utilizaremos el método popleft() para extraerlos por la parte izquierda (el principio de la cola). 

```python
cola.popleft()
```

```
'Hector'

```



```python
print(cola)
```

```
deque(['Juan', 'Miguel', 'Maria', 'Arnaldo'])

```



```python
cola.popleft()
```

```
'Juan'

```



```python
print(cola)
```

```
deque(['Miguel', 'Maria', 'Arnaldo'])

```



## Salida por pantalla

La función print() es la forma general de mostrar información por pantalla. Generalmente podemos mostrar texto y variables separándolos con comas:

```python
v = "otro texto"
n = 10
print("Un texto",v,"y un número",n)
```

```
Un texto otro texto y un número 10

```

#### El método .format()

Es una funcionalidad de las cadenas de texto que nos permite formatear información en una cadena (variables o valores literales) cómodamente utilizando identificadores referenciados:

```python
c = "Un texto '{}' y un número '{}'".format(v,n)
print(c)
```

```
"Un texto 'otro texto' y un número '10'"

```



##### También podemos referenciar a partir de la posición de los valores utilizando índices:

```python
print( "Un texto '{1}' y un número '{0}'".format(v,n) )
```

```
Un texto '10' y un número 'otro texto'

```

##### O podemos utilizar identificador con una clave y luego pasarlas en el format:

```python
print( "Un texto '{v}' y un número '{n}'".format(n=n,v=v) )
```

```
Un texto 'otro texto' y un número '10'

```



```python
print("{v},{v},{v}".format(v=v))
```

```
otro texto,otro texto,otro texto

```



### Formateo avanzado

##### Alineamiento a la derecha en 30 caracteres

```python
print( "{:>30}".format("palabra") )  
```

```
                       palabra

```



##### Alineamiento a la izquierda en 30 caracteres

```python
print( "{:30}".format("palabra") )  
```

```
palabra                       

```



##### Alineamiento al centro en 30 caracteres

```python
print( "{:^30}".format("palabra") ) 
```

```
           palabra            

```



##### Truncamiento a 3 caracteres

```python
print( "{:.5}".format("palabra") )  
```

```
palab

```



##### Alineamiento a la derecha en 30 caracteres con truncamiento de 3

```python
print( "{:>30.3}".format("palabra") )  
```

```
                           pal

```



##### Formateo de números enteros, rellenados con espacios

```python
print("{:4d}".format(10))
print("{:4d}".format(100))
print("{:4d}".format(1000))
```

```
  10
 100
1000

```



##### Formateo de números enteros, rellenados con ceros

```python
print("{:04d}".format(10))
print("{:04d}".format(100))
print("{:04d}".format(1000))
```

```
0010
0100
1000

```



##### Formateo de números flotantes, rellenados con espacios

```python
print("{:7.3f}".format(3.1415926))
print("{:7.3f}".format(153.21))
```

```
  3.142
153.210

```



##### Formateo de números flotantes, rellenados con ceros

```python
print("{:07.3f}".format(3.1415926))
print("{:07.3f}".format(153.21))
```

```
003.142
153.210

```



## Las funciones

Son fragmentos de código que se pueden ejecutar múltiples veces. Pueden recibir y devolver información para comunicarse con el proceso principal.

#### Definición y llamada

```python
def saludar():
    print("Hola! Este print se llama desde la función saludar()")

saludar()
```

```
Hola! Este print se llama desde la función saludar()

```

##### Dentro de una función podemos utilizar variables y sentencias de control:

```python
def dibujar_tabla_del_5():
    for i in range(10):
        print("5 * {} = {}".format(i,i*5))
dibujar_tabla_del_5()
```

```
5 * 0 = 0
5 * 1 = 5
5 * 2 = 10
5 * 3 = 15
5 * 4 = 20
5 * 5 = 25
5 * 6 = 30
5 * 7 = 35
5 * 8 = 40
5 * 9 = 45

```

##### Ámbito de las variables

Una variable declarada en una función no existe en la función principal:

```python
def test():
    n = 10
test()
```

```python
print(n)
```

```
---------------------------------------------------------------------------

NameError                                 Traceback (most recent call last)

<ipython-input-4-667d7c7a2c02> in <module>()
----> 1 print(n)
NameError: name 'n' is not defined

```



##### Sin embargo, siempre que declaremos la variable antes de la ejecución, podemos acceder a ella desde dentro:

```python
def test():
    print(l)

l = 10
test()
```

```
10

```

> En el caso que declaremos de nuevo una variable en la función, se creará un copia de la misma que sólo funcionará dentro de la función.



##### Por tanto *no podemos modificar una variable externa dentro de una función*:

```python
def test():
    o = 5 # variable que sólo existe dentro de la función
    print(o)
test()

o=10 # variable externa, no modificable
test()
print(o)
```

```
5
5
10

```



#### La instrucción global

Para poder modificar una variable externa en la función, debemos indicar que es global de la siguiente forma:

```python
def test():
    global o # variable que hace referencia a la o externa
    o = 5
    print(o)
test()

o=10
test()
print(o)
```

```
5
5
5

```



#### Trabajando con argumentos y parámetros

##### Argumentos por posición

```python
def resta(a,b):
    return a-b

resta(1,2)   # posición índice 0 valor 1, posición índice 1 valor 2
```

```
-1

```



##### Argumentos por nombre

```python
resta(b=2,a=1)
```

```
-1

```



##### Llamada sin argumentos

Al llamar una función que tiene definidos unos parámetros, si no pasamos los argumentos correctamente provocará un error:

```python
resta()
```

```
---------------------------------------------------------------------------

TypeError                                 Traceback (most recent call last)

<ipython-input-4-78c8f433960e> in <module>()
----> 1 resta()
TypeError: resta() missing 2 required positional arguments: 'a' and 'b'

```



#### Parámetros por defecto

Para solucionarlo podemos asignar unos valores por defecto nulos a los parámetros, y de ésa forma podríamos hacer una comprobación antes de ejecutar el código de la función:

```python
def resta(a=None,b=None):
    if a == None or b == None:
        print("Error, debes enviar dos números a la función")
        return
    return a-b
resta(1,5)
```

```
-4

```



## Paso por valor y paso por referencia

- **Paso por valor**: Se crea una copia local de la variable dentro de la función.
- **Paso por referencia**: Se maneja directamente la variable, los cambios realizados dentro le afectarán también fuera.

Tradicionalmente, **los tipos simples se pasan automáticamente por valor y los compuestos por referencia**.

- **Simples**: Enteros, flotantes, cadenas, lógicos...
- **Compuestos**: Listas, diccionarios, conjuntos...

#### Ejemplo paso por valor

```python
def doblar_valor(numero):
    numero*=2
    
n = 10
doblar_valor(n)
n
```



```
10

```



#### Ejemplo paso por referencia

```python
def doblar_valores(numeros):
    for i,n in enumerate(numeros):
        numeros[i] *= 2
ns = [10,50,100]
doblar_valores(ns)
print(ns)
```



```
[20, 100, 200]

```



#### Trucos

##### Para modificar los tipos simples podemos devolverlos modificados y reasignarlos:

```python
def doblar_valor(numero):
    return numero*2
n = 10
n = doblar_valor(n)
print(n)
```



```
20

```



##### Y en el caso de los tipos compuestos, podemos evitar la modificación enviando una copia:

```python
def doblar_valores(numeros):
    for i,n in enumerate(numeros):
        numeros[i] *= 2
ns = [10,50,100]
doblar_valores(ns[:])  # Una copia al vuelo de una lista con [:]
print(ns)
```

```
[10, 50, 100]

```



### Argumentos y parámetros indeterminados

Quizá en alguna ocasión no sabemos de antemano cuantos elementos vamos a enviar a una función. En estos casos podemos utilizar los parámetros indeterminados por posición y por nombre.

#### Por posición

Para recibir un número indeterminado de parámetros por posición, debemos crear una lista dinámica de argumentos (una tupla en realidad):

```python
def indeterminados_posicion(*args):
    for arg in args:
        print(arg)
    
indeterminados_posicion(5,"Hola",[1,2,3,4,5])
```

```
5
Hola
[1, 2, 3, 4, 5]

```

#### Por nombre

Para recibir un número indeterminado de parámetros por nombre (clave-valor), debemos crear un diccionario dinámico de argumentos:

```python
def indeterminados_nombre(**kwargs):
    print(kwargs)
indeterminados_nombre(n=5,c="Hola",l=[1,2,3,4,5])    
```

```
{'n': 5, 'c': 'Hola', 'l': [1, 2, 3, 4, 5]}

```



```python
def indeterminados_nombre(**kwargs):
    for kwarg in kwargs:
        print(kwarg)
indeterminados_nombre(n=5,c="Hola",l=[1,2,3,4,5])   
```

```
n
c
l

```



```python
def indeterminados_nombre(**kwargs):
    for kwarg in kwargs:
        print(kwarg," ", kwargs[kwarg])
indeterminados_nombre(n=5,c="Hola",l=[1,2,3,4,5])   
```

```
n   5
c   Hola
l   [1, 2, 3, 4, 5]

```



#### Por posición y nombre a la vez

Si queremos aceptar ambos tipos de parámetros simultáneamente, entonces debemos crear ambas colecciones dinámicas:

```python
def super_funcion(*args,**kwargs):
    t = 0
    for arg in args:
        t+=arg
    print("Sumatorio indeterminado es",t)
    for kwarg in kwargs:
        print(kwarg," ", kwargs[kwarg])

super_funcion(10,50,-1,1.56,10,20,300,nombre="Hector",edad=27)
```

```
Sumatorio indeterinado es 390.56
nombre   Hector
edad   27

```



### Funciones recursivas

Se trata de funciones que se llaman a sí mismas durante su propia ejecución. Funcionan de forma similar a las iteraciones, y debemos encargarnos de planificar el momento en que una función recursiva deja de llamarse o tendremos una función rescursiva infinita.

Suele utilizarse para dividir una tarea en subtareas más simples de forma que sea más fácil abordar el problema y solucionarlo.



##### Ejemplo sencillo sin retorno

Cuenta regresiva hasta cero a partir de un número:

```python
def cuenta_atras(num):
    num -= 1
    if num > 0:
        print(num)
        cuenta_atras(num)
    else:
        print("Boooooooom!")
    print("Fin de la función", num)

cuenta_atras(5)
```

```
4
3
2
1
Boooooooom!
Fin de la función 0
Fin de la función 1
Fin de la función 2
Fin de la función 3
Fin de la función 4

```



##### Ejemplo con retorno (factorial de un número)

El factorial de un número corresponde al producto de todos los números desde 1 hasta el propio número:

- 3! = 1 x 2 x 3 = 6
- 5! = 1 x 2 x 3 x 4 x 5 = 120

```python
def factorial(num):
    print("Valor inicial ->",num)
    if num > 1:
        num = num * factorial(num -1)
    print("valor final ->",num)
    return num

factorial(5)
```

```
Valor inicial -> 5
Valor inicial -> 4
Valor inicial -> 3
Valor inicial -> 2
Valor inicial -> 1
valor final -> 1
valor final -> 2
valor final -> 6
valor final -> 24
valor final -> 120

```

```
120

```



















