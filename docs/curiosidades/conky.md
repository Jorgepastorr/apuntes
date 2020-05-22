# conky

Conky es un gadget de escritorio donde podemos monitorizar diferentes aspectos de nuestro sistema, con el tenemos una vision rapida del rendimiento del equipo.

Este es el conky de ejemplo:

![ejemplo](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/screen-conky.png)

> El fondo es transparente pero mi tema de escritorio es oscuro, por eso se ve negro.



###### Requisitos para este script:

```bash
# sensores de temperatura y descarga de datos http
sudo apt install -y lm-sensors hddtemp curl
# comando velocidad de descarga y subida parecido a "adsltest"
sudo apt-get install python-pip
sudo pip install speedtest-cli
```



###### Instalar conky

```bash
sudo apt intall conky conky-all
```



Una vez instalado podemos ver que funciona con.

```bash
# activar 
conky -d
# matar 
pkill conky
```

- Veremos un script horrible en la izquierda superior del escritorio



###### Script personalizado de conky

[Manual configuración oficial](http://conky.sourceforge.net/config_settings.html)

Para usar nuestra confiuración personal la mejor opción es crear un archivo en la siguiente direccion:

`~/.conky/test/conkyrc` 

- `.conky` es obligatorio en nla carpeta personal y oculta.
- `test` puede ser el nombre que quieras es solo por organización.
- `conkyrc` es el archivo donde editaremos conky

****

***conkyrc*** 

```bash
# configuracion posicionamiento, fondo y tal
background no
font Snap.se:size=8
xftfont Snap.se:size=8
use_xft yes
xftalpha 0.1
update_interval 3.0
total_run_times 0
own_window yes
own_window_type normal
own_window_transparent yes
own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager
double_buffer yes
draw_shades no
draw_outline no
draw_borders no
draw_graph_borders no
minimum_size 250 6
maximum_width 400
default_color d9d9d9
#default_shade_color 000000
#default_outline_color 000000
#alignment tr
gap_x 1650
gap_y 250
no_buffers yes
cpu_avg_samples 2
override_utf8_locale no
uppercase no # set to yes if you want all text to be in uppercase
use_spacer no
own_window_argb_visual yes 
border_outer_margin 10


TEXT
#Aqui empieza la configuracion de los datos que se muestran
#El primero es el nombre del sistema operativo y la version del kernel
${font Ubuntu:style=bold:size=14}${execi 3600 lsb_release -d | cut -c14-34} 
version $alignr $kernel

#Esto nos muestra los cuatro procesadores y una barra de cada uno de ellos con su uso
${color 1889ca}${font Ubuntu:style=bold:size=14}Procesadores $hr ${color d9d9d9}
${font Arial:size=11}CPU1: ${cpu cpu1}% ${cpubar cpu1}
CPU2: ${cpu cpu2}% ${cpubar cpu2}
CPU3: ${cpu cpu3}% ${cpubar cpu3}
CPU4: ${cpu cpu4}% ${cpubar cpu4}

#Esto nos muestra la temperatura de los procesadores
${color 1889ca}${font Ubuntu:style=bold:size=14}Temperatura:$hr ${color d9d9d9}
${font Arial:size=11}Equipo $alignr ${execi 1 sensors | grep temp1 | cut -c15-17;}C
CPU1 ${alignr}${execi 1 sensors | grep Core\ 0 | cut -c15-17;}C
CPU2 ${alignr}${execi 1 sensors | grep Core\ 1 | cut -c15-17;}C
CPU3 ${alignr}${execi 1 sensors | grep Core\ 2 | cut -c15-17;}C
CPU4 ${alignr}${execi 1 sensors | grep Core\ 3 | cut -c15-17;}C

#Esto nos muestra la particion Home, la RAM y la sawp con una barra cada una y sus datos
${color 1889ca}${font Ubuntu:style=bold:size=14}Memoria y discos $hr ${color d9d9d9}
${font Arial:size=11}HOME $alignr ${fs_used /home} / ${fs_size /home}
${fs_bar /home}
${font Arial:size=11}RAM $alignr $mem / $memmax  
${membar} 
${font Arial:size=11}SWAP $alignr $swap / $swapmax 
$swapbar

#Esto nos muestra las ip local y publica
${color 1889ca}${font Ubuntu:style=bold:size=14}Redes $hr ${color d9d9d9}
${font Arial:size=11}Ip local	${alignr} ${execi 300 ip a | grep  inet | grep  brd | cut -c10-25 | head -1}
${font Arial:size=11}Ip publica	${alignr} ${execi 300 GET http://www.vermiip.es/  | grep "Tu IP p&uacute;blica es" | cut -d ':' -f2 | cut -d '<' -f1}

#Esto nos muestra la velocidad de descarga 
${font Arial:size=11}V red Descarga $alignr ${execi 300 speedtest-cli | grep Download | cut -c10-15;}Mb/s 
# cada if muestra los bits que descarga al momento cada red
${if_up wlxb8a38692198f}
${font Arial:size=11}Intensidad WIFI $alignr ${wireless_link_qual wlxb8a38692198f}%
${font Arial:size=11}Descarga wifi $alignr ${downspeed wlxb8a38692198f}/s 
${endif}
${if_up enp3s0}${font Arial:size=11}Descarga cable $alignr ${downspeed enp3s0}/s 
${endif}
#Esto muestra el uso de la CPU de las aplicaciones que mas hacen uso de ella
${color 1889ca}${font Ubuntu:style=bold:size=14}Uso CPU aplicaciones $hr ${color d9d9d9}
${font Arial:size=11}${top name 1}$alignr${top cpu 1}%
${top name 2}$alignr${top cpu 2}%
${top name 3}$alignr${top cpu 3}%

#Esto nos muestra el procentaje de RAM que usan las aplicaciones de ella
${color 1889ca}${font Ubuntu:style=bold:size=14}Uso RAM aplicaciones $hr ${color d9d9d9}
${font Arial:size=11}${top_mem name 1}$alignr${top_mem mem 1}%
${top_mem name 2}$alignr${top_mem mem 2}%
${top_mem name 3}$alignr${top_mem mem 3}%

```

> **Nota:**  Para que funcione correctamente el apartado de redes se tiene que indicar el nombre red

  

###### Lanzamos nuestro conky con:

```bash
conky -c /home/debian/.conky/test/conkyrc
```

- En el caso de querer lanzar varios conkys 

  ```bash
  conky -q -c /home/debian/.conky/test/conkyrc
  conky -q -c /home/debian/.conky/test/conkyrc1
  ```



###### Lanzar conky al inicio de sesión

Hay diferentes maneras de lanzar conky al inicio de sesión, usando cron, localrc, o como aplicación de inicio, que al parecer es lo que prefiere la gente.



**Iremos al metodo popular.**

Como estamos usando gnome, este comando abrira una ventana para crear una aplicación en `~/.config/autostart/` que es la ruta de autoarranque al iniciar la sesión.

```bash
gnome-desktop-item-edit ~/.config/autostart/ --create-new
```

- le indicamos que es una aplicacion

- nombre

- comando que queremos que ejecute

  ```bash
  sh -c "conky -c /home/debian/.conky/test/conkyrc;"
  ```

- y si queremos un comentario.

![1534923153236](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/lanzador.png)



###### Resultado final

![escritorio final](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/Captura%20de%20pantalla%20de%202018-08-22%2009-37-14.png)