# Tkinter 
Tkinter es una libreria de python para crear programas con interficies graficas.  

!> Los programas se crean en archivos `*.py`, al ejecutarse se abre una terminal más el programa. Para evitar eso lo guardare en `*.pyw`, así solo abrira el programa.

<br>

### Raiz
Es la ventana principal del programa.

```python
from tkinter import *

# creo la raiz
root = Tk()

# Titulo
root.title("Hola mundo")

# bucle mantiene la app ( siempre abajo del todo )
root.mainloop()
```
<br>

#### Resizable
Permite establecer los parametros de agrandar o enpequeñecer la ventna o simplemente dejarla fija.
```python
# Poder agrandar ventana (anchura, altura) 0 = false, 1 = true
root.resizable(1,1) # 1,1 movible. 0,0 fija
```
<br>

#### Iconbitmap
Añade un icono en la ventana
```python
root.iconbitmap('@hola.xbm')
```


Ejemplo configurando lo mas básico, la raiz con un titulo y ventana redimensionable.  
*tk.py*  
```python
from tkinter import *

# creo la raiz
root = Tk()

# Titulo
root.title("Hola mundo")

# Poder agrandar ventana (anchura, altura) 0 = false, 1 = true
root.resizable(1,1)

# bucle mantiene la app ( siempre abajo del todo )
root.mainloop()
```
Así se muestra de `tk.pyw`   

<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/raiz-tk.png"></center>

<br>

### Frame (Marco)  
Los frames son marcos contenedores de otros widgets. Pueden tener tamaño propio y posicionarse en distintos lugares de otro contenedor ( ya sea la raiz u otro marco ).


```python
from tkinter import *
root = Tk()

# Hijo de root, no ocurre nada
frame = Frame(root)  

# Empaqueta el frame en la raíz
frame.pack()      

# Como no tenemos ningún elemento dentro del frame, 
# no tiene tamaño y aparece ocupando lo mínimo posible, 0*0 px

# Color de fondo, background
frame.config(bg="lightblue")     

# Podemos establecer un tamaño,
# la raíz se adapta al frame que contiene
frame.config(width=480,height=320) 

root.mainloop()       
```
<br>

#### .Conf (Estilismo)
**config** añade distintas configuraciones al los frames o la raíz.
```python
.config(width=480,height=320) # Podemos establecer un tamaño
.config(cursor="")         # Tipo de cursor
.config(relief="sunken")   # relieve del frame hundido
.config(bd=25)             # tamaño del borde en píxeles
.config(bg="blue")          # color de fondo, background
.config(cursor="pirate")    # tipo de cursor (arrow defecto)
.config(relief="sunken")    # relieve del root 
.config(bd=25)              # tamaño del borde en píxeles
.config(font=("Consolas",24)) # tipo de letra
.config(fg='blue') # color de letra
.config(padx=10) # padding x
.config(pady=10) # padding y
```
<br>

#### .Pack (Posicionamiento)
Pack() enpaqueta los frames y los muestra en la ventana.  

```python
frame.pack(side="right")   # a la derecha al medio
frame.pack(anchor="se")    # sudeste, abajo a la derecha
frame.pack(fill="x")                # ancho como el padre
frame.pack(fill="y")                # alto como el padre
frame.pack(fill="both")             # ambas opciones
frame.pack(fill="both", expand=1)   # expandirse para ocupar el espacio
```

Ejemplo empacando frame en sud-este de la raiz.
```python
from tkinter import *

root = Tk()

# RAIZ
root.title("Hola mundo") # Titulo
# Poder agrandar ventana (anchura, altura) 0 = false, 1 = true
root.resizable(1,1)

# Frame ( Marco )
frame = Frame(root)

frame.pack(side='right', anchor='se') # pegado a la derecha y posición se
# lo mas abitual es utilizat (fill='both', expand=1) adaptarse a la ventana.

frame.config(width=280, height=120) # tamaño inicial
frame.config(bg="lightblue")    # fondo
frame.config(bd=10)             # borde
frame.config(relief="sunken")   # stilo de borde
frame.config(cursor="pirate")  # cambio de cursor

# bucle aplicación
root.mainloop()
```
<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/frame-se.png"></center>

<br>

### Label  

El widget Label se utiliza para mostrar textos, suelen ser estáticos de ahí su nombre.

```python
from tkinter import *
root = Tk()
frame = Frame(root)
frame.pack()

label = Label(frame,text="¡Hola Mundo!")
label.pack()

root.mainloop() 
```



