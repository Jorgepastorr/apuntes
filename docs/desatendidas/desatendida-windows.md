desatendida windows

[TOC]



## Formas de crear

Tenemos 3 maneras de crear una desatendida en windows 

1. ntlite un programa que tiene versión gratuita y de pago.

2. 1. Muy fácil de usar
   2. En gratuito no puedes modificar discos y particiones, por defecto utiliza todo el disco.
   3. Muy recomendable si quieres instalar en todo el disco.

3. adk es la actualización de aik.

4. 1. Difícil manejo hay que tener conocimientos de controladores o mirar mucha documentación de ayuda.
   2. En este caso partiremos de una plantilla.
   3. Todas las posibilidades de configuración.

5. Crear archivo AutoUnattend.xml manualmente.

6. 1. Nivel dios todo poderoso, hay que dedicarle muchas horas a documentarse.
   2. Esta manera la evitaremos.



## Links de descarga

[ntlite](https://www.ntlite.com/download/)

[Windows Assessment and Deployment Kit  ( adk )](https://developer.microsoft.com/es-es/windows/hardware/windows-assessment-deployment-kit)

[Kit de instalación automatizada de Windows ( waik )](https://www.microsoft.com/es-es/download/details.aspx?id=5753)



## Ntlite

Empecemos por lo fácil.

### 1 Descargar herrmientas

Descargar ntlite e instalar, no tiene complicación.

Descargamos iso de windows



### 2 Abrir iso y copiar en carpeta

Clic derecho en la iso descargada y descomprimir en carpeta.

En mi caso la iso se llama win10 y “extraer en carpeta win10/”

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/descomprimiendo-iso.png)



### 3 abrir ntlite y añadir imagen

click en añadir → buscar carpeta que hemos descomprimido la imagen.

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/añadiendo-imagen-nt.png)



### 4 abrir windows que configurar 

En mi caso la iso solo tiene windows 10 home pero si os descargais una iso de microsoft tendrá varias versiones del windows elegido 

Tarda unos minutos lo aviso entre 2 y 4 normalmente

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/abriendo-iso-nt.png)



### 5 Configurar iso

 A continuación nos saldrá una barra lateral con las diferentes opciones de configuración.

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/barra-lateral.png)

Tenemos varias opciones útiles por aquí:



#### Eliminar

eliminar/componentes → podemos eliminar las app de windows por defecto tipo bing o twitter etc..



#### Configurar

configurar/configurar → podemos poner que pregunte antes de descargar actualizaciones por ejemplo, entre muchas otras cosas.

configura/servicios → activas y desactivas servicios por defecto



#### Integrar

integrar/actualizaciones → si te descargas aplicaciones manualmente puedes añadirlas para que el sistema las integre en la instalación.

integrar/controladores → añades drivers de los dispositivos deseados.



#### Automatizar

Aquí es la sección donde evitamos que sea un pesado el instalador preguntandonos pasos.



##### Automatizar/desatendido

Primero marcamos pestaña activar arriba a la izquierda.

Seguiremos añadiendo, idioma, idioma teclado, saltar ventanas, zona horaria, usuarios, etc..

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/config-auto-1.png)

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/config-auto-2.png)

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/config-auto-3.png)

En mi caso hecho una configuración simple sin clave de activación, si se desea activar windows es muy intuitivo solo hay que añadir dicha clave en los casillas correspondientes.

Podremos configurar casi todo menos las particiones ya que estamos utilizando versión gratuita, en la versión de pago eres libre a partir de 40€ actualmente.



##### Postinstalación

Aquí nos permite agregar scripts o ejecutables para que se instalen justo después de la instalación.

En mi caso he añadido el ejecutable de firefox.

Añadir → seleccionas ejecutable

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/powst-inst.png)



#### Final

Por último nos queda montar la iso en el apartado aplicar.

Seleccionamos crear iso y procesar.

Tardará un rato es un poco lento unos 5 - 10 minutos.

Pero bueno es tiempo que nos ahorraremos en un futuro instalando.

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/nt/final.png)

Una vez creada la iso solo nos queda quemarla en un pen o insertar en máquina virtual y a esperar que se instala todo solito.



