--[[
    Wrapper RakClient
]]



local RakCore = require("LuaRak.core")
local utils = require("LuaRak.utils")
local LuaBitStream = require("LuaRak.bitstream")
local handler = require("LuaRak.samp.client.handler")



local LuaClient = {}



---Create new client
---@param nickname string
---@return table LuaClient
function LuaClient:new(nickname)
    self.rakClient = RakCore.RakClient:new()
    assert(self.rakClient, "Error creating RakClient")

    assert(utils:isType(nickname, "string"), "Nickname is expected as a string")
    self.nickname = nickname
    self.playerId = -1
    self.sampVersion = "0.3.7-R3"

    self.receivePacketHandlers = {}
    self.receiveRPCHandlers = {}

    self.rakClient:SetMTUSize(576)

    self.rakClient:RegisterReceiveRPCHandler(function(rpcId, bs)
        for _, ReceiveRPCHandler in ipairs(self.receiveRPCHandlers) do
            ReceiveRPCHandler(rpcId, LuaBitStream:new(bs))
        end
    end)


    return setmetatable(self, {
        __index = rawget
    })
end


---Connect to the server
---@param ip string
---@param port number
---@param proxy any
---@return boolean
function LuaClient:connect(ip, port, proxy)
    proxy = proxy and proxy:getProxy() or RakCore.Proxy:new()
    return self.rakClient:Connect(ip, port, 0, 0, 5, proxy)
end


---Disconnects from the server
---@param timeout number
function LuaClient:disconnect(timeout)
    self.playerId = -1
    timeout = timeout or 1
    self.rakClient:Disconnect(timeout)
end


---Sends a packet to the server
---@param ... unknown
---@return boolean
function LuaClient:sendPacket(...)    
    if utils:isType(..., "table") then
        local bs = utils:getBitStream(...)
        return self.rakClient:SendBitStream(bs, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0)
    else
        local data = select(1, ...)
        local length = select(2, ...)
        return self.rakClient:SendData(data, length, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0)
    end
end


---Sends a RPC to the server
---@param rpcId number
---@param ... unknown
---@return boolean
function LuaClient:sendRPC(rpcId, ...)
    if utils:isType(..., "table") then
        local bs = utils:getBitStream(...)
        return self.rakClient:RPCBitStream(rpcId, bs, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0, false, RakCore.UNASSIGNED_NETWORK_ID, nil)
    else
        local data = select(1, ...)
        local length = select(2, ...)
        return self.rakClient:RPCData(rpcId, data, length, RakCore.PacketPriority.HIGH_PRIORITY, RakCore.PacketReliability.RELIABLE_ORDERED, 0, false, RakCore.UNASSIGNED_NETWORK_ID, nil)
    end
end


---Update the network
function LuaClient:updateNetwork()
    local packet = self.rakClient:Receive()

    if packet ~= nil then
        local bs = LuaBitStream:new(packet.data, packet.length, false)
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



---Adds an event handler
---@param eventName string
---@param callback function
function LuaClient:addEventHandler(eventName, callback)
    local eventList = {
        ["onReceivePacket"] = function(inputHandler)
            table.insert(self.receivePacketHandlers, inputHandler)
        end,
        ["onReceiveRPC"] = function(inputHandler)
            table.insert(self.receiveRPCHandlers, inputHandler)
        end
    }

    eventList[eventName](callback)
end


---Returns RakClient
---@return userdata
function LuaClient:getRakClient()
    return self.rakClient
end


---Sets the SAMP version for connect
---@param version string
function LuaClient:setSAMPVersion(version)
    self.sampVersion = version
end


---Sets client nickname
---@param nickname string
function LuaClient:setNickname(nickname)
    self.nickname = nickname
end


---Return client nickname
---@return string
function LuaClient:getNickname()
    return self.nickname
end


---Return player ID
---@return integer
function LuaClient:getId()
    return self.playerId
