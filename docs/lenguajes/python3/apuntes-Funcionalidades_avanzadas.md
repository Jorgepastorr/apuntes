## Compresión de listas

La compresión de listas es una manera rápida de crear una lista en una sola línea de código.



### compresión simple

Crear una lista de una cadena de caracteres


```python
# metodo tradicional
lista = []
for letra in 'casa':
    lista.append(letra)

print(lista)
```

    ['c', 'a', 's', 'a']



```python
# método con compresión
lista = [letra for letra in 'casa']
print(lista)
```

    ['c', 'a', 's', 'a']



### compresión con condición

Múltiples de 2 del 0 al 10


```python
# metodo tradicional
lista = []
for numero in range(0,11):
    lista.append(numero ** 2)

print(lista)
```

    [0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100]



```python
# compresion
lista = [numero ** 2 for numero in range(0,11)] 
print(lista)
```

    [0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100]


números pares del 0 al 10


```python
# metodo tradicional
lista = []
for numero in range(0,11):
    if numero % 2 == 0:
        lista.append(numero)

print(lista)
```

    [0, 2, 4, 6, 8, 10]



```python
# compresion
lista = [numero for numero in range(0,11) if numero % 2 == 0] 
print(lista)
```

    [0, 2, 4, 6, 8, 10]



### compresión múltiple

lista de números pares del 0 al 10 potenciados por 2 


```python
# metodo tradicional
lista = []
for numero in range(0,11):
        lista.append(numero ** 2)

pares = []
for numero in lista:
    if numero % 2 == 0:
        pares.append(numero)

print(pares)
```

    [0, 4, 16, 36, 64, 100]



```python
# compresion
pares = [ numero for numero in [ numero ** 2 for numero in range(0,11)] if numero % 2 == 0]
print(pares)
```

    [0, 4, 16, 36, 64, 100]



## Ámbitos y funciones decoradoras



### Introducción

No cabe duda de que Python es un lenguaje flexible, y cuando trabajamos con funciones no es una excepción.

En Python, dentro de una función podemos definir otras funciones. Con la peculiaridad de que el ámbito de estas funciones se encuentre únicamente dentro de la función padre. Vamos a trabajar los ámbitos un poco más en profundidad:

```python
def hola():
    
    def bienvenido():
        return "Hola!"
    
    return bienvenido
```

Si intentamos llamar a la función bienvenido...

```python
bienvenido()
```

```
---------------------------------------------------------------------------

NameError                                 Traceback (most recent call last)

<ipython-input-3-f083d151b813> in <module>()
----> 1 bienvenido()
```

```
NameError: name 'bienvenido' is not defined
```

Como vemos nos da un error de que no existe. En cambio si intentamos ejecutar la función **hola()**:

```python
hola()
```



```
<function __main__.hola.<locals>.bienvenido>
```



Se devuelve la función bienvenido, y podemos apreciar dentro de su definición que existe un espacio llamado **locals**, el cual hace referencia al ámbito local que abarca la función.

#### Ámbito local y global

Si utilizamos una función reservada **locals()** obtendremos un diccionario con todas las definiciones dentro del espacio local del bloque en el que estamos:

```python
def hola():
    
    def bienvenido():
        return "Hola!"
    
    print( locals() )  # Mostramos el ámbito local

hola()
```

```
{'bienvenido': <function hola.<locals>.bienvenido at 0x000001F867E88C80>}
```

Como vemos se nos muestra un diccionario, aquí encontraremos la función **bienvenido()**.

Podríamos añadir algo más:

```python
lista = [1,2,3]

def hola():
    
    numero = 50
    
    def bienvenido():
        return "Hola!"
    
    print( locals() )  # Mostramos el ámbito local

hola()
```

```
{'bienvenido': <function hola.<locals>.bienvenido at 0x000001F867E88950>, 'numero': 50}
```

Como podemos observar, ahora además de la función tenemos una clave con el número y el valor 50. Sin embargo no encontramos la lista, pues esta se encuentra fuera del ámbito local. De hecho se encuentra en el ámbito global, el cual podemos mostrar con la función reservada **globals()**:

```python
# Antes de ejecutar este bloque reinicia el Notebook para vaciar la memoria.
lista = [1,2,3]

def hola():
    
    numero = 50
    
    def bienvenido():
        return "Hola!"
    
    print( globals() )  # Mostramos el ámbito global

hola()
```

