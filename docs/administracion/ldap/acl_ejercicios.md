Implementar a la base de dades edt.org les següents ACLS:

`ldapmodify -x -D cn=Sysadmin,cn=config -w syskey -f acl.ldif `

1. L’usuari “Anna Pou” és ajudant de l’administrador i té permisos per modificar-ho tot.
   Tothom pot veure totes les dades de tothom.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to * by dn.exact="cn=Anna Pou,ou=usuaris,dc=edt,dc=org" write by * read
```

1. L'usuari “Anna Pou” és ajudant d’administració. Tothom es pot modificar el seu propi
   email i homePhone. Tothom pot veure totes les dades de tothom.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=mail,homePhone 
    by dn.exact="cn=Anna Pou,ou=usuaris,dc=edt,dc=org" write
    by self write
olcAccess: to * by dn.exact="cn=Anna Pou,ou=usuaris,dc=edt,dc=org" write by * read
```

1. Tot usuari es pot modificar el seu mail. Tothom pot veure totes les dades de tothom.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=mail by self write by * read
olcAccess: to * by * read
```

1. Tothom pot veure totes les dades de tothom, excepte els mail dels altres.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=mail by self read
olcAccess: to * by * read
```

1. Tot usuari es pot modificar el seu propi password i tothom pot veure totes les dades
   de tothom.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=userPassword by self write by * read
olcAccess: to * by * read
```

1. Tot usuari es pot modificar el seu propi password i tothom pot veure totes les dades
   de tothom, excepte els altres passwords.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=userPassword by self write by * auth
olcAccess: to * by * read
```

1. Tot usuari es pot modificar el seu propi password i tot usuari només pot veure les
   seves pròpies dades.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=userPassword by self write by * auth
olcAccess: to * by self read by * search
```

1. Tot usuari pot observar les seves pròpies dades i modificar el seu propi password,
   email i homephone. L’usuari “Anna Pou” pot modificar tots els atributs de tots
   excepte els passwords, que tampoc pot veure. L’usuari “Pere Pou” pot modificar els
   passwords de tothom.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=userPassword by dn.exact="cn=Pere Pou,ou=usuaris,dc=edt,dc=org" write
            by self write by * auth 
olcAccess: to attrs=mail,homePhone 
            by dn.exact="cn=Anna Pou,ou=usuaris,dc=edt,dc=org" write 
            by self write        
olcAccess: to * by dn.exact="cn=Anna Pou,ou=usuaris,dc=edt,dc=org" write 
            by self read by * search
```
