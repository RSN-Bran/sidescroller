Player = {}
Player.__index = Player

function Player:new()
    
    local instance = setmetatable({}, Player)

    instance.pos = {x=10, y=10}
    instance.sprite=playerSprite
    instance.width, instance.height = instance.sprite:getDimensions()
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "dynamic")
    instance.body:setFixedRotation(true)
    instance.shape = love.physics.newRectangleShape(instance.width/2, instance.height/2, instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    
    return instance
end

function Player:update(dt)
    local speed=100
    local dx,dy=0,0
    if love.keyboard.isDown("left") then
        dx=-speed
    end
    if love.keyboard.isDown("right") then
        dx=speed
    end

    self.body:setLinearVelocity(dx, dy)
    self.pos.x, self.pos.y = player.body:getPosition()
end

function Player:draw()
    love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end

