------------------------------------------------------------
-- Account utils is a util namespace for wrapping account --
-- specific actions into clean and easilly read funcs.    --
------------------------------------------------------------

local A = {}

function A.setupNewAccount( account, dm )
   account:setInterp( ACCOUNT_INTERP )
   dm:AASData( d.account )
   dm:setupInterp( d.account )
   account:save()
end;

function A.connectAccount( account, dm )
   dm:AASData( account )
   dm:setupInterp( account )
end;

return S
