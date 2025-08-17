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
            collideWithHitbox(o2.obj)
           
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_SPIKE then
            collideWithHitbox(o1.obj)
            
        elseif o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_WALL then
            --player.hasJump=true
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_WALL then
            --player.hasJump=true
        elseif o1.type==COLLIDER_TYPE_PLAYER_GROUND_DETECTION and o2.type==COLLIDER_TYPE_WALL then
            player.hasJump=true
        elseif o2.type==COLLIDER_TYPE_PLAYER_GROUND_DETECTION and o1.type==COLLIDER_TYPE_WALL then
            player.hasJump=true
        elseif o1.type==COLLIDER_TYPE_WARP and o2.type==COLLIDER_TYPE_PLAYER then
            enterWarp(o1.obj)
        elseif o2.type==COLLIDER_TYPE_WARP and o1.type==COLLIDER_TYPE_PLAYER then
            enterWarp(o2.obj)
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
            exitDoor(o1.obj)
        elseif o2.type==COLLIDER_TYPE_WARP and o1.type==COLLIDER_TYPE_PLAYER then
            exitDoor(o2.obj)
        end

        if o1.type==COLLIDER_TYPE_DOOR and o2.type==COLLIDER_TYPE_PLAYER then
            exitDoor(o1.obj)
        elseif o2.type==COLLIDER_TYPE_DOOR and o1.type==COLLIDER_TYPE_PLAYER then
            exitDoor(o2.obj)
        end
    end
    

end

function presolve(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()
    

end

function postsolve(a,b,contact)
    local o1,o2 = a:getUserData(), b:getUserData()

end

function persistentContact(a,b)
    local o1,o2 = a:getUserData(), b:getUserData()
    if o1 and o2 then
        --Touch Spike
        if o1.type==COLLIDER_TYPE_PLAYER and o2.type==COLLIDER_TYPE_SPIKE then
            local callback = function() player:hurt(o2.obj.damage) end
            table.insert(callbacks, callback)
        elseif o2.type==COLLIDER_TYPE_PLAYER and o1.type==COLLIDER_TYPE_SPIKE then
            local callback = function() player:hurt(o1.obj.damage) end
            table.insert(callbacks, callback)
        end
    end
end

function collideWithHitbox(hitObj)
    local callback = function() player:hurt(hitObj.damage) end
    table.insert(callbacks, callback)
end

function activateCheckpoint(checkpoint)
    map.currentCheckpoint=checkpoint
    checkpoint:activate()
end

function enterWarp(warp)
    if warp.isActive==true then
        local callback = function() 
            if map.mapId~=warp.toMapId then
                print("test")
                map = setMap(MAP_TABLE[warp.toMapId]);
            end
            local newWarp=filter(map.warps.objects, "warpId", "=", warp.toWarpId)[1]
            newWarp.isActive=false
            player:warp(newWarp.pos.x, newWarp.pos.y)
            player:place({x=newWarp.pos.x, y=newWarp.pos.y}) 
            
        end
        table.insert(callbacks, callback)
    end
    
end

function exitDoor(door)
    door.isActive=true 
end

function enterDoor(door)
    if door.isActive==true then
        local callback = function() 
            map = setMap(MAP_TABLE[door.toMapId]);
            local newDoor=filter(map.doors.objects, "doorId", "=", door.toDoorId)[1]
            newDoor.isActive=false

            if newDoor.isHorizontal then
                newX=newDoor.pos.x+(newDoor.width/2)
                newY=newDoor.pos.y
            else
                newY=newDoor.pos.y+newDoor.height-5
                if newDoor.pos.x < 0 then
                    newX=newDoor.pos.x+newDoor.width
                else
                    newX=newDoor.pos.x
                end
                
            end
            player:place({x=newX, y=newY}) 
            
        end
        table.insert(callbacks, callback)
    end
    
end

function exitDoor(door)
    door.isActive=true 
end

function collectItem(item)
    item:collect()
    player.itemsCollected[item.itemId] = true
    player.itemCount=player.itemCount+1
end