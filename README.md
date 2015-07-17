## Remodora - Remote Control Pandora Through a Website

_Ryan Pusztai, 2015 (MIT/X11)_

Control Pandora through a website using pianobar and libpiano.

## Why Remodora?

The idea is to have a cheap headless server with audio that you can control through the web. A possible
solution is a [Raspberry Pi](http://www.raspberrypi.org/) for $35.00. Then you can connect to it
through any laptop, computer or phone and use the web browser to control the audio without being near the
audio system. This can be helpful if you have builtin home audio system or you are out on the deck and want to
change the music or check who is playing that current song.

### Name

The name is just a combination of **Remote** and **Pandora**.

## Requirements

* [LuaJIT 5.2](http://luajit.org)+
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
		
		$ sudo apt-get install luajit pianobar
2. Install **LuaRocks**
		
		$ wget http://luarocks.org/releases/luarocks-2.2.1.tar.gz
		$ tar zxpf luarocks-2.2.1.tar.gz`
		$ cd luarocks-2.2.1
		$ ./configure; sudo make bootstrap
3. Install **Turbo.lua** and **LuaJSON**
		
		$ sudo luarocks install turbo
		$ sudo luarocks install luajson
4. Download the source from [GitHub](https://github.com/rjpcomputing/Remodora/archive/master.zip)
5. Extract it to any location
		
		$ unzip <remodora>.zip
6. Execute the `remodora` script from inside the directory you extracted the source to.
7. Open a browser and point it at **http://your-ip:8888**.
8. When it loads for the first time it will take you to the settings dialog. Fill in your Pandora username and password. Please be aware that Remodora will be managing the pianobar settings file, so if you edit it by hand it will overwrite it.
9. Enjoy the music.

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
