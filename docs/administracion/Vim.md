# Vim atajos básicos

[Artículo completo](http://www.sromero.org/wiki/linux/aplicaciones/manual_vim)



##### Básico

```bash
dd		# cortar, borrar
v		# seleccionar
p		# pegar
y		# copiar
i		# editar
ESC		# modo comando
:q		# salir
ZZ, :qw!	# salir guardando
/123	# busca los caracteres 123 en el texto, n y N, mueves entre ellos
```



##### Movimiento inserción y borrado

```bash
x		# borrar caracter del cursor
J		# Junta la linea actual con la siguiente
u		# desacer ultima acción
Ctrl+R	# reacer ultima acción
A		# modo de insercion al final de la linea
o		# Crea linea vacia debajo linea actual
O		# Crea linea vacia encima linea actual
D		# Borra desde el cursor hasta final de linea
C		# cambiar el texto hasta el final de linea
```



##### Movimiento más avanzado

```bash
**MOVIMIENTO**
w		# mueve el cursor al principio de la siguiente palabla
b		# mueve el cursor al principio de la anterior palabla
Ctrl+direccion	# lo mismo que los dos anteriores y mas facil
$		# mueve el cursor al final de la linea
0		# mueve el cursor al inicio de la linea
{}		# mueve el cursor entre parrafos
%		# al usarlo entre un (), [], {} cerrados te lleva al cierre
10G		# ir a la linea 10

**BORRADO**
dw		# borrar texto hasta el final de la palabra
db		# borrar texto hasta el principio de la palabra
dis		# borrar hasta que encuentra un punto
dG		# borrar hasta el final del documento
dgg		# borrar hasta el inicio del documento
df,		# borrar hasta la primera ,

**PUNTO**
.		# repite el comando anterior
```



##### Seleccionar  

```bash
V		# Selecciona por lineas
Ctrl+V	# Selecciona tanto en vertical como horizontal ( muy útil )
:!sort 	# despues de seleccionar el texto que queremos lo ordenamos con sort
```
- Despues de seleccionar el texto que quieres tratar con `:!` puedes modificarlo al gusto, como anteriormente con sort. vale cualquier comando de la shell: `tr, awk, sort`, etc..





##### Remplazar

```bash
# En el parrafo actual
:s/alfa/beta/g
# En el archivo entero
:%s/alfa/beta/g
```



##### Variables del editor

```bash
:set number    	# mostrar el número de línea al comienzo de la línea
:set nonumber 	# Desactiva la numeración de líneas. 
:set hlsearch   # resalta las palabras que coinciden
:set nohlsearch # Desactivar el modo de resaltado de ocurrencias. 
:set ai  		# establece auto-sangría
:set noai    	# desactiva auto-sangría
:colorscheme   	# se usa para cambiar el esquema de color para el editor.
:syntax on    	# activará la sintaxis de color para archivos .xml, .html, etc. 
```

<br>

##### Autocompletar

**Autocompletar ruta del sistema.**
En modo de inserción `CTRL + x CTRL + f` 
<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/vim/vim_path.png"/></center>

- Con `CTRL + n` y `CTRL + p` te desplazas por las opciones.

<br>

**Autocompletar línea del mismo archivo.**
En modo de inserción `CTRL + x CTRL + l`
<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/vim/vim_lineas.png"/></center>

<br>

**Autocompletar palabra del mismo archivo.**
En modo de inserción `CTRL + x CTRL + p`
<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/vim/vim_autocompletar.png"/></center>

<br>

**Diccionario** 
Para poder utilizar un diccionario de palabras deberemos indicar a Vim la ruta donde se encuentra el diccionario. En “/usr/shared/dicts” encontraréis diccionarios:

Si tenemos el archivo  `~/.vimrc` añadir la siguiente linea, en caso contrario crearlo.
*.vimrc*  
```bash
set dictionary+=/usr/share/dict/words
```

Ahora podremos utilizar el diccionario en vim con `CTRL + x CTRL + k` 
<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/vim/vim_diccionario.png"/></center>




