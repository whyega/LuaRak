--[[
    HELLO NIGGERS
]]



local RakCore = require("LuaRak.core")
local utils = require("LuaRak.utils")
local bitstream = require("LuaRak.bitstream")
local handler = require("LuaRak.samp.client.handler")




local LuaClient = {}



function LuaClient:new(nickname, proxy)
    self.rakClient = RakCore.RakClient:new()
    assert(self.rakClient, "Error creating RakClient")

    assert(type(nickname) == "string", "Nickname is expected as a string")
    self.nickname = nickname

    self.proxy = proxy or RakCore.Proxy:new()
    self.receivePacketHandlers = {}

    self.rakClient:SetMTUSize(576)


    return setmetatable(self, {
        __index = function(t, k)
            return rawget(t, k)
        end
    })
end



function LuaClient:connect(ip, port, proxy)
    proxy = proxy or self.proxy
    return self.rakClient:Connect(ip, port, 0, 0, 5, proxy)
end



function LuaClient:disconnect(timeout)
    timeout = timeout or 1
    return self.rakClient:Disconnect(timeout)
end



function LuaClient:sendPacket(...)
    if type(...) == "table" then
        local bs = utils:getBitStream(...)
        return self.rakClient:SendBitStream(bs, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0)
    else
        local data = select(1, ...)
        local length = select(2, ...)
        return self.rakClient:SendData(data, length, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0)
    end
end



function LuaClient:sendRPC(rpcId, ...)
    if type(...) == "table" then
        local bs = utils:getBitStream(...)
        return self.rakClient:RPCBitStream(rpcId, bs, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0, false, RakCore.UNASSIGNED_NETWORK_ID, nil)
    else
        local data = select(1, ...)
        local length = select(2, ...)
        return self.rakClient:RPCData(rpcId, data, length, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0, false, RakCore.UNASSIGNED_NETWORK_ID, nil)
    end
end



function LuaClient:setFakePing(ping, isUse)
    if ping == nil then
        ping = self.rakClient:GetAveragePing()
        isUse = false
    end

    return self.rakClient:SetFakePing(isUse, ping)
end



function LuaClient:sendChat(text)
    local bs = bitstream:new()
    bs:writeUInt8(#text)
    bs:writeString(text)
    self:sendRPC(101, bs)
end



function LuaClient:sendCommand(command)
    local bs = bitstream:new()
    bs:writeUInt32(#command)
    bs:writeString(command)
    self:sendRPC(50, bs)
end



function LuaClient:sendRequestClass(classid)
    local bs = bitstream:new()
    bs:writeUInt32(classid)
    self:sendRPC(128, bs)
end



function LuaClient:sendRequestSpawn()
    self:sendRPC(129, "", 0)
end



function LuaClient:sendSpawn()
    self:sendRPC(52, "", 0)
end



function LuaClient:sendClickPlayer(playerId, source)
    local bs = bitstream:new()
    bs:writeUInt16(playerId)
    bs:writeUInt8(source)
    self:sendRPC(23, bs)
end



function LuaClient:sendClickTextdraw(textdrawId)
    local bs = bitstream:new()
    bs:writeUInt16(textdrawId)
    self:sendRPC(83, bs)
end



function LuaClient:sendDeathByPlayer(playerId, reason)
    local bs = bitstream:new()
    bs:writeUInt16(playerId)
    bs:writeUInt8(reason)
    self:sendRPC(53, bs)
end



function LuaClient:sendDialogResponse(dialogId, button, listitem, input)
    local bs = bitstream:new()
    bs:writeInt16(dialogId)
    bs:writeInt8(button)
    bs:writeInt16(listitem)
    bs:writeString8(input)
    self:sendRPC(62, bs)
end



function LuaClient:sampSendEditAttachedObject(response, index, model, bone, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ)
    local bs = bitstream:new()
    bs:writeInt32(response)
    bs:writeInt32(index)
    bs:writeInt32(model)
    bs:writeInt32(bone)
    bs:writeVector({offsetX, offsetY, offsetZ})
    bs:writeVector({rotX, rotY, rotZ})
    bs:writeVector({scaleX, scaleY, scaleZ})
    self:sendRPC(116, bs)
end



function LuaClient:sampSendEditObject(playerObject, objectId, response, posX, posY, posZ, rotX, rotY, rotZ)
    local bs = bitstream:new()
    bs:writeBool(playerObject)
    bs:writeInt16(objectId)
    bs:writeInt32(response)
    bs:writeVector({posX, posY, posZ})
    bs:writeVector({rotX, rotY, rotZ})
    self:sendRPC(117, bs)
end



function LuaClient:sampSendEnterVehicle(vehicleId, passenger)
    local bs = bitstream:new()
    bs:writeInt16(vehicleId)
    bs:writeBool(passenger)
    self:sendRPC(26, bs)
end



function LuaClient:sampSendExitVehicle(vehicleId)
    local bs = bitstream:new()
    bs:writeInt16(vehicleId)
    self:sendRPC(154, bs)
end



function LuaClient:sampSendGiveDamage(playerId, damage, weapon, bodypart)
    local bs = bitstream:new()
    bs:writeBool(false)
    bs:writeInt16(playerId)
    bs:writeFloat(damage)
    bs:writeInt32(weapon)
    bs:writeInt32(bodypart)
    self:sendRPC(115, bs)
end



function LuaClient:sampSendTakeDamage(playerId, damage, weapon, bodypart)
    local bs = bitstream:new()
    bs:writeBool(true)
    bs:writeInt16(playerId)
    bs:writeFloat(damage)
    bs:writeInt32(weapon)
    bs:writeInt32(bodypart)
    self:sendRPC(115, bs)
end



function LuaClient:sampSendInteriorChange(interiorId)
    local bs = bitstream:new()
    bs:writeInt8(interiorId)
    self:sendRPC(118, bs)
end



function LuaClient:sampSendMenuQuit()
    self:sendRPC(140, "", 0)
end



function LuaClient:sampSendMenuSelectRow(id)
    local bs = bitstream:new()
    bs:writeInt8(id)
    self:sendRPC(132, bs)
end



function LuaClient:updateNetwork()
    local packet = self.rakClient:Receive()

    if packet ~= nil then
        local bs = bitstream:new(packet.data, packet.length, false)
        local readOffset = bs:getReadOffset()
        bs:resetReadPointer()
        local packetId = bs:readUInt8()
        bs:setReadOffset(readOffset)
        for _, packetHandler in ipairs(self.receivePacketHandlers) do
            packetHandler(packetId, bs)
        end
        handler:processing(self, packetId, bs)

        self.rakClient:DeallocatePacket(packet)
    end
end



function LuaClient:addEventHandler(eventName, callback)
    local eventList = {
        ["onSendPacket"] = self.rakClient.RegisterSendHandler,
        ["onSendRPC"] = self.rakClient.RegisterRPCHandler,
        ["onReceiveRPC"] = self.rakClient.RegisterReceiveRPCHandler,
        ["onReceivePacket"] = function(_, handler)
            table.insert(self.receivePacketHandlers, handler)
        end
    }

    eventList[eventName](self.rakClient, callback)
end



function LuaClient:getRakClient()
    return self.rakClient
end



function LuaClient:getBotNickname()
    return self.nickname
end



return LuaClient