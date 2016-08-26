return "accept event", function( server )
   local new_client = server:accept()

   if( new_client ) then
      ServerUtils.setupNewConnection( new_client )
      DataManager.dataDump()
   end

   return ACCEPT_INTERVAL;
end;
