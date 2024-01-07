local bit = require("bit")
local ffi = require("ffi")



local utils = {}



function utils:convertBitsToBytes(bits)
    return bit.rshift(bits + 7, 3)
end


function utils:convertBytesToBits(bytes)
    return bit.lshift(bytes, 3)
end


function utils:getBitStream(bitstream)
    return type(bitstream) == "userdata" and bitstream or bitstream:getBitStream()
end


function utils:getProxy(proxy)
    return type(proxy) == "userdata" and proxy or proxy:getProxy()
end


function utils:log(text)
    return print(("[LuaRak]: %s"):format(text))
end


function utils:isType(value, inType)
    return type(value) == inType
end


function utils:getPointer(cdata)
    return tonumber(ffi.cast("uintptr_t", ffi.cast("void*", cdata)))
end



return utils