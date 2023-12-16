#include "main.hpp"



static sol::table open(sol::this_state ts)
{	
	sol::state_view lua(ts);
	sol::table module = lua.create_table();

	module["VERSION"] = 0.5;	

	
	LuaRak luarak(module);

	luarak.InitializeRakClient();
	luarak.InitializeRakServer();
	luarak.InitializeBitStream();
	luarak.InitializeProxy();
	luarak.InitializeNetEncryption();


	return module;
}



SOL_MODULE_ENTRYPOINT(open);
