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