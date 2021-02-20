# aws

Funcionalidades generales de aws, este documento a sedo creado para repasar rapidamente que son las funcionalidades más comunes de aws.

## S3

S3 es el almacenamiento de ficheros que tiene amazon, se gestiona mediante buckets ( directorios ) , puede utilizarse simplemente para alojar ficheros o como directorio web.

Ofrece:

- control de versiones
- replicacion de datos
- seguridad y encriptación
- transfer acelerate
- alojamiento de sitios web



### CloudFront

CloudFront replica el contenido de un bucket en todos los servidores generales de amazon, esto aporta una mayor rapidez en las peticiones web, serán automáticamente enrutadas a la localización del servidor de aws mas cercano a tu localización. Así estés en la parte del mundo que estés tendrás una petición rápida con la web.

Se utiliza para distribuciones web (alojamiento web)  o RTMP (streaming de vídeo)



### Storage gateway

TODO



### Snowball

Es una solución de transporte de datos a nivel de petabytes, para transportar datos de forma física, desde aws o hasta aws. Es decir transportar multitud de datos en una maleta desde tu dispositivo local a aws o a la inversa.

- Se utiliza para migrar datos analíticos, biblioteca de vídeos, remplazo de cintas, backups, etc. 

- Se solicita un dispositivo snowball desde la consola aws

- una vez recibido se conecta a la red local y se graban los datos

- se envía el dispositivo snowball a aws e introducen la información en los buckes de la empresa.



### CLI

https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html



```bash
# configurar acceso consola
➜  ~ aws configure
AWS Access Key ID [****************TW4T]: AKIARTYVO34XH4YS25VN
AWS Secret Access Key [****************DeJP]: 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
Default region name [eu-west-2]:   
Default output format [json]: 

# listado de buckets
➜  ~ aws s3 ls  
2021-01-20 11:00:26 bucket.mybuck.imagenes

➜  ~ aws s3 ls s3://bucket.mybuck.imagenes
2021-01-18 12:30:34      85870 Pirineus_Barcelona_h1.jpg
2021-01-20 10:42:04         33 tesversion.txt

# copido de archivos
➜  ~ aws s3 cp Documentos/Vagrant.md s3://bucket.mybuck.imagenes/ 
upload: Documentos/Vagrant.md to s3://bucket.mybuck.imagenes/Vagrant.md

➜  ~ aws s3 cp s3://bucket.mybuck.imagenes s3://bucket.mybuck.files --recursive
copy: s3://bucket.mybuck.imagenes/tesversion.txt to s3://bucket.mybuck.files/tesversion.txt
copy: s3://bucket.mybuck.imagenes/Vagrant.md to s3://bucket.mybuck.files/Vagrant.md
copy: s3://bucket.mybuck.imagenes/Pirineus_Barcelona_h1.jpg to s3://bucket.mybuck.files/Pirineus_Barcelona_h1.jpg

➜  ~ aws s3 cp s3://bucket.mybuck.imagenes/Vagrant.md s3://bucket.mybuck.files/
copy: s3://bucket.mybuck.imagenes/Vagrant.md to s3://bucket.mybuck.files/Vagrant.md

# borrado de archivos en bucket
➜  ~ aws s3 ls s3://bucket.mybuck.files                                        
2021-01-20 11:28:21      85870 Pirineus_Barcelona_h1.jpg
2021-01-20 11:28:21       8182 Vagrant.md
2021-01-20 11:28:21         33 tesversion.txt

➜  ~ aws s3 rm s3://bucket.mybuck.files/Pirineus_Barcelona_h1.jpg
delete: s3://bucket.mybuck.files/Pirineus_Barcelona_h1.jpg

# borrado de bucket
➜  ~ aws s3 rb s3://bucket.mybuck.files --force    
delete: s3://bucket.mybuck.files/Vagrant.md
delete: s3://bucket.mybuck.files/tesversion.txt
remove_bucket: bucket.mybuck.files

```



## Ec2

EC2 proporciona máquinas virtuales en la nube.

### balaceadores de carga

**aplicaciones** es el mas adecuado para balancear trafico http, https

**red** es el mas adecuado para el control del protocolo de transmisión TCP y de la seguridad TLS para la que se requiere un rendimiento extremo.

**clásico**  equilibrio de carga básico en varias instancias ec2, funciona tanto en nivel de solicitud como de conexión.



### roles

permisos entre servicios dentro de aws.

Por ejemplo si una instancia de EC2 quiere acceder a un bucket esta instancia debe tener un rol con permisos al menos de read en S3



### metadata

Metadatos son datos que se asignan por defecto a una instancia, y la manera de visualizarlos es la siguiente.

