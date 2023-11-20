# ACL para configuración IPv4

## Configurar ACL IPv4 estándar

Todas las listas de control de acceso (ACL) deben planificarse. Al configurar una ACL compleja, se sugiere que:

- Utilice un editor de texto y escriba los detalles de la política que se va a implementar.
- Agregue los comandos de configuración del IOS para realizar esas tareas.
- Incluya comentarios para documentar la ACL.
- Copie y pegue los comandos en el dispositivo.
- Pruebe siempre exhaustivamente una ACL para asegurarse de que aplica correctamente la política deseada.

### Sintaxis de una ACL de IPv4 estándar numerada

Para crear una ACL estándar numerada, utilice el siguiente comando de configuración global:

    Router(config)# access-list access-list-number {deny | permit | remark text} source [source-wildcard] [log]


| Parámetro          | Descripción                                                             |
| :----------------- | :---------------------------------------------------------------------- |
| access-list-number | El rango de números ACL estándar es de 1 a 99 o 1300 a 1999.            |
| deny               | deniega el acceso si la condición coincide.                             |
| permit             | permite el acceso si la condición coincide.                             |
| remark text        | (Opcional) entrada de texto para fines de documentación                 |
| source             | identifica la red de origen o la dirección de host que se va a filtrar. |
| source-wildcard    | (Opcional) Máscara wildcard de 32 bits para aplicar al origen.          |
| log                | (Opcional) Genera y envía un mensaje informativo cuando el ACE coincide |

> Nota: Utilice el comando de configuración global no access-list access-list-number para eliminar una ACL estándar numerada.

###  Sintaxis de una ACL de IPv4 estándar con nombre

Para crear una ACL estándar nombrada, utilice el comando `ip access-list` standard

Los nombres de las ACL son alfanuméricos, distinguen mayúsculas de minúsculas y deben ser únicos. 

No es necesario que los nombres de las ACL comiencen con mayúscula, pero esto los hace destacarse cuando se observa el resultado de `show running-config`.

    Router(config)# ip access-list standard access-list-name
    R1(config)# ip access-list standard NO-ACCESS


### Aplicación de la ACL IPv4 estándar

Después de configurar una ACL IPv4 estándar, debe vincularse a una interfaz o entidad. 

    Router(config-if) # ip access-group {access-list-number | access-list-name} {in | out}

### ejemplo estandar numerada

    R1(config)# access-list 10 remark ACE permits all host in LAN 2
    R1(config)# access-list 10 permit 192.168.20.0 0.0.0.255

    R1(config)# interface Serial 0/1/0
    R1(config-if)# ip access-group 10 out

### ejemplo estandar nombrada

    R1(config)# ip access-list standard PERMIT-ACCESS

    R1(config-std-nacl)# remark ACE permits host 192.168.10.10
    R1(config-std-nacl)# permit host 192.168.10.10

    R1(config-std-nacl)# remark ACE permits all hosts in LAN 2
    R1(config-std-nacl)# permit 192.168.20.0 0.0.0.255

    R1(config)# interface Serial 0/1/0
    R1(config-if)# ip access-group PERMIT-ACCESS out
    R1(config-if)# end


## Modificación de ACL de IPv4

Después de configurar una ACL, es posible que deba modificarse. Las ACL con varias ACE pueden ser complejas de configurar. A veces, el ACE configurado no produce los comportamientos esperados. 

Hay dos métodos que se deben utilizar al modificar una ACL:

- Utilice un editor de texto.
- Utilice números de secuencia

### Método de editor de textos

Las ACL con varias ACE deben crearse en un editor de texto. Esto permite crear o editar la ACL y luego pegarla en la interfaz del router. También simplifica las tareas para editar y corregir una ACL.

Para corregir un error en una ACL:

- Copie la ACL de la configuración en ejecución y péguela en el editor de texto.
- Realice las ediciones o cambios necesarios.
- Elimine la ACL configurada previamente en el router.
- Copie y pegue la ACL editada de nuevo en el router.

### método secuencia de números

Una ACE ACL se puede eliminar o agregar utilizando los números de secuencia ACL.

Utilice el comando ip access-list standard para editar una ACL. 

Las instrucciones no se pueden sobrescribir con el mismo número de secuencia que el de una instrucción existente. La instrucción actual debe eliminarse primero con el comando no 10. A continuación, se puede agregar el ACE correcto utilizando el número de secuencia. 

    R1# show access-lists 
    Standard IP access list 1 
        10 deny 19.168.10.10 
        20 permit 192.168.10.0, wildcard bits 0.0.0.255

    R1# conf t
    R1(config)# ip access-list standard 1
    R1(config-std-nacl)# no 10
    R1(config-std-nacl)# 10 deny host 192.168.10.10
    R1(config-std-nacl)# end
    R1# show access-lists
    Standard IP access list 1
        10 deny   192.168.10.10
        20 permit 192.168.10.0, wildcard bits 0.0.0.255


## Protección de puertos VTY con una ACL IPv4 estándar

Una ACL estándar puede proteger el acceso administrativo remoto a un dispositivo mediante las líneas vty implementando los dos siguientes pasos:

