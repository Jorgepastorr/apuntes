# Backing_chain

Backing chain permite crear una máquina virtual rápidamente.

Es tan rápido por que realmente no la crea, se basa en una máquina base y le va añadiendo seciones al disco nuevo. Si la máquina base se actualiza la nueva también estara actualizada al arrancarse de nuevo.

El inconveniente es que si desaparece la máquina base se tendran que reescribir de donde cogen base todas las backing creadas.



## Script backing

Este script creara una máquina de la base que eligas.

```bash
#!/bin/bash
# este script creara una carpeta backing dentro de /var/lib/libvirt/images/

echo "Aquest script solament funcionara amb els disc guardats a /var/lib/libvirt/images/*"
virsh list --all

# demanem nom de maquina a extreure .xml
read -e -p "Introdueix el nom de la máquina que vols la base: " XML_MV

#Demanem el nom de la màquina virtual nova
read -e -p "Introdueix el nom de la nova MV: " NOM_MV
echo ""
#Creem un nou arxiu xml a partir de la plantilla
virsh dumpxml $XML_MV > $NOM_MV.xml

# extreiem nom del disc virtual de base
disc_base=`cat $NOM_MV.xml | egrep   "<source file" | sed -r 's,^.*images/(.*\.qcow2).*,\1,'`

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
qemu-img create -b /var/lib/libvirt/images/$disc_base -f qcow2 /var/lib/libvirt/images/backing/$NOM_MV.qcow2


#Creem la MV amb el nou xml
virsh define $NOM_MV.xml

#info del nou disc
echo ""
echo "Informació del seu nou disc"
echo ""
qemu-img info --backing-chain /var/lib/libvirt/images/backing/$NOM_MV.qcow2

# borra archivo .xml 
rm $NOM_MV.xml
```

