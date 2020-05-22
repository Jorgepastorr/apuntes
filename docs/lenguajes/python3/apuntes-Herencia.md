# Herencias






## Estructura para los productos de una tienda

### Ejemplo sin herencia


```python
class Producto:
    def __init__(self,referencia,tipo,nombre,pvp,descripcion,productor=None,distribuidor=None,isbn=None,autor=None):
        self.referencia = referencia
        self.tipo = tipo
        self.nombre = nombre
        self.pvp = pvp
        self.descripcion = descripcion
        self.productor = productor
        self.distribuidor = distribuidor
        self.isbn = isbn
        self.autor = autor
        
adorno = Producto('000A','ADORNO','Vaso Adornado',15,'Vaso de porcelana con dibujos')   
```


```python
print(adorno)
```


    <__main__.Producto at 0x5243810>




```python
adorno.tipo
```


    'ADORNO'



## Creando una jerarquía de productos con clases
### Superclase Producto


```python
class Producto:
    def __init__(self,referencia,nombre,pvp,descripcion):
        self.referencia = referencia
        self.nombre = nombre
        self.pvp = pvp
        self.descripcion = descripcion
        
    def __str__(self):
        return """\
REFERENCIA\t{}
NOMBRE\t\t{}
PVP\t\t{}
DESCRIPCIÓN\t{}""".format(self.referencia,self.nombre,self.pvp,self.descripcion)
```

### Subclase Adorno


```python
class Adorno(Producto):
    pass

a = Adorno(2034,"Vaso adornado",15,"Vaso de porcelana adornado con árboles")
print(a)
```

```python
Referencias	2034
Nombre		Vaso adornado
PVP		15
Descripcion	Vaso de porcelana adornado con árboles
```

### Subclase Alimento


```python
class Alimento(Producto):
    productor = ""
    distribuidor = ""
    
    def __str__(self):
        return """\
REFERENCIA\t{}
NOMBRE\t\t{}
PVP\t\t{}
DESCRIPCIÓN\t{}
PRODUCTOR\t{}
DISTRIBUIDOR\t{}""".format(self.referencia,self.nombre,self.pvp,self.descripcion,self.productor,self.distribuidor)
        
    
al = Alimento(2035,"Botella de Aceite de Oliva Extra",5,"250 ML")
al.productor = "La Aceitera"
al.distribuidor = "Distribuciones SA"

print(al)
```

    REFERENCIA		2035
    NOMBRE			Botella de Aceite de Oliva Extra
    PVP				5
    DESCRIPCIÓN		250 ML
    PRODUCTOR		La Aceitera
    DISTRIBUIDOR	Distribuciones SA


### Subclase Libro


```python
class Libro(Producto):
    isbn = ""
    autor = ""
    
    def __str__(self):
        return """\
REFERENCIA\t{}
NOMBRE\t\t{}
PVP\t\t{}
DESCRIPCIÓN\t{}
ISBN\t\t{}
AUTOR\t\t{}""".format(self.referencia,self.nombre,self.pvp,self.descripcion,self.isbn,self.autor)
    
li = Libro(2036,"Cocina Mediterránea",9,"Recetas sanas y buenas")
li.isbn = "0-123456-78-9"
li.autor = "Doña Juana"

print(li)
```

    REFERENCIA	2036
    NOMBRE		Cocina Mediterránea
    PVP		9
    DESCRIPCIÓN	Recetas sanas y buenas
    ISBN		0-123456-78-9
    AUTOR		Doña Juana



## Trabajando con clases heredadas en conjunto

