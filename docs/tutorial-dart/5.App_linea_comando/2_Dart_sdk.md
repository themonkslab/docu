---
sidebar_position: 2
---

# Dart SDK

_SDK_ o _software development kit_ es una serie de __herramientas que utilizamos para escribir software o programas.__ Por lo general, contienen:

- Compiladores
- Analizadores
- Debuggers o herramientas para detectar _bugs_ o errores
- Librerías
- Framework

Tenemos que entender que instalando el Dart SDK, podemos crear aplicaciones para terminal o línea de comando, para servidores y aplicaciones que no sean Flutter; para esto último tendremos que instalar el Flutter SDK (siguiente curso!). Sin embargo, si instalamos el SDK de Flutter, este incluye el de Dart!

## Instalando el Dart SDK

Este SDK es soportado por Windows (10 o superior), Mac (11 o superior) y Linux (Debian y Ubuntu estables).

Dijimos estables y esto también aplica a Dart. Qué significa? Estamos hablando de los distintos canales en donde el código se lanza y cada uno refiere a su estado actual:

- __Estable__ es aquél que está listo para producción y se actualiza, en el caso de Dart, cada aproximadamente tres meses.
- __Beta__ está creado para testear características que están a punto de salir a producción o al _stable channel_ (canal estable). Se actualiza una vez por mes.
- __Dev__ es en donde se crean cosas nuevas, muchas de ellas aun rotas y no tiene ningún tipo de soporte. Se actualiza generalmente dos veces por semana.

### En Windows

Para esta instalación lo primero que haremos será instalar el [chocolatey package manager](https://chocolatey.org/install) y para ello utilizaremos  _Windows PowerShell_.

Ejecuten el _Power Shell_ como administradores y tal como indica la web de _chocolatey_ corran el siguiente comando:`Get-ExecutionPolicy`, y si les devuelve _Restricted_ ejecuten además `Set-ExecutionPolicy AllSigned` diciendo que si a todo.

Luego ejecuten el comando:
`Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`

![chocolatey y PowerShell](5.2.1_chocolatey_and_PowerShell.png)

Listo! ya instalamos el _chocolatey package manager_ y estamos listos para instalar el __Dart SDK__. Para ello iremos a este [link](https://community.chocolatey.org/packages) y buscaremos el paquete de Dart SDK en su versión mas estable.

![Dart SDK Package](5.2.2_DartSDK_package.png)

Cierren el _Windows PowerShell_ y vuelvan a ejecutarlo como administrador, y ahora ejecuten el comando: `choco install dart-sdk` y esperen unos minutos. Cuando haya terminado, cierren, vuelvan a abrir y si ejecutan el comando `dart` les debería de aparecer lo siguiente:

![Dart command in PowerShell](5.2.3_Dart_command_in_PowerShell.png)

Listo! el Dart SDK ya está instalado en Windows, ahora nos queda VS Code, pero en el próximo artículo 👍.

### En Mac

### En Linux
