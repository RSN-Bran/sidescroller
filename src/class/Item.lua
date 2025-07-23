Item = {}
Item.__index = Item

function Item:new(v)
    local instance = setmetatable({}, Item)

    instance.pos = {x=v.x, y=v.y}
    instance.body=love.physics.newBody(world, instance.pos.x, instance.pos.y, "kinematic")

    instance.itemId=v.properties.itemId
    if contains(player.itemsCollected, instance.itemId) then
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

    return instance
end


function Item:update(dt)
end

function Item:draw()
    if self.isActive then
        love.graphics.rectangle("line", self.pos.x, self.pos.y, 5,5)
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
    self:destroy()
end