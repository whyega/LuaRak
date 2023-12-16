#pragma once

#include "sol.hpp"

#include "samp_netencr.h"
#include "SOCKS5.hpp"
#include "RakClient.h"
#include "RakServer.h"

#include "LuaBitStream.hpp"



using namespace RakNet;



class LuaRak
{
public:
	LuaRak(sol::table& module);

	void InitializeRakClient();
	void InitializeRakServer();
	void InitializeBitStream();
	void InitializeProxy();
	void InitializeNetEncryption();


private:
	sol::table lua;
};
