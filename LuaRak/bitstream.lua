local RakCore = require("LuaRak.core")
local utils = require("LuaRak.utils")
local ffi = require("ffi")



local BitStream = {}



---Create new BitStrream object 
---@param ... unknown
---@return table
function BitStream:new(...)
    local argCount = select("#", ...)
    if argCount == 0 or argCount == 3 then
        self.bitstream = RakCore.BitStream:new(...)
    else
        self.bitstream = ...
    end


    return setmetatable(self, {
        __index = rawget
    })
end



---Reset bitstream
function BitStream:reset()
    self.bitstream:Reset()
end


---Reset pointer of read
function BitStream:resetReadPointer()
    self.bitstream:ResetReadPointer()
end


---Reset pointer of write
function BitStream:resetWritePointer()
    self.bitstream:ResetReadPointer()
end


---Sets pointer of write
---@param offset number
function BitStream:setWriteOffset(offset)
    self.bitstream:SetWriteOffset(offset)
end


---Returns pointer of write
---@return number
function BitStream:getWriteOffset()
    return self.bitstream:GetWriteOffset()
end


---Sets pointer of read
---@param offset number
---@return unknown
function BitStream:setReadOffset(offset)
    return self.bitstream:SetReadOffset(offset)
end


---Return pointer of read
---@return number
function BitStream:getReadOffset()
    return self.bitstream:GetReadOffset()
end


---
---@return number
function BitStream:getNumberOfBitsUsed()
    return self.bitstream:GetNumberOfBitsUsed()
end

---
---@return number
function BitStream:getNumberOfBytesUsed()
    return self.bitstream:GetNumberOfBytesUsed()
end


---
---@return number
function BitStream:getNumberOfUnreadBits()
    return self.bitstream:GetNumberOfUnreadBits()
end


---
---@return integer
function BitStream:getNumberOfUnreadBytes()
    return utils:convertBitsToBytes(self.bitstream:GetNumberOfUnreadBits())
end


---
---@param bits number
---@return unknown
function BitStream:ignoreBits(bits)
    return self.bitstream:IgnoreBits(bits)
end


---
---@param bytes number
---@return unknown
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


function BitStream:writeVector3D(vector)
    for value = 1, 3 do
        self.bitstream:WriteFloat(value)
    end
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


---Returns the original BitStream class 
---@return userdata
function BitStream:getBitStream()
    return self.bitstream
end


---Return pointer of data 
---@return unknown
function BitStream:getDataPtr()
    return utils:getPointer(ffi.cast("unsigned char**", self.bitstream:GetData())[0])
end



return BitStream