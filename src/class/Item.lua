Item = {}
Item.__index = Item

function Item:new(v)
    local instance = setmetatable({}, Item)

    instance.pos = {x=v.x, y=v.y}
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "kinematic")

    instance.itemId=v.properties.itemId
    if player.itemsCollected[instance.itemId] == true then
        instance.shape=nil
        instance.fixture=nil
        instance.isActive=false
    else
        instance.shape = love.physics.newCircleShape(5)
        instance.fixture=love.physics.newFixture(instance.body, instance.shape)
        instance.fixture:setUserData({type=OBJECT_TYPE_ITEM, obj=instance})
        instance.fixture:setSensor(true)
        instance.isActive=true
    end

    instance.sounds={}
    instance.sounds.collect=love.audio.newSource('assets/sounds/item_sound.wav', "static")

    instance.spriteSheet = love.graphics.newImage('assets/sprites/coin-sheet.png')
    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.idle = anim8.newAnimation( instance.spriteGrid('1-8', 1), 0.2)
    instance.currentAnimation=instance.animations.idle

    return instance
end


function Item:update(dt)
    self.currentAnimation:update(dt)
end

function Item:draw()
    if self.isActive then
        self.currentAnimation:draw(self.spriteSheet, self.pos.x, self.pos.y, nil)
    end
end

function Item:destroy()
    if not isempty(self.body) then
        self.body:destroy()
        self.body=nil
    end
end

function Item:collect()
    self.isActive=false
    self.sounds.collect:play()
    self:destroy()
end

function Item:__tostring()
    return 
        "itemId:"..self.itemId.."\n"..
        "pos.x:"..self.pos.x.."\n"..
        "pos.y:"..self.pos.y.."\n"..
        "isActive:"..tostring(self.isActive)
end