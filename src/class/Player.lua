Player = {}
Player.__index = Player

function Player:new()
    
    local instance = setmetatable({}, Player)

    instance.spawnLocation = {x=0, y=0}

    instance.pos = {x=instance.spawnLocation.x, y=instance.spawnLocation.y}
    instance.spriteSheet = love.graphics.newImage('assets/sprites/guy-sheet.png')

    instance.currentHealth=5
    instance.maxHealth=instance.currentHealth

    instance.invincibilityFrames=0
    instance.invincibilityAnimationToggle=true

    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.idle = anim8.newAnimation( instance.spriteGrid('1-4', 1), 0.2)
    instance.animations.right = anim8.newAnimation( instance.spriteGrid('5-6', 1), 0.2)
    instance.animations.left = anim8.newAnimation( instance.spriteGrid('7-8', 1), 0.2)

    instance.currentAnimation={}
    instance.width, instance.height = 16,16
    instance.shape = love.physics.newRectangleShape(instance.width/2, instance.height/2, instance.width, instance.height)
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "dynamic")
    instance.body:setUserData({shape=instance.shape, width=instance.width, height=instance.height})
    instance.body:setFixedRotation(true)
    
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({type=COLLIDER_TYPE_PLAYER, obj=instance})

    instance.groundDetectionShape=love.physics.newRectangleShape((instance.width/2)-5, instance.height, instance.width-10, 1)
    instance.groundDetectionFixture=love.physics.newFixture(instance.body, instance.groundDetectionShape)
    instance.groundDetectionFixture:setUserData({type=COLLIDER_TYPE_PLAYER_GROUND_DETECTION, obj=instance})
    
    instance.hasJump=true
    
    return instance
end

function Player:spawn()
    self.currentHealth=self.maxHealth
    local currentCheckpoint = map.currentCheckpoint

    
    self.body:setPosition(currentCheckpoint.pos.x, currentCheckpoint.pos.y)
    self.pos.x, self.pos.y = player.body:getPosition()

    gameState = "PLAYING"

end

function Player:hurt(damage)
    if self.invincibilityFrames <= 0 then
        self.currentHealth=self.currentHealth-damage
        if self.currentHealth <= 0 then
            self:kill()
        else
            self.invincibilityFrames=INVINCIBILITY_FRAMES
        end
    end
end

function Player:kill()
    gameState = "DEAD"
end

function Player:jump()
    if self.hasJump then
        gravity = 10
        self.body:setLinearVelocity(0, -4000)
        self.pos.x, self.pos.y = self.body:getPosition()
        self.hasJump=false
    end
    
end

function Player:update(dt)
    if gameState ~= "DEAD" then
        local speed=150
        local dx,dy=0,0
        if love.keyboard.isDown("left") then
            dx=-speed
            self.currentAnimation=self.animations.left
        elseif love.keyboard.isDown("right") then
            dx=speed
            self.currentAnimation=self.animations.right
        else
            self.currentAnimation=self.animations.idle
        end

        self.currentAnimation:update(dt)

        self.body:setLinearVelocity(dx, dy)

        self.pos.x, self.pos.y = self.body:getPosition()
        if self.invincibilityFrames > 0 then
            self.invincibilityFrames=self.invincibilityFrames-1
            self.invincibilityAnimationToggle = not self.invincibilityAnimationToggle
        end
        
    end

    
end

function Player:draw()
    if gameState~="DEAD" then
        if self.invincibilityAnimationToggle then
            self.currentAnimation:draw(self.spriteSheet, self.pos.x, self.pos.y, nil)
        end
    end
end

