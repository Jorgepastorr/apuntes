# Tmux

## Esteroides para tu terminal

Hoy, quiero presentaros a **tmux, un programa que dotará de funciones extra a cualquier emulador de terminal que estemos usando**.
Estas funciones incluyen entre otras, pestañas, paneles, poder administrar diferentes sesiones en una misma ventana, trabajo cooperativo vía SSH… Vamos, que **es como darle superpoderes** a nuestra amiguita.

- [link pagína donde se extrajo la info](http://www.sromero.org/wiki/linux/aplicaciones/tmux)

- [manual tmux](http://man.openbsd.org/OpenBSD-current/man1/tmux.1)



Explicare los atajos más usados, pero sin duda el más importante es el siguiente, la ayuda.

##### Menu ayuda

```bash
ctrl + ?	# muestra todos los atajos disponibles
```



##### Abrir sesion en tmux

```bash
tmux					# nombre aleatorio
tmux new -s mysesion	# nombre específico
```



##### Dividir pantalla

```bash
ctrl + b %	# panel vertical
ctrl + b "	# panel horizontal
```

##### Moverse entre divisiones

```bash
ctrl + b # flecha de dirección
```

##### Nueva ventana

```bash
ctrl + b c
```

##### Navegar entre ventanas

```bash
ctrl + b n	# adelante
ctrl + b p	# atras
```

##### Dar nombre a ventana

```bash
ctrl + b ,
```



##### Redimensionar ventana

```bash
ctrl + b Esc + direccion de flecha
```
Lo malo que solo mueve 10 espacios por ejecución, por lo tanto creo un nuevo atajo.

```bash  
vim ~/tmux.conf

bind-key -r S-Up    resize-pane -U 10
bind-key -r S-Down  resize-pane -D 10
bind-key -r S-Left  resize-pane -L 10
bind-key -r S-Right resize-pane -R 10
``` 
- `-r` permite repetir la ejecución de la tecla.
ahora con `ctrl + b  shift + {left,right,up,down}` podremos redimensionar al gusto.  


##### Zoom de una ventana

```bash
ctrl + b z	# añadir zoom, pone pantalla completa
ctrl + b z	# por segunda vez, quitar zoom
```



##### Cerrar ventana 

```bash
ctrl + b &
ctrl + b x	# cerrar división o ventana si no hay divisiones
```



##### Tarea en 2º plano

Muy útil cuando ejecutas un comando que tarda mucho.

```bash
ctrl + b d
```



##### Ver listas de sesiones activas

```bash
tmux ls
```

##### Volver a la sesión 

```bash
tmux a
# en el caso de que ayan varias sesiones activas
tmux a -t nombre 
```

#####  Elegir sesión si tenemos abierta más de una. 

```bash
Ctrl + b s
```



##### Cerrar sesion 

```bash
ctrl + b & # en todas las ventanas
tmux kill-session -t mysesión # matar sesión
```

##### Copiar y pegar

En tmux se puede copiar y pegar como en todas las terminales `ctrl + Mayus + c|v`, o en caso de no utilizar entorno gráfico dispone de su propio Copy&Paste muy parecido a vim.

- Entrar "copy mode" presionando `CTRL + b, [`.
- Utilizar las flechas para mover el cursor por la pantalla. Presiona `CTRL + SPACE` para empezar a copiar.
- Usa las flexas para moverte al final det texto que quieres copiar. Presiona `ALT + w` o `CTRL + w` para copiar.
- Presiona `CTRL + b, ]` para copiar, incluso en otras ventanas Tmux abiertas en esa misma sessión.


## Compartir sesión

*Partimos de 2 hosts, host "uno" y host "dos", el host dos ara de server con la ip 10.0.0.2.*

Fingiremos que hay alguien trabajando en el server e invita a otro a ver su trabajo, o pide ayuda, da lo mismo.



###### Server, host dos.

inicia tmux con una sesion llamada compartida

```bash
tmux new -s compartida
```



 ###### Host "uno" 

conecta con server

```bash
tmux					# inicia sesion de tmux
ssh server@10.0.0.2		# se conecta via ssh al server
tmux ls					# lista sesiones abiertas
tmux a -t compartida	# se conecta a la sesión compartida
```

