local B = {}

---------------------------------------------
-- Davenge Buffer Constants and Globals    --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

TOP_FAVOR = 1
BOT_FAVOR = 2
MID_FAVOR = 3
COLOR_CHAR = "#"

local color_tab = {
   --reset
   n = string.char(27) .. "[0m",
   -- grey / dark grey
   z = string.char(27) .. "[0;37m",
   Z = string.char(27) .. "[1;37m",
   -- cyan
   c = string.char(27) .. "[0;36m",
   C = string.char(27) .. "[1;36m",
   -- megenta
   m = string.char(27) .. "[0;35m",
   M = string.char(27) .. "[1;35m",
   -- blue
   b = string.char(27) .. "[0;34m",
   B = string.char(27) .. "[1;34m",
   -- yellow
   y = string.char(27) .. "[0;33m",
   Y = string.char(27) .. "[1;33m",
   -- green
   g = string.char(27) .. "[0;32m",
   G = string.char(27) .. "[1;32m",
   -- red
   r = string.char(27) .. "[0;31m",
   R = string.char(27) .. "[1;31m",
}

---------------------------------------------
-- Davenge Buffer Helper Methods           --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

-- get substring at desired length, take into account colors and expand until we get the false length created by the color tags
local function getsubstr_color( str, length, ecc ) -- ecc expected color count
   local substr = str:sub( 1, length )
   local _ ,cc = substr:gsub( COLOR_CHAR .. ".", "" )
   if( cc ~= ecc ) then
      return getsubstr_color( str, ( length + cc * 2 ) - 1, cc )
   end
   return substr
end



---------------------------------------------
-- Davenge Buffer Methods                  --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

function B:new( width )
   local buffer = {}
   setmetatable( buffer, self )
   self.__index = self
   buffer.width = width;
   buffer.lines = {}
   buffer.favor = TOP_FAVOR
   return buffer
end

function B:parse( str )
   --simplify these into \r\n into one character, much easier to work with
   local str = str:gsub( '\r\n', '\n' )
   local str = str:gsub( '\n\r', '\n' )
   local i, c, aw, lastspace = 1, 0, self.width, 0
   local t = {}
   str:gsub( ".", function( char ) table.insert( t, #t+1, char ); end )

   repeat
      ::parsestart::
      if( t[i] == COLOR_CHAR ) then -- test for color, if color expand c by two but also expand our artificial width by two, inc by two
         i = i + 2
         aw = aw + 2 
         c = c + 2
         goto parsestart
      elseif( t[i] == '\n' ) then -- if nl, reset our count and aw to start,inc by 1
         c = 0
         aw = self.width
         i = i + 1
         goto parsestart
      end

      if( t[i] == ' ' ) then -- record where our last space was, for when we have to back it up to prevent line truncation
         lastspace = i
      end
      i = i + 1
      c = c + 1

      if( c == aw ) then
         if( t[i] == ' ' ) then
            t[i] = '\n'
            c = 0
            aw = self.width
            goto parsestart
         else
            if( lastspace > ( i - aw ) ) then
               t[lastspace] = '\n'
               i = lastspace + 1
            else
               table.insert( t, i+1, '\n' )
               i = i + 2
            end
            c = 1
            aw = self.width
            lastspace = 0
         end
      end
   until not t[i]

   if( t[i-1] ~= '\n') then
      t[i] = '\n'
   end

   
   local newstr = table.concat( t, "" )
   newstr:gsub( "(.-)\n", function( ln ) self.lines[#self.lines+1] = ln; end )
   return true
end

function B:length()
   local length
   for _,line in ipairs( self ) do
      length = length + #line
   end
   return length
end

function B:clear()
   self.lines = {}
end

B.__tostring = function ( buffer )
   return table.concat( buffer.lines, "\n" )
end

function B.buffers_to_string( table_of_buffers, pattern )
   local output = {}
   local height = 0
   local starting_height = {}
   local prepared_string = {}
   local iterators = {}
   -- need to find the buffer with the greatest "heigth"
   for _, buffer in pairs( table_of_buffers ) do
      height = #buffer.lines > height and #buffer.lines or height
   end
   for i, buffer in pairs( table_of_buffers ) do 
      -- if buffer is the height standard or is TOP_FAVOR it starts at 0
      if( #buffer.lines == height or buffer.favor == TOP_FAVOR ) then
         starting_height[i] = 1
      else
         -- otherwise, start at the difference
         starting_height[i] = ( height + 1 ) - #buffer.lines -- you have to add 1 because there is no line at 0...
      end

      -- now, if its mid favor, this numnber needs to be divided by 2
      -- bottom favor does not need to be touched, the difference is enough
      if( buffer.favor == MID_FAVOR ) then
         starting_height[i] = starting_height[i] / 2
      end
      iterators[i] = 1
   end

   -- now we need to prepare each buffers string
   -- then insert it into output after creating it with our pattern
   for h = 1, height, 1 do
      for i, buffer in pairs( table_of_buffers ) do
         if( starting_height[i] <= h ) then
            prepared_string[i] = buffer.lines[iterators[i]] or string.rep( " ", buffer.width )
            iterators[i] = iterators[i] + 1
            if( #prepared_string[i] < buffer.width ) then
               prepared_string[i] = prepared_string[i] .. string.rep( " ", buffer.width - #prepared_string[i] )
            end
         else
            prepared_string[i] = string.rep( " ", buffer.width )
         end
      end
      output[#output+1] = string.format( pattern, table.unpack( prepared_string ) )
   end

   return table.concat( output, '\n' )
end

function B.colorize( str )
   str = str:gsub( COLOR_CHAR .. "(.)", function( c )
      return color_tab[c] or c
   end )
   return str .. string.char(27) .. "[0m"
end

return B

