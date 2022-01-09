# Métodos de colecciones

## Métodos de las cadenas

### upper(): 

Devuelve la cadena con todos sus caracteres a mayúscula

```python
"Hola Mundo".upper()
```

    'HOLA MUNDO'

### lower(): 

Devuelve la cadena con todos sus caracteres a minúscula

```python
"Hola Mundo".lower()
```

    'hola mundo'

### capitalize(): 

Devuelve la cadena con su primer carácter en mayúscula

```python
"hola mundo".capitalize()
```

    'Hola mundo'


### title(): 

Devuelve la cadena con el primer carácter de cada palabra en mayúscula

```python
"hola mundo".title()
```

    'Hola Mundo'

### count(): 

Devuelve una cuenta de las veces que aparece una subcadena en la cadena

```python
"Hola mundo".count('mundo')
```

    1

### find(): 

Devuelve el índice en el que aparece la subcadena (-1 si no aparece)

```python
"Hola mundo".find('mundo')
```

    5


```python
"Hola mundo".find('mundoz')
```

    -1

### rfind():  

Devuelve el índice en el que aparece la subcadena, empezando por el final

```python
"Hola mundo mundo mundo".rfind('mundo')
```

    17

### isdigit(): 

Devuelve True si la cadena es todo números (False en caso contrario)

```python
c = "100"
```

```python
c.isdigit()
```

    True

### isalnum(): 

Devuelve True si la cadena es todo números o carácteres alfabéticos

```python
c2 = "ABC10034po"
```

```python
c2.isalnum()
```

    True

### isalpha(): 

Devuelve True si la cadena es todo carácteres alfabéticos

```python
c2.isalpha()
```

    False

```python
"Holamundo".isalpha()
```

    True

### islower(): 

Devuelve True si la cadena es todo minúsculas

```python
"Hola mundo".islower()
```

    False

### isupper(): 

Devuelve True si la cadena es todo mayúsculas

```python
"Hola mundo".isupper()
```

    False

### istitle(): 

Devuelve True si la primera letra de cada palabra es mayúscula

```python
"Hola Mundo".istitle()
```

    True

### isspace(): 

Devuelve True si la cadena es todo espacios

```python
"  -  ".isspace()
```

    False

### startswith():

Devuelve True si la cadena empieza con una subcadena

```python
"Hola mundo".startswith("Mola")
```

    False

### endswith(): 

Devuelve True si la cadena acaba con una subcadena

```python
"Hola mundo".endswith('mundo')
```

    True

### split(): 

Separa la cadena en subcadenas a partir de sus espacios y devuelve una lista

```python
"Hola mundo mundo".split()[0]
```

    'Hola'

Podemos indicar el carácter a partir del que se separa:

```python
"Hola,mundo,mundo,otra,palabra".split(',')
```

    ['Hola', 'mundo', 'mundo', 'otra', 'palabra']

### join(): 

Une todos los caracteres de una cadena utilizando un caracter de unión

```python
",".join("Hola mundo")
```

    'H,o,l,a, ,m,u,n,d,o'


```python
" ".join("Hola")
```

    'H o l a'

### strip(): 

Borra todos los espacios por delante y detrás de una cadena y la devuelve

```python
"   Hola mundo     ".strip()
```

    'Hola mundo'

Podemos indicar el carácter a borrar:

```python
"-----Hola mundo---".strip('-')
```

    'Hola mundo'

### replace(): 

Reemplaza una subcadena de una cadena por otra y la devuelve

```python
"Hola mundo".replace('o','0')
```

    'H0la mund0'

Podemos indicar un límite de veces a reemplazar:

```python
"Hola mundo mundo mundo mundo mundo".replace(' mundo','',4)
```

    'Hola mundo'

## Métodos de las listas

### append(): 

Añade un ítem al final de la lista

```python
lista = [1,2,3,4,5]
lista.append(6)
```

### clear(): 

Vacía todos los ítems de una lista

```python
print(lista)
```

```
[1, 2, 3, 4, 5, 6]
```

```python
lista.clear()
```

```python
print(lista)
```

```
[]
```

### extend(): 

Une una lista a otra

```python
l1 = [1,2,3]
l2 = [4,5,6]

l1.extend(l2)
```

### count(): 

Cuenta el número de veces que aparece un ítem

```python
l1
```

```
[1, 2, 3, 4, 5, 6]
```

```python
["Hola", "mundo", "mundo"].count("Hola")
```

```
1
```

### index(): 

Devuelve el índice en el que aparece un ítem (error si no aparece)

```python
["Hola", "mundo", "mundo"].index("mundo")
```

