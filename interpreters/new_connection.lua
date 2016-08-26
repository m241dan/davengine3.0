local input, con, dm, d, state

local sub_i = {}

sub_i[1] = function()
   if( input:lower() == "save" ) then
      d:save()
      con:send( "Saved!\r\n" )
   else
      d.name = input
      con:send( "Name set to: " .. d.name .. "\r\n" )
   end
end;

local function interpreter( datamanager, data )
   dm = datamanager
   d = data
   con = datamanager.socket.connection
   con:send( "\r\nWelcome to DavEngine 3.0\r\n\r\nWhat is  your name?: " )
   state = 1
   while( 1 ) do
      input = coroutine.yield()
      sub_i[state]() -- sub interpreter
   end
end

return coroutine.create( interpreter )
