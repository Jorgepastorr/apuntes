# Las excepciones

Son bloques de código excepcionales que nos permiten continuar con la ejecución de un programa pese a que ocurra un error.

## Try - Except

Para prevenir el error, debemos poner el código propenso a error un bloque `try` y luego encadenaremos un bloque `except` para tratar la excepción:

```python
try:
    n = float(input("Introduce un número: "))
    m = 4
    print("{}/{}={}".format(n,m,n/m))
except:
    print("Ha ocurrido un error, introduce bien el número")
```

```
Introduce un número: aaa
Ha ocurrido un error, introduce bien el número
```

### Excepciones en bucle

Utilizando un `while(true)`, podemos asegurárnos de que el usuario introduce bien el valor

Repitiendo la lectura por teclado hasta que lo haga bien, y entonces rompemos el bucle con un break:

```python
while(True):
    try:
        n = float(input("Introduce un número: "))
        m = 4
        print("{}/{}={}".format(n,m,n/m))
        break  # Importante romper la iteración si todo ha salido bien
    except:
        print("Ha ocurrido un error, introduce bien el número")
```

```
Introduce un número: aaa
Ha ocurrido un error, introduce bien el número
Introduce un número: 10
10.0/4=2.5
```



### Else en excepciones

Es posible encadenar un bloque else después del *except* para comprobar el caso en que **todo funcione correctamente** (no se ejecuta la excepción).

El bloque *else* es un buen momento para romper la iteración con *break* si todo funciona correctamente:

```python
while(True):
    try:
        n = float(input("Introduce un número: "))
        m = 4
        print("{}/{}={}".format(n,m,n/m))
    except:
        print("Ha ocurrido un error, introduce bien el número")
    else:
        print("Todo ha funcionado correctamente")
        break  # Importante romper la iteración si todo ha salido bien
```

```
Introduce un número: 10
10.0/4=2.5
Todo ha funcionado correctamente
```


### Finally en excepciones

Por último es posible utilizar un bloque *finally* que se ejecute al final del código, **ocurra o no ocurra un error**:

```python
while(True):
    try:
        n = float(input("Introduce un número: "))
        m = 4
        print("{}/{}={}".format(n,m,n/m))
    except:
        print("Ha ocurrido un error, introduce bien el número")
    else:
        print("Todo ha funcionado correctamente")
        break  # Importante romper la iteración si todo ha salido bien
    finally:
        print("Fin de la iteración") # Siempre se ejecuta
```

```
Introduce un número: aaa
Ha ocurrido un error, introduce bien el número
Fin de la iteración
Introduce un número: 10
10.0/4=2.5
Todo ha funcionado correctamente
Fin de la iteración
```

### Capturando múltiples excepciones

**Guardando la excepción**

Podemos asignar una excepción a una variable (por ejemplo e). De esta forma haciendo un pequeño truco podemos analizar el tipo de error que sucede gracias a su identificador:

```python
try:
    n = input("Introduce un número: ")
    5/n
except Exception as e:
    print( type(e).__name__ )
```

```
Introduce un número: 10
TypeError
```



**Encadenando excepciones**

Gracias a los identificadores de errores podemos crear múltiples comprobaciones, siempre que dejemos en último lugar la excepción por defecto *Excepcion* que engloba cualquier tipo de error (si la pusiéramos al principio, las demas excepciones nunca se ejecutarían):

```python
try:
    n = float(input("Introduce un número: "))
    5/n
except TypeError:
    print("No se puede dividir el número por una cadena")
except ValueError:
    print("Debes introducir una cadena que sea un número")
except ZeroDivisionError:
    print("No se puede dividir por cero, prueba otro número")
except Exception as e:
    print( type(e).__name__ )
```

```
Introduce un número: aaaa
ValueError
```



### Invocación de excepciones

La instrucción raise

Gracias a raise podemos lanzar un error manual pasándole el identificador. Luego simplemente podemos añadir un except para tratar esta excepción que hemos lanzado:

```python
def mi_funcion(algo=None):
    try:
        if algo is None:
            raise ValueError("Error! No se permite un valor nulo")
    except ValueError:
        print("Error! No se permite un valor nulo (desde la excepción)")
mi_funcion()
```

```
Error! No se permite un valor nulo (desde la excepción)
```


### Ejercicio

Realiza una función llamada `agregar_una_vez()` que reciba una lista y un elemento. La función debe añadir el elemento al final de la lista con la condición de no repetir ningún elemento. Además si este elemento ya se encuentra en la lista se debe invocar un error de tipo `ValueError` que debes capturar y mostrar este mensaje en su lugar:

```
  Error: Imposible añadir elementos duplicados => [elemento].
```

** Pueba de agregar los elementos 10, -2, "Hola" a la lista de elementos con la función una vez la has creado y luego muestra su contenido. **

```python
elementos = [1, 5, -2]

def agregar_una_vez(lista, el):
    try:
        if el in lista:
            raise ValueError
        else:
            lista.append(el)
    except ValueError:
        print("Error: Imposible añadir elementos duplicados =>", el)
        

agregar_una_vez(elementos, 10)
agregar_una_vez(elementos, -2)
agregar_una_vez(elementos, "Hola")
print(elementos)
```

```
Error: Imposible añadir elementos duplicados => -2
[1, 5, -2, 10, 'Hola']
```



