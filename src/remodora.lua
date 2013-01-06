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
local tablex		= require( "pl.tablex" )
local stringx		= require( "pl.stringx" ).import()
local pretty		= require( "pl.pretty" )
local text			= require( "pl.text" )
text.format_operator()
require( "pl.strict" ); orbit = false;

-- Orbiter
local orbiter	= require( "orbiter" )
local html		= require( "orbiter.html" )
local jq		= require( "orbiter.libs.jquery" )

-- Pianobar
local Pianobar		= require( "pianobar" )

-- HELPER FUNCTIONS -----------------------------------------------------------
--
local function IsProcessRunning( processName )
	return os.execute( ("ps --no-heading -C %s"):format( processName ) ) == 0
end

-- APP INSTANCE ---------------------------------------------------------------
--
-- Create the app instance
local Remodora = orbiter.new( html )
local h1, h2, h3, p, div, class, id, a, img, span, ul, ol, li, meta, form, label, button, input, fieldset =
	html.tags( "h1, h2, h3, p, div, class, id, a, img, span, ul, ol, li, meta, form, label, button, input, fieldset" )

Remodora._APPNAME = "Remodora"
Remodora._VERSION = "1.0"

function Remodora:InitializePianobar()
	self.pianobar = Pianobar( true )
end

-- Layout function makes the file have a template that all
-- functions will call to get the base functionality from.
function Remodora:Layout( page )
	local scripts = { "/js/toastr.js" }
	for _, val in ipairs( page.scripts or {} ) do table.insert( scripts, val ) end
	local styles = { "/css/style.css", "/css/toastr.css", "/css/toastr-responsive.css" }
	for _, val in ipairs( page.styles or {} ) do table.insert( styles, val ) end

	return html
	{
		title			= page.title or ("%s v%s"):format( self._APPNAME, self._VERSION ),
		favicon			= page.favicon or { "/images/pandora.png" },
		styles			= styles,
		scripts			= scripts,
		inline_script	= page.inline_script,
		body			=
		{
			meta { name = "viewport", content = "width=device-width, initial-scale=1.0, maximum-scale=1.0" },
			div
			{
				id = "login-box",
				class = "login-popup",
				a { href = "#", class = "close", img{ src = "images/close_pop.png", class = "btn_close", title = "Close Window", alt = "Close" } },
				form
				{
					method = "post", class = "signin", action = "signin",
					fieldset
					{
						class = "textbox",
						label
						{
							class = "username",
							span( "Pandora Email" ),
							input{ id = "username", name = "username", value = "", type = "text", autocomplete = "on", placeholder = "Email" }
						},
						label
						{
							class = "password",
							span( "Pandora Password" ),
							input{ id = "password", name = "password", value = "", type = "password", placeholder = "Password" }
						},
						button{ class = "submit button", type = "button", "Sign in" },
					}
				},
			},
			div
			{
				id = "navcontainer",
				div
				{
					id = "dock",
					class = "right",
					ul
					{
						li { html.link { "#login-box", "Pandora Login", class = "login-window" } },
						li { html.link { "#", "", title = "Stop Pandora", class = "stop-pandora", onclick = "$.get('/rest/action/q')" } },
					},
				},
			},
			div
			{
				id = "controls",
				ul
				{
					class = "toolbar",
					li { html.link { "/stations", "", title = "Change Station", class = "change-stations" } },
					li { html.link { "#", "", title = "Play/Pause", onclick = "$.get( '/rest/action/p' );$(this).toggleClass( 'controls-play controls-pause' );", class = "controls-pause" } },
					li { html.link { "#", "", title = "Next", onclick = "$.get( '/rest/action/n' )", class = "controls-next" } },
					li { html.link { "#", "", title = "Love", onclick = "$.get( '/rest/action/+' )", class = "controls-love" } },
					li { html.link { "#", "", title = "Ban", onclick = "$.get( '/rest/action/-' )", class = "controls-ban" } },
					li { html.link { "#", "", title = "Tired", onclick = "$.get( '/rest/action/t' )", class = "controls-tired" } },
				},
			},
			div { id = "content", page.content },
		},
	}
end

function Remodora:Index( web )
	-- Make sure pianobar is running, if not start it
	local pianobarRunning = ""
	if IsProcessRunning( "pianobar" ) then
		pianobarRunning = "Pianobar is running"
	else
		pianobarRunning = "Pianobar is not running"
		self.pianobar:Start()
	end

	return self:Layout
	{
		scripts = { "/js/login.js", "/js/main.js" },
		--inline_script = [=[]=],
		content =
		{
			img { class = "albumart shadow", src = "../images/song.png" },
			img { class = "love", style = "display: none;", src = "../images/love_song.48x48.png" },
			div
			{
				class = "songdetails",
				h2 { class = "title", "Loading..." },
				div { "by ", h2 { class = "artist", "" } },
				div { "from ", h2 { class = "album", "" } },
			}
		}
	}
end

function Remodora:Signin( web )
	local user	= web.input.user
	local pass	= web.input.pass

	if #user < 4 or #pass < 4 then
		web.status = "400 Bad Request"
		return json.encode( { false, "Username or password are not formatted correctly" } )
	else
		self.pianobar:WriteUsernamePassword( user, pass )

		return json.encode( { true, "OK" } )
	end
end

function Remodora:Stations( web )
	local stations = self.pianobar:GetStations()

	local stationLinks = {}
	-- Convert them to links for switching
	for idx, val in ipairs( stations ) do
		stationLinks[1 + #stationLinks] = { "/station/%i" % (idx - 1), val }
	end

	return self:Layout
	{
		title = ("%s v%s - Stations"):format( self._APPNAME, self._VERSION ),
		content =
		{
			h2 ( "Stations" ),
			html.list
			{
				render = html.link,
				data = stationLinks
			}
		}
	}
end

function Remodora:ChangeStation( web, station )
	self.pianobar:ChangeStation( station )

	return web:redirect( "/" )
end

function Remodora:Action( web, action )
	self.pianobar:PerformAction( action )

	return json.encode( { true, "Ok" } )
	--return web:redirect( "/" )
end

function Remodora:GetSongInfo( web )
	return json.encode( self.pianobar:GetSongInfo() )
end

-- Initialize the routes
Remodora:dispatch_get( Remodora.Index, "/", "/index.html" )
Remodora:dispatch_get( Remodora.Stations, "/stations" )
Remodora:dispatch_get( Remodora.ChangeStation, "/station/(.+)" )
Remodora:dispatch_get( Remodora.Action, "/rest/action/(.+)" )
Remodora:dispatch_get( Remodora.GetSongInfo, "/rest/songinfo" )
Remodora:dispatch_post( Remodora.Signin, "/rest/signin" )
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
