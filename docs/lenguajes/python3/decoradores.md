# Decoradores

## Metodos e decoracion

Tanto __call__ como __get__ son métodos especiales en Python que permiten que los objetos sean llamados y accedidos como si fueran funciones o atributos normales, respectivamente. Aquí tienes una explicación de cada uno:
Método __call__:

El método __call__ permite que un objeto sea llamado como una función. Esto significa que después de definir __call__ para una clase, las instancias de esa clase se comportarán como funciones y podrán ser llamadas utilizando paréntesis (). Cuando se llama a un objeto de esta manera, Python automáticamente invoca el método __call__ de la clase.

```python
class MiClase:
    def __init__(self, nombre):
        self.nombre = nombre

    def __call__(self):
        print(f"Llamando a la instancia de {self.nombre}")

# Crear una instancia de la clase
instancia = MiClase("Ejemplo")

# Llamar a la instancia como si fuera una función
instancia()  # Salida: "Llamando a la instancia de Ejemplo"
```

Método __get__:

El método __get__ se utiliza para controlar el acceso a un atributo de una clase. Se utiliza en el contexto de los descriptores de Python, que son objetos que personalizan el acceso a los atributos de una clase.

```python
class Descriptor:
    def __init__(self, valor):
        self.valor = valor

    def __get__(self, instancia, clase):
        print("Obteniendo el valor del descriptor")
        return self.valor

class MiClase:
    descriptor = Descriptor(10)

# Crear una instancia de la clase
instancia = MiClase()

# Acceder al atributo controlado por el descriptor
print(instancia.descriptor)  # Salida: "Obteniendo el valor del descriptor" y luego "10"
```

---

Usamos el decorador de `@staticmethod` para definir un método estático en Python, aquí se puede observar que el método estático no se toma a sí mismo (self) como argumento para el método.

```python
    class A(object):
        
        @staticmethod       # no necesitamos crear una instancia
        def metodo(*argv):  # no necesito pasarle el self como parametro
            return argv

    A.metodo("hola") # Podemos invocar al método sin crear el objeto
    ('hola',)
```


Un `@classmethod` es un método que recibe la clase como el primer argumento implícito, al igual que un método de instancia recibe la instancia. Esto significa que puede utilizar la clase y sus propiedades dentro de ese método en lugar de una instancia determinada.

```python
    class MyClass():
        
        TOTAL_OBJECTS=0
        
        def __init__(self, nombre):
            self.nombre = nombre
            MyClass.TOTAL_OBJECTS += 1
        
        @classmethod
        def total_objects(cls):  #cls es la clase
            print("Total objects: ",cls.TOTAL_OBJECTS)

    # Creating objects        
    my_obj1 = MyClass("obj1")
    my_obj2 = MyClass("obj2")
    my_obj3 = MyClass("obj3")

    # Calling class method 
    MyClass.total_objects()
    Total objects:  3
```


`@property`: es un decorador integrado para la función property() en Python. Se utiliza para dar una funcionalidad "especial" a ciertos métodos para que actúen como captadores, definidores o eliminadores cuando definimos propiedades en una clase. Se pueden definir tres métodos para una propiedad:

- getter: para acceder al valor del atributo.
- setter: para establecer el valor del atributo.
- deleter: para eliminar el atributo de instancia.


```python
class MiClase:
    def __init__(self, nombre):
        self._nombre = nombre

    @property
    def nombre(self):
        return self._nombre

    @nombre.setter
    def nombre(self, nuevo_nombre):
        if isinstance(nuevo_nombre, str):
            self._nombre = nuevo_nombre
        else:
            raise TypeError("El nombre debe ser una cadena de caracteres.")

    @nombre.deleter
    def nombre(self):
        del self._nombre

# Crear una instancia de la clase
instancia = MiClase("Ejemplo")

# Acceder al atributo nombre
print(instancia.nombre)  # Salida: "Ejemplo"

# Establecer un nuevo valor para el atributo nombre
instancia.nombre = "Nuevo ejemplo"
print(instancia.nombre)  # Salida: "Nuevo ejemplo"

# Eliminar el atributo nombre
del instancia.nombre
# Esto generará un error ya que hemos eliminado el atributo nombre
print(instancia.nombre)  # Salida: AttributeError: 'MiClase' object has no attribute '_nombre'
```

En este ejemplo, hemos definido el método setter con @nombre.setter y el método deleter con @nombre.deleter, que nos permiten establecer y eliminar el valor del atributo nombre, respectivamente. El método setter verifica si el nuevo valor es una cadena de caracteres y, si no lo es, lanza un error de tipo. El método deleter simplemente elimina el atributo _nombre.

---

## Decoradores en funciones

En python se pueden pasar funciones como argumento, tal como se ve en el ejemplo.

