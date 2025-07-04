Wall = {}
Wall.__index = Wall

function Wall:new()
    
    local instance = setmetatable({}, Wall)

    instance.pos = {x=100, y=10}
    instance.width, instance.height = 10, 10
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "static")
    instance.body:setFixedRotation(true)
    instance.shape = love.physics.newRectangleShape(10/2, 10/2, instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    
    return instance
end

function Wall:update(dt)

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

function Walls:draw()
    for i,wall in ipairs(self.walls) do
        wall:draw()
    end
end
