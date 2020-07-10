# README #

Version en produccion 1.0.0
***Es de uso privado no redistribuir fuera del ecocistema de aplicaciones actual!!!!!!!

### Reproductor de Anuncios Flotantes ###

*Este es el primer boceto del Algoritmo para colocar videos en la capa superior del display con un fade in

### ¿Como instalarlo? ###
Utima Actualizacion de todo 15-XI-2017

### En automatico ###


bash install.sh


### A pata ###



1.-Realizar la configuración normal de la memoria
     La memoria del GPU split se debe poner a 256mb en lugar de 128

2- Instalar lsof

sudo apt-get install lsof

4.-Editar lo siguiente en el script de uxmal.

apagar el black screen en versiones con ucp

sudo vim uxmalstream/index.js

buscar la linea 82 y cambiar el valor de -b de "true" a "false"

5.- instalar el servicio copiando el archivo "AdsPlayer" en "/etc/init.d/"

sudo cp /home/uslu/adsplayer/AdsPlayer /etc/init.d/AdsPlayer

dar permisos de ejecucion :P

sudo chmod +x /etc/init.d/AdsPlayer

despues lanzar el comando

sudo update-rc.d AdsPlayer defaults

y probar si el servicio arranca con: sudo service AdsPlayer start

instalar en el crontab la linea :

@reboot sudo bash /home/uslu/gsign/cclauncher.sh

### Contribution guidelines ###

*Si quieres aportar primero realiza un nuevo branch o enviame los .diff del proyecto

### ¿Tienes problemas? ###

--Antes de abrir un ticket de incidencia por favor realiza lo siguiente:

*Actualiza todo el sistema operativo.
*Descarga la version mas actual de este repo.
*Verifica tus videos y sus tiempos de carga.
*Verifica que los videos cumplan con el perfil de Uxmal en handbreak.

En el repo hay un brach de mirai works si hay problemas de rendimiento usar ese repo junto con sus binarios OMXplayer y BroadcomShell 


Copyright 2017 Gustavo Santana
(C)2017 Mirai Works LLC

