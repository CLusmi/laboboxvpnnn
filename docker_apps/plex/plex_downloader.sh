#!/bin/bash

IP=`wget -qO- ipv4.icanhazip.com`
TOKEN=%token%
DL=/home/labobox/docker_apps/plex
LOG=/home/labobox/docker_apps/plex/plex_scripts.log

cd /home/labobox/docker_apps/plex

echo "#################################################################################" >> $LOG
echo "#" >> $LOG
echo "# Téléchargement de la derniere version disponible de PlexMediaServer." >> $LOG
wget -O $DL/plex.deb "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=$TOKEN" >> $LOG
echo "#" >> $LOG
echo "# Installation de la derniere version disponible de PlexMediaServer." >> $LOG
    /usr/bin/dpkg -i $DL/plex.deb >> $LOG
echo "#" >> $LOG
echo "# Suppression de la version telecharger." >> $LOG
	rm -rf $DL/plex.deb
echo "#" >> $LOG
echo "# La derniere version de PlexMediaServer a été installée !" >> $LOG
echo "#" >> $LOG
echo "#################################################################################" >> $LOG

cat $LOG
