## Fundamentos php

### Variables

```php
<?php
// variables

//String
$nombre = "Jorge";
// integrer
$numero = 7;
//double
$decimal = 7.7;
//bolean (true/false)
$verdadero = true;

// concatenar con . "punto"
echo 'Hola, ' . $nombre;

// gettype muestra tipo de variables
echo gettype($nombre);

 ?>
```

#### Valor variables

```php
<?php
$num = 6;
$num2 = '5';
$texto = 'hola';
$diccionario = array('nombre' => 'jorge', 'edad' => 30 );
$lista = array('pedro', 'juan', 'silvia' );
$boleano = true;


echo "Numero normal <br/>";
var_dump($num);
echo "<br/><br/> numero en String <br/>";
var_dump($num2);
echo "<br/><br/> Texto <br/>";
var_dump($texto);
echo "<br/><br/> boleano <br/>";
var_dump($boleano);
echo "<br/><br/> boleano print_r debuelve false 0 o true 1<br/>";
print_r($boleano);

// utilizando pre añadimos la salida literal en este caso algo mqas claro
echo "<br/><br/> diccionario <br/>";
echo "<pre>";
var_dump($diccionario);
echo "</pre>";
// si utiliamos print_r() tenemos menos información pero mas claro
echo "diccionario con print_r<br/>";
print_r($diccionario);

echo " <br/><br/> Lista <br/>";
echo "<pre>";
var_dump($lista);
echo "</pre>";

echo "Lista con print_r <br/>";
print_r($lista);
 ?>
```



### Constantes

```php
<?php
define('PI',3.14);
define('NOMBRE',"Jorge");
echo PI;
echo NOMBRE;
 ?>
```



### Arreglos

#### Listas

```php
<?php
// Listas
echo 'Listas' . '<br />';

// metodo antiguo
$semana = array('lunes','Mares','Miercoles','Jueves');

// meodoactual
$semana2 = ['lunes','Mares','Miercoles','Jueves'];

// mostrar lista
echo $semana[0] . '<br />';
echo $semana2[0];

// añair item a lista
$semana[4] = 'Viernes';
echo $semana[4];
?>
```



#### Diccionarios

```php
<?php
// dicionarios
echo 'Diccionarios' . '<br />';

// Diccionarios
$persona = ['telefono' => 6268564, 'apellido' => 'Pastor', 'pais' => 'España'];
echo $persona['telefono'] . '<br />';
echo $persona['apellido'] . '<br />';
echo $persona['pais'] . '<br />';

// cambio telefono
echo '<br />' . 'Cambio telf' . '<br />';
$persona['telefono'] = 64687941;
echo $persona['telefono'] . '<br />';
?>
```



#### Matrices

```php
<?php
  echo 'Listas multiples' . '<br />';
  $amigos = array(
    //posición  0      1
        array('Jorge',29),  //posición 0
        array('Alex',20),   //posición 1
        array('Pedro',40)   //posición 2
  );

  echo $amigos[0][0] . '<br />';
  echo $amigos[1][0] . '<br />';
  echo $amigos[2][0] . '<br />';
?>
```



#### Contando items "count"

```php
<?php
  // contando items de array
  echo 'Número de items en lista' . '<br />';
  $meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                  'Agosto','Septiembre','Octubre','Nobiembre','Diciembre'
                );
  
  // count muestra total de items de lista
  echo "La lista meses tiene ". count($meses) .' meses';
  echo '<br />';
  
  // count -1 resta 1 ya que indice empieza en 0
  $ultimo_mes = count($meses) -1;
  echo "El ultimo mes es $meses[$ultimo_mes]";
?>
```



#### Recorrer lista

Recorriendo y ordenando listas con:
**foreach()**
Ordena tanto caracteres como números
**sort()**
**rsort() **

