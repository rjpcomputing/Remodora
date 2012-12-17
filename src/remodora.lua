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
require( "pl.strict" )

-- Orbiter
local orbiter	= require( "orbiter" )
local html		= require( "orbiter.html" )

-- Create the app instance
local Remodora	= orbiter.new( html )
local h2, p		= html.tags( "h2, p" )

function Remodora:index( web )
	return html
	{
		title = "A Remodora Orbiter App",
		h2 "Remodora to do easy stuff",
		p "complex stuff made manageable",
		html.list
		{
			render = html.link,
			{ "/section/first", "First section" },
			{ "/section/second", "Second Section" }
		}
	}
end

function Remodora:sections( web, name )
	return html { h2 ( name ) }
end

Remodora:dispatch_get( Remodora.index, "/", "/index.html" )
Remodora:dispatch_get( Remodora.sections, "/section/(.+)" )

Remodora:run( ... )
