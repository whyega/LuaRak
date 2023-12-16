package.path = ("%s;..\\?\\init.lua"):format(package.path)
package.path = ("%s;..\\?.lua"):format(package.path)
package.cpath = ("%s;..\\?.dll"):format(package.cpath)


local LuaRak = require("LuaRak")


local server = LuaRak:server(1000, 7777)


while true do
    server:updateNetwork()
end