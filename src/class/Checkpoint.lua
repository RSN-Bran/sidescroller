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

    instance.checkpointId=v.properties.checkpointId
    instance.mapId=map.mapId

    return instance
end

function Checkpoint:destroy()
    self.fixture:destroy()
    self.body:destroy()
end

function Checkpoint:activate()
    self.isCollected=true
    player.checkpoint.mapId=self.mapId
    player.checkpoint.checkpointId=self.checkpointId

    end

function Checkpoint:update(dt)
    self.body:setLinearVelocity(0, 0)
    self.pos.x, self.pos.y = self.body:getPosition()
    if player.checkpoint.mapId==self.mapId and player.checkpoint.checkpointId==self.checkpointId then
        
        self.currentAnimation=self.animations.idleActive
    else
        self.currentAnimation=self.animations.idleInactive
    end
    self.currentAnimation:update(dt)
end

function Checkpoint:draw()
    
    self.currentAnimation:draw(self.spriteSheet, self.pos.x-BASE_TILE_SIZE, self.pos.y-BASE_TILE_SIZE, nil)
end

function Checkpoint:__tostring()
    return 
        "checkpointId:"..self.checkpointId.."\n"..
        "mapId:"..self.mapId.."\n"..
        "pos.x:"..self.pos.x.."\n"..
        "pos.y:"..self.pos.y
end


Checkpoints = {}
Checkpoints.__index = Checkpoints
function Checkpoints:new()
    local instance = setmetatable({}, Checkpoints)
    instance.checkpoints = {}
    return instance
end

function Checkpoints:destroy()
    for i,checkpoint in ipairs(self.checkpoints) do
        checkpoint:destroy(dt)
    end
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
