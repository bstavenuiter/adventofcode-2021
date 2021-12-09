package.path = package.path .. ";../?.lua"
require('library')

-- local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

function ExploreBasin(key, lines, index, indexes)
    local lineTable = ExplodeLine(lines[index])

    -- if we see the same key again, don't process again
    if indexes[index .. '-' .. key] then
        return indexes
    end

    -- print('Storing ' .. index .. '-' .. key)
    indexes[index .. '-' .. key] = 1

    -- check up
    if lines[index-1] then
        local previousLineTable = ExplodeLine(lines[index - 1])
        if previousLineTable[key] ~= 9 then
            -- print('UP: at (' .. index-1 .. '-' .. (key) .. ') which is' .. previousLineTable[key])
            indexes = ExploreBasin(key, lines, index-1, indexes)
        end
    end

    --check right
    if lineTable[key+1] and lineTable[key+1] ~= 9 then
        -- print('RIGHT: at (' .. index .. '-' .. (key+1) .. ') which is' .. lineTable[key+1])
        indexes = ExploreBasin(key+1, lines, index, indexes)
    end

    -- check down
    if lines[index+1] then
        local nextLineTable = ExplodeLine(lines[index + 1])
        if nextLineTable[key] ~= 9 then
            -- print('DOWN: at (' .. index+1 .. '-' .. (key) .. ') which is' .. nextLineTable[key])
            indexes = ExploreBasin(key, lines, index+1, indexes)
        end
    end

    -- check left
    if lineTable[key-1] and lineTable[key-1] ~= 9 then
        -- print('LEFT: at (' .. index .. '-' .. (key-1) .. ') which is' .. lineTable[key-1])
        indexes = ExploreBasin(key-1, lines, index, indexes)
    end

    return indexes
end

function ExplodeLine(line)
    local lineTable = {}
    for word in string.gmatch(line or '', '.') do
        lineTable[#lineTable + 1] = tonumber(word)
    end
    return lineTable
end

function GetLowestNumberInCurrentLine(scanTable, index)
local previousLine = scanTable[index-1] and scanTable[index-1] or nil
    local currentLine = scanTable[index]
    local nextLine = scanTable[index+1] and scanTable[index+1] or nil

    local lowestNumbers = {}
    local nextLineTable = ExplodeLine(nextLine or '')
    local previousLineTable = ExplodeLine(previousLine or '')
    local currentLineTable = ExplodeLine(currentLine or '')

    for k, word in pairs(currentLineTable) do
        local isLowestNumber = true
        local number = tonumber(word)
        k = tonumber(k)

        isLowestNumber = not(previousLineTable[k] and previousLineTable[k] <= number) and isLowestNumber or false
        isLowestNumber = not(nextLineTable[k] and nextLineTable[k] <= number) and isLowestNumber or false
        isLowestNumber = not(k > 1 and currentLineTable[k-1] <= number) and isLowestNumber or false
        isLowestNumber = not(k < #currentLineTable and currentLineTable[k+1] <= number) and isLowestNumber or false

        -- if previousLineTable[k] and previousLineTable[k] <= number then
        --     isLowestNumber = false
        -- end

        -- if nextLineTable[k] and nextLineTable[k] <= number then
        --     isLowestNumber = false
        -- end

        -- if k > 1 then
        --     if currentLineTable[k-1] <= number then
        --         isLowestNumber = false
        --     end
        -- end

        -- if k < #currentLineTable then
        --     if currentLineTable[k+1] <= number then
        --         isLowestNumber = false
        --     end
        -- end

        if isLowestNumber then
            --table.insert(lowestNumbers, number)
            lowestNumbers[k] = number
            print('Lowest number ' .. number .. ' at index ' .. k )
        end
    end
    return lowestNumbers
end

local scanTable = {}
local basinAmounts = {}

local totalRiskLevel = 0
for k,line in pairs(lines) do
    scanTable[k] = line --current / middle lien

    if k ~=1 then
        scanTable[k-1] = lines[k-1] --previous line
    end

    if lines[k+1] then
        scanTable[k+1] = lines[k+1] -- nextline
    end

    if scanTable[k-2] then
        scanTable[k-2] = nil --remove the oldest line
    end

    print(scanTable[k-1])
    print(scanTable[k])
    print(scanTable[k+1])
    local lowestNumbers = GetLowestNumberInCurrentLine(scanTable, k)
    for _,v in pairs(lowestNumbers) do
        totalRiskLevel = totalRiskLevel + 1 + v
    end


    for lowestKey,_ in pairs(lowestNumbers) do
        print()
        local basin = ExploreBasin(lowestKey, lines, k, {})
        local basinAmount = 0
        for _,_ in pairs(basin) do
            basinAmount = basinAmount + 1
        end
        table.insert(basinAmounts, basinAmount)
        print('Basin amount: ' .. basinAmount)
    end
    print()
end
print('Total risk level ' .. totalRiskLevel)

table.sort(basinAmounts, function(a,b) return a > b end)

print('3 Largest basins amount multiplied: ' .. (basinAmounts[1] * basinAmounts[2] * basinAmounts[3]))
