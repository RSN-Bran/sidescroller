Spike = {}
Spike.__index = Spike

function Spike:new(v)
    
    local instance = setmetatable({}, Spike)

    instance.pos = {x=v.x, y=v.y}
    instance.width, instance.height = v.width, v.height
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "static")
    instance.body:setFixedRotation(true)
    instance.shape = love.physics.newRectangleShape((instance.width/2), (instance.height/2), instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({type="Spike", obj=instance})
    instance.fixture:setSensor(true)
    

    return instance
end

function Spike:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
end
function Spike:draw()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
end


Spikes = {}
Spikes.__index = Spikes
function Spikes:new()
    local instance = setmetatable({}, Spikes)
    instance.spikes = {}
    return instance
end

function Spikes:add(v)
    local wall = Spike:new(v)
    table.insert(self.spikes, wall)
end

function Spikes:update()
    for i,wall in ipairs(self.spikes) do
        wall:update()
    end
end

function Spikes:draw()
    
    for i,wall in ipairs(self.spikes) do
        wall:draw()
    end
end
