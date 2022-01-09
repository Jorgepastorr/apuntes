# Módulos


## El módulo collections



### Contador

Es una subclase de diccionario utilizada para realizar cuentas.

Cuenta las veces que hay repetido un elemento, sea númerico o caracter.


```python
from collections import Counter
```

```python
l = [1,2,3,4,1,2,3,1,2,1]
Counter(l)
```


    Counter({1: 4, 2: 3, 3: 2, 4: 1})




```python
p = "palabra"
Counter(p)
```


    Counter({'a': 3, 'b': 1, 'l': 1, 'p': 1, 'r': 1})




```python
animales = "gato perro canario perro canario perro"
Counter(animales)
```


    Counter({' ': 5,
             'a': 5,
             'c': 2,
             'e': 3,
             'g': 1,
             'i': 2,
             'n': 2,
             'o': 6,
             'p': 3,
             'r': 8,
             't': 1})


Con split separamos por palabras


```python
animales.split()
```

    ['gato', 'perro', 'canario', 'perro', 'canario', 'perro']

Ahora podemos contar las palabras repetidas


```python
Counter(animales.split())
```

    Counter({'canario': 2, 'gato': 1, 'perro': 3})



#### most_common()

Permite mostrar los mas comunes


```python
c = Counter(animales.split())
```


```python
c.most_common(1)
```

    [('perro', 3)]


```python
c.most_common(2)
```


    [('perro', 3), ('canario', 2)]




```python
c.most_common()
```


    [('perro', 3), ('canario', 2), ('gato', 1)]


## Tuplas con nombres

Subclase de las tuplas utilizada para crear pequeñas estructuras inmutables, parecidas a una clase y sus objetos pero mucho más simples.


```python
t = (20,40,60)
```


```python
t[0]
```

    20

```python
t[-1]
```

    60

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

    'Hector'

```python
p.apellido
```

    'Costa'

```python
p.edad
```

    27

```python
p
```

    Persona(nombre='Hector', apellido='Costa', edad=27)

```python
p[0]
```

    'Hector'

```python
p[1]
```

    'Costa'

```python
p[-1]
```

    27

Al ser una tupla, no se puede modificar


```python
p.nombre = "Hola"
```

    ---------------------------------------------------------------------------
    
    AttributeError                            Traceback (most recent call last)
    
    <ipython-input-91-5cd7aba08457> in <module>()
    ----> 1 p.nombre = "Hola"


    AttributeError: can't set attribute


## El módulo datetime



```python
import datetime
```

```python
dt = datetime.datetime.now() # Ahora
dt
```

```
datetime.datetime(2016, 6, 18, 21, 29, 28, 607208)
```

```python
dt.year # año
```

```
2016
```


```python
dt.month # mes
```

```
6
```

```python
dt.day # día
```

```
18
```

```python
print("{}:{}:{}".format(dt.hour, dt.minute, dt.second))
```

```
21:29:28
```

```python
print("{}/{}/{}".format(dt.day, dt.month, dt.year))
```

```
18/6/2016
```

Crear un datetime manualmente (year, month, day, hour=0, minute=0, second=0, microsecond=0, tzinfo=None)

*Notad que sólo son obligatorios el año, el mes y el día*

```python
dt = datetime.datetime(2000,1,1)
```

```python
dt
```

```
datetime.datetime(2000, 1, 1, 0, 0)
```



```python
dt.year = 3000 # Error en asignación
```

```
---------------------------------------------------------------------------

AttributeError                            Traceback (most recent call last)

<ipython-input-18-f655491f2afa> in <module>()
----> 1 dt.year = 3000
```

```
AttributeError: attribute 'year' of 'datetime.date' objects is not writable
```

```python
dt = dt.replace(year=3000) # Asignación correcta con .replace()
```

```python
dt
```

```
datetime.datetime(3000, 1, 1, 0, 0)
```

### Formateos

Formato automático ISO (Organización Internacional de Normalización) 

```python
dt = datetime.datetime.now()
dt.isoformat()
```

```
'2016-06-18T21:37:10.303386'
```



Formateo munual (inglés por defecto)

- [datetime-strftime](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior)

```python
dt.strftime("%A %d %B %Y %I:%M")
```

```
'Saturday 18 June 2016 09:37'
```

### tiempo con timedelta

```python
dt = datetime.datetime.now()
dt
```

```
datetime.datetime(2016, 6, 18, 21, 47, 13, 504534)

```



```python
t = datetime.timedelta(days=14, hours=4, seconds=1000)
dentro_de_dos_semanas = dt + t
```

```python
dentro_de_dos_semanas
```

```
datetime.datetime(2016, 7, 3, 2, 3, 53, 504534)

```



```python
dentro_de_dos_semanas.strftime("%A %d de %B del %Y - %H:%M")
```

