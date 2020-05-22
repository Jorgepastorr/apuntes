# rdiff-backup 

<https://www.merkasys.com/rdiff-backup-como-hacer-copias-de-seguridad/>

### backup en cron

***/etc/crontab*** 

```bash
# Fem el backup incremental a nivell de blocs
25 23 * * * root /usr/bin/rdiff-backup /opt/vimet /mnt/backup/vimet/rdiff > /tmp/rdiff.log 2>&1

# Elimina els backups més antics de dues setmanes
45 22 * * * root /usr/bin/rdiff-backup --remove-older-than 2W /mnt/backup/vimet/rdiff
```



### crear backup

backup local

```bash
rdiff-backup /opt/vimet /mnt/backup/vimet/rdiff > /tmp/rdiff.log
```



a servidor externo

```bash
rdiff-backup /home/webs copias@osiris::/backups/webs
```



Para hacer una copia entre dos servidores:

```bash
rdiff-backup usuario1@servidor1::/home/webs usuario2@servidor2::/backups/webs
```



El siguiente comando copiará por ejemplo /usr/local/bin pero no /usr/bin

```bash
rdiff-backup –include /usr/local –exclude /usr / /backups
```



Ahora queremos copiar todo el sistema excluyendo /proc, /sys, /tmp y /backups:

```bash
rdiff-backup –exclude /proc –exclude /sys –exclude /tmp –exclude /backups / /backups
```

- Notas: Si elegimos copiar todo el sistema agregar siempre un –exclude con el directorio donde se van a realizar las copias.



Utilizando ***“extended shell globbing patterns”***. Además de los directorios que se excluyen del ejemplo anterior, excluiremos todos los ficheros que terminen en jpg:

```bash
rdiff-backup –exclude /proc –exclude /sys –exclude /tmp –exclude ‘**jpg’ –exclude /backups / /backups
```



Las comillas simples en los ** son muy importantes para que no los interprete la shell.

*rdiff-backup* también nos da la posibilidad de escribir en un fichero lo que queremos copiar. Para ello necesitamos usar la opción *–include-list*. Hay que escribir una línea por fichero/directorio. Si el fichero contiene las líneas:

- /etc
- /home



Entonces tendremos que ejecutar:

```bash
rdiff-backup –include-filelist fichero-list.txt –exclude ‘**’ / /backups
```



Importante agregar el *exclude ‘**’* para que solo copie lo que hemos indicado en el fichero y excluya el resto. Recordemos que el directorio de origen que indicamos es /.

Con la opción *–include-globbing-filelist* nos permite indicar un fichero donde podemos escribir patrones. Debemos añadir una línea por patrón pudiendo utilizar el carácter + para indicar las inclusiones y el carácter – para las exclusiones.

- \- **jpg
- – /home/*/Trash
- \+ /etc
- \+ /home
- – **



Con esta configuración excluímos los ficheros que terminen en *jpg* y la *carpeta Trash* de todas las carpetas de /home e incluiremos */etc y /home.* Para utilizar este fichero ejecutaremos:

```bash
rdiff-backup –include-globbing-filelist fichero-list.txt / /backups
```



Se utiliza la opción –include-globbing-filelist y no –include-filelist para que reconozca los patrones. Si usáramos –include-filelist entendería los * como propios del nombre del fichero.

Antes de terminar este apartado quiero comentar que con la opción –include-globbing-filelist se pueden mezclar líneas con patrones o sin ellos y líneas con exclusiones o sin ellas. Es decir, sin los caracteres + o -:

- -**jpg
- – /home/*/Trash
- – /usr/local/games
- /usr/local
- \+ /etc
- \+ /home
- – **



### ver versiones

Queremos sacar un listado de todas las copias realizadas por lo que ejecutaremos:

```bash
rdiff-backup -l /directorio/copias
```



Per veure totes les versions disponibles d’un arxiu

```bash 
rdiff-backup --list-increments /mnt/backup/vimet/rdiff/templates/user/doc1.txt
```



Per veure una foto de fa 7 dies de un directori concret

```bash
rdiff-backup --list-at-time 7D /mnt/backup/vimet/rdiff/templates/user/
```



Per veure tots els  canvis que hi han hagut els darrers 7 dies a un directori concret

```bash
rdiff-backup --list-changed-since 7D /mnt/backup/vimet/rdiff/templates/user/
changed templates/user
deleted templates/user/Plantilla_Fedora.qcow2
new     templates/user/Plantilla_definitiva.qcow2
```



Con –list-changed-since lista todos los ficheros que han cambiado desde una marca de tiempo:

```bash
rdiff-backup –list-changed-since 5D /backups
rdiff-backup –list-changed-since 2011-12-18T09:14:27+01:00 /backups
```



Con –list-at-time podemos listar todos los ficheros que estuvieron presentes en un determinado backup:

```bash
rdiff-backup –list-at-time 5D /backups
rdiff-backup –list-at-time 2011-12-18T09:14:27+01:00 /backups
```



Y por último, podemos comparar los cambios existentes entre un backup y un directorio en concreto.

Para ello rdiff-backup nos ofrece algunas opciónes como –compare y –compare-at-time. La primera para comparar con el último backup y la segunda para comparar con una marca de tiempo determinada:

```bash
rdiff-backup –compare /webs /backups/webs
rdiff-backup –compare-at-time 2011-12-18T09:14:27+01:00 /webs /backups/webs
```



 

### Restauraciones

El siguiente comando restaura el directorio /backups/webs de la copia realizada el 05 Mayo del 2011 en /tmp/webs:

```bash
rdiff-backup -r 2011-05-06 /backups/webs /tmp/webs
```



La misma recuperación anterior pero desde un servidor remoto:

```bash
rdiff-backup -r 2011-05-06 usuario@servidor::/backups/webs /tmp/webs
```



Recuperación de una copia de hace 5 días:

```bash
rdiff-backup -r 5D /backups/webs /tmp/webs
```



Vamos a utilizar la marca de tiempo obtenido de un listado queriendo recuperar /backups/webs en /tmp/webs del día 20 Diciembre del 2011 a las 23 horas, 00 minutos 01 segundos:

```bash
rdiff-backup -r 2011-12-20T23:00:01+01:00 /backups/webs /tmp/webs
```



Si quisiéramos recuperarlo de un servidor ejecutaríamos:

```bash
rdiff-backup -r 2011-12-20T23:00:01+01:00 usuario@servidor::/backups/webs /tmp/webs
```