```
{'__name__': '__main__', '_oh': {}, '__doc__': 'Automatically created module for IPython interactive environment', 'lista': [1, 2, 3], '__builtin__': <module 'builtins' (built-in)>, 'In': ['', '# Antes de ejecutar este bloque reinicia el Notebook para vaciar la memoria.\nlista = [1,2,3]\n\ndef hola():\n    \n    numero = 50\n    \n    def bienvenido():\n        return "Hola!"\n    \n    print( globals() )  # Mostramos el ámbito global\n\nhola()'], '_ih': ['', '# Antes de ejecutar este bloque reinicia el Notebook para vaciar la memoria.\nlista = [1,2,3]\n\ndef hola():\n    \n    numero = 50\n    \n    def bienvenido():\n        return "Hola!"\n    \n    print( globals() )  # Mostramos el ámbito global\n\nhola()'], '__loader__': None, '__builtins__': <module 'builtins' (built-in)>, '_dh': ['C:\\CursoPython\\Fase 4 - Temas avanzados\\Tema 15 - Funcionalidades avanzadas\\Apuntes'], 'get_ipython': <bound method InteractiveShell.get_ipython of <ipykernel.zmqshell.ZMQInteractiveShell object at 0x00000243D11F5E80>>, 'hola': <function hola at 0x00000243D1B58C80>, '_sh': <module 'IPython.core.shadowns' from 'C:\\Users\\Hector\\Anaconda3\\lib\\site-packages\\IPython\\core\\shadowns.py'>, '_': '', '_ii': '', 'Out': {}, '__package__': None, '___': '', '_iii': '', '_i': '', '__spec__': None, 'exit': <IPython.core.autocall.ZMQExitAutocall object at 0x00000243D1A92B70>, 'quit': <IPython.core.autocall.ZMQExitAutocall object at 0x00000243D1A92B70>, '_i1': '# Antes de ejecutar este bloque reinicia el Notebook para vaciar la memoria.\nlista = [1,2,3]\n\ndef hola():\n    \n    numero = 50\n    \n    def bienvenido():\n        return "Hola!"\n    \n    print( globals() )  # Mostramos el ámbito global\n\nhola()', '__': ''}
```

Tampoco es necesario que nos paremos a analizar el contenido, pero como podemos observar, desde el ámbito global tenemos acceso a muchas más definiciones porque engloba a su vez todas las de sus bloques padres. 

Si mostramos únicamente las claves del diccionario **globals()**, quizá sería más entendible:

```python
globals().keys()
```



```
dict_keys(['_i4', '__name__', '_oh', '__doc__', 'lista', '__builtin__', 'In', '_i5', '_ih', '__loader__', '__builtins__', '_dh', 'get_ipython', 'hola', '_sh', '_', '_ii', 'Out', '__package__', '___', '_iii', '_i', '__spec__', 'exit', '_i3', 'quit', '_i1', '_i2', '__'])
```



Ahora si buscamos bien encontraremos la clave **lista**, la cual hace referencia a la variable declarada fuera de la función. Incluso podríamos acceder a ella como si fuera un diccionario normal:

```python
globals()['lista']  # Desde la función globals
```

```
[1, 2, 3]
```



```python
lista  # Forma tradicional
```



```
[1, 2, 3]
```



### Funciones como variables

Volviendo a nuestra función **hola()**, ahora sabemos que si la ejecutamos, en realidad estamos accediendo a su función local  **bienvenido()**, pero eso no significa que la ejecutamos, sólo estamos haciendo referencia a ella.

Esa es la razón de que se devuelva su definición y no el resultado de su ejecución:

```python
def hola():
    
    def bienvenido():
        return "Hola!"
    
    return bienvenido

hola()
```



```
<function __main__.hola.<locals>.bienvenido>
```



Por muy raro que parezca, podríamos ejecutarla llamando una segunda vez al paréntesis. La primera para **hola()** y la segunda para **bienvenido()**:

```python
hola()()
```



```
'Hola!'
```



Como es realmente extraño, normalmente lo que hacemos es asignar la función a una variable y ejecutarla como si fuera una nueva función:

```python
bienvenido = hola()
bienvenido()
```



```
'Hola!'
```



A diferencia de las colecciones y los objetos, donde las copias se utilizaban como accesos directos, las copias de las funciones son independientes y aunque borrásemos la original, la nueva copia seguiría existiendo:

```python
del(hola)

bienvenido()
```



```
'Hola!'
```



### Funciones como argumentos

Si ya era extraño ejecutar funciones anidadas, todavía es más extraño el concepto de enviar una función como argumento de otra función, sin embargo gracias a la flexibilidad de Python es posible hacerlo:

```python
def hola():
    return "Hola Mundo!"

def test(funcion):
    print( funcion() )
    
test(hola)
```

```
Hola Mundo!
```

Quizá en este momento no se ocurren muchas utilidades para esta funcionalidad, pero creedme que es realmente útil cuando queremos extender funciones ya existentes sin modificarlas. De ahí que este proceso se conozca como un decorador, y de ahí pasamos directamente a las funciones decoradoras.

### Funciones decoradoras

Una función decoradora es una función que envuelve la ejecución de otra función y permite extender su comportamiento. Están pensadas para reutilazarlas gracias a una sintaxis de ejecución mucho más simple.

