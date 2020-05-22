# Test

## Doctest

Si por un lado las **docstrings** nos permitían describir documentación, los **doctest** nos permiten combinar pruebas en la propia documentación.

Este concepto de integrar las pruebas en la documentación nos ayuda a mantener las pruebas actualizadas, y además nos sirve como ejemplo de utilización del código, ayudándonos a explicar su propósito.

Para utilizar **doctests** hay que inidicar una línea dentro de la documentación de la siguiente forma:

```python
>>>
```

De esta Python entenderá que debe ejecutar el contenido dentro del comentario como si fuera código normal, y lo hará hasta que encuentre una línea en blanco (o llegue al final de la documentación).

La mejor forma de ver a **doctest** en acción.

### Definiendo pruebas

Por regla general cada prueba va ligada a una funcionalidad, pueden ser funciones, clases o sus métodos. Por ejemplo, dada una función **suma**...

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos"""
    return a+b
```

Para realizar una prueba dentro de la función, vamos a ejecutar un código de prueba de la propia suma:

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos

    >>> suma(5,10)
    """
    return a+b
```

Bien, ya tenemos la prueba, pero ahora nos falta indicarle a doctest cuál es el resultado que debería devolver la prueba, y eso lo indicaremos en la siguiente línea:

```python
>>>
```

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos

    >>> suma(5,10)
    15
    """
    return a+b
```

¡Muy bien! Ahora tenemos que ejecutar la pruebas y ver si funciona o no, pero antes tenemos que adaptar el código.

### Ejecutando pruebas en un módulo

Para ejecutar pruebas tendremos que utilizar la terminal, así vamos a guardar la función en un script **test.py** como si fuera un módulo con funciones.

Ahora justo al final indicaremos que se ejecten las pruebas doctest de las funciones del módulo escribiendo el siguiente código abajo del todo:

```python
import doctest
doctest.testmod()  # Notar que mod significa módulo
```

Esto sería suficiente, pero con el objetivo de evitar que este código se ejecute al importarlo desde otro lugar, se suele indicar de la siguiente forma:

```python
if __name__ == "__main__":
    import doctest
    doctest.testmod()
```

Así únicamente se lanzarán las pruebas al ejecutar directamente el módulo, y ya podremos ejecutar el módulo desde la terminal:

```bash
python test.py
```

Como resultado veremos que no se muestra nada. Eso no significa que no se ejecute nuestra prueba, sino que esta ha funcionado correctamente y no hay fallos.

Si queremos podemos mostrar todo el registro de ejecución pasando un argumento -v a python justo al final:

```bash
python test.py -v
```

Y entonces veremos el siguiente resultado:

```bash
Trying:
    suma(5,10)
Expecting:
    15
ok
1 items had no tests:
    __main__
1 items passed all tests:
   1 tests in __main__.suma
1 tests in 2 items.
1 passed and 0 failed.
Test passed.
```

En el que se prueba el código suma(5,10), se espera 15 y el resultado es ok; un resumen y finalmente Test passed.

### Creando varias pruebas

