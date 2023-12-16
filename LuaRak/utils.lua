local bit = require("bit")



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



function utils:log(text)
    return print(("[LuaRak]: %s"):format(text))
end



return utils