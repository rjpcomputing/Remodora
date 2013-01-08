-- ----------------------------------------------------------------------------
--	pianobar - Controls and works with Pianobar using Lua
--
--	Author:		R. Pusztai <rjpcomputing@gmail.com>
--	Date:		01/01/2013
--	License:	MIT/X11, see 'LICENSE' document
--	Notes:
--
--	Revisions:
--		0.0 - Initial placeholder
-- ----------------------------------------------------------------------------
-- Penlight
local class			= require( "pl.class" )
local path			= require( "pl.path" )
local dir			= require( "pl.dir" )
local config		= require( "pl.config" )
local stringx		= require( "pl.stringx" ).import()
local pretty		= require( "pl.pretty" )
local text			= require( "pl.text" )
text.format_operator()

-- HELPER FUNCTIONS -----------------------------------------------------------
--
local function IsProcessRunning( processName )
	return os.execute( ("ps --no-heading -C %s &> /dev/null"):format( processName ) ) == 0
end

-- PIANOBAR CLASS -------------------------------------------------------------
--
local Pianobar = class()

function Pianobar:WriteFIFO( command )
	local f = io.output( self.fifoPath )
	f:write( ("%s\n"):format( command ) )
	f:close()
end

function Pianobar:Trace( ... )
	if self.trace then print( "[pianobar]", ... ) end
end

function Pianobar:ReadConfig( configPath )
	-- Read the config in so we can check that it matches the required configuration.
	local pianobarConfiguration, errMsg = config.read( configPath )
	if pianobarConfiguration then
		return pianobarConfiguration
	else
		error( ("Could not read the pianobar config file from %q/nMore info: %s"):format( configPath, errMsg ) )
	end
end

--- Contructor
-- @param shouldLog {boolean} If true, trace logging to the terminal
-- @returns pianobar object
function Pianobar:_init( shouldLog )
	-- Setup defaults
	local pianobarConfigDir	= path.expanduser( "~/.config/pianobar" )
	self.configDir			= pianobarConfigDir
	self.configFilePath		= path.join( pianobarConfigDir, "config" )
	self.eventCommandPath	= path.join( pianobarConfigDir, "events.lua" )
	self.fifoPath			= path.join( pianobarConfigDir, "ctl" )
	self.trace				= shouldLog or false
	self.isFirstRun			= false

	if path.exists( self.configFilePath ) then
		self.config = self:ReadConfig( self.configFilePath )
		self:Trace( "config found and loaded" )
	else
		self:Trace( "config not found" ); self:Trace( "this is the first run" )
		dir.makepath( self.configDir )

		-- Write stub configuration
		local stub =
		[[# User
		user = your@user.name
		password = password
		# or
		#password_command = gpg --decrypt ~/passwordusername = user
		volume = 0
		event_command = $eventcommand
		fifo = $fifo
		tls_fingerprint = 2D0AFDAFA16F4B5C0A43F3CB1D4752F9535507C0]] % { eventcommand = self.eventCommandPath, fifo = self.fifoPath }
		-- Remove tabs
		stub = stub:gsub( "\t", "" )

		local configStubHandle = io.output( self.configFilePath )
		configStubHandle:write( stub )
		configStubHandle:close()
		self:Trace( "stub config file written" )

		-- Read the config file back in as a config table
		self.config = self:ReadConfig( self.configFilePath )
		self:Trace( "stub config loaded" )

		-- Write the events.lua
		local eventContents = io.input( "support/events.lua" ):read( "*a" )
		local eventHandle = io.output( self.eventCommandPath )
		eventHandle:write( eventContents:format( self.configDir ) )
		eventHandle:close()
		os.execute( ("chmod +x %s"):format( self.eventCommandPath ) )
		self:Trace( "event file written" )

		-- Write fifo file
		if not path.exists( self.fifoPath ) then
			os.execute( ("mkfifo %s"):format( self.fifoPath ) )
			self:Trace( "FIFO file written" )
		end

		self.isFirstRun = true
	end
end

function Pianobar:Start()
	if not self:IsRunning() then
		os.execute( "pianobar &" )
	end
end

--- Is Pianobar currently running
-- @returns true if pianobar is running, else false
function Pianobar:IsRunning()
	return IsProcessRunning( "pianobar" )
end

--- Writes a username and password to the Pianobar config file.
-- @param username {string} Username to set
-- @param password {string} password to set
function Pianobar:WriteUsernamePassword( username, password )
	local f = io.output( self.configFilePath )

	if self:IsRunning() then
		self:Quit()
	end

	-- Update the config table
	self.config.user		= username
	self.config.password	= password

	-- Write the table to disk
	local res = ""
	for key, value in pairs( self.config ) do
		res = ("%s%s = %s\n"):format( res, key, value )
	end
	self:Trace( "res =", res )

	f:write( res )
	f:close()

	self:Start()
end

function Pianobar:GetStations()
	local stationsPath = path.join( self.configDir, "stations.json" )

	if path.exists( stationsPath ) then
		local ret = json.decode( io.input( stationsPath ):read( "*a" ) )

		return ret
	else
		error( "No stations found. This may be due to pianobar not running" )
	end
end

function Pianobar:Play()
	self:WriteFIFO( "p" )
end

function Pianobar:Next()
	self:WriteFIFO( "n" )
end

function Pianobar:Love()
	self:WriteFIFO( "+" )
end

function Pianobar:Ban()
	self:WriteFIFO( "-" )
end

function Pianobar:Tired()
	self:WriteFIFO( "t" )
end

function Pianobar:PerformAction( action )
	self:WriteFIFO( action )
end

function Pianobar:ChangeStation( station )
	self:WriteFIFO( "s" .. station )
end

function Pianobar:GetSongInfo()
	local songInfoPath = path.join( self.configDir, "currentSong.json" )

	if path.exists( songInfoPath ) then
		local allInfo = json.decode( io.input( songInfoPath ):read( "*a" ) )

		return
		{
			stationName	= allInfo.stationName,
			artist		= allInfo.artist,
			album		= allInfo.album,
			title		= allInfo.title,
			coverArt	= allInfo.coverArt,
			rating		= allInfo.rating,
			detailUrl	= allInfo.detailUrl,
		}
	else
		error( "No current song information found. This may be due to pianobar not running" )
	end
end

function Pianobar:Quit()
	self:WriteFIFO( "q" )
	self:Trace( "Quit" )
	-- We tried nicely, now it is time to KILL!
	if self:IsRunning() then
		os.execute( "killall -9 pianobar" )
		self:Trace( "Still found pianobar. Forcefully killed...")
	end
end

return Pianobar