```python
class Producto:
    def __init__(self,referencia,nombre,pvp,descripcion):
        self.referencia = referencia
        self.nombre = nombre
        self.pvp = pvp
        self.descripcion = descripcion
        
    def __str__(self):
        return """\
REFERENCIA\t{}
NOMBRE\t\t{}
PVP\t\t{}
DESCRIPCIÓN\t{}""".format(self.referencia,self.nombre,self.pvp,self.descripcion)
    

class Adorno(Producto):
    pass


class Alimento(Producto):
    productor = ""
    distribuidor = ""
    
    def __str__(self):
        return super().__str__() + """\
PRODUCTOR\t{}
DISTRIBUIDOR\t{}""".format(self.productor,self.distribuidor)


class Libro(Producto):
    isbn = ""
    autor = ""
    
    def __str__(self):
        return super().__str__() + """\
ISBN\t\t{}
AUTOR\t\t{}""".format(self.isbn,self.autor)
```

#### Creamos algunos objetos

```python
ad = Adorno(2034,"Vaso adornado",15,"Vaso de porcelana adornado con árboles")

al = Alimento(2035,"Botella de Aceite de Oliva Extra",5,"250 ML")
al.productor = "La Aceitera"
al.distribuidor = "Distribuciones SA"

li = Libro(2036,"Cocina Mediterránea",9,"Recetas sanas y buenas")
li.isbn = "0-123456-78-9"
li.autor = "Doña Juana"
```

### Lista de productos

```python
productos = [ad, al]
productos.append(li)
print(productos)
```

```
[<__main__.Adorno at 0x14c58660940>,
 <__main__.Alimento at 0x14c586608d0>,
 <__main__.Libro at 0x14c58660978>]
```



## Lectura secuencial de productos con un for .. in

```python
for p in productos:
    print(p,"\n")
```

```
REFERENCIA	2034
NOMBRE		Vaso adornado
PVP		15
DESCRIPCIÓN	Vaso de porcelana adornado con árboles 

REFERENCIA	2035
NOMBRE		Botella de Aceite de Oliva Extra
PVP		5
DESCRIPCIÓN	250 ML
PRODUCTOR	La Aceitera
DISTRIBUIDOR	Distribuciones SA 

REFERENCIA	2036
NOMBRE		Cocina Mediterránea
PVP		9
DESCRIPCIÓN	Recetas sanas y buenas
ISBN		0-123456-78-9
AUTOR		Doña Juana 
```



#### Podemos acceder a los atributos si son compartidos entre todos los objetos

```python
for p in productos:
    print(p.referencia, p.nombre)
```

```
2034 Vaso adornado
2035 Botella de Aceite de Oliva Extra
2036 Cocina Mediterránea
```

#### Pero si un objeto no tiene el atributo deseado, dará error:

```python
for p in productos:
    print(p.autor)
```

```
---------------------------------------------------------------------------

AttributeError                            Traceback (most recent call last)

<ipython-input-8-36e9baf5c1cc> in <module>()
      1 for p in productos:
----> 2     print(p.autor)
AttributeError: 'Adorno' object has no attribute 'autor'
```



#### Tendremos que tratar cada subclase de forma distinta, gracias a la función isistance():

```python
for p in productos:
    if( isinstance(p, Adorno) ):
        print(p.referencia,p.nombre)
    elif( isinstance(p, Alimento) ):
        print(p.referencia,p.nombre,p.productor)
    elif( isinstance(p, Libro) ):
        print(p.referencia,p.nombre,p.isbn)        
```

```
2034 Vaso adornado
2035 Botella de Aceite de Oliva Extra La Aceitera
2036 Cocina Mediterránea 0-123456-78-9
```

## Funciones que reciben objetos de distintas clases

### Los obetos se envían por referencia a las funciones

Así que debemos tener en cuenta que cualquier cambio realizado dentro afectará al propio objeto.

```python
def rebajar_producto(p, rebaja):
    """Rebaja un producto en porcentaje de su precio"""
    p.pvp = p.pvp - (p.pvp/100 * rebaja)

rebajar_producto(al, 10)
print(al_rebajado)
```

