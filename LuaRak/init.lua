local RakCore = require("LuaRak.core")
local LuaClient = require("LuaRak.samp.client")
local LuaProxy = require("LuaRak.proxy")
local LuaBitStream = require("LuaRak.bitstream")



local LuaRak = {}


---Create new instance SAMP client
---@param nickname string
---@return table
function LuaRak:client(nickname)
    return LuaClient:new(nickname)
end


---Create new BitStream buffer
---@param ... unknown
---@return table
function LuaRak:BitStream(...)
    return LuaBitStream:new(...)
end


---Create SOCKS5 UDP proxy
---@param address string
---@param port number
---@param user string
---@param password string
---@return table
function LuaRak:proxy(address, port, user, password)
    return LuaProxy:new(address, port, user, password)
end


---Return core RakNet library
---@return unknown
function LuaRak:getCore()
    return RakCore
end



return LuaRak