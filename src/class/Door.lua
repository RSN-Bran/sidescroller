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
    instance.id=v.id
    instance.doorId=v.properties.doorId
    instance.toDoorId=v.properties.toDoorId
    instance.toMapId=v.properties.toMapId

    instance.fixture:setUserData({type=COLLIDER_TYPE_DOOR, obj=instance})
    instance.fixture:setSensor(true)
    instance.isActive=true

    
    if instance.width > instance.height then
        instance.isHorizontal=true
    else
        instance.isHorizontal=false
    end


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

function Door:__tostring()
    return 
        "id:"..self.id.."\n"..
        "doorId:"..self.doorId.."\n"..
        "toDoorId:"..self.toDoorId.."\n"..
        "toMapId:"..self.toMapId.."\n"..
        "pos.x:"..self.pos.x.."\n"..
        "pos.y:"..self.pos.y.."\n"..
        "height:"..self.height.."\n"..
        "width:"..self.width.."\n"..
        "isActive:"..tostring(self.isActive)
end