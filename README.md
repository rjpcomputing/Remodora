## Remodora - Remote Control Pandora Through a Website

_Ryan Pusztai, 2016 (MIT/X11)_

Control Pandora through a website using pianobar and libpiano.

![Remodora Screenshot](/doc/remodora-screenshot.png?raw=true "Optional Title")

## Why Remodora?

The idea is to have a cheap headless server with audio that you can control through the web. A possible
solution is a [Raspberry Pi](http://www.raspberrypi.org/) for $35.00. Then you can connect to it
through any laptop, computer or phone and use the web browser to control the audio without being near the
audio system. This can be helpful if you have builtin home audio system or you are out on the deck and want to
change the music or check who is playing that current song.

### Name

The name is just a combination of **Remote** and **Pandora**.

## Requirements

* [LuaJIT 2.0+](http://luajit.org)
* [Turbo.lua](http://github.com/stevedonovan/Orbiter)
* [Penlight](http://stevedonovan.github.com/Penlight/)
* [LuaJSON](https://github.com/harningt/luajson)
* [LuaRocks](http://luarocks.org)
* [Pianobar](http://github.com/PromyLOPh/pianobar)

## Installation

### Debian Based Distros + Raspbian

1. Install **LuaJIT 2.0**+ and **Pianobar**.
**NOTE**: Pianobar is old when you get it from the repository, so your results may very. Please see doc/notes.md for instructions on installing it from source.
At this time I recommend installing it from source.

		$ sudo apt-get install luajit pianobar libssl-dev liblua5.1-0-dev
If you are using a Raspberry Pi 2 I recommend using Pulse Audio by simply installing it. I found that there is a lot of static from the analog headphone jack.
Installing pulseaudio

		$ sudo apt-get install pulseaudio
Edit `/etc/libao.conf` by changing **default_driver=alsa** to **default_driver=pulse**.

		$ sudo nano /etc/libao.conf
2. Install **LuaRocks**

		$ wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz
		$ tar zxpf luarocks-2.2.2.tar.gz
		$ cd luarocks-2.2.2
		$ ./configure; sudo make bootstrap
3. Install **Turbo.lua** and **LuaJSON**

		$ sudo luarocks install turbo
		$ sudo luarocks install luajson
		$ sudo luarocks install penlight
		$ sudo luarocks install luasocket
4. Download the source from [GitHub](https://github.com/rjpcomputing/Remodora/archive/master.zip)
5. Extract it to any location

		$ unzip <remodora>.zip
6. Execute the `remodora` script from inside the directory you extracted the source to. If a prefix is needed then pass that as the first argument. A prefix is appended to the URL. This can be useful if you are running any other apps on the server or for using a proxy server. In normal operation this is probably not needed. Also change the **href** attribute of `<base href="">` in the file `index.html` to match any prefix you are using.

		$ ./remodora
or

		$ ./remodora <prefix-if-any>
7. Open a browser and point it at **`http://your-ip:8888/<prefix-if-any>`**.
8. Close Remodora after the first launch. It will create the config file template. Close Remodora and edit `~/.config/pianobar/config`. Change the file to match your **Pandora** login details

		user = your@user.name
		password = password
~~When it loads for the first time it will take you to the settings dialog. Fill in your Pandora username and password.~~  Please be aware that Remodora will be managing the pianobar settings file, so if you edit it by hand it will overwrite it.
9. Start Remodora again. Enjoy the music.

### Debian Jessie+ Start At Boot

This will make Remodora start on boot and run as the user `www-data`.

**NOTE**: Please review the settings in `remodora.service` if you choose to store the files somewhere else.

1. Copy `Remodora` directory to `/var/turbo/remodora`.

		$ mkdir /var/turbo
		$ cp Remodora /var/turbo
		$ mv /var/turbo/Remodora /var/turbo/remodora
2. Copy the `remodora.service` file to `/etc/systemd/system/remodora.service`.
		$ sudo cp /var/turbo/remodora/remodora.service /etc/systemd/system
3. Change the permissions of the file to **664**.

		$ sudo chmod 664 /etc/systemd/system/remodora.service
4. Reload systemd config.

		$ sudo systemctl daemon-reload
5. Make the `.config` directory manually so that the user that runs the service can use to store **Pianobars** configuration.

		$ sudo mkdir -p /var/www/.config
		$ sudo chown www-data:www-data /var/www/.config
6. Allow the user `www-data` to play the music by adding `www-data` to the **audio** group in `/etc/group`.
7. Add the service to start automatically on boot.

		$ sudo systemctl enable remodora.service

### NON-FUNCTIONING - Windows

**CAUTION! CAUTION!** - Does not work at this because `fifo` is not currently supported by the Pianobar Windows port.

1. Install [Lua for Windows](http://code.google.com/p/luaforwindows/)
2. Install the [Windows version of Pianobar](https://github.com/thedmd/pianobar-windows)
3. Configure Pianobar
	* Add your username and password to the config file

			# User
			user = your@user.name
			password = password
			# or
			#password_command = gpg --decrypt ~/password
2. Download the source from [GitHub](https://github.com/rjpcomputing/Remodora/archive/master.zip)
3. Extract the source
4. Double-click on the `remodora.lua`. This will open a Command Prompt
5. Open your web browser and point it at **http://your-ip:8080**.
6. Enjoy the music.

## Uses

* [Turbo.lua](http://turbo.lua)
* [AngularJS](https://angularjs.org/)
* [Bootstrap](http://getbootstrap.com)
