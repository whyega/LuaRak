--[[

]]


local RakCore = require("LuaRak.core")
local bitstream = require("LuaRak.bitstream")
local handler = require("LuaRak.samp.server.handler")



local LuaServer = {}



function LuaServer:new(maxPlayers, port)
    self.rakServer = RakCore.RakServer:new()
    assert(self.rakServer, "Error creating RakServer")

    self.rakServer:Start(maxPlayers, 0, 5, port)
    self.rakServer:StartOccasionalPing()


    return setmetatable(self, {
        __index = self
    })
end



function LuaServer:updateNetwork()
    local packet = self.rakServer:Receive()

    if packet ~= nil then
        local bs = bitstream:new(packet.data, packet.length, false)
        handler:processing(self, bs)

        self.rakClient:DeallocatePacket(packet)
    end
end



function LuaServer:getRakServer()
    return self.rakServer
end



return LuaServer