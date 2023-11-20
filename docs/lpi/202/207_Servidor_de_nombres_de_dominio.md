# 207 Servidor de nombres de dominio (DNS)

Caracteristicas:

El DNS se creó como solución a los límites del archivo **hosts** descargado y tenía que cumplir con ciertos requisitos de diseño.

- Dinamico: Los registros se añaden de forma única y estan disponibles para todos.
- Se replica: Tienen varias copias de los servidores
- Esta Jerarquizado: Los datos se clasifican en una estructura de árbol que permite su organización. 
- Sisema distribuido: Los datos se reparten en una multitud de «subbases de datos» (las zonas DNS) y el conjunto de estas pequeñas bases de datos compone la totalidad de los registros DNS. 
- Seguro: se pueden asegurar de extremo a extremo las operaciones DNS. 

### Concepto de zonas

La organización jerárquica es la razón de la existencia de las zonas DNS. Cada nivel de la jerarquía es una zona. Cada árbol es un dominio. 

**tld** (top level domain)  son las conocidas `es., com., net.` siendo `.` la raiz de la jerarquia 

El interés de este tipo de organización es dedicar un servidor (de hecho por lo menos dos, por motivos de tolerancia a fallos) a la gestión de una zona.

Por razones de tolerancia a fallos, los datos de cada zona DNS se deben replicar por lo menos una vez, es decir, tienen que existir al menos dos copias. **SOA** sera el servidor master y se vera reflejado en las zonas y las que albergan una réplica de la zona se configuran como **slave**.

### Registros

- **Tipo A:** La mas utilizada convierte un nombre `www.myweb.net` en IP `81.85.47.14`
- **Tipo AAAA:** lo mismo que A pero en IPv6
- **Tipo PTR:** Justo lo cantrario de A convierte IP a Nombre.  Existen en zonas un poco particulares llamadas IN-ADDR.ARPA.
- **Tipo CNAME:** (alias o sobrenombre)  Este tipo de registros hace corresponder un nombre a otro nombre. 
- **Tipo MX:** indicador de servidor de mensajería para un dominio `@dominio.es → smtp.dominio.es → 82.25.120.6`
- **Tipo SOA:**  Indica que el servidor tiene la responsabilidad de la zona.  Toda zona en funcionamiento tiene por lo menos un registro SOA.
- **Tipo NS:** Indica los servidores de nombres para la zona.  Toda zona en funcionamiento tiene por lo menos un registro NS.

## 207.1 Configuración básica del servidor DNS

El servidor DNS BIND se basa en un ejecutable **named** y en un archivo de configuración **named.conf**.

El archivo `named.conf` simplificado se veria como:

```
include "/ruta/archivo"; 
options { 
        directory "/ruta/directoriodetrabajo"; 
        forwarders { A.B.C.D }; 
        };  
zone "NOMBREDEZONA1" { 
        type tipo; 
        file "/RUTA/NOMBREARCHIVO1"; 
        }; 
zone "example.org" IN {
        type master;
        file "/etc/bind/exampleorg.zone";
    };
```



| directory  | Se usa en directivas option. Indica el directorio utilizado para almacenar en disco datos de caché del servidor. |
| ---------- | ------------------------------------------------------------ |
| forwarders | para las configuraciones simples (redirección incondicional). Si el servidor no dispone en sus archivos de la resolución solicitada, devuelve la petición al servidor cuya dirección IP es la dada junto a esta directiva. |
| zone       | Contenedor para el nombre de una zona DNS administrada por el servidor. |
| type       | Indica el tipo de zona almacenada. Los valores principales son hint (servidores raíz), master (servidor maestro de una zona) y slave (réplica de un servidor master). |

**forward** se pueden especificar dos valores: `forward first;`(predeterminado) y `forward only;`. Con `forward only`, las consultas se limitan solo a las direcciones IP del servidor de nombres especificadas.

```
    options {
        // ...
        forwarders {
            123.12.134.2;
            123.12.134.3;
        }
        forward only;
        // ...
    };
```

### Zonas Preinstaladas 

Según la implementación, algunas zonas se proporcionan por defecto en la instalación del servidor para habilitar un funcionamiento estándar y permitir las resoluciones de nombre comunes.  Por ejemplo, la zona localhost que permite resolver el nombre localhost a 127.0.0.1 incluida en el interior del servicio DNS y no solo en el archivo hosts.

### Servidor de caché

Un servidor DNS de caché proporciona también la resolución de nombres, pero no contiene ningún dato de resolución local y requiere una infraestructura ya existente. Se limita a reenviar las peticiones a otros servidores. De este modo, el servidor pondrá en caché durante un tiempo determinado todas las resoluciones que ha reenviado.

