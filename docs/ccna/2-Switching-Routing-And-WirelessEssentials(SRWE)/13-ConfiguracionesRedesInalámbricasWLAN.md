# Configuraciones de redes inalámbricas WLAN

## Configuración de WLAN de sitio remoto

### Configuración de red básica

La configuración básica de la red incluye los siguientes pasos:

- Iniciar sesión en el router desde un navegador web
- Cambiar la contraseña de administrador predeterminada.
- Iniciar sesión con la nueva contraseña administrativa
- Cambiar las direcciones IPv4 predeterminadas del DHCP
- Renovar la dirección IP.
- Iniciar sesión en el router con la nueva dirección IP.

La configuración básica de la red inalámbrica incluye los siguientes pasos:

- Ver los valores predeterminados de WLAN
- Cambiar el modo de red, identificando qué el estándar 802.11 se implemente.
- Configurar el SSID
- Configurar el canal, asegurándose de que no haya canales superpuestos en uso.
- Configurar el modo de seguridad, seleccionando entre Open, WPA, WPA2 Personal, WPA2 Enterprise, etc..
- Configurar la frase de contraseña, según sea necesario para el modo de seguridad seleccionado.

### Configurar una red de malla inalámbrica


Si desea extender el alcance más allá de aproximadamente 45 metros en interiores y 90 metros en exteriores, cree una malla inalámbrica. 

Cree la malla agregando puntos de acceso con la misma configuración, excepto que use diferentes canales para evitar interferencias.

La extensión de una WLAN en una oficina pequeña o en el hogar se vuelve cada vez más fácil. 

Los fabricantes han creado una red de malla inalámbrica (WMN) simple a través de aplicaciones de teléfono inteligente. 

### Calidad de servicio

Muchos routers domésticos y de oficinas pequeñas tienen una opción para configurar la calidad de servicio (QoS). 

Al configurar la QoS, puede garantizar que ciertos tipos de tráfico, como voz y video, tengan prioridad respecto del tráfico sin plazos, como el correo electrónico y la navegación web. 

En algunos routers inalámbricos, también se puede priorizar el tráfico en puertos específicos.


## Configure una WLAN básica en el WLC

### Topología de WLC

El punto de acceso (AP) es un AP basado en el controlador en lugar de un AP autónomo, por lo que no requiere configuración inicial y a menudo se denomina AP ligero (LAPs). 

Los puntos de acceso LAPs usan el Protocolo Lightweight Access Point Protocol (LWAPP) para comunicarse con el controlador WLAN (WLC). 

Los AP basados en controladores son útiles en situaciones en las que se requieren muchos AP en la red. 

Conforme se agregan puntos de acceso, cada punto de acceso es configurado y administrado de manera automática por el WLC.

### Inicie sesión en el WLC

Configurar un controlador de red inalámbrica (WLC) no es muy diferente que configurar un router inalámbrico El WLC controla los AP y proporciona más servicios y capacidades de gestión.

- El usuario inicia sesión en el WLC utilizando credenciales que se configuraron durante la configuración inicial.
- Lapágina de resumen de red es un panel que proporciona una descripción general rápida de las redes inalámbricas configuradas, los puntos de acceso asociados (AP) y los clientes activos. 
- También puede ver la cantidad de puntos de acceso no autorizados y clientes.


## Configure una red inalámbrica WLAN WPA2 Enterprise en el WLC

### SNMP y RADIUS

La PC-A está ejecutando el software del servidor Simple Network Management Protocol (SNMP) y el servicio de autenticación remota de acceso telefónico (RADIUS). 

El administrador de red quiere que el WLC reenvíe todos los mensajes de registro SNMP (es decir, trampas) al servidor SNMP.

El administrador de la red quiere usar un servidor RADIUS para los servicios de autenticación, autorización y contabilidad (AAA). 

Los usuarios ingresarán sus credenciales de nombre de usuario y contraseña que serán verificadas por el servidor RADIUS. 

El servidor RADIUS se necesita para las redes WLAN que están usando autenticación WPA2 Enterprise.


