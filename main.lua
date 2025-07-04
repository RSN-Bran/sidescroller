-- require 'global'
-- require 'controls'

function love.load()
    loadRequirements()
    loadAssets()
    gameStart()
    
end 

function love.update(dt)
    world:update(dt)
    player:update(dt)
end

function love.draw()
  
    player:draw()
    wall:draw()
    
    
end

function love.keypressed(key)
end

function love.gamepadpressed(joystick, button)

end

function love.joystickremoved(joystick)
end

function love.joystickadded(joystick)
end

function loadRequirements()
    require('/src/class/Player')
    require('/src/class/Wall')
end

function loadAssets()
    playerSprite = love.graphics.newImage('assets/sprites/guy.png')
end

function gameStart()
    world = love.physics.newWorld(0,5000)
    player = Player:new()
    wall=Wall:new()
end