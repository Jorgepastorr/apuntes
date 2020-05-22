# Distribución

## Setuptools

En Python todo el tema de empaquetar puede ser un poco lioso, ya que encontramos varios módulos desintados a ello. Nosotros vamos a centrarnos en **setuptools**, ya que es la forma más utilizada, nos proporciona todo lo necesario para distribuir nuestros propios módulos e incluso nos permite publicar paquetes en el respositorio público PyPI (Python Package Index) de forma directa desde la propia terminal.

Si lo recordáis, en la lección de módulos ya os enseñé como crear un distribuible con setuptools, a lo largo de esta lección vamos a repasar y aprender varios conceptos nuevos.

### Paquete básico

Antes de comenzar es importante repasar la estructura de un paquete en Python,ya que para distribuir nuestro código es indispensable estructurarlo dentro de un paquete:

```
| setup.py         # Fichero que contiene toda la información de instalación
+ prueba/          # Directorio del paquete al mismo nivel que setup.py
   | __init__.py   # Fichero que indica que el directorio es un paquete
   | modulo.py     # Módulo o script que contiene definiciones
```

Por lo tanto vamos a empaquetar el paquete de nombre **prueba**, que contiene código en el fichero *modulo.py*.

Vamos a aprender un poco más sobre el fichero de instalación.

### setup.py

El fichero de configuración incluye toda la información necesaria para realizar la instalación de nuestro paquete. Algunos campos incluyen sólo metadatos como el nombre, la versión, la descripción o el autor. Pero otros sirven para extender la instalación.

Como sería un caos que cada desarrollador pusiera los campos que quisiera, hay una serie de parámetros comunes y avanzados, pero como son muchos lo más común es utilizar una plantilla base como la siguiente que pasa la configuración a la función **setup**:

```python
from setuptools import setup

setup(name="Prueba",  # Nombre
      version="0.1",  # Versión de desarrollo
      description="Paquete de prueba",  # Descripción del funcionamiento
      author="Hector Costa",  # Nombre del autor
      author_email='me@hcosta.info',  # Email del autor
      license="GPL",  # Licencia: MIT, GPL, GPL 2.0...
      url="http://ejemplo.com",  # Página oficial (si la hay)
      packages=['prueba'],
)
```

¿Hasta aquí fácil no? Son simples metadatos para definir el paquete, con la excepción de **packages**, en el que tenemos que indicar todos los paquetes que formarán parte del paquete distribuido en forma de lista.

Aunque en este caso únicamente tendríamos al paquete **prueba**, imaginaros que tenemos docenas de subpaquetes y tubiéramos que añadirlos uno a uno... Pues para estos casos podemos importar una función que se encargará de buscar automáticamente los subpaquetes, se trata de **find_packages** y la podemos encontrar dentro de **setuptools**:

```python
from setuptools import setup, find_packages

setup(...
      packages=find_packages()
)
```

### Dependencias

Ahora imaginaros que en vuestro paquete algún código utiliza funciones de un módulo externo o paquete que hay que instalar manualmente. Esto se conoce como dependencias del paquete, y por suerte podemos indicar a un parámetro que descargue todos los paquetes en la versión que nosotros indiquemos, se trata de **install_requires**. 

Por ejemplo imaginad que dentro de nuestro paquete necesitamos utilizar el módulo **Pillow** para manejar imágenes. Por regla general podemos instalarlo desde la terminal con el comando:

```
pip install pillow
```

Pero si queremos que el paquete lo instale automáticamente sólo tenemos que indicarlo de esta forma:

```python
setup(...,
      install_requires=["pillow"],
)
```

Y así iríamos poniendo todas las dependencias en la lista.

Lo bueno que tiene es que podemos indicar la versión exacta que queremos instalar, por ejemplo. Si mi programa utilizase la versión 1.1.0 de Pillow tendría que poner:

```python
setup(...,
      install_requires=["pillow==1.1.0"],
)
```

En cambio si fuera compatible con cualquier versión a partir de la 1.1.5 podría poner:

```python
setup(...,
      install_requires=["pillow>=1.1.5"],
)
```

Si no indicamos una versión, se instalará automáticamente la más actual.

#### Utilizando un fichero de dependencias

De forma similar a antes, quizá llega el momento donde tenemos muchísimas dependencias y es un engorro tener que cambiar directamente el fichero **setup.py**. Para solucionarlo podemos utilizar una técnica que se basa en crear un fichero de texto y escribir las dependencias, una por línea.

Luego podemos abrir el fichero y añadir las dependencias automáticamente en forma de lista. Generalmente a este fichero se le llama **requirements.txt** y debe estar en el mismo directorio que **setup.py**:

##### requirements.txt

```
pillow==1.1.0
django>=1.10.0,<=1.10.3
pygame
```

