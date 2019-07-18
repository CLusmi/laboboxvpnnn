#!/bin/bash

IP=`wget -qO- ipv4.icanhazip.com`
TOKEN=%token%
DL=/home/labobox/docker_apps/plex
LOG=/home/labobox/docker_apps/plexplex_dl.log

cd /home/labobox/docker_apps/plex

echo "#################################################################################" >> $LOG
echo "#" >> $LOG
echo "# $(date)" >> $LOG
echo "#" >> $LOG
echo "# Nous regardons si vous visionnez actuellement sur Plex." >> $LOG
sessions=$(curl http://$IP:32400/status/sessions?X-Plex-Token=$TOKEN | grep "MediaContainer size" | awk -F'[\"]' '{print $2}')
if (($sessions < 1))
then
echo "#" >> $LOG
echo "# Aucunes videos sont lues actuellement, nous passons à la suite du script." >> $LOG
echo "#" >> $LOG
echo "# Téléchargement de la derniere version disponible de PlexMediaServer." >> $LOG
wget -O $DL/plex.deb "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=$TOKEN" >> $LOG
echo "#" >> $LOG
echo "# Comparaison de la version installé et de la version télécharger." >> $LOG
newplex="$(dpkg -I $DL/plex.deb | grep Version | awk '{print $2}' | awk -F'[ -]' '{print $1}')"
currentplex="$(dpkg -l | grep plexmediaserver | awk '{print $3}' | awk -F'[ -]' '{print $1}')"
echo "# La version actuellement installé est : $currentplex" >> $LOG
echo "# La version télécharger est : $newplex" >> $LOG
/usr/bin/dpkg --compare-versions $newplex gt $currentplex
if (($? < 1))
then
        echo "#" >> $LOG
        echo "# $newplex est plus reçent que $currentplex" >> $LOG
        echo "# Installation de la nouvelle version de PlexMediaServer." >> $LOG
        echo "#" >> $LOG
        service plexmediaserver stop
        sleep 3
        /usr/bin/dpkg -i $DL/plex.deb >> $LOG
        sleep 3
        service plexmediaserver restart
        echo "#" >> $LOG
        echo "# Nous rennomons la version télécharger en : plex.$newplex.deb" >> $LOG
        mv $DL/plex.deb $DL/plex.$newplex.deb
        echo "#" >> $LOG
else
        echo "#" >> $LOG
        echo "# $newplex n'est pas plus reçent que $currentplex" >> $LOG
        echo "# Suppression de la version télécharger." >> $LOG
        rm $DL/plex.deb
fi
else
echo "#" >> $LOG
echo "# Une video est en cours de lecture, nous abandonnons le script." >> $LOG
fi
echo "#" >> $LOG
echo "#" >> $LOG
echo "#################################################################################" >> $LOG

cat $LOG
