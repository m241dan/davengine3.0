------------------------------------------------------------
-- Account utils is a util namespace for wrapping account --
-- specific actions into clean and easilly read funcs.    --
------------------------------------------------------------

local A = {}

function A.setupNewAccount( account, dm )
   account:setInterp( ACCOUNT_INTERP )
   dm:AASData( d.account )
   dm:setupInterp( d.account )
   account:save()
end;

function A.connectAccount( account, dm )
   dm:AASData( account )
   dm:setupInterp( account )
end;

function A.handleTakeOver( account, d, dm, old_dm )
   if( not old_dm.socket ) then
      dm.socket.connection:send( "Reconnecting...\r\n" )
      old_dm.socket = dm.socket;
      -- essentially, now we just need to "cleanUpNewConnect" ...
      dm:remData( d ) -- DM will delete itself if it has no data, and it should
      d:delete()
   else
      -- replace the old socket and close
      DataManager.by_socket[old_dm.socket] = nil
      old_dm.socket.connection:send( "Your account is being taken over by someone else logging into it...\r\n" )
      old_dm.socket:close()

      --swap in the new socket
      old_dm.socket = dm.socket
      DataManager.by_socket[dm.socket] = old_dm
      dm.socket.connection:send( "Taking over an already logged in account!\r\n" )
      -- essentially, now we just need to "cleanUpNewConnect" ...
      dm:remData( d ) -- DM will delete itself if it has no data, and it should
      d:delete()
   end
end;

return A
