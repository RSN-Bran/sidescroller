ObjectList = {}
ObjectList.__index = ObjectList

function ObjectList:new(type)
    local instance = setmetatable({}, ObjectList)
    instance.type=type
    instance.objects={}
    return instance
end

function ObjectList:add(objects)
    local object = {}
    for i,object in ipairs(objects) do
        if self.type==OBJECT_TYPE_ITEM then
            object = Item:new(object)
        elseif self.type==OBJECT_TYPE_WARP then
            object = Warp:new(object)
        elseif self.type==OBJECT_TYPE_DOOR then
            object = Door:new(object)
        elseif self.type==OBJECT_TYPE_TERRAIN then
            object = Terrain:new(object)
        elseif self.type==OBJECT_TYPE_SPIKE then
            object = Spike:new(object)
        elseif self.type==OBJECT_TYPE_CHECKPOINT then
            object = Checkpoint:new(object)
        elseif self.type==OBJECT_TYPE_CREDIT then
            object = Credit:new(object, i)
        end
        table.insert(self.objects, object)  
    end
end

function ObjectList:update(dt)
    for i,object in ipairs(self.objects) do
        object:update(dt)
    end
end

function ObjectList:draw()
    for i,object in ipairs(self.objects) do
        object:draw()
    end
end

function ObjectList:destroy()
    for i,object in ipairs(self.objects) do
        object:destroy()
    end
end

function ObjectList:__tostring()
    retStr=""
    for i,v in ipairs(self.objects) do
        retStr=retStr..tostring(v).."\n".."----".."\n"
    end
    return retStr
end