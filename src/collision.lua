function OnCollisionEnter(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    if o1 and o2 then
        --Activate Checkpoint
        if o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_CHECKPOINT then
            activateCheckpoint(o2.obj)  
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_CHECKPOINT then
            activateCheckpoint(o1.obj)

        --test
        elseif o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_DOOR then
            enterDoor(o2.obj)
            
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_DOOR then
            enterDoor(o1.obj)

        --Touch Spike
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
                local nextWarp = filter(map.warps.objects, "warpToId", "=", o1.obj.id)[1]
                nextWarp.isActive=false
                local callback = function() player:warp(nextWarp.pos.x, nextWarp.pos.y) end
                table.insert(callbacks, callback)
                
            end
        elseif o2.type==COLLIDER_TYPE_WARP and o1.type==COLLIDER_TYPE_PLAYER then
            if o2.obj.isActive then
                local nextWarp = filter(map.warps.objects, "warpToId", "=", o2.obj.id)[1]
                nextWarp.isActive=false
                local callback = function() player:warp(nextWarp.pos.x, nextWarp.pos.y) end
                table.insert(callbacks, callback)
                
            end
        end
        if o1.type==COLLIDER_TYPE_PLAYER and o2.type==OBJECT_TYPE_ITEM then
            collectItem(o2.obj)
        elseif o1.type==OBJECT_TYPE_ITEM and o2.type==COLLIDER_TYPE_PLAYER then
            collectItem(o1.obj)
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

        if o1.type==COLLIDER_TYPE_DOOR and o2.type==COLLIDER_TYPE_PLAYER then
            exitDoor(o1.obj)
        elseif o2.type==COLLIDER_TYPE_DOOR and o1.type==COLLIDER_TYPE_PLAYER then
            exitDoor(o2.obj)
        end
    end
    

end

function presolve(a,b,contact)
    

end

function postsolve(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

    

end

function activateCheckpoint(checkpoint)
    map.currentCheckpoint=checkpoint
    checkpoint:activate()
end

function enterDoor(door)
    if door.isActive==true then
        local callback = function() 
            map = setMap(MAP_TABLE[door.toMapId]);
            local newDoor=filter(map.doors.objects, "id", "=", door.toDoorId)[1]
            newDoor.isActive=false
            player:place({x=newDoor.pos.x, y=newDoor.pos.y}) 
        end
        table.insert(callbacks, callback)
    end
    
end

function exitDoor(door)
    door.isActive=true 
end

function collectItem(item)
    item:collect()
    table.insert(player.itemsCollected, item.itemId)
end