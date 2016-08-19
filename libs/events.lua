local DRoutine = require( "droutine" )

local E = {}

local pollFunction = dofile( "events/pollfun.lua" )

function E.newPollEvent( arg )
   if( arg == "droutine" ) then
      return DRoutine:new( pollFunction )
   else
      return pollFunction
   end
end;

return E
