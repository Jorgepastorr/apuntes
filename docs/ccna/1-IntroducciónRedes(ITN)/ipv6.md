# IPv6

IPv6 tiene 128 bits 64 de prefijo de red y 64 de host

## Filtrado de ipv6 reducciones

- los 0 a la izquierda se pueden ignorar
- puedes poner :: solo una vez

Estas ip son la misma

    2001:0B88:2F4D:0000:0000:CD45:0000:9C5A
    2001:B88:2F4D:0:0:CD45:0:9C5A
    2001:B88:2F4D::CD45:0:9C5A

En vez de mascara contiene prefijo de red

    2003::/3

## Tipos de IP

| IPv6      |   IPv4 |
|:---|:---|
| Globales  | Publidas |
| Privadas  | Privadas |
| Link locales | nada  |


### En Global Unicast Addresses

Las ip globales empiezan por 2 o 3

- los 3 primeros bits los asigna iana
- los 45 bits siguientes es el prefijo del ISP (telefonica, vodafone, ...)
- los 16 bits siguientes son para subneting
- y los 64 restantes de host

### Unique Local Unicast Addresses

Equivalen a IPv4 direcciones privadas, requieren un identificador de organización aleatorio

- primeroos 8 bits `11111101` en hexadecimal `FD00::/8`
- los siguientes  40 bits son de organizacion id
- los siguientes 16 bits destinados a subneting
- los 64 bits restantes a hosts

### Link-Local Unicast Addresses

Son las IPv6 generadas automaticamente por el host en la interfaz de red

- Siempre comienzan por `FE80` equivalente a `1111 1110 10` 10 bits
- seguido de 54 bits a 0
- seguido de 64 bits de interface ID



## Configuracion ipv6 router

    R1(config)# ipv6 unicast-routing # habilitar enrutamiento ipv6
    R1# show ipv6 interface brief
    R1# show ipv6 route

    R1(config-if)# ipv6 address 2001::1/64  # añadir ipv6
    R1(config-if)# ipv6 address fe80::1 li  # configurar link local

    R1# show ipv6 neighbors # tabla mac ipv6
    R1# clear ipv6 neighbors