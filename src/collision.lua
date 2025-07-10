function OnCollisionEnter(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    if o1 and o2 then
        if o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_CHECKPOINT then
            map.currentCheckpoint=o2.obj
            o2.obj:activate()
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_CHECKPOINT then
            map.currentCheckpoint=o1.obj
            o1.obj:activate()

        elseif o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_SPIKE then
            local callback = function() player:hurt(1) end
            table.insert(callbacks, callback)
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_SPIKE then
            local callback = function() player:hurt(1) end
            table.insert(callbacks, callback)
        elseif o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_WALL then
            --player.hasJump=true
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_WALL then
            --player.hasJump=true
        elseif o1.type==COLLIDER_TYPE_PLAYER_GROUND_DETECTION and o2.type==COLLIDER_TYPE_WALL then
            player.hasJump=true
        elseif o2.type==COLLIDER_TYPE_PLAYER_GROUND_DETECTION and o1.type==COLLIDER_TYPE_WALL then
            player.hasJump=true
        elseif o1.type==COLLIDER_TYPE_WARP and o2.type==COLLIDER_TYPE_PLAYER then
            if o1.obj.isActive then
                local nextWarp = filter(map.warps.warps, "warpToId", "=", o1.obj.id)[1]
                nextWarp.isActive=false
                local callback = function() player:warp(nextWarp.pos.x, nextWarp.pos.y) end
                table.insert(callbacks, callback)
                
            end
        elseif o2.type==COLLIDER_TYPE_WARP and o1.type==COLLIDER_TYPE_PLAYER then
            if o2.obj.isActive then
                local nextWarp = filter(map.warps.warps, "warpToId", "=", o2.obj.id)[1]
                nextWarp.isActive=false
                local callback = function() player:warp(nextWarp.pos.x, nextWarp.pos.y) end
                table.insert(callbacks, callback)
                
            end
        end
    end

end

function OnCollisionExit(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()
    if o1 and o2 then
        if o1.type==COLLIDER_TYPE_WARP and o2.type==COLLIDER_TYPE_PLAYER then
            o1.obj.isActive=true
        elseif o2.type==COLLIDER_TYPE_WARP and o1.type==COLLIDER_TYPE_PLAYER then
            o2.obj.isActive=true
        end
    end
    

end

function presolve(a,b,contact)
    

end

function postsolve(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    

end