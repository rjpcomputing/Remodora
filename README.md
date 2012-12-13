## Remodora - Remote control Pandora Through a Website

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
* [Pianobar](http://github.com/PromyLOPh/pianobar)

## Installation

### Debian Based Distros + Raspbian

1. Install **Lua 5.1**+ and **Pianobar**

	`$ sudo apt-get install lua5.1 luarocks pianobar`
2. Install **Penlight**

	`$ sudo luarocks install penlight`
3. Configure Pianobar
	* Add your username and password to the config file
	
			# User
			user = your@user.name
			password = password
			# or
			#password_command = gpg --decrypt ~/password

4. Download the source from [GitHub](https://github.com/rjpcomputing/Remodora/archive/master.zip)
5. Extract it to any location

	`$ unzip <remodora>.zip`
6. Change in the created directory and may the `remodora.lua` file executable.

	`$ chmod +x remodora.lua`
7. Execute the `remodora.lua` and open a browser and point it at **http://your-ip:8080**.
8. Enjoy the music.

### UNTESTED - Windows

**CAUTION CAUTION** - May not work

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
