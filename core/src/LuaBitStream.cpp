#include "LuaBitStream.hpp"



namespace LuaBitStream 
{
	void WriteString(BitStream& bs, std::string_view value)
	{
		bs.Write(value.data(), value.size());
	}


	std::string ReadString(BitStream& bs, unsigned int len)
	{
		std::string value(len, '\0');
		bs.Read(value.data(), len);
		return value;
	}
};