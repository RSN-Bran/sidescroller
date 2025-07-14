function update()
end

function updateCamera(dt)

    --Aim the camera at the player
    cam:lookAt(player.pos.x, player.pos.y)

    --Calculate height and width of the gameplay area
    local w=love.graphics.getWidth()
    local h=love.graphics.getHeight()-(HUD_HEIGHT*2)

    --Lock horizontal scrolling if edge of screen is reached
    if cam.x < w/2 then
        cam.x=w/2
    elseif cam.x > (map.pixelDimensions.x-w/2) then
        cam.x=(map.pixelDimensions.x-w/2)
    end

    --Lock vertical scrolling if edge of screen is reached
    if cam.y < h/2 then
        cam.y=h/2
    elseif cam.y > (map.pixelDimensions.y-h/2)-HUD_HEIGHT then
        cam.y=(map.pixelDimensions.y-h/2)-HUD_HEIGHT
    end
end

function executeUpdateCallbacks(dt)
    --Execute stored callbacks
    for i,v in ipairs(callbacks) do
        v()
    end
    callbacks = {}
end