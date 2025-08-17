Warp = {}
Warp.__index = Warp

function Warp:new(v)
    local instance = setmetatable({}, Warp)

    instance.pos = {x=v.x, y=v.y}

    instance.id=v.id

    instance.warpId=v.properties.warpId
    instance.toWarpId=v.properties.toWarpId
    instance.toMapId=v.properties.toMapId
    if isempty(v.properties.usable) then
        instance.usable=true
    else
        instance.usable=v.properties.usable
    end

    instance.spriteSheet = love.graphics.newImage('assets/sprites/warp-sheet.png')

    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.idle = anim8.newAnimation( instance.spriteGrid('1-4', 1), 0.2)

    instance.currentAnimation=instance.animations.idle

    if instance.usable then
        instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "kinematic")
        instance.shape = love.physics.newCircleShape(5)
        instance.fixture=love.physics.newFixture(instance.body, instance.shape)
        instance.fixture:setUserData({type="Warp", obj=instance})
        instance.fixture:setSensor(true)
    end
    instance.isActive=true

    return instance
end


function Warp:update(dt)
    if self.usable then
        self.currentAnimation:update(dt)
    end
end

function Warp:draw()
    if self.usable then
        self.currentAnimation:draw(self.spriteSheet, self.pos.x, self.pos.y, nil)
    end
    
end

function Warp:destroy()
    if not isempty(self.fixture) then
        self.fixture:destroy()
        self.body:destroy()
    end
end

function Warp:__tostring()
    return 
        "id:"..self.id.."\n"..
        "pos.x:"..self.pos.x.."\n"..
        "pos.y:"..self.pos.y.."\n"..
        "warpId:"..self.warpId.."\n"..
        "toWarpId:"..self.toWarpId.."\n"..
        "toMapId:"..self.toMapId.."\n"..
        "isActive:"..tostring(self.isActive)
end