# Lanzador aplicaciones en gnome



A veces instalamos una aplicación y no nos inserta un enlace en el lanzador de gnome, pues esta es una solucion sencilla al problema.

Lo que hace es crear un archivo `*.descktop` en `/usr/share/applications` y así poder visualizar la aplicación en el escritorio.



```bash
sudo gnome-desktop-item-edit /usr/share/applications --create-new
```

- le indicamos que es una aplicacion

- imagen a mostrar

- nombre

- comando que queremos que ejecute

  ```bash
  /opt/firefox/firefox # por poner alguna aleatoria
  ```

  - Esta ejecutando el binario de firefox en este caso.

- y opcional un comentario.

![1534923153236](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/lanzador.png)



Y tienes el icono de escritorio.

![lanzador gnome](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/lanzador-gnome.png)