local function process()
   for i, c in ipairs( server.connections ) do
      -- (c)onnections are the socket that datamanager refers to, just some lua flex
      local dm = DataManager.by_socket[c]
      if( not dm ) then
         print( "event:process(): Unable to locate a DM for this socket." )
         goto next_client
      end

      local current_data = dm.data[dm.index]  -- shouldn't be possible to not have data at index, so not going to check
      local interp = dm.interpreter[current_data]
      if( not interp ) then
         print( "event:process(): Unable to locate an interpreter for the current data." )
         goto next_client
      end

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
