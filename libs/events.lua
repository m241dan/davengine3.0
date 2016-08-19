-- TODO: Automate to automatically require all files and a call to it will automatically return the right function

local DRoutine = require( "droutine" )

local E = {}

local pollFunction = dofile( "events/pollfun.lua" )
local acceptFunction = dofile( "events/acceptfun.lua" )

function E.newPollEvent( arg )
   if( arg == "droutine" ) then
      return DRoutine:new( pollFunction )
   else
      return pollFunction
   end
end;

function E.newAcceptEvent( arg )
   if( arg == "droutine" ) then
      return DRoutine:new( acceptFunction )
   else
      return acceptFunction
   end
end;

return E
