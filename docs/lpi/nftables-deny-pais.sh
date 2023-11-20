#!/bin/bash
# El objetivo de este script es BLOQUEAR todo el tráfico del pais que nosotros definamos, aunque tambien podriamos permitir solamente el nuestro, y denegar el resto.
# Autor: RedesZone.net; puedes compartir y modificar este script como desees.
# -------------------------------------------------------------------------------
#Elegiremos el nombre PAIS del pais que queremos BLOQUEAR
#Como ejemplo pondremos Andorra ya que tiene pocos rangos de direcciones IP.
PAIS="sg"
### Variables para facilitar el uso del script que apuntan a nftables (cortafuegos), wget para coger los archivos de la base de datos y egrep para seleccionar la IP sin ningún símbolo que NFT no pueda interpretar ###
NFT=/sbin/nft
WGET=/usr/bin/wget
EGREP=/bin/egrep
#Ubicacion donde se guarda la base de datos de
BBDD="/home/debian/Descargas/NFT-bdd"
#URL de la base de datos de paises
URLDESCARGA="http://www.ipdeny.com/ipblocks/data/countries"
#Funcion para limpiar todas las reglas del firewall y lo ponemos por defecto.
limpiarReglasAntiguas(){
$NFT flush set filter ips_baneadas
$NFT flush chain ip filter INPUT
}
#Creamos el directorio para almacenar la base de datos
[ ! -d $BBDD ] && /bin/mkdir -p $BBDD
#Ejecutamos la funcion
limpiarReglasAntiguas
for c in $PAIS
do
# Base de datos local
DBLOCAL=$BBDD/$c.zone
# Descargamos y actualizamos la base de datos
$WGET -O $DBLOCAL $URLDESCARGA/$c.zone
# Filtramos la base de datos para que NFT interprete correctamente la base de datos y vamos anadiendo cada bloque de IP.
FILTROIPS=$(egrep -v "^#|^$" $DBLOCAL)
#Creamos el set de ips_baneadas de tipo IPv4.
$NFT add set ip filter ips_baneadas \{type ipv4_addr\; flags interval\;\}
#Metemos en el set todos los rangos de IP.
for ipbloqueo in $FILTROIPS
do
echo "$NFT add element ip filter ips_baneadas { $ipbloqueo }"
done
done
#Bloqueamos todo lo que coincida con el SET anteriormente creado.
$NFT add rule ip filter INPUT ip saddr @ips_baneadas counter drop
# $NFT list ruleset > /etc/nftables.conf
$NFT list ruleset > /home/debian/Descargas/nftables-deny.conf
echo "systemctl restart nftables.service"
exit 0