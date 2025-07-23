-- require 'global'
-- require 'controls'

function love.load()
    init()
    loadRequirements()
    loadSettings()
    loadAssets()
    gameStart()
    
end 

function love.update(dt)
    if gameState==GAME_STATE_PLAYING then
        world:update(dt)
        player:update(dt)
        map:update(dt)
        updateCamera(dt)
        
    else
        pauseMenu:update(dt)
    end

    executeUpdateCallbacks(dt)
end

function love.draw()

    --Draw everything within the camera (Game)
    cam:attach()   
        map:draw()
        player:draw()
        drawColliders()
        
    cam:detach()

    --Update the game scale for menus
    love.graphics.push()
    love.graphics.scale(settings.scale, settings.scale)

    if gameState==GAME_STATE_DEAD then
        love.graphics.print("You Died. Press 'r' to respawn")
    else
        player.health:draw()
    end
    love.graphics.print("Items Collected: "..#player.itemsCollected, 0, 20)
    if gameState == GAME_STATE_PAUSE then
        pauseMenu:draw()
    end
    love.graphics.pop()
    
    
end

function love.keypressed(key)
    
    if gameState==GAME_STATE_PLAYING then
        if key=="q" then
            gameState = GAME_STATE_PAUSE
        
        elseif key=="space" then
            player:jump()
        end
    elseif gameState==GAME_STATE_PAUSE then
        if key=="q" then
            gameState = GAME_STATE_PLAYING
        elseif key=="up" then
            pauseMenu:moveSelectorUp()
        elseif key=="down" then
            pauseMenu:moveSelectorDown()
        elseif key=="return" then
            local action = pauseMenu.pauseOptions.options[pauseMenu.currentOptionIndex].action
            if not isempty(action) then
                action()
            end
        end
    elseif gameState==GAME_STATE_DEAD then
        if key=="r" then
            player:spawn()
        end
    end
end

function love.gamepadpressed(joystick, button)

end

function love.joystickremoved(joystick)
end

function love.joystickadded(joystick)
end


function init()
    callbacks = {}
    
end

function loadRequirements()
    sti = require "libraries/sti"
    json = require "libraries/json"
    camera = require "libraries/camera"
    anim8 = require "libraries/anim8"

    love.graphics.setDefaultFilter("nearest", "nearest")

    require('/src/class/Player/Player')
    require('/src/class/Player/PlayerHealth')
    require('/src/class/ObjectList')
    require('/src/class/Terrain')
    require('/src/class/Map')
    require('/src/class/Checkpoint')
    require('/src/class/Spike')
    require('/src/class/PauseMenu')
    require('/src/class/Warp')
    require('/src/class/Item')
    require('/src/class/Settings')
    require('/src/class/Door')
    --require('/src/class/Settings')

    require('/src/constants')
    require('/src/collision')
    require('/src/update')
    require('/src/draw')

    --data
    require('/src/data/maps')
    

    require('/global/functions')
end

function loadAssets()
end

function loadSettings()
    cam = camera()
    settings = Settings:new()
    settings:updateScale(1)
    
    
end

function setMap(mapFile)
    
    if not isempty(map) then
        map:destroy()
    end

    map = Map:new(mapFile)
    
    map:load()
    
    return map
end
function gameStart()

    
    
    gameState = GAME_STATE_PLAYING
    gravity = 1000
    world = love.physics.newWorld(0,gravity)
    world:setCallbacks(OnCollisionEnter, OnCollisionExit, presolve, postsolve)
    player = Player:new()
    player:init()
    map = setMap(MAP_TABLE[1])
    player:place()
    
    pauseMenu=PauseMenu:new()
    
end