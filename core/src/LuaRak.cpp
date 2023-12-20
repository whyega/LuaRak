#include "LuaRak.hpp"



LuaRak::LuaRak(sol::table& module)
{	
	module.new_enum<PacketPriority>("PacketPriority", {
		{ "SYSTEM_PRIORITY", PacketPriority::SYSTEM_PRIORITY },
		{ "HIGH_PRIORITY", PacketPriority::HIGH_PRIORITY },
		{ "MEDIUM_PRIORITY", PacketPriority::MEDIUM_PRIORITY },
		{ "LOW_PRIORITY", PacketPriority::LOW_PRIORITY },
		{ "NUMBER_OF_PRIORITIES", PacketPriority::NUMBER_OF_PRIORITIES }
	});

	module.new_enum<PacketReliability>("PacketReliability", {
		{ "UNRELIABLE", PacketReliability::UNRELIABLE },
		{ "UNRELIABLE_SEQUENCED", PacketReliability::UNRELIABLE_SEQUENCED },
		{ "RELIABLE", PacketReliability::RELIABLE },
		{ "RELIABLE_ORDERED", PacketReliability::RELIABLE_ORDERED },
		{ "RELIABLE_SEQUENCED ", PacketReliability::RELIABLE_SEQUENCED  }
	});


	module.new_usertype<PlayerID>("PlayerID",
		"binaryAddress", &PlayerID::binaryAddress,
		"port", &PlayerID::port
	);

	module.new_usertype<NetworkID>("NetworkID",
		"playerId", &NetworkID::playerId,
		"localSystemId", &NetworkID::localSystemId
	);

	module.new_usertype<Packet>("Packet",
		"playerIndex", &Packet::playerIndex,
		"playerId", &Packet::playerId,
		"length", &Packet::length,
		"bitSize", &Packet::bitSize,
		"data", &Packet::data,
		"deleteData", &Packet::deleteData
	);

	module.new_usertype<RPCParameters>("RPCParameters",
		"input", &RPCParameters::input,
		"numberOfBitsOfData", &RPCParameters::numberOfBitsOfData,
		"sender", &RPCParameters::sender
	);

	module["UNASSIGNED_PLAYER_ID"] = std::ref(UNASSIGNED_PLAYER_ID);
	module["UNASSIGNED_NETWORK_ID"] = std::ref(UNASSIGNED_NETWORK_ID);	


	lua = module;
}