```
REFERENCIA	2038
NOMBRE		Botella de Aceite de Oliva Extra
PVP		4.5
DESCRIPCIÓN	250 ML
PRODUCTOR	La Aceitera
DISTRIBUIDOR	Distribuciones SA
```



```python
print(al)
```

```
REFERENCIA	2035
NOMBRE		Botella de Aceite de Oliva Extra
PVP		4.5
DESCRIPCIÓN	250 ML
PRODUCTOR	La Aceitera
DISTRIBUIDOR	Distribuciones SA
```

### Una copia de un objeto también hace referencia al objeto copiado (como un acceso directo)

```python
copia_al = al
```

```python
copia_al.referencia = 2038
```

```python
print(copia_al)
```

```
REFERENCIA	2038
NOMBRE		Botella de Aceite de Oliva Extra
PVP		4.5
DESCRIPCIÓN	250 ML
PRODUCTOR	La Aceitera
DISTRIBUIDOR	Distribuciones SA
```



```python
print(al)
```

```
REFERENCIA	2038
NOMBRE		Botella de Aceite de Oliva Extra
PVP		4.5
DESCRIPCIÓN	250 ML
PRODUCTOR	La Aceitera
DISTRIBUIDOR	Distribuciones SA
```

#### Esto también sucede con los tipos compuestos:

```python
l = [1,2,3]
```

```python
l2 = l[:]
```

```python
l2.append(4)
```

```python
l
```

```
[1, 2, 3, 4]
```



### Para crear una copia 100% nueva debemos utilizar el módulo copy:

```python
import copy

copia_ad = copy.copy(ad)
```

```python
print(copia_ad)
```

```
REFERENCIA	2034
NOMBRE		Vaso adornado
PVP		15
DESCRIPCIÓN	Vaso de porcelana adornado con árboles
```



```python
copia_ad.pvp = 25
```

```python
print(copia_ad)
```

```
REFERENCIA	2034
NOMBRE		Vaso adornado
PVP		25
DESCRIPCIÓN	Vaso de porcelana adornado con árboles

```



```python
print(ad)
```

```
REFERENCIA	2034
NOMBRE		Vaso adornado
PVP		15
DESCRIPCIÓN	Vaso de porcelana adornado con árboles

```

## Polimorfismo

Se refiere a una propiedad de la herencia por la que objetos de distintas subclases pueden responder a una misma acción.

```python
def rebajar_producto(p, rebaja):
    p.pvp = p.pvp - (p.pvp/100 * rebaja)
```

El método  **rebajar_producto() ** es capaz de tomar objetos de distintas subclases y manipular el atributo **pvp**.

La acción de manipular el **pvp** funcionará siempre que los objetos tengan ése atributo, pero en el caso de no ser así, daría error.

La polimorfia es implícita en Python en todos los objetos, ya que todos son hijos de una superclase común llamada **Object**.



# Herencia múltiple

Posibilidad de que una subclase herede de múltiples superclases.

El problema aparece cuando las superclases tienen atributos o métodos comunes. 

En estos casos, Python dará prioridad a las clases más a la izquierda en el momento de la declaración de la subclase.

```python
class A:
    def __init__(self):
        print("Soy de clase A")
    def a(self):
        print("Este método lo heredo de A")
        
class B:
    def __init__(self):
        print("Soy de clase B")
    def b(self):
        print("Este método lo heredo de B")
        
class C(B,A):
    def c(self):
        print("Este método es de C")

c = C()
```

```
Soy de clase B
```



```python
c.a()
```

```
Este método lo heredo de A
```



```python
c.b()
```

```
Este método lo heredo de B
```



```python
c.c()
```

```
Este método es de C
```



# Ejercicio: Herencia en la POO

**En este ejercicio vas a trabajar el concepto de herencia un poco más en profundidad, aprovechando para introducir un nuevo concepto muy importante que te facilitará mucho la vida.**

