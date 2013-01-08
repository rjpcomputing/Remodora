## Remodora - Remote Control Pandora Through a Website

_Ryan Pusztai, 2012 (MIT/X11)_

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

* [Lua 5.1](http://lua.org)+
* [Orbiter](http://github.com/stevedonovan/Orbiter)
* [Penlight](http://stevedonovan.github.com/Penlight/)
* [LuaJSON](https://github.com/harningt/luajson)
* [LuaSocket](http://w3.impa.br/~diego/software/luasocket/)
* [Pianobar](http://github.com/PromyLOPh/pianobar)

## Installation

### Debian Based Distros + Raspbian

1. Install **Lua 5.1**+, **LuaRocks**, and **Pianobar**

	`$ sudo apt-get install lua5.1 luarocks pianobar`
2. Install **Penlight**, **LuaJSON**, **LuaSocket**

	`$ sudo luarocks install penlight`
	`$ sudo luarocks install luajson`
	`$ sudo luarocks install luasocket`
3. Download the source from [GitHub](https://github.com/rjpcomputing/Remodora/archive/master.zip)
4. Extract it to any location

	`$ unzip <remodora>.zip`
5. Change into the 'src' directory and make the `remodora.lua` file executable.

	`$ chmod +x remodora.lua`
6. Copy `Orbiter` from the 'libs' directory.

	`$ cp -r ../libs/Orbiter/orbiter .`
7. Execute the `remodora.lua` and open a browser and point it at **http://your-ip:8080**.
8. When it loads for the first time it will take you to the settings dialog. Fill in your Pandora username and password. Please be aware that Remodora will be managing the pianobar settings file, so if you edit it by hand it will overwrite it.
9. Enjoy the music.

#### Old Setup

4. Create a FIFO file by running `mkfifo ctl` in your Remodora directory.
5. Configure Pianobar
	* Add your username and password to the config file

			# User
			user = your@user.name
			password = password
			# or
			#password_command = gpg --decrypt ~/password
			fifo = path_to_ctl
			event_command = path/to/eventcmd.lua

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

* [Mousetrap](http://github.com/ccampbell/mousetrap)
* [jQuery](http://jquery.com/)
