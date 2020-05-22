# instalar webmin

Webmin es una herramienta para administrar tu pc local o remotamente.

## **Instalar**

<http://www.webmin.com/deb.html>

###  Desde web deb

**Dependencias necesarias en debian**

```bash
sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python
```

**Descargar paquete**

```bash
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.860_all.deb 
```

**instalar**

```bash
sudo dpkg --install webmin1.860all.deb
```



### Desde repositorio

**añadir repositorio**

```bash
sudo deb http://download.webmin.com/download/repository sarge contrib 
```

**descargar y añadir key repo**

```bash
sudo cd /root
sudo wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc 
```

**instalar**

```bash
sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get install webmin
```



###  Desde rpm web

**Descargar**

```bash
wget http://prdownloads.sourceforge.net/webadmin/webmin-1.860-1.noarch.rpm 
```

**Instalar dependencias necesarias**

```bash
sudo dnf -y install perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect 
```

**Instalar**

```bash
sudo rpm -U webmin-1.860-1.noarch.rpm
```



###  acceder

<https://192.168.4.3:10000>

contraseña de root



configurar dns

<https://usuariodebian.blogspot.com.es/2012/10/instalar-y-configurar-un-servidor-dns.html>