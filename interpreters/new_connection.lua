local function interpreter( datamanager, data )
   local input
   local con = datamanager.socket.connection
   while( 1 ) do
      input = coroutine.yield()
      con:send( "Your input:\n   " .. input .. "\n" );
   end
end

return coroutine.create( interpreter )
