# Orientado a objetos

- [**Orientado a objetos**](#Orientado a objetos)
  - [Método init](#Método __init__())
  - [Métodos especiales de clase](#Métodos especiales de clase)
  - [Objetos dentro de objetos](#Objetos dentro de objetos)
  - [Objetos dentro de objetos](#Objetos dentro de objetos)



## Método __init__()
Se llama automáticamente al crear una instancia de clase.


```python
class Galleta():
    chocolate = False
    def __init__(self):
        print("Se acaba de crear una galleta.")
g = Galleta()
```

    Se acaba de crear una galleta.



#### Métodos y la palabra self

Self sirve para hacer referencia a los métodos y atributos base de una clase dentro de sus propios métodos.


```python
class Galleta():
    chocolate = False
    
    def __init__(self):
        print("Se acaba de crear una galleta.")
    
    def chocolatear(self):
        self.chocolate = True
        
    def tiene_chocolate(self):
        if (self.chocolate):
            print("Soy una galleta chocolateada :-D")
        else:
            print("Soy una galleta sin chocolate :-(")
    
g = Galleta() # creo la galleta
g.tiene_chocolate() # miro si hay chocolate
g.chocolatear() # chocolateo la galleta
g.tiene_chocolate() # miro si hay chocolate
```

    Se acaba de crear una galleta.
    Soy una galleta sin chocolate :-(
    Soy una galleta chocolateada :-D



#### Parámetros con valores por defecto en el __init__()

- Si no se ponen valores por defecto a las variables, en el caso de iniciar una galleta y no añadir parametros mostrara error.

```python
class Galleta():
    chocolate = False
    
    def __init__(self, sabor=None, forma=None):
        self.sabor = sabor
        self.forma = forma
        if sabor is not None and forma is not None:
            print("Se acaba de crear una galleta {} y {}".format(sabor,forma))
    
    def chocolatear(self):
        self.chocolate = True
        
    def tiene_chocolate(self):
        if (self.chocolate):
            print("Soy una galleta chocolateada :-D")
        else:
            print("Soy una galleta sin chocolate :-(")
```


```python
g = Galleta("salada","cuadrada")
```

    Se acaba de crear una galleta salada y cuadrada



## Métodos especiales de clase

#### Constructor y destructor

```python
class Pelicula:
    # Constructor de clase (al crear la instancia)
    def __init__(self,titulo,duracion,lanzamiento):
        self.titulo = titulo
        self.duracion = duracion
        self.lanzamiento = lanzamiento
        print("Se ha creado la película",self.titulo)
        
    # Destructor de clase (al borrar la instancia)
    def __del__(self):
        print("Se está borrando la película", self.titulo)
        
p = Pelicula("El Padrino",175,1972)
```

- Al finalizar el script el metodo `del` se ejecuta por defecto.

```
Se ha creado la película El Padrino
Se está borrando la película El Padrino
```



#### String

Para devolver una cadena por defecto al convertir un objeto a una cadena con str(objeto):

```python
class Pelicula:
    # Constructor de clase
    def __init__(self,titulo,duracion,lanzamiento):
        self.titulo = titulo
        self.duracion = duracion
        self.lanzamiento = lanzamiento
        print("Se ha creado la película",self.titulo)
        
    # Destructor de clase
    def __del__(self):
        print("Se está borrando la película", self.titulo)
        
    # Redefinimos el método string
    def __str__(self):
        return "{} lanzada en {} con una duración de {} minutos".format(self.titulo,self.lanzamiento,self.duracion)
        
p = Pelicula("El Padrino",175,1972)
```

```
Se ha creado la película El Padrino
```

```python
str(p)
```

```
'El Padrino lanzada en 1972 con una duración de 175 minutos'
```



#### Length

Para devolver un número que simula la longitud del objeto len(objeto):

```python
class Pelicula:
    # Constructor de clase
    def __init__(self,titulo,duracion,lanzamiento):
        self.titulo = titulo
        self.duracion = duracion
        self.lanzamiento = lanzamiento
        print("Se ha creado la película",self.titulo)
        
    # Destructor de clase
    def __del__(self):
        print("Se está borrando la película", self.titulo)
        
    # Redefinimos el método string
    def __str__(self):
        return "{} lanzada en {} con una duración de {} minutos".format(self.titulo,self.lanzamiento,self.duracion)
    
    # Redefinimos el método length
    def __len__(self):
        return self.duracion
        
p = Pelicula("El Padrino",175,1972)
len(p)
```

```
Se ha creado la película El Padrino
Se está borrando la película El Padrino
175
```



## Objetos dentro de objetos

```python
class Pelicula:
    
    # Constructor de clase
    def __init__(self, titulo, duracion, lanzamiento):
        self.titulo = titulo
        self.duracion = duracion
        self.lanzamiento = lanzamiento
        print('Se ha creado la película:',self.titulo)
        
    def __str__(self):
        return '{} ({})'.format(self.titulo, self.lanzamiento)
```



#### Creando un catálogo de películas

```python
class Catalogo:
    
    peliculas = []  # Esta lista contendrá objetos de la clase Pelicula
    
    def __init__(self,peliculas=[]):
        self.peliculas = peliculas
        
    def agregar(self,p):  # p será un objeto Pelicula
        self.peliculas.append(p)
        
    def mostrar(self):
        for p in self.peliculas:
            print(p)  # Print toma por defecto str(p)
```

```python
p = Pelicula("El Padrino",175,1972) # creo pelicula
c = Catalogo([p]) # añado al catalogo
```

```
Se ha creado la película: El Padrino
```

Muestro la peliculas del catalogo

```python
c.mostrar()
```

```
El Padrino (1972)
```



```python
c.agregar(Pelicula("El Padrino: Parte 2",202,1974))  # Añadimos una película directamente
```

```
Se ha creado la película: El Padrino: Parte 2
```

Muestro la peliculas del catalogo

```python
c.mostrar()
```

```
El Padrino (1972)
El Padrino: Parte 2 (1974)
```





## Encapsulación

Consiste en denegar el acceso a los atributos y métodos internos de la clase desde el exterior.

En Python no existe, pero se puede simular precediendo atributos y métodos con dos barras bajas __:

```python
class Ejemplo:
    __atributo_privado = "Soy un atributo inalcanzable desde fuera"
    
    def __metodo_privado(self):
        print("Soy un método inalcanzable desde fuera")
```

```python
e = Ejemplo()
```

```python
e.__atributo_privado
e.__metodo_privado()
```



```
AttributeError: 'Ejemplo' object has no attribute '__atributo_privado'
AttributeError: 'Ejemplo' object has no attribute '__metodo_privado'
```



#### Cómo acceder

Internamente la clase sí puede acceder a sus atributos y métodos encapsulados, el truco consiste en crear sus equivalentes "publicos":

```python
class Ejemplo:
    __atributo_privado = "Soy un atributo inalcanzable desde fuera"
    
    def __metodo_privado(self):
        print("Soy un método inalcanzable desde fuera")
        
    def atributo_publico(self):
        return self.__atributo_privado
        
    def metodo_publico(self):
        return self.__metodo_privado()
```

```python
e = Ejemplo()
e.atributo_publico()
```

```
'Soy un atributo inalcanzable desde fuera'
```

```python
e.metodo_publico()
```

```
Soy un método inalcanzable desde fuera
```

