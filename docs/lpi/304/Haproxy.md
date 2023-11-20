# Haproxy

HAProxy es un proxy inverso gratuito, muy rápido y fiable que ofrece alta disponibilidad, equilibrio de carga y proxy para aplicaciones basadas en TCP y HTTP. Es particularmente adecuado para sitios web de muy alto tráfico y alimenta una parte significativa de los más visitados del mundo. A lo largo de los años, se ha convertido en el equilibrador de carga de código abierto estándar de facto, ahora se envía con la mayoría de las distribuciones principales de Linux y, a menudo, se implementa de forma predeterminada en plataformas en la nube. 

- [haproxy.org](http://www.haproxy.org/)
- [haproxy doc](http://www.haproxy.org/download/1.4/doc/configuration.txt)


Instalación

	yum -y install haproxy 

Archivo de configuración `/etc/haproxy/haproxy.cfg`

## balanceo simple a dos nodos con stats

	[root@node01 ~]# cat /etc/haproxy/haproxy.cfg 
	...
	frontend LB
		bind 192.168.33.11:80
		reqadd X-Forwarded-Proto:\http
		default_backend LB

	backend LB 192.168.33.11:80
		mode http
		stats enable
		stats hide-version
		stats uri /stats
		stats realm Haproxy\Statistics
		stats auth haproxy:reverse
		balance roundrobin
		server nodo02 192.168.33.12:80 check
		server nodo03 192.168.33.13:80 check

---

## Balanceo con ssl

Creación de certificado

	[root@node01 ssl]# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/haproxy.key -out /etc/ssl/haproxy.crt
	[root@node01 ssl]# cat haproxy.key haproxy.crt > haproxy.pem

Archivo config

	[root@node01 ~]# cat /etc/haproxy/haproxy.cfg 
	global
		...
		tune.ssl.default-dh-param 2048


	frontend LBS
		bind 192.168.33.11:443 ssl crt /etc/ssl/haproxy.pem
		reqadd X-Forwarded-Proto:\https
		default_backend LB

	frontend LB
		bind 192.168.33.11:80
		reqadd X-Forwarded-Proto:\http
		default_backend LB

	backend LB 192.168.33.11:80
		redirect scheme https if !{ ssl_fc }
		mode http
		stats enable
		stats hide-version
		stats uri /stats
		stats realm Haproxy\Statistics
		stats auth haproxy:reverse
		balance roundrobin
		server nodo02 192.168.33.12:80 check
		server nodo03 192.168.33.13:80 check

---

## Escuchar en puerto especifico

	[root@node01 ~]# cat /etc/haproxy/haproxy.cfg 
	...
	listen mysql 192.168.33.100:3307
		mode tcp
		balance roundrobin
		server mariadb1 192.168.33.12:3306 check weight 10
		server mariadb2 192.168.33.13:3306 check weight 20


## Extra

	global
		log /dev/log    local0
		log /dev/log    local1 notice
		chroot /var/lib/haproxy
		stats socket /run/haproxy/admin.sock mode 660 level admin
		stats timeout 30s
		user haproxy
		group haproxy
		daemon

		# Default SSL material locations
		ca-base /etc/ssl/certs
		crt-base /etc/ssl/private

		# Default ciphers to use on SSL-enabled listening sockets.
		# For more information, see ciphers(1SSL). This list is from:
		#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
		# An alternative list with additional directives can be obtained from
		#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
		ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
		ssl-default-bind-options no-sslv3

	defaults
		log    global
		mode    http
		option    httplog
		option    dontlognull
			timeout connect 5000
			timeout client  50000
			timeout server  50000
		errorfile 400 /etc/haproxy/errors/400.http
		errorfile 403 /etc/haproxy/errors/403.http
		errorfile 408 /etc/haproxy/errors/408.http
		errorfile 500 /etc/haproxy/errors/500.http
		errorfile 502 /etc/haproxy/errors/502.http
		errorfile 503 /etc/haproxy/errors/503.http
		errorfile 504 /etc/haproxy/errors/504.http


	frontend ssl
		bind *:80 
		mode tcp
		option tcplog
		tcp-request inspect-delay 5s
		tcp-request content accept if HTTP

		# capta sinla petición es ssh
		acl client_attempts_ssh payload(0,7) -m bin 5353482d322e30

		use_backend ssh if !HTTP
		use_backend ssh if client_attempts_ssh
		#use_backend secure_http if HTTP

		# según el dominio nde petición redirecciona al backend indicado.
		acl is-tk hdr(host) -i jorgepastorr.tk:50022
		acl is-docs hdr(host) -i docs.jorgepastorr.tk:50022
		use_backend docs if is-tk
		use_backend docs if is-docs

	backend ssh
		mode tcp
		option tcplog
		server ssh 127.0.0.1:22 check
		timeout server 1h
		timeout connect 1h

	backend docs
		reqadd X-Forwarded-Proto:\ https
		rspadd Strict-Transport-Security:\ max-age=31536000
		mode http
		option httplog
		option forwardfor
		server local_http_server 127.0.0.1:8000


Autorizo la conexión ssh desde el dominio indicado en el usuario pi.


	pi@raspberryJorge:~ $ cat ~/.ssh/config
	Host jorgepastorr.tk
		ProxyCommand openssl s_client -connect jorgepastorr.tk:50022 -quiet



