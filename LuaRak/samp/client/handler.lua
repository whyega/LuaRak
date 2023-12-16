local bit = require("bit")
local utils = require("LuaRak.utils")
local bitstream = require("LuaRak.bitstream")
local misc = require("LuaRak.samp.client.misc")



local packetEnum = {
    [12] = function(client, packetId, bs)
        bs:ignoreBits(8)
        local len = bs:readUInt8()
        local input = bs:readString(len - 1)
        local authKey = misc:generateAuthKey(input)
        if authKey then
            local bsAuthPacket = bitstream:new()
            bsAuthPacket:writeUInt8(packetId)
            bsAuthPacket:writeUInt8(#authKey)
            bsAuthPacket:writeString(authKey)
            client:sendPacket(bsAuthPacket)
        else
            utils:log("Invalid auth key")
        end
    end,

    [34] = function(client, packetId, bs)
        bs:ignoreBits(56)
        local playerId = bs:readUInt16()
        local challenge = bs:readUInt32()
        local version = 4057

        local bsRPCJoin = bitstream:new()
        bsRPCJoin:writeInt32(version)
        bsRPCJoin:writeUInt8(1)
        bsRPCJoin:writeUInt8(#client.nickname)
        bsRPCJoin:writeString(client.nickname)
        bsRPCJoin:writeUInt32(bit.bxor(challenge, version))

        -- local gpci = --[[misc:generateGPCI(0x3e9)]] "zalupa"
        -- local gpci = RakCore.genGPCI(0x3e9)
        local gpci = "35715FF1E8AF1C05863FADF17EAB2C0DB5362632788"
        bsRPCJoin:writeUInt8(#gpci)
        bsRPCJoin:writeString(gpci)
        local clientVersion = "0.3.7-R3"
        bsRPCJoin:writeUInt8(#clientVersion)
        bsRPCJoin:writeString(clientVersion)

        client:sendRPC(25, bsRPCJoin)
    end
}



local PacketHandler = {}



function PacketHandler:processing(client, packetId, bs)
    local callback = packetEnum[packetId]
    if callback then callback(client, packetId, bs) end
end



return PacketHandler