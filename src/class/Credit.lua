Credit = {}
Credit.__index = Credit

function Credit:new(text, index)
    print(text)
    local instance = setmetatable({}, Credit)

    instance.pos = {x=GAME_WIDTH/3, y=(GAME_HEIGHT)+index*20}
    instance.text=text
    instance.isLast = index==#CREDITS_TABLE

    return instance
end


function Credit:update(dt)
    self.pos.y= self.pos.y-1
    if self.isLast and self.pos.y < -10 then
        gameState=GAME_STATE_PAUSE
    end
end

function Credit:draw()
    love.graphics.print(self.text, self.pos.x, self.pos.y)
end

function Credit:destroy()

end