```
1
```

```python
["Hola", "mundo", "mundo"].index("mundoz")
```

```
---------------------------------------------------------------------------

ValueError                                Traceback (most recent call last)

<ipython-input-1-3c3755903d17> in <module>()
----> 1 ["Hola", "mundo", "mundo"].index("mundoz")
```

```
ValueError: 'mundoz' is not in list
```

### insert(indice, valor): 

Agrega un ítem a la lista en un índice específico. Primera posición (0)

```python
l = [1,2,3]
l.insert(0,0)
```

```python
print(l)
```

```
[0, 1, 2, 3]
```

Penúltima posición (-1)

```python
l = [5,10,15,25]
l.insert(-1,20)
```

```python
print(l)
```

```
[5, 10, 15, 20, 25]
```

Última posición en una lista (podemos utilizar len)

```python
n = len(l)
l.insert(n,30)
```

```python
print(l)
```

```
[5, 10, 15, 20, 25, 30]
```

Una posición fuera de rango (999)

```python
l.insert(20,999)
```

```python
print(l)
```

```
[5, 10, 15, 20, 25, 30, 999]
```

### pop(): 

Extrae un ítem de la lista y lo borra

```python
l = [10,20,30,40,50]
```

```python
l.pop()
```

```
50
```



```python
print(l)
```

```
[10, 20, 30, 40]
```

Podemos indicarle un índice con el elemento a sacar (0 es el primer ítem)

```python
l.pop(0)
```

```
10
```

```python
print(l)
```

```
[20, 30, 40]

```

### remove(): 

Borra un ítem de la lista directamente a partir del índice

```python
l.remove(30)
```

```python
print(l)
```

```
[20, 40]
```

```python
l = [20,30,30,30,40]
```

```python
l.remove(30)
```

```python
print(l)
```

```
[20, 30, 30, 40]
```

### reverse(): 

Le da la vuelta a la lista actual

```python
l.reverse()
```

```python
print(l)
```

```
[40, 30, 30, 20]
```

Las cadenas no tienen el método `.reverse()` pero podemos simularlo haciendo unas conversiones...

```python
"Hola mundo".reverse()
```

```
---------------------------------------------------------------------------

AttributeError                            Traceback (most recent call last)

<ipython-input-58-eb5308f434bf> in <module>()
----> 1 "Hola mundo".reverse()

```

```
AttributeError: 'str' object has no attribute 'reverse'

```

```python
lista = list("Hola mundo")
lista
```

```
['H', 'o', 'l', 'a', ' ', 'm', 'u', 'n', 'd', 'o']
```



```python
lista.reverse()
lista
```

```
['o', 'd', 'n', 'u', 'm', ' ', 'a', 'l', 'o', 'H']
```



```python
cadena = "".join(lista)
cadena
```

```
'odnum aloH'
```



### sort(): 

Ordena automáticamente los ítems de una lista por su valor de menor a mayor

```python
lista = [5,-10,35,0,-65,100]
lista.sort()
lista
```

```
[-65, -10, 0, 5, 35, 100]
```

Podemos utilizar el argumento reverse=True para indicar que la ordene del revés

```python
lista.sort(reverse=True)
lista
```

```
[100, 35, 5, 0, -10, -65]
```

## Métodos de los conjuntos

```python
c = set()
```

### add(): 

Añade un ítem a un conjunto, si ya existe no lo añade

```python
c.add(1)
c.add(2)
c.add(3)
print(c)
```

```
{1, 2, 3}
```



### discard(): 

Borra un ítem de un conjunto

```python
c.discard(1)
print(c)
```

```
{2, 3}
```

*Cuando creas una copia realmente es un enlace directo*

```python
c.add(1)
c2 = c
c2.add(4)
print(c)
```

```
{1, 2, 3, 4}
```

### copy(): 

Crea una copia de un conjunto

*Recordad que los tipos compuestos no se pueden copiar, son como accesos directos  por referencia*

```python
c2 = c.copy()
print(c2)
```

```
{1, 2, 3, 4}
```



```python
print(c)
```

```
{1, 2, 3, 4}
```



```python
c2.discard(4)
print(c2)
```

```
{1, 2, 3}
```



```python
print(c)
```

```
{1, 2, 3, 4}
```



### clear():  

Borra todos los ítems de un conjunto

```python
c2.clear()
```

```python
c2
```

```
set()
```

## Comparación de conjuntos

```python
c1 = {1,2,3}
c2 = {3,4,5}
c3 = {-1,99}
c4 = {1,2,3,4,5}
```

