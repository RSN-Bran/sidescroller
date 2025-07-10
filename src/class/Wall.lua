Wall = {}
Wall.__index = Wall

function Wall:new(v)
    
    local instance = setmetatable({}, Wall)

    instance.pos = {x=v.x, y=v.y}
    instance.width, instance.height = v.width, v.height
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "static")
    instance.body:setFixedRotation(true)
    instance.shape = love.physics.newRectangleShape((instance.width/2), (instance.height/2), instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({type=COLLIDER_TYPE_WALL, obj=instance})
    

    return instance
end

function Wall:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
end
function Wall:draw()
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
end


Walls = {}
Walls.__index = Walls
function Walls:new()
    local instance = setmetatable({}, Walls)
    instance.walls = {}
    return instance
end

function Walls:add(v)
    local wall = Wall:new(v)
    table.insert(self.walls, wall)
end

function Walls:update(dt)
    for i,wall in ipairs(self.walls) do
        wall:update(dt)
    end
end

function Walls:draw()
    
    for i,wall in ipairs(self.walls) do
        wall:draw()
    end
end
