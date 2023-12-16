package.path = ("%s;..\\?\\init.lua"):format(package.path)
package.path = ("%s;..\\?.lua"):format(package.path)
package.cpath = ("%s;..\\?.dll"):format(package.cpath)


local LuaRak = require("LuaRak")



local client = LuaRak:client("LuaRak1")


local isSpawned = false

client:addEventHandler("onReceivePacket", function(id, bitstream)
    print("RECEIVE PACKET", id)
end)


client:addEventHandler("onReceiveRPC", function(rpcId, bitstream)
    print("RECEIVE RPC", rpcId)
    if rpcId == 12 and not isSpawned then
        client:sendRequestClass(101)
        client:sendRequestSpawn()
        client:sendSpawn()
        client:sendChat("TEst")
        -- client:sendCommand("/vw 31")
        isSpawned = true
    end
end)



local proxy = LuaRak:createProxy()
print(proxy:Start("163.5.108.211", "19149", "user147152", "1mch8z"))
proxy:SetReceivingByProxy(true);

client:setFakePing(5000)
client:connect("185.189.15.89", 7228, proxy)
-- client:connect("127.0.0.1", 7777, proxy)

while true do
    client:updateNetwork()
end