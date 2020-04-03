-- ----------------------------------------------------------------------------
--	pianobar - Controls and works with Pianobar using Lua
--
--	Author:		R. Pusztai <rjpcomputing@gmail.com>
--	Date:		01/01/2013
--	License:	MIT/X11, see 'LICENSE' document
--	Notes:
--
--	Revisions:
--		1.0 (01/01/2013) - Initial placeholder
--		1.1 (01/08/2013) - Put in checks for if pianobar is running before
--		                   making action
--		                 - Changed the check for pianobar running to not output
--		                   to the terminal
-- ----------------------------------------------------------------------------
-- Socket for sleep
local socket		= require( "socket" )
local json			= require( "json" )
-- Penlight
local class			= require( "pl.class" )
local path			= require( "pl.path" )
local dir			= require( "pl.dir" )
local config		= require( "pl.config" )
--local stringx		= require( "pl.stringx" ).import()
local pretty		= require( "pl.pretty" )
local text			= require( "pl.text" )
text.format_operator()

-- HELPER FUNCTIONS -----------------------------------------------------------
--
local function IsProcessRunning( processName )
	--local ret = io.popen( ("ps --no-heading -C %s"):format( processName ) ):read( "*a" )
	local ret = io.popen( ("pgrep %s"):format( processName ) ):read( "*a" )

	return #ret > 0
--	return os.execute( ("ps --no-heading -C %s &> /dev/null &"):format( processName ) ) == 0
end

-- PIANOBAR CLASS -------------------------------------------------------------
--
local Pianobar = class()

function Pianobar:WriteFIFO( command )
	if self:IsRunning() then
		local f = io.output( self.fifoPath )
		f:write( ("%s\n"):format( command ) )
		f:close()
		--self:Trace( "action:", command )
	else
		self:Trace( ("ERROR: pianobar not running. Can't execute command %q"):format( command ) )
	end
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

function Pianobar:GetCurrentDetails()
	local songInfoPath = path.join( self.configDir, "current_details.json" )
	if path.exists( songInfoPath ) then
		return json.decode( io.input( songInfoPath ):read( "*a" ) )
	else
		error( "No current song information found. This may be due to pianobar not running" )
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
		#volume = 0
		sort = quickmix_10_name_az
		audio_quality = high
		event_command = $eventcommand
		fifo = $fifo
		rpc_host = internal-tuner.pandora.com
		tls_fingerprint = 7F2BFD338D08D6F952D215C0FC8C3C4C1DC1772F]] % { eventcommand = self.eventCommandPath, fifo = self.fifoPath }
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
		local eventContents = io.input( "src/support/events.lua" ):read( "*a" )
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

function Pianobar:Start( shouldSetStation )
	if not self:IsRunning() then
		os.execute( "pianobar &> /dev/null &" )
		if shouldSetStation then socket.sleep( 3 ); self:WriteFIFO( "0" ) end	-- Start Quickmix at the station, since it is the first run
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
	self:Trace( "Wrote username and password" )

	f:write( res )
	f:close()

	self:Start( true )
end

function Pianobar:GetStations()
	local details = self:GetCurrentDetails()
	local stations = {}
	for i = 0, details.stationCount do
		stations[1 + #stations] = details["station" .. i]
	end

	return stations
end

function Pianobar:GetSongInfo()
	local details = self:GetCurrentDetails()

	return
	{
		stationName	= details.stationName,
		artist		= details.artist,
		album		= details.album,
		title		= details.title,
		coverArt	= details.coverArt,
		rating		= details.rating,
		detailUrl	= details.detailUrl,
	}
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

function Pianobar:Quit()
	self:WriteFIFO( "q" )
	-- Delete the current details so that the image and details go back to default
	os.remove( path.join( self.configDir, "current_details.json" ) )
	self:Trace( "Quit" )
	-- We tried nicely, now it is time to KILL!
	--if self:IsRunning() then
	socket.sleep( 1 )
	os.execute( "killall -9 pianobar" )
	self:Trace( "Still found pianobar. Forcefully killed...")
	--end
end

return Pianobar
