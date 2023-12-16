local bitstream = require("LuaRak.bitstream")



local packetEnum = {

}



local PacketHandler = {}



function PacketHandler:processing(client, bs)
    local readOffset = bs:getReadOffset()
    bs:resetReadPointer()
    local packetId = bs:readUInt8()
    bs:setReadOffset(readOffset)
    local callback = packetEnum[packetId]
    if callback then callback(client, packetId, bs) end
end



return PacketHandler