Hasta ahora sabemos que una clase heredada puede fácilmente extender algunas funcionalidades, simplemente añadiendo nuevos atributos y métodos, o sobreescribiendo los ya existentes. Como en el siguiente ejemplo
<br><br>
<img src="http://www.escueladevideojuegos.net/ejemplos_edv/Cursos/Python/EjemploClases.png" />
<br>

```python
class Vehiculo():
    
    def __init__(self, color, ruedas):
        self.color = color
        self.ruedas = ruedas
        
    def __str__(self):
        return "color {}, {} ruedas".format( self.color, self.ruedas )
        
        
class Coche(Vehiculo):
    
    def __init__(self, color, ruedas, velocidad, cilindrada):
        self.color = color
        self.ruedas = ruedas
        self.velocidad = velocidad
        self.cilindrada = cilindrada
        
    def __str__(self):
        return "color {}, {} km/h, {} ruedas, {} cc".format( self.color, self.velocidad, self.ruedas, self.cilindrada )
        
        
c = Coche("azul", 150, 4, 1200)
print(c)
```

```
Color azul, 4 km/h, 150 ruedas, 1200 cc
```

**El inconveniente más evidente de ir sobreescribiendo es que tenemos que volver a escribir el código de la superclase y luego el específico de la subclase.**

Para evitarnos escribir código innecesario, podemos utilizar un truco que consiste en llamar el método de la superclase y luego simplemente escribir el código de la clase:

```python
class Vehiculo():
    
    def __init__(self, color, ruedas):
        self.color = color
        self.ruedas = ruedas
        
    def __str__(self):
        return "color {}, {} ruedas".format( self.color, self.ruedas )
        
        
class Coche(Vehiculo):
    
    def __init__(self, color, ruedas, velocidad, cilindrada):
        Vehiculo.__init__(self, color, ruedas)
        self.velocidad = velocidad
        self.cilindrada = cilindrada
        
    def __str__(self):
        return Vehiculo.__str__(self) + ", {} km/h, {} cc".format(self.velocidad, self.cilindrada)  # utilizamos super()
        
        
c = Coche("azul", 4, 150, 1200)
print(c)
```

```
Color azul, 4 ruedas, 150 km/h, 1200 cc
```

**Como tener que determinar constantemente la superclase puede ser fastidioso, Python nos permite utilizar un acceso directo mucho más cómodo llamada super().**

Hacerlo de esta forma además nos permite llamar cómodamente los métodos o atributos de la superclase sin necesidad de especificar el self.

```python
class Vehiculo():
    
    def __init__(self, color, ruedas):
        self.color = color
        self.ruedas = ruedas
        
    def __str__(self):
        return "color {}, {} ruedas".format( self.color, self.ruedas )
        
        
class Coche(Vehiculo):
    
    def __init__(self, color, ruedas, velocidad, cilindrada):
        super().__init__(color, ruedas)  # utilizamos super() sin self en lugar de Vehiculo
        self.velocidad = velocidad
        self.cilindrada = cilindrada
        
    def __str__(self):
        return super().__str__() + ", {} km/h, {} cc".format(self.velocidad, self.cilindrada)

    
c = Coche("azul", 4, 150, 1200)
print(c)
```

```
Vehículo azul, 4 ruedas, 150 km/h, 1200 cc
```

# Ejercicio

Utilizando esta nueva técnica, extiende la clase Vehiculo y realiza la siguiente implementación:
<br><br>
<img src="http://www.escueladevideojuegos.net/ejemplos_edv/Cursos/Python/EjercicioClases.png" />
<br>

## Experimenta

- Crea al menos un objeto de cada subclase y añádelos a una lista llamada vehiculos.
- Realiza una función llamada **catalogar()** que reciba la lista de vehiculos y los recorra mostrando el nombre de su clase y sus atributos.
- Modifica la función **catalogar()** para que reciba un argumento optativo **ruedas**, haciendo que muestre únicamente los que su número de ruedas concuerde con el valor del argumento. También debe mostrar un mensaje **"Se han encontrado {} vehículos con {} ruedas:"** únicamente si se envía el argumento ruedas. Ponla a prueba con 0, 2 y 4 ruedas como valor.