Creando más etiquetas.

```python
from tkinter import *
root = Tk()
Label(root, text="¡Hola Mundo!").pack()
Label(root, text="¡Otra etiqueta!").pack()
Label(root, text="¡Última etiqueta!").pack()
root.mainloop() 
```

<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/label-testo.png"></center>

Posicionando etiquetas.

```python
Label(root, text="¡Hola Mundo!").pack(anchor='nw')
Label(root, text="¡Otra etiqueta!").pack(anchor='center')
Label(root, text="¡Última etiqueta!").pack(anchor='se')
Label(root, text="¡Hola mundo!").place(x=10, y=10) # x, y cordenadas
```

- **place**  posiciona por coordenadas respecto al padre.



<br>



#### Texto en variable  

```python
# # variable dinamica
texto = StringVar()
texto.set("un nuevo texto") # texto nuevo

label = Label(root, text="Linea inicial del texto")
label.pack(anchor="center")

# Cambio el texto a el label
label.config(textvariable=texto)
```

- Es un ejemplo un poco absurdo, pero quería remarcar que el texto se puede asignar a una variable.



<br>   

#### Imagen 

```python
# Añadir imagen
imagen = PhotoImage(file="hola.png") # acepta  .png y .gif
Label(root, image=imagen, bd=0).pack()
```

> Para trabajar con otro tipo de formato se a de trabajar con un módulo externo como PIL.



<br>   

### Entry 

Widget Entry (texto corto), son lo que en python un input() donde el usuario inserta un pequeño campo de texto.  

```python
from tkinter import *
root = Tk()

# Entrada de texto, un input
Entry(root).pack(side="right")

# label del campo de texto
Label(root, text="Nombre").pack(side="left")

root.mainloop()
```



En el caso anterior si añadiera otro campo de texto se mostraría en la misma línea, eso pasa porque pack() intenta alinear automáticamente, pero no hace milagros.

Para solucionarlo creo 2 frames ( marcos) en cada uno de ellos ira su campo de texto así se mostraran en 2 lineas

```python
# marco 1 linea 1
frame = Frame(root)
frame.pack()

# Entrada de texto, un input 1
entry = Entry(frame)
entry.pack(side="right")
# label del campo de texto 2
label1 = Label(frame, text="Nombre")
label1.pack(side="left")

# marco 2 linea 2
frame2 = Frame(root)
frame2.pack()

# Entrada de texto, un input 2
entry2 = Entry(frame2)
entry2.pack(side="right")
# label del campo de texto 2
label2 = Label(frame2, text="Apellido")
label2.pack(side="left")
```

- Aun así como nombre y apellidos no tienen los mismos caracteres no queda perfecto, utilizare `.grid()` para alinear como si fuera una tabla.

<br> 

#### .grid (tabla)  

Widget Grid simula una tabla para poder encuadrar, obviamente tiene configuraciones propias .

```python
.grid(row=0) 	# numero de fila
.grid(column=0)	# numero de columna
.grid(sticky='w')	# pegado e, s, w, o
.grid(state='disabled') # estado disable, normal
.grid(show='*') 	# muestra, para contraseñas
.grid(justify='center') #justifica el texto. center, left, right
```



Padding es un parámetro que esta en todos los widgets.

```python
.grid(padx=5) # pading  vertical
.grid(pady=5) # pading horizontal
```



Ejemplo de dos entradas bien alineadas con grid.

```python
from tkinter import *
root = Tk()

# label del campo de texto 1
label1 = Label(root, text="Nombre")
label1.grid(row=0, column=0, sticky="w", padx=5, pady=5)

# campo de texto 1
entry = Entry(root)
entry.grid(row=0, column=1, padx=5, pady=5)
# Puedo justificar el texto del input para que vempiece a escribir desde centro derecha o izquierda con justify
# O desabilitar el campo con state "disable" o "normal"
entry.config(justify="right", state="disable")

# label del campo de texto 2
label2 = Label(root, text="Contraseña")
label2.grid(row=1, column=0, sticky="w", padx=5, pady=5)

# campo de texto 2
entry2 = Entry(root)
entry2.grid(row=1, column=1, padx=5, pady=5)
# También puedo mostrar un caracter especial mientras escribes una contraseña
entry2.config(justify="center", show="*")

root.mainloop()
```



<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/entry.png"></center>

<br>  

