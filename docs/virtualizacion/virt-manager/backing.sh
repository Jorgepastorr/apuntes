#!/bin/bash
# este script creara una carpeta backing dentro de /var/lib/libvirt/images/

echo "Aquest script solament funcionara amb els disc guardats a /var/lib/libvirt/images/*"
virsh list --all

# demanem nom de maquina a extreure .xml
read -e -p "Introdueix el nom de la máquina que vols la base: " XML_MV

#Demanem el nom de la màquina virtual nova
read -e -p "Introdueix el nom de la nova MV: " NOM_MV

#Demanem el tamany del nou disc
read -e -p "Introdueix tamny del nou disc: " TAMANY_MV
echo ""
#Creem un nou arxiu xml a partir de la plantilla
virsh dumpxml $XML_MV > $NOM_MV.xml
if [ $? -ne 0 ];then
  echo "Error al extraer el xmlde la máquina base" &> /dev/stderr
  exit 1
fi

# extreiem nom del disc virtual de base
disc_base=$(grep  "<source file"  $NOM_MV.xml | grep "/var/lib/libvirt/images" | sed -r 's,^.*images/(.*\.qcow2).*,\1,')

#Modifiquem el xml de la nova MV: nom.
sed -i -e s,"<name>.*</name>","<name>$NOM_MV</name>", $NOM_MV.xml
# Borrem uuid
sed -i -e s,"<uuid>.*</uuid>","", $NOM_MV.xml
# eliminem mac
sed -i -e s,"<mac address=.*/>","", $NOM_MV.xml

# cambiem nom disc
sed -i -e s,"<source file='/var/lib/libvirt/images/.*.qcow2'/>","<source file='/var/lib/libvirt/images/backing/$NOM_MV.qcow2'/>", $NOM_MV.xml

#si no existeix, creem carpeta per guardar discs de backing
if ! [ -d /var/lib/libvirt/images/backing ];then
  mkdir /var/lib/libvirt/images/backing
fi
# creem disc nou baat a la máquina base
qemu-img create -b /var/lib/libvirt/images/$disc_base -f qcow2 /var/lib/libvirt/images/backing/$NOM_MV.qcow2  $TAMANY_MV
if [ $? -ne 0 ];then
  echo "Error al generar el nuevo disco de la máquina virtual" &> /dev/stderr
  exit 2
fi


#Creem la MV amb el nou xml
virsh define $NOM_MV.xml

#info del nou disc
echo ""
echo "Informació del seu nou disc"
echo ""
qemu-img info --backing-chain /var/lib/libvirt/images/backing/$NOM_MV.qcow2

# borra archivo .xml 
rm $NOM_MV.xml