void LuaRak::InitializeRakClient()
{
	sol::usertype<RakClient> RakClientType = lua.new_usertype<RakClient>("RakClient", sol::constructors<RakClient()>());

	RakClientType["Connect"] = &RakClient::Connect;
	RakClientType["Disconnect"] = &RakClient::Disconnect;
	RakClientType["InitializeSecurity"] = &RakClient::InitializeSecurity;
	RakClientType["SetPassword"] = &RakClient::SetPassword;
	RakClientType["HasPassword"] = &RakClient::HasPassword;

	
	/*
	RakClientType["Send"] = sol::overload(
		static_cast<bool(RakClient::*)(BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel)>(&RakClient::Send),
		static_cast<bool(RakClient::*)(BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel)>(&RakClient::Send)
	);
	*/

	RakClientType["SendBitStream"] = [](RakClient& pRakClient, BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel)
	{
		return pRakClient.Send(bitStream, priority, reliability, orderingChannel);
	};

	RakClientType["SendData"] = [](RakClient& pRakClient, const char* data, const int length, PacketPriority priority, PacketReliability reliability, char orderingChannel)
	{
		return pRakClient.Send(data, length, priority, reliability, orderingChannel);
	};

	RakClientType["Receive"] = &RakClient::Receive;
	RakClientType["DeallocatePacket"] = &RakClient::DeallocatePacket;
	
	RakClientType["PingServer"] = sol::overload(
		[](RakClient& pRakClient)
		{
			return pRakClient.PingServer();
		},

		[](RakClient& pRakClient, const char* host, unsigned short serverPort, unsigned short clientPort, bool onlyReplyOnAcceptingConnections)
		{
			return pRakClient.PingServer(host, serverPort, clientPort, onlyReplyOnAcceptingConnections);
		}
	);

	RakClientType["GetAveragePing"] = &RakClient::GetAveragePing;
	RakClientType["GetLastPing"] = &RakClient::GetLastPing;
	RakClientType["GetLowestPing"] = &RakClient::GetLowestPing;
	RakClientType["GetPlayerPing"] = &RakClient::GetPlayerPing;
	RakClientType["StartOccasionalPing"] = &RakClient::StartOccasionalPing;
	RakClientType["StopOccasionalPing"] = &RakClient::StopOccasionalPing;
	RakClientType["IsConnected"] = &RakClient::IsConnected;
	RakClientType["GetSynchronizedRandomInteger"] = &RakClient::GetSynchronizedRandomInteger;
	RakClientType["GenerateCompressionLayer"] = &RakClient::GenerateCompressionLayer;
	RakClientType["DeleteCompressionLayer"] = &RakClient::DeleteCompressionLayer;
	RakClientType["RegisterAsRemoteProcedureCall"] = &RakClient::RegisterAsRemoteProcedureCall;
	RakClientType["RegisterClassMemberRPC"] = &RakClient::RegisterClassMemberRPC;
	RakClientType["UnregisterAsRemoteProcedureCall"] = &RakClient::UnregisterAsRemoteProcedureCall;
	RakClientType["GetPlayerPing"] = &RakClient::GetPlayerPing;

	/*
	RakClientType["RPC"] = sol::overload(
		[](RakClient& pRakClient, int rpcId, BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp, NetworkID networkId, BitStream* replyFromTarget)
		{
			return pRakClient.RPC(&rpcId, bitStream, priority, reliability, orderingChannel, shiftTimestamp, networkId, replyFromTarget);
		},

		[](RakClient& pRakClient, int rpcId, const char* data, unsigned int bitLength, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp, NetworkID networkId, BitStream* replyFromTarget)
		{
			return pRakClient.RPC(&rpcId, data, bitLength, priority, reliability, orderingChannel, shiftTimestamp, networkId, replyFromTarget);
		}
	);
	*/

	RakClientType["RPCBitStream"] = [](RakClient& pRakClient, int rpcId, BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp, NetworkID networkId, BitStream* replyFromTarget)
	{
		return pRakClient.RPC(&rpcId, bitStream, priority, reliability, orderingChannel, shiftTimestamp, networkId, replyFromTarget);
	};

	RakClientType["RPCData"] = [](RakClient& pRakClient, int rpcId, const char* data, unsigned int bitLength, PacketPriority priority, PacketReliability reliability, char orderingChannel, bool shiftTimestamp, NetworkID networkId, BitStream* replyFromTarget)
	{
		return pRakClient.RPC(&rpcId, data, bitLength, priority, reliability, orderingChannel, shiftTimestamp, networkId, replyFromTarget);
	};


	RakClientType["SetTrackFrequencyTable"] = &RakClient::SetTrackFrequencyTable;
	RakClientType["GetSendFrequencyTable"] = &RakClient::GetSendFrequencyTable;
	RakClientType["GetCompressionRatio"] = &RakClient::GetCompressionRatio;
	RakClientType["GetDecompressionRatio"] = &RakClient::GetDecompressionRatio;
	RakClientType["AttachPlugin"] = &RakClient::AttachPlugin;
	RakClientType["DetachPlugin"] = &RakClient::DetachPlugin;
	RakClientType["GetStaticServerData"] = &RakClient::GetStaticServerData;
	RakClientType["SetStaticServerData"] = &RakClient::SetStaticServerData;
	RakClientType["GetStaticClientData"] = &RakClient::GetStaticClientData;
	RakClientType["SetStaticClientData"] = &RakClient::SetStaticClientData;
	RakClientType["SendStaticClientDataToServer"] = &RakClient::SendStaticClientDataToServer;
	RakClientType["GetServerID"] = &RakClient::GetServerID;
	RakClientType["GetPlayerID"] = &RakClient::GetPlayerID;
	RakClientType["GetInternalID"] = &RakClient::GetInternalID;
	RakClientType["PlayerIDToDottedIP"] = &RakClient::PlayerIDToDottedIP;
	RakClientType["PushBackPacket"] = &RakClient::PushBackPacket;
	RakClientType["RemoveRouterInterface"] = &RakClient::RemoveRouterInterface;
	RakClientType["SetTimeoutTime"] = &RakClient::SetTimeoutTime;
	RakClientType["SetMTUSize"] = &RakClient::SetMTUSize;
	RakClientType["GetMTUSize"] = &RakClient::GetMTUSize;
	RakClientType["AllowConnectionResponseIPMigration"] = &RakClient::AllowConnectionResponseIPMigration;
	RakClientType["AdvertiseSystem"] = &RakClient::AdvertiseSystem;
	RakClientType["GetStatistics"] = &RakClient::GetStatistics;
	RakClientType["ApplyNetworkSimulator"] = &RakClient::ApplyNetworkSimulator;
	RakClientType["IsNetworkSimulatorActive"] = &RakClient::IsNetworkSimulatorActive;
	RakClientType["GetPlayerIndex"] = &RakClient::GetPlayerIndex;

	// Custom methods
	RakClientType["SetFakePing"] = &RakClient::SetFakePing;
	RakClientType["RegisterSendHandler"] = &RakClient::RegisterSendHandler;
	RakClientType["RegisterRPCHandler"] = &RakClient::RegisterRPCHandler;
	RakClientType["RegisterReceiveRPCHandler"] = &RakClient::RegisterReceiveRPCHandler;
}



