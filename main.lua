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
        cam:lookAt(player.pos.x, player.pos.y)
    else
        pauseMenu:update(dt)
    end

    --Execute stored callbacks
    for i,v in ipairs(callbacks) do
        v()
    end
    callbacks = {}
end

function love.draw()
  
    
    if gameState==GAME_STATE_DEAD then
        love.graphics.print("You Died. Press 'r' to respawn")
    else
        love.graphics.print("Health: "..player.currentHealth)
    end
    if gameState == GAME_STATE_PAUSE then
        pauseMenu:draw()
    end
    cam:attach()
        
        map:draw()
        player:draw()

        if DISPLAY_COLLIDERS then
            local items, len = world:getBodies()
            for i,v in ipairs(items) do
                local bodyData = v:getUserData()
                if bodyData then
                    local shape=bodyData.shape
                    if shape:getType()=="polygon" then
                        local x,y=v:getPosition()
                        love.graphics.rectangle("line", x, y, bodyData.width, bodyData.height)
                    end
                end
            end
        end
        
        -- for i = 1, len do
        --     local x, y, w, h = world:getRect(items[i])
        --     love.graphics.rectangle("line", x, y, w, h)
        -- end
    cam:detach()
    
    
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

    require('/src/class/Player')
    require('/src/class/Wall')
    require('/src/class/Map')
    require('/src/class/Checkpoint')
    require('/src/class/Spike')
    require('/src/class/PauseMenu')
    require('/src/class/Warp')
    --require('/src/class/Settings')

    require('/src/constants')
    require('/src/collision')

    require('/global/functions')
end

function loadAssets()
    checkpointSprite = love.graphics.newImage('assets/sprites/flag.png')
end

function loadSettings()
    love.window.setMode(640, 360)
    
end
function gameStart()

    
    cam = camera()
    gameState = GAME_STATE_PLAYING
    gravity = 1000
    world = love.physics.newWorld(0,gravity)
    world:setCallbacks(OnCollisionEnter, OnCollisionExit, presolve, postsolve)
    map = Map:new('maps/test2.lua')
    pauseMenu=PauseMenu:new()
    map:load()
    player = Player:new()
    player:spawn()
end