## ADK

ADK nos genera un archivo AutoUnattend.xml que luego añadiremos a la raíz de la iso.



### Descargar herrmientas

Descargar adk e instalar

Descargamos iso de windows



### Montamos imagen en carpeta

click derecho en imágen extraer en carpeta a elegir



### abrimos ADK

administrador de imágenes de sistemas de windows

Nombre cortito han elegido



### Empezar a configurar



#### Extraer imagen

En el recuadro inferior izquierdo “Imagen de windows”

- click derecho seleccionar imagen de windows
- Buscamos en la carpeta que hemos extraído la iso el archivo install.wim
- ~/imagen/sources/install.wim

Tardara un poco, paciencia.



#### Archivo de respuesta

En el recuadro superior central “Archivo de respuesta”

- click derecho seleccionar nuevo archivo de respuesta

Quedará así.

![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/adk.png)

Abajo todos los componentes a añadir al archivo y arriba iremos configurando lo requerido.



#### Añadir componentes a archivo de respuesta

Para añadir un componente click derecho sobre el y seleccionamos la posición a insertar.



##### 1 windowsPE

```
International-core-winPe-neutral/setupUILanguage
windows-setup-neutral/diskConfiguration/disk/createPartition
windows-setup-neutral/diskConfiguration/disk/ModifiPartition
windows-setup-neutral/imageinstall/osimage/installTo
windows-setup-neutral/UserData/ProductKey
```



##### 2 offlineServicing

```
Windows-Lua-Settings-neutral
```



##### 3 generalize

```
Windows-Securiti-SPP-neutral
```



##### 4 specialize

```
Windows-International-core-neutral
Windows-Security-SPP-UX-neutral
Windows-Shell-setup-neutral
Windows-SQMApi-neutral
```



##### 7 oobeSystem

```
Windows-Shell-Setup-neutral/Autolog/Password
(esta opción si quieres añadir comandos al final de la instalación)
	- Windows-Shell-Setup-neutral/FirstLogonCommands/SyschronousCommand  

Windows-Shell-Setup-neutral/OOBE
Windows-Shell-Setup-neutral/UserAcounts/localAccounts
```



#### Configurar componentes

( Para ver la ayuda de los parámetros a configurar click derecho ayuda)

Como es muy largo de explicar dejo el archivo de respuesta comentado a continuación y buscamos poco a poco cada parámetro.

También puedes copiar el siguiente archivo, abrirlo como Autounattend.xml y modificar al gusto, es algo complejo al principio.

[AutoUnattend.xml](./autounattend.xml)

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

            <!--       Idioma de teclado e instalación -->
            
            <SetupUILanguage>
                <UILanguage>es-ES</UILanguage>
            </SetupUILanguage>
            <InputLocale>040a:0000040a</InputLocale>
            <SystemLocale>es-ES</SystemLocale>
            <UILanguage>es-ES</UILanguage>
            <UILanguageFallback>es-ES</UILanguageFallback>
            <UserLocale>es-ES_tradnl</UserLocale>
        </component>
        <!--    fin   Idioma de teclado e instalación -->
        
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DiskConfiguration>
                <Disk wcm:action="add">
                    <ModifyPartitions>
                        <ModifyPartition wcm:action="add">
<!--                            Active que sea la partición activa al arrancar-->
                            <Active>true</Active>
                            <Format>NTFS</Format>
                            <Label>os</Label>
                            <Letter>C</Letter>
                            <Order>1</Order>
                            <PartitionID>1</PartitionID>
                        </ModifyPartition>
                    </ModifyPartitions>
                    <CreatePartitions>
                        <CreatePartition wcm:action="add">
<!--                      extend      Que ocupe todo el disco-->
                            <Extend>true</Extend>
                            <Order>1</Order>
                            <Type>Primary</Type>
                        </CreatePartition>
                    </CreatePartitions>
<!--                    disco 0  -->
                    <DiskID>0</DiskID>
<!--                    borre todo el disco-->
                    <WillWipeDisk>true</WillWipeDisk>
                </Disk>
            </DiskConfiguration>
            <ImageInstall>
                <OSImage>
                    <InstallTo>
