#pragma once

#include "sol.hpp"

#include "SOCKS5.hpp"
#include "RakClient.h"

#include "LuaBitStream.hpp"



using namespace RakNet;


class LuaRak
{
public:
	LuaRak(sol::table& module);

	void InitializeRakClient();
	void InitializeBitStream();
	void InitializeProxy();

private:
	sol::table lua;
};
