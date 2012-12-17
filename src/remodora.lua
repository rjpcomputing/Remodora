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
-- Penlight
local appSupport	= require( "pl.app" )
local class			= require( "pl.class" )
local lapp			= require( "pl.lapp" )
local path			= require( "pl.path" )
local dir			= require( "pl.dir" )
local stringx		= require( "pl.stringx" ).import()
local pretty		= require( "pl.pretty" )
require( "pl.strict" ); orbit = false;

-- Orbiter
local orbiter	= require( "orbiter" )
local html		= require( "orbiter.html" )

-- Create the app instance
local Remodora	= orbiter.new( html )
local h2, p, div, class, id		= html.tags( "h2, p, div, class, id" )

-- Layout function makes the file have a template that all
-- functions will call to get the base functionality from.
function Remodora:layout( ... )
	return html
	{
		title	= "Remodora v0.01",
		styles	= { "/css/style.css" },
		body	= { div { id = "content", ... } }
	}
end

function Remodora:index( web )
	-- Initialize the system
	--
	-- Check for FIFO file
	if not path.exists( "ctl" ) then
		os.execute( "mkfifo ctl" )
	end

	return self:layout
	{
		h2 { class = "album", "Loading" },
		p "Web Client",
		html.list
		{
			render = html.link,
			{ "/section/first", "First section" },
			{ "/section/second", "Second Section" }
		}
	}
end

function Remodora:sections( web, name )
	return self:layout { h2 ( name ) }
end

-- Initialize the routes
Remodora:dispatch_get( Remodora.index, "/", "/index.html" )
Remodora:dispatch_get( Remodora.sections, "/section/(.+)" )
Remodora:dispatch_static( "/css/.+" )

if orbit then			-- Orbit loads the module and runs it using Xavante, etc
    return app
else					-- We use the Orbiter micro-server
    Remodora:run( ... )
end
