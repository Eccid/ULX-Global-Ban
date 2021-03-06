--ULX Global Ban
--Adobe And NigNog
------------------

//Require MySQLOO
local MySQLOO = require( 'mysqloo' )
require( 'mysqloo' )

//Include Globals
include('gb_config.lua')
if (GB_UseGateKeeper == true) then
	include('gb_gatekeeper.lua')
end

//Setup MySQLOO Connections
ULX_DB = mysqloo.connect(GB_DATABASE_HOST, GB_DATABASE_USERNAME, GB_DATABASE_PASSWORD, GB_DATABASE_NAME, GB_DATABASE_PORT)

include('gb_serverheartbeat.lua');
 
function afterConnected(database)
	print('[ULX GB] - Database Connection Successful ' )
	
	--Dam ULib Fails when inclduing this anywhere else...
	include('globalban/gb_banmanagement.lua')
	
	--Check Wether or not a server exists in the Database
	GB_QueryDatabaseForServer()
end

function connectToDatabase()
	print('[ULX GB] - Connecting to Database!')
	
	ULX_DB.onConnected = afterConnected
	ULX_DB:connect()
end

//Run the connection!
connectToDatabase()
 
//Keep the MySQL Database Open and Connected.
local function DbCheck()
	if (ULX_DB:status() != mysqloo.DATABASE_CONNECTED) then
		ULX_DB = mysqloo.connect(GB_DATABASE_HOST, GB_DATABASE_USERNAME, GB_DATABASE_PASSWORD, GB_DATABASE_NAME, GB_DATABASE_PORT)
		print('[ULX GB] - Database Connection Restarted' )
	end
end
timer.Create( 'DbCheck', 90, 0, DbCheck )