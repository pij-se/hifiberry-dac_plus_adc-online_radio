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

# Install and configure Icecast2
echo "Installing Icecast2..."
sudo apt install icecast2
