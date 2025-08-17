Map = {}
Map.__index = Map

function Map:new(stiFile)
    local instance = setmetatable({}, Map)
    instance.stiFile = stiFile

    local stiProperties = sti(stiFile)
    instance.mapId=stiProperties.properties.mapId
    instance.name = stiProperties.properties.name
    instance.dimensions = {x=stiProperties.width, y=stiProperties.height}
    instance.pixelDimensions = {x=instance.dimensions.x*BASE_TILE_SIZE, y=instance.dimensions.y*BASE_TILE_SIZE}
    return instance
end

function Map:load()
    self.stiProperties = sti(self.stiFile)

    self.tileLayer = filter(self.stiProperties.layers, "name", "=", "Tile Layer 1")[1]

    --TERRAIN
    local terrainObjs = getObjectsFromLayer(self.stiProperties.layers, "Terrain")
    self.terrains=ObjectList:new(OBJECT_TYPE_TERRAIN)
    self.terrains:add(terrainObjs)

    --SPIKES
    local spikeObjs = getObjectsFromLayer(self.stiProperties.layers, "Spikes")
    self.spikes=ObjectList:new(OBJECT_TYPE_SPIKE)
    self.spikes:add(spikeObjs)

    --WARPS
    local warpObjs = getObjectsFromLayer(self.stiProperties.layers, "Warps")
    self.warps=ObjectList:new(OBJECT_TYPE_WARP)
    self.warps:add(warpObjs)

    --DOORS
    local doorObjs = getObjectsFromLayer(self.stiProperties.layers, "Doors")
    self.doors=ObjectList:new(OBJECT_TYPE_DOOR)
    self.doors:add(doorObjs)

    --ITEMS
    local itemObjs = getObjectsFromLayer(self.stiProperties.layers, "Items")
    self.items=ObjectList:new(OBJECT_TYPE_ITEM)
    self.items:add(itemObjs)

    --Checkpoints
    local checkpointObjs = getObjectsFromLayer(self.stiProperties.layers, "Checkpoints")
    self.checkpoints=ObjectList:new(OBJECT_TYPE_CHECKPOINT)
    self.checkpoints:add(checkpointObjs)
end

function Map:update(dt)
    self.terrains:update(dt)
    self.checkpoints:update(dt)
    self.warps:update(dt)
    self.doors:update(dt)
    self.items:update(dt)
end
function Map:draw()
    self.stiProperties:drawLayer(self.tileLayer)
    self.terrains:draw()

    self.checkpoints:draw()
    self.warps:draw()
    self.doors:draw()
    self.items:draw()
    

    
end

function Map:destroy()
    self.terrains:destroy()
    self.spikes:destroy()
    self.warps:destroy()
    self.doors:destroy()
    self.items:destroy()
    self.checkpoints:destroy()
end

return Map
