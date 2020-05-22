# Remark  

[**Ejemplo diapositiva con remark**](http://docs.jorgepastorr.tk:50022/remark/index.html)  



Diapositivas echas en markdown, rapido y facil.

https://remarkjs.com  
https://github.com/gnab/remark  
https://github.com/gnab/remark/wiki/Formatting     

---

<br>  

## Introducción  

En las siguientes diapositivas muestro algunos ejemplos de sintaxis.
- Remark es sorprendentemente fácil de usar.
- Puedes insertar estilos mediante html, css y js.
- Utiliza el lenguaje de marcado ligero **Markdown**.

---

<br>  

## Iniciar diapositivas.

https://github.com/gnab/remark  
Lo único que tenemos que hacer para empezar a crear diapositivas es copiar el código html del [readme.md](https://github.com/gnab/remark) del proyecto y empezar a escribir markdown en el mismo archivo entre el elemento `textarea`.  

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Title</title>
    <meta charset="utf-8">
    <style>
      @import url(https://fonts.googleapis.com/css?family=Yanone+Kaffeesatz);
      @import url(https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic);
      @import url(https://fonts.googleapis.com/css?family=Ubuntu+Mono:400,700,400italic);

      body { font-family: 'Droid Serif'; }
      h1, h2, h3 {
        font-family: 'Yanone Kaffeesatz';
        font-weight: normal;
      }
      .remark-code, .remark-inline-code { font-family: 'Ubuntu Mono'; }
    </style>
  </head>
  <body>
    <textarea id="source">

class: center, middle

# Title

---

# Agenda

1. Introduction
2. Deep-dive
3. ...

---

# Introduction

    </textarea>
    <script src="https://remarkjs.com/downloads/remark-latest.min.js">
    </script>
    <script>
      var slideshow = remark.create();
    </script>
  </body>
</html>
```



O aun mejor la opción que me gusta más, modificar la siguiente línea del código html y escribir en un archivo markdown a parte.

```javascript
var slideshow = remark.create({
  sourceUrl: 'markdown.md'
  });
```
- De esta manera queda todo mas limpio y ordenado.  

   

### configuración index.html

A parte hay alguna que otra configuración mas como:

- ratio de visión  4:3  o 19:9.

- modo de navegación entre diapositivas, permitir clics, scroll y touch que no se que es.

- formatear el listado de diapositivas, o quitarlo.

  ```html
  <script>
        var slideshow = remark.create({
          sourceUrl: 'markdown.md',
          // Set the slideshow display ratio
          // Default: '4:3'
          // Alternatives: '16:9', ...
          ratio: '4:3',
  
          // Navigation options
          navigation: {
            // Enable or disable navigating using scroll
            // Default: true
            // Alternatives: false
            scroll: true,
  
            // Enable or disable navigation using touch
            // Default: true
            // Alternatives: false
            touch: true,
  
            // Enable or disable navigation using click
            // Default: false
            // Alternatives: true
            click: false
          },
  
          // Customize slide number label, either using a format string..
          slideNumberFormat: 'Slide %current% of %total%',
          // .. or by using a format function
          //slideNumberFormat: function (current, total) {
          //  return 'Slide ' + current + ' of ' + total;
          // },
  
          // Enable or disable counting of incremental slides in the slide counting
          countIncrementalSlides: false,
          // Estilo en las cuadros de codigo
          highlightStyle: 'default'
        });
  </script>
  ```

  - Hay alguna que otra más mirar en el enlace de la wiki si interesa.



---
<br>  

## Css  

Por defecto trae configurado algunas clases css como el alineamiento.

- Texto alineado a  la derecha con `.right[texto]`

- Texto alineado a la izquierda con `.left[texto]`

- texto centrado con  `.center[texto]`] 
- texto en medio de la diapositiva`class: center, middle`
- colores `.red[texto]`

<br>  

Y alguna que otra más.

- siempre puedes asignar tu propio css en el archivo html y llamarlo desde markdown.  

---


## Imágenes

1. insertar imágenes de background.
    ```remark
    background-image: url(https://ruta/Super-Mario-Film.jpg)  
    ```
1. imágenes normales usamos markdown.
    ```remark
    ![descripcion](image.png)
    ```

---
<br>  

## Vídeos 

<iframe width="460" height="215" src="https://www.youtube.com/embed/5eLcHJLDlI8" frameborder="0" allow="encrypted-media" allowfullscreen></iframe>

con un iframe de toda la vida:  
```html
<iframe width="560" height="315" src="https://www.youtube.com/embed/5eLcHJLDlI8" frameborder="0" allow="encrypted-media" allowfullscreen></iframe>
```
o como en markdown:
```html
<video width="560" height="420" controls>
  <source src="{{ site.baseurl }}/assets/video_example.mp4" type="video/mp4">
</video>
```

Esta parte es igual que en markdown vamos.



<br>  

## Herencia de diapositiva  

No tenemos que repetir dos diapositivas si usas el mismo contenido sucesivamente, con `--` de separador entre diapositivas se clona la anterior.  

```remark  
# Herencia de slide  

- bullet 1
--

- bullet 2
```

---
<br>  

## Soy una plantilla   

La plantilla es similar a `--` con la diferencia que no tienen que ser las diapositivas sucesivas.  
- Se le asigna un `name` a la plantilla y luego se le llama con `template:`  

---


***Sintaxis***

```remark  
name: plantilla

# Soy una plantilla   
  
---
template: plantilla

e cogido la plantilla y e agregado texto.
```
---
<br>  

## Mas herencias.  
Pues se ve que les gusta esto de heredar o clonar, como quieras llamarlo.
- con `layout: true` inicias la herencia y hasta que le indicas `false` crea subsecciones.



***Sintaxis***    

```remark
---
layout: true

# Mas herencias.  
Pues se ve que les gusta esto de heredar o clonar, como quieras llamarlo.
- con `layout: true` inicias la herencia y hasta que le indicas `false` crea subsecciones.
---

## Sub section 1
  - Pues no se que poner

---

## Sub section 2
  - Me e quedado sin ideas

---
layout: false
```

- En este caso la diferencia es que las sub-secciones se remplazan.

<br>  

## Redireccionamiento  

En la slide inicial se le a asignado `name: inicio` y el enlace anterior es un simple link `[el inicio](#inicio)`  
```remark
name: inicio

# Title remark  
---

....
Contenido varias diapositivas
....

---

# Redireccionamiento  

[el inicio](#inicio)  
```

---
<br>   

## Columnas

Pues jugando un poco con css puedes hacer muchas cosas, como columnas etc..  

**css en el archivo html**  

  ```css
  .left-column {
        color: #777;
        width: 20%;
        height: 92%;
        float: left;
  }
  .left-column h2:last-of-type, .left-column h3:last-child {
    color: #000;
  }
  .right-column {
    width: 75%;
    float: right;
    padding-top: 1em;
  }
  ```
- Y te quedan 2 columnas de 20% y 75% que resulta muy curioso.  

**código en markdown**   

  ```remark
  ---

  .left-column[
    ## Y esto?
  ]
  .right-column[
    Pues jugando un poco con css pedes hacer muchas cosas, como columnas etc..
    ```css
    contenido css    
  ]
  ---
  .left-column[
    ## Y esto?
    ## Sintaxis?
  ]
  .right-column[
    ```remark
    contenido markdown
  ]
  ---
  ```
---

<br>  

## Modo presentación  
Modo presentación tiene varias ventajas entre ellas los comentarios adicionales:  

***Sintaxis***  

```markdown
Slide 1 content
???
Comentarios slide 1
---
Slide 2 content
???
Comentarios slide 2
```
- Estos comentarios no se ven en la presentacion estandar, pero si pulsas la tecla **P** se abre modo presentación y los ves a la derecha.
- También esta la opción de clonar la presentación con **C** y así mostrar en dos pantallas 1 en el proyector y otra en la estandar.  
- Por ultimo siempre esta la tecla **H** para mostrar todas las opciones.

---

<br>  

## Asignar clases  

Asignar clases a un diapositiva es muy útil a la hora de insertar estilos.
Por ejemplo estas diapositivas la primera y la ultima utilizan el mismo código css, por eso mismo le asigno la misma clase.  

```remark
---
class: center, middle, custom
```
- De hecho hay tres: center y middle las trae por defecto remark.
- custom es mi propio css incrustado en el html.

```css
.custom {
  background-color: #272822;
  color: #f3f3f3; 
}
.custom a {        
  color: #f92672;
}
```

---
<br>  

## Para mas información:  
[https://remarkjs.com](https://remarkjs.com)