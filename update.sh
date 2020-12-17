#!/bin/bash

start=start.sh
bak=start-pre-$1
prev=previous_versions
url=https://cdn.getbukkit.org/spigot/spigot-"$1".jar
wget --spider $url
echo "removing last backup ..."
sudo rm -rf /home/minecraft-pre-update
echo "backing up current version"
sudo cp -R /home/minecraft /home/minecraft-pre-update
if [ $? -gt -1 ] && [ -n "$1" ] ; then
	echo "moving `ls s*.jar` to $prev"
	sudo mv s*.jar $prev/.
	echo "retrieving $url"
	sudo wget -nc $url
	sudo cp $start $prev/$bak 
	sudo chmod 400 $prev/$bak
	sudo chmod 777 $start 
	sudo echo "#!/bin/bash" > $start
	sudo echo "sudo java -Xmx6G -Xms4G -jar /home/minecraft/spigot-$1.jar nogui > /dev/console" >> $start
	sudo chmod 755 $start
	echo "'sudo reboot' to take effect with version $1"
else
	echo "needs version number on invoke"
	echo "example $0 1.10"
fi
