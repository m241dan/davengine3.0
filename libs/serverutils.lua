----------------------------------------------------------
-- Server Utils is a util namespace for wrapping server --
-- specific actions into clean and easilly read funcs.  --
----------------------------------------------------------

local S = {}

function S.setupNewConnection( client )
   local new_dm = DataManager:new( client )
   local data = Data:new()

   data:setInterp( NEW_CONNECT_INTERP )
   new_dm:AASData( data )
   new_dm:setupInterp( data );
end;

function S.cleanUpNewConnection( dm, d )
   dm:remData( d )
   d:delete()
end;


return S