```php
<?php
$meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                'Agosto','Septiembre','Octubre','Nobiembre','Diciembre'
              );

$persona = array('Telefono' => 626585941 , 'Edad' => 30, 'Ciudad' => 'Barcelona' );

 ?>
 <!DOCTYPE html>
 <html>
   <head>
     <meta charset="utf-8">
     <title>Mese del año</title>
   </head>
   <body>
     <h1>meses del año</h1>
     <ul>
        <?php
            // es un for recorre lista meses
            foreach ($meses as $mes ) {
              echo '<li>'. $mes .'</li>';
            }
         ?>
     </ul>
     <br>
     <h3>ordenado alfabeticamente con sort</h3>
     <ul>
        <?php
          // ordena la lista alfabeticamente
            sort($meses);
            // es un for recorre lista meses
            foreach ($meses as $mes ) {
              echo '<li>'. $mes .'</li>';
            }
         ?>
     </ul>
     <br>
     <h3>ordenado al reves con rsort</h3>
     <ul>
        <?php
          // ordena la lista al reves
            rsort($meses);
            // es un for recorre lista meses
            foreach ($meses as $mes ) {
              echo '<li>'. $mes .'</li>';
            }
         ?>
     </ul>
     <h3>recorriendo valores de diccionario</h3>
     <ul>
        <?php
            // es un for recorre diccionario persona
            foreach ($persona as $dato => $valor ) {
              echo '<li>'. $dato . ' : ' . $valor . '</li>';
            }
         ?>
     </ul>
   </body>
 </html>
```



### If 

#### Condicional if

```php
<?php
  $edad = 1;
  // issed muestra si la variable tiene alguna asignación
  // si es true marca 1 si es false 0
  echo isset($edad);
  echo "<br />";

  // si la condición es cierta se signa la priomera opcion si no la segunda
  // como no emos asignado nada a edad2 es false 2 opcion.
  $edad2 = (isset($edad2)) ? $edad2 : 'El usuario no a establecido su edad';
  echo "Edad: " . $edad2 . "<br />";;

  $edad3 = 19;
  // como edad3 cumple la condición muestra primera opción
  $edad3 = ($edad3 >= 18) ? 'Eres mayor de edad' : 'Eres menor';
  echo  $edad3;
?>
```



#### If else if else

```php
<?php
  $mes = "Diciembre";
  /*
  condicionalesd
  < > == != <= >= !
  ||  &&
  XOR xor a de coincidir 1 condición pero solo 1
  */

  // condicio if, else if, else con or
  if ( $mes == 'Diciembre' || $mes == 'Enero' || $mes == 'Febrero'){
    echo "Es invierno";
  } else if ($mes == 'Marzo' || $mes == 'Abril' || $mes == 'Mayo'){
    echo 'Es primavera';
  } else {
    echo 'Me a dado peceza seguir escribiendo adivina';
  }
?>
```



### Operadores

```php
<?php
/*
Opreadores
+ - / * %
*/
$numero = 10;
$numero2 = 5;

$resultado = $numero + $numero2;
echo "Resultado suma simple" . $resultado . '<br />';
 ?>
```



#### Asignación

```php
<?php
  /*
  Operador de asignación
  =, +=, -=, /=, *=
  */
  // es lo mismo pero de forma reducida
  //$numero = $numero + 7;
  $numero += 7;
  echo "Resultado Asignación" . $numero . '<br />';
?>
```



#### Comparación

```php
<?php
  /*
  Operadores comparación
  ==
  ===
  !=, <>
  !==
  < > <= >=
  && ||
  */
  $numero = '10';
  // el comparador === a de ser identico tanto en valor como en tipo
  // en este caso es diferente uno es String otro integrer
  // lño mismo pasas con el diferente !==
  if ($numero === 10){
    echo "ES identico". '<br />';
  } else {
    echo "Es diferente". '<br />';
  }
?>
```



#### Incremento / decremento

```php
<?php
  /* Operadores Incremento / Decremento
  ++$x
  $x++
  --$x
  $x--
  */
  $numero = 5;
  echo "Numero: " . $numero . '<br />';
  // incrementa despues de pasar la linea
  echo "incrementa despues de pasar la linea" . $numero++ . '<br />';
  echo "Numero: " . $numero . '<br />';
  // incrementa en la misma linea
  echo "incrementa en la misma linea" . ++$numero . '<br />';
?>
```



#### Cadenas

```php
<?php
  /*
  Operadores cadenas
  .
  .=
  */
  $texto = 'Primer texto';
  // con .= concatenamos el texto
  $texto .= ' Segundo texto';
  echo "$texto";
?>
```