Evidentemente podemos definir múltiples pruebas. Probemos también alguna que sabemos que es incorrecta:

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos

    >>> suma(5,10)
    15

    >>> suma(0,0)
    1

    >>> suma(-5,7)
    2
    """
    return a+b
```

Ahora, si ejecutamos el script de forma normal...

```bash
python test.py
```

A diferencia que antes sí que nos muestra algo, indicándonos que uno de los tests a fallado:

```bash
**********************************************************************
File "test.py", line 7, in __main__.suma
Failed example:
    suma(0,0)
Expected:
    1
Got:
    0
**********************************************************************
1 items had failures:
   1 of   3 in __main__.suma
***Test Failed*** 1 failures.
```

La cuestión ahora sería revisar el test si es incorrecto, o adaptar la función para que devuelve el resultado esperado en el test. Evidentemente en este caso hemos hecho un test incorrecto a propósito así que simplemente lo borraríamos.



### Tests avanzados

Hasta ahora hemos hecho unos tests muy simples, pero los **doctests** son muy flexibles. Algunas de sus funcionalidades interesantes son la posibilidad de ejecutar bloques de código o la captura de excepciones.

Para crear un test que incluya un bloque de código, debemos utilizar las sentencias anidadas para simular tabulaciones:

```python
...
```

```python
def doblar(lista):
    """Dobla el valor de los elementos de una lista
    >>> l = [1, 2, 3, 4, 5] 
    >>> doblar(l)
    [2, 4, 6, 8, 10]
    """
    return [n*2 for n in lista]
```

En este caso hemos creado la lista del test manualmente, pero podríamos generarla con un bucle utilizando sentencias anidadas:

```python
def doblar(lista):
    """Dobla el valor de los elementos de una lista
    >>> l = [1, 2, 3, 4, 5] 
    >>> doblar(l)
    [2, 4, 6, 8, 10]

    >>> l = [] 
    >>> for i in range(10):
    ...     l.append(i)
    >>> doblar(l)
    [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
    """
    return [n*2 for n in lista]
```

Si ejecutamos el script monitorizando todo:

```bash
python test.py -v
```

Podemos observar la ejecución del test avanzado:

```bash
Trying:
    l = [1, 2, 3, 4, 5]
Expecting nothing
ok
Trying:
    doblar(l)
Expecting:
    [2, 4, 6, 8, 10]
ok
Trying:
    l = []
Expecting nothing
ok
Trying:
    for i in range(10):
        l.append(i)
Expecting nothing
ok
Trying:
    doblar(l)
Expecting:
    [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
ok
1 items had no tests:
    __main__
1 items passed all tests:
   5 tests in __main__.doblar
5 tests in 2 items.
5 passed and 0 failed.
Test passed.
```

Por último vamos a volver a nuestra función suma para tratar excepciones dentro de los tests.

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos

    Pueden ser números:

    >>> suma(5,10)
    15

    >>> suma(-5,7)
    2

    Cadenas de texto:

    >>> suma('aa','bb')
    'aabb'

    O listas:

    >>> a = [1, 2, 3]
    >>> b = [4, 5, 6]
    >>> suma(a,b)
    [1, 2, 3, 4, 5, 6]
    """
    return a+b
```

Ahora sabemos que no podemos sumar tipos distintos, ¿cómo podemos tenerlo en cuenta en un test?

Pues por ahora podemos suponer un resultado y comprobar el resultado cuando falle:

```python
>>> suma(10,"hola")
"10hola"
```

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos

    Pueden ser números:

    >>> suma(5,10)
    15

    >>> suma(-5,7)
    2

    Cadenas de texto:

    >>> suma('aa','bb')
    'aabb'

    O listas:

    >>> a = [1, 2, 3]
    >>> b = [4, 5, 6]
    >>> suma(a,b)
    [1, 2, 3, 4, 5, 6]

    Sin embargo no podemos sumar elementos de tipos diferentes:

    >>> suma(10,"hola")
    "10hola"
    """
    return a+b
```

Si ejecutamos el script monitorizando todo:

```bash
python test.py -v
```

Podemos observar el fallo:

```bash
Trying:
    suma(5,10)
Expecting:
    15
ok
Trying:
    suma(-5,7)
Expecting:
    2
ok
Trying:
    suma('aa','bb')
Expecting:
    'aabb'
ok
Trying:
    a = [1, 2, 3]
Expecting nothing
ok
Trying:
    b = [4, 5, 6]
Expecting nothing
ok
Trying:
    suma(a,b)
Expecting:
    [1, 2, 3, 4, 5, 6]
ok
Trying:
    suma(10,"hola")
Expecting:
    "10hola"
**********************************************************************
File "test.py", line 26, in __main__.suma
Failed example:
    suma(10,"hola")
Exception raised:
    Traceback (most recent call last):
      File "C:\Program Files\Anaconda3\lib\doctest.py", line 1321, in __run
        compileflags, 1), test.globs)
      File "<doctest __main__.suma[6]>", line 1, in <module>
        suma(10,"hola")
      File "test.py", line 29, in suma
        return a+b
    TypeError: unsupported operand type(s) for +: 'int' and 'str'
1 items had no tests:
    __main__
**********************************************************************
1 items had failures:
   1 of   7 in __main__.suma
7 tests in 2 items.
6 passed and 1 failed.
***Test Failed*** 1 failures.
```

Concretamente debemos fijarnos en la primera línea y última de la excepción:

```bash
    Traceback (most recent call last):
        ...
    TypeError: unsupported operand type(s) for +: 'int' and 'str'
```

Y precisamente esto es lo que tenemos que indicar en el test:

```python
def suma(a, b):
    """Esta función recibe dos parámetros y devuelve la suma de ambos

    Pueden ser números:

    >>> suma(5,10)
    15

    >>> suma(-5,7)
    2

    Cadenas de texto:

    >>> suma('aa','bb')
    'aabb'

    O listas:

    >>> a = [1, 2, 3]
    >>> b = [4, 5, 6]
    >>> suma(a,b)
    [1, 2, 3, 4, 5, 6]

    Sin embargo no podemos sumar elementos de tipos diferentes:

    >>> suma(10,"hola")
    Traceback (most recent call last):
        ...
    TypeError: unsupported operand type(s) for +: 'int' and 'str'
    """
    return a+b
```

Y con esto acabamos esta lección en la que hemos visto como crear tests sencillos en la documentación con **doctest**. En la siguiente veremos un tipo distinto de tests más avanzados, los tests unitarios o **Unittest**.



## Unittest

El módulo **unittest**, a veces referido como **PyUnit**, forma parte de una serie de frameworks conocidos como *xUnit*. Estas librerías se encuentran en la mayoría de lenguajes y son casi un estándard a la hora de programar pruebas unitarias.

A diferencia de **doctest**, **unittest** ofrece la posibilidad de crear las pruebas en el propio código implementando una clase llamada **unittest.TestCase** en la que se incluirá un *kit o batería de pruebas*.

Cada una de las pruebas puede devolver tres respuestas en función del resultado:

- **OK**: Para indicar que la prueba se ha pasado éxitosamente.

- **FAIL**: Para indicar que la prueba no ha pasado éxitosamente lanzaremos una excepción AssertionError (sentencia verdadero-falso)

- **ERROR**: Para indicar que la prueba no ha pasado éxitosamente, pero el resultado en lugar de ser una aserción es otro error.

Vamos a crear una prueba unitaria muy sencilla para ver su funcionamiento en un script **tests.py**:

```python
import unittest

class Pruebas(unittest.TestCase):
    def test(self):
        pass

if __name__ == "__main__":
    unittest.main()
```

En este sencillo ejemplo podemos observar como heredamos de la clase **unittest.TestCase** para crear una batería de pruebas.

Cada método dentro de esta clase será una prueba, que en nuestro ejemplo no lanza ninguna excepción ni error, porlo que significa que los tests pasarán correctamente, y finalmente ejecutamos el método main() para ejecutar todas las baterías:

```python
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
```

Como vemos se ha 1 realizado 1 test y el resultado a sido OK.

Si en lugar de pasar, invocamos una execepción AssertError...

```python
import unittest

class Pruebas(unittest.TestCase):
    def test(self):
        raise AssertionError()

if __name__ == "__main__":
    unittest.main()
```

Entonces el test fallaría:

```python
F
======================================================================
FAIL: test (__main__.Pruebas)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "C:\Users\Hector\Desktop\test.py", line 5, in test
    raise AssertionError()
AssertionError

----------------------------------------------------------------------
Ran 1 test in 0.000s

FAILED (failures=1)
```

En el supuesto caso que dentro del test diera un error no asertivo, entonces tendríamos un Error:

```python
import unittest

class Pruebas(unittest.TestCase):
    def test(self):
        1/0

if __name__ == "__main__":
    unittest.main()
```

Entonces el test fallaría:

```python
E
======================================================================
ERROR: test (__main__.Pruebas)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "C:\Users\Hector\Desktop\test.py", line 5, in test
    1/0
ZeroDivisionError: division by zero

----------------------------------------------------------------------
Ran 1 test in 0.001s

FAILED (errors=1)
```

### Excepciones Asertivas

Con lo que sabemos podríamos crear tests complejos sirviéndonos de condiciones y excepciones *AssertionError*, pero la clase **TestCase** nos provee de un montón de alternativas.

Vamos a hacer un repaso de las más comunes, recordad que siempre devolverán True o False dependiendo de si pasan o no el test:

![](img/errores.PNG)

Si os interesa profundizar os dejo el enlace oficial: https://docs.python.org/3/library/unittest.html

Vamos a hacer algunos ejemplos para practicar.

### Funciones propias

```python
import unittest

def doblar(a): return a*2
def sumar(a,b): return a+b  
def es_par(a): return 1 if a%2 == 0 else 0

class PruebasFunciones(unittest.TestCase):

    def test_doblar(self):
        self.assertEqual(doblar(10), 20)
        self.assertEqual(doblar('Ab'), 'AbAb')

    def test_sumar(self):
        self.assertEqual(sumar(-15, 15), 0)
        self.assertEqual(sumar('Ab' ,'cd'), 'Abcd')

    def test_es_par(self):
        self.assertEqual(es_par(11), False)
        self.assertEqual(es_par(68), True)

if __name__ == '__main__':
    unittest.main()
```

Resultado:

```bash
...
----------------------------------------------------------------------
Ran 3 tests in 0.000s

OK
```

### Métodos de cadenas

```python
import unittest

class PruebasMetodosCadenas(unittest.TestCase):

    def test_upper(self):
        self.assertEqual('hola'.upper(), 'HOLA')

    def test_isupper(self):
        self.assertTrue('HOLA'.isupper())
        self.assertFalse('Hola'.isupper())

    def test_split(self):
        s = 'Hola mundo'
        self.assertEqual(s.split(), ['Hola', 'mundo'])

if __name__ == '__main__':
    unittest.main()
```

Resultado:

```bash
...
----------------------------------------------------------------------
Ran 3 tests in 0.000s

OK
```

### Preparación y limpieza

Lo último importante a comentar es que la clase **TestCase** incorpora dos métodos extras.

El primero es **setUp()** y sirve para preparar el contexto de las pruebas, por ejemplo para escribir unos valores de prueba en un fichero conectarse a un servidor o a una base de datos.

Luego tendríamos **tearDown()** para hacer lo propio con la limpieza, borrar el fichero, desconectarse del servidor o borrar las entradas de prueba de la base de datos.

Este proceso de preparar el contexto se conoce como ***test fixture*** o accesorios de prueba.

Sólo por poner un ejemplo supongamos que necesitamos contar con una lista de elementos para realizar una serie de pruebas:

```python
import unittest

def doblar(a): return a*2

class PruebaTestFixture(unittest.TestCase):

    def setUp(self):
        print("Preparando el contexto")
        self.numeros = [1, 2, 3, 4, 5]

    def test(self):
        print("Realizando una prueba")
        r = [doblar(n) for n in self.numeros]
        self.assertEqual(r, [2, 4, 6, 8, 10])

    def tearDown(self):
        print("Destruyendo el contexto")
        del(self.numeros)

if __name__ == '__main__':
    unittest.main()
```

Resultado de la prueba:

```bash
Preparando el contexto
.
Realizando una prueba
Destruyendo el contexto
----------------------------------------------------------------------
Ran 1 test in 0.000s

OK
```

Y con esto finalizamos el tema.

Ahora ya sabemos cómo documentar nuestro código **docstrings**, generar la documentación con **pydoc**, introducir pruebas en las *docstrings* combinando **doctest**, y crear pruebas avanzadas con el módulo **unittest**.

Estamos a un paso de finalizar con el curso, sólo nos falta ver cómo distribuir nuestros módulos y programas.

¡Nos vemos en la próxima unidad!