Imaginaros estas dos funciones sencillas:

```python
def hola():
    print("Hola!")

def adios():
    print("Adiós!")
```

Y queremos queremos crear un decorador para monitorizar cuando se ejecutan las dos funciones, avisando antes y después. 

Para crear una función decoradora tenemos que recibir la función a ejecutar, y envolver su ejecución con el código a extender:

```python
def monitorizar(funcion):

    def decorar():
        print("\t* Se está apunto de ejecutar la función:", funcion.__name__)
        
        funcion()
        
        print("\t* Se ha finalizado de ejecutar la función:", funcion.__name__)

    return decorar
```

Ahora para realizar la monitorización deberíamos llamar al monitor ejecutando la función enviada y devuelta:

```python
monitorizar(hola)()
```

```
	* Se está apunto de ejecutar la función: hola
Hola!
	* Se ha finalizado de ejecutar la función: hola

```

Sin embargo esto no es muy cómodo, y ahí es cuando aparece la sintaxis que nos permite configurar una función decoradora en una función normal:

```python
@monitorizar
def hola():
    print("Hola!")

@monitorizar
def adios():
    print("Adiós!")
```

Una vez configurada la función decoradora, al utilizar las funciones se ejecutarán automáticamente dentro de la función decoradora:

```python
hola()
print()
adios()
```

```
	* Se está apunto de ejecutar la función: hola
Hola!
	* Se ha finalizado de ejecutar la función: hola

	* Se está apunto de ejecutar la función: adios
Adiós!
	* Se ha finalizado de ejecutar la función: adios

```

### Pasando argumentos al decorador

```python
def monitorizar_args(funcion):

    def decorar(*args,**kwargs):
        print("\t* Se está apunto de ejecutar la función:", funcion.__name__)
        funcion(*args,**kwargs)
        print("\t* Se ha finalizado de ejecutar la función:", funcion.__name__)

    return decorar

@monitorizar_args
def hola(nombre):
    print("Hola {}!".format(nombre))

@monitorizar_args
def adios(nombre):
    print("Adiós {}!".format(nombre))
    
hola("Héctor")
print()
adios("Héctor")
```

```
	* Se está apunto de ejecutar la función: hola
Hola Héctor!
	* Se ha finalizado de ejecutar la función: hola

	* Se está apunto de ejecutar la función: adios
Adiós Héctor!
	* Se ha finalizado de ejecutar la función: adios

```

**Perfecto!** Ahora ya sabes qué son las funciones decoradoras y cómo utilizar el símbolo @ para automatizar su ejecución. Estas funciones se utilizan mucho cuando trabajamos con Frameworks Web como Django, así que seguro te harán servicio si tienes pensado aprender a utilizarlo.



## Funciones generadoras

Por regla general, cuando queremos crear una lista de algún tipo, lo que hacemos es crear la lista vacía, y luego con un bucle varios elementos e ir añadiendolos a la lista si cumplen una condición:

```python
[numero for numero in [0,1,2,3,4,5,6,7,8,9,10] if numero % 2 == 0 ]    
```



```
[0, 2, 4, 6, 8, 10]
```



También vimos cómo era posible utilizar la función **range()** para generar dinámicamente la lista en la memoria, es decir, no teníamos que crearla en el propio código, sino que se interpretaba sobre la marcha:

```python
[numero for numero in range(0,11) if numero % 2 == 0 ]
```



```
[0, 2, 4, 6, 8, 10]
```



La verdad es que **range()** es una especie de función generadora. Por regla general las funciones devolvuelven un valor con **return**, pero la preculiaridad de los generadores es que van *cediendo* valores sobre la marcha, en tiempo de ejecución.

La función generadora **range(0,11)**, empieza cediendo el **0**, luego se procesa el for comprobando si es par y lo añade a la lista, en la siguiente iteración se cede el **1**, se procesa el for se comprueba si es par, en la siguiente se cede el **2**, etc. 

Con esto se logra ocupar el mínimo de espacio en la memoria y podemos generar listas de millones de elementos sin necesidad de almacenarlos previamente. 

Veamos a ver cómo crear una función generadora de pares:

```python
def pares(n):
    for numero in range(n+1):
        if numero % 2 == 0:
            yield numero
        
pares(10)
```



```
<generator object pares at 0x000002945F38BFC0>
```



Como vemos, en lugar de utilizar el **return**, la función generadora utiliza el **yield**, que significa ceder. Tomando un número busca todos los pares desde 0 hasta el número+1 sirviéndonos de un range(). 

Sin embargo, fijaros que al imprimir el resultado, éste nos devuelve un objeto de tipo generador.

De la misma forma que recorremos un **range()** podemos utilizar el bucle for para recorrer todos los elementos que devuelve el generador:

```python
for numero in pares(10):
    print(numero)
```

```
0
2
4
6
8
10
```

