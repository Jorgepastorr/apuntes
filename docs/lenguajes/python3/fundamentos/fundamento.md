# Fundamentos

## Textos (cadenas de caracteres)

Acepta carácteres especiales como las tabulaciones `/t` o los saltos de línea `/n`

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


Para evitar los carácteres especiales, debemos indicar que una cadena es cruda (raw)

```python
print(r"C:\nombre\directorio")  # r => raw (cruda)
```

```
C:\nombre\directorio
```


Podemos utilizar `"""` *(triple comillas)* para cadenas multilínea

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


También es posible utilizar la multiplicación de cadenas

```python
diez_espacios = " " * 10
print(diez_espacios + "un texto a diez espacios")
```

```
          un texto a diez espacios
```



### Índices en las cadenas

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

### Slicing en las cadenas

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


Para voltear una cadena rápidamente utilizando slicing podemos utilizar un tercer índice -1: `cadena[::-1]`

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

### Índices y slicing

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

### Suma de listas

Da como resultado una nueva lista que incluye todos los ítems.

```python
numeros + [5,6,7,8]
```

```
[1, 2, 3, 4, 5, 6, 7, 8]
```

### Son modificables

A diferencia de las cadenas, en las listas sí podemos modificar sus ítems utilizando índices:

```python
pares = [0,2,4,5,8,10]
pares[3]= 6
print(pares)
```

```
[0, 2, 4, 6, 8, 10]
```


### Integran funcionalidades internas

Como el método `.append()` para añadir un ítem al final de la lista

```python
pares.append(12)
print(pares)
```

```
[0, 2, 4, 6, 8, 10, 12]
```



Y una peculiaridad, es que también aceptan asignación con slicing para modificar varios ítems en conjunto

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



Asignar una lista vacía equivale a borrar los ítems de la lista o sublista

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



La función `len()` también funciona con las listas del mismo modo que en las cadenas:

```python
print(len(pares))
```

```
8
```



### Listas anidadas

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

### Matriz 

Diversas listas dentro de una lista se denomina Matriz.
Modificare cada lista para que el ultimo número sume el total de los primeros 3 números.

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



### Tuplas con nombres

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

---

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

Se consigue utilizando la instrucción `input()` que lee y devuelve una cadena:

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



De cadena a entero

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

De cadena a flotante

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



También podemos comparar variables

```python
a = 10
b = 5
a > b
```

```
True
```

Y otros tipos, como cadenas, listas, el resultado de algunas funciones o los propios tipos lógicos

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

La representación aritmética de True y False equivale a 1 y 0 respectivamente

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

### Sentencia If

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

También permite anidar If dentro de If

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

Como condición podemos evaluar múltiples expresiones, siempre que éstas devuelvan True o False

```python
if a==5 and b == 10:
    print("a vale 5 y b vale 10")
```

```
a vale 5 y b vale 10
```

### Sentencia Else

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

### Sentencia Elif

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

### While

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

#### Else en bucle While

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

#### Break

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

#### menú interactivo

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



### For

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



#### Modificar ítems de lista

La forma correcta de hacerlo es haciendo referencia al índice de la lista en lugar de la variable:

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

Podemos utilizar la función `enumerate()` para conseguir el índice y el valor en cada iteración fácilmente:

```python
numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for indice,numero in enumerate(numeros):
    numeros[indice] *= 10
numeros
```

```
[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
```

#### La función `range()`

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

Si queremos conseguir la lista literal podemos transformar el range a una lista:

```python
print( list(range(10)) )
```

```
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

Si queremos conseguir la suma de todos los numeros pares del 0 al 100

```python
suma = sum( range(0, 101, 2) )
print(suma)
```

```
2550
```
