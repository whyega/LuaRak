local RakCore = require("LuaRak.core")
local utils = require("LuaRak.utils")



local Proxy = {}



function Proxy:new(address, port, user, password)
    assert(utils:isType(address, "string"))

    port = tostring(port)
    self.proxy = RakCore.Proxy:new(address, port, user, password)


    return setmetatable(self, {
        __index = rawget
    })
end



function Proxy:connect(isNoAuth)
    local result = isNoAuth and self.proxy:startWithoutAuth() or self.proxy:startWithAuth()
    self.proxy:setReceivingByProxy(true)

    return result
end



function Proxy:getProxy()
    return self.proxy
end



return Proxy