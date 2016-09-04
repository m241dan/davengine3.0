local input, con, dm, d, state

local sub_i = {}

sub_i[1] = function()
   input = string.capitalize( input )
   local path = Account.save_loc .. input .. ".lua"
   -- start with if its already connected???
   d.account = Account.by_name[input]
   if( d.account ) then
      con:send( "\r\nWhat is your password?: " )
      state = 4
   -- then loading from file
   elseif( Luatils.fileExists( path ) ) then
      con:send( "\r\nWhat is your password?: " )
      d.account = Account.load( path )
      state = 2
   -- then creating a new one!    
   else
      con:send( "\r\nNew account? Enter a password for the new account!: " )
      d.entered_name = input
      state = 3
   end
end;

sub_i[2] = function()
   if( d.account.passwd == LuaSha.hash256( input ) ) then
      AccountUtils.connectAccount( d.account, dm )
      ServerUtils.cleanUpNewConnection( dm, d )
   else
      con:send( "\r\nWrong password. Try again: " )
   end
end;

sub_i[3] = function()
   d.entered_pw = LuaSha.hash256( input )
   con:send( "\r\nEnter same password again: " )
   if( d.entered_pw ~= LuaSha.hash256( coroutine.yield() ) ) then
      con:send( "\r\nPasswords did not match!\r\nEnter a password for the new account!: " )
   else
      local new_account = Account:new( d.entered_name, d.entered_pw )
      AccountUtils.setupNewAccount( new_connect, dm )
      ServerUtils.cleanUpNewConnection( dm, d )
   end
end;

sub_i[4] = function()
   if( d.account.passwd == LuaSha.hash256( input ) ) then
      old_dm = DataManager.by_data[d.account]

      -- handle case one, the account was hanging
      if( not old_dm ) then
         AccountUtils.connectAccount( d.account, dm )
         ServerUtils.cleanUpNewConnect( dm, d )
      -- handle case two, this account has a DM already...
      else
         AccountUtils.handleTakeOver( d.account, d, dm, old_dm )
         -- no need for cleanUpNewConnect, handleTakeOver deals with this because things vary with it based on circumstance, order may matter
      end
                   
   else
      con:send( "\r\nWrong password. Try again: " )
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
