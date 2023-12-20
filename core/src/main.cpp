#include "main.hpp"



static sol::table open(sol::this_state ts)
{	
	sol::state_view lua(ts);
	sol::table module = lua.create_table();

	module["VERSION"] = 0.6;	

	
	LuaRak luarak(module);

	luarak.InitializeRakClient();
	luarak.InitializeRakServer();
	luarak.InitializeBitStream();
	luarak.InitializeProxy();
	luarak.InitializeNetEncryption();
	luarak.InitializeStringCompressor();


	return module;
}



SOL_MODULE_ENTRYPOINT(open);