Utilizando comprensión de listas también podemos crear una lista al vuelo:

```python
[numero for numero in pares(10)]
```



```
[0, 2, 4, 6, 8, 10]
```



Sin embargo el gran potencial de los generadores no es simplemente crear listas, de hecho como ya hemos visto, el propio resultado no es una lista en sí mismo, sino una secuencia iterable con un montón de características únicas.

### Iteradores

Por tanto las funciones generadoras devuelven un objeto que suporta un protocolo de iteración. ¿Qué nos permite hacer? Pues evidentemente controlar el proceso de generación. Teniendo en cuenta que cada vez que la función generadora cede un elemento, queda suspendida y se retoma el control hasta que se le pide generar el siguiente valor. 

Así que vamos a tomar nuestro ejemplo de pares desde otra perspectiva, como si fuera un iterador manual, así veremos exactamente a lo que me refiero:

```python
pares = pares(3)
```

Bien, ahora tenemos un iterador de pares con todos los números pares entre el 0 y el 3. Vamos a conseguir el primer número par:

```python
next(pares)
```



```
0
```



Como vemos la función integrada **next()** nos permite acceder al siguiente elemento de la secuencia. Pero no sólo eso, si volvemos a ejecutarla...

```python
next(pares)
```



```
2
```



Ahora devuelve el segundo! ¿No os recuerdo esto al puntero de los ficheros? Cuando leíamos una línea, el puntero pasaba a la siguiente y así sucesivamente. Pues aquí igual. 

¿Y qué pasaría si intentamos acceder al siguiente, aún sabiendo que entre el 0 y el 3 sólo tenemos los pares 0 y 2?

```python
next(pares)
```

```
---------------------------------------------------------------------------

StopIteration                             Traceback (most recent call last)

<ipython-input-34-68378216ba43> in <module>()
----> 1 next(pares)
```

```
StopIteration: 
```

Pues que nos da un error porque se ha acabado la secuencia, así que tomad nota y capturad la excepción si váis a utilizarlas sin saber exactamente cuantos elementos os devolverá el generador.

Así que la pregunta que nos queda es ¿sólo es posible iterar secuencias generadas al vuelo? Vamos a probar con una lista:

```python
lista = [1,2,3,4,5]
next(lista)
```

```
---------------------------------------------------------------------------

TypeError                                 Traceback (most recent call last)

<ipython-input-38-28c22b67c419> in <module>()
      1 lista = [1,2,3,4,5]
----> 2 next(lista)
      3 
      4 cadena = "Hola"
      5 next(cadena)
```

```
TypeError: 'list' object is not an iterator
```

¿Quizá con una cadena?

```python
cadena = "Hola"
next(cadena)
```

```
---------------------------------------------------------------------------

TypeError                                 Traceback (most recent call last)

<ipython-input-39-44ca9ed1903b> in <module>()
      1 cadena = "Hola"
----> 2 next(cadena)
```

```
TypeError: 'str' object is not an iterator
```

Pues no, no podemos iterar ninguna colección como si fuera una secuencia. Sin embargo, hay una función muy interesante que nos permite covertir las cadenas y algunas colecciones a iteradores, la función **iter()**:

```python
lista = [1,2,3,4,5]
lista_iterable = iter(lista)
print( next(lista_iterable) )
print( next(lista_iterable) )
print( next(lista_iterable) )
print( next(lista_iterable) )
print( next(lista_iterable) )
```

```
1
2
3
4
5
```



```python
cadena = "Hola"
cadena_iterable = iter(cadena)
print( next(cadena_iterable) )
print( next(cadena_iterable) )
print( next(cadena_iterable) )
print( next(cadena_iterable) )
```

```
H
o
l
a
```

Muy bien, ahora ya sabemos qué son las funciones generadores, cómo utilizarlas, y también como como convertir algunos objetos a iteradores. Os sugiero probar por vuestra cuenta más colecciones a ver si encontráis alguna más que se pueda iterar.





## Funciones Lambda

Si empiezo diciendo que las funciones o expresiones lambda sirven para crear funciones anónimas, posiblemente me diréis ¿qué me estás contando?, así que vamos a tomarlo con calma, pues estamos ante unas de las funcionalidades más potentes de Python a la vez que más confusas para los principiantes. 

Una función anónima, como su nombre indica es una función sin nombre. ¿Es posible ejecutar una función sin referenciar un nombre? Pues sí, en Python podemos ejecutar una función sin definirla con **def**. De hecho son similares pero con una diferencia fundamental:

**El contenido de una función lambda debe ser una única expresión en lugar de un bloque de acciones. **

Y es que más allá del sentido de función que tenemos, con su nombre y sus acciones internas, una función en su sentido más trivial significa realizar algo sobre algo. Por tanto podríamos decir que, mientras las funciones anónimas **lambda** sirven para realizar funciones simples, las funciones definidas con **def** sirven para manejar tareas más extensas.

