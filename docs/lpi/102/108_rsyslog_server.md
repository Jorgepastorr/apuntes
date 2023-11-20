# rsyslog server central



rsyslog no solo procesa los logs del host local, sino que también puede procesar los de un host remoto mediante TCP o UDP.

Tabla de practica:

| Papel              | Host          | SO              | IP          |
| ------------------ | ------------- | --------------- | ----------- |
| server de registro | debian-server | debian (buster) | 192.168.1.6 |
| cliente            | debian        | debian (buster) | 192.168.1.4 |



## Server

Comencemos por configurar el servidor. En primer lugar, nos aseguramos de que `rsyslog`esté en funcionamiento:

```bash
root@debian-server:~# systemctl status rsyslog
```



Añadimos la configuración para que `rsyslog` escuche mediante TCP desde el archivo `/etc/rsyslog.d/remote.conf`

```bash
# ######### Receiving Messages from Remote Hosts ##########
# TCP Syslog Server:
# provides TCP syslog reception and GSS-API (if compiled to support it)
$ModLoad imtcp.so  # load module
##$UDPServerAddress 10.10.0.1  # force to listen on this IP only
$InputTCPServerRun 514  # Starts a TCP server on selected port
```

Debemos reiniciar el servicio `rsyslog` y comprobar que el servidor está escuchando en el puerto 514:

```bash
root@debian-server:~# systemctl restart rsyslog
root@debian-server:~# netstat -nltp | grep 514
tcp        0      0 0.0.0.0:514             0.0.0.0:*               LISTEN      2263/rsyslogd
tcp6       0      0 :::514                  :::*                    LISTEN      2263/rsyslogd
```

A continuación, debemos abrir los puertos en el firewall y recargar la configuración:

```bash
root@debian-server:~# firewall-cmd --permanent --add-port 514/tcp
success
root@debian-server:~# firewall-cmd --reload
success
```



Por defecto los logs del cliente se escribiran en `/var/log/messages` junto a los del servidor. Entonces añadimos una directiva en el archivo `/etc/rsyslog.d/remote.conf` para que los logs del cliente se escriban en un directorio diferente

```bash
$template RemoteLogs,"/var/log/remotehosts/%HOSTNAME%/%$NOW%.%syslogseverity-text%.log"
if $FROMHOST-IP=='192.168.1.4' then ?RemoteLogs
& stop
```

- `$template RemoteLogs` indica donde se escribiran los logs del cliente
- la condición filtra por la ip del cliente y si coincide envia los logs a la template `RemoteLogs`
- `& stop` impide que vse dupliquen los logs en `/var/log/messages`



Con la configuración actualizada, reiniciaremos `rsyslog`nuevamente y confirmaremos que aún no hay `remotehosts`directorio en `/var/log`:

```bash
root@debian-server:~# systemctl restart rsyslog
root@debian-server:~# ls /var/log/
```



## Cliente

El servidor ya está configurado. A continuación, configuraremos el cliente.

Nuevamente, debemos asegurarnos de que `rsyslog`esté instalado y funcionando:

```bash
root@debian:~# sudo systemctl status rsyslog
```

La siguiente linea de vconfiguración se puede añadir tanto en `/etc/rsyslog.conf` como `/etc/rsyslog.d/remote.conf` , la directiva indica vque mande todos los logs al host `debian-server` por el puerto 514

```bash
*.* @@debian-server:514
```

> Tiene que tener la resolución de nombre mediante dns o el archivo hosts, men caso contrario indcar la ip en vez del hostname.

Reiniciar el servicio y eso es todo en el cliente.

```bash
root@debian:~# systemctl restart rsyslog
```



Ahora desde el servidor se puede ver como van llegando los logs del cliente.

```bash
root@debian-server:~# ls /var/log/remotehosts/debian/
2019-09-17.info.log  2019-09-17.notice.log
```

