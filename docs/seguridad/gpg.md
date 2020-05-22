# GPG

PGP ( Pretty Good Privacy ) es un mecanismo de cifrado y procesamiento de contenido. en su versión gratuita `GPG` (Gnu Protection Group )

gpg se utiliza para guardar ficheros cifrados en disco o para mandar ficheros por correo.

## Tipos de seguridad

**Data at Rest**: Son datos sin movimiento, se protege con RAID, LVM, Backups, GPG, luks ( particiones encriptadas ).

**Data on Motion**: datos en movimiento, se protege via SSL, TLS, ... Estos datos suelen utilizar criptografía simétrica.

## Definiciones

**Cifrar**: puedes verlo pero no leerlo, ya que es un texto plano encriptado de alguna manera, solo lo podrá leer el emisor y el receptor.

El cifrado de un texto puede ser en `.der` binario o `.pem` ascci base 64.

**Autenticar**: demostrar quien eres, el mensaje verifica que el emisor es quien dice ser.

**intregridad**: es cierto que no se a tocado nada del contenido en el viaje.

**no repudiar**: no puedes negar que es tuyo

**firmar**: integra autenticar, integridad y no repudiar. El emisor firma con la clave privada un documento, el destinatario con la clave publica del emisor verifica que es de dicho emisor, porque desenrosca tiene integridad y no puede negar que es suyo.

Al firmar se añade al final del documento un hash que es extraído del documento y además se firma con la clave privada, el receptor verificara la firma con la clave publica y si el documento genera un hash igual que el enviado, el texto no a sido modificado.

### Hash

Hash ( no es un cifrado, ni certificado de claves ) `MD5, SHA` Es una función que dada una información de entrada,  genera un valor que no puede ser generado por ninguna otra entrada, a no ser que sea la misma. 

El mas mínimo cambio generará un código de bytes completamente diferente.

La función es una transformación, no encripta, no se puede obtener el resultado inicial a partir del resultado final.

### Criptografía

**Simétrica**: una palabra o frase secreta que se usa tanto para cifrar como descifrar, las claves son mas pequeñas y algoritmo mas rápido.

La cable privada se guarda con criptografía simétrica si le indicamos la passfrase que pide al generar las keys, en caso contrario se guarda en texto plano. El inconveniente de guardarla encriptada es que cada vez que se tenga qu utilizar pedirá la passfrase para desencriptarse.

**Asimétrica**:  claves mas largas algoritmo lento. Utiliza clave privada y publica, la privada se mantiene solo el propietario la publica contra mas la tengan mejor. Para una comunicación bidireccional las dos pares han de tener la publica del otro extremo, ya que con la publica se encripta y con la privada se desencripta.

## Modelos de seguridad

- **PKI public key infraestructura:** mecanismo piramidal hay alguien que te tiene que autenticar

- **Web of trust**: confiar en quien yo quiero. para que esto funcione tiene que haber intercambio de claves públicas.

## Gestionar claves

`gpg --gen-key `  genera claves con distintos formatos, tiempo de duración y una clave passfrase. este crea un directorio en `~/.gnupg/` donde guarda las claves.

A destacar que `Keyring` llavero donde están las llaves y `secring` llavero público.

### generar llaves

```bash
gpg --gen-key
gpg --full-gen-key
```

Se escoge el tipo de cifrado y tamaño

```bash
Por favor seleccione tipo de clave deseado:
   (1) RSA y RSA (por defecto)
   (2) DSA y ElGamal
   (3) DSA (sólo firmar)
   (4) RSA (sólo firmar)
Su elección: 1
las claves RSA pueden tener entre 1024 y 4096 bits de longitud.
¿De qué tamaño quiere la clave? (3072) 
```

Cuando caduca

```bash
Por favor, especifique el período de validez de la clave.
         0 = la clave nunca caduca
      <n>  = la clave caduca en n días
      <n>w = la clave caduca en n semanas
      <n>m = la clave caduca en n meses
      <n>y = la clave caduca en n años
¿Validez de la clave (0)? 
La clave nunca caduca
¿Es correcto? (s/n) s
```

