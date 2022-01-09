# Salida por pantalla

La función print() es la forma general de mostrar información por pantalla. Generalmente podemos mostrar texto y variables separándolos con comas:

```python
v = "otro texto"
n = 10
print("Un texto",v,"y un número",n)
```

```
Un texto otro texto y un número 10

```

## El método .format()

Es una funcionalidad de las cadenas de texto que nos permite formatear información en una cadena (variables o valores literales) cómodamente utilizando identificadores referenciados:

```python
c = "Un texto '{}' y un número '{}'".format(v,n)
print(c)
```

```
"Un texto 'otro texto' y un número '10'"

```

También podemos referenciar a partir de la posición de los valores utilizando índices:

```python
print( "Un texto '{1}' y un número '{0}'".format(v,n) )
```

```
Un texto '10' y un número 'otro texto'

```

O podemos utilizar identificador con una clave y luego pasarlas en el format:

```python
print( "Un texto '{v}' y un número '{n}'".format(n=n,v=v) )
```

```
Un texto 'otro texto' y un número '10'

```



```python
print("{v},{v},{v}".format(v=v))
```

```
otro texto,otro texto,otro texto

```



## Formateo avanzado

Alineamiento a la derecha en 30 caracteres

```python
print( "{:>30}".format("palabra") )  
```

```
                       palabra

```



Alineamiento a la izquierda en 30 caracteres

```python
print( "{:30}".format("palabra") )  
```

```
palabra                       

```


Alineamiento al centro en 30 caracteres

```python
print( "{:^30}".format("palabra") ) 
```

```
           palabra            

```



Truncamiento a 3 caracteres

```python
print( "{:.5}".format("palabra") )  
```

```
palab

```



Alineamiento a la derecha en 30 caracteres con truncamiento de 3

```python
print( "{:>30.3}".format("palabra") )  
```

```
                           pal

```



Formateo de números enteros, rellenados con espacios

```python
print("{:4d}".format(10))
print("{:4d}".format(100))
print("{:4d}".format(1000))
```

```
  10
 100
1000

```



Formateo de números enteros, rellenados con ceros

```python
print("{:04d}".format(10))
print("{:04d}".format(100))
print("{:04d}".format(1000))
```

```
0010
0100
1000

```



Formateo de números flotantes, rellenados con espacios

```python
print("{:7.3f}".format(3.1415926))
print("{:7.3f}".format(153.21))
```

```
  3.142
153.210

```



Formateo de números flotantes, rellenados con ceros

```python
print("{:07.3f}".format(3.1415926))
print("{:07.3f}".format(153.21))
```

```
003.142
153.210

```


