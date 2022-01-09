# Funciones

Son fragmentos de código que se pueden ejecutar múltiples veces. Pueden recibir y devolver información para comunicarse con el proceso principal.

## Definición y llamada

```python
def saludar():
    print("Hola! Este print se llama desde la función saludar()")

saludar()
```

```
Hola! Este print se llama desde la función saludar()

```

## variables y sentencias de control

```python
def dibujar_tabla_del_5():
    for i in range(10):
        print("5 * {} = {}".format(i,i*5))
dibujar_tabla_del_5()
```

```
5 * 0 = 0
5 * 1 = 5
5 * 2 = 10
5 * 3 = 15
5 * 4 = 20
5 * 5 = 25
5 * 6 = 30
5 * 7 = 35
5 * 8 = 40
5 * 9 = 45

```

## Ámbito de las variables

Una variable declarada en una función no existe en la función principal:

```python
def test():
    n = 10
test()
```

```python
print(n)
```

```
---------------------------------------------------------------------------

NameError                                 Traceback (most recent call last)

<ipython-input-4-667d7c7a2c02> in <module>()
----> 1 print(n)
NameError: name 'n' is not defined

```

Sin embargo, siempre que declaremos la variable antes de la ejecución, podemos acceder a ella desde dentro:

```python
def test():
    print(l)

l = 10
test()
```

```
10

```

> En el caso que declaremos de nuevo una variable en la función, se creará un copia de la misma que sólo funcionará dentro de la función.



Por tanto *no podemos modificar una variable externa dentro de una función*:

```python
def test():
    o = 5 # variable que sólo existe dentro de la función
    print(o)
test()

o=10 # variable externa, no modificable
test()
print(o)
```

```
5
5
10

```



### La instrucción global

Para poder modificar una variable externa en la función, debemos indicar que es global de la siguiente forma:

```python
def test():
    global o # variable que hace referencia a la o externa
    o = 5
    print(o)
test()

o=10
test()
print(o)
```

```
5
5
5

```



## Trabajando con argumentos y parámetros

### Argumentos por posición

```python
def resta(a,b):
    return a-b

resta(1,2)   # posición índice 0 valor 1, posición índice 1 valor 2
```

```
-1

```

### Argumentos por nombre

```python
resta(b=2,a=1)
```

```
-1

```



### Llamada sin argumentos

Al llamar una función que tiene definidos unos parámetros, si no pasamos los argumentos correctamente provocará un error:

```python
resta()
```

```
---------------------------------------------------------------------------

TypeError                                 Traceback (most recent call last)

<ipython-input-4-78c8f433960e> in <module>()
----> 1 resta()
TypeError: resta() missing 2 required positional arguments: 'a' and 'b'

```



### Parámetros por defecto

Para solucionarlo podemos asignar unos valores por defecto nulos a los parámetros, y de ésa forma podríamos hacer una comprobación antes de ejecutar el código de la función:

```python
def resta(a=None,b=None):
    if a == None or b == None:
        print("Error, debes enviar dos números a la función")
        return
    return a-b
resta(1,5)
```

```
-4

```



## Paso por valor y paso por referencia

- **Paso por valor**: Se crea una copia local de la variable dentro de la función.
- **Paso por referencia**: Se maneja directamente la variable, los cambios realizados dentro le afectarán también fuera.

Tradicionalmente, **los tipos simples se pasan automáticamente por valor y los compuestos por referencia**.

- **Simples**: Enteros, flotantes, cadenas, lógicos...
- **Compuestos**: Listas, diccionarios, conjuntos...

### Paso por valor

```python
def doblar_valor(numero):
    numero*=2
    
n = 10
doblar_valor(n)
n
```



```
10
```

### Paso por referencia

```python
def doblar_valores(numeros):
    for i,n in enumerate(numeros):
        numeros[i] *= 2

ns = [10,50,100]
doblar_valores(ns)
print(ns)
```

```
[20, 100, 200]

```



### Trucos

Para modificar los tipos simples podemos devolverlos modificados y reasignarlos:

```python
def doblar_valor(numero):
    return numero*2

n = 10
n = doblar_valor(n)
print(n)
```

