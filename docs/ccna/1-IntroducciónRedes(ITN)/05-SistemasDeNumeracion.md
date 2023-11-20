# Sistemas de numeración

## Sistema de numeración binaria

### Direcciones binarias e IPv4

Cada dirección está compuesta por una cadena de 32 bits, dividida en cuatro secciones llamadas octetos.
Cada octeto contiene 8 bits (o 1 byte) separados por un punto.
Para facilitar el uso de las personas, esta notación punteada se convierte en decimal punteado

El sistema de notación posicional binaria funciona como se muestra en las siguientes tablas.

| base | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| posiciónm en numero | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
| cálculo | 2^7 | 2^6 | 2^5 | 2^4 | 2^3 | 2^2 | 2^1 | 2^0 |
| valor posición | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |

#### Convertir binario a decimal

convertir 11000000 a decimal

| valor posición     | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| binario            | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| Suma               | +128 | +64 | +0 | +0 | +0 | +0 | +0 | +0 |

El resultado de convertir 11000000 es 192

#### convertir de decimal a binario

Hay 2 formas simples de hacerlo:
- dividiendo el numero reiteradamente entre 2 y guardando el dividendo que sera 0 o 1 siempre, para despues leer todos los dividendo de derecha a izquierda.
- Partiendo de los valores de posicion 128,64,32,16,8,4,2,1 vamos a conertir el 68, el procedimento seria :
  - `68 >= 128`? no. en la posicion 128 se asigna 0.
  - `68 >= 64`? si. en la posición 64 se asigna 1 y se resta el valor `68 - 64 = 4` y seguimos
  - `4 >= 32`? no en la posicion 32 se asigna 0. y así asta el final.

### Sistema de números hexadecimales

Hexadecimal es un sistema de numeración de base dieciséis, que utiliza los dígitos del 0 al 9 y las letras de A a F.
Hexadecimal se usa para representar direcciones IPv6 y direcciones MAC.

La dirección IPv6:
- tiene 128 bits 
- se divide en 8 bloques de 16 bits cada uno. 
- Cada 4 bits está representado por un solo dígito hexadecimal.

