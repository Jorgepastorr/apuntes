# sudo

<https://fedoraproject.org/wiki/Configuring_Sudo>

<http://www.mjmwired.net/resources/mjm-fedora-f19.html#sudo>



Sudo nos permite acceder a comandos de root, es perfecto para usuario administrador.



#### sudo con periodo de gracia

Añadiendo la siguiente linea al archivo /etc/sudoers permitira hacer sudo y pedira la contraseña de usuario, no de  ( root ) .

Puedes editar con gedit, nano, vim, etc.. o añadirla con un echo.

```bash
echo 'username ALL=(ALL) ALL' >> /etc/sudoers
```

- cambiar username por ombre de usuario.

Tiene un periodo de gracia hasta que vuelve a pedir la contraseña.



#### sudo permisivo

En ocasiones no quieres que sudo pida contraseña, como por ejemplo entorno de prueba, en casa, etc..

```bash
echo 'username ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
```



####  sudo estricto

Hay casos que quieres que sudo sea mas estrito y pida la contraseña cada vez que se ejecuta, en ese caso tenemos que modificar ***/etc/sudoers*** de la siguiente manera.

Reducir periodo de gracia a 0

```bash
echo 'username ALL=(ALL) ALL' >> /etc/sudoers
echo 'Defaults:ALL timestamp_timeout=0' >> /etc/sudoers
```





#### Añadir usuario a wheel

La manera mas correcta de permitir a un usuario ser administrador del sistema es añadirlo al grupo wheel. 

Y despues reiniciar.

```bash
usermod username -a -G wheel
# o también
gpasswd -a username wheel
```



#### Wheel permisivo

Quitar comentario “#” a la línia            

***/etc/sudoers***

```bash
---
%wheel    ALL=(ALL)    NOPASSWD: ALL      
# Añadir “#” a la línia:            
%wheel    ALL=(ALL)    ALL: ALL
---
```

#### Wheel normal

***/etc/sudoers***

```bash
---
%wheel    ALL=(ALL)    ALL: ALL
---
```

