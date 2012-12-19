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

--
local function GetStations()

end

local function InitializePianobar()
	local pianobarConfigDir		= path.expanduser( "~/.config/pianobar" )
	local pianobarConfigFile	= path.join( pianobarConfigDir, "config" )

	if path.exists( pianobarConfigFile ) then
		-- Read the config in so we can check that it matches the required configuration.
		local pianobarConfiguration, errMsg = config.read( pianobarConfigFile )
		if pianobarConfiguration then
			--
		else
			error( ("Could not read the pianobar config file from %q/nMore info: %s"):format( pianobarConfigFile, errMsg ) )
		end
	else
		dir.makepath( pianobarConfigDir )

		local eventCommandPath		= path.join( pianobarConfigDir, "events.lua" )
		local fifoPath				= path.join( pianobarConfigDir, "ctl" )

		-- Write stub configuration
		local stub =
		[[username = user
		password = some_password
		volume = 0
		event_command = $eventcommand
		fifo = $fifo]] % { eventcommand = eventCommandPath, fifo = fifoPath }
		-- Remove tabs
		stub = stub:gsub( "\t", "" )
		io.output( pianobarConfigFile ):write( stub )

		-- Write the events.lua
		local eventContents = io.input( "support/events.lua" ):read( "*a" )
print( eventContents:format( lfs.currentdir() ) )
		io.output( eventCommandPath ):write( eventContents:format( lfs.currentdir() ) )

		-- Write fifo file
		if not path.exists( fifoPath ) then
			io.execute( ("mkfifo %s"):format( fifoPath ) )
		end

		return true
	end

	return false
end

-- Create the app instance
local Remodora = orbiter.new( html )
local h2, p, div, class, id		= html.tags( "h2, p, div, class, id" )

-- Layout function makes the file have a template that all
-- functions will call to get the base functionality from.
function Remodora:layout( ... )
	return html
	{
		title	= "Remodora v0.01",
		favicon	= { "/images/pandora.png" },
		styles	= { "/css/style.css" },
		body	= { div { id = "content", ... } }
	}
end

function Remodora:index( web )
	-- Make sure pianobar is running, if not start it

	return self:layout
	{
		h2 { class = "album", "Loading" },
		p "Web Client",

	}
end

function Remodora:stations( web )
	local stations = GetStations()

	return self:layout
	{
		h2 ( "Stations" ),
		html.list
		{
			render = html.link,
			{ "/section/first", "First section" },
			{ "/section/second", "Second Section" }
		}
	}
end

-- Initialize the routes
Remodora:dispatch_get( Remodora.index, "/", "/index.html" )
Remodora:dispatch_get( Remodora.stations, "/stations" )
Remodora:dispatch_static( "/css/.+" )
Remodora:dispatch_static( "/images/.+" )
Remodora:dispatch_static( "/js/.+" )

-- Main entry point
local function main( ... )
	local isFirstRun = InitializePianobar()


	if orbit then			-- Orbit loads the module and runs it using Xavante, etc
		return Remodora
	else					-- We use the Orbiter micro-server
		Remodora:run( ... )
	end
end

main( ... )