```
'domingo 03 de julio del 2016 - 02:03'

```



```python
hace_dos_semanas = dt - t
hace_dos_semanas.strftime("%A %d de %B del %Y - %H:%M")
```

```
'sábado 04 de junio del 2016 - 17:30'

```


## Códigos de idiomas

- https://msdn.microsoft.com/es-es/es/library/cdax410z.aspx

```python
import locale
```

```python
locale.setlocale(locale.LC_ALL, 'es-ES') # Establece idioma en "es-ES" (español de España)
locale.setlocale(locale.LC_ALL, '') # Establece idioma del sistema
```

```
'es-ES'
```

```python
dt.strftime("%A %d %B %Y %I:%M")
```

```
'sábado 18 junio 2016 09:37'

```

```python
dt.strftime("%A %d de %B del %Y - %H:%M") # %I 12h - %H 24h
```

```
'sábado 18 de junio del 2016 - 21:37'
```





## Extra: Zonas horarias con pytz

*pip3 install pytz*

```python
import pytz
```

```python
pytz.all_timezones
```

```bash
['Africa/Abidjan',
 'Africa/Accra',
 'Africa/Addis_Ababa',
 'Africa/Algiers',
 'Africa/Asmara',
 'Africa/Asmera',
 'Africa/Bamako',
 'Africa/Bangui',
 'Africa/Banjul',
 'Africa/Bissau',
 'Africa/Blantyre',
 'Africa/Brazzaville',
 'Africa/Bujumbura',
 'Africa/Cairo',
 'Africa/Casablanca',
 'Africa/Ceuta',
 'Africa/Conakry',
 'Africa/Dakar',
 'Africa/Dar_es_Salaam',
 'Africa/Djibouti',
 'Africa/Douala',
 'Africa/El_Aaiun',
 'Africa/Freetown',
...
# salen muchos, todos los del mmundo.

```



```python
dt = datetime.datetime.now(pytz.timezone('Asia/Tokyo'))
dt.strftime("%A %d de %B del %Y - %H:%M") # %I 12h - %H 24h
```

```
'domingo 19 de junio del 2016 - 04:52'

```

## El módulo math

```python
import math
```

### Redondeos

```python
pi = 3.14159
```

```python
round(pi) # Redondeo integrado
```

```
3
```



```python
math.floor(pi) # Redondeo a la baja - Suelo
```

```
3
```



```python
math.floor(3.99)
```

```
3
```



```python
math.ceil(pi)  # Redondeo al alta - Techo
```

```
4
```



```python
math.ceil(3.01)
```

```
4
```



### Valor absoluto

```python
abs(-10)
```

```
10
```



### Sumatorio

```python
# Sumatorio integrado
n = [0.9999999, 1, 2, 3]
sum(n)
```

```
6.999999900000001
```



```python
# Sumatorio mejorado para números reales
math.fsum(n) 
```

```
6.9999999
```



### Truncamiento

```python
math.trunc(123.45) # Truncar, cortar la parte decimal
```

```
123
```



### Potencias y raíces

```python
math.pow(2, 3)  # Potencia con flotante 
```

```
8.0
```



```python
2 ** 3  # Potencia directa
```

```
8
```



```python
math.sqrt(9)  # Raíz cuadrada (square root)
```

```
3.0
```



### Constantes

```python
math.pi   # Constante pi
```

```
3.141592653589793
```



```python
math.e   # Constante e
```

```
2.718281828459045
```

## El módulo random

```python
import random
```

```python
random.random() # Flotante aleatorio >= 0 y < 1.0
```

```
0.12539542779843138
```



```python
random.random() # Flotante aleatorio >= 0 y < 1.0
```

```
0.3332807222427663
```



```python
random.uniform(1,10) # Flotante aleatorio >= 1 y <10.0
```

```
6.272300429556777
```



```python
random.randrange(10) # Entero aleatorio de 0 a 9, 10 excluído
```

```
7
```



```python
random.randrange(0,101) # Entero aleatorio de 0 a 100
```

```
14
```



```python
random.randrange(0,101,2) # Entero aleatorio de 0 a 100 cada 2 números, múltiples de 2
```

```
68
```



```python
random.randrange(0,101,5) # Entero aleatorio de 0 a 100 cada 5 números, múltiples de 5
```

```
25
```



```python
c = 'Hola mundo'
random.choice(c) # letra aleatoria
```

```
'o'
```



```python
l = [1,2,3,4,5]
random.choice(l) # elemento aleatorio
```

```
3
```



```python
random.shuffle(l) # barajar una lista, queda guardado
l
```

```
[3, 4, 2, 5, 1]
```



```python
random.sample(l, 2) # muestra aleatoria de 2 elementos de la lista
```

```
[3, 4]
```