void LuaRak::InitializeRakServer()
{
	sol::usertype<RakServer> RakServerType = lua.new_usertype<RakServer>("RakServer", sol::constructors<RakServer()>());

	RakServerType["Start"] = &RakServer::Start;
	RakServerType["InitializeSecurity"] = &RakServer::InitializeSecurity;
	RakServerType["DisableSecurity"] = &RakServer::DisableSecurity;
	RakServerType["SetPassword"] = &RakServer::SetPassword;
	RakServerType["HasPassword"] = &RakServer::HasPassword;
	RakServerType["Disconnect"] = &RakServer::InitializeSecurity;


	RakServerType["SendBitStream"] = [](RakServer& pRakServer, BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, PlayerID playerId, bool broadcast)
	{
		return pRakServer.Send(bitStream, priority, reliability, orderingChannel, playerId, broadcast);
	};

	RakServerType["SendData"] = [](RakServer& pRakServer, const char* data, const int length, PacketPriority priority, PacketReliability reliability, char orderingChannel, PlayerID playerId, bool broadcast)
	{
		return pRakServer.Send(data, length, priority, reliability, orderingChannel, playerId, broadcast);
	};

	RakServerType["Receive"] = &RakServer::Receive;
	RakServerType["Kick"] = &RakServer::Kick;
	RakServerType["DeallocatePacket"] = &RakServer::DeallocatePacket;
	RakServerType["SetAllowedPlayers"] = &RakServer::SetAllowedPlayers;
	RakServerType["GetAllowedPlayers"] = &RakServer::GetAllowedPlayers;
	RakServerType["GetConnectedPlayers"] = &RakServer::GetConnectedPlayers;
	RakServerType["GetPlayerIPFromID"] = &RakServer::GetPlayerIPFromID;
	RakServerType["PingPlayer"] = &RakServer::PingPlayer;
	RakServerType["GetAveragePing"] = &RakServer::GetAveragePing;
	RakServerType["GetLastPing"] = &RakServer::GetLastPing;
	RakServerType["GetLowestPing"] = &RakServer::GetLowestPing;
	RakServerType["StartOccasionalPing"] = &RakServer::StartOccasionalPing;
	RakServerType["StopOccasionalPing"] = &RakServer::StopOccasionalPing;
	RakServerType["IsActive"] = &RakServer::IsActive;
	RakServerType["GetSynchronizedRandomInteger"] = &RakServer::GetSynchronizedRandomInteger;
	RakServerType["StartSynchronizedRandomInteger"] = &RakServer::StartSynchronizedRandomInteger;
	RakServerType["StopSynchronizedRandomInteger"] = &RakServer::StopSynchronizedRandomInteger;
	RakServerType["GenerateCompressionLayer"] = &RakServer::GenerateCompressionLayer;
	RakServerType["DeleteCompressionLayer"] = &RakServer::DeleteCompressionLayer;
	RakServerType["RegisterAsRemoteProcedureCall"] = &RakServer::RegisterAsRemoteProcedureCall;
	RakServerType["RegisterClassMemberRPC"] = &RakServer::RegisterClassMemberRPC;
	RakServerType["UnregisterAsRemoteProcedureCall"] = &RakServer::UnregisterAsRemoteProcedureCall;

	RakServerType["RPCBitStream"] = [](RakServer& pRakServer, int rpcId, BitStream* bitStream, PacketPriority priority, PacketReliability reliability, char orderingChannel, PlayerID playerId, bool broadcast, bool shiftTimestamp, NetworkID networkId, BitStream* replyFromTarget)
	{
		return pRakServer.RPC(&rpcId, bitStream, priority, reliability, orderingChannel, playerId, broadcast, shiftTimestamp, networkId, replyFromTarget);
	};

	RakServerType["RPCData"] = [](RakServer& pRakServer, int rpcId, const char* data, unsigned int bitLength, PacketPriority priority, PacketReliability reliability, char orderingChannel, PlayerID playerId, bool broadcast, bool shiftTimestamp, NetworkID networkId, BitStream* replyFromTarget)
	{
		return pRakServer.RPC(&rpcId, data, bitLength, priority, reliability, orderingChannel, playerId, broadcast, shiftTimestamp, networkId, replyFromTarget);
	};

	RakServerType["SetTrackFrequencyTable"] = &RakServer::SetTrackFrequencyTable;
	RakServerType["GetSendFrequencyTable"] = &RakServer::GetSendFrequencyTable;
	RakServerType["GetCompressionRatio"] = &RakServer::GetCompressionRatio;
	RakServerType["GetDecompressionRatio"] = &RakServer::GetDecompressionRatio;
	RakServerType["AttachPlugin"] = &RakServer::AttachPlugin;
	RakServerType["DetachPlugin"] = &RakServer::DetachPlugin;
	RakServerType["GetStaticServerData"] = &RakServer::GetStaticServerData;
	RakServerType["SetStaticServerData"] = &RakServer::SetStaticServerData;
	RakServerType["SetRelayStaticClientData"] = &RakServer::SetRelayStaticClientData;
	RakServerType["SendStaticServerDataToClient"] = &RakServer::SendStaticServerDataToClient;
	RakServerType["SetOfflinePingResponse"] = &RakServer::SetOfflinePingResponse;
	RakServerType["GetStaticClientData"] = &RakServer::GetStaticClientData;
	RakServerType["SetStaticClientData"] = &RakServer::SetStaticClientData;
	RakServerType["ChangeStaticClientData"] = &RakServer::ChangeStaticClientData;
	RakServerType["GetNumberOfAddresses"] = &RakServer::GetNumberOfAddresses;
	RakServerType["GetLocalIP"] = &RakServer::GetLocalIP;
	RakServerType["GetInternalID"] = &RakServer::GetInternalID;
	RakServerType["PushBackPacket"] = &RakServer::PushBackPacket;
	RakServerType["SetRouterInterface"] = &RakServer::SetRouterInterface;
	RakServerType["RemoveRouterInterface"] = &RakServer::RemoveRouterInterface;
	RakServerType["GetIndexFromPlayerID"] = &RakServer::GetIndexFromPlayerID;
	RakServerType["GetPlayerIDFromIndex"] = &RakServer::GetPlayerIDFromIndex;
	RakServerType["AddToBanList"] = &RakServer::AddToBanList;
	RakServerType["RemoveFromBanList"] = &RakServer::RemoveFromBanList;
	RakServerType["ClearBanList"] = &RakServer::ClearBanList;
	RakServerType["IsBanned"] = &RakServer::IsBanned;
	RakServerType["IsActivePlayerID"] = &RakServer::IsActivePlayerID;
	RakServerType["SetTimeoutTime"] = &RakServer::SetTimeoutTime;
	RakServerType["SetMTUSize"] = &RakServer::SetMTUSize;
	RakServerType["GetMTUSize"] = &RakServer::GetMTUSize;
	RakServerType["AdvertiseSystem"] = &RakServer::AdvertiseSystem;
	RakServerType["GetStatistics"] = &RakServer::GetStatistics;
	RakServerType["ApplyNetworkSimulator"] = &RakServer::ApplyNetworkSimulator;
	RakServerType["IsNetworkSimulatorActive"] = &RakServer::IsNetworkSimulatorActive;
}



