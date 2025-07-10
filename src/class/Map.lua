Map = {}
Map.__index = Map

function Map:new(stiFile)
    local instance = setmetatable({}, Map)
    instance.stiFile = stiFile

    local stiProperties = sti(stiFile)
    instance.name = stiProperties.properties.name
    instance.dimensions = {x=stiProperties.width, y=stiProperties.height}

    return instance
end

function Map:load()
    self.stiProperties = sti(self.stiFile)

    print(self.stiProperties.layers[2].objects[1])
    self.wallLayer = filter(self.stiProperties.layers, "name", "=", "Wall")[1]
    self.tileLayer = filter(self.stiProperties.layers, "name", "=", "Tile Layer 1")[1]
    local spawnObjs = filter(self.stiProperties.layers, "name", "=", "Spawns")[1]
    local spikeObjs = filter(self.stiProperties.layers, "name", "=", "Spikes")[1]

    self.walls = Walls:new()
    for i,v in ipairs(self.wallLayer.objects) do
        self.walls:add(v)
    end

    self.checkpoints = Checkpoints:new()
    for i,v in ipairs(spawnObjs.objects) do
        self.checkpoints:add(v)
    end

    self.spikes = Spikes:new()
    for i,v in ipairs(spikeObjs.objects) do
        self.spikes:add(v)
    end

    self.currentCheckpoint = filter(self.checkpoints.checkpoints, "isInitial", "=", true)[1]
    print(self.currentCheckpoint)
end

function Map:update(dt)
    self.walls:update()
    self.checkpoints:update()
    -- for i,v in ipairs(self.spawners) do
    --     v:update(dt)
    -- end
end
function Map:draw()
    self.walls:draw()
    self.checkpoints:draw()
    self.stiProperties:drawLayer(self.tileLayer)
    self.stiProperties:drawLayer(self.wallLayer)
end
return Map