Si deconstruimos una función sencilla, podemos llegar a una función lambda. Por ejemplo tomad la siguiente función para doblar un valor:

```python
def doblar(num):
    resultado = num*2
    return resultado
```

```python
doblar(2)
```



```
4
```



Vamos a simplificar el código lo máximo posible:

```python
def doblar(num):
    return num*2
```

Todavía más, podemos escribirlo todo en una sola línea:

```python
def doblar(num): return num*2
```

Esta notación simple es la que una función lambda intenta replicar, fijaros, vamos a convertir la función en una función anónima:

```python
lambda num: num*2
```

```
<function __main__.<lambda>>
```



¡Hualá! Aquí tenemos una función anónima con una entrada que recibe **num**, y una salida que devuelve **num * 2**.

Lo único que necesitamos hacer para utilizarla es guardarla en una variable y utilizarla tal como haríamos con una función normal:

```python
doblar = lambda num: num*2

doblar(2)
```

```
4
```



Gracias a la flexibilidad de Python podemos implementar infinitas funciones simples.

**Por ejemplo comprobar si un número es impar:**

```python
impar = lambda num: num%2 != 0
impar(5)
```

```
True
```



**Darle la vuelta a una cadena utilizando slicing:**

```python
revertir = lambda cadena: cadena[::-1]
revertir("Hola")
```

```
'aloH'
```



**Incluso podemos enviar varios valores, por ejemplo para sumar dos números:**

```python
sumar = lambda x,y: x+y
sumar(5,2)
```

```
7
```



Como véis podemos realizar cualquier cosa que se nos ocurra, siempre que lo podamos definir en una sola expresión.

Por ahora lo dejamos aquí, pero en las próximas lecciones veremos como utilizar la función lambda en conjunto con otras funciones como **filter()** y **map()**, que es cuando sale a relucir su verdadero potencial.



## Función filter()

Tal como su nombre indica filter significa filtrar, y es una de mis funciones favoritas, ya que a partir de una lista o iterador, y una función condicional, es capaz de devolver una nueva colección con los elementos filtrados que cumplan la condición. Por ejemplo, supongamos que tenemos una lista varios números y queremos filtrarla, quedándonos únicamente con los múltiples de 5...

```python
def multiple(numero):     # Primero declaramos una función condicional
    if numero % 5 == 0:   # Comprobamos si un numero es múltiple de cinco
        return True       # Sólo devolvemos True si lo es
    
numeros = [2, 5, 10, 23, 50, 33]

filter(multiple, numeros)
```

```
<filter at 0x257ac84abe0>
```



Si ejecutamos el filtro obtenemos un objeto de tipo filtro, pero podemos transformarlo en una lista fácilmente haciendo un cast:

```python
list( filter(multiple, numeros) )
```

```
[5, 10, 50]
```



Por tanto cuando utilizamos la función **filter()** tenemos que enviar una función condicional, pero como recordaréis, no es necesario definirla, podemos utlizar una función anónima lambda:

```python
list( filter(lambda numero: numero%5 == 0, numeros) )
```

```
[5, 10, 50]
```



Así, en una sola línea hemos definido y ejecutado el filtro utilizando una función condicional anónima y una lista de numeros.

### Filtrando objetos

Sin embargo, para mí, más allá de filtrar listas con valores simples, el verdadero potencial de **filter()** sale a relucir cuando necesitamos filtrar varios objetos de una lista.

Por ejemplo, dada una lista con varias personas, nos gustaría filtrar únicamente las que son menores de edad:

```python
class Persona:
    
    def __init__(self, nombre, edad):
        self.nombre = nombre
        self.edad = edad
        
    def __str__(self):
        return "{} de {} años".format(self.nombre, self.edad)

    
personas = [
    Persona("Juan", 35),
    Persona("Marta", 16),
    Persona("Manuel", 78),
    Persona("Eduardo", 12)
]
```

Para hacerlo nos vamos a servir de una función lambda, comprobando el campo edad para cada persona:

```python
menores = filter(lambda persona: persona.edad < 18, personas)

for menor in menores:
    print(menor)
```

```
Marta de 16 años
Eduardo de 12 años
```

Sé que es un ejemplo sencillo, pero estoy seguro que os puede servir como base para realizar filtrados en muchos de vuestros proyectos.



## Función map()

Esta función trabaja de una forma muy similar a **filter()**, con la diferencia que en lugar de aplicar una condición a un elemento de una lista o secuencia, aplica una función sobre todos los elementos y como resultado se devuelve un iterable de tipo map:

```python
def doblar(numero):
    return numero*2
    
numeros = [2, 5, 10, 23, 50, 33]

map(doblar, numeros)
```

```
<map at 0x212eb6e0748>
```



Fácilmente podemos transformar este iterable en una lista:

```python
list(map(doblar, numeros))
```