void LuaRak::InitializeBitStream()
{
	sol::usertype<BitStream> BitStreamType = lua.new_usertype<BitStream>("BitStream", sol::constructors<BitStream(), BitStream(unsigned char* data, unsigned int lengthInBytes, bool copyData)>());

	BitStreamType["Reset"] = &BitStream::Reset;
	BitStreamType["ResetReadPointer"] = &BitStream::ResetReadPointer;
	BitStreamType["ResetWritePointer"] = &BitStream::ResetWritePointer;
	BitStreamType["SetWriteOffset"] = &BitStream::SetWriteOffset;
	BitStreamType["GetWriteOffset"] = &BitStream::GetWriteOffset;
	BitStreamType["SetReadOffset"] = &BitStream::SetReadOffset;
	BitStreamType["GetReadOffset"] = &BitStream::GetReadOffset;
	BitStreamType["GetNumberOfBitsUsed"] = &BitStream::GetNumberOfBitsUsed;
	BitStreamType["GetNumberOfBytesUsed"] = &BitStream::GetNumberOfBytesUsed;
	BitStreamType["GetNumberOfUnreadBits"] = &BitStream::GetNumberOfUnreadBits;
	BitStreamType["IgnoreBits"] = &BitStream::IgnoreBits;
	BitStreamType["GetData"] = &BitStream::GetData;
	
	BitStreamType["WriteUInt8"] = &LuaBitStream::WriteValue<unsigned char>;
	BitStreamType["WriteUInt16"] = &LuaBitStream::WriteValue<unsigned short>;
	BitStreamType["WriteUInt32"] = &LuaBitStream::WriteValue<unsigned int>;
	BitStreamType["WriteInt8"] = &LuaBitStream::WriteValue<char>;
	BitStreamType["WriteInt16"] = &LuaBitStream::WriteValue<short>;
	BitStreamType["WriteInt32"] = &LuaBitStream::WriteValue<int>;
	BitStreamType["WriteBool"] = &LuaBitStream::WriteValue<bool>;
	BitStreamType["WriteFloat"] = &LuaBitStream::WriteValue<float>;
	BitStreamType["WriteString"] = &LuaBitStream::WriteString;

	BitStreamType["ReadUInt8"] = &LuaBitStream::ReadValue<unsigned char>;
	BitStreamType["ReadUInt16"] = &LuaBitStream::ReadValue<unsigned short>;
	BitStreamType["ReadUInt32"] = &LuaBitStream::ReadValue<unsigned int>;
	BitStreamType["ReadInt8"] = &LuaBitStream::ReadValue<char>;
	BitStreamType["ReadInt16"] = &LuaBitStream::ReadValue<short>;
	BitStreamType["ReadInt32"] = &LuaBitStream::ReadValue<int>;
	BitStreamType["ReadBool"] = &LuaBitStream::ReadValue<bool>;
	BitStreamType["ReadFloat"] = &LuaBitStream::ReadValue<float>;
	BitStreamType["ReadString"] = &LuaBitStream::ReadString;	
}