Se añade identificadores y contraseña

```bash
Nombre y apellidos: user1 edt
Dirección de correo electrónico: user1@edt.org
Comentario: cc
Ha seleccionado este ID de usuario:
    "user1 edt (cc) <user1@edt.org>"
```

```bash
claves pública y secreta creadas y firmadas.

pub   rsa3072 2020-02-11 [SC]
      B3A2BCDF9FFB9991A7374A369241A986C5CB7445
uid                      user1 edt (cc) <user1@edt.org>
sub   rsa3072 2020-02-11 [E]
```

### Listar claves

```bash
user1@pc02:~$ gpg --list-key
gpg: comprobando base de datos de confianza
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: nivel: 0  validez:   1  firmada:   0  confianza: 0-, 0q, 0n, 0m, 0f, 1u
/home/user1/.gnupg/pubring.kbx
------------------------------
pub   rsa3072 2020-02-11 [SC]
      B3A2BCDF9FFB9991A7374A369241A986C5CB7445
uid        [  absoluta ] user1 edt (cc) <user1@edt.org>
sub   rsa3072 2020-02-11 [E]
```

#### Fingerprint

```bash
user1@pc02:~$ gpg --fingerprint
```

### Exportar clave

Exportar la clave pública sirve para que el destinatario pueda abrir y decodificar nuestros mensajes.

```bash
gpg --output /tmp/user1.gpg --export user1@edt.org # binario
gpg --armor --output /tmp/user1.gpg --export user1@edt.org # en texto plano cifrado base 64 
# exportar todas las claves que tenga.
gpg --output /tmp/user1.gpg --export
```

### Importar clave

importar claves permite decodificar documentos de otros usuarios.

```bash
user2@pc02:~$ gpg --import /tmp/user1.gpg 
gpg: creado el directorio '/home/user2/.gnupg'
gpg: caja de claves '/home/user2/.gnupg/pubring.kbx' creada
gpg: /home/user2/.gnupg/trustdb.gpg: se ha creado base de datos de confianza
gpg: clave 9241A986C5CB7445: clave pública "user1 edt (cc) <user1@edt.org>" importada
gpg: Cantidad total procesada: 1
gpg:               importadas: 1
```

vemos como ahora user2 tiene  su propia clave mas la pública de user1

```bash
user2@pc02:~$ gpg --list-key
------------------------------
pub   rsa3072 2020-02-11 [SC]
      B3A2BCDF9FFB9991A7374A369241A986C5CB7445
uid        [desconocida] user1 edt (cc) <user1@edt.org>
sub   rsa3072 2020-02-11 [E]

pub   rsa3072 2020-02-11 [SC] [caduca: 2022-02-10]
      3E409CD05DEEAB9583410521A7005DFA20B44BD3
uid        [  absoluta ] user2 edt <user2@edt.org>
sub   rsa3072 2020-02-11 [E] [caduca: 2022-02-10]
```

#### Confirmar clave

```bash
user2@pc02:~$ gpg --edit-key user1@edt.org

gpg> fpr --> Mostra el fingerprint
gpg> sign --> Firma la clau pública com a vàlida, utilitzando su propio passfrase de user2
gpg> quit
¿Grabar cambios? (s/N) s
```

### Cifrar archivo

puedo cifrar un documento para user1 por que tengo su clave pública

```bash
# en binaro
user2@pc02:~$  gpg --output /tmp/fstab.gpg --encrypt --recipient user1@edt.org /etc/fstab
# en base64
user2@pc02:~$ gpg --armor --output /tmp/passwd.pem --encrypt --recipient user1@edt.org passwd.txt 
```

### Descifrar

desde user1 puedo descifrar un archivo que se a creado con mi clave pública

```bash
user1@pc02:~$ gpg --decrypt /tmp/fstab.gpg 
```

### Firmar

Existen diferentes formas de firmar

#### Archivo codificado

Firmar codificando todo el documento, este método en el caso de archivos grandes no es recomendable.