Luego en las dependencias indicaríamos lo siguiente:

```python
setup(...,
      install_requires=[i.strip() for i in open("requirements.txt").readlines()],
)
```

### Suite Test

Otra cosa interesante que podemos hacer es adjuntar una suite de tests unitarios para nuestro paquete, ya sabéis, los que aprendimos en la unidad anterior. 

Para incluirlos tendremos indicar un parámetro en el instalador llamado **test_suite**, al que le pasaremos el nombre del directorio que los contiene, por lo general llamado **tests**:

```
| setup.py
| requeriments.txt
+ prueba/          
   | __init__.py   
   | modulo.py  
+ tests/
   | test_pillow.py
   | test_django.py
   | test_pygame.py
```

En el **setup.py**:

```python
setup(...,
      test_suite="tests"
)
```

Luego para ejecutarlos podemos utilizar el comando:

```python
python setup.py test
```

## PyPI y PIP

Por último hablemos un poco más del **Python Package Index**. 

Como ya sabéis se trata de un repositorio público con miles y miles de paquetes creados por la enorme comunidad de Python. De hecho yo mismo creé hace años un pequeño módulo para el framework django, os dejo el enlace por si os pica la curiosidad: https://pypi.python.org/pypi/django-easyregistration 

Sea como sea, la forma de instalar cómodamente los paquetes de PyPI es con la herramienta PIP (un acrónimo recursivo de Pip Installs Packages), utilizando el comando **pip install nombre_paquete**. 

Además podemos listar los paquetes instalados con **pip list**, borrar alguno con **pip uninstall  nombre_paquete** o incluso instalar todas las dependencias de un fichero **requisites.txt** utilizando **pip install requisites.txt**.

Si queréis saber más sobre pip, simplemente escribid **pip** en la terminal.

### Clasificadores

Por lo tanto tenemos un repositorio inmenso, así que ¿cómo podemos añadir información para categorizar nuestro paquete en PyPI? Pues utilizando un parámetro llamado **classifiers** de la siguiente forma:

```python
setup(...,
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Topic :: Utilities",
        "License :: OSI Approved :: GNU General Public License (GPL)",
    ],
)
```

Hay un montón de clasificadores, desde el estado del proyecto, el tema, las licencias, etc. Una lista completa de los clasificadores disponibles podemos encontrarla en la propia web de PyPI:
https://pypi.python.org/pypi?%3Aaction=list_classifiers

### Probando el paquete

Una vez tenemos toda la información configurada, podemos probar nuestro paquete fácilmente realizando una instalación en modo desarrollo. Para ello utilizaríamos el siguiente comando:

```
python setup.py develop
```

Este modo es muy práctico, ya que nos permite utilizar nuestro módulo en cualquier lugar y hacer modificacione sin necesidad de reinstalarlo constamente. Eso es posible porque se utiliza desde el propio directorio. 

Una vez hayamos hecho las probaturas y estemos satisfechos, podemos desinstalar el paquete de desarrollo:

```
python setup.py develop --uninstall
```

Para instalar el paquete definitivo utilizaríamos:

```
python setup.py install
```

Pero tenemos que tener en cuenta que una vez hecho esto, el paquete se instala en una copia interna y ya no podremos modificarlo sin antes desinstalarlo, algo que tendremos que hacer con PIP, buscando el nombre del paquete con **pip list** y haciendo un **pip uninstall nombre_paquete**.

## Distribuyendo el paquete

Ya tenemos el paquete, hemos creado el instalador, lo hemos probado y estamos preparados para distribuirlo. Hay dos formas:

* **Localmente**: Generando un fichero comprimido que podemos compartir con nuestros conocidos.
* **Públicamente**: En el repositorio PyPI para que todo el mundo pueda utilizarlo.

Evidentemente si distribuimos localmente no tenemos que tener mucho cuidado, y además podemos hacer pruebas. Pero si decidimos hacerlo públicamente tendremos que intentar que el paquete tenga un mínimo de calidad.

### Localmente

Distribuir el paquete localmente es muy fáci. Simplemente tenemos que utilizar el comando:

```
python setup.py sdist
```

