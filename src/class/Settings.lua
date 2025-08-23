Settings = {}
Settings.__index = Settings

function Settings:new(v)
    local instance = setmetatable({}, Settings)


    instance.scale=2

    

    return instance
end

function Settings:updateScale(scale)
    self.scale=scale
    love.window.setMode(640*self.scale, 360*self.scale)
    cam.scale=self.scale
end