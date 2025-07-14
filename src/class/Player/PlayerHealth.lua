PlayerHealth = {}
PlayerHealth.__index = PlayerHealth

function PlayerHealth:new(maxHealth)
    
    local instance = setmetatable({}, PlayerHealth)

    instance.maxHealth=maxHealth

    instance.spriteSheet = love.graphics.newImage('assets/sprites/healthNode-Sheet.png')

    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.full = anim8.newAnimation( instance.spriteGrid(1, 1), 0.2)
    instance.animations.hurt = anim8.newAnimation( instance.spriteGrid('1-9', 1), 0.05, (function() instance.animationList[instance.currentHealth+1] = instance.animations.empty end))
    instance.animations.refill = anim8.newAnimation( instance.spriteGrid('9-1', 1), 0.1)
    instance.animations.empty = anim8.newAnimation( instance.spriteGrid(9, 1), 0.2)
    
    return instance
end

function PlayerHealth:spawn()
    self.currentHealth=self.maxHealth
    self.animationList={}
    for i=1,self.maxHealth,1  do
        table.insert(self.animationList, self.animations.full)
    end
end

function PlayerHealth:hurt(damage)
    self.animationList[self.currentHealth] = self.animations.hurt
    self.currentHealth=self.currentHealth-damage
    
end



function PlayerHealth:update(dt)
    for i=1,self.maxHealth,1  do
        self.animationList[i]:update(dt)
    end
end


function PlayerHealth:draw()
    for i=1,self.maxHealth,1  do
        self.animationList[i]:draw(self.spriteSheet, 16*i, 0, nil)
    end
end