#pragma once

#include "BitStream.h"
#include <string>



using namespace RakNet;



namespace LuaBitStream {
	template <typename T>
	void WriteValue(BitStream& bs, T value)
	{
		bs.Write(value);
	}


	template <typename T>
	T ReadValue(BitStream& bs)
	{
		T value;
		bs.Read(value);
		return value;
	}


	void WriteString(BitStream& bs, std::string_view value);
	
	std::string ReadString(BitStream& bs, unsigned int len);
};