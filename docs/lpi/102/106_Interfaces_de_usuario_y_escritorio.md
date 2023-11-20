# 106 Interfaces de usuario y escritorio



## Componentes

![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Schema_of_the_layers_of_the_graphical_user_interface.svg/1024px-Schema_of_the_layers_of_the_graphical_user_interface.svg.png)



**Servidor de pantalla** (display server)  facilita las operaciones para que se activen los pixeles en pantalla y establece la comunicación con el resto  de componentes, servidor mas utilizado `X.org`

**protocolo de comunicación** entre el servidor de pantalla y la interfaz gráfica se comunica de manera cliente servidor donde la interfaz gráfica puede ser en local o remoto. Los protocolos suelen ser **X11** o **wayland**

**Interfaz gráfica** es el escritorio que escogemos para trabajar graficamente.

**Gestor de ventanas** (windows manager)  facilita algunos estilos para las ventanas como bordes, botones, etc...

**Gestor de pantalla** (display manager) es la pantalla de autenticación de usuarios e iniciar el entorno  gráfico, muy utilizados `dgm, lightdm` .



Cada instancia de un servidor X en ejecución tiene un *nombre de visualización* para identificarlo. El nombre para mostrar contiene lo siguiente:

```bash
hostname:displaynumber.screennumber
```

`hostname` indica el nombre del sistema que se mostrará la aplicación. Si no se muestra se asume el host local.

`displaynumber` referencia a la colección de pantallas que están en uso. A cada sessión del servidor X se le asigna un número empezando por `0`

`screennumber` cada pantalla independiente tendrá su propio número asignado. Si solo hay una pantalla lógica en uso se omite el punto y el número de pantalla.

El nombre de la sesión se almacena en la variable `DISPLAY`

```bash
➜ echo $DISPLAY
:0
```

Un solo monitor, con una sola pantalla se muestra como `:0` 

Dos monitores agrupados como una sola pantalla se mostrará `:0`

Dos monitores con cada pantalla independiente se mostrará el primer monitor como `:0.0` y el segundo como `:0.1` 

Para iniciar un programa en una pantalla especifica se puede utilizar la variable `DISPLAY` o las opciones `--screen` y `--display` de `gtk-options`  

```bash
$ DISPLAY=:0.1 firefox &
```



## Instalar y configurar

### Instalación

desde los repositorios en la instalación

debian 

```bash
tasksel --list-task
tasksel install gnome-desktop
apt install xserver-xorg gnome-session
```



redhad

```bash
yum grouplist
yum groupinstall general-desktop
```



### Configuración

Los archivos de configuración  de X11 son  `/etc/X11/xorg.conf`,  `/etc/X11/xorg.cong.d/` y los proporcionados por la distribución `/usr/share/X11/xorg.conf.d/`.

Los archivos de  `/etc/X11/xorg.cong.d/` se analizan antes que `/etc/X11/xorg.conf` si existe.

Las versiones actuales de X.org detectan automáticamente el hardware disponible y no se crea el archivo de configuración `/etc/X11/xorg.conf`.

Para generar el archivo de configuración se utiliza `Xorg -configure` sin estar utilizando el entorno gráfico. Esto genera un archivo en el directorio actual que despues se a de colocar en el lugar correspondiente.



**secciones del fichero** de configuración `xorg.conf`

`inputDevice`  Se utiliza para configurar un modelo especifico de teclado o mouse. identificador, driver y opciones

`InputClass` Se utiliza para configurar una *clase* de dispositivos de hardware, por ejemplo un teclado con un modelo especifico ( opciones `xkeyboard-config(7)`)

```bash
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us"
        Option "XkbModel" "pc105"
EndSection
```

También se puede configurar una classe de dispositivo lanzando:

```bash
setxkbmap -model pc105 -layout "us"	# temporalmente

# permanente, genera 00-keyboard.conf en /etc/X11/xorg.conf.d/
localectl --no-convert set-x11-keymap "us" pc105 
```

`Monior` describe el monitor físico que se utiliza y dónde está conectado

`Device`  describe la tarjeta de video física que se utiliza. La sección también contendrá el módulo del kernel utilizado como  controlador para la tarjeta de video, junto con su ubicación física en  la placa base.

```bash
Section "Device"
        Identifier  "Device0"
        Driver      "i915"
        BusID       "PCI:0:2:0"
EndSection
```

`Screen`  une las secciones `Monitor`y `Device`. Una `Screen`sección de ejemplo podría verse como la siguiente

```bash
Section "Screen"
        Identifier "Screen0"
        Device     "Device0"
        Monitor    "DP2"
EndSection
```

`ServerLayout` configuración del diseño general, agrupa todas las secciones, como el mouse, el teclado y las pantallas, en una interfaz del sistema X Window.

`Files`  nombres de ruta de archivos necesarios modulos y fuentes

`Module` carga dinamica de modulos

`outputClass`  descripción de la clase de salida





### Herramientas

Sobre información:

//`xdpyinfo` muestra información sobre un servidor X. se utiliza para examinar las capacidades de un servidor, los valores predefinidos, parámetros utilizados en la comunicación entre cliente servidor, y los diferentes tipos de pantalla y elementos visuales disponibles.

