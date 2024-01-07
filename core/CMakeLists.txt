cmake_minimum_required(VERSION 3.15)


set(CMAKE_COLOR_DIAGNOSTICS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

project(core VERSION 0.6 LANGUAGES CXX)


add_subdirectory("src/libs/RakNet")

add_library(${PROJECT_NAME} SHARED)


target_include_directories(${PROJECT_NAME} PUBLIC 
    "src/libs/lua"
    "src/libs/sol2"
)

target_sources(${PROJECT_NAME} PRIVATE
    "src/main.cpp"
    "src/LuaRak.cpp"
    "src/LuaBitStream.cpp"
)

target_link_libraries(${PROJECT_NAME} PRIVATE 
    RakNet
    ${CMAKE_SOURCE_DIR}/src/libs/lua/lua51.lib
)

target_compile_definitions(${PROJECT_NAME} PRIVATE MODULE_NAME=${PROJECT_NAME})