<!--                        Instalar en disco 0 partición 1-->
                        <DiskID>0</DiskID>
                        <PartitionID>1</PartitionID>
                    </InstallTo>
<!--                    Especifica que se instalara windows en las paticiones que e descrito-->
                    <InstallToAvailablePartition>false</InstallToAvailablePartition>
                </OSImage>
            </ImageInstall>
            <UserData>
                <ProductKey>
                    <Key>W269N-WFGWX-YVC9B-4J6C9-T83GX</Key>
                </ProductKey>
<!--                especifica que se acepta automaticamente la clave-->
                <AcceptEula>true</AcceptEula>
                <FullName>admin</FullName>
            </UserData>
        </component>
    </settings>
    <settings pass="offlineServicing">
        <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <EnableLUA>false</EnableLUA>
        </component>
    </settings>
    <settings pass="generalize">
        <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!--            Especifica que la licenciab no cambiaa y es valida-->
            <SkipRearm>1</SkipRearm>
        </component>
    </settings>
    <settings pass="specialize">
        <component name="Microsoft-Windows-International-Core" processorArchitecture="wow64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!--            Idioma del usuario final-->
            <InputLocale>040a:0000040a</InputLocale>
            <SystemLocale>es-ES_tradnl</SystemLocale>
            <UILanguage>es-ES_tradnl</UILanguage>
            <UILanguageFallback>es-ES_tradnl</UILanguageFallback>
            <UserLocale>es-ES_tradnl</UserLocale>
        </component>
        <component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="wow64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!--            especifico que activo manualmente mediante key-->
            <SkipAutoActivation>true</SkipAutoActivation>
        </component>
        <component name="Microsoft-Windows-SQMApi" processorArchitecture="wow64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <CEIPEnabled>0</CEIPEnabled>
        </component>
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="wow64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ComputerName>mv-virt-w10</ComputerName>
            <ProductKey>W269N-WFGWX-YVC9B-4J6C9-T83GX</ProductKey>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="wow64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <AutoLogon>
                <Password>
                    <Value>YQBkAG0AaQBuAFAAYQBzAHMAdwBvAHIAZAA=</Value>
                    <PlainText>false</PlainText>
                </Password>
                <Username>admin</Username>
                <Enabled>false</Enabled>
            </AutoLogon>
            <OOBE>
<!-- Especifica que no se muestra la página Términos de licencia de software de Microsoft de bienvenida de Windows.-->
                <HideEULAPage>true</HideEULAPage>
<!--                Oculta la página de registro OEM durante OOBE.-->
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
<!--                Oculta la página de inicio de sesión durante OOBE.-->
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
<!--                Oculta la pantalla Unirse a la red inalámbrica durante la Bienvenida de Windows.-->
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
<!--                tipo de red-->
                <NetworkLocation>Home</NetworkLocation>
                <SkipUserOOBE>true</SkipUserOOBE>
                <SkipMachineOOBE>true</SkipMachineOOBE>
<!--                desactivar la configuración de Express-->
                <ProtectYourPC>3</ProtectYourPC>
            </OOBE>
            <UserAccounts>
<!--                añado usuiarios -->             
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value>YQBkAG0AaQBuAFAAYQBzAHMAdwBvAHIAZAA=</Value>
                            <PlainText>false</PlainText>
                        </Password>
                        <Name>admin</Name>
                        <Group>administrators</Group>
                        <DisplayName>admin</DisplayName>
                    </LocalAccount>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value>dQBzAGUAcgBQAGEAcwBzAHcAbwByAGQA</Value>
                            <PlainText>false</PlainText>
                        </Password>
                        <Name>user</Name>
                        <Group>user</Group>
                        <DisplayName>user</DisplayName>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
            <RegisteredOwner>admin</RegisteredOwner>
            <DisableAutoDaylightTimeSet>false</DisableAutoDaylightTimeSet>
<!--                zona horaria -->            
          	<TimeZone>Romance Standard Time</TimeZone>
<!--                comandos que quiero que ejecute despues de la imnstalación -->         
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <Order>4</Order>
                    <RequiresUserInput>false</RequiresUserInput>