### Text ( texto largo )

Se explica por si solo, un campo de texto donde puedes escribir tanto como te venga en gana.

```python
from tkinter import *
root = Tk()

texto = Text(root)
texto.pack()

root.mainloop()
```

Por defecto ocupa un espacio predefinido, pero puedes definir un tamaño concreto y alguna que otra configuración.

```python
texto.config(width=50, height=10) # tamaño en caracteres
texto.config(font=("Consolas", 12)) # fuente
texto.config(padx=10, pady=10)	# padding, para que el texto no este muy al borde
texto.config(selectbackground="orange")	# color de selección del texto
```



Ejemplo campo de texto.

```python
from tkinter import *
root = Tk()

# asigno Text a una variable  para poder configurar facilmente
texto = Text(root)
texto.pack()

texto.config(width=50, height=10)	# width=50 es igual a 50 caracteres de ancho, no pixeles
texto.config(font=("Consolas", 12))# Cambio fuente del campo
texto.config(padx=10, pady=10)	# le añado un pading
texto.config(selectbackground="orange")	# Cambio el color de selección del texto

root.mainloop()
```



<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/text.png"></center>



<br>

### Button

Un botón clicable que se le puede asignar una acción.  

```python
from tkinter import *

# Definimos una función a ejecutar al clic el botón
def hola():
    print("Hola mundo!")

root = Tk()

# Enlezamos la función a la acción del botón
Button(root, text="Clícame", command=hola).pack()

root.mainloop() 
```

- El concepto es muy simple, pero es algo muy útil en interficies gráficas.



El siguiente código es de una calculadora muy salchichera, como ejemplo es válido. 

```python
# calculadora cutre que suma, resta o multiplica 2 números
from tkinter import *

# funciones que hacen las operaciónes y asignan el resultado.
# Al recibir estrings los calculo cambiando la variable a float
def sumar():
    result.set( float(n1.get()) + float(n2.get()) )
    borrar()

def restar():
    result.set( float(n1.get()) - float(n2.get()) )
    borrar()

def multiplicar():
    result.set( float(n1.get()) * float(n2.get()) )
    borrar()

# funcion donde borro los strings de las barras
def borrar():
    n1.set("")
    n2.set("")

root = Tk()
# Añado borde al frame de root por mejorar apariencia
root.config(bd=15)

n1 = StringVar()
n2 = StringVar()
result = StringVar()

Label(root, text="Número 1").pack()
Entry(root, justify="center", textvariable=n1).pack() # entrada numero 1
Label(root, text="Número 2").pack()
Entry(root, justify="center", textvariable=n2).pack() # entrada numero 2
Label(root, text="Resultado").pack()
# Resultado desabilito la barra para que no nse pueda modificar
Entry(root, justify="center", textvariable=result, state="disabled").pack()

# Botones que ejecutan la funcion indicada
Label(root, text="").pack()
Button(root, text="Sumar", command=sumar ).pack(side="left")
Button(root, text="restar", command=restar ).pack(side="left")
Button(root, text="multiplicar", command=multiplicar ).pack(side="left")

root.mainloop()
```



<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/calculadora.png"></center>

<br>

  

### Radiobutton  

Otro componente básico de los formularios son los **botones radiales**. Se utilizan cuando quieres ofrecerle al usuario la posibilidad de elegir una opción entre varias:

En el siguiente ejemplo muestro un radiobutton de 3 opciones que modifican un label, mostrando la opción clicada y un botón de resetear opciones nulas.

```python
# Ventana de 3 radiobuttons donde muestro en un label el valor del button + un botton de reset del valor

from tkinter import *

def seleccionar():
    monitor.config( text="{}".format(opcion.get()) )

def reset():
    opcion.set(None)
    monitor.config( text="" )


root = Tk()
root.config(bd=10)

opcion = IntVar() 

# opciones de butons que modifican variable opcion y ejecutan la funcion seleccionar
# para mostrar valor en el monitor
Radiobutton(root, text="Opción 1", variable=opcion, value=1, command=seleccionar).pack()
Radiobutton(root, text="Opción 2", variable=opcion, value=2, command=seleccionar).pack()
Radiobutton(root, text="Opción 3", variable=opcion, value=3, command=seleccionar).pack()

# label de monitor donde muestro valor de radiobuton
monitor = Label(root)
monitor.pack()

Button(root, text="Reset", command=reset).pack()
root.mainloop()
```



