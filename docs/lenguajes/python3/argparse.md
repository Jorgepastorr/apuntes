# Argparse

https://bip.weizmann.ac.il/course/python/PyMOTW/PyMOTW/docs/argparse/index.html

https://docs.python.org/3/library/argparse.html



control de argumentos en python.

**importando libreria**

```bash
import argparse
```

### Help

El formateo del help es opcional ya qu se puede dejar en blanco y mostrara solo las opciones de argumentos añadidos, pero ya que lo tenemos lo dejaremos bonito.

`prog`: nombre del programa

`usage` : modo de uso

`formatter_class=argparse.RawDescriptionHelpFormatter`: forzar un formato literal, si no muesta toda la descripción en una línea.

`description`: descripcion del programa

`epilog`: Ultima linea que mostrara el help.

```python
parser = argparse.ArgumentParser(
        prog='provando_argparse.py',
        usage='%(prog)s [options]',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description='''
        haciendo pruevas con argparse
        ----------------------------
        Prueva de formato
        literal''',
        epilog="Epilog, es el footer del help"
        )
args = parser.parse_args()
```

```bash
python3 provando_agparse.py -h
usage: provando_argparse.py [options]

        haciendo pruevas con argparse
        ----------------------------
        Prueva de formato
        literal

optional arguments:
  -h, --help  show this help message and exit
```

### Version

```python
parser = argparse.ArgumentParser(
          prog='provando_argparse.py',
          usage='%(prog)s [options]',
          formatter_class=argparse.RawDescriptionHelpFormatter,
          description='''
              haciendo pruevas con argparse
              ----------------------------
              Prueva de formato
              literal''',
          epilog="Epilog, es el footer del help"
 )
parser.add_argument('--version', action='version', version='%(prog)s 1.0')
args = parser.parse_args()
```



### Argumento opcional, único en str

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("-a","--add", help="Detecta y confirma primer argumento")

argumento = analizador.parse_args()

if argumento.add :
    print("Argumento opcional solicitado -a")
    print("Argumento dado: " + argumento.add )
```

### Argumento opcional, unico en int

`type` permite obligar, que el argumento insertado sea de un tipo o otro.

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("-i","--integer", 
                            help="Detecta y confirma primer argumento integer",
                            type=int)

argumento = analizador.parse_args()

if argumento.integer :
    print("Argumento opcional solicitado -i")
    print("Argumento dado: ", argumento.integer )
```

### Argumento obligatorio

Al añadir un argumento sin el `-` se convierte en obligatorio, no se podra ejecutar el script sin como minimo 1 argumento.

ej: `python3 prog.py file.txt`

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("archivo",  help="Argumento obligatorio")

argumento = analizador.parse_args()

if argumento.archivo :
    print("Argumento obligatorio: archivo")
    print("Nombre del archivo: " + argumento.archivo )
```

### Número de argumentos esplicito

`nargs` permite indicar cuantos argumentos quieres que entren por opción

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("-s","--suma", 
                            help="Suma 2 argumentos numericos",
                            nargs=2,
                            type=int)

argumento = analizador.parse_args()

if argumento.suma :
    print("Argumento opcional solicitado -s")
    print(f"Resultado de {argumento.suma[0]} + {argumento.suma[1]} = {argumento.suma[0] + argumento.suma[1]}")
```

### Número x de argumentos

`nargs` nos deja jugar con alguna expresión regular por ejemplo.

| N   | The absolute number of arguments (e.g., 3). |
| --- | ------------------------------------------- |
| ?   | 0 or 1 arguments                            |
| *   | 0 or all arguments                          |
| +   | Todos, y al menos un argumento.             |

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("-l","--lista", 
                            help="Muestra todos los argumentos dados de 0 a n",
                            nargs="*")

argumento = analizador.parse_args()

if argumento.lista :
    print("Argumento opcional solicitado -l")
    print(f"la lista de argumentos es: {argumento.lista}")
```

### Opciones por default

En n argumento obligatorio si le añadimos un valor por defecto, se convierte en, no obligatorio al ya tener un valor predeterminado.

Muy útil para scripts con rutas predeterminadas e indicarle al usuario s quiere otra opcional que la escriba.

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("defecto", 
                            help="Muestra argumento y si no hay muestra el por defecto",
                            nargs="?",
                            default='hola mundo')

argumento = analizador.parse_args()

if argumento.defecto :
    print("Argumento opcional solicitado -d")
    print(f"la lista de argumentos es: {argumento.defecto}")
```

### Opcional en obligatorio

`required` obliga a que se añada el argumento obligatoriamente.

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("-r","--required", help="Lista los n argumentos dados",
                        required=True, nargs="*")

argumento = analizador.parse_args()

if argumento.required :
    print("Argumento opcional solicitado -r")
    print(f"Argumento dado: {argumento.required}")
```

### Lista opciones de argumento

`choices` opciones de argumento, solo aceptara  esas opciones al argumento indicado.

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument(
                        "mes",
                        choices=['Enero','Abril','Julio','Octubre'],
                        help="Permite escoger un mes de comienzo de trimestre.",
                        )
argumento = analizador.parse_args()

print("Argumento: solicita un mes de una lista predeterminada.")
print("Mes escogido:")
print(argumento.mes)
```

### Verificar opción

`action=store_true`  si la opción a sido añadida retornara un valor de `True` en el caso contrario `False`

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
analizador.add_argument("-l","--long", help="Detecta y confirma primer argumento",
                        action = "store_true")
analizador.add_argument("-a","--arbol", help="Detecta y confirma primer argumento",
                        action = "store_true")
argumento = analizador.parse_args()

if argumento.long:
    print("Argumento --long devuelve: " , argumento.long )
if argumento.arbol:
    print("Argumento --arbol devuelve: " , argumento.arbol )
```

`action=count`  tiene el poder de contar las veces que añades repetidament la opción, utilizado en vervose comunmente `-v -vv -vvv`

```python
parser = argparse.ArgumentParser()
parser.add_argument("square", type=int,
                    help="display the square of a given number")
parser.add_argument("-v", "--verbosity", action="count", default=0,
                    help="increase output verbosity")
args = parser.parse_args()
answer = args.square**2
if args.verbosity >= 2:
    print("the square of {} equals {}".format(args.square, answer))
elif args.verbosity >= 1:
    print("{}^2 == {}".format(args.square, answer))
else:
    print(answer)
```

### Opciones incompatibles entre ellas

Al crear un grupo de argumentos puedes diferenciar opciones incompatibles, por ejemplo en el siguiente script poedes añadir opción `-c o -e` pero nunca podras añadir las 2 a la vez.

```python
analizador = argparse.ArgumentParser(description='Tutorial sobre argparse.')
grupo = analizador.add_mutually_exclusive_group()
grupo.add_argument(
  "-c",
  "--cubo",
  action = "store_true",
  help="Imprime un cubo en tercera dimensión.",
)
grupo.add_argument(
  "-e",
  "--esfera",
  action = "store_true",
  help="Imprime una esfera en tercera dimensión.",
)
argumento = analizador.parse_args()
if argumento.cubo:
  print("'Imprime' un cubo")
if argumento.esfera:
  print("'Imprime' una esfera")
```
