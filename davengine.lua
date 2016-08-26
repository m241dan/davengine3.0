----------------------------------
-- Setup our Modules from /libs --
----------------------------------
package.path = package.path .. ";./libs/?.lua"
package.cpath = package.cpath .. ";./libs/?.so"

Luatils = require( "luautils" )
Server = require( "server" )
Client = require( "client" )
EventQueue = require( "eventqueue" ) -- cannot be instanced
Event = EventQueue.event -- a shortcut, could also just do things like EventQueue.event:new()
Events = require( "events" )
DRoutine = require( "droutine" )
LuaSha = require( "luasha" )
DBuffer = require( "dbuffer" )
DataManager = require( "datamanager" )
Data = require( "data" )
Time = require( "time" )
LFS = require( "lfs" )
ServerUtils = require( "serverutils" )
Signal = require( "posix.signal" )

SERVER_PORT = 6500
ACCEPT_INTERVAL = EventQueue.second
POLL_INTERVAL = EventQueue.second / 10
NEW_CONNECT_INTERP = "interpreters/new_connection.lua"

Signal.signal( Signal.SIGINT, function()
   if( not server ) then return; end
   server:close()
   EventQueue.stop()
end )

function main()
   print( "DavEngine starting..." )
   loadEvents( "events/server/" )
   bootServer( SERVER_PORT )

   print( "Starting the Event Queue" )
   EventQueue.run()

   print( "DavEngine shutting down..." )      

end;

function bootServer( port )
   print( "Booting the TCP Server..." )
   server = Server:new( port )
   server:start()
   server.accept_event = Event:new( Events.getEvent( "accept event" ), ACCEPT_INTERVAL, { server }, "Accepting new connections." )
   server.poll_event = Event:new( Events.getEvent( "poll event" ), POLL_INTERVAL, { server }, "Polling the Clients connected to the server." ) -- Every 1/10th of a second

   EventQueue.insert( server.accept_event )
   EventQueue.insert( server.poll_event )
end;

function loadEvents( path )
   print( "Loading events from: " .. path )
   Events.init( path )
end;

main()