```
[4, 10, 20, 46, 100, 66]
```



Y podemos simplificarlo con una función lambda para substituir la llamada de una función definida:

```python
list( map(lambda x: x*2, numeros) )
```

```
[4, 10, 20, 46, 100, 66]
```



La función **map()** se utiliza mucho junto a expresiones lambda ya que permite ahorrarnos el esfuerzo de crear bucles for.

Además se puede utilizar sobre más de un iterable con la condición que tengan la misma longitud. 

Por ejemplo si queremos multiplicar los números de dos listas:

```python
a = [1, 2, 3, 4, 5]
b = [6, 7, 8, 9, 10]

list( map(lambda x,y : x*y, a,b) )
```

```
[6, 14, 24, 36, 50]
```



E incluso podemos extender la funcionalidad a tres listas o más:

```python
c = [11, 12, 13, 14, 15]

list( map(lambda x,y,z : x*y*z, a,b,c) )
```

```
[66, 168, 312, 504, 750]
```



### Mapeando objetos

Evidentemente, siempre que la utilicemos correctamente podemos mapear una serie de objetos sin ningún problema:

```python
class Persona:
    
    def __init__(self, nombre, edad):
        self.nombre = nombre
        self.edad = edad
        
    def __str__(self):
        return "{} de {} años".format(self.nombre, self.edad)

    
personas = [
    Persona("Juan", 35),
    Persona("Marta", 16),
    Persona("Manuel", 78),
    Persona("Eduardo", 12)
]
```

Por ejemplo una función para incrementar un año de edad a todas las personas de la lista:

```python
def incrementar(p):
    p.edad += 1
    return p

personas = map(incrementar, personas)

for persona in personas:
    print(persona)
```

```
Juan de 36 años
Marta de 17 años
Manuel de 79 años
Eduardo de 13 años
```

Claro que en este caso tenemos que utilizar una función definida porque no necesitamos actuar sobre la instancia, a no ser que nos tomemos la molestia de rehacer todo el objeto:

```python
personas = [
    Persona("Juan", 35),
    Persona("Marta", 16),
    Persona("Manuel", 78),
    Persona("Eduardo", 12)
]

personas = map(lambda p: Persona(p.nombre, p.edad+1), personas)

for persona in personas:
    print(persona)
```

```
Juan de 36 años
Marta de 17 años
Manuel de 79 años
Eduardo de 13 años
```

Y con esto acabamos esta interesante funcionalidad.



## Expresiones regulares

Una de las tareas más utilizadas en la programación es la búsqueda de subcadenas o patrones dentro de otras cadenas de texto.

Las expresiones regulares, también conocidas como 'regex' o 'regexp', son patrones de búsqueda definidos con una sintaxis formal. Siempre que sigamos sus reglas, podremos realizar búsquedas simples y avanzadas, que utilizadas en conjunto con otras funcionalidades, las vuelven una de las opciones más útiles e importantes de cualquier lenguaje.

