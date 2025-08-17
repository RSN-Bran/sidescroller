function drawColliders()
    if DISPLAY_COLLIDERS then
            local items, len = world:getBodies()
            for i,v in ipairs(items) do
                local bodyData = v:getUserData()
                if bodyData then
                    local shape=bodyData.shape
                    if shape:getType()=="polygon" then
                        local x,y=v:getPosition()
                        --love.graphics.rectangle("line", x, y, bodyData.width, bodyData.height)
                    end
                end
            end
        end
end