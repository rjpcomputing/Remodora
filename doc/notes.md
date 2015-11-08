## Remove Unneeded/Desktop Packages
	
	$ sudo apt-get remove --purge desktop-base lightdm lxappearance lxde-common lxde-icon-theme lxinput lxpanel lxpolkit lxrandr lxsession-edit lxshortcut lxtask lxterminal
	$ sudo apt-get  remove --purge wolfram-engine squeak-*
	$ sudo apt-get remove --purge obconf openbox raspberrypi-artwork xarchiver xinit xserver-xorg xserver-xorg-video-fbdev x11-utils x11-common x11-session utils

## Raspberry Pi Pianobar Setup

### Pianobar

* 12/14/2012 - Needs to be built from source for stability.
	* Install needed development files

		`$ sudo apt-get install git libavcodec-dev libavformat-dev libavutil-dev libavfilter-dev libgnutls-dev libjson0-dev libgcrypt11-dev libao-dev`
	* Get the pianobar source
		
		`$ git clone https://github.com/PromyLOPh/pianobar.git`
	
	* Build pianobar

		`$ cd pianobar`
		
		`$ make`
		
		`$ sudo make install`

### Fix Pop Between Tracks

These are instructions to get rid of the pops between tracks when using analog audio on the Raspberry Pi.

* Install pulseadio
        `$ sudo apt-get install pulseaudio`

* Make libao use Pulse Audio

	`$ echo "default_driver=pulse" > ~/.libao`
or
	`$ sudo nano /etc/libao.conf` edit the **default_driver** to **pulse**

* Pulseaudio with default settings is just trying to be nice and releases the sound card when no audio is
playing. You can change that behaviour by having pulseaudio not load the module "module-suspend-on-idle".
To achieve this, delete the corresponding line from /etc/pulse/default.pa and /etc/pulse/system.pa.
You have to restart pulseaudio for the setting to take effect. Simplest method is to reboot the pi.

### Fix "ALSA lib pcm.c:2217:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.front"

* Change the line in `/usr/share/alsa/alsa.conf` from **pcm.front cards.pcm.front** to **pcm.front cards.pcm.default**

	`$ sudo nano /usr/share/alsa/alsa.conf`