`xwininfo` muestra información sobre ventanas, identificando la ventana por `-id` , `-name` o seleccionando con el raton la ventana.

`~/.xsession-errors`  fichero de registro de logs del servidor X.



Sobre manejo:

`xhost` Permite establecer los equipos que podrán acceder de forma remota al servidor gráfico.

```bash
xhost +	# permitir conexiones a todos
xhost - # denegar conexiones a todos (por defecto)
xhost +hostname	# permitir conexion a hostname o ip indicado
```

`xauth` determina qué usuarios pueden lanzar aplicaciónes sobre el servidor gráfico.

`$DISPLAY` Variabl de entorno que indica al programa cliente a que  lugar dirigir la comunicación.

```bash
Sintaxis:  hostname:D.S
hostname	# nombre o ip del ordenador destino
D	# número que indica el Display (monitor)
S	# número de pantalla Screen
```





## Escritorios gráficos

Los más populares:

**KDE** escrito ec `C++` y usa QT para la programación de librerías gráficas, utiliza OpenGl para la eceleración de hardware. Versión actual Plasma 5. [KDE](https://kde.org)

**GNOME** escrito en `C` y usa `GTK+` para la programación de librerías gráficas. Versión actual Gnome 3. [Gnome](https://www.gnome.org)

**XFCE**   escrito en `C` y usa `GTK+` para la programación de librerías gráficas. Es un entorno muy ligero para ordenadores de pocos recursos [XFCE](https://www.xfce.org)



Los entonos gráficos se pueden instalar en la instalación y/o desde los grupos de repositorios tanto  Debian con `tesksel` como Redhad `groupinstall`.

Siempre que se tengan varios entorno de escritorio instalados, se puede indicar la opción por defecto en:

```bash
# cambiar entorno grafico por defecto
➜  update-alternatives --config x-session-manager
```



**gestor de sessiones** es la pantalla que muetra el entorno gráfico al iniciar sessión, comunmente utilizados gdm3, ligthdm, ssdm.

```bash
# cambiar de gestor gdm3 a otro instalado
dpkg-reconfigure gdm3
```



La organización *freedesktop.org* mantiene una gran cantidad de especificaciones para la interoperabilidad de escritorio . La adopción de la especificación completa no es obligatoria, pero muchas de ellas se utilizan ampliamente:

- Ubicación de directorios: Donde se encuentran, la configuración personal y otros archivos especificos de usuario
- Entradas de escritorio:  Las aplicaciones de escritorio tendrán un archivo de texto con extensión `.desktop` para lanzarse
- Inicio automático de la aplicación:  Entrada de escritorio que indica que aplicación debe iniciarse al iniciar sesión un usuario
- Arrastrar y soltar:  Cómo deben manejar las aplicaciones los eventos de arrastrar y soltar.
- Cubo de basura: La ubicación común de los archivos eliminados por el administrador de  archivos, así como los métodos para almacenar y eliminar archivos desde  allí.
- Temas de iconos: El formato común para bibliotecas de iconos intercambiables.



**XDMCP** ( X Display Manager Control Protocol ) Es el protocolo utilizado entre el servidor y el Display Manager ( gestor de sessiones)

**VNC** Es una manera de conectar un cliente y un servidor para poder ver en remoto el escritorio de otra máquina.

**Spice** Es un protocolo pensado para conectar de manera remota con escritorios de máquinas virtuales

**RDP** Es el protocolo de comunicación que utilizan los entornos windows  para acceder al escritorio de forma remota



### Escritorio remoto simple

Esta opción es muy simple y solo habilita sesiones remotas al usuario que lo configura.

server 

```bash
sudo apt install vnc4server

vim ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &

sudo vncserver -localhost no -geometry 1024x768 -depth 24
```



cliente 

```bash
sudo apt install vinagre
```

En el programa indicar la dirección IP o el dominio de la máquina del server junto al puerto `5900` 



## Accesibilidad

Los diferentes escritorios propocionan ayudas en caso de padecer una discapacidad o dificultad física.

- **Alto contraste**: Un contraste alto para distinguir los colores facilmente

- **Lector de pantalla**: En caso de discapacidad visual `Orca, Emacspeak` proporcionan leectur de los diferentes componentes de la pantalla

- **Pantalla braile**: Proporciona la lectura de la pantalla mediante un teclado en blaile con `BRLTTY`

- **Lupa de pantalla**: Proporciona una lupa que se vva moviendo junto al ratón
- **Teclado en pantalla**: Muestra un teclado en la pantalla  que se accionará con el raton
- **Teclas pegajosas  de repetición**: Una tecla se mantendra presionada hasta que se accione la sigiente, util para hacer `ctrl + alt + supr` con un solo dedo.
- **teclas lentas de rebote de conmutación**: limita la repetición de teclas, para personas que tiemblan y presiona teclas repetidas veces sin querer
- **Teclas de raton**: se asigna los botones vdel raton a diferentes teclas en el teclado
- **Gestos**: reconoce gestos con el raton para hacer una acción
- **Reconocimiento de voz**: escritura por voz, etc...



