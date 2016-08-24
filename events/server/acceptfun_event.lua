return "accept event", function( server )
   local nc

   nc = server:accept()
   if( nc ) then
      local new_dm = DataManager:new( nc )
      local data = Data:new()

      data:setInterp( "interpreters/new_connection.lua" )
      new_dm:AASData( data );
      new_dm:setupInterp( data );

      DataManager.dataDump()
   end

   return ACCEPT_INTERVAL;
end;
