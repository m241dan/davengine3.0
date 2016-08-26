local input, con, dm, d, state

local sub_i = {}

sub_i[1] = function()
   local path = Account.save_path .. input .. ".lua"
   if( Luatils.fileExists( path ) ) then
      con:send( "\r\nWhat is your password?: " )
      d.account = Account.load( path )
      state = 2
   else
      con:send( "\r\nNew account? Enter a password for the new account!: " )
      d.entered_name = input
      state = 3
   end
end;

sub_i[2] = function()
   if( d.account.passwd == LuaSha.hash256( input ) ) then
      dm:AASData( d.account )
      dm:setupInterp( d.account )
      d.account = nil -- not sure this is needed
      dm:remData( d )
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
      new_account:setInterp( ACCOUNT_INTERP )
      dm:AASData( new_account )
      dm:setupInterp( new_account )
      new_account:save()
     
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
   print( "I'M DYING!!!\r\n" )
end

return coroutine.create( interpreter )
