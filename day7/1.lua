package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('input.txt')
--local lines = lines_from('example.txt')

local crabTable = {}
for word in string.gmatch(lines[1], '([^,]+)') do
    word = tonumber(word)
    if crabTable[word] == nil then
        crabTable[word] = 1
    else
        crabTable[word] = crabTable[word] + 1
    end
end

function findMax(crabTable)
    local max = 0
    for k,v in pairs(crabTable) do
        max = math.max(max,k)
    end
    return max
end

local maxDistance = findMax(crabTable)

local bestScore = 99999999999
local bestScoreGaussian = 99999999999

for i=0,maxDistance do
    local currentScore = 0
    for k,v in pairs(crabTable) do
        currentScore = currentScore + ( math.abs(k-i) * v)
    end
    bestScore = math.min(bestScore, currentScore)
end

for i=0,maxDistance do
    local currentScore = 0
    for k,v in pairs(crabTable) do
        currentScore = currentScore + ( (math.abs(k-i) / 2) * (1 + math.abs(k-i) )  * v)
    end
    bestScoreGaussian = math.min(bestScoreGaussian, currentScore)
end

print('Least fuel possible ' .. bestScore)
print('Least fuel possible gaussian ' .. bestScoreGaussian)

