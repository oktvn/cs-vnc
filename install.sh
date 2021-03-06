#!/bin/bash

#cd ${HOME}

mkdir -p ${HOME}/.config/
mkdir -p ${HOME}/.cloudshell/
sudo mkdir -p /opt/cs-vnc
touch ${HOME}/.cloudshell/no-apt-get-warning
sudo apt-get update
sudo apt-get install -y supervisor xvfb openbox x11vnc dbus-x11 libdbus-glib-1-2
sudo apt-get install -y lxpanel pcmanfm --no-install-recommends

echo "Cloning noVNC and Websockify..."
echo
{
sudo git clone git://github.com/kanaka/noVNC /opt/noVNC/
sudo git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify
}&> /dev/null

sudo cp /opt/noVNC/vnc.html /opt/noVNC/index.html 

# Copy supervisord configuration to proper configuration directory
echo "Configuring supervisord..."
echo

cp ./conf/supervisord.conf ${HOME}/.config/supervisord.conf

echo "Configuring pcmanfm..."
echo

sudo cp ./misc/cs-vnc-default.png /opt/cs-vnc/
cp -r ./conf/pcmanfm/ ${HOME}/.config/pcmanfm/

# Creating proper directory for the script
echo "Installing run script..."
echo

# Copy the run script to proper /opt/ directory
sudo cp ./src/run.sh /opt/cs-vnc/cs-vnc.sh
sudo cp ./src/desktop.sh /opt/cs-vnc/desktop.sh

sudo ln -sf /opt/cs-vnc/cs-vnc.sh /usr/local/bin/cs-vnc

echo
echo "Installation finished."
echo "Usage: just run the 'cs-vnc' command and open Web Preview on port 8080 (default)."
echo "WARNING: If this script is being run on a Google Cloud Shell, you have to re-run install.sh again if the container dies."
echo
