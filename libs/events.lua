-- TODO: Automate to automatically require all files and a call to it will automatically return the right function

local E = {}

local events = {}

function E.init( path )
   --load events from path given, will load all _event.lua files
   for entry in LFS.dir( path ) do
      if( entry ~= "." and entry ~= ".." and entry:find( "_event.lua" ) ) then
         local name, func = dofile( path .. "/" .. entry );
         if( type( name ) ~= "string" ) then
            print( "Event file: " .. entry .. " does not return a string as its first argument.\n" )
            goto next;
         end
         if( type( func ) ~= "function" ) then
            print( "Event file: " .. entry .. " does not return a function as its second argument.\n" )
            goto next;
         end
         events[name] = func; 
      end
      ::next::
   end


end;

function E.getEvent( name, drout )
   if( not drout ) then
      return events[name]
   else
      return DRoutine:new( event[name] )
   end
end;

return E