```python
def suma(a, b):
    print( a + b )

def resta(a, b):
    print( a - b )

def ejecutar_operacion(operacion, a, b):
    print('Antes de la ejecucion')
    operacion(a, b)

mi_operacion = suma
ejecutar_operacion(mi_operacion, 70, 90)
```

Una función decoradora en Python es una función que toma otra función como argumento y retorna una nueva función que agrega funcionalidad adicional a la función original sin modificar su definición. Esto se logra envolviendo la función original dentro de la función decoradora y devolviendo la función envuelta.

A toma como argumento B y retorna C

Sintaxi:

```python
def funcion_a(function_b):
    def function_c():
        print('Antes de la ejecucion')
        function_b()
        print('Despuew de la ejecucion')

    return function_c
```

Pasando argumentos a la funcion

```python
def decorador(funcion):
    def wrapper(*args, **kwargs):
        print("Antes de llamar a la función")
        resultado = funcion(*args, **kwargs)
        print("Después de llamar a la función")
        return resultado
    return wrapper

@decorador
def suma(a, b):
    return a + b

# Llamada a la función decorada
suma(5, 6)
```

    Antes de llamar a la función
    11
    Después de llamar a la función

Un pequeño ejemplo practico es un decorador que muestre el tiempo de ejecucion

```python
import time

def calcular_tiempo(funcion):
    def wrapper(*args, **kwargs):
        start = time.time()
        resultado = funcion(*args, **kwargs)
        
        print('Tiempo total: ', time.time() - start )
        return resultado
    return wrapper

@calcular_tiempo
def suma(a, b):
    return a + b

suma(5, 6)
```

Pasar arguentos al decorador

```python
import time

def calcular_tiempo(name):
    def wrapper(funcion):
        def wrapper_2(*args, **kwargs):
            start = time.time()
            resultado = funcion(*args, **kwargs)
            
            print(f'Tiempo total de la funcion {name} es de: ', time.time() - start )
            return resultado
        return wrapper_2
    return wrapper

@calcular_tiempo('suma')
def suma(a, b):
    return a + b

suma(5, 6)
```

## decoradores en clases

Los decoradores en clases en Python son funciones que toman una clase como argumento y pueden modificar su comportamiento, añadir funcionalidades adicionales o envolver métodos específicos dentro de la clase. Esto se logra mediante el uso del mismo patrón de decoración utilizado con funciones, pero aplicado a clases.

**Decorador simple**

el decorador se aplica directamente a la clase utilizando @decorador. La función decoradora toma la clase como argumento y retorna una nueva clase que reemplaza la original.

```python
def decorador(clase):
    class NuevaClase:
        def __init__(self, *args, **kwargs):
            self.instancia = clase(*args, **kwargs)

        def metodo_decorado(self):
            print("Antes de llamar al método")
            self.instancia.metodo_original()
            print("Después de llamar al método")
    return NuevaClase

@decorador
class MiClase:
    def metodo_original(self):
        print("¡Método original ejecutado!")

# Crear una instancia de la clase decorada
instancia = MiClase()

# Llamar al método decorado
instancia.metodo_decorado()
```

**Añadiendo funcionalidades**

El decorador se define como una función anidada user_decorator, que devuelve otra función anidada super_user. La función super_user toma la clase como argumento, crea una nueva clase SuperUser que hereda de la clase original (cls), y agrega nuevos métodos (get_fullname y __str__) a esta nueva clase. Finalmente, la función user_decorator retorna la función super_user, y esta última función se utiliza como decorador @user_decorator() aplicado a la clase User.

```python
def user_decorator():
    def super_user(cls):
        
        class SuperUser(cls):
            def get_fullname(self):
                return f'{self.get_name()} {self.get_last_name()}'
            
            def __str__(self):
                return f'Hola, mi nombre es: {self.get_fullname()}'
        
        return SuperUser
    return super_user


@user_decorator()
class User:
    def __init__(self, name, last_name):
        self.name = name
        self.last_name = last_name
    
    def get_name(self):
        return self.name

    def get_last_name(self):
        return self.last_name

if __name__ == '__main__':
    user = User('Codigo', 'Facilito')
    print(user.get_fullname()) # retorna: 'Codigo facilito'
    print(user) # retorna: 'Hola, mi nombre es: Codigo facilito'

```

Pasando argumentos al decorador

```python
def user_decorator(prefix):
    def super_user(cls):
        class SuperUser(cls):
            def get_fullname(self):
                return f'{prefix} {self.get_name()} {self.get_last_name()}'

            def __str__(self):
                return f'Hola, mi nombre es: {self.get_fullname()}'

        return SuperUser
    return super_user

@user_decorator("Super")
class User:
    def __init__(self, name, last_name):
        self.name = name
        self.last_name = last_name

    def get_name(self):
        return self.name

    def get_last_name(self):
        return self.last_name

# Crear una instancia de la clase decorada
usuario = User("John", "Doe")

# Llamar al método __str__ de la clase
print(usuario)  # Salida: Hola, mi nombre es: Super John Doe
```