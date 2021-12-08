package.path = package.path .. ";../?.lua"
require('library')

--local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

local spawnTime = 7
local firstCycleStartup = 1
local line = lines[1]
local day = 1
local totalDays = 257

local t = string.gmatch(line, '([^,]+)')

local def = {}
for spawnUntil in t do
    table.insert(def, {1, tonumber(spawnUntil)})
end

repeat
    local amountFishToAdd = 0
    for _,fishDef in pairs(def) do
        if fishDef[2] == 0 then
            fishDef[2] = spawnTime
            amountFishToAdd = amountFishToAdd + (fishDef[1])
        end
        fishDef[2] = fishDef[2] - 1
    end

    if amountFishToAdd > 0 then
        table.insert(def, {amountFishToAdd, spawnTime + firstCycleStartup})
    end
    day = day + 1
until day == totalDays


local amountTotal = 0
for _,fishDef in pairs(def) do
    amountTotal = amountTotal + fishDef[1]
end

print('Total fished in the sea after ' .. day .. ' days: ' .. amountTotal)
