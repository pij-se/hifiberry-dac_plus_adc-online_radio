#!/bin/sh
# https://github.com/pij-se/hifiberry-dac_plus_adc-online_radio/setup.sh
# 
# Raspbery Pi 4, HiFiBerry DAC+ ADC, with Icecast2 and Darkice, for local network online radio.
# Copyright (c) 2023 Johan Palm <johan@pij.se>
# All rights reserved.
# Published under the GNU General Public License v3.0.

# Update Raspberry Pi OS packages
echo "Checking for updates..."
sudo apt update
echo "Downloading and installing updates..."
sudo apt upgrade -y

# Install Icecast2
echo "Installing Icecast2..."
sudo apt install icecast2 -y

# Download, configure, and install Darkice
echo "Installing Darkice..."
sudo apt install libasound2-dev -y
sudo apt install libvorbis-dev -y
sudo apt install libmp3lame-dev -y
wget https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz
tar -xvkf darkice-1.4.tar.gz
cd darkice-1.4/
./configure --with-alsa --with-vorbis --with-lame-prefix=/usr/lib/arm-linux-gnueabihf/
sudo make install
sudo make clean
cd ..
rm -r ./darkice-1.4
sudo systemctl enable darkice

# Reboot
sudo reboot