```bash
user1@pc02:~$ gpg --output /tmp/missatge.gpg --sign missatge.txt 
user1@pc02:~$ gpg -a --output /tmp/missatge.pem --sign missatge.txt 


user2@pc02:~$ gpg --decrypt /tmp/missatge.gpg 
```

#### Hash al final

Firmar añadiendo hash al final.

```bash
user1@pc02:~$ gpg -a --output /tmp/missatge.pem  --clearsign missatge.txt 
user1@pc02:~$ cat /tmp/missatge.pem 
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

hola caracola 
est son pruebas de gpg
-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEs6K835/7mZGnN0o2kkGphsXLdEUFAl5K5Z0ACgkQkkGphsXL
dEUvSwv+L5/c4+gPmqFAdDmx/VLZud8DWhQHeWsw0G5TVu70Qoo2E1ZR0LgdyZsA
S5xoyMzGKQ5BpV4KBTKISz9153TTMelr3ind0xsODYaPTGW3YcbZagbD7HFF7Pea
tFJClPLV5Jw3WQW+UkIf1CRZUPu8mTpMzaGsywt06+/99BNjZGoIS9uKku5/L7QS
J2dcqI9FX/Cm/SLdsshQ4H8xeTcUcTH+pLfFKlhBCwlz1IvaB7d+QHSw0DIkaOur
7UIENg2CM2GtTHymE5b0ZaGDZX/xamL22XuuSVCuUrPxxTBwYWD2J6IXtpPzNwdf
TR3YQW5P5Z0wH09lBPDKED2m+ISi/L+PAWIbxb+5V/DOG5PrFBX0oJQheNrBFaTV
xK2/KTgQNd5J9zzLmvFXc7d+zo8N4IL0yxt2L1OJsRqHA2nRXFT6v+Ax9GWaYZs0
bUOeRTQdtOU+pTrnlBEKpwFAWfwZGIjAC3oDFYlYg6Anfshq39UqzeZ+41/ofmin
vLh/ONOI
=YR4/
-----END PGP SIGNATURE-----

user2@pc02:~$ gpg --decrypt /tmp/missatge.pem
hola caracola
est son pruebas de gpg
gpg: Firmado el lun 17 feb 2020 20:12:29 CET
gpg:                usando RSA clave B3A2BCDF9FFB9991A7374A369241A986C5CB7445
gpg: Firma correcta de "user1 edt (cc) <user1@edt.org>" [total]
```

#### Separado

crear hash y firma en un segundo documento, en este caso se tiene que enviar dos archivos, el documento mas la firma, se verifica que no a sido modificado y después se trabaja con el archivo de texto en este caso. 

```bash
user1@pc02:~$ gpg -a --output /tmp/missatge.pem  --detach-sign missatge.txt 
user1@pc02:~$ cp missatge.txt /tmp/

user2@pc02:~$ gpg --verify /tmp/missatge.pem /tmp/missatge.txt 
gpg: Firmado el lun 17 feb 2020 20:17:18 CET
gpg:                usando RSA clave B3A2BCDF9FFB9991A7374A369241A986C5CB7445
gpg: Firma correcta de "user1 edt (cc) <user1@edt.org>" [total]
```

#### Verficar

Para verificar una firma hay que tener varias cosas en cuenta:

- tengo la clave publica del emisor?
- tengo la clave publica del emisor firmada?