Esto generará un directorio **dist/** en la carpeta del paquete. Dentro encontraremos un fichero zip o tar.gz dependiendo de nuestro sistema operativo.

Este fichero ya podremos compartirlo con quien queramos, y para instalarlo sólo tendremos que utilizar la herramienta **pip**:

```
pip install nombre_del_fichero.zip  # La extensión depende del sistema operativo
```

Luego para desinstalarlo de la misma forma pero utilizando el nombre del paquete:

```
pip uninstall nombre_paquete
```

### Públicamente

Aunque no voy a hacer la demostración porque ahora mismo no dispongo de un paquete para publicar en el repositorio de PyPI, sí que os voy a enseñar los pasos a seguir para hacerlo. Lo bueno de registrar un paquete en PyPI es que podemos instalarlo desde cualquier lugar a través de internet utilizando la herramienta PIP.

Dicho ésto, si algún día creáis un paquete de calidad y queréis compartirlo con la comunidad, lo primero es registrar una cuenta en PyPI: https://pypi.python.org/pypi?%3Aaction=register_form

A continuación desde el directorio de nuestro paquete tenemos que ejecutar el comando:

```
python setup.py register
```

Así iniciaremos una petición para registrar nuestro paquete en el repositorio. Luego tendremos que seguir los pasos e identificarnos cuando lo pida con nuestro usuario y contraseña (que hemos creado antes).

Una vez hecho esto ya hemos creado nuestro paquete, pero todavía no hemos publicado una versión, así que vamos a hacerlo utilizando el comando:

```
python setup.py sdist upload
```

¡Y ya está! Ahora podremos instalar nuestro paquete desde en cualquier lugar con PIP:

```
pip install nombre_paquete
```



## Pyinstaller

Ya hemos visto como distribuir nuestros paquetes... ¿Pero y si creamos una aplicación y queremos generar un ejecutable para utilizarla? Bueno, en este caso puede ser bastante complicado dependiendo de las dependencias que utilice el programa.

Por suerte hay un módulo que nos ayudará mucho a generar ejecutables porque automatiza el proceso, ese es **pyinstaller**.

Lo que hace es generar un .EXE en Windows, un .DMG en MAC o el ejecutable que utilice el sistema operativo. Dentro del ejecutable se incluye el propio intérprete de Python, y por esa razón podremos utilizarlo en cualquier ordenador sin necesidad de instalar Python previamente.

### Instalación

La instalación es muy fácil:

```
pip install pyinstaller
```

No hay más.

### Primer ejecutable

Comencemos con algo simple, tenemos un script **hola.py**:

```python
print("Hola mundo!")
```

Y queremos crear un ejecutable a partir de él, pues haríamos lo siguiente:

```
pyinstaller hola.py
```

Una vez acabe el proceso se nos habrán creado varias carpetas. La que nos interesa es **dist**, y dentro encontraremos una carpeta con el nombre programa y en esta un montón de ficheros y el ejecutable, en mi caso como estoy en Windows es **hola.exe**.

Como es un programa para terminal, para ejecutarlo tengo que abrir la terminal en ese directorio y ejecutar el programa manualmente:

```
C:\Users\Hector\Desktop\hola\dist\hola>hola.exe
Hola mundo!
```

### Ejecutable con interfaz

Ahora vamos a hacer otro a partir de un simple programa con Tkinter, la librería de componentes integrada en Python que ya conocemos. Nos debería funcionar sin problemas:

```python
from tkinter import *
root = Tk()
Label(text='Hola mundo').pack(pady=10)
root.mainloop()
```

Suponiendo que lo hemos puesto en el mismo script:

```
pyinstaller hola.py
```

En esta ocasión si ejecutamos el programa con doble clic nos funcionará bien, el problema es que se muestra la terminal de fondo.

Para que desaparezca tenemos que indicar que es una aplicación en ventana, y eso lo hacemos de la siguiente forma al crear el ejecutable:

```
pyinstaller --windowed hola.py
```

### Ejecutable en un fichero

Ya véis que por defecto Pyinstaller crea un directorio con un montón de ficheros. Podemos utilizar un comando para generar un solo fichero ejecutable que lo contenga todo, pero este ocupara bastante más:

```
pyinstaller --windowed --onefile hola.py
```

### Cambiar el icono

También podemos cambiar el icono por defecto del ejecutable. Para ello necesitamos una imagen en formato .ico.

```
pyinstaller --windowed --onefile --icon=./hola.ico hola.py
```

Si no tenéis uno, podéis utilizar este para probar: http://www.iconarchive.com/download/i3532/artua/star-wars/Darth-Vader.ico

Si por algo no os cambia el icono, probad cambiando el nombre del ejecutable. A veces el caché de Windows puede ignorar estas cosas.

## Limitaciones

El gran problema con Pyinstaller como os decía al principio son las dependencias.

Si nuestro programa utiliza únicamente módulos de la librería estándard no tendremos ningún problema, pero si queremos utilizar módulos externos es posible que no funcione... A no ser que sea alguno de los soportados como PyQT, django, pandas, matpotlib... pero requieren una configuraciones extra.

Si queréis saber más os dejo este enlace con los paquetes soportados:
https://github.com/pyinstaller/pyinstaller/wiki/Supported-Packages

Personalmente nunca he hecho nada avanzado, pero si queréis hacerlo y no lo conseguís, os podéis poner en contacto conmigo y estaré encantado de ayudaros.

Y con esto llegamos al final... por ahora ;-)
