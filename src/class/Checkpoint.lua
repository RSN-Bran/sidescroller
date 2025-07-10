Checkpoint = {}
Checkpoint.__index = Checkpoint

function Checkpoint:new(v)
    local instance = setmetatable({}, Checkpoint)

    instance.pos = {x=v.x, y=v.y}
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "kinematic")
    instance.shape = love.physics.newCircleShape(5)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    
    instance.isInitial = v.name=="Initial"
    instance.fixture:setUserData({type="Checkpoint", obj=instance})
    instance.fixture:setSensor(true)

    instance.sprite=checkpointSprite

    return instance
end

function Checkpoint:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
end

function Checkpoint:draw()
    love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end


Checkpoints = {}
Checkpoints.__index = Checkpoints
function Checkpoints:new()
    local instance = setmetatable({}, Checkpoints)
    instance.checkpoints = {}
    return instance
end

function Checkpoints:add(v)
    local checkpoint = Checkpoint:new(v)
    table.insert(self.checkpoints, checkpoint)
end

function Checkpoints:update()
    for i,checkpoint in ipairs(self.checkpoints) do
        checkpoint:update()
    end
end

function Checkpoints:draw()
    for i,checkpoint in ipairs(self.checkpoints) do
        checkpoint:draw()
    end
end