<!--              dentro de la iso e creado una carpeta que contiene firefox.exe-->                  
                    <CommandLine>D:\aplicaciones\firefox.exe</CommandLine>
                    <Description>intala firefox</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>desabilitar updates</Description>
                    <RequiresUserInput>false</RequiresUserInput>
                    <CommandLine>reg add &quot;HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update&quot; /v AUOptions /t REG_DWORD /d 4 /f</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <RequiresUserInput>true</RequiresUserInput>
                    <Description>vision panel control</Description>
                    <CommandLine>reg add &quot;HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel&quot; /v StartupPage /t REG_DWORD /d 1 /f</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <Description>tamaño icono panel</Description>
                    <RequiresUserInput>false</RequiresUserInput>
                    <CommandLine>reg add &quot;HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel&quot; /v AllItemsIconView /t REG_DWORD /d 0 /f</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>5</Order>
                    <Description>instala ccleaner</Description>
                    <RequiresUserInput>true</RequiresUserInput>
                    <CommandLine>D:\aplicaciones\ccleaner.exe /S</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>Get-AppxPackage *CandyCrushSodaSaga* | Remove-AppxPackage</CommandLine>
                    <Description>borrar candy</Description>
                    <Order>6</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>7</Order>
                    <CommandLine>powershell Remove-AppxPackage  9E2F88E3.Twitter_5.8.1.0_x86__wgeqdkkx372wm</CommandLine>
                    <Description>borrar twiter</Description>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
            </FirstLogonCommands>
        </component>
    </settings>
    <cpi:offlineImage cpi:source="wim://pc-jorge/downloads/iso&apos;s/windows10-2/sources/install.wim#Windows 10 Home" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
```



#### Desinstalar app y desabilitar updates

En la sección

- Windows-Shell-Setup-neutral/FirstLogonCommands/SyschronousCommand  

Podemos insertar diferentes comandos por ejemplo:

Deshabilitar auto updates.

Desinstalar app instaladas por defecto:

**Opciones  app a desinstalar sin que afecte al sistema**

```powershell
Get-AppxPackage *3dbuilder* | Remove-AppxPackage
Get-AppxPackage *windowsalarms* | Remove-AppxPackage
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage
Get-AppxPackage *zunemusic* | Remove-AppxPackage
Get-AppxPackage *zunevideo* | Remove-AppxPackage
Get-AppxPackage *onenote* | Remove-AppxPackage
Get-AppxPackage *people* | Remove-AppxPackage
Get-AppxPackage *windowsstore* | Remove-AppxPackage
Get-AppxPackage *xboxapp* | Remove-AppxPackage
Get-AppxPackage *CandyCrushSodaSaga* | Remove-AppxPackage
Get-AppxPackage *Twitter* | Remove-AppxPackage
Get-AppxPackage *WindowsMaps* | Remove-AppxPackage
Get-AppxPackage *BingFinance* | Remove-AppxPackage
Get-AppxPackage *BingSports* | Remove-AppxPackage
Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage *MicrosoftSolitaireCollection* | Remove-AppxPackage
Get-AppxPackage *Sway* | Remove-AppxPackage
Get-AppxPackage *SkypeApp* | Remove-AppxPackage
```



#### Guardar archivo en iso y montar

Por último ya solo queda guardar el archivo en la raíz de la iso y montar.

**Abrimos:**

Entorno de herramientas de implementación y creación imágenes

Comando para montar.

```shell
oscdimg -n -m -bF:\Users\jorge\Downloads\iso's\win10\boot\etfsboot.com F:\Users\jorge\Downloads\iso's\win10 F:\Users\jorge\Downloads\win10.iso
```



**Explicacion:**

oscdimg -n -m -bF:\Users\jorge\Downloads\iso's\win10\boot\etfsboot.com

- Es la ruta al archivo booteable de dentro de la iso

F:\Users\jorge\Downloads\iso's\win10

- Es la dirección de la carpeta de la iso

F:\Users\jorge\Downloads\win10.iso

- Dirección donde creo la nueva iso



![img](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/comando-ter.png)