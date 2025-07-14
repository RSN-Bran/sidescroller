Checkpoint = {}
Checkpoint.__index = Checkpoint

function Checkpoint:new(v)
    local instance = setmetatable({}, Checkpoint)

    instance.pos = {x=v.x, y=v.y}
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "kinematic")
    instance.shape = love.physics.newCircleShape(5)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)

    instance.isCollected=false

    instance.spriteSheet = love.graphics.newImage('assets/sprites/flag-sheet.png')
    
    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    
    instance.animations.idleInactive = anim8.newAnimation( instance.spriteGrid('1-2', 1), 0.5)
    instance.animations.idleActive = anim8.newAnimation( instance.spriteGrid('3-4', 1), 0.5)
    instance.currentAnimation=instance.animations.idleInactive

    instance.isInitial = v.name=="Initial"
    instance.fixture:setUserData({type="Checkpoint", obj=instance})
    instance.fixture:setSensor(true)

    return instance
end

function Checkpoint:activate()
    self.isCollected=true
    self.currentAnimation=self.animations.idleActive
end

function Checkpoint:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
    self.currentAnimation:update(dt)
end

function Checkpoint:draw()
    self.currentAnimation:draw(self.spriteSheet, self.pos.x, self.pos.y, nil)
    self.currentAnimation:draw(self.spriteSheet, self.pos.x-TILE_SIZE, self.pos.y-TILE_SIZE, nil)
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

function Checkpoints:update(dt)
    for i,checkpoint in ipairs(self.checkpoints) do
        checkpoint:update(dt)
    end
end

function Checkpoints:draw()
    for i,checkpoint in ipairs(self.checkpoints) do
        checkpoint:draw()
    end
end
