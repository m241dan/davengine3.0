return function( server )
   local nc

   nc = server:accept()
   if( nc ) then
      nc:send( "You have connected!" )
   end
   return ACCEPT_INTERVAL;
end;
