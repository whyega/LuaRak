package.path = ("%s;..\\?\\init.lua;..\\?.lua"):format(package.path)
package.cpath = ("%s;..\\?.dll;.\\luajit\\lua\\?.dll"):format(package.cpath)


local effil = require("effil")



-- Каждый бот будет работать в своем потоке (спасибо Lua за его крутую многопоточность!)
local runner = effil.thread(function(nickname, host, port, proxyIP, proxyPort, proxyUser, proxyPass)
    local LuaRak = require("LuaRak")


    -- Если при вызове потока мы укажем прокси, то создастся прокси 0_0
    local proxy
    if host and port then
        proxy = LuaRak:proxy(proxyIP, proxyPort, proxyUser, proxyPass)
    end

    local client = LuaRak:client(nickname)


    -- Вешаем обработчики на входящие и исходящие пакеты
    client:addEventHandler("onReceivePacket", function(id, bitstream)
        print(string.format("RECEIVE PACKET: ID - %d | LENGTH - %d", id, bitstream:getNumberOfBytesUsed()))
    end)


    client:addEventHandler("onReceiveRPC", function(id, bitstream)
        print(string.format("RECEIVE RPC: ID - %d | LENGTH - %d", id, bitstream:getNumberOfBytesUsed()))

        if id == 101 then
            bitstream:ignoreBytes(2)
            local text = bitstream:readString(bitstream:readUInt8())
            print(string.format("[CHAT] %s", text))
        elseif id == 93 then
            bitstream:ignoreBytes(4)
            local text = bitstream:readString(bitstream:readUInt32())
            print(string.format("[MESSAGE] %s", text))
        end
    end)


    -- Получаем объект RakClient'а, который использует наш бот и вызываем кастомный метод (установка пинга)
    client:getRakClient():SetFakePing(true, 2^16)
    proxy:connect()
    client:connect(host, port, proxy)


    -- В бесконечном цикле обновляем входящие пакеты и прочую лабуду
    while true do
        -- Ставим задержку в 1мс на каждй итерации, дабы LuaJIT не ел ЦП
        effil.sleep(1, "ms")
        -- Само обновление сети
        client:updateNetwork()
    end
end)


-- Создаем 3 экземпляра потока
for i = 1, 3 do
    runner("LuaRakTest" .. tostring(i), "185.189.15.89", 7228, "85.143.41.139", 63649, "jsPZJFhR", "nX2Jtv3t")
end


-- Дабы основной поток не загнулся, приходится оставлять еще один бесконечный цикл с задержкой в 1 секунду
while true do effil.sleep(1) end