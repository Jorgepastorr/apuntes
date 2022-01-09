
# Manejo de datos



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

Un conjunto auto-elimina elementos duplicados

```python
test = {'Hector','Hector','Hector'}
print(test)
```

```
{'Hector'}
```

### Método add()

Sirve para añadir elementos al conjunto. Si un elemento ya se encuentra, no se añadirá de nuevo.

```python
conjunto = set()
conjunto = {1,2,3}
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


### lista a conjunto y viceversa

Es muy útil transformar listas a conjuntos para borrar los elementos duplicados automáticamente.

```python
l = [1,2,3,3,2,1]
print(l)
```

```
[1, 2, 3, 3, 2, 1]
```

Convertir lista a conjunto

```python
c = set(l)
```

```python
print(c)
```

```
{1, 2, 3}
```

Convertir conjunto a lista

```python
l = list(c)
print(l)
```

```
[1, 2, 3]
```


Conversion en una linea, lista --> conjunto --> lista

```python
l = [1,2,3,3,2,1]
# En una línea
l = list( set( l ) )
print(l)
```

```
[1, 2, 3]
```



### cadena a conjunto

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

Tipo de variable

```python
type(vacio)
```

```
dict
```

### Sintaxis

Para cada elemento se define la estructura -> `clave:valor`

```python
colores = {'amarillo':'yellow','azul':'blue'}
```

También se pueden añadir elementos sobre la marcha

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



### Modificación de valor a partir de la clave

```python
colores['amarillo'] = 'white'
print(colores)
```

```
{'amarillo': 'white', 'azul': 'blue', 'verde': 'green'}
```


### Función del()

Sirve para borrar un elemento del diccionario.

```python
del(colores['amarillo'])
print(colores)
```

```
{'azul': 'blue', 'verde': 'green'}

```



### Directamente con registros

```python
edades = {'Hector':27,'Juan':45,'Maria':34}
edades['Hector']+=1
print(edades)
```

```
{'Hector': 28, 'Juan': 45, 'Maria': 34}

```



### Lectura secuencial con for

Es posible utilizar una iteración for para recorrer los elementos del diccionario:

```python
for edad in edades:
    print(edad)
```

```
Maria
Hector
Juan

```

> El problema es que se devuelven las claves, no los valores

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

### listas de disccionarios

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



### Valor por defecto

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



### Diccionarios ordenados

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

Las podemos crear como listas normales y añadir elementos al final con el append():

```python
pila = [3,4,5]
pila.append(6)
pila.append(7)
print(pila)
```

```
[3, 4, 5, 6, 7]

```



Para sacar los elementos utilizaremos el método .pop():

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

> Si hacemos pop() de una pila vacía, devolverá un error:

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

Debemos importar la colección *deque* manualmente para crear una cola:

```python
from collections import deque

cola = deque()
print(cola)
```

```
deque([])

```



Podemos añadir elemento directamente pasando una lista a la cola al crearla:

```python
cola = deque(['Hector','Juan','Miguel'])
print(cola)
```

```
deque(['Hector', 'Juan', 'Miguel'])

```



Y también utilizando el método `.append()`:

```python
cola.append('Maria')
cola.append('Arnaldo')
print(cola)
```

```
deque(['Hector', 'Juan', 'Miguel', 'Maria', 'Arnaldo'])

```

A la hora de sacar los elementos utilizaremos el método `popleft()` para extraerlos por la parte izquierda (el principio de la cola). 

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

