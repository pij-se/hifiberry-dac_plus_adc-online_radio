#!/bin/sh
# https://github.com/pij-se/hifiberry-dac_plus_adc-online_radio/setup.sh
# 
# A shell script to set up your Raspberry 4 with HiFiBerry's DAC+ ADC, Icecast2,
# and Darkice, to create an online radio for streaming audio on your local
# network (for example from a turntable to Sonos).
#
# Copyright (c) 2023 Johan Palm <johan@pij.se>
# All rights reserved.
# Published under the GNU General Public License v3.0.

# Determine the platform to find the path to libmp3lame for Darkice.
case $(uname -m) in *"arm"*) lame=/usr/lib/arm-linux-gnueabihf/ ;; *) ;; esac
case $(uname -m) in *"x86"*) lame=/usr/lib/x86_64-linux-gnu ;; *) ;; esac
if [ "$lame" = "" ]; then echo "unable to detect platform, exiting..."; exit 1; fi

# Update the package list and upgrade packages.
echo "checking for package updates..."
sudo apt update
echo "upgrading packages..."
sudo apt upgrade -y

# Install and set up Icecast2.
echo "installing icecast2..."
sudo apt install icecast2 -y
sudo useradd icecast -g audio
sudo mkdir -p /var/icecast
sudo chown -R icecast /var/icecast
sudo chown -R icecast /var/log/icecast2
wget https://raw.githubusercontent.com/pij-se/hifiberry-dac_plus_adc-online_radio/main/icecast.xml
sudo mv /etc/icecast2/icecast.xml /etc/icecast2/icecast.xml.bak
sudo mv ./icecast.xml /etc/icecast2/icecast.xml
wget https://raw.githubusercontent.com/pij-se/hifiberry-dac_plus_adc-online_radio/main/icecast2.service
sudo mv ./icecast2.service /lib/systemd/system/icecast2.service
sudo systemctl enable icecast2

# Download, configure, and install Darkice.
echo "installing darkice..."
sudo apt install libasound2-dev -y
sudo apt install libvorbis-dev -y
sudo apt install libmp3lame-dev -y
wget https://github.com/rafael2k/darkice/releases/download/v1.4/darkice-1.4.tar.gz
tar -xvkf darkice-1.4.tar.gz
cd darkice-1.4/
./configure --with-alsa --with-vorbis --with-lame-prefix=$lame
sudo make install
sudo make clean
cd ..
rm -rf ./darkice-1.4
rm -f ./darkice-1.4.tar.gz
wget https://raw.githubusercontent.com/pij-se/hifiberry-dac_plus_adc-online_radio/main/darkice.cfg
sudo mv ./darkice.cfg /etc/darkice.cfg
wget https://raw.githubusercontent.com/pij-se/hifiberry-dac_plus_adc-online_radio/main/darkice.service
sudo mv ./darkice.service /lib/systemd/system/darkice.service
sudo systemctl enable darkice

# Reboot
echo "rebooting..."
sudo reboot