end



function LuaClient:sendChat(text)
    local bs = LuaBitStream:new()
    bs:writeUInt8(#text)
    bs:writeString(text)
    self:sendRPC(101, bs)
end



function LuaClient:sendCommand(command)
    local bs = LuaBitStream:new()
    bs:writeUInt32(#command)
    bs:writeString(command)
    self:sendRPC(50, bs)
end



function LuaClient:sendRequestClass(classid)
    local bs = LuaBitStream:new()
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
    local bs = LuaBitStream:new()
    bs:writeUInt16(playerId)
    bs:writeUInt8(source)
    self:sendRPC(23, bs)
end



function LuaClient:sendClickTextdraw(textdrawId)
    local bs = LuaBitStream:new()
    bs:writeUInt16(textdrawId)
    self:sendRPC(83, bs)
end



function LuaClient:sendDeathByPlayer(playerId, reason)
    local bs = LuaBitStream:new()
    bs:writeUInt16(playerId)
    bs:writeUInt8(reason)
    self:sendRPC(53, bs)
end



function LuaClient:sendDialogResponse(dialogId, button, listitem, input)
    local bs = LuaBitStream:new()
    bs:writeInt16(dialogId)
    bs:writeInt8(button)
    bs:writeInt16(listitem)
    bs:writeString8(input)
    self:sendRPC(62, bs)
end



function LuaClient:sampSendEditAttachedObject(response, index, model, bone, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ)
    local bs = LuaBitStream:new()
    bs:writeInt32(response)
    bs:writeInt32(index)
    bs:writeInt32(model)
    bs:writeInt32(bone)
    bs:writeVector3D({offsetX, offsetY, offsetZ})
    bs:writeVector3D({rotX, rotY, rotZ})
    bs:writeVector3D({scaleX, scaleY, scaleZ})
    self:sendRPC(116, bs)
end



function LuaClient:sampSendEditObject(playerObject, objectId, response, posX, posY, posZ, rotX, rotY, rotZ)
    local bs = LuaBitStream:new()
    bs:writeBool(playerObject)
    bs:writeInt16(objectId)
    bs:writeInt32(response)
    bs:writeVector3D({posX, posY, posZ})
    bs:writeVector3D({rotX, rotY, rotZ})
    self:sendRPC(117, bs)
end



function LuaClient:sampSendEnterVehicle(vehicleId, passenger)
    local bs = LuaBitStream:new()
    bs:writeInt16(vehicleId)
    bs:writeBool(passenger)
    self:sendRPC(26, bs)
end



function LuaClient:sampSendExitVehicle(vehicleId)
    local bs = LuaBitStream:new()
    bs:writeInt16(vehicleId)
    self:sendRPC(154, bs)
end



function LuaClient:sampSendGiveDamage(playerId, damage, weapon, bodypart)
    local bs = LuaBitStream:new()
    bs:writeBool(false)
    bs:writeInt16(playerId)
    bs:writeFloat(damage)
    bs:writeInt32(weapon)
    bs:writeInt32(bodypart)
    self:sendRPC(115, bs)
end



function LuaClient:sampSendTakeDamage(playerId, damage, weapon, bodypart)
    local bs = LuaBitStream:new()
    bs:writeBool(true)
    bs:writeInt16(playerId)
    bs:writeFloat(damage)
    bs:writeInt32(weapon)
    bs:writeInt32(bodypart)
    self:sendRPC(115, bs)
end



function LuaClient:sampSendInteriorChange(interiorId)
    local bs = LuaBitStream:new()
    bs:writeInt8(interiorId)
    self:sendRPC(118, bs)
end



function LuaClient:sampSendMenuQuit()
    self:sendRPC(140, "", 0)
end



function LuaClient:sampSendMenuSelectRow(id)
    local bs = LuaBitStream:new()
    bs:writeInt8(id)
    self:sendRPC(132, bs)
end



return LuaClient