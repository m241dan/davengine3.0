local input, con

local function interpreter( datamanager, data )
   con = datamanager.socket.connection
   con:send( "\r\nSuccessful account connection made!" )

   while( 1 ) do
      input = coroutine.yield()
      print( "\r\nRepeater Mode: " .. input .. "\r\n" )
   end
end

return coroutine.create( interpreter )