- Cree una ACL para identificar a qué hosts administrativos se debe permitir el acceso remoto.
- Aplique la ACL al tráfico entrante en las líneas vty.

    R1(config-line)# access-class {access-list-number | access-list-name} { in | out }

En este ejemplo se muestra cómo configurar una ACL para filtrar el tráfico vty.

- En primer lugar, se configura una entrada de base de datos local para un usuario ADMIN y una clase de contraseña.
- Las líneas vty en R1 están configuradas para utilizar la base de datos local para la autenticación, permitir el tráfico SSH y utilizar la ACL ADMIN-HOST para restringir el tráfico.

    R1(config)# username ADMIN secret class
    R1(config)# ip access-list standard ADMIN-HOST
    R1(config-std-nacl)# remark This ACL secures incoming vty lines
    R1(config-std-nacl)# permit 192.168.10.10
    R1(config-std-nacl)# deny any
    R1(config-std-nacl)# exit

    R1(config)# line vty 0 4
    R1(config-line)# login local
    R1(config-line)# transport input ssh
    R1(config-line)# access-class ADMIN-HOST in


## Configuración de ACL IPv4 extendidas

Las ACL extendidas proporcionan un mayor rango de control. Pueden filtrar por dirección de origen, dirección de destino, protocolo (es decir, IP, TCP, UDP, ICMP) y número de puerto.

Las ACL extendidas se pueden crear como:

- **ACL extendida numerada**: creada mediante el comando de configuración global access-list access-list-number.
- **ACL extendida nombradas**: creada usando el nombre de lista de acceso extendido de ip access-list .

### configuración de números de puerto

Las ACL extendidas pueden filtrar en diferentes opciones de número de puerto y nombre de puerto. 

En este ejemplo se configura una ACL 100 extendida para filtrar el tráfico HTTP. El primer ACE utiliza el nombre del puerto www. El segundo ACE utiliza el número de puerto 80. Ambas ACE logran exactamente el mismo resultado.

    R1(config)# access-list 100 permit tcp any any eq www
    R1(config)#  !or...
    R1(config)# access-list 100 permit tcp any any eq 80 

La configuración del número de puerto es necesaria cuando no aparece un nombre de protocolo específico, como SSH (número de puerto 22) o HTTPS (número de puerto 443), como se muestra en el siguiente ejemplo.

    R1(config)# access-list 100 permit tcp any any eq 22
    R1(config)# access-list 100 permit tcp any any eq 443


### TCP Establecida ACL extendida

TCP también puede realizar servicios básicos de firewall con estado usando la palabra clave TCP **established**

La palabra clave **established** permite que el tráfico interno salga de la red privada interna y permite que el tráfico de respuesta devuelta entre en la red privada interna.

Se deniega el tráfico TCP generado por un host externo e intentando comunicarse con un host interno.

ACL 120 está configurado para permitir sólo devolver tráfico web a los hosts internos. A continuación, la ACL se aplica saliente en la interfaz R1 G0/0/0. 

El comando show access-lists muestra que los hosts internos están accediendo a los recursos web seguros desde Internet. 

> Nota: Si el segmento TCP que regresa tiene los bits ACK o de restablecimiento (RST) establecidos, que indican que el paquete pertenece a una conexión existente, se produce una coincidencia TCP.

    R1(config)# access-list 120 permit tcp any 192.168.10.0 0.0.0.255 established
    R1(config)# interface g0/0/0 
    R1(config-if)# ip access-group 120 out 
    R1(config-if)# end


### Configuración de las ACL IPv4 extendidas

La topología a continuación se utiliza para demostrar la configuración y aplicación de dos ACL IPv4 extendidas con nombre a una interfaz:

- SURF - Esto permitirá que dentro del tráfico HTTP y HTTPS salga a Internet. 
- Navegación - Esto solo permitirá devolver tráfico web a los hosts internos mientras que todo el resto del tráfico que sale de la interfaz R1 G0/0/0 está implícitamente denegado. 

    R1(config)# ip access-list extended SURFING
    R1(config-ext-nacl)# Remark Permits inside HTTP and HTTPS traffic 
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq 80
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq 443
    R1(config-ext-nacl)# exit
    
    R1(config)# ip access-list extended BROWSING
    R1(config-ext-nacl)# Remark Only permit returning HTTP and HTTPS traffic 
    R1(config-ext-nacl)# permit tcp any 192.168.10.0 0.0.0.255 established
    R1(config-ext-nacl)# exit
    
    R1(config)# interface g0/0/0
    R1(config-if)# ip access-group SURFING in
    R1(config-if)# ip access-group BROWSING out


###  Edición de ACL extendidas

Una ACL extendida se puede editar utilizando un editor de texto cuando se requieren muchos cambios. O bien, si la edición se aplica a una o dos ACE, se pueden utilizar números de secuencia.

Por ejemplo:

- El número de secuencia ACE 10 de la ACL de SURF tiene una dirección de red IP de origen incorrecta.

    R1# configure terminal
    R1(config)# ip access-list extended SURFING 
    R1(config-ext-nacl)# no 10
    R1(config-ext-nacl)# 10 permit tcp 192.168.10.0 0.0.0.255 any eq www
    R1(config-ext-nacl)# end

