#!/bin/bash

# This script will update a spigot server 

# Define the startup script
START=start.sh
# Define the backup for the startup script (in case of rollback) 
BAK=startup-script-pre-$1
# Define where to store the previous version (in case of rollback)
PREV=previous_versions
# Define the URL to grab
URL=https://cdn.getbukkit.org/spigot/spigot-"$1".jar
HOME=/home/minecraft
HOME_BACKUP=/home/minecraft-pre-update

# Script starts here

# Check URL
wget --spider $URL
# Continue if the URL exists and the input is a number
if [ $? -gt -1 ] && [ -n "$1" ] ; then
  echo "Removing last backup ... ($HOME_BACKUP)"
  sudo rm -rf $HOME_BACKUP
  echo "Backing up current version ($HOME)"
  sudo cp -R $HOME $HOME_BACKUP
	echo "moving `ls s*.jar` to $PREV"
	sudo mv s*.jar $PREV/.
	echo "retrieving $URL"
  # Get the new version of Spigot
	sudo wget -nc $URL
  # Copy and update file properties
	sudo cp $START $PREV/$BAK 
	sudo chmod 400 $PREV/$BAK
  # Modify the start script
	sudo chmod 777 $START 
	sudo echo "#!/bin/bash" > $START
	sudo echo "sudo java -Xmx6G -Xms4G -jar /home/minecraft/spigot-$1.jar nogui > /dev/console" >> $START
	sudo chmod 755 $START
	echo "'sudo reboot' to take effect with version $1"
  # Done!
else
	if [ -n "$1" ]; then
    echo "Error: Version number $1 doesn't exist at $URL"
  else
    echo "Error: Needs version number on invoke"
  	echo "example $0 1.10"
  fi
fi