Un servidor BIND recién instalado es de forma natural un servidor de caché. Por lo tanto, no hay que realizar ningún tipo de configuración particular.

### rndc

Rndc es el comando para gestionar BIND

```bash
rndc accion [parametro]
rndc reload	# Recarga los archivos de configuración y la información de zona.
rndc reload zone zona	# carga los archivos de una sola zona.
rndc reconfig	# Carga los archivos de configuración solamente para las nuevas zonas.
rndc flush		# Borra la caché del servidor.
rndc flush zona	# Borra la caché del servidor para una zona específica.
rndc status	# Muestra el estado del servidor.
```



## 207.2 Crear y mantener zonas DNS

### Administrar zonas

La información necesaria para la resolución deberá encontrarse en un archivo de declaración de zona. La ubicación de este archivo es libre, ya que se define en una sección **zone** de **named.conf**. Sin embargo, se ha establecido por un uso cotidiano que este archivo se ubique en el directorio **/var/named**. 

#### Zona directa

```
$TTL      ttl 
nombrezona  IN  SOA  servidor mailadmin ( 
         serial 
         refresh 
         retry 
         expire 
         negative ) 
 
nombrezona  IN  NS  servidor 
---
$TTL 86400
@      IN  SOA lion.example.org. dnsmaster.lion.example.org. (
               2001110700    ; Ser: yyyymmhhee (ee: ser/day start 00)
                    28800    ; Refresh
                     3600    ; Retry
                   604800    ; Expiration
                    86400 )  ; Negative caching
           IN  NS       lion.example.org.
           IN  MX   0   lion.example.org.
lion   IN   A       224.123.240.1
```



|  Opciones  |                                                              |
| :--------: | :----------------------------------------------------------- |
|    ttl     | Time To Live (tiempo de vida): indica la duración en segundos que se conservarán los datos en memoria caché. |
| nombrezona | FQDN de la zona administrada en este archivo. A menudo reemplazado por una arroba (@) para aligerar el archivo. |
|     IN     | Obsoleto a la vez que actual: clase Internet (no hay otra clase que se pueda usar). |
|    SOA     | Start Of Authority. Registro obligatorio para indicar que este servidor es legítimo en esta zona. |
|  servidor  | FQDN del servidor que tiene autoridad en la zona.            |
| mailadmin  | Dirección de correo del administrador del servidor. La arroba es un carácter reservado en los archivos de zona, convencionalmente se reemplaza por un punto. **admin@midominio.es** pasaría a ser entonces **admin.midominio.es.** |
|   serial   | Valor numérico. Número de serie del archivo.                 |
|  refresh   | Valor numérico. Utilizado cuando la zona se replica. Indica al servidor esclavo con qué intervalo comprobar la validez de su zona. |
|   retry    | Valor numérico. Utilizado cuando la zona se replica. Si es imposible para el servidor esclavo contactar con el servidor maestro, indica cuánto esperar antes de volverlo a intentar. |
|   expire   | Valor numérico. Utilizado cuando la zona se replica. Si es imposible para el servidor esclavo contactar con el servidor maestro, indica con cuánto tiempo los registros sin refrescar pierden su validez y deben dejarse de usar. |
|  negative  | Valor numérico. Indica cuánto tiempo el servidor debe conservar en caché una respuesta negativa. |
|     NS     | Registro que indica cuál es el servidor de nombres para esta zona. |

#### Zona indirecta

El archivo de zona inversa tendrá la misma estructura que un archivo de zona directa. Es importante el nombre del archivo. Por ejemplo, la zona inversa para la red **192.168.99.0** será: **99.168.192.in-addr.arpa** y este es el nombre que deberá usarse en el archivo de zona y en el archivo **named.conf**.

```
zone "240.123.224.in-addr.arpa" IN {
        type master;
        file "/etc/bind/exampleorg.rev";
    };
---

$TTL    ttl 
nombrezonainv  IN  SOA  servidor mailadmin ( 
         serial 
         refresh 
         retry 
         expire 
         negative ) 
 
nombrezonainv  IN  NS  servidor 
---

$TTL 86400
@      IN  SOA lion.example.org. dnsmaster.lion.example.org. (
               2001110700    ; Ser: yyyymmhhee (ee: ser/day start 00)
                    28800    ; Refresh
                     3600    ; Retry
                   604800    ; Expiration
                     3600 )  ; Negative caching
       IN  NS       lion.example.org.
1      IN   PTR     lion.example.org.
```

- `nombrezonainv`: Nombre normalizado de la zona inversa: subred_invertida.in-addr.arpa. Donde subred_invertida representa los bytes de la subred en orden inverso. Atención: el nombre de la zona inversa es un FQDN, por lo tanto tiene que terminar con un punto.

#### Registros

Formato de un registro de recurso en un archivo de zona directa

