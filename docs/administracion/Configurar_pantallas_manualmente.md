# Configurar pantallas manualmente

En este post esplico como configurar manualmente de forma temporal con el comando `xrand` y  permanente con el archivo `xorg.conf`.



En un mundo perfecto conectas un dispositivo y descargas los controladores funciona correctamente al 100%, pero en la mitad de las ocasiones eso no es así.

En la realidad conectas dos pantallas, coge las resoluciones que le parece o detecta, y se lio a configurar posiciones y resoluciones manualmente.

En mi caso se jodio todo al no detectar todas la resoluciones del monitor con salida VGA y ademas no poder instalar el control center de AMD por incompativilidad de la version de Xserver.



Puesta en escena del entorno:

```bash
+--------------+      +---------------+
|  VGA         |      |  HDMI         |
|  Primer      |      |  segundo      |
|  monitor     |      |  monitor      |
| 1920x1080    |      |  1920x1080    |
+------------+-+       +-+------------+
     |----|  |          |   |----|
     +----+  |          |   +----+
             |          |
             |          |
   +-------+ |          |
   | +--+  | |          |
   |       | |          |
   | +--+  | |          |
   |       | |          |
   | PC    | |          |
   |       +-+          |
   |       +------------+
   +-------+
```



## Configuración temporal

xrandr es un comando muy potente en cuanto a personalización de pantallas y googlendo y biendo manuales es intuitivo de configurar con el.



En un inicio no me detectava la resolucion 1920x1080 en el VGA como se ve debajo.

```bash
➜  ~ xrandr
Screen 0: minimum 320 x 200, current 3840 x 1080, maximum 8192 x 8192
HDMI-0 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 160mm x 90mm
   1920x1080i    60.00 +  50.00    59.94* 
   1366x768      60.00 +
   1400x1050     59.98  
   1280x1024     60.02  
   1440x900      59.89  
   1280x960      60.00  
   1152x864      74.82  
   1280x768      59.87  
   1280x720      60.00    50.00    59.94  
   1024x768      75.03    70.07    60.00  
   800x600       72.19    75.00    60.32    56.25  
   720x576       50.00  
   720x576i      50.00  
   720x480       60.00    59.94  
   720x480i      60.00    59.94  
   640x480       75.00    60.00    59.94  
DVI-0 disconnected (normal left inverted right x axis y axis)
VGA-0 connected  1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1024x768      60.00  
   800x600       60.32    56.25  
   848x480       60.00  
   640x480       59.94   
```



**Así que empiezo a poner a mi gusto la configuración.** 

Miro ncon el comando `cvt` los parametros para añadir una resolucion 1920x1080 60Hz.

```bash
➜  ~ cvt 1920 1080 60
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```

Una vez tengo los parametros sigo con el lio.

```bash
# Creo una nueva resolución
xrandr  --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

# la añado a las opciones de la pantalla VGA
xrandr  --addmode VGA-0  1920x1080_60.00

# Pongo la resolucion en la pantalla VGA
xrandr  --output  VGA-0  --mode 1920x1080_60.00 

# Pongo la pantalla VGA primaria
xrandr  --output  VGA-0  --primary

# Pongo la pantalla  HDMI a 1920x1080 y ademas la coloco a la dereha de la VGA
xrandr  --output  HDMI-0  --mode 1920x1080i --right-of VGA-0
```



> Esto esta muy bien pero al reiniciar el ordenador se va todo a la mierda.



## Configuración permanente

Para configurar las pantallas de forma permanente nos tenemos que pelear con el tedioso archivo xorg.conf.

En el caso que el archivo no se encuentre en la ruta `/etc/X11/xorg.conf` tendremos que generarlo.

### Generar archivo xorg.conf

Tenemos apagar todo el modo gráfico para despues generarlo.

```bash
# volamos al modo headles
sudo init 3

# generamos archivo
sudo X -configure
```

- El siguiente comando genera el archivo de prueva en `/root/xorg.conf.new` 

----



He generado el archivo para tener una guia de la sintaxis y ver con que nombre identifica el pc a la targeta gráfica y su driver, todo lo demas lo e borrado como se ve en el ejemplo mas abajo.



**Genero los parametros para una resolución 1920x1080 60Hz.** 

```bash
➜  ~ cvt 1920 1080 60
Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
```



**Ejemplo archivo xorg.conf** . 

En la siguiente configuración:

- VGA
  - Creo una resolución 1920x1080 60Hz .
  - Pantalla por defecto Primaria.
- HDMI
  - modo resolucion 1920x1080.
  - coloco a la derecha de monitor VGA.



*/etc/X11/xorg.conf*

```bash
Section "Device"
	Identifier  "Card0"
	Driver      "radeon"
	BusID       "PCI:1:0:0"
	# añado un alias para tabajar mas claramente
	Option      "monitor-VGA-0" "lg"
	Option      "monitor-HDMI-0" "tv"
EndSection

Section "Monitor"
	Identifier   "lg"
	# creo añado resolucion para esta pantalla
	Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
EndSection

Section "Monitor"
	Identifier   "tv"
	# selecciono resolución existente para monitor tv
	Option  "PreferredMode" "1920x1080i"
	# coloco monitor a la derecha
	Option  "RightOf" "lg"
EndSection

# declaro monitor lg como primario
Section "Screen"
	Identifier "Default Screen"
	Monitor    "lg"
	DefaultDepth 24
	SubSection "Display"
		Depth     24
		Virtual  3840 1080
	EndSubSection
	Device     "Card0"
EndSection

# declaro monitor secundario
Section "Screen"
	Identifier "Screen1"
	Monitor    "tv"
	DefaultDepth 24
	SubSection "Display"
		Depth     24
		Virtual  3840 1080
	EndSubSection
	Device     "Card0"
EndSection
```



Una vez añadido los parametros toca colocar el archivo en su ruta, reiniciar y tener fe en que funcione.

- Es posible que a la primera no atines todos los parametros y tengas que hacer varias pruebas.



> Si pones algún parametro que no le gusta, es posible que no arranque el modo gráfico y no pases del login. Modifica de nuevo el archivo hasta que atines con la configuración adecuada.
>
> Cada vez que quieras probar una configuración toca reiniciar.

 
