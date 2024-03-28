## Ficheros de texto

##### Crear fichero y escribir texto


```python
texto = "Una línea con texto\nOtra línea con texto"
fichero = open('fichero.txt','w')  # fichero.txt ruta donde lo crearemos, w indica modo de escritura, write (puntero principio)
fichero.write(texto) # escribimos el texto
```


    40


```python
fichero.close()  # cerramos el fichero
```



##### Lectura de un fichero de texto


```python
fichero = open('fichero.txt','r')  # modo lectura read, por defecto ya es r, no es necesario
texto = fichero.read() # lectura completa
fichero.close()
print(texto)
```

    Una línea con texto
    Otra línea con texto
    Otra línea más abajo del todo



```python
fichero = open('fichero.txt','r')
texto = fichero.readlines() # leer creando una lista de líneas
fichero.close()
print(texto)
```

    ['Una línea con texto\n', 'Otra línea con texto\n', 'Otra línea más abajo del todo']

```python
print(texto[-1]) # Última línea
```

    Otra línea más abajo del todo



##### Extensión de un fichero de texto

modo a (*append*), inserta el puntero al final  y así poder añadir la texto al final del documento.


```python
fichero = open('fichero.txt','a')  # modo a, append, añadir - extender (puntero al final)
fichero.write('\nOtra línea más abajo del todo')
fichero.close()
```

```python
fichero = open('fichero_inventado.txt','a+')  # Extensión con escritura simultánea, crea fichero si no existe
```



##### Lectura de un fichero no existente


```python
fichero = open('fichero_inventado.txt','r')
```


    ---------------------------------------------------------------------------
    
    FileNotFoundError                         Traceback (most recent call last)
    
    <ipython-input-2-c2865d5b1523> in <module>()
    ----> 1 fichero = open('fichero_inventado.txt','r')
    FileNotFoundError: [Errno 2] No such file or directory: 'fichero_inventado.txt'

##### Lectura línea a línea


```python
fichero = open('fichero.txt','r')
fichero.readline()   # Línea a línea
```


    'Una línea con texto\n'


```python
fichero.readline()
```


    'Otra línea con texto'


```python
fichero.readline()
```


    ''


```python
fichero.close()
```



##### Lectura línea a línea secuencial


```python
with open("fichero.txt", "r") as fichero:
    for linea in fichero:
        print(linea)
```

    Una línea con texto
    
    Otra línea con texto
    
    Otra línea más abajo del todo



##### Manejando el puntero


```python
fichero = open('fichero.txt','r')
fichero.seek(0) # Puntero al principio
fichero.read(10) # Leemos 10 carácteres
```


    'Una línea '


```python
fichero.read(10) # Leemos 10 carácteres más, a partir del 10 donde está el puntero
```


    'con texto\n'




```python
fichero.seek(0)
fichero.seek( len(fichero.readline()) ) # Leemos la primera línea y situamos el puntero al principio de la segunda
```


    20




```python
fichero.read() # Leemos todo lo que queda del puntero hasta el final
```


    '\nOtra línea con texto\nOtra línea más abajo del todo'



##### Lectura y escritura a la vez


```python
fichero2 = open('fichero2.txt','r+')  # + escritura simultánea, puntero al principio por defecto
fichero2.write('asdfgh')
fichero2.close()
```



##### Modificar una línea específica


```python
fichero2 = open('fichero2.txt','r+')  # modo lectura con escritura, puntero al principio por defecto
texto = fichero2.readlines() # leemos todas las líneas
texto[2] = "Esta es la línea 3 modificada\n"  # indice menos 1
texto
```


    ['asdfgh1\n', 'Línea 2\n', 'Esta es la línea 3 modificada\n', 'Línea 4']




```python
fichero2.seek(0) # Ponemos el puntero al principio
fichero2.writelines(texto)
fichero2.close()
```



## El módulo pickle

##### Guardar estructura en fichero binario

```python
import pickle
```

```python
lista = [1,2,3,4,5] # Podemos guardar lo que queramos, listas, diccionarios, tuplas...
fichero = open('lista.pckl','wb') # Escritura en modo binario, vacía el fichero si existe
pickle.dump(lista, fichero) # Escribe la estructura en el fichero 
fichero.close()
```



##### Recuperar estructura de fichero binario

```python
fichero = open('lista.pckl','rb') # Lectura en modo binario
lista_fichero = pickle.load(fichero)
fichero.close()
print(lista_fichero)
```

```
[1, 2, 3, 4, 5]
```



##### Abrir fichero y si no existe lo crea

```python
fichero = open('catalogo.pckl', 'ab+') # metodo append binario
lista_fichero = pickle.load(fichero)
fichero.close()
```



##### Lógica para trabajar con objetos

