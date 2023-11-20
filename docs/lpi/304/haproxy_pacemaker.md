

## haproxy en pacemaker

En este ejemplo hacen 2 nodos de cluster con haproxy y hay 2 nodos mas con apache donde se balanceara la carga

Permitir al kernel añadir ip virtules

	/etc/sysctl.conf
		net.ipv4.ip_nonlocal_bind=1

	sysctl -p

### Configuracion haproxy

	[root@node01 ssl]# cat /etc/haproxy/haproxy.cfg
	...
	peers ha-web
		peer node01 192.168.33.11:1024
		peer node02 192.168.33.12:1024

	listen admin
		bind *:8180
		mode http
		stats enable
		stats hide-version
		stats uri /
		stats realm balanceador HAProxy
		stats auth haproxy:reverse
		stats refresh 5s

	frontend web-http
		bind *:8080
		default_backend apache

	backend apache
		stick-table type ip size 20k peers ha-web
		mode http
		balance roundrobin
		server web1 192.168.33.13:80 check maxconn 5000
		server web2 192.168.33.14:80 check maxconn 5000

#### solucionar problemas con Selinux

	cat /var/log/audit/audit.log | grep AVC | tail -n1 | audit2allow -w -a
	setsebool -P nis_enabled 1


### instalar pacemaker


    yum install -y epel-release
    yum install  -y pcs fence-agents-all

    firewall-cmd --permanent --add-service=high-availability
    firewall-cmd --add-service=high-availability

    systemctl start pcsd.service
    systemctl enable pcsd.service

    echo reverse | passwd --stdin hacluster

    pcs cluster auth node01 node02

    pcs cluster setup --start --name mycluster node01 node02
    pcs cluster enable --all

    pcs cluster status

	pcs property set stonith-enabled=false 
	pcs property set no-quorum-policy=ignore
	crm_verify -L -V

#### recursos

Añado recurso de servicio pacemaker e IP flotante

	pcs resource create HaproxyIP ocf:heartbeat:IPaddr2 ip=192.168.33.50 cidr_netmask=24 op monitor interval=10s
	pcs resource create HaproxyService systemd:haproxy op monitor interval=5s

junto los dos recursos en un grupo para que siempre vayan juntos

	pcs resource group add HAProxy HaproxyIP HaproxyService

