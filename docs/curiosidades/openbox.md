# Openbox  

Openbox es un escritorio muy ligero y útil en máquinas con pocos recursos. Recién instalado solo es un fondo de pantalla oscuro y un menú con click derecho, por lo tanto tedioso de utilizar y feo, por eso mismo con una configuración inicial se puede dejar decente.

Los paquetes de este documento son de Fedora 30  en otras distribuciones pueden cambiar  los nombres.



```bash
sudo dnf install openbox obconf obmenu lxappearance nitrogen xcompmgr lxrand tint2 xscreensaver volumeicon ulauncher xdotool
```

```bash
# descargar ultima versión y descomprimir
https://code.google.com/p/obkey/downloads/list
tar -zxvf obkey*

# mover a /opt y añadir binario a /usr/bin
mv obkey* /opt
rm obkey*tar.gz
ln -s /opt/obkey*/obkey /usr/bin

# indicar donde guardar cambios
obkey  /home/USUARIO/.config/openbox/rc.xml
```

Explicación de lo que se esta instalando:

- `obconf` Configuración openbox
- `obmenu` Edición menú openbox
- `tint2` panel
- ` lxappearance` Configuración tema 
- `    nitrogen` Fondo de escritorio
- `    xcompmgr` Permitir transparencias 
- `    lxrandr` Configuración monitores
- `    ulauncher`  Lanzador de aplicaciones interactivo (Dock)
  - Este dock es un poco pesado pero hay que decir que mola un monton, para opciones mas ligeras `wbar` 
- `    obkey `  Editor de atajos
- `    volumeicon` icono de volumen
- `    xscreensaver`  Bloqueo de pantalla
- `xdotool` ejecutar atajos de teclado desde terminal



Las configuraciones de atajos de teclado permitidas por openbox.

http://openbox.org/wiki/Help:Actions



Para empezar crearemos un archivo si no existe en `~/.config/openbox/autostart`  y añadimos las características a arrancar al iniciar sesión.

<u>*autostart*</u>

```bash
# permitir fondo de escritorio
nitrogen --restore&
# panel 
tint2&
# permitir transparencia y una pequña animación de abrir/cerrar ventana
xcompmgr -cCfF -t-3 -l-5 -r5 -D4&
# lanzador de aplicaciones molon
ulauncher&
# bloqueador de pantalla
xscreensaver&
```



Personalmente ir clicando el botón derecho para abrir el menú, me toca la moral. Por lo tanto creo una atajo de teclado y lo asigno a un botón del panel.

```xml
<keybind key="W-Escape">
    <action name="ShowMenu">
    	<menu>root-menu</menu>
    </action>
</keybind>
```

Abro configuración del panel con `tint2conf`  creo un botón que es muy intuitivo y en la casilla de ejecutar inserto `xdotool key super+Escape`.



Ahora solo queda configurar todo con un poco de paciencia y al gusto de cada uno, como resultado muestro mis archivos de configuración.

[Configuración personal](https://github.com/Jorgepastorr/apuntes/tree/master/linux/curiosidades/conf_openbox)