1. Crear una colección
2. Introducir los objetos en la colección
3. Guardar la colección haciendo un dump
4. Recuperar la colección haciendo un load
5. Seguir trabajando con nuestros objetos

```python
class Persona:
    
    def __init__(self,nombre):
        self.nombre = nombre
        
    def __str__(self):
        return self.nombre
    

nombres = ["Héctor","Mario","Marta"]
personas = []

for n in nombres:
    p = Persona(n)
    personas.append(p)
    
import pickle
f = open('personas.pckl','wb')
pickle.dump(personas, f)
f.close()

f = open('personas.pckl','rb')
personas = pickle.load(f)
f.close()
for p in personas:
    print(p)
```

```
Héctor
Mario
Marta
```





## Ejemplo practico

##### Catálogo de películas con ficheros y pickle

```python
from io import open
import pickle

class Pelicula:
    
    # Constructor de clase
    def __init__(self, titulo, duracion, lanzamiento):
        self.titulo = titulo
        self.duracion = duracion
        self.lanzamiento = lanzamiento
        print('Se ha creado la película:',self.titulo)
        
    def __str__(self):
        return '{} ({})'.format(self.titulo, self.lanzamiento)


class Catalogo:
    
    peliculas = []
    
    # Constructor de clase
    def __init__(self):
        self.cargar()
        
    def agregar(self,p):
        self.peliculas.append(p)
        self.guardar()
        
    def mostrar(self):
        if len(self.peliculas) == 0:
            print("El catálogo está vacío")
            return
        for p in self.peliculas:
            print(p)
            
    def cargar(self):
        fichero = open('catalogo.pckl', 'ab+')
        fichero.seek(0)
        try:
            self.peliculas = pickle.load(fichero)
        except:
            print("El fichero está vacío")
        finally:
            fichero.close()
            del(fichero)
            print("Se han cargado {} películas".format( len(self.peliculas) ))
    
    def guardar(self):
        fichero = open('catalogo.pckl', 'wb')
        pickle.dump(self.peliculas, fichero)
        fichero.close()
        del(fichero)
    
    # Destructor de clase
    def __del__(self):
        self.guardar()  # guardado automático
        print("Se ha guardado el fichero")
```



##### Creando un objeto catálogo

```python
c = Catalogo()
```

```
El fichero está vacío
Se han cargado 0 películas
```



```python
c.mostrar()
```

```
El catálogo está vacío
```



```python
c.agregar( Pelicula("El Padrino", 175, 1972) )
```

```
Se ha creado la película: El Padrino
```



```python
c.agregar( Pelicula("El Padrino: Parte 2", 202, 1974) )
```

```
Se ha creado la película: El Padrino: Parte 2
```



```python
c.mostrar()
```

```
El Padrino (1972)
El Padrino: Parte 2 (1974)
```



##### Recuperando el catálogo al crearlo de nuevo

```python
c = Catalogo()
```

```
Se han cargado 2 películas
```



```python
c.mostrar()
```

```
El Padrino (1972)
El Padrino: Parte 2 (1974)
```



```python
del(c)
```

```
Se ha guardado el fichero
```



```python
c = Catalogo()
```

```
Se han cargado 2 películas
```



```python
c.agregar( Pelicula("Prueba", 100, 2005) )
```

```
Se ha creado la película: Prueba
```



```python
c.mostrar()
```

```
El Padrino (1972)
El Padrino: Parte 2 (1974)
Prueba (2005)
```



```python
del(c)
```

```
Se ha guardado el fichero

```



```python
c = Catalogo()
```

```
Se han cargado 3 películas

```



```python
c.mostrar()
```

```
El Padrino (1972)
El Padrino: Parte 2 (1974)
Prueba (2005)

```



##### Conclusiones

- Trabajamos en memoria, no en el fichero
- Nosotros decidimos cuando escribir los datos:
  1. Al manipular un registro
  2. Al finalizar el programa



## Ficheros CSV


#### Leer ficheros csv

```python
import csv

with open(r"data\airbnb.csv", newline='',encoding='utf-8' ) as File:   # encoding='utf-8'
    registros = csv.reader(File)
    for row in registros:
        print(row)  # Crea una lista para fila y los datos entre comillas ''
```

    ['neighbourhood_group', 'neighbourhood', 'latitude', 'longitude', 'room_type', 'price', 'minimum_nights', 'number_of_reviews', 'reviews_per_month', 'calculated_host_listings_count', 'availability_365']
    ['Centro', 'Justicia', '40.4247153175374', '-3.69863818770584', 'Entire home/apt', '49', '28', '35', '0.42', '1', '99']
    ...

`skipinitialspace` elimina los espacios en blanco al inicio de la columna

    SN, Name, City
    1, John, Washington
    2, Eric, Los Angeles
    3, Brad, Texas

