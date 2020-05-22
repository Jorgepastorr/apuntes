# Cambiar color promp terminal    



Insertar las 2 líneas siguientes al final del archivo .bashrc de tu carpeta personal, escoger el número de color que nos gusta y modificar el número en negrita, en mi caso he escogido el 36 cain.

modificar archivo ***.bashrc*** en carpeta personal

```bash
# User specific aliases and functions
PS1='\[\e[;36m\][\u@\h \W]\$\[\e[0m\]'
export PS1
```

[;30\]hola color[0m\] -- negro<br>
<span style="color:#4b8cba;">[;34\]hola color[0m\] -- azul</span><br>
<span style="color:#729533;">[;32\]hola color[0m\] -- verde</span><br>
<span style="color:#4d9994;">[;36\]hola color[0m\] -- chain</span><br>
<span style="color:#c05350;">[;31\]hola color[0m\] -- rojo</span><br>
<span style="color:#ba5586;">[;35\]hola color[0m\] -- lila</span><br>
[;37\]hola color[0m\] → blanco




![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/tabla-colores-prompt.png)
