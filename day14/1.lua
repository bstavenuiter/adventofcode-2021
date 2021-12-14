package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('example.txt')
-- local lines = lines_from('input.txt')

function ExplodeLine(line, pattern)
    local _,_, a,b = string.find(line or '', pattern)

    return a,b
end

function ExplodeTemplate(template)
    local templateTable = {}
    for k in string.gmatch(template or '', '.') do
        templateTable[#templateTable + 1] = k
    end
    return templateTable
end

function FindIndices(str, pattern)
    local i = 1
    local indices = {}
    while true do
        i,j = string.find(str, pattern, i)
        -- print(i,j)
        if i == nil then break end
        indices[#indices + 1] = i
        i = j
    end
    return indices
end

function SortReplaceTable(tbl)
    table.sort(tbl, function(a,b) return a.dex > b.dex end)
    return tbl
end

local template = lines[1]
local templateTable = ExplodeTemplate(template)
lines[1] = nil
lines[2] = nil

local instructions = {}
for _,v in pairs(lines) do
    local checkPair, insertChar = ExplodeLine(v, '(%a+)%s%-%>%s(%a+)')
    instructions[#instructions + 1] = {checkPair = checkPair, insertChar = insertChar}
end
print('Template: ' .. template)
print('Amount instructions: ' .. #instructions)

local steps = 0
repeat
    local template = table.concat(templateTable, '')
    local replaceTable = {}
    for _,instruction in ipairs(instructions) do
        local indices = FindIndices(template, instruction.checkPair)
        if #indices then
            for _,v in ipairs(indices) do
                replaceTable[#replaceTable + 1] = {dex = v+1, insertChar = instruction.insertChar}
            end
        end
    end
    replaceTable = SortReplaceTable(replaceTable)

    for _,v in ipairs(replaceTable) do
        table.insert(templateTable, v.dex, v.insertChar)
    end
    print('Step: ' .. steps)
    print('Length: ' .. #templateTable)

    steps = steps + 1
until steps == 10

local charTable = {}
for _,char in ipairs(templateTable) do
    if not charTable[char] then
        charTable[char] = 0
    end
    charTable[char] = charTable[char] + 1
end

local lowestAmount = math.huge
local highestAmount = 0
for k,v in pairs(charTable) do
    lowestAmount = math.min(lowestAmount, v)
    highestAmount = math.max(highestAmount, v)
end
print('Lowest amount ' .. lowestAmount)
print('Highest amount ' .. highestAmount)
print(highestAmount - lowestAmount)