void LuaRak::InitializeProxy()
{
	sol::usertype<SOCKS5::SOCKS5> ProxyType = lua.new_usertype<SOCKS5::SOCKS5>("Proxy", sol::constructors<SOCKS5::SOCKS5()>());

	ProxyType["Start"] = sol::overload(
		static_cast<bool (SOCKS5::SOCKS5::*)(const std::string ProxyIP, const std::string ProxyPort)>(&SOCKS5::SOCKS5::Start),
		static_cast<bool (SOCKS5::SOCKS5::*)(const std::string ProxyIP, const std::string ProxyPort, const std::string ProxyLogin, const std::string ProxyPassword)>(&SOCKS5::SOCKS5::Start)
	);

	ProxyType["SendTo"] = &SOCKS5::SOCKS5::SendTo;
	ProxyType["RecvFrom"] = &SOCKS5::SOCKS5::RecvFrom;
	ProxyType["IsStarted"] = &SOCKS5::SOCKS5::IsStarted;
	ProxyType["getIP"] = &SOCKS5::SOCKS5::GetProxyIP;
	ProxyType["getPORT"] = &SOCKS5::SOCKS5::GetProxyPort;
	ProxyType["IsValidProxy"] = &SOCKS5::SOCKS5::IsValidProxy;
	ProxyType["SetValidProxy"] = &SOCKS5::SOCKS5::SetValidProxy;
	ProxyType["IsReceivingByProxy"] = &SOCKS5::SOCKS5::IsReceivingByProxy;
	ProxyType["SetReceivingByProxy"] = &SOCKS5::SOCKS5::SetReceivingByProxy;
}



void LuaRak::InitializeNetEncryption()
{
	lua.set_function("kyretardizeDatagram", kyretardizeDatagram);
	lua.set_function("unKyretardizeDatagram", unKyretardizeDatagram);
}



void LuaRak::InitializeStringCompressor()
{
	sol::usertype<StringCompressor> StringCompressorType = lua.new_usertype<StringCompressor>("StringCompressor");
	StringCompressorType["AddReference"] = &StringCompressor::AddReference;	
	StringCompressorType["DecodeString"] = &StringCompressor::DecodeString;
	StringCompressorType["EncodeString"] = &StringCompressor::EncodeString;
	StringCompressorType["GenerateTreeFromStrings"] = &StringCompressor::GenerateTreeFromStrings;
	StringCompressorType["Instance"] = &StringCompressor::Instance;
	StringCompressorType["RemoveReference"] = &StringCompressor::RemoveReference;
}