```python
import csv
with open('data\people.csv', 'r') as csvfile:
    reader = csv.reader(csvfile, skipinitialspace=True)  # elimina los espacios en blanco al inicio de la columna
    for row in reader:
        print(row)
```

    ['SN', ' Name', ' City']
    ['1', ' John', ' Washington']
    ['2', ' Eric', ' Los Angeles']
    ['3', ' Brad', ' Texas']


**Registro de dialecto**

El registro de dialecto asigna los valores csv en ese registro, como se va a leer ese csv, delimitador, ...

```python
import csv
csv.register_dialect('myDialect',
                    delimiter='|',  # \t  tabulador, ; ,
                    skipinitialspace=True,
                    quoting=csv.QUOTE_MINIMAL)

with open('data\office.csv', 'r') as csvfile:
    reader = csv.reader(csvfile, dialect='myDialect')
    for row in reader:
        print(row)
```

**DictReader**

DictReader muestra el csv pero en diccionarios, cada fila es un diccionario y las key seran los encabezados de las columnas.

```python
import csv

PATH_FICHERO =r"data\airbnb.csv"

with open(PATH_FICHERO) as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        print(row)
```

    {'neighbourhood_group': 'Centro', 'neighbourhood': 'Justicia', 'latitude': '40.4247153175374', 'longitude': '-3.69863818770584', 'room_type': 'Entire home/apt', 'price': '49', 'minimum_nights': '28', 'number_of_reviews': '35', 'reviews_per_month': '0.42', 'calculated_host_listings_count': '1', 'availability_365': '99'}
    {'neighbourhood_group': 'Centro', 'neighbourhood': 'Embajadores', 'latitude': '40.4134181798486', 'longitude': '-3.70683844591936', 'room_type': 'Entire home/apt', 'price': '80', 'minimum_nights': '5', 'number_of_reviews': '18', 'reviews_per_month': '0.3', 'calculated_host_listings_count': '1', 'availability_365': '188'}
    ...

#### Escribir fichero csv

```python
import csv

PATH_FICHERO = "data\jugadores1.csv"  # Mostrar el fichero 

encabezado = ['nombre', 'equipo', 'posicion']
rows = [["Thibaut Courtois", "Real Madrid", "Portero"],
        ["E. Milatao", "Real Madrid", "Defensa"],
        ["Marcelo Vieira", "Real Madrid", "Defensa"]]

with open(PATH_FICHERO , 'w', newline='' ) as f:  # newline=''
    csv_writer = csv.writer(f, delimiter=',')
    csv_writer.writerow(encabezado) # escribe el encabezado
    for row in rows:
        csv_writer.writerow(row)   # escribe una sola linea
```

Mientras writerow escribe linea a linea writerows lo hace  de golpe

```python
import csv

PATH_FICHERO = "data\jugadores_2.csv"  

encabezado = ['nombre', 'equipo', 'posicion']
rows = [["Thibaut Courtois", "Real Madrid", "Portero"],
        ["Sergio Ramos", "Real Madrid", "Defensa"],
        ["Marcelo Vieira", "Real Madrid", "Defensa"]]

with open(PATH_FICHERO , 'wt') as f: # wt mode escritura y texto
    csv_writer = csv.writer(f)
    csv_writer.writerow(encabezado) # escribe el encabezado
    csv_writer.writerows(rows)  # escribe todas las lineas de una vez
```

**Formato de escritura**

    csv.QUOTE_MINIMAL # Sólo los que contienen caracteres especiales
    csv.QUOTE_NONNUMERIC # no numericos
    csv.QUOTE_NONE # sin comillas
    csv.QUOTE_ALL # Todo entre comillas

```python
    import csv

    row_list = [
        ["SN", "Name", "Quotes"],
        [1, "Buddha", "What we think we become"],
        [2, "Mark Twain", "Never regret anything that made you smile"],
        [3, "Oscar Wilde", "Be yourself everyone else is already taken"]
    ]
    with open('data\quotes.csv', 'w', newline='') as file:
        writer = csv.writer(file, quoting=csv.QUOTE_NONNUMERIC, delimiter=';') # csv.QUOTE_NONNUMERIC
        writer.writerows(row_list)
```

**DictWriter** escrive el fichero partiendo de diccionarios

```python
with open(PATH_FICHERO, 'w', newline='') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=encabezado)

    writer.writeheader()
    writer.writerow({"nombre": "Thibaut Courtois", "equipo":"Real Madrid","posicion":"Portero"})
    writer.writerow({"nombre":"Sergio Ramos", "equipo":"Real Madrid", "posicion":"Defensa"})
    writer.writerow({"nombre":"Marcelo Vieira", "equipo":"Real Madrid", "posicion":"Defensa"})
    writer.writerow({"nombre":"Benzema", "equipo":"Real Madrid", "posicion":"Delantero"})
```

