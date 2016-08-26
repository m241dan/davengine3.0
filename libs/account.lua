local A = Data:new()

A.__index = A
A.type = "account"
A.interp_path = "interpreters/account_interp.lua"
A.save_loc = "./accounts/"
A.save_name = "default_account"
A.level = 1

function A:new( name, passwd )
   a = {}
   setmetatable( a, self )

   -- init some defaults
   a.name = name
   a.passwd = passwd

   return a
end;

function A:serialize()
   return "Account:load( \"" .. self.save_loc .. self.name .. ".lua\" )"
end;

return A


