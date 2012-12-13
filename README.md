# Remodora

Control Pandora through a website using pianobar and libpiano.

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
7. Execute the `remodora.lua` and open a browser and point it at **<your-ip>:8080** and enjoy.

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
5. Open your web browser and point it at **<your-ip>:8080**
6. Enjoy music.

## Uses

* [Mousetrap](http://github.com/ccampbell/mousetrap)
* [jQuery](http://jquery.com/)
