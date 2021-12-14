
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

local template = lines[1]
local templateTable = ExplodeTemplate(template)

lines[1] = nil
lines[2] = nil

local instructions = {}
for _,v in pairs(lines) do
    local checkPair, insertChar = ExplodeLine(v, '(%a+)%s%-%>%s(%a+)')
    instructions[checkPair] = {string.sub(checkPair,1,1) .. insertChar, insertChar .. string.sub(checkPair,2,2), insertChar, 0, 0}
end
print('Template: ' .. template)
print('Amount instructions: ' .. #instructions)

local charCounter = {}
local previousChar = ''

for char in string.gmatch(template, '.') do
    if previousChar ~= '' then
        instructions[previousChar .. char][4] = instructions[previousChar .. char][4] + 1
    end
    charCounter[char] = charCounter[char] and charCounter[char] + 1 or 1
    previousChar = char
end

local steps = 0
repeat
    for k,v in pairs(instructions) do
        instructions[v[1]][5] = instructions[v[1]][5] + v[4]
        instructions[v[2]][5] = instructions[v[2]][5] + v[4]
        charCounter[v[3]] = charCounter[v[3]] and charCounter[v[3]] + v[4] or 1
        v[4] = 0
    end
    for k,v in pairs(instructions) do
        v[4] = v[5]
        v[5] = 0
    end
    steps = steps + 1
until steps == 40

local lowestAmount = math.huge
local highestAmount = 0
for char,amount in pairs(charCounter) do
    print(char .. ' has seen ' .. amount .. ' appearences')
    highestAmount = math.max(highestAmount, amount)
    lowestAmount = math.min(lowestAmount, amount)
    print('highest - lowest = ' .. highestAmount - lowestAmount - 1)
end
