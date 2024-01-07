#include "main.hpp"



static sol::table open(sol::this_state ts)
{	
	sol::state_view lua(ts);
	sol::table module = lua.create_table();

	module["VERSION"] = 0.6;	
	

	LuaRak raklib(module);

	raklib.InitializeRakClient();
	raklib.InitializeBitStream();
	raklib.InitializeProxy();


	return module;
}


SOL_MODULE_ENTRYPOINT(open);