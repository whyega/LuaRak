local RakCore = require("LuaRak.core")
local utils = require("LuaRak.utils")



local BitStream = {}



function BitStream:new(...)
    local argCount = select("#", ...)
    if argCount == 0 or argCount == 3 then
        self.bitstream = RakCore.BitStream:new(...)
    else
        self.bitstream = ...
    end


    return setmetatable(self, {
        __index = function(t, k)
            return rawget(t, k)
        end
    })
end



function BitStream:reset()
    return self.bitstream:Reset()
end


function BitStream:resetReadPointer()
    return self.bitstream:ResetReadPointer()
end


function BitStream:resetWritePointer()
    return self.bitstream:ResetReadPointer()
end


function BitStream:setWriteOffset()
    return self.bitstream:SetWriteOffset()
end


function BitStream:getWriteOffset()
    return self.bitstream:GetWriteOffset()
end


function BitStream:setReadOffset(offset)
    return self.bitstream:SetReadOffset(offset)
end


function BitStream:getReadOffset()
    return self.bitstream:GetReadOffset()
end


function BitStream:getNumberOfBitsUsed()
    return self.bitstream:GetNumberOfBitsUsed()
end


function BitStream:getNumberOfBytesUsed()
    return self.bitstream:GetNumberOfBytesUsed()
end


function BitStream:getNumberOfUnreadBits()
    return self.bitstream:GetNumberOfUnreadBits()
end


function BitStream:getNumberOfUnreadBytes()
    return utils:convertBitsToBytes(self.bitstream:GetNumberOfUnreadBits())
end


function BitStream:ignoreBits(bits)
    return self.bitstream:IgnoreBits(bits)
end


function BitStream:ignoreBytes(bytes)
    return self.bitstream:IgnoreBits(utils:convertBytesToBits(bytes))
end


function BitStream:writeUInt8(value)
    return self.bitstream:WriteUInt8(value)
end


function BitStream:writeUInt16(value)
    return self.bitstream:WriteUInt16(value)
end


function BitStream:writeUInt32(value)
    return self.bitstream:WriteUInt32(value)
end


function BitStream:writeInt8(value)
    return self.bitstream:WriteInt8(value)
end


function BitStream:writeInt16(value)
    return self.bitstream:WriteInt16(value)
end


function BitStream:writeInt32(value)
    return self.bitstream:WriteInt32(value)
end


function BitStream:writeFloat(value)
    return self.bitstream:WriteFloat(value)
end


function BitStream:writeString(value)
    return self.bitstream:WriteString(value)
end



function BitStream:readUInt8()
    return self.bitstream:ReadUInt8()
end


function BitStream:readUInt16()
    return self.bitstream:ReadUInt16()
end


function BitStream:readUInt32()
    return self.bitstream:ReadUInt32()
end


function BitStream:readInt8()
    return self.bitstream:ReadInt8()
end


function BitStream:readInt16()
    return self.bitstream:ReadInt16()
end


function BitStream:readInt32()
    return self.bitstream:ReadInt32()
end


function BitStream:readFloat()
    return self.bitstream:ReadFloat()
end


function BitStream:readString(size)
    return self.bitstream:ReadString(size)
end


function BitStream:getBitStream()
    return self.bitstream
end


function BitStream:getDataPtr()
    return self.bitstream:GetData()
end



return BitStream