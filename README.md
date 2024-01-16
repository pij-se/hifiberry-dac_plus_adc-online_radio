# hifiberry-dac_plus_adc-online_radio
A shell script to set up your Raspberry 4 with HiFiBerry's DAC+ ADC Pro, Icecast2, and Darkice, to create an online radio for streaming audio on your local network (for example from a turntable to Sonos).

This project was forked from https://github.com/pij-se/hifiberry-dac_plus_adc-online_radio to address issues with kernel versions (https://github.com/raspberrypi/linux/issues/5709) and Darkice build issues (https://github.com/titixbrest/darkice/commit/93b8d973d11efaf6799d406230f51b4c49293e5b)

## Background
I ended up buying a turntable as a gift to a family member. It turned out that the only sound system she had was a set of Sonos speakers. As you may know, Sonos is not exactly an open system; much like other brands they are keen on keeping their customers within their ecosystem, and so, a seemingly simple task such as connecting an external audio source to your Sonos sound system ends up being rather expensive if you do it the Sonos way.

## Sonos Line-In
If you are looking for the Sonos solution to this problem, the only way forward is to get one of their products with a line-in. As of today's date, their [offering (2023-03-24)](https://support.sonos.com/en/article/use-line-in-on-sonos/) is as follows:

- Sonos Amp for €799,
- Sonos Era 100 for €279,
- Sonos Era 300 for €499,
- Sonos Five for €649, or
- Sonos Port for €449.

The Era 100 and Era 300 require a USB Type-C to 3.5mm adapter, Sonos Line-In Adapter, for another €25. So, the cheapest Sonos solution will currently set you back €304 for the Era 100 plus Line-In Adapter.

## The alternative(s)
If you are reading this you are most likely looking for an alternative, less expensive solution, and yes, there are other solutions.

Sonos has a feature called TuneIn, which allows you to tune in to online radio stations. Via TuneIn, you can add non-listed radio stations, such as a radio station on your local network, and this is something we can use to circumvent the need to purchase a Sonos line-in product.

While there are probably multiple solutions to this problem, where some have opted for a Bluetooth audio stream from e.g. a phone to a Raspberry Pi, and from the Raspberry Pi to your local network, it seemed to me that such a solution had a few shortcomings in terms of device compatibility and audio stream quality (essentially some devices seem unable to properly connect to the Raspberry Pi as a Bluetooth speaker, and due to limitations imposed by Raspberry Pi hardware design where Bluetooth and WiFi share the same on-board radio, the audio quality had to be reduced to avoid lag or stuttering).

Enter [HiFiBerry](https://www.hifiberry.com/), which offers daughter boards with a line-in for Raspberry Pi. I opted for the [HiFiBerry DAC+ ADC (2023-03-24)](https://www.hifiberry.com/shop/boards/hifiberry-dac-adc/) paired with the [Steel Case for HiFiBerry DAC+/ADC, PI 4, V2 (2023-03-24)](https://www.hifiberry.com/shop/cases/steel-case-for-hifiberry-dac-pi-4/), and of course a Raspberry Pi 4. The board has a 3.5mm jack connected to the ADC (analog-to-digital converter), which constitutes the line-in.

Unfortunately, HiFiBerry's guide on [creating your own radio station with the HiFiBerry DAC+ ADC and Icecast (2023-03-24)](https://www.hifiberry.com/docs/projects/create-your-own-radio-station-with-the-hifiberry-dac-adc-and-icecast/) turned out to be out of date. After eventually getting it to "work" (using Ices2, as used in HifiBerry's guide) as I was facing significant stream delays (around 30 seconds) and never got Sonos TuneIn to connect to the stream; the Sonos S1 app would simply drop the connection without ever playing any audio, with the error message "Network connection speed insufficient to maintain playback buffer".

When looking for a solution I stumbled upon [Darkice (2023-03-24)](http://www.darkice.org/), a supposedly stable but no longer actively developed alternative to Ices2. This turned out to be the solution.

## Getting started
The shell script in this repository will download, compile, install, and configure Icecast2 and Darkice on your Raspberry Pi. Before you run the script, however, you need to set up your Raspberry Pi.

I recommend that you download and flash [Raspberry Pi OS Lite (2023-03-24)](https://www.raspberrypi.com/software/operating-systems/) to your Raspberry Pi SD memory card. This is the version without the desktop, and at least for me, this is the preferable choice since the Raspberry Pi OS with a desktop does not offer any added value given that the device will, once set up, run headless (without a monitor). Contrary, the desktop version will presumably use more system resources, which most likely means that your Raspberry Pi will run hotter and consume more energy, it also uses more space on the SD memory card.

There are various tools you can use to flash the operating system to the SD card, I refer to the documentation on Raspberry Pi's website and elsewhere [on the web](https://duckduckgo.com/?q=how+to+flash+raspberry+pi+os+to+an+sd+card).

Once you have successfully started your Raspberry Pi, you need to connect it to your local network. If you wish to use a wired connection it is sufficient to connect the Ethernet cable between the Raspberry Pi and your router. If you prefer a wireless connection, the easiest way is to use the **Raspberry Pi Software Configuration Tool** `raspi-config`, which will guide you through the connection.

To run `raspi-config`, simply type the following and hit Enter:
```
$ sudo raspi-config
```

Use the arrow keys, Enter, and Escape, to navigate to `1 System Options`, and continue to `S1 Wireless LAN`. Enter the SSID (the name of your wireless network) and passphrase (the wireless network password) when prompted, and you're done.

After connecting the Raspberry Pi to your network, I highly recommend that you browse through your router's settings to assign a static IP address to the Raspberry Pi. Note the IP address. If you skip this step, chances are that the IP address will eventually change, resulting in the need to remove and add the radio station via Sonos TuneIn again, using the new IP address.

## Download, compile, install, and configure Icecast2 and Darkice
Once your Raspberry Pi is connected to your network you are ready to run the script.

Below is a step-by-step guide on each task performed by the script. I only added them to explain in-depth what the script actually does, in case you are interested, or as a help in case the script fails for any reason. To download and execute the script, simply type the following and hit Enter after each line:
```
$ wget https://raw.githubusercontent.com/bgannon2/hifiberry-dac_plus_adc-online_radio/main/setup.sh
$ chmod +x ./setup.sh
$ ./setup.sh
```

It will take some time to run the script, especially since the script has to configure and compile Darkice2 with MP3 support. When the script is done the Raspberry Pi will reboot, and all that remains is to connect an audio source to the line-in and to add your new online radio to Sonos TuneIn.

To add the radio you need to find the IP address of the Raspberry Pi. If you assigned a static IP address to the Raspberry Pi you should already know the IP address. If not, you can run `ifconfig` to see which IP address is assigned to your Raspberry Pi, either under `eth0` or under `wlan0`, depending on if you are using a wired or wireless connection. Type the following and hit Enter:
```
$ ifconfig
```

To add a radio to Sonos TuneIn using the Sonos S1 app, navigate to **Browse > TuneIn > My Radio Stations**. Tap the three dots **...** in the upper right corner, and then **Add New Radio Station**. In the **Streaming URL** field, enter `http://<IP-address>:8000/radio.mp3` (where `<IP-address>` is the IP address of the Raspberry Pi), and enter the desired station name in the **Station Name** field. Hit OK.

**Done! You can now connect Sonos to your Raspberry Pi!**

## The script in detail
Please see the script for now.
