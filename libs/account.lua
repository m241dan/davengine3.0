local A = Data:raw()

A.all = {}
A.by_name = {}

A.__index = A
A.type = "account"
A.interp_path = "interpreters/account_interp.lua"
A.save_loc = "./accounts/"
A.save_name = "default_account"
A.level = 1

local wm = { __mode = "kv" }
setmetatable( A.by_name, wm )

function A:new( name, passwd )
   a = {}
   setmetatable( a, self )

  -- init some defaults
   a.name = name
   a.save_name = name
   a.passwd = passwd

  -- store in some lib arrays
   A.all[a] = a
   A.by_name[name] = a

   return a
end;

function A:serialize()
   return "Account:load( \"" .. self.save_loc .. self.name .. ".lua\" )"
end;

function A.load( path )
   local a = dofile( path )

   if( not a ) then
      print( "Could not load " .. path .. "." )
      return nil
   end

   if( not A.by_name[a.name] ) then
      setmetatable( a, self )
      A.all[a] = a
      A.by_name[a.name] = a
   else
      print( "An account with that name has already been loaded.\n" )
      a = nil
   end

   return a
end;

function A:delete()
   A.all[self] = nil
end

return A


