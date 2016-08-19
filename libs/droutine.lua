------------------------------------------------------------
-- Davenge Routine Library ||| written by Daniel R. Koris --
------------------------------------------------------------
-- The droutine's goal is to provide a container for a    --
-- lua coroutine. It will allow us to call it as a normal --
-- function, like a wrapped coroutine but will provide    --
-- all the functionality of a non-wrapped coroutine.      --
------------------------------------------------------------

local DR = {}

-- setup OOP by indexing itself
DR.__index = DR
-- setup __call metamethod, a call to a DRoutine should pass the args in a resume to the thread contained within
DR.__call = function( t, ... )

   -- sanity checks
   if( not t.thread ) then
      print( "Call on DRoutine has no thread." )
      return
   end

   if( coroutine.status( t.thread ) == "dead" ) then
      print( "Call on DRoutine with a dead thread." )
      return
   end
   -- make the call, or in this case the resume and return the results
   local result = coroutine.resume( t.thread, ... )
   return result
end
--------------
-- DR:new() --
--------------
-- creating a new container
function DR:new( arg )
   -- create table and set its metatable to the library
   local dr = {}
   setmetatable( dr, self )

   if( arg ) then
      dr:wrap( arg )
   end

   return dr
end
-- returns a new DR object

-----------------
-- DR:status() --
-----------------
-- get the status of the contained coroutine
function DR:status()
   if( not self.thread ) then
      return "none"
   end
   return coroutine.status( self.thread )
end
-- returns a string

---------------
-- DR:wrap() --
---------------
-- takes either a path on which it will run doFile, a function, or an existing thread
-- most efficient: thread -> function -> path string
function DR:wrap( arg )
   local t = type( arg )
   -- if its a thread, assign it and leave
   if( t ~= "thread" ) then
      -- if it's a string, run dofile on it because we assume thats a path
      if( t == "string" ) then
         arg = dofile( arg )
      end

      -- because it's another function or something crazy our dofile returned, we need to do some additional magic
      -- use of goto to keep things neat and change 2 lines into 1... awesome
      t = type( arg )
      if( t == "function" ) then
         arg = coroutine.create( arg )
      elseif( t ~= "thread" ) then
         print( "DR:wrap has reached the end of its two steps deep logic and did not end up with a thread." )
         return
      end
   end
   self.thread = arg
end

return DR
