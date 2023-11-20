yum install epel-release -y
yum --enablerepo=epel -y groups install "Xfce"

Todos:

    192.168.33.11   server.lpic.lan server
    192.168.33.12   nfsserver.lpic.lan nfsserver
    192.168.33.13   cliente.lpic.lan cliente

server freeIpa:
    
    yum update nss
    yum install ipa-server -y
    ipa-server-install


    The IPA Master Server will be configured with:
    Hostname:       server.lpic.lan
    IP address(es): 192.168.33.11
    Domain name:    lpic.lan
    Realm name:     LPIC.LAN


yum install -y krb5-server pam_krb5 krb5-workstation
/etc/krb5.conf
/var/kerberos/krb5kdc/kdc.conf
kdb5_util create -s
[root@server ~]# systemctl start krb5kdc.service
[root@server ~]# systemctl status krb5kdc.service

[root@server ~]# kadmin.local 
Authenticating as principal root/admin@LPIC.LAN with password.
kadmin.local:  listprincs
K/M@LPIC.LAN
kadmin/admin@LPIC.LAN
kadmin/changepw@LPIC.LAN
kadmin/server.lpic.lan@LPIC.LAN
kiprop/server.lpic.lan@LPIC.LAN
krbtgt/LPIC.LAN@LPIC.LAN
kadmin.local:  addprinc linus
WARNING: no policy specified for linus@LPIC.LAN; defaulting to no policy
Enter password for principal "linus@LPIC.LAN": 
Re-enter password for principal "linus@LPIC.LAN": 
Principal "linus@LPIC.LAN" created.
kadmin.local:  exit

[root@server ~]# adduser linux
[root@server ~]# authconfig-tui 


NFS-server:

    [root@NFS-server ~]# cat /etc/exports
    /shared *(rw)

    [root@NFS-server ~]# systemctl restart nfs-server
    [root@NFS-server ~]# exportfs -r
    [root@NFS-server ~]# showmount -e localhost
    Export list for localhost:
    /shared *

    [root@cliente ~]# yum install -y ipa-client

    ipa-client-install

[vagrant@NFS-server ~]$ kinit admin
[vagrant@NFS-server ~]$ klist
[vagrant@NFS-server ~]$ klist -l
[vagrant@NFS-server ~]$ klist -k

[root@NFS-server ~]# ipa-getkeytab -s server.lpic.lan -p nfs/nfsserver.lpic.lan -k /etc/krb5.keytab
systemctl start nfs-secure

[root@NFS-server ~]# cat /etc/exports
/shared *(sec=krb5,rw)

Client: 

    [root@cliente ~]# showmount -e nfsserver
    Export list for nfsserver:
    /shared *
    [root@cliente ~]# mount nfsserver:/shared /mnt

    [root@cliente ~]# yum install -y nfs4-acl-tools

    [root@cliente ~]# yum install -y ipa-client

ipa-client-install

mount -o sec=krb5 nfsserver:/shared /mnt


------------------
yum update nss -y
yum install -y ipa-server ipa-server-dns 
ipa-server-install --setup-dns

klist
kinit admin
klist
ipa  user-add ldapuser
ipa passwd ldapuser


cliente:

ipa-client-install --mkhomedir
getent passwd ldapuser

replica:

- https://www.freeipa.org/page/V4/Replica_Setup

[vagrant@ipa ~]$ ipa hostgroup-add-member ipaservers --hosts cli2.lpic.lan        

ipa host help
ipa help topics
ipa hostgroup-find
ipa host-find
[vagrant@ipa ~]$ ipa hostgroup-show ipaservers



[root@cli2 ~]# yum  install -y ipa-server
ipa-replica-install

--
https://www.freeipa.org/page/Windows_authentication_against_FreeIPA

ipa host-add win.lpic.lan --ip-address=192.168.33.16
ipa-getkeytab -s ipa.lpic.lan -p host/win.lpic.lan -e arcfour-hmac -k /etc/krb5.keytab.win -P

win:

ksetup /setdomain LPIC.LAN
ksetup /addkdc LPIC.LAN ipa.lpic.lan
ksetup /addkpassword LPIC.LAN ipa.lpic.lan
ksetup /setcomputerpassword reverse
ksetup /mapuser * *
gpedit.msc

Windows settings -> security settings -> local Policies -> security options
    netword security * kerberos
        rc4* aes128* aes256*

crear new user
    tools -> computer management -> Local users -> more actions -> new user