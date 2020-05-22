# Haproxy    
  
Haproxy es un programa que te permite balancear la carga de TCP/UDP, una de sus grandes utilidades es la redirección de puertos, de esta manera  con tener un solo puerto abierto podemos servir todas nuestras aplicaciones al exterior.  
[Link de donde se extrajo la información](https://blog.chmd.fr/ssh-over-ssl-episode-4-a-haproxy-based-configuration.html)



*/etc/haproxy/haproxy.cfg*
```bash
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
    server ssh 127.0.0.1:22
    timeout server 2h

backend docs
    reqadd X-Forwarded-Proto:\ https
    rspadd Strict-Transport-Security:\ max-age=31536000
    mode http
    option httplog
    option forwardfor
    server local_http_server 127.0.0.1:8000
  ```
  
autorizo la conexión ssh desde el dominio indicado en el usuario pi.
```bash
pi@raspberryJorge:~ $ cat ~/.ssh/config
Host jorgepastorr.tk
    ProxyCommand openssl s_client -connect jorgepastorr.tk:50022 -quiet
``` 

