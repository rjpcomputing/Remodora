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

if "songlove" == event then
	-- Change the current songs rating
	details.rating = 1
end

-- Write current details out for every event
io.output( path.join( out, "current_details.json" ) ):write( json.encode( details ) )

