#!/usr/bin/env lua
-- events.lua - Pianobar event output to JSON
local json		= require( "json" )
local stringx	= require( "pl.stringx" )
local path		= require( "pl.path" )

local out = "%s"

local event = arg[1]
local details = {}
for line in io.stdin:lines() do
	local lineDetails = stringx.split( line, "=" )
	details[lineDetails[1]] = lineDetails[2]
end

if "songstart" == event then
	io.output( path.join( out, "currentSong.json" ) ):write( json.encode( details ) )
elseif "songlove" == event then
	-- Change the current songs rating
	details.rating = 1
	io.output( path.join( out, "currentSong.json" ) ):write( json.encode( details ) )
	io.output( path.join( out, "message" ) ):write( "Loved" )
elseif "songban" == event then
	io.output( path.join( out, "message" ) ):write( "Banned" )
elseif "songshelf" == event then
	io.output( path.join( out, "message" ) ):write( "Tired" )
elseif "usergetstations" == event then
	local stations = {}
	for i = 0, details.stationCount do
		stations[1 + #stations] = details["station" .. i]
	end
	io.output( path.join( out, "stations.json" ) ):write( json.encode( stations ) )
end
