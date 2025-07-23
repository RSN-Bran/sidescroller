Door = {}
Door.__index = Door

function Door:new(v)
    local instance = setmetatable({}, Door)

    instance.pos = {x=v.x, y=v.y}
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "static")
    --instance.body:setFixedRotation(true)
    instance.width=v.width
    instance.height=v.height
    instance.shape = love.physics.newRectangleShape((instance.width/2), (instance.height/2), instance.width, instance.height)
    instance.fixture=love.physics.newFixture(instance.body, instance.shape)
    instance.id=v.properties.doorId
    instance.toDoorId=v.properties.toDoorId
    instance.toMapId=v.properties.toMapId

    instance.fixture:setUserData({type=COLLIDER_TYPE_DOOR, obj=instance})
    instance.fixture:setSensor(true)
    instance.isActive=true


    return instance
end


function Door:update(dt)
end

function Door:draw()
end

function Door:destroy()
    self.fixture:destroy()
    self.body:destroy()
end
