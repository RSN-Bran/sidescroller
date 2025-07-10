PauseMenu = {}
PauseMenu.__index = PauseMenu

function PauseMenu:new()
    local instance = setmetatable({}, PauseMenu)

    return instance
end

function PauseMenu:load()
end

function PauseMenu:update(dt)

end
function PauseMenu:draw()
    love.graphics.rectangle("line", love.graphics.getWidth()/4, love.graphics.getHeight()/4, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
end
return PauseMenu
