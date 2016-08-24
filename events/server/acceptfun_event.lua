return "accept event", function( server )
   local nc

   nc = server:accept()
   if( not nc ) then
      print( "Server event could not accept new connection." )
      return ACCEPT_INTERVAL
   end

   local new_dm = DataManager:new( nc )
   local data = Data:new()

   data:setInterp( "interpreters/new_connection.lua" )
   new_dm:AAS( data );
   new_dm:setupInterp( data );

   DataManager.dataDump()

   return ACCEPT_INTERVAL;
end;
