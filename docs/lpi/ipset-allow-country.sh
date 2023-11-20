#!/bin/bash
# El objetivo de este script es PERMITIR todo el tráfico del pais que nosotros definamos.
# Autor: RedesZone.net; puedes compartir y modificar este script como desees.
# -------------------------------------------------------------------------------
#Elegiremos el nombre PAIS del pais que queremos PERMITIR
#Como ejemplo pondremos Andorra ya que tiene pocos rangos de direcciones IP.
PAIS="es"
### Variables para facilitar el uso del script que apuntan a iptables (cortafuegos), ipset (extension de IPTABLESables), wget para coger los archivos de la base de datos y egrep para seleccionar la IP sin ningún símbolo que iptables no pueda interpretar ###
IPTABLES=/sbin/iptables
IPSET=/sbin/ipset
WGET=/usr/bin/wget
EGREP=/bin/egrep
#Ubicacion donde se guarda la base de datos de
BBDD="/root/iptables-bdd"
#URL de la base de datos de paises
URLDESCARGA="http://www.ipdeny.com/ipblocks/data/countries"
#Funcion para limpiar todas las reglas del firewall y lo ponemos por defecto.
# limpiarReglasAntiguas(){
# $IPTABLES -F
# $IPTABLES -X
# $IPTABLES -t nat -F
# $IPTABLES -t nat -X
# $IPTABLES -t mangle -F
# $IPTABLES -t mangle -X
# $IPTABLES -P INPUT ACCEPT
# $IPTABLES -P OUTPUT ACCEPT
# $IPTABLES -P FORWARD ACCEPT
# $IPSET flush paispermitido
# $IPSET destroy paispermitido
# }
#Creamos el directorio para almacenar la base de datos
[ ! -d $BBDD ] && /bin/mkdir -p $BBDD
#Ejecutamos la funcion
# limpiarReglasAntiguas
for c in $PAIS
do
# Base de datos local
DBLOCAL=$BBDD/$c.zone
# Descargamos y actualizamos la base de datos
$WGET -O $DBLOCAL $URLDESCARGA/$c.zone
# Filtramos la base de datos para que IPTABLES interprete correctamente la base de datos y vamos anadiendo cada bloque de IP.
FILTROIPS=$(egrep -v "^#|^$" $DBLOCAL)
#Creamos el IPset nuevo para bloquear el pais
$IPSET create paispermitido hash:net
for ippermitir in $FILTROIPS
do
$IPSET add paispermitido $ippermitir
done
done
#Permitimos el tráfico del ipset creado.
$IPTABLES -I INPUT -m set --match-set paispermitido src -j ACCEPT
#DENEGAMOS todo el resto del trafico.
# $IPTABLES -A INPUT -j DROP
$IPTABLES -A INPUT -i veth0 -p tcp --match multiport --dport 80,443 -j DROP

exit 0