<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/radiobuton.png"></center>

<br>  

### Checkbutton  

con radiobutton puedes marcar una entre varias opciones, con checkbutton se pueden marcar todas las opciones posibles que desees. 

En el siguiente ejemplo se ve dos opciones a añadir como quieres el café.

Checkbutton siempre tendrá 2 opciones `onvalue` el valor seleccionado y `offvalue` valor sin seleccionar. 

```python
from tkinter import *

root = Tk()
root.config(bd=15)

leche = IntVar()      # 1 si, 0 no
azucar = IntVar()    # 1 si, 0 no

Label(root,text="¿Cómo quieres el café?").pack()
Checkbutton(root, text="Con leche", variable=leche, 
            onvalue=1, offvalue=0).pack()
Checkbutton(root, text="Con azúcar",variable=leche, 
            onvalue=1, offvalue=0).pack()

root.mainloop()
```



En el siguiente ejemplo muestro como recoger las variables de checkbutton, desde una función donde se modificara un label para mostrar como quieres el café, ademas introduzco una imagen alineada a la izquierda.

```python
# ventana donde muestra una imagen con dos opciones tipo checkbutton que modifican el texto de un label

from tkinter import *

# funcion donde añade el texto a la label monitor
def seleccionar():
    cadena = ""
    if leche.get():
        cadena += "Con leche"
    else:
        cadena += "Sin leche"

    if azucar.get():
        cadena += " y con azúcar"
    else:
        cadena += " y sin azúcar"

    monitor.config( text=cadena )

root = Tk()
root.title("Cafetería")
root.config(bd=10)

leche = IntVar()    # 1 si, 0 no
azucar = IntVar()

# imagen de un cafecito muy gracioso alineado a la derecha
imagen = PhotoImage(file="imagen.gif")
Label(root, image=imagen).pack(side="left")

# Frame donde enpaqueto los radiobuttons y su texto modificable
frame = Frame(root)
frame.pack(side="left")

# Botton alineado a la izquierda, con su valor de variables asignados si estan seleccionados o no
# ademas ejecutan la función seleccionar
Label(frame, text="¿Cómo quieres el café?").pack(anchor="w")
Checkbutton(frame, text="Con leche", variable=leche, onvalue=1, offvalue=0, command= seleccionar ).pack(anchor="w")
Checkbutton(frame, text="Con azúcar", variable=azucar, onvalue=1, offvalue=0, command= seleccionar ).pack(anchor="w")

# Label donde muestro el texto que modifican los botones
monitor = Label(frame)
monitor.pack()

root.mainloop()
```



<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/checkbutton.png"></center>



<br>  

### Menús  

Menú en la barra superior de toda la vida.

```python
from tkinter import *

root = Tk()

menubar = Menu(root)
root.config(menu=menubar)  # Lo asigno a la base ( creo la barra )

# asigno menus iniciales
filemenu = Menu(menubar, tearoff=0)
editmenu = Menu(menubar, tearoff=0)
helpmenu = Menu(menubar, tearoff=0)

# los añado a la barra
menubar.add_cascade(label="Archivo", menu=filemenu)
menubar.add_cascade(label="Editar", menu=editmenu)
menubar.add_cascade(label="Ayuda", menu=helpmenu)

root.mainloop()
```

- Esto seria el menú más básico, lo malo es que no hacen nada de momento.

<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/menu.png"></center>





En el siguiente ejemplo añado submenus a cada menú, y a la opción salir le asigno un comando para cerrar el programa.

```python
from tkinter import *

root = Tk()

# barra de menu principal
menubar = Menu(root)
root.config(menu=menubar)

# Primeras opciones de menu
filemenu = Menu(menubar, tearoff=0)
# submenus del menu archivo
filemenu.add_command(label="Nuevo")
filemenu.add_command(label="Abrir")
filemenu.add_command(label="Guardar")
filemenu.add_command(label="Cerrar")
# barra separadora
filemenu.add_separator()
# anado un comando al submenu para salir
filemenu.add_command(label="Salir", command=root.quit)

# menu editar
editmenu = Menu(menubar, tearoff=0)
editmenu.add_command(label="Cortar")
editmenu.add_command(label="Copiar")
editmenu.add_command(label="Pegar")

# menu ayuda
helpmenu = Menu(menubar, tearoff=0)
helpmenu.add_command(label="Ayuda")
helpmenu.add_separator()
helpmenu.add_command(label="Acerca de....")

# añado los menus a la barra de menus
menubar.add_cascade(label="Archivo", menu=filemenu)
menubar.add_cascade(label="Editar", menu=editmenu)
menubar.add_cascade(label="Ayuda", menu=helpmenu)

root.mainloop()
```



