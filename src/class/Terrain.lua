Terrain = {}
Terrain.__index = Terrain

function Terrain:new(v)
    
    local instance = setmetatable({}, Terrain)

    instance.pos = {x=v.x, y=v.y}
    instance.width, instance.height = v.width, v.height
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "static")
    instance.body:setFixedRotation(true)
    instance.shape = love.physics.newRectangleShape((instance.width/2), (instance.height/2), instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({type=COLLIDER_TYPE_WALL, obj=instance})
    

    return instance
end

function Terrain:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
end
function Terrain:draw()
    --love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
end

function Terrain:destroy()
    self.fixture:destroy()
    self.body:destroy()
end