Sin embargo antes de utilizarlas hay que estar seguros de lo que hacemos, de ahí aquella famosa frase de [Jamie Zawinski](https://es.wikipedia.org/wiki/Jamie_Zawinski), programador y hacker:

> *Some people, when confronted with a problem, think "I know, I'll use regular expressions." Now they have two problems.*

Que viene a decir:

> *Hay gente que, cuando se enfrenta a un problema, piensa "Ya sé, usaré expresiones regulares". Ahora tienen dos problemas.*

### Métodos básicos

#### re.search: buscar un patrón en otra cadena

```python
import re

texto = "En esta cadena se encuentra una palabra mágica"

re.search('mágica', texto)
```

```
<_sre.SRE_Match object; span=(40, 46), match='mágica'>
```



Como vemos, al realizar la búsqueda lo que nos encontramos es un objeto de tipo *Match* (encontrado), en lugar un simple *True* o *False*.

En cambio, si no se encontrase la palabra, no se devolvería nada (*None*):

```python
re.search('hola', texto)
```

Por tanto, podemos utilizar la propia funcionalidad junto a un condicional sin ningún problema:

```python
palabra = "mágica"

encontrado = re.search(palabra,  texto)

if encontrado:
    print("Se ha encontrado la palabra:", palabra)
else:
    print("No se ha encontrado la palabra:", palabra)
```

```
Se ha encontrado la palabra: mágica
```

Sin embargo, volviendo al objeto devuelto de tipo *Match*, éste nos ofrece algunas opciones interesantes.

```python
print( encontrado.start() )  # Posición donde empieza la coincidencia
print( encontrado.end() )    # Posición donde termina la coincidencia
print( encontrado.span() )   # Tupla con posiciones donde empieza y termina la coincidencia
print( encontrado.string )   # Cadena sobre la que se ha realizado la búsqueda
```

```
40
46
(40, 46)
En esta cadena se encuentra una palabra mágica
```

Como vemos, en este objeto se esconde mucha más información de la que parece a simple vista, luego seguiremos hablando de ellos.

#### re.match: buscar un patrón al principio de otra cadena

```python
texto = "Hola mundo"
re.match('Hola', texto)
```

```
<_sre.SRE_Match object; span=(0, 4), match='Hola'>
```



```python
texto = "Hola mundo"
re.match('Mola', texto)  # no devuelve nada
```



Podemos extraer grupos de texto con `()` 

```python
texto = 'https://www.elitetorrent.biz/series/tell-me-a-story-temporada-1-capitulo-9-espanol/'
con = re.match(r".*series/(.*)-(temporada-[0-9]*)-(.*)", texto)
print(con.groups())
```

```python
('tell-me-a-story', 'temporada-1', 'capitulo-9-espanol/')
```



#### re.split: dividir una cadena a partir de un patrón

```python
texto = "Vamos a dividir esta cadena"
re.split(' ', texto)
```

```
['Vamos', 'a', 'dividir', 'esta', 'cadena']
```



#### re.sub: sustituye todas las coincidencias en una cadena

```python
texto = "Hola amigo"
re.sub('amigo', 'amiga', texto)
```

```
'Hola amiga'
```



#### re.findall: buscar todas las coincidencias en una cadena

```python
texto = "hola adios hola hola"
re.findall('hola', texto)
```

```
['hola', 'hola', 'hola']
```



Aquí se nos devuelve una lista, pero podríamos aplicar la función *len()* para saber el número:

```python
len(re.findall('hola', texto))
```

```
3
```



### Patrones con múltiples alternativas

Si queremos comprobar varias posibilidades, podemos utilizar una tubería | a modo de OR. Generalmente pondremos el listado de alternativas entre paréntesis ():

```python
texto = "hola adios hello bye"
re.findall('hola|hello', texto)
```

```
['hola', 'hello']
```



### Patrones con sintaxis repetida

Otra posibilidad que se nos ofrece es la de buscar patrones con letras repetidas, y aquí es donde se empieza a poner interesante. Como podemos o no saber de antemano el número de repeticiones hay varias formas de definirlos.

```python
texto = "hla hola hoola hooola hooooola"
```

Antes de continuar, y para aligerar todo el proceso, vamos a crear una función capaz de ejecutar varios patrones en una lista sobre un texto:

```python
def buscar(patrones, texto):
    for patron in patrones:
        print( re.findall(patron, texto) )

patrones = ['hla', 'hola', 'hoola']
buscar(patrones, texto)
```

```
['hla']
['hola']
['hoola']
```

#### Con meta-carácter *

Lo utilizaremos para definir ninguna o más repeticiones de la letra a la izquierda del meta-carácter:

```python
patrones = ['ho','ho*','ho*la','hu*la']  # 'ho', 'ho[0..N]', 'ho[0..N]la', 'hu[0..N]la'
buscar(patrones, texto)
```

```
['ho', 'ho', 'ho', 'ho']
['h', 'ho', 'hoo', 'hooo', 'hooooo']
['hla', 'hola', 'hoola', 'hooola', 'hooooola']
['hla']
```

#### Con meta-carácter +

Lo utilizaremos para definir una o más repeticiones de la letra a la izquierda del meta-carácter:

```python
patrones = ['ho*', 'ho+']  # 'ho[0..N], 'ho[1..N]'
buscar(patrones, texto)
```

```
['h', 'ho', 'hoo', 'hooo', 'hooooo']
['ho', 'hoo', 'hooo', 'hooooo']
```

#### Con meta-carácter ?

Lo utilizaremos para definir una o ninguna repetición de la letra a la izquierda del meta-carácter:

```python
patrones = ['ho*', 'ho+', 'ho?', 'ho?la']  # 'ho[0..N], 'ho[1..N]', 'ho[0..1]', 'ho[0..1]la'
buscar(patrones, texto)
```

```
['h', 'ho', 'hoo', 'hooo', 'hooooo']
['ho', 'hoo', 'hooo', 'hooooo']
['h', 'ho', 'ho', 'ho', 'ho']
['hla', 'hola']
```

#### Con número de repeticiones explícito {n}

Lo utilizaremos para definir 'n' repeticiones exactas de la letra a la izquierda del meta-carácter:

```python
patrones = ['ho{0}la', 'ho{1}la', 'ho{2}la']  # 'ho[0]la', 'ho[1]la', 'ho[2]la'
buscar(patrones, texto)
```

```
['hla']
['hola']
['hoola']

```

#### Con número de repeticiones en un rango  {n, m}

Lo utilizaremos para definir un número de repeticiones variable entre 'n' y 'm' de la letra a la izquierda del meta-carácter:

```python
patrones = ['ho{0,1}la', 'ho{1,2}la', 'ho{2,9}la']  # 'ho[0..1]la', 'ho[1..2]la', 'ho[2..9]la'
buscar(patrones, texto)
```

```
['hla', 'hola']
['hola', 'hoola']
['hoola', 'hooola', 'hooooola']

```

#### Trabajando con conjuntos de caracteres [ ]

Cuando nos interese crear un patrón con distintos carácteres, podemos definir conjuntos entre paréntesis:

```python
texto = "hala hela hila hola hula"

patrones = ['h[ou]la', 'h[aio]la', 'h[aeiou]la']
buscar(patrones, texto)
```

```
['hola', 'hula']
['hala', 'hila', 'hola']
['hala', 'hela', 'hila', 'hola', 'hula']

```

Evidentemente los podemos utilizar con repeticiones:

```python
texto = "haala heeela hiiiila hoooooola"

patrones = ['h[ae]la', 'h[ae]*la', 'h[io]{3,9}la']
buscar(patrones, texto)
```

```
[]
['haala', 'heeela']
['hiiiila', 'hoooooola']

```

#### Exclusión en grupos [^ ]

Cuando utilizamos grupos podemos utilizar el operador de exclusión ^ para indicar una búsqueda contraria:

```python
texto = "hala hela hila hola hula"

patrones = ['h[o]la', 'h[^o]la'] 
buscar(patrones, texto)
```

```
['hola']
['hala', 'hela', 'hila', 'hula']

```

Si excluimos una expresión regular con un grupo excluido, en realidad tenemos lo mismo:

#### Rangos [ - ]

Otra característica que hace ultra potentes los grupos, es la capacidad de definir rangos. Ejemplos de rangos:

- **[A-Z]**: Cualquier carácter alfabético en mayúscula (no especial ni número)
- **[a-z]**: Cualquier carácter alfabético en minúscula (no especial ni número)
- **[A-Za-z]**: Cualquier carácter alfabético en minúscula o mayúscula (no especial ni número)
- **[A-z]**: Cualquier carácter alfabético en minúscula o mayúscula (no especial ni número)
- **[0-9]**: Cualquier carácter numérico (no especial ni alfabético)
- **[a-zA-Z0-9]**: Cualquier carácter alfanumérico (no especial)

Tened en cuenta que cualquier rango puede ser excluido para conseguir el patrón contrario.

```python
texto = "hola h0la Hola mola m0la M0la"

patrones = ['h[a-z]la', 'h[0-9]la', '[A-z]{4}', '[A-Z][A-z0-9]{3}'] 
buscar(patrones, texto)
```

```
['hola']
['h0la']
['hola', 'Hola', 'mola']
['Hola', 'M0la']

```

#### Códigos escapados \

Si cada vez que quisiéramos definir un patrón variable tuviéramos que crear rangos, al final tendríamos expresiones regulares gigantes. Por suerte su sintaxis también acepta una serie de caracteres escapados que tienen un significo único. Algunos de los más importantes son:

| Código | Significado          |
| :----: | :------------------- |
|   \d   | numérico             |
|   \D   | no numérico          |
|   \s   | espacio en blanco    |
|   \S   | no espacio en blanco |
|   \w   | alfanumérico         |
|   \W   | no alfanumérico      |

El problema que encontraremos en Python a la hora de definir código escapado, es que las cadenas no tienen en cuenta el \ a no ser que especifiquemos que son cadenas en crudo (raw), **por lo que tendremos que precedir las expresiones regulares con una 'r'**.

```python
texto = "Este curso de Python se publicó en el año 2016"

patrones = [r'\d+', r'\D+', r'\s', r'\S+', r'\w+', r'\W+'] 
buscar(patrones, texto)
```

```
['2016']
['Este curso de Python se publicó en el año ']
[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
['Este', 'curso', 'de', 'Python', 'se', 'publicó', 'en', 'el', 'año', '2016']
['Este', 'curso', 'de', 'Python', 'se', 'publicó', 'en', 'el', 'año', '2016']
[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']

```

Por mi parte lo vamos a dejar aquí, pero el mundo de las expresiones regulares es gigantesco y daría para un curso entero. Os animo a seguir aprendiendo leyendo documentación y buscando ejemplos. 

Aquí os dejo algunos enlaces que quizá os pueden servir, en inglés:

### Documentación

Hay docenas y docenas de códigos especiales, si queréis echar un vistazo a todos ellos podéis consultar la documentación oficial:

- https://docs.python.org/3.5/library/re.html#regular-expression-syntax

Un resumen por parte de Google Eduactión: 

- https://developers.google.com/edu/python/regular-expressions

Otro resumen muy interesante sobre el tema:

- https://www.tutorialspoint.com/python/python_reg_expressions.htm

Un par de documentos muy trabajados con ejemplos básicos y avanzados:

- http://www.python-course.eu/python3_re.php
- http://www.python-course.eu/python3_re_advanced.php