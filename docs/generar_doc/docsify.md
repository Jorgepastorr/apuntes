# Docsify  

Docsify es un magnífico sitio donde generar tu documentación y colgarla en un servidor web rapidamente, de manera muy sencilla y con una agradable presentación. docsify crea una web donde leera automáticamente tus archivos markdown y los mostrara con un menu lateral.  

[Página oficial Docsify](https://docsify.js.org)  

<br>  

## Iniciar docsify  

Existen dos maneras de iniciar Docsify, mediante `npm` o insertando el archivo `index.html` en el inicio de una carpeta.
> Se recomienda `npm`  

<br>  

### Iniciar desde npm  (recomendado)
Mediante esta opción tenemos que instalar docsify y luego iniciarlo.  
```bash   
# instalar  
sudo npm i docsify-cli -g  

# iniciar en el directorio docs
docsify init ./docs
```  
- Esto crea dos archivos en el directorio docs, index.html y un README.md.  

Previsualización del la web.  
```bash  
docsify serve docs
```  
> `http://localhost:3000`  

<br>  

### Iniciar forma manual

Para iniciar de forma manual simplemente copiar el siguiente código en un archivo index.html e insertarlo en el directorio raiz de vuestra web.  
Inmediatamente empezara a leer los archivos .md que esten en el mismo nivel de directorio.  
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Document</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="description" content="Description">
  <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
  <link rel="stylesheet" href="//unpkg.com/docsify/lib/themes/vue.css">
</head>
<body>
  <div id="app"></div>
  <script>
    window.$docsify = {
      name: '',
      repo: ''
    }
  </script>
  <script src="//unpkg.com/docsify/lib/docsify.min.js"></script>
</body>
</html>
```  

<br>  

## Funcionamiento  

El funcionamiento consiste en un directorio donde tienes todos tus archivos .md y se muestran en la web en el menú lateral.  
El problema es cuando empiezas a tener mucha información y necesitas organización. docsify a pensado en ello y el orden es el siguiente.  
- En cada directorio abra un archivo `_sidebar.md` con el menú lateral y un `README.md` que iniciara ese directorio.

***Ejemplo:***  
```bash  
./docs
├── README.md
├── _sidebar.md
├── Sistemas
│   ├── README.md
│   └── _sidebar.md
└── Redes
    ├── README.md
    └── _sidebar.md
```  

Despues en cada `_sidebar.md` te diriges a cada directorio mediante links.  
***Ejemplo:***  
```markdown  
- [inicio](/README.md)
  - [Redes](/Redes/README.md)
  - [Sistemas](/Sistemas/README.md)
```  
> Si se inicia docsify teniendo mucha información, moriras del aburrimiento creando menus.  

<br>  

## Configurar presentación

Desde index.html hay reglas a configurar que son interesantes. Solo explicare las que me parecen mas interesantes y estoy utilizando en esta web actualmente.  
[Todas las opciones](https://docsify.js.org/#/configuration)  

### name  
Nombre que saldra en encima del menu y redirijira al inicio.
```javascript  
window.$docsify = {
    name: 'Jorge Pastor'
};
```  
### repo  
Añade tu repositorio en la esquina superior derecha.  
```javascript  
window.$docsify = {
    repo: 'https://github.com/Jorgepastorr/apuntes'
};
```  

### loadsidebar  
Cargar los menús personalizados.   

```javascript  
window.$docsify = {
  // load from _sidebar.md
  loadSidebar: true,

  // load from summary.md
  loadSidebar: 'summary.md'
};
```        
### subMaxLevel  
Nivel de headers que quieres que muestre el menú.  
```javascript  
window.$docsify = {
  subMaxLevel: 2
};
```  

### autoHeader  
Muestra el encabezado del markdown (El titulo principal).  
```javascript  
window.$docsify = {
  loadSidebar: true,
  autoHeader: true
};
```  

### themeColor  
Color del tema, la variable se descrive a si misma.  
```javascript  
window.$docsify = {
  themeColor: 'purple'
};
```  

<br>  

## Plugins  
Los plugins son funciones adicionales muy interesantes algunas de ellas.  
[Todos los plugins](https://docsify.js.org/#/plugins)

### Buscar texto  
En la esquina superior izquieda inserta una barra de busqueda.
```javascript  
<script>
    window.$docsify = {
        search: {
            maxAge: 86400000,
            paths: 'auto',
            placeholder: 'Search',
            depht: 3,
            noData: 'No Results!' 
        }  
    }
</script>
<script src="//unpkg.com/docsify/lib/plugins/search.min.js"></script>
```  
### Copiado de código  
En los cuadros de codigo añade un enlace de copiado rapido.   
```javascript
<script src="//unpkg.com/docsify-copy-code"></script>
```

### Zoom en imágenes  
Al clicar en una imágen hace zoom.  
```javascript
<script src="//unpkg.com/docsify/lib/plugins/zoom-image.min.js"></script>
```

### Tabs  
[doc de tabs](https://jhildenbiddle.github.io/docsify-tabs/#/)  
Tabs es un plugin donde crea pestañas en un recuadro de código.  

```markdown  
<!-- tabs:start -->

#### ** English **

Hello!

#### ** French **

Bonjour!

#### ** Italian **

Ciao!

<!-- tabs:end -->
```   
***Ejemplo:***  
<!-- tabs:start -->

#### ** English **

Hello!

#### ** French **

Bonjour!

#### ** Italian **

Ciao!

<!-- tabs:end -->  


```javascript
<script>
    window.$docsify = {
        tabs: {
            persist    : true,      // default
            sync       : true,      // default
            theme      : 'classic', // default
            tabComments: true,      // default
            tabHeadings: true       // 
        }
    }
</script>
<script src="//unpkg.com/prismjs/components/prism-bash.min.js"></script>
<script src="//unpkg.com/prismjs/components/prism-php.min.js"></script>
<script src="https://unpkg.com/docsify-tabs@1"></script>
```  