```
20

```

Y en el caso de los tipos compuestos, podemos evitar la modificación enviando una copia:

```python
def doblar_valores(numeros):
    for i,n in enumerate(numeros):
        numeros[i] *= 2

ns = [10,50,100]
doblar_valores(ns[:])  # Una copia al vuelo de una lista con [:]
print(ns)
```

```
[10, 50, 100]

```



## Argumentos y parámetros indeterminados

Quizá en alguna ocasión no sabemos de antemano cuantos elementos vamos a enviar a una función. En estos casos podemos utilizar los parámetros indeterminados por posición y por nombre.

### Por posición

Para recibir un número indeterminado de parámetros por posición, debemos crear una lista dinámica de argumentos (una tupla en realidad):

```python
def indeterminados_posicion(*args):
    for arg in args:
        print(arg)
    
indeterminados_posicion(5,"Hola",[1,2,3,4,5])
```

```
5
Hola
[1, 2, 3, 4, 5]

```

### Por nombre

Para recibir un número indeterminado de parámetros por nombre (clave-valor), debemos crear un diccionario dinámico de argumentos:

```python
def indeterminados_nombre(**kwargs):
    print(kwargs)

indeterminados_nombre(n=5,c="Hola",l=[1,2,3,4,5])    
```

```
{'n': 5, 'c': 'Hola', 'l': [1, 2, 3, 4, 5]}
```

```python
def indeterminados_nombre(**kwargs):
    for kwarg in kwargs:
        print(kwarg)

indeterminados_nombre(n=5,c="Hola",l=[1,2,3,4,5])   
```

```
n
c
l
```



```python
def indeterminados_nombre(**kwargs):
    for kwarg in kwargs:
        print(kwarg," ", kwargs[kwarg])

indeterminados_nombre(n=5,c="Hola",l=[1,2,3,4,5])   
```

```
n   5
c   Hola
l   [1, 2, 3, 4, 5]
```



### Por posición y nombre a la vez

Si queremos aceptar ambos tipos de parámetros simultáneamente, entonces debemos crear ambas colecciones dinámicas:

```python
def super_funcion(*args,**kwargs):
    t = 0
    for arg in args:
        t+=arg

    print("Sumatorio indeterminado es",t)

    for kwarg in kwargs:
        print(kwarg," ", kwargs[kwarg])

super_funcion(10,50,-1,1.56,10,20,300,nombre="Hector",edad=27)
```

```
Sumatorio indeterinado es 390.56
nombre   Hector
edad   27
```



## Funciones recursivas

Se trata de funciones que se llaman a sí mismas durante su propia ejecución. Funcionan de forma similar a las iteraciones, y debemos encargarnos de planificar el momento en que una función recursiva deja de llamarse o tendremos una función rescursiva infinita.

Suele utilizarse para dividir una tarea en subtareas más simples de forma que sea más fácil abordar el problema y solucionarlo.



### Ejemplo sencillo sin retorno

Cuenta regresiva hasta cero a partir de un número:

```python
def cuenta_atras(num):
    num -= 1
    if num > 0:
        print(num)
        cuenta_atras(num)
    else:
        print("Boooooooom!")
    print("Fin de la función", num)

cuenta_atras(5)
```

```
4
3
2
1
Boooooooom!
Fin de la función 0
Fin de la función 1
Fin de la función 2
Fin de la función 3
Fin de la función 4
```


### Ejemplo con retorno

El factorial de un número corresponde al producto de todos los números desde 1 hasta el propio número:

- 3! = 1 x 2 x 3 = 6
- 5! = 1 x 2 x 3 x 4 x 5 = 120

```python
def factorial(num):
    print("Valor inicial ->",num)
    if num > 1:
        num = num * factorial(num -1)
    print("valor final ->",num)
    return num

factorial(5)
```

```
Valor inicial -> 5
Valor inicial -> 4
Valor inicial -> 3
Valor inicial -> 2
Valor inicial -> 1
valor final -> 1
valor final -> 2
valor final -> 6
valor final -> 24
valor final -> 120
```

```
120
```