*Recordatorio: Puedes utilizar el atributo especial de clase **name** de la siguiente forma para recuperar el nombre de la clase de un objeto:*

```python
type(objeto).__name__
```

```python
class Vehiculo():
    
    def __init__(self, color, ruedas):
        self.color = color
        self.ruedas = ruedas
        
    def __str__(self):
        return "color {}, {} ruedas".format( self.color, self.ruedas )
        
        
class Coche(Vehiculo):
    
    def __init__(self, color, ruedas, velocidad, cilindrada):
        super().__init__(color, ruedas)  # utilizamos super() sin self en lugar de Vehiculo
        self.velocidad = velocidad
        self.cilindrada = cilindrada
        
    def __str__(self):
        return super().__str__() + ", {} km/h, {} cc".format(self.velocidad, self.cilindrada)

    
# Completa el ejercicio aquí

class Camioneta(Coche):
    
    def __init__(self, color, ruedas, velocidad, cilindrada, carga):
        super().__init__(color, ruedas, velocidad, cilindrada)
        self.carga = carga
        
    def __str__(self):
        return super().__str__() + ", {} kg de carga".format(self.carga)
    

class Bicicleta(Vehiculo):
    
    def __init__(self, color, ruedas, tipo):
        super().__init__(color, ruedas)
        self.tipo = tipo
        
    def __str__(self):
        return super().__str__() + ", {}".format(self.tipo)
    

class Motocicleta(Bicicleta):
    
    def __init__(self, color, ruedas, tipo, velocidad, cilindrada):
        super().__init__(color, ruedas, tipo)
        self.velocidad = velocidad
        self.cilindrada = cilindrada
        
    def __str__(self):
        return super().__str__() + ", {} km/h, {} cc".format(self.velocidad, self.cilindrada) 
    
    
def catalogar(vehiculos):
    for v in vehiculos:
        print(type(v).__name__, v)
        
def catalogar(vehiculos, ruedas=None):
      
    # Primera pasada, mostrar recuento
    if ruedas != None:
        contador = 0
        for v in vehiculos:
            if v.ruedas == ruedas: 
                contador += 1
        print("\nSe han encontrado {} vehículos con {} ruedas:".format(contador, ruedas))
    
    # Segnda pasada, mostrar vehículos
    for v in vehiculos:
        if ruedas == None:
            print(type(v).__name__, v)
        else:
            if v.ruedas == ruedas:
                print(type(v).__name__, v)
                
        
lista = [
    Coche("azul", 4, 150, 1200),
    Camioneta("blanco", 4, 100, 1300, 1500),
    Bicicleta("verde", 2, "urbana"),
    Motocicleta("negro", 2, "deportiva", 180, 900)
]

catalogar(lista)
catalogar(lista, 0)
catalogar(lista, 2)
catalogar(lista, 4)
```

```
Coche color azul, 4 ruedas, 150 km/h, 1200 cc
Camioneta color blanco, 4 ruedas, 100 km/h, 1300 cc, 1500 kg de carga
Bicicleta color verde, 2 ruedas, urbana
Motocicleta color negro, 2 ruedas, deportiva, 180 km/h, 900 cc

Se han encontrado 0 vehículos con 0 ruedas:

Se han encontrado 2 vehículos con 2 ruedas:
Bicicleta color verde, 2 ruedas, urbana
Motocicleta color negro, 2 ruedas, deportiva, 180 km/h, 900 cc

Se han encontrado 2 vehículos con 4 ruedas:
Coche color azul, 4 ruedas, 150 km/h, 1200 cc
Camioneta color blanco, 4 ruedas, 100 km/h, 1300 cc, 1500 kg de carga
```

