PauseMenu = {}
PauseMenu.__index = PauseMenu

PAUSE_OPTIONS={
    menuName="Pause",
    bAction=function() end,
    options={
        {
            name="Resume",
            action=function() gameState = GAME_STATE_PLAYING end
        },
        {
            name="Reset",
            action=function() love.load() end
        },
        {
            name="Settings",
            action=function() pauseMenu:loadMenu(SETTINGS_OPTIONS) end
        },
        {
            name="Quit",
            action=function() love.event.quit() end
        }
    }
}

SETTINGS_OPTIONS={
    menuName="Settings",
    bAction=function() pauseMenu:loadMenu(PAUSE_OPTIONS) end,
    options={
        {
            name="Test",
            action=function() gameState = GAME_STATE_PLAYING end
        },
    }
}

function PauseMenu:new()
    local instance = setmetatable({}, PauseMenu)

    instance.spriteSheet = love.graphics.newImage('assets/sprites/menu-arrow-sheet.png')
    instance.spriteGrid = anim8.newGrid(16, 16, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())

    
    instance.animations = {}
    instance.animations.arrow = anim8.newAnimation( instance.spriteGrid('1-4', 1), 0.2)
    instance.currentAnimation=instance.animations.arrow

    instance.currentOptionIndex=1

    instance.pauseOptions=PAUSE_OPTIONS
    return instance
end

function PauseMenu:loadMenu(menu)
    self.currentOptionIndex=1
    self.pauseOptions=menu
end

function PauseMenu:moveSelectorUp()
    if self.currentOptionIndex==1 then
        self.currentOptionIndex=#self.pauseOptions.options
    else
        self.currentOptionIndex=self.currentOptionIndex-1
    end
end

function PauseMenu:moveSelectorDown()
    if self.currentOptionIndex==#self.pauseOptions.options then
        self.currentOptionIndex=1
    else
        self.currentOptionIndex=self.currentOptionIndex+1
    end
end

function PauseMenu:load()
end

function PauseMenu:update(dt)
    self.currentAnimation:update(dt)
end

function PauseMenu:draw()
    --love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", love.graphics.getWidth()/4, love.graphics.getHeight()/4, love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    
    for i,v in ipairs(self.pauseOptions.options) do
        local x, y = love.graphics.getWidth()/2, (love.graphics.getHeight()/4)+i*20
        if i==self.currentOptionIndex then
            self.currentAnimation:draw(self.spriteSheet, x-20, y, nil)
        end
        love.graphics.setColor(1,1,1)
        love.graphics.print(v.name, x,y)
    end
end

return PauseMenu