Con writerows tambien se puede hacer de golpe

```python
import csv

PATH_FICHERO = "data\jugadores_5.csv"

encabezado = ["nombre", "equipo", "posicion"]
rows = [
    {"nombre": "Thibaut Courtois","equipo":"Real Madrid", "posicion":"Portero"},
    {"nombre":"Sergio Ramos", "equipo":"Real Madrid", "posicion":"Defensa"},
    {"nombre":"Marcelo Vieira", "equipo":"Real Madrid", "posicion":"Defensa"},
    {"nombre":"Benzema", "equipo":"Real Madrid", "posicion":"Delantero"}
]

with open("data\jugadores_7.csv", 'wt', newline='') as csvfile:
    fieldnames = ["nombre", "equipo", "posicion"]
    writer = csv.DictWriter(csvfile, fieldnames=encabezado)
    writer.writeheader()
    writer.writerows(rows)
```


## JSON

##### Leer fichero Json

En este ejemplo se muestra como son las conversiones:

- `json.dumps()` convierte de diccionario a Json
- `json.load()` convierte Json en diccionario

```python
import json

data = {'key1': {'c': True, 'a': 90, '5': 50},
        'key3':{'b': 3, 'c': "yes"}, 
        'key2':{'b': 3, 'c': "yes"}}

d = json.dumps(data, sort_keys=True, indent=4) # Crea el JSON
json = json.loads(d) # JSON -> Dict
print(json)
```

    {'key1': {'5': 50, 'a': 90, 'c': True}, 'key2': {'b': 3, 'c': 'yes'}, 'key3': {'b': 3, 'c': 'yes'}}

```python
print(d)
```

    {
        "key1": {
            "5": 50,
            "a": 90,
            "c": true
        },
        "key2": {
            "b": 3,
            "c": "yes"
        },
        "key3": {
            "b": 3,
            "c": "yes"
        }
    }

Una vez converido en diccionario, se gestiona como diccionario.

```python
json["key2"]
json["key1"]["a"]
```

    {'b': 3, 'c': 'yes'}
    90


Recibir Json en request

```python
import json
import requests

response = requests.get('https://itunes.apple.com/gb/rss/customerreviews/id=1145275343/page=2/json')
json_data = json.loads(response.text)
data = json_data['feed']['entry']
```


Para leer desde fichero es lo mismo, solo que se recibe la data desde el fichero

```python
with open("data/data_file.json", "r") as file:
    my_file = file.read()
    json_datos = json.loads(my_file)
```


##### Escribir fichero Json

Escribir fichero desde un requests

```python
import json
import requests

response = requests.get('https://itunes.apple.com/search?term=Alejandro+Sanz')
json_data = json.loads(response.content)
json_data

with open("data/data_file.json", "w") as write_file:
    json.dump(json_data, write_file, indent=4)
```

Lo mismo con nuestra propia data

```python
import json
import os

data = {}

data['clients'] = []

data['clients'].append({
    'first_name': 'Sigrid',
    'last_name': 'Mannock',
    'age': 27,
    'amount': 7.17})
data['clients'].append({
    'first_name': 'Joe',
    'last_name': 'Hinners',
    'age': 31,
    'amount': [1.90, 5.50]})
data['clients'].append({
    'first_name': 'Theodoric',
    'last_name': 'Rivers',
    'age': 36,
    'amount': 1.11})

file_name = "data\\data.json"

with open(file_name, 'w') as file:
    json.dump(data, file, indent=4)

data
```

    {'clients': [{'first_name': 'Sigrid',
    'last_name': 'Mannock',
    'age': 27,
    'amount': 7.17},
    {'first_name': 'Joe',
    'last_name': 'Hinners',
    'age': 31,
    'amount': [1.9, 5.5]},
    {'first_name': 'Theodoric',
    'last_name': 'Rivers',
    'age': 36,
    'amount': 1.11}]}

##### Codificación Unicode

```python
data = {'first_name': 'Daniel', 'last_name': 'Rodríguez'}
print(json.dumps(data))
print(json.dumps(data, ensure_ascii=False))
```

    '{"first_name": "Daniel", "last_name": "Rodr\\u00edguez"}'
    '{"first_name": "Daniel", "last_name": "Rodríguez"}'

Ordenar

```python
data = {
'first_name': 'Sigrid',
'last_name': 'Mannock',
'age': 27,
'amount': 7.17}
json.dumps(data, sort_keys=True)
```

    '{"age": 27, "amount": 7.17, "first_name": "Sigrid", "last_name": "Mannock"}'
