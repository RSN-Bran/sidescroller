Map = {}
Map.__index = Map

function Map:new(stiFile)
    local instance = setmetatable({}, Map)
    instance.stiFile = stiFile

    local stiProperties = sti(stiFile)
    instance.name = stiProperties.properties.name
    instance.dimensions = {x=stiProperties.width, y=stiProperties.height}
    instance.pixelDimensions = {x=instance.dimensions.x*16, y=instance.dimensions.y*16}
    return instance
end

function Map:load()
    self.stiProperties = sti(self.stiFile)

    self.wallLayer = filter(self.stiProperties.layers, "name", "=", "Wall")[1]
    self.tileLayer = filter(self.stiProperties.layers, "name", "=", "Tile Layer 1")[1]
    local spawnObjs = filter(self.stiProperties.layers, "name", "=", "Spawns")[1]
    local warpObjs = filter(self.stiProperties.layers, "name", "=", "Warps")[1]
    local spikeObjs = filter(self.stiProperties.layers, "name", "=", "Spikes")[1]

    self.walls = Walls:new()
    for i,v in ipairs(self.wallLayer.objects) do
        self.walls:add(v)
    end

    self.checkpoints = Checkpoints:new()
    for i,v in ipairs(spawnObjs.objects) do
        self.checkpoints:add(v)
    end

    self.warps = Warps:new()
    for i,v in ipairs(warpObjs.objects) do
        self.warps:add(v)
    end

    self.spikes = Spikes:new()
    for i,v in ipairs(spikeObjs.objects) do
        self.spikes:add(v)
    end

    self.currentCheckpoint = filter(self.checkpoints.checkpoints, "isInitial", "=", true)[1]
end

function Map:update(dt)
    self.walls:update(dt)
    self.checkpoints:update(dt)
    self.warps:update(dt)
    -- for i,v in ipairs(self.spawners) do
    --     v:update(dt)
    -- end
end
function Map:draw()
    self.walls:draw()
    self.checkpoints:draw()
    self.warps:draw()
    self.stiProperties:drawLayer(self.tileLayer)
    self.stiProperties:drawLayer(self.wallLayer)
end
return Map
