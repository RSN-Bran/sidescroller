Spike = {}
Spike.__index = Spike

function Spike:new(v)
    
    local instance = setmetatable({}, Spike)

    instance.pos = {x=v.x, y=v.y}
    instance.id=v.id
    instance.damage=1
    instance.width, instance.height = v.width, v.height
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "static")
    instance.body:setFixedRotation(true)
    instance.shape = love.physics.newRectangleShape((instance.width/2), (instance.height/2), instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({type="Spike", obj=instance})
    instance.fixture:setSensor(true)
    instance.isActive=true
    

    return instance
end

function Spike:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
end
function Spike:draw()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
end

function Spike:destroy()
    self.fixture:destroy()
    self.body:destroy()
    
end

function Spike:__tostring()
    return 
        "id:"..self.id.."\n"..
        "pos.x:"..self.pos.x.."\n"..
        "pos.y:"..self.pos.y.."\n"..
        "damage"..self.damage.."\n"..
        "isActive:"..tostring(self.isActive)
end
