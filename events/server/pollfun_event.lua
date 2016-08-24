local function process()
   for i, c in ipairs( server.connections ) do
      -- (c)onnections are the socket that datamanager refers to, just some lua flex
      local dm = DataManager.by_socket[c]
      local current_data = dm.data[dm.index]
      local interp = dm.interpreter[current_data]

      -- let's examine the inbuffer
      for _, ln in ipairs( c.inbuf ) do
         -- process the line through our current data's interpreter
         interp( ln )
         -- if it's dead, shut it down
         if( interp:status() == "dead" ) then
            print( "Removing Data, it cannot exist without an interpreter" )
            dm:remData( current_data )
            goto next_client
         end
      end
     
      c.inbuf = {}
      ::next_client::
   end
end

return "poll event", function( server )
   -- poll clients for new input
   server:poll()
   -- process the stuff in the inbufs of the clients
   process()
   -- push the outbufs
   server:push()

   return POLL_INTERVAL
end;
