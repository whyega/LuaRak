cmake_minimum_required(VERSION 3.15)

project("RakNet")


add_library(${PROJECT_NAME} STATIC)


target_include_directories(${PROJECT_NAME} PUBLIC 
    "include"
    "../sol2"
    "../lua"
)


target_sources(${PROJECT_NAME} PRIVATE
    "src/_findfirst.cpp"
    "src/BitStream.cpp"
    "src/CheckSum.cpp"
    "src/CommandParserInterface.cpp"
    "src/ConsoleServer.cpp"
    "src/DataBlockEncryptor.cpp"
    "src/DataCompressor.cpp"
    "src/DS_ByteQueue.cpp"
    "src/DS_HuffmanEncodingTree.cpp"
    "src/DS_Table.cpp"
    "src/GetTime.cpp"
    "src/InternalPacketPool.cpp"
    "src/LinuxStrings.cpp"
    "src/LogCommandParser.cpp"

    # SAMP
    "src/NetEncrypt.cpp"

    "src/NetworkIDGenerator.cpp"
    "src/NetworkTypes.cpp"
    "src/PluginInterface.cpp"
    "src/RakClient.cpp"
    "src/RakNetCommandParser.cpp"
    "src/RakNetStatistics.cpp"
    "src/RakNetworkFactory.cpp"
    "src/RakPeer.cpp"
    "src/RakSleep.cpp"
    "src/Rand.cpp"
    "src/ReliabilityLayer.cpp"
    "src/rijndael.cpp"
    "src/RPCMap.cpp"
    "src/SHA1.cpp"
    "src/SimpleMutex.cpp"
    "src/SocketLayer.cpp"
    "src/StringCompressor.cpp"
    "src/StringTable.cpp"
    "src/SystemAddressList.cpp"
    "src/SystemDatabaseClient.cpp"
    "src/SystemDatabaseServer.cpp"
    "src/TableSerializer.cpp"
)