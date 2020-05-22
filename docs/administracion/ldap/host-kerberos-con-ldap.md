# Instalación host  ldap-kerberos



```bash
sudo dnf install -y nss-pam-ldapd authconfig \
                pam_krb5 krb5-workstation
```



```bash
sudo authconfig --enableshadow --enablelocauthorize \
   --enableldap \
   --ldapserver='ldap.edt.org' \
   --ldapbase='dc=edt,dc=org' \
   --enablekrb5 --krb5kdc='kserver.edt.org' \
   --krb5adminserver='kserver.edt.org' --krb5realm='EDT.ORG' \
   --enablemkhomedir \
   --updateall
```



```bash
sudo systemctl start nslcd
```



Si al autenticar con un usuario de ldap da el error ` pam_krb5[10992]: error updating ccache "KCM:"` comentar la linea de cache KMC en `/etc/krb5.conf.d/kcm_default_ccache`

```bash
# cat /etc/krb5.conf.d/kcm_default_ccache
# This file should normally be installed by your distribution into a
# directory that is included from the Kerberos configuration file (/etc/krb5.conf)
# On Fedora/RHEL/CentOS, this is /etc/krb5.conf.d/
#
# To enable the KCM credential cache enable the KCM socket and the service:
#   systemctl enable sssd-secrets.socket sssd-kcm.socket
#   systemctl start sssd-kcm.socket
#
# To disable the KCM credential cache, comment out the following lines.

[libdefaults]
    #default_ccache_name = KCM:
```



```bash
Host *
GSSAPIAuthentication yes
GSSAPIDelegateCredentials yes
```

