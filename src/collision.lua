function OnCollisionEnter(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    if o1 and o2 then
        if o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_CHECKPOINT then
            map.currentCheckpoint=o2.obj
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_CHECKPOINT then
            map.currentCheckpoint=o1.obj

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
        end
    end

end

function OnCollisionExit(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    

end

function presolve(a,b,contact)
    

end

function postsolve(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    

end