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
        local contacts= world:getContacts()
        for i,v in ipairs(contacts) do
            a,b=v:getFixtures()
            persistentContact(a,b)
        end
        player:update(dt)
        map:update(dt)
        updateCamera(dt)
    elseif gameState==GAME_STATE_CREDITS then
        credits:update(dt)
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
    love.graphics.print("Items Collected: "..player.itemCount, 0, 20)
    if gameState == GAME_STATE_PAUSE then
        pauseMenu:draw()
    end
    love.graphics.pop()

    if gameState==GAME_STATE_CREDITS then
        credits:draw()
    end
    
    
end

function love.keypressed(key)
    if key=="lshift" then
        startPressed()
    elseif key=="z" then
        aPressed()
    elseif key=="x" then
        bPressed()
    elseif key=="up" then
        upPressed()
    elseif key=="down" then
        downPressed()
    end
end

function love.gamepadpressed(joystick, button)
    if isempty(controller) then
        controller=joystick
    end
    if button=="start" then
        startPressed()
    elseif button=="a" then
        aPressed()
    elseif button=="b" then
        bPressed()
    elseif button=="dpup" then
        upPressed()
    elseif button=="dpdown" then
        downPressed()
    end
end

function love.joystickremoved(joystick)
end

function love.joystickadded(joystick)
    if isempty(controller) then
        controller=joystick
    end
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
    require('/src/class/Credit')
    --require('/src/class/Settings')

    require('/src/constants')
    require('/src/collision')
    require('/src/update')
    require('/src/draw')
    require('/src/controls')

    --data
    require('/src/data/maps')
    require('/src/data/items')
    require('/src/data/credits')
    

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

    
    controller = nil
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