```
nombre IN tipoRR valor_resuelto 
```

Formato de un registro de recurso en un archivo de zona inversa

```
dirección_host IN PTR nombre 
```



| nombre         | Nombre simple o FQDN al que se le crea la correspondencia con una dirección IP. |
| -------------- | ------------------------------------------------------------ |
| tipoRR         | Tipo de registro. A menudo de tipo A: crea la correspondencia entre una IP y un nombre. |
| valor_resuelto | Es lo que se hace corresponder a un nombre. En el caso de un registro de tipo A, se trata de una dirección IP. |
| dirección_host | El byte o bytes que están asociados a la dirección de red de la zona inversa formarán la dirección IP que se resolverá. |
| PTR            | Tipo puntero: crea la correspondencia de un nombre con una dirección IP. Aparte de los registros SOA y NS, son los únicos que se encuentran en las zonas inversas. |

#### Zonas Secundarias

Una zona DNS no debería depender de un único servidor y por ello es frecuente crear un segundo servidor de zonas secundarias, estrictamente idénticas a las zonas primarias y sincronizadas a intervalos regulares.

El servidor secundario de DNS no es necesario crear los archivos de zona, ya que se sincronizarán desde el servidor autoritario. Se habla comúnmente de servidor maestro y servidores esclavos.

```
zone "nombrezona" { 
    type slave; 
    masters { dirección_maestro; }; 
    file "archivo"; 
}; 
---
zone "example.org" IN {
        type slave;
        masters { 224.123.240.1; }; // lion
        file "db.example.org";
};
```

#### Delegación de Zona

Una delegación de zona consiste en hacer que un servidor de terceros gestione una zona hija albergada por un servidor padre. Es el principio de la delegación el que permite distribuir el conjunto de espacio de nombres DNS en miles de servidores. La delegación se configura en el servidor padre.

Para ello se añaden dos **Resource Records** en el archivo de zona del padre: uno de tipo **NS** para indicar que existe un servidor de nombres para la zona hija y otro de tipo **A** para saber la dirección IP de este servidor de nombres. El registro de tipo A que permite obtener la dirección IP del servidor de nombre de la zona hija es llama **glue record** (registro de pegado).

```
zona_hija IN NS dns_hijo 
dns_hijo IN A A.B.C.D 
```

### Herramientas

**ping** Cuando se utiliza ping para comprobar la resolución de nombres, es la traducción de la dirección lo que importa, no la respuesta ICMP de la máquina remota.

**nslookup** es la herramienta más popular de consulta a servidores DNS. Está disponible en la gran mayoría de las plataformas Unix y Windows.

**dig** es la nueva herramienta propuesta por el ISC para la consulta y el diagnóstico de servidores DNS. Llegando a ser la más precisa y exitosa de las herramientas de test.

```bash
dig nombre 
dig @server_dns nombre -t TIPO
dig @1.1.1.1 test.dmain.es 
```

**host** es una sencilla herramienta para realizar peticiones DNS en modo no interactivo.

```bash
host nombre 
host -t tipo nombre A.B.C.D 
host cuacua.formacion.es 
host -t NS formacion.es 
```

**named-checkconf** es una herramienta muy util que busca errores en nel archivo `named.conf`

```bash
named-checkconf	
named-checkconf /etc/named.conf
named-checkzone mydomain.net /var/named/mydomain.net.db		# chequeo zona directa
named-checkzone 20.172.in-addr.arpa  /etc/bind/db.172.20	# chequeo zona inversa
```



## 207.3 Seguridad a un servidor DNS

### Ocultar versión

Los crackers utilizan  las versiones para saber las vulnerabilidades de los programas por ello, se debe ocultar esa información si es posible

```bash
dig @target chaos version.bind txt
```

```
    options {
        // hide bind version
        version "hidden";
    };
```



### Limitaciones de clientes

Hay varias formas de limitar el acceso a los datos del servidor de nombres. Primero, se debe definir una *lista de control de acceso* . Esto se hace con la `acl`declaración.

```
    acl "trusted" {
        localhost;
        192.168.1.0/24;
    };
```

La **allow-query** declaración se puede utilizar dentro de una `zone`declaración o también una `options`declaración. Puede contener una etiqueta acl (como `trusted`) `none`, o una o más direcciones IP o rangos de IP. Use etiquetas siempre que pueda

```
allow-query { redes_autorizadas; };
```

Ambos `dig`y `host`pueden iniciar una *transferencia de zona* 

```bash
dig axfr @ns12.zoneedit.com zonetransfer.me
host -l zonetransfer.me ns16.zoneedit.com
```

Las transferencias de zona están controladas por la **allow-transfer** declaración. Esta declaración también se puede especificar en la `zone`declaración, anulando así la `options allow-transfer`declaración global