### isdisjoint(): 

Comprueba si el conjunto es disjunto de otro conjunto

*Si no hay ningún elemento en común entre ellos*

```python
c1.isdisjoint(c2)
```

```
False
```

### issubset(): 

Comprueba si el conjunto es subconjunto de otro conjunto

*Si sus ítems se encuentran todos dentro de otro*

```python
c3.issubset(c4)
```

```
False
```

### issuperset(): 

Comprueba si el conjunto es contenedor de otro subconjunto

*Si contiene todos los ítems de otro*

```python
c3.issuperset(c1)
```

```
False
```

## Métodos avanzados

Se utilizan para realizar uniones, diferencias y otras operaciones avanzadas entre conjuntos.

Suelen tener dos formas, la normal que **devuelve** el resultado, y otra que hace lo mismo pero **actualiza** el propio resultado.

```python
c1 = {1,2,3}
c2 = {3,4,5}
c3 = {-1,99}
c4 = {1,2,3,4,5}
```

### union(): 

Une un conjunto a otro y devuelve el resultado en un nuevo conjunto

```python
c1.union(c2) == c4
```

```
True
```



```python
c1.union(c2)
```

```
{1, 2, 3, 4, 5}
```



```python
print(c1)
```

```
{1, 2, 3}

```



```python
print(c2)
```

```
{3, 4, 5}

```



### update(): 

Une un conjunto a otro en el propio conjunto

```python
c1.update(c2)
print(c1)
```

```
{1, 2, 3, 4, 5}

```

### difference(): 

Encuentra los elementos no comunes entre dos conjuntos

```python
c1 = {1,2,3}
c2 = {3,4,5}
c3 = {-1,99}
c4 = {1,2,3,4,5}
c1.difference(c2)
```

```
{1, 2}
```

### difference_update(): 

Guarda  en el conjunto los elementos no comunes entre dos conjuntos

```python
c1.difference_update(c2)
```

```python
print(c1)
```

```
{1, 2}

```



### intersection(): 

Devuelve un conjunto con los elementos comunes en dos conjuntos

```python
c1 = {1,2,3}
c2 = {3,4,5}
c3 = {-1,99}
c4 = {1,2,3,4,5}
```

```python
c1.intersection(c2)
```

```
{3}

```



### intersection_update(): 

Guarda en el conjunto los elementos comunes entre dos conjuntos

```python
c1.intersection_update(c2)
c1
```

```
{3}

```

### symmetric_difference(): 

Devuelve los elementos simétricamente diferentes entre dos conjuntos

*Todos los elementos que no concuerdan entre los dos conjuntos*

```python
c1 = {1,2,3}
c2 = {3,4,5}
c3 = {-1,99}
c4 = {1,2,3,4,5}
```

```python
c1.symmetric_difference(c2)
```

```
{1, 2, 4, 5}

```



## Métodos de los diccionarios

```python
colores = { "amarillo":"yellow", "azul":"blue", "verde":"green" }
colores['amarillo']
```

```
'yellow'
```

### get(): 

Busca un elemento a partir de su clave y si no lo encuentra devuelve un valor por defecto

```python
colores.get('negro','no se encuentra')
```

```
'no se encuentra'
```



```python
'amarillo' in colores
```

```
True
```



### keys(): 

Genera una lista en clave de los registros del diccionario

```python
colores.keys()
```

```
dict_keys(['amarillo', 'azul', 'verde'])
```



### values():  

Genera una lista en valor de los registros del diccionario

```python
colores.values()
```

```
dict_values(['yellow', 'blue', 'green'])
```



### items(): 

Genera una lista en clave-valor de los registros del diccionario

```python
colores.items()
```

```
dict_items([('amarillo', 'yellow'), ('azul', 'blue'), ('verde', 'green')])
```



```python
for c in colores:
    print(colores[c])
```

```
yellow
blue
green
```



```python
for c,v in colores.items():
    print(c,v) # clave, valor
```

```
amarillo yellow
azul blue
verde green
```

### pop(): 

Extrae un registro de un diccionario a partir de su clave y lo borra, acepta valor por defecto

```python
colores.pop("amarillo","no se ha encontrado")
```

```
'yellow'
```



```python
print(colores)
```

```
{'azul': 'blue', 'verde': 'green'}
```



```python
colores.pop("negro","no se ha encontrado")
```

```
'no se ha encontrado'
```



```python
print(colores)
```

```
{'azul': 'blue', 'verde': 'green'}
```



### clear(): 

Borra todos los registros de un diccionario

```python
colores.clear()
print(colores)
```

```
{}
```

