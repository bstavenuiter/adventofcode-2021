package.path = package.path .. ";../?.lua"
require('library')

--local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

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
            table.insert(lowestNumbers, number)
            print('Lowest number ' .. number .. ' at index ' .. k )
        end
    end
    return lowestNumbers
end

local scanTable = {}

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
    print()
end
print('Total risk level ' .. totalRiskLevel)

