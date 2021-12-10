package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('example.txt')
--local lines = lines_from('input.txt')

function ExplodeLine(line)
    local lineTable = {}
    for word in string.gmatch(line or '', '.') do
        lineTable[#lineTable + 1] = word
    end
    return lineTable
end

local scoringTable = {
    [")"] = 3,
    ["]"] = 57,
    ["}"] = 1197,
    [">"] = 25137
}
local part2ScoringTable = {
    [")"] = 1,
    ["]"] = 2,
    ["}"] = 3,
    [">"] = 4
}
local openBrackets = {
    ["("] = ')',
    ["["] = ']',
    ["{"] = '}',
    ["<"] = '>'
}
local expectingTable = {
    [")"] = '(',
    ["]"] = '[',
    ["}"] = '{',
    [">"] = '<',
    ["("] = ')',
    ["["] = ']',
    ["{"] = '}',
    ["<"] = '>',
}

local part2LineScores = {}
local score = 0

function TableReverse(someTable)
    local newTable = {}
    for i = #someTable, 1, -1 do
        table.insert(newTable, someTable[i])
    end
    return newTable
end

function TableSort(someTable)
    local newTable = {}
    for i = #someTable, 1, -1 do
        table.insert(newTable, someTable[i])
    end
    return newTable
end

for _,line in pairs(lines) do
    local stack = {}
    print(line)
    local lineTable = ExplodeLine(line)
    local corrupted = false
    for k,char in pairs(lineTable) do
        if not openBrackets[char] then
            if char == stack[#stack] then --expected closing char
                stack[#stack] = nil
            else
                print('Expected ' .. stack[#stack] .. ' but found ' .. char .. ' at index ' .. k)
                score = score + scoringTable[char]
                corrupted = true
                break
            end
        else
            table.insert(stack, expectingTable[char])
        end
    end
    -- part2 
    if not corrupted and #stack then
        local lineScore = 0
        stack = TableReverse(stack)
        for _,v in pairs(stack) do
            lineScore = lineScore * 5 + (part2ScoringTable[v])
        end
        table.insert(part2LineScores, lineScore)
    end
    print()
end

print('Score ' .. score)

table.sort(part2LineScores, function(a,b) return a < b end)
print('Part2 Score ' .. part2LineScores[math.floor(#part2LineScores/2) + 1])
