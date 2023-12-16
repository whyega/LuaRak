local Route = {}



local types = {
    string = "pathToFile",
    table = "queue"
}



function Route:new(client, input)
    local val = types[input]
    assert(val, "The value must have the value of a table or string")
    self[val] = input

    self.client = client
    self.isStared = false
    self.isStopped = false
    self.isPaused = false


    return setmetatable(self, {
        __index = function(t, k)
            return rawget(self, k)
        end
    })
end



function Route:start()
    if self.pathToFile then

    else
        for i, path in ipairs(self.queue) do

        end
    end
end



function Route:stop()
    self.isStopped = true
end



function Route:resume()
    self.isPaused = false
end



function Route:pause()
    self.isPaused = true
end



function Route:reload()
    if self.isStared then self:stop() end
    self:start()
end



return Route