<center><img src="https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/interficies-graficas/menu-desplegable.png"></center>



<br> 

### Progressbar  

```python
    # progressbar = ttk.Progressbar(actualizar, orient='horizontal', mode='indeterminate')
    # # progressbar.step(50)
    # progressbar.pack(fill='x')
```



### Subprocesos



```python
  process = subprocess.Popen( instalador.get() +" update", shell=True,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
       
        while True:
            out = process.stdout.readline()
            if out == '' or process.poll() is not None:  #if out == '' and process.poll() is not None:
                break
                
            print(out)
            a_texto.insert("end", out)
            a_texto.see("end")
            a_texto.update_idletasks()
```



### Scrollbar  



```python
   frame1 = Frame(condiciones)
    frame1.pack(anchor='center')

    scrollbar = Scrollbar(frame1)
    scrollbar.pack( side="right", fill="y" )

    c_texto = Text(frame1, yscrollcommand = scrollbar.set )
    for line in range(100):
        c_texto.insert(END, "This is line number " + str(line) + " \n")

    c_texto.pack()
    scrollbar.config( command = c_texto.yview )
    # por defecto scroll abajo
    #  c_texto.yview_moveto(1)
```

### Popups  

Popups vantanas de alertas, existen diferentes tipo de ventanas: iformacion, warning, error, la utilidad simple aceptar o denegar una acción. 

```python
from tkinter import *
from tkinter import messagebox as Messagebox

root = Tk()

def test():
    # Mensages simples de mostrar info, alertas, errores personalizable

    # Messagebox.showinfo("Titulo de ventana","Hola mundo")
    # Messagebox.showwarning("Alerta","Alerta solo administradores.")
    # Messagebox.showerror("Error!","Ha ocurrido un error")

    # Mensages para realizar una accion 
    
    # Opciones si y no
    # resultado = Messagebox.askquestion("Salir","¿Estas seguro de salir?")
    # if resultado == "yes": # "no"
    #     root.destroy()

    # Opciones si y no
    # resultado = Messagebox.askyesno("Salir","¿Estas seguro de salir?")
    # if resultado: # "True or False"
    #     root.destroy()

    # Opciones ACEPT cancel
    # resultado = Messagebox.askokcancel("Salir","¿Sobreescribir el fichero actual?")
    # if resultado: # "True or False"
    #     root.destroy()
    
    # Opciones retry cancel
    resultado = Messagebox.askretrycancel("Reintentar","No se a podido conectar")
    if resultado: # "True or False"
        root.destroy()

Button(root, text="Clicame", command=test).pack()

root.mainloop()   

```

#### Avanzados  

diferentes popups para seleccionar color, obtener ruta de archivo para abrir o guardar un archivo.

```python    
  
from tkinter import *
from tkinter import messagebox as Messagebox
from tkinter import colorchooser as Colorchooser
from tkinter import filedialog as Filedialog

root = Tk()

def test():

    # Colorchooser abre un popup donde puedes elejir un color en una tabla de colorchooser    
    # en terminal devuelve una tupla con el codigo en rgk y hexadewcimal
    # ((96.375, 161.62890625, 144.5625), '#60a190')

    # color = Colorchooser.askcolor(title="Elige un color")
    # print(color)


    # Filedialog.askopenfilename obtiene la ruta de un archivo mediante un popup
    # initialdir indica la ruta donde se abrira el popup ( cuidado segun el sistema operativo )
    # filetypes para filtrar entre diferentes ficheros

    # ruta = Filedialog.askopenfilename(title="Abrir un fichero", initialdir="/home",
    #     filetypes=(("Fichero de texto","*.txt"),
    #         ("Fichero de texto avanzado","*.odt"),
    #         ("Todos los ficheros","*.*")) )
    # print(ruta)


    # Filedialog.asksaveasfile guarda un archivo hay que jugar con el mode segun que quieras hacer

    fichero = Filedialog.asksaveasfile(title="Guardar un fichero", mode="w", defaultextension=".txt")
    if fichero is not None:
        fichero.write("Hola!")
        fichero.close()

Button(root, text="Clicame", command=test).pack()

root.mainloop()
  
```
