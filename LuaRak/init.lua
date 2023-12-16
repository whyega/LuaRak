local RakCore = require("LuaRak.core")
local LuaClient = require("LuaRak.samp.client")
local LuaServer = require("LuaRak.samp.server")
local bitstream = require("LuaRak.bitstream")



local LuaRak = {}



function LuaRak:client(nickname)
    return LuaClient:new(nickname)
end



function LuaRak:server(maxPlayers, port)
    return LuaServer:new(maxPlayers, port)
end



function LuaRak:BitStream(...)
    return bitstream:new(...)
end



function LuaRak:createProxy()
    return self:getCore().Proxy:new()
end



function LuaRak:loadClientModule(module)
    local path = ("LuaRak.samp.client.modules.%s"):format(module)
    return require(path)
end



function LuaRak:loadServerModule(module)
    local path = ("LuaRak.samp.server.modules.%s"):format(module)
    return require(path)
end



function LuaRak:getCore()
    return RakCore
end



return LuaRak