### switch ( menu )

```php
<?php
$mes = 'Enero';

switch ($mes) {
  case 'Diciembre':
    echo "Feliz Navidad";
    break;

  case 'Enero':
    echo "Feliz año";
    break;

  default:
    echo "opcion no permitida";
    break;
}
 ?>
```



### Bucles

#### For

```php
<?php
  // bucle for
  for ($i=1; $i <= 10; $i++) {
    echo "for $i <br />";
  }
?>
```



#### While, do while

```php
<?php
  // bucle while
  $x = 1;

  while ($x <= 10) {
    echo "while $x <br />";
    $x++;
  }

  // bucle do while
  echo "<br/>";
  // se ejecuitara el codico como mínmimo 1 vez, si cumple la condición
  // se ejecutara de nuevo si no, no.
  $a = 1;
  do {
    echo "Do while $a <br/>";
    $a++;
  } while ($a <= 10);
?>
```



#### Recorrer lista

```php
<?php
  $meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                  'Agosto','Septiembre','Octubre','Nobiembre','Diciembre'
                );

  // recorrer lista con for
  echo "Recorrer lista con for <br/>";
  for ($i=0; $i < count($meses); $i++) {
    echo $meses[$i] . "<br/>";
  }

  //recorrer lista con while
  echo "<br/>";
  echo "Recorrer lista con while <br/>";
  $contador = 0;
  while ($contador <= 10) {
    echo $meses[$contador] . "<br/>";
    $contador++;
  }
?>
```

### Funciones

```php
<?php
$num = 6;
$num2 = '5';
$texto = 'hola';
$diccionario = array('nombre' => 'jorge', 'edad' => 30 );
$lista = array('pedro', 'juan', 'silvia' );
$boleano = true;


echo "Numero normal <br/>";
var_dump($num);
echo "<br/><br/> numero en String <br/>";
var_dump($num2);
echo "<br/><br/> Texto <br/>";
var_dump($texto);
echo "<br/><br/> boleano <br/>";
var_dump($boleano);
echo "<br/><br/> boleano print_r debuelve false 0 o true 1<br/>";
print_r($boleano);

// utilizando pre añadimos la salida literal en este caso algo mqas claro
echo "<br/><br/> diccionario <br/>";
echo "<pre>";
var_dump($diccionario);
echo "</pre>";
// si utiliamos print_r() tenemos menos información pero mas claro
echo "diccionario con print_r<br/>";
print_r($diccionario);

echo " <br/><br/> Lista <br/>";
echo "<pre>";
var_dump($lista);
echo "</pre>";

echo "Lista con print_r <br/>";
print_r($lista);
 ?>
   
<?php
// extract()    extrae keys de diccionarios a variables
// array_pop()    extrae y elñimina ultimo item de lista
// join()       añade lo que quieras entre item e item de lista
// array_reverse()    invierte la lista
// round()    redonmdea
// ceil()   redondea al alza 12,1 es 13
// rand()   numero aleatorio  

$persona = array('telefono' =>626485795 , 'edad'=>20,'pais'=>'francia' );
// extract extrae las key como variables
extract($persona);
echo $telefono;
echo "<br/><br/>";

$semana = array('lunes','martes','miercoles','jueves','viernes','sabado','domingo' );
// array_pop extrae y elimina el ultimo item de las listas
$ultimo_dia = array_pop($semana);
foreach ($semana as $dia ) {
  echo "dia: ". $dia . "<br/>";
}
echo "Y el dia extraido es: " . $ultimo_dia . '<br/>';

// añade lo que quieras entre item e item
echo join(' - ',$semana);
echo "<br/><br/>";

// array_reverse invierte el orden de la lista
$invertida = array_reverse($semana);
echo join(' - ',$invertida);
echo "<br/><br/>";


echo "redondeando <br/>";
echo round(15.245);
echo "<br/>";
// redondea y especifico 1 decimal a mostrar
echo round(18.254, 1);
echo "<br/><br/>";

echo "redondeando al alza<br/>";
echo ceil(12.1);
echo "<br/><br/>";
// numero aleatorio
echo "Numero aleatorio <br/>";
echo rand(1,100);



 ?>

```

