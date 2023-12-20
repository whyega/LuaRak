local RakCore = require("LuaRak.core")



local Proxy = {}



function Proxy:new(address, port, user, password, isActivity)
    self.proxy = RakCore.Proxy:new()
    self.proxy:Start(address, port, user, password)
    print(self.proxy.SetReceivingByProxy)
    if isActivity then self.proxy:SetReceivingByProxy(true) end

    return setmetatable(self, {
        __index = function(t, k)
            return rawget(t, k)
        end
    })
end



function Proxy:setReceiving(toggle)
    self.proxy:SetReceivingByProxy(toggle)
end



function Proxy:getProxy(toggle)
    return self.proxy
end



return Proxy