```bash
# no tengo la clave publica (FAIL)
user3@pc02:~$ gpg --verify /tmp/missatge.pem
gpg: Firmado el lun 17 feb 2020 20:17:18 CET
gpg:                usando RSA clave B3A2BCDF9FFB9991A7374A369241A986C5CB7445
gpg: Imposible comprobar la firma: No hay clave pública

# tengo la publica pero no esta firmada (Tu sabras si fiarte)
user3@pc02:~$ gpg --verify /tmp/missatge.pem
gpg: Firmado el lun 17 feb 2020 20:17:18 CET
gpg:                usando RSA clave B3A2BCDF9FFB9991A7374A369241A986C5CB7445
gpg: comprobando base de datos de confianza
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: nivel: 0  validez:   1  firmada:   0  confianza: 0-, 0q, 0n, 0m, 0f, 1u
gpg: Firma correcta de "user1 edt (cc) <user1@edt.org>" [desconocido]
gpg: ATENCIÓN: ¡Esta clave no está certificada por una firma de confianza!
gpg:          No hay indicios de que la firma pertenezca al propietario.
Huellas dactilares de la clave primaria: B3A2 BCDF 9FFB 9991 A737  4A36 9241 A986 C5CB 7445

# tengo la publica y esta firmada (Todo OK)
user2@pc02:~$ gpg --verify /tmp/missatge.pem
gpg: Firmado el lun 17 feb 2020 20:17:18 CET
gpg:                usando RSA clave B3A2BCDF9FFB9991A7374A369241A986C5CB7445
gpg: Firma correcta de "user1 edt (cc) <user1@edt.org>" [total]
```

#### Confianza

Con la confianza se tiene que tener cuidado y por eso existen diferentes modos.

```bash
user3@pc02:~$ gpg --edit-key user1@edt.org
pub  rsa3072/9241A986C5CB7445
     creado: 2020-02-11  caduca: nunca       uso: SC  
     confianza: desconocido   validez: desconocido
```

**Validez**: Por un lado esta la validez que es el yo confío en ese emisor, y lo activamos firmando la clave publica.

**Confianza (TRUST)**: trust significa, confío en los amigos de este usuario? es decir, confío en las claves publicas que tiene este usuario de otros usuarios? Esto pasa porque al importar, puedes importar múltiples claves de un mismo usuario.

Por esa complejidad tiene diferentes niveles de confianza.

```bash
  1 = No lo sé o prefiero no decirlo
  2 = NO tengo confianza
  3 = Confío un poco # confío si 6 de los que yo confío, confían en ti.
  4 = Confío totalmente # confío si 3 de los que yo confío, confían en ti.
  5 = confío absolutamente
  m = volver al menú principal
```



### Eliminar claves

Eliminar todas las llaves de un usuario

```bash
user2@pc02:~$ gpg --list-keys
/home/user2/.gnupg/pubring.kbx
------------------------------
pub   rsa3072 2020-02-11 [SC] [caduca: 2022-02-10]
      3E409CD05DEEAB9583410521A7005DFA20B44BD3
uid        [  absoluta ] user2 edt <user2@edt.org>
sub   rsa3072 2020-02-11 [E] [caduca: 2022-02-10]

pub   rsa3072 2020-02-17 [SC]
      62811DDBE923D412B65AE99D1286DEC624F83F1A
uid        [desconocida] user3 edt <user3@edt.org>
sub   rsa3072 2020-02-17 [E]

pub   rsa3072 2020-02-11 [SC]
      B3A2BCDF9FFB9991A7374A369241A986C5CB7445
uid        [   total   ] user1 edt (cc) <user1@edt.org>
sub   rsa3072 2020-02-11 [E]

user2@pc02:~$ gpg --delete-keys user1@edt.org
```



Eliminar una clave de un usuario

```bash
user2@pc02:~$ gpg --edit-key user3@edt.org
...
pub  rsa3072/1286DEC624F83F1A
     creado: 2020-02-17  caduca: nunca       uso: SC  
     confianza: desconocido   validez: desconocido
sub  rsa3072/A34F8119A219F135
     creado: 2020-02-17  caduca: nunca       uso: E   
[desconocida] (1). user3 edt <user3@edt.org>

gpg> key 1

pub  rsa3072/1286DEC624F83F1A
     creado: 2020-02-17  caduca: nunca       uso: SC  
     confianza: desconocido   validez: desconocido
sub* rsa3072/A34F8119A219F135
     creado: 2020-02-17  caduca: nunca       uso: E   
[desconocida] (1). user3 edt <user3@edt.org>

gpg> delkey
¿De verdad quiere borrar esta clave? (s/N) s

pub  rsa3072/1286DEC624F83F1A
     creado: 2020-02-17  caduca: nunca       uso: SC  
     confianza: desconocido   validez: desconocido
[desconocida] (1). user3 edt <user3@edt.org>
```