```bash
# servidor master
	zone "example.org" IN {
        type master;
        // ....
        allow-transfer {
            my_slave_servers;
        };
    };
# servidor esclavo
    zone "example.org" IN {
        type slave;
        // ....
        allow-transfer {
            none;
        };
    };
```

**Nota**  *IMPORTANTE: \* ¡No olvide proteger también la \* zona inversa* !

### Cuenta de servicio

En los orígenes, era frecuente ejecutar un servidor **bind** con la cuenta de administración **root**. Es decir, la cuenta **root** era propietaria del proceso. Esto presenta una serie de riesgos.

La solución es, en general, ejecutar **named** con unas credenciales distintas a las de **root**, utilizando una cuenta de servicio. Una cuenta de usuario que no permita la conexión directa al sistema, pero que será propietaria del proceso.

Las implementaciones de **bind** utilizadas en las distribuciones modernas de Linux usan de forma nativa una cuenta de servicio.

```bash
[root@RH9 root]# grep named /etc/passwd 
named:x:25:25:Named:/var/named:/sbin/nologin

named -u usuario	# -u, indica la cuenta de servicio propietaria del proceso.
```

### Bind en modo chroot

**El objetivo** es hacer creer al proceso que se está ejecutando en un sistema normal, mientras que realmente está enclaustrado en una estructura de directorios paralela y en ningún caso puede interactuar con el resto del sistema.

**Para crear** el modo chroot debe tener a su disposición todos los elementos necesarios para su funcionamiento. Hay que entender que el proceso no tendrá ningún modo de ir a buscar cualquier tipo de dato fuera de su directorio.

```bash
/
├── boot
├── dev
├── etc
├── var
... └── named
         ├── dev
         ├── etc
         └── var
              └── run
```

Pasos para la creación del entorno de trabajo

- Creación del directorio de chroot.
- Creación de la estructura de directorios falsa «/» en el directorio de chroot. Todos los directorios utilizados por el proceso named deben aparecer ahí.
- Copia de los archivos de configuración en el directorio de chroot.
- Ejecución del proceso en modo chroot.

**Ejecutar** programa en modo chroot

```bash
named -c config -u usuario -t directorio 
-c	# Opcional. Indica el archivo de configuración que se usará en la carga. 
-u	# La cuenta de servicio propietaria del proceso.
-t	# El directorio en el que se enjaulará named. A menudo, /var/named.
```

### Intercambio seguro entre servidores

En el caso de los DNS, la seguridad se basa sobre todo en la autenticación y la integridad de los datos. En este caso se usará el mecanismo **TSIG** (Transaction SIGnature, firma de transacciones). Este mecanismo se basa en el uso de una clave compartida entre los servidores que intercambian datos.

Existe una herramienta de **generación de claves**: **dnssec-keygen**. Tiene muchos posibles usos, pero el que se muestra a continuación es su uso para TSIG.

```bash
dnssec-keygen -a HMAC-MD5 -b tamaño_de_clave -n nametype nombreclave 
-a	# define el algoritmo de cifrado. HMAC-MD5 es el único valor soportado para TSIG.
-b	# define el tamaño de la clave usada. Para HMAC-MD5, tamaño_de_clave tiene que estar comprendido entre 1 y 512. 
-n	# define la propiedad de la clave. generalmente nametype tiene el valor HOST|ZONE|USER...
El nombre de la clave. 

dnssec-keygen -a HMAC-MD5 -b 128 -n HOST supersecret 
Ksupersecret.+157+26824 
 
cat Ksupersecret.+157+26824.key 
supersecret. IN KEY 512 3 157 
  yItYGlAQtGcM7VqGjZdJAg== 
 
cat Ksupersecret.+157+26824.private 
Private-key-format: v1.2 
Algorithm: 157 (HMAC_MD5) 
Key: yItYGlAQtGcM7VqGjZdJAg==

# listar claves
rndc tsig-list
```

**Declaración** de la clave

En los servidores afectados por esta medida de seguridad, se incluirá en el archivo **named.conf** la definición de la clave.

```
key nombreclave { 
   algorithm hmac-md5; 
   secret "yItYGlAQtGcM7VqGjZdJAg=="; 
};
```

La clave compartida se declara en ambos servidores. Ahora hay que hacer que sepan que tienen que utilizarla para garantizar la seguridad de ciertas comunicaciones. Por lo tanto, habrá que añadir una nueva directiva en **named.conf**.

```
server ip_dest { 
   keys { nombreclave; }; 
};
```

A continuación hay que hacer que esta medida de seguridad sea obligatoria para todas las peticiones entre servidores

```
zone "midominio.es" { 
    type master; 
    file "db.midominio.es"; 
    allow-recursion { key supersecret; }; 
}; 
```

