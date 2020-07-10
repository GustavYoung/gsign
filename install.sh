#!/bin/bash
#Copyright 2019-2020 Gustavo Santana
#(C) Mirai Works LLC
#tput setab [1-7] Set the background colour using ANSI escape
#tput setaf [1-7] Set the foreground colour using ANSI escape
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
white=`tput setaf 7`
bg_black=`tput setab 0`
bg_red=`tput setab 1`
bg_green=`tput setab 2`
bg_white=`tput setab 7`
ng=`tput bold`
reset=`tput sgr0`
#echo "${red}red text ${green}green text${reset}"

sleep 1;

# Nombre de instancia para que no choque con la de uxmalstream
SERVICE="CC_installer_V3";
echo "${red}${bg_white}${ng}Comenzando instalacion...${reset}"
cd /home/uslu/;
echo "Instalando Servicios..."
sudo cp /home/uslu/gsign/miraiCart /etc/init.d/miraiCart;
yes | cp Llayer_utils/sync.cfg gsign
echo "Setting Perms"
sudo chmod +x /etc/init.d/miraiCart;
echo "Reb Cache"
sudo update-rc.d miraiCart defaults;
sleep 2;
reset;
clear;
echo "${red}${bg_white}${ng}Reemplaza "uxm-usuario" por"
echo "el usuario del cliente ejemplo:uxm-heineken"
echo "."
echo "verifica que todo este bien y solo da :q"
read -p "Presiona ENTER cuando estes listo para editar el archivo.${reset}"
sudo vim /home/uslu/gsing/sync.cfg;
reset;
clear;
echo "${red}${bg_white}${ng}Instala la sig. configuracion del crontab"
echo "@reboot sudo bash /home/uslu/gsign/cclauncher.sh"
echo ""
read -p "Presiona ENTER cuando estes listo para editar el crontab. ${reset}"
sudo crontab -e;
reset;
clear;
echo "${red}${bg_white}${ng}Se va a lanzar el sincronizador manualmente"
echo "en caso necesario confirma la llave escribiendo yes"
echo "y pulsando ENTER revisa que los archivos sean correctos ${reset}"
sudo bash /home/uslu/gsign/realtime.sh
sleep 5;
reset;
clear;
echo "Actualizando Parche v3"
echo ""
read -p "Eso es todo. Presiona ENTER para salir."