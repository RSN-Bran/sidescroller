--Pressed Functions
function startPressed()
    if gameState==GAME_STATE_PLAYING then
        gameState = GAME_STATE_PAUSE
    elseif gameState==GAME_STATE_PAUSE then
        pauseMenu:loadMenu(PAUSE_OPTIONS)
        gameState = GAME_STATE_PLAYING
    end
end

function upPressed()
    if gameState==GAME_STATE_PAUSE then
        pauseMenu:moveSelectorUp()
    end
end

function downPressed()
    if gameState==GAME_STATE_PAUSE then
        pauseMenu:moveSelectorDown()
    end
end

function rightPressed()
    if gameState==GAME_STATE_PLAYING then
        player:prepDash("RIGHT")
    end
end

function leftPressed()
    if gameState==GAME_STATE_PLAYING then
        player:prepDash("LEFT")
    end
end


function aPressed()
    if gameState==GAME_STATE_PAUSE then
        local action = pauseMenu.pauseOptions.options[pauseMenu.currentOptionIndex].action
        if not isempty(action) then
            action()
        end
    elseif gameState==GAME_STATE_PLAYING then
        player:initiateJump()
    elseif gameState==GAME_STATE_DEAD then
        player:spawn()
    end
end

function bPressed()
    if gameState==GAME_STATE_PAUSE then
        local action = pauseMenu.pauseOptions.bAction
        if not isempty(action) then
            action()
        end
    end
end

--Released Functions
function startReleased()
end

function upReleased()
end

function downReleased()

end

function aReleased()
    if gameState==GAME_STATE_PLAYING then
        player:endJump()
    end
end

function bReleased()
end

--Is Down Functions
function startIsDown()
end

function upIsDown()
end

function downIsDown()

end

function aIsDown()
    if gameState==GAME_STATE_PLAYING then
        player:endJump()
    end
end

function bIsDown()
end