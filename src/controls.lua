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

function aPressed()
    if gameState==GAME_STATE_PAUSE then
        local action = pauseMenu.pauseOptions.options[pauseMenu.currentOptionIndex].action
        if not isempty(action) then
            action()
        end
    elseif gameState==GAME_STATE_PLAYING then
        player:jump()
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