----------------------------------------------------------
-- Server Utils is a util namespace for wrapping server --
-- specific actions into clean and easilly read funcs.  --
----------------------------------------------------------

local S = {}

function S.setupNewConnection( client )
   local new_dm = DataManager:new( nc )
   local data = Data:new()

   data:setInterp( NEW_CONNECT_INTERP )
   new_dm:AASData( data )
   new_dm:setupInterp( data );
end;



return S
