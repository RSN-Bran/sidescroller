Warp = {}
Warp.__index = Warp

function Warp:new(v)
    local instance = setmetatable({}, Warp)

    instance.pos = {x=v.x, y=v.y}
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "kinematic")
    instance.shape = love.physics.newCircleShape(5)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.id=v.id
    instance.warpToId=v.properties.warpId

    instance.spriteSheet = love.graphics.newImage('assets/sprites/warp-sheet.png')

    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animations = {}
    instance.animations.idle = anim8.newAnimation( instance.spriteGrid('1-4', 1), 0.2)

    instance.currentAnimation=instance.animations.idle

    instance.fixture:setUserData({type="Warp", obj=instance})
    instance.fixture:setSensor(true)
    instance.isActive=true


    return instance
end


function Warp:update(dt)
    self.currentAnimation:update(dt)
end

function Warp:draw()
    self.currentAnimation:draw(self.spriteSheet, self.pos.x, self.pos.y, nil)
end


Warps = {}
Warps.__index = Warps
function Warps:new()
    local instance = setmetatable({}, Warps)
    instance.warps = {}
    return instance
end

function Warps:add(v)
    local warp = Warp:new(v)
    table.insert(self.warps, warp)
end

function Warps:update(dt)
    for i,warp in ipairs(self.warps) do
        warp:update(dt)
    end
end

function Warps:draw()
    for i,warp in ipairs(self.warps) do
        warp:draw()
    end
end
