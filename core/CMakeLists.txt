cmake_minimum_required(VERSION 3.0)

project(core)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_library(${PROJECT_NAME} SHARED
    src/libs/Misc/samp_netencr.cpp
    src/libs/RakNet/BitStream.cpp
    src/libs/RakNet/CheckSum.cpp
    src/libs/RakNet/CommandParserInterface.cpp
    src/libs/RakNet/ConsoleServer.cpp
    src/libs/RakNet/DataBlockEncryptor.cpp
    src/libs/RakNet/DataCompressor.cpp
    src/libs/RakNet/DS_ByteQueue.cpp
    src/libs/RakNet/DS_HuffmanEncodingTree.cpp
    src/libs/RakNet/DS_Table.cpp
    src/libs/RakNet/GetTime.cpp
    src/libs/RakNet/InternalPacketPool.cpp
    src/libs/RakNet/LinuxStrings.cpp
    src/libs/RakNet/LogCommandParser.cpp
    src/libs/RakNet/NetworkIDGenerator.cpp
    src/libs/RakNet/NetworkTypes.cpp
    src/libs/RakNet/PluginInterface.cpp
    src/libs/RakNet/RakClient.cpp
    src/libs/RakNet/RakNetCommandParser.cpp
    src/libs/RakNet/RakNetStatistics.cpp
    src/libs/RakNet/RakNetworkFactory.cpp
    src/libs/RakNet/RakPeer.cpp
    src/libs/RakNet/rakserver.cpp
    src/libs/RakNet/RakSleep.cpp
    src/libs/RakNet/Rand.cpp
    src/libs/RakNet/ReliabilityLayer.cpp
    src/libs/RakNet/rijndael.cpp
    src/libs/RakNet/RPCMap.cpp
    src/libs/RakNet/SHA1.cpp
    src/libs/RakNet/SimpleMutex.cpp
    src/libs/RakNet/SocketLayer.cpp
    src/libs/RakNet/StringCompressor.cpp
    src/libs/RakNet/StringTable.cpp
    src/libs/RakNet/SystemAddressList.cpp
    src/libs/RakNet/SystemDatabaseClient.cpp
    src/libs/RakNet/SystemDatabaseServer.cpp
    src/libs/RakNet/TableSerializer.cpp
    src/libs/RakNet/_findfirst.cpp
    src/LuaBitStream.cpp
    src/LuaRak.cpp
    src/main.cpp
)


target_include_directories(${PROJECT_NAME} PRIVATE 
    src/libs/RakNet
    src/libs/lua
    src/libs/Misc
    src/libs/sol2
)


if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32 _DEBUG _WINDOWS _USRDLL LUA_BUILD_AS_DLL MODULE_NAME=${PROJECT_NAME})
else()
    target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32 NDEBUG _WINDOWS _USRDLL LUA_BUILD_AS_DLL MODULE_NAME=${PROJECT_NAME})
    target_link_directories(${PROJECT_NAME} PRIVATE src/libs/RakNet)
endif()


target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/src/libs/lua/lua51.lib)