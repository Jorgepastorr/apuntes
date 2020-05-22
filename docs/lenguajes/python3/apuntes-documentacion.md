# Documentación

## Docstrings

En Python todos los objetos cuentan con una variable especial llamada __doc__ gracias a la que podemos describir para qué sirven los y cómo se usan los objetos. Estas variables reciben el nombre de *docstrings*, cadenas de documentación.

### Docstrings en funciones

Python implementa un sistema muy sencillo para establecer el valor de las docstrings, únicamente tenemos que crear un comentario en la primera línea después de la declaración.

```python
def hola(arg):
    """Este es el docstring de la función"""
    print("Hola", arg, "!")
```

```python
hola("Héctor")
Hola Héctor !
```



Para consultar la documentación es tan sencillo como utilizar la función reservada **help** y pasarle el objeto:

```python
help(hola)
```

    Help on function hola in module __main__:
    
    hola(arg)
        Este es el docstring de la función

### Docstrings en clases y métodos

De la misma forma podemos establecer la documentación de la clase después de la definición, y de los métodos, como si fueran funciones:

```python
class Clase:
    """ Este es el docstring de la clase"""

    def __init__(self):
        """Este es el docstring del inicializador de clase"""

    def metodo(self):
        """Este es el docstring del metodo de clase"""
```

```python
o = Clase()
help(o)
```

    Help on Clase in module __main__ object:
    
    class Clase(builtins.object)
     |  Este es el docstring de la clase
     |  
     |  Methods defined here:
     |  
     |  __init__(self)
     |      Este es el docstring del inicializador de clase
     |  
     |  metodo(self)
     |      Este es el docstring del metodo de clase
     |  
     |  ----------------------------------------------------------------------
     |  Data descriptors defined here:
     |  
     |  __dict__
     |      dictionary for instance variables (if defined)
     |  
     |  __weakref__
     |      list of weak references to the object (if defined)

### Docstrings en scripts y módulos

Cuando tenemos un script o módulo, la primera línea del mismo hará referencia al docstring del módulo, en él deberíamos explicar el funcionamiento del mismo: 

#### mi_modulo.py

```python
"""Este es el docstring del módulo"""

def despedir():
    """Este es el docstring de la función despedir"""
    print("Adiós! Me estoy despidiendo desde la función despedir() del módulo prueba")

def saludar():
     """Este es el docstring de la función saludar"""
    print("Hola! Te estoy saludando desde la función saludar() del módulo prueba")
```

```python
import mi_modulo  # Este módulo lo he creado en el directorio

help(mi_modulo)
```

    Help on module mi_modulo:
    
    NAME
        mi_modulo - Este es el docstring del módulo
    
    FUNCTIONS
        despedir()
            Este es el docstring de la función despedir
    
        saludar()
            Este es el docstring de la función saludar
    
    FILE
        c:\cursopython\fase 4 - temas avanzados\tema 16 - docomentación y pruebas\mi_modulo.py

```python
help(mi_modulo.despedir)
```

    Help on function despedir in module mi_modulo:
    
    despedir()
        Este es el docstring de la función despedir

Como dato curioso, también podemos listar las variables y funciones del módulo con la función **dir**:

```python
dir(mi_modulo)
```

    ['__builtins__',
     '__cached__',
     '__doc__',
     '__file__',
     '__loader__',
     '__name__',
     '__package__',
     '__spec__',
     'despedir',
     'saludar']

Como vemos muchas de ellas son especiales, seguro que muchas os suenan, os invito a comprobar sus valores:

```python
mi_modulo.__name__
'mi_modulo'
```

```python
mi_modulo.__doc__
'Este es el docstring del módulo'
```



### Docstrings en paquetes

En el caso de los paquetes el docstring debemos establecerlo en la primera línea del inicializador **init**:

Suponiedo que tenemos la siguiente estructura:

```bash
mi_paquete/
|_ __init__.py
|_ adios
|    |_ __init__.py
|    |_ adios.py
|_ hola 
     |_ __init__.py
     |_ hola.py
```

#### __init______.py

```python
""" Este es el docstring de mi_paquete """
```

```python
import mi_paquete
help(mi_paquete)
```



    Help on package mi_paquete:
    
    NAME
        mi_paquete - Este es el docstring de mi_paquete
    
    PACKAGE CONTENTS
        adios (package)
        hola (package)
    
    FILE
        c:\cursopython\fase 4 - temas avanzados\tema 16 - docomentación y pruebas\mi_paquete\__init__.py

## Creando buena documentación

Podéis aprender a crear buena documentación tomando como referencia contenido de las librerías internas de Python:

```python
help(print)
```

    Help on built-in function print in module builtins:
    
    print(...)
        print(value, ..., sep=' ', end='\n', file=sys.stdout, flush=False)
    
        Prints the values to a stream, or to sys.stdout by default.
        Optional keyword arguments:
        file:  a file-like object (stream); defaults to the current sys.stdout.
        sep:   string inserted between values, default a space.
        end:   string appended after the last value, default a newline.
        flush: whether to forcibly flush the stream.

```python
help(len)
```

    Help on built-in function len in module builtins:
    
    len(obj, /)
        Return the number of items in a container.

```python
help(str)
```

```bash
Help on class str in module builtins:

class str(object)
 |  str(object='') -> str
 |  str(bytes_or_buffer[, encoding[, errors]]) -> str
 |  
 |  Create a new string object from the given object. If encoding or
 |  errors is specified, then the object must expose a data buffer
 |  that will be decoded using the given encoding and error handler.
 |  Otherwise, returns the result of object.__str__() (if defined)
 |  or repr(object).
 |  encoding defaults to sys.getdefaultencoding().
 |  errors defaults to 'strict'.
 |  
 |  Methods defined here:
 |  
 |  __add__(self, value, /)
 |      Return self+value.
 |  
 |  __contains__(self, key, /)
 |      Return key in self.
....
```



Recordad, una buena documentación siempre dará respuesta a las dos preguntas básicas: **¿Para qué sirve?** y **¿Cómo se utiliza?**



## Pydoc

En la lección anterior aprendimos que utilizando la función **help** podemos mostrar información formateada por la consola. Pues en realidad esta función hace uso del módulo **pydoc** para generar la documentación a partir de sus *docstrings*.

Desde la terminal no podemos utilizar la función *help*, pero sí existe la posibilidad de utilizar **pydoc** de forma similar.

Por ejemplo podemos consultar la documentación de scripts, módulos y clases utilizando la sintaxis:

```bash
pydoc nombre.py
```

También podemos utilizar la misma sintaxis para los paquetes:

```bash
pydoc nombre_paquete
```

### Documentación en HTML

Una función interesante de Pydoc es que podemos generar la documentación de nuestro código utilizando la siguiente sintaxis:

```bash
pydoc -w nombre.py
```

Si tenemos un paquete podemos generar toda la documentación de forma recursiva de la siguiente forma estando en el directorio del paquete:

```bash
pydoc -w .\
```

Esto generará toda la documentación del paquete, subpaquete, clases, métodos y funciones. Está bien para publicarla en Internet, pero también podemos consultarla directamente en local lanzando un servidor temporal, desde el directorio del paquete:

```bash
pydoc -p 8000
```

Aunque esto mostrará la documentación general de Python en ese momento, a parte de nuestro módulo.

Existen otras alternativas más bonitas para generar documentación, como los módulos **Epydoc** o **Sphinx**.
