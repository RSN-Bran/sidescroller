PlayerHealthItem = {}
PlayerHealthItem.__index = PlayerHealthItem

function PlayerHealthItem:new(i, animation)
    
    local instance = setmetatable({}, PlayerHealthItem)

    instance.spriteSheet = love.graphics.newImage('assets/sprites/healthNode-Sheet.png')

    instance.index=i
    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.full = anim8.newAnimation( instance.spriteGrid(1, 1), 0.2)
    instance.animations.hurt = anim8.newAnimation( instance.spriteGrid('1-9', 1), 0.05, (function() instance.currentAnimation=instance.animations.empty player.health:test() end))
    instance.animations.refill = anim8.newAnimation( instance.spriteGrid('9-1', 1), 0.1)
    instance.animations.empty = anim8.newAnimation( instance.spriteGrid(9, 1), 0.2)

    instance.currentAnimation=animation
    
    return instance
end

function PlayerHealthItem:hurt(damage)
    local i=0
    while i < damage do
        self.animationList[self.currentHealth-i] = self.animations.hurt
        self.currentHealth=self.currentHealth-1
        if self.currentHealth <=0 then
            break
        end
        i=i+1
    end
end

function PlayerHealthItem:changeAnimation(animation)
    self.currentAnimation=animation
end



function PlayerHealthItem:update(dt)
    self.currentAnimation:update(dt)
end


function PlayerHealthItem:draw()
    self.currentAnimation:draw(self.spriteSheet, 16*self.index, 0, nil)
end

function PlayerHealthItem:__tostring()
    return "hi"
end

PlayerHealth = {}
PlayerHealth.__index = PlayerHealth

function PlayerHealth:new(maxHealth, currentHealth)
    
    local instance = setmetatable({}, PlayerHealth)

    instance.maxHealth=maxHealth
    if isempty(currentHealth) then
        instance.currentHealth=maxHealth
    else
        instance.currentHealth=currentHealth
    end

    instance.healthItems = {}

    -- --Animations
    instance.spriteSheet = love.graphics.newImage('assets/sprites/healthNode-Sheet.png')
    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.full = anim8.newAnimation( instance.spriteGrid(1, 1), 0.2)
    instance.animations.hurt = anim8.newAnimation( instance.spriteGrid('1-9', 1), 0.05, (function() self.currentAnimation = instance.animations.empty player.health:set() end))
    instance.animations.refill = anim8.newAnimation( instance.spriteGrid('9-1', 1), 0.1)
    instance.animations.empty = anim8.newAnimation( instance.spriteGrid(9, 1), 0.2)
    
    return instance
end

function PlayerHealth:set()
    local i=1
    self.healthItems = {}
    while i <= self.maxHealth do
        local healthItem = {}
        if i <= self.currentHealth then
            healthItem = PlayerHealthItem:new(i, self.animations.full)
        else
            healthItem = PlayerHealthItem:new(i, self.animations.empty)
        end
        table.insert(self.healthItems, healthItem)
        i = i +1
    end
end

function PlayerHealth:spawn()
    -- self.currentHealth=self.maxHealth
    -- self.animationList={}
    -- for i=1,self.maxHealth,1  do
    --     table.insert(self.animationList, self.animations.full)
    -- end
end

function PlayerHealth:hurt(damage)
    local i=0
    local health =self.currentHealth
    while i < damage do
        self.healthItems[health-i]:changeAnimation(self.animations.hurt)
        self.currentHealth=self.currentHealth-1
        if self.currentHealth <=0 then
            break
        end
        i=i+1
    end
    
    
end



function PlayerHealth:update(dt)
    for i,v in ipairs(self.healthItems)  do
        v:update(dt)
    end
end


function PlayerHealth:draw()
    for i,v in ipairs(self.healthItems)  do
        v:draw()
    end
end

function PlayerHealth:__tostring()
    return "HI"
end