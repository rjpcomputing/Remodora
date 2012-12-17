### Pianobar

* 12/14/2012 - Needs to be built from source for stability.
	* Install needed development files

		`$ sudo apt-get install libao-dev libmad0-dev libfaad-dev libgnutls-dev libjson0-dev libgcrypt11-dev`
	* Build pianobar

		`$ make`

### Fix Pop Between Tracks

* Make libao use Pulse Audio

	`$ echo "default_driver=pulse" > ~/.libao`
or
	`$ sudo nano /etc/libao.conf` edit the **default_driver** to **pulse**

* Pulseaudio with default settings is just trying to be nice and releases the sound card when no audio is
playing. You can change that behaviour by having pulseaudio not load the module "module-suspend-on-idle".
To achieve this, delete the corresponding line from /etc/pulse/default.pa and /etc/pulse/system.pa.
You have to restart pulseaudio for the setting to take effect. Simplest method is to reboot the pi.
