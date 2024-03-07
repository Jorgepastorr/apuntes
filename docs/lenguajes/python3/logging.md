
## Logging

Con el módulo logging, podemos registrar los mensajes que deseamos ver. Existen cinco (5) niveles estándar que indican la gravedad o el tipo de evento. 

    •	DEBUG - Depuración
    •	INFO - Información
    •	WARNING - Advertencia
    •	ERROR - Error
    •	CRITICAL – Crítico

El módulo logging proporciona un registrador predeterminado que nos permite comenzar sin necesidad de hacer mucha configuración. Los métodos correspondientes para cada nivel se pueden llamar de la siguiente manera:



```python
import logging
```


```python
import logging

logging.debug('Este es un mensaje de depuración')
logging.info('Este es un mensaje de información')
logging.warning('Este es un mensaje de advertencia')
logging.error('Este es un mensaje de error')
logging.critical('Este es un mensaje Critico')
```

    WARNING:root:Este es un mensaje de advertencia
    ERROR:root:Este es un mensaje de error
    CRITICAL:root:Este es un mensaje Critico


Observamos, que los mensajes debug() e info() no se muestran. Esto es porque de forma predeterminada, el módulo logging registra los mensajes con un nivel de gravedad de ADVERTENCIA o superior.  

Configuraciones básicas (Basic Configurations)
Podemos utilizar el método basicConfig(**kwargs) para configurar logging.  Algunos de los parámetros más utilizados para basicConfig() son los siguientes:

    •	level o nivel: La raíz de logging se establecerá en el nivel de gravedad especificado.
    •	filename o nombre de archivo: especifica el archivo.

Mediante el parámetro level, puede establecer el nivel de mensajes de registro que desea registrar. Esto se puede hacer pasando una de las constantes disponibles en la clase, y esto permitiría que se registren todas las llamadas de registro en o por encima de ese nivel. Por ejemplo:


```python
logging.basicConfig(level=logging.DEBUG)
```

Todos los eventos por encima o en el mismo nivel DEBUG, ahora se registrarán. 
Si necesitamos guardar estos registros en un archivo en lugar de mostrarlos en la consola, podemos utilizar el nombre de archivo y el modo de archivo y decidir el formato del mensaje utilizando el formato


```python
# Para visualizar la creación del fichero, abrir ficheros logging.py en Pycharm

import logging
import os

logFormatter = '%(asctime)s - %(user)s - %(levelname)s - %(message)s'

logging.basicConfig(level=logging.DEBUG, filename="milog.log", filemode='a',  format= logFormatter, datefmt='%d-%b-%y %H:%M:%S')
logger = logging.getLogger()  # crear el objeto

logger.warning('Estos se registrará en el archivo milog.log')
logger.info('El administrador, ha iniciado sesisón')
logger.warning('El administrador, ha cerrado su sesisón')
logger.debug('Esto es un ejemplo...')
logger.error('Este es un mensaje de error')
logger.critical('Este es un mensaje Critico')
```

    WARNING:root:Estos se registrará en el archivo milog.log
    INFO:root:El administrador, ha iniciado sesisón
    WARNING:root:El administrador, ha cerrado su sesisón
    DEBUG:root:Esto es un ejemplo...
    ERROR:root:Este es un mensaje de error
    CRITICAL:root:Este es un mensaje Critico


Formatear fichero de log

```python
import logging

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')
logging.warning('Este es una advertencia ....')

```

    WARNING:root:Este es una advertencia ....



```python
import logging

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S', level=logging.INFO)
logging.info('El administrador, ha iniciado sesisón')

```

    INFO:root:El administrador, ha iniciado sesisón



```python
import logging

logging.basicConfig(format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')
logging.warning('El administrador, ha cerrado su sesión')
```

    WARNING:root:El administrador, ha cerrado su sesión

Se pueden pasar variables al log

```python
import logging

name = 'John'
logging.error(f'{name} generó un error')

```

    ERROR:root:John generó un error


Enviar excepciones al log

```python
import logging

a = 5
b = 0

try:
  c = a / b
except Exception as e:
    logging.error("Ha ocurrido una excepción", exc_info=True)

```

    ERROR:root:Ha ocurrido una excepción
    Traceback (most recent call last):
      File "<ipython-input-9-87a667ac2f71>", line 7, in <module>
        c = a / b
    ZeroDivisionError: division by zero


El método addHandler() asigna el handler correspondiente al logger.

El método addHandler() no tiene ninguna cuota mínima o máxima para el número de controladores que puede agregar. A veces será beneficioso para una aplicación registrar todos los mensajes de todas las gravedades en un archivo de texto mientras registra simultáneamente errores o arriba en la consola. 


```python
import logging

logger = logging.getLogger('Ejemplo de LOG')

# Todos los mensajes de niveles superiores a DEBUG se guardan en el fichero
fh = logging.FileHandler('debug_jup.log') # Archivo 
fh.setLevel(logging.DEBUG)

# Todos los mensajes de ERROR o CRITICAL se mostrarán en la consola
ch = logging.StreamHandler()  # Consola
ch.setLevel(logging.ERROR)

#formato de los mensajes
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)

# Creamos los objetos
logger.addHandler(fh)
logger.addHandler(ch)

# Código de nuestra aplicación
logger.debug('mensaje debug')
logger.info('mensaje info')
logger.warning('mensaje warning')
logger.error('mensaje error')
logger.critical('mensaje critical')
```

    DEBUG:Ejemplo de LOG:mensaje debug
    INFO:Ejemplo de LOG:mensaje info
    WARNING:Ejemplo de LOG:mensaje warning
    2021-09-13 20:52:03,580 - Ejemplo de LOG - ERROR - mensaje error
    ERROR:Ejemplo de LOG:mensaje error
    2021-09-13 20:52:03,581 - Ejemplo de LOG - CRITICAL - mensaje critical
    CRITICAL:Ejemplo de LOG:mensaje critical

