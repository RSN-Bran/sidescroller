function calculateDistance(position1, position2)
    local xDistance = (position2.x - position1.x)^2
    local yDistance = (position2.y - position1.y)^2
    return math.sqrt(xDistance+yDistance)
end

function contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function removeValue(tab, val)

    for index, value in ipairs(tab) do
        if value == val then
            table.remove(tab, index)
        end
    end

end

-- Return the first index with the given value (or nil if not found).
function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function isempty(s)
    return s == nil or s == ''
end

function printTableKeys(tab)
    for k,v in pairs(tab) do
        print(k)
    end
end

function increment(val, inc)
    return val + inc
end

function dumpTable(table, depth)
    if (depth > 200) then
      print("Error: Depth > 200 in dumpTable()")
      return
    end
    for k,v in pairs(table) do
      if (type(v) == "table") then
        print(string.rep("  ", depth)..k..":")
        dumpTable(v, depth+1)
      else
        print(string.rep("  ", depth)..k..": ",v)
      end
    end
end

function print_r(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(print_r(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n"..print_r(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end

function selectFields(obj, fields)
end

function filter(table, field, operator, value)
    local retArr = {}
    for i,v in ipairs(table) do 
        if operator == "=" and v[field] == value then
            retArr[#retArr+1] = v
        elseif operator == ">" and v[field] > value then
            retArr[#retArr+1] = v
        elseif operator == ">=" and v[field] >= value then
            retArr[#retArr+1] = v
        elseif operator == "<" and v[field] < value then
            retArr[#retArr+1] = v
        elseif operator == "<=" and v[field] <= value then
            retArr[#retArr+1] = v
        elseif operator == "~=" and v[field] ~= value then
            retArr[#retArr+1] = v
        elseif operator == "null" and isempty(v[field]) then
            retArr[#retArr+1] = v
        elseif operator == "not null" and not isempty(v[field]) then
            retArr[#retArr+1] = v
        end
    end
    return retArr
end

function contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function concatTables(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function getObjectsFromLayer(layerObj, layerName)
    local objs= filter(layerObj, "name", "=", layerName)[1]
    if isempty(objs) then
        return {}
    else 
        return objs.objects
    end
end




-- function slice (tbl, s, e)
--     local pos, new = 1, {}
    
--     for i = s, e do
--         new[pos] = tbl[i]
--         pos = pos + 1
--     end
    
--     return new
-- end

-- function nilSafeIndex(table, indexes)
--     if isempty(indexes) then
--         return table
--     elseif isempty(table[indexes[1]]) then
--         return nil
--     else
--         nilSafeIndex(table[indexes[1]], slice(table, ))
--     end
-- end