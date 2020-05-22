# vnc

vncserver@:1.service conectar al numero 1 de sesion grafica que representra el puerto 5900 +nº

copiar vncserver@.service por vncserver_user1@.service al arrancar con el systemctl pasar argumento 1, 2 el que sea.



## Instalar vnc cliente/servidor

```bash
 sudo dnf install -y tigervnc tigervnc-server
```



## Configuración servidor

Por cada usuario que queramos que se conecte, se tiene que copiar el demonio original y re-nombrarlo, en este caso para user1 (este usuario tiene que existir en el servidor). 

```bash
sudo cp  /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver_user1@.service
```



Modificar e unit renombrado, simplemente cambiar `<(USER)>` original por el usuario que conectara, en los comentarios del archivo lo explica.

```bash
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
WorkingDirectory=/home/user1
User=user1
Group=user1

PIDFile=/home/user1/.vnc/%H%i.pid

ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver -autokill %i
ExecStop=/usr/bin/vncserver -kill %i

Restart=on-success
RestartSec=15

[Install]
WantedBy=multi-user.target
```

Recargar dominios del sistema.

```bash
sudo systemctl daemon-reload
```



### Configurar usuario de servidor

El usuario a de tener una contraseña para la conexión vnc, y se la añade con `vncpasswd` 

```bash
su - user1
[user1@i09 ~]$ vncpasswd 
Password:
Verify:
Would you like to enter a view-only password (y/n)? y
Password:
Verify:
```

En el archivo `~/.vnc/xstartup` del usuario user1 se indica que ejecutar al iniciar una sesión con vnc.

```bash
[user1@i09 ~]$ cat .vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch startxfce4
#exec dbus-launch gnome-session
#exec dbus-launch cinnamon-session 

[user1@i09 ~]$ logout
```

> Escoger el escritorio que se quiera abrir, ha de estar instalado en el sistema.



### Encender servicio

Para iniciar servicio se a de pasar un argumento,  en este caso es el 1, que indica que iniciara sesión en `$DISPLAY 1:`

```bash
sudo systemctl start vncserver_user1@:1.service
```

> si en este paso no arranca el servicio correctamente, es muy posible no tener bien el archivo `~/.vnc/xstartup`



### Conexión

```bash
vncviewer localhost:1 &
```