```bash
[ec2-user@ip-172-31-43-213 ~]$ curl http://169.254.169.254/latest/meta-data/
ami-id
ami-launch-index
ami-manifest-path
block-device-mapping/
events/
hibernation/
hostname
iam/
identity-credentials/
instance-action
instance-id
instance-life-cycle
instance-type
local-hostname
local-ipv4
mac
metrics/
network/
placement/
profile
public-hostname
public-ipv4
public-keys/
reservation-id
security-groups
services/

[ec2-user@ip-172-31-43-213 ~]$ curl http://169.254.169.254/latest/meta-data/public-ipv4
35.178.148.97

[ec2-user@ip-172-31-43-213 ~]$ curl http://169.254.169.254/latest/user-data
#!/bin/bash

yum update -y
yum install httpd -y

aws s3 cp s3://bucket-mybuck-web/index.html /var/www/html/
```



### Auto escalado

El auto escalado permite mediante grupos de configuración desplegar varias instancias a la vez con la misma configuración y según el rendimiento que estén teniendo auto escalarse aumentando o disminuyendo el numero de instancias.

Se utiliza junto a un balanceador de carga para redireccionar las peticiones automáticamente. En el caso que se caiga una instancia por el motivo que sea, se elimina y se crea una nueva automáticamente.



## CloudWatch

Es un servicio de monitorización de los diferentes servicios de aws, puedes crear paneles, alertas, o acciones según el estado de las instancias etc..



## EFS

Elastic file system es un almacenamiento autoescalable que proporciona aws, este almacenamiento se monta en las instancias EC2, es necesario instalar `amazon-efs-utils` y el montaje es similar al siguiente ` sudo mount -t efs -o tls,accesspoint=fsap-08feb0179b349a252 fs-b7c0f446:/ /var/www/html`  

- se paga por la capacidad de datos que utilizas.

- tiene bajas latencias para cargas de trabajo

- esta diseñado para el acceso compartido de miles de instancias EC2

- es un servicio completamente administrativo

- no es necesario aprovisionar ninguna capacidad de almacenamiento por adelantado

- acceso de forma segura

- permite cifrado en transito y almacenamiento

- permite controlar el acceso mediante IAM



## Route53

**Enrutamiento simple**: enrutamiento por una o mas ip y el mismo dns se encarga del balanceo

**Enrutamiento ponderado**: este es un enrutamiento que indicas el porcentaje de carga que tendrá cada servidor, por ejemplo teniendo dos servidores uno que coja el 80% y el segundo un 20%

**Enrutamiento por latencia**:  teniendo diferentes servidores, responderá el que tenga menos latencia.

**Enrutamiento de conmutación por error**: en este caso se crea una comprobación de estado en route53 este comprueba que el servidor este en correcto estado, en el caso contrario redirigirá las peticiones a un servidor secundario.

**Enrutamiento por geolocalización**: se asocian servidores a una zona geográfica como, EU, USA, Asia, etc...

**Enrutamiento por respuesta multivalor**:  teniendo múltiples servidores se le asignan comprobación de estado a todos y en el caso de caer uno, se redirige a los demás y ese deja de recibir peticiones.



## Bases de datos

El beneficio de usar este servicio es tener backups automatizados, y el auto-escalado, ademas ofrece replicar rápidamente una base de datos en read only. 

AWS ofrece diferentes tipos de bases de datos relacionales, no relacionales y en memoria, y formato ofrece diferentes bases de datos,



### relacionales

**aurora**: base de datos compatible con mysql y postgres creada para la nube y combina el rendimiento y la disponibilidad de las bases de datos tradicionales.

**rds**: relational database service, es un servicio de bases de datos que ofrece aws, aurora, mysql, mariadb, postgres, oracle sqlserver.

**redshift**: servicio de almacenamiento de datos ágil y escalable, permite analizar los datos de manera simple y rentable. Ofrece un rendimiento diez veces superior gracias a aprendizaje automático y disco de alto rendimiento.

### No relacionales

**DynamoDB**. es un servicio de base de datos noSql rápido y flexible para cualquier escala.



### En memoria

Son bases de datos que se ejecutan en memoria, son extremadamente rápidas, pero no permiten datos perdurables.

**ElastiCache para Redis**

**ElastiCache para Memcached**



## VPC

VPC gestiona todo el servicio de red en AWS 

- gestión de gateway
- redes y subredes ( públicas y privadas )
- enrutamiento



## SQS

Servicio de colas de aws, creación de colas para aplicaciones.

Este servicio es útil por ejemplo en una aplicación que recibe instrucciones de hacer alguna cosa, por ejemplo una impresora. Una aplicación se encargaría de enviar el mensaje a la cola y la segunda aplicación de recoger cada mensaje y ejecutar la tarea especifica.

En el caso de que caiga la segunda aplicación no se perderá ninguna tarea, porque  los mensajes seguirán en la cola esperando ser recogidos.



## Elastic Transcoder

Elastic ranscoder permite cambiar formatos de archivos automáticamente de un bucket S3 a otro bucket S3.

Por ejemplo cambiar la resolución de un archivo de vídeo, así estar optimizado para visualizaciones en pantallas de diferentes tamaños.





