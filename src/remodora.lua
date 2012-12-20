#!/usr/bin/env lua
-- ----------------------------------------------------------------------------
--	Remodora - Remote control Pandora through a website using pianobar.
--
--	Author:		R. Pusztai <rjpcomputing@gmail.com>
--	Date:		12/14/2012
--	License:	MIT/X11, see 'LICENSE' document
--	Notes:
--
--	Revisions:
--		0.0 - Initial placeholder
-- ----------------------------------------------------------------------------
package.path = package.path .. ";./?/init.lua"	-- Add 'init.lua' loading to the current directory
local lfs			= require( "lfs" )
local json			= require( "json" )
-- Penlight
local appSupport	= require( "pl.app" )
local class			= require( "pl.class" )
local lapp			= require( "pl.lapp" )
local path			= require( "pl.path" )
local dir			= require( "pl.dir" )
local config		= require( "pl.config" )
local stringx		= require( "pl.stringx" ).import()
local pretty		= require( "pl.pretty" )
local text			= require( "pl.text" )
text.format_operator()
require( "pl.strict" ); orbit = false;

-- Orbiter
local orbiter	= require( "orbiter" )
local html		= require( "orbiter.html" )

-- HELPER FUNCTIONS -----------------------------------------------------------
--
local function IsProcessRunning( processName )
	return os.execute( ("ps --no-heading -C %s"):format( processName ) ) == 0
end

-- APP INSTANCE ---------------------------------------------------------------
--
-- Create the app instance
local Remodora = orbiter.new( html )
local h2, p, div, class, id		= html.tags( "h2, p, div, class, id" )

Remodora._APPNAME = "Remodora"
Remodora._VERSION = "0.2"

function Remodora:GetStations()
	local stationsPath = path.join( self.pianobar.configDir, "stations.json" )
	return { "Holiday Music", "TobyMac Radio", "Christian Heavy Music" }

--	if path.exists( stationsPath ) then
--		return json.encode( io.input( stationsPath ):read( "*a" ) )
--	else
--		error( "No stations found" )
--	end
end

function Remodora:InitializePianobar()
	local pianobarConfigDir	= path.expanduser( "~/.config/pianobar" )
	self.pianobar =
	{
		configDir			= pianobarConfigDir,
		configFile			= path.join( pianobarConfigDir, "config" ),
		eventCommandPath	= path.join( pianobarConfigDir, "events.lua" ),
		fifoPath			= path.join( pianobarConfigDir, "ctl" ),
	}
	self.isFirstRun = false

	if path.exists( self.pianobar.configFile ) then
		-- Read the config in so we can check that it matches the required configuration.
		local pianobarConfiguration, errMsg = config.read( self.pianobar.configFile )
		if pianobarConfiguration then
			-- Load the configuration into the object
			self.pianobar.config = pianobarConfiguration
		else
			error( ("Could not read the pianobar config file from %q/nMore info: %s"):format( self.pianobar.configFile, errMsg ) )
		end
	else
		dir.makepath( pianobarConfigDir )

		-- Write stub configuration
		local stub =
		[[# User
		user = your@user.name
		password = password
		# or
		#password_command = gpg --decrypt ~/passwordusername = user
		volume = 0
		event_command = $eventcommand
		fifo = $fifo]] % { eventcommand = self.pianobar.eventCommandPath, fifo = self.pianobar.fifoPath }
		-- Remove tabs
		stub = stub:gsub( "\t", "" )
		io.output( self.pianobar.configFile ):write( stub )

		-- Write the events.lua
		local eventContents = io.input( "support/events.lua" ):read( "*a" )
		io.output( self.pianobar.eventCommandPath ):write( eventContents:format( lfs.currentdir() ) )

		-- Write fifo file
		if not path.exists( self.pianobar.fifoPath ) then
			os.execute( ("mkfifo %s"):format( self.pianobar.fifoPath ) )
		end

		self.isFirstRun = true

		return true
	end

	return false
end

-- Layout function makes the file have a template that all
-- functions will call to get the base functionality from.
function Remodora:Layout( page )
	return html
	{
		title	= page.title or ("%s v%s"):format( self._APPNAME, self._VERSION ),
		favicon	= page.favicon or { "/images/pandora.png" },
		styles	= page.styles or { "/css/style.css" },
		body	= { div { id = "content", page.content } }
	}
end

function Remodora:Index( web )
	-- Make sure pianobar is running, if not start it
	local firstRunText = nil
	if self.isFirstRun then firstRunText = "First time running Remodora" end
	local pianobarRunning = ""
	if IsProcessRunning( "pianobar" ) then
		pianobarRunning = "Pianobar is running"
	else
		pianobarRunning = "Pianobar is not running"
	end

	return self:Layout
	{
		content =
		{
			h2 { class = "album", "Loading" },
			p "Web Client",
			p( firstRunText ),
			p( pianobarRunning ),
		}
	}
end

function Remodora:Stations( web )
	local stations = self:GetStations()

	return self:Layout
	{
		title = ("%s v%s - Stations"):format( self._APPNAME, self._VERSION ),
		content =
		{
			h2 ( "Stations" ),
			html.list
			{
				--render = html.link,
				data = stations
			}
		}
	}
end

-- Initialize the routes
Remodora:dispatch_get( Remodora.Index, "/", "/index.html" )
Remodora:dispatch_get( Remodora.Stations, "/stations" )
Remodora:dispatch_static( "/css/.+" )
Remodora:dispatch_static( "/images/.+" )
Remodora:dispatch_static( "/js/.+" )

-- Main entry point
local function main( ... )
	local isFirstRun = Remodora:InitializePianobar()

	if orbit then			-- Orbit loads the module and runs it using Xavante, etc
		return Remodora
	else					-- We use the Orbiter micro-server
		Remodora:run( ... )
	end
end

main( ... )
