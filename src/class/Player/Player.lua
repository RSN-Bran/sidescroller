Player = {}
Player.__index = Player

function Player:new()
    
    local instance = setmetatable({}, Player)

    instance.spawnLocation = {x=0, y=0}

    instance.pos = {x=instance.spawnLocation.x, y=instance.spawnLocation.y}
    instance.velocity = {x=0, y=0}
    instance.spriteSheet = love.graphics.newImage('assets/sprites/guy-sheet.png')

    instance.health=PlayerHealth:new(5)

    instance.invincibilityFrames=0
    instance.invincibilityAnimationToggle=true

    instance.spriteGrid = anim8.newGrid(BASE_TILE_SIZE, BASE_TILE_SIZE, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.idle = anim8.newAnimation( instance.spriteGrid('1-4', 1), 0.2)
    instance.animations.right = anim8.newAnimation( instance.spriteGrid('5-6', 1), 0.2)
    instance.animations.left = anim8.newAnimation( instance.spriteGrid('7-8', 1), 0.2)

    instance.currentAnimation={}
    instance.width, instance.height = BASE_TILE_SIZE,BASE_TILE_SIZE
    instance.shape = love.physics.newRectangleShape(instance.width/2, instance.height/2, instance.width, instance.height)
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "dynamic")
    instance.body:setLinearDamping(.9)
    instance.body:setUserData({shape=instance.shape, width=instance.width, height=instance.height})
    instance.body:setFixedRotation(true)
    
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setUserData({type=COLLIDER_TYPE_PLAYER, obj=instance})

    instance.groundDetectionShape=love.physics.newRectangleShape((instance.width/2)-5, instance.height, instance.width-10, 1)
    instance.groundDetectionFixture=love.physics.newFixture(instance.body, instance.groundDetectionShape)
    instance.groundDetectionFixture:setUserData({type=COLLIDER_TYPE_PLAYER_GROUND_DETECTION, obj=instance})

    instance.itemsCollected={}

    instance.hasJump=true
    instance.isJumping=false
    
    return instance
end

function Player:init()
    --Ensure momentum doesn't carry over
    self.body:setLinearVelocity(0, 0)

    --Initialize the player's health
    self.health:spawn()
end

function Player:place(pos)
    --Set the spawn to the Map's currently enabled checkpoint
    local currentCheckpoint = map.currentCheckpoint
    if isempty(pos) then
        self.body:setPosition(currentCheckpoint.pos.x, currentCheckpoint.pos.y)
    else
        self.body:setPosition(pos.x, pos.y)
    end
    
    self.pos.x, self.pos.y = player.body:getPosition()

    --Update the game state
    gameState = "PLAYING"

end

function Player:spawn()
    self:init()
    self:place()
end

function Player:hurt(damage)
    if self.invincibilityFrames <= 0 then
        self.health:hurt(damage)
        if self.health.currentHealth <= 0 then
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
        self.body:applyLinearImpulse(0, -100, self.pos.x, self.pos.y)
        self.pos.x, self.pos.y = self.body:getPosition()
        self.hasJump=false
        self.isJumping=true
    end
    
end

function Player:warp(x, y)
    self.body:setPosition(x,y)
end

function Player:update(dt)
    if gameState ~= "DEAD" then
        local maxSpeed=200
        self.velocity.x, self.velocity.y = self.body:getLinearVelocity()
        if love.keyboard.isDown("left") then
            self.velocity.x = self.velocity.x-40
            if self.velocity.x < -maxSpeed then
                self.velocity.x=-maxSpeed
            end
            self.currentAnimation=self.animations.left
        elseif love.keyboard.isDown("right") then
            self.velocity.x = self.velocity.x+40
            if self.velocity.x > maxSpeed then
                self.velocity.x=maxSpeed
            end
            self.currentAnimation=self.animations.right
        else
            self.currentAnimation=self.animations.idle
        end

        self.currentAnimation:update(dt)
        self.health:update(dt)

        self.body:setLinearVelocity(self.velocity.x, self.velocity.y)

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

