package.path = package.path .. ";../?.lua"
require('library')

--local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

local spawnTime = 6
local firstCycleStartup = 2
local line = lines[1]
local day = 1
local totalDays = 81

repeat
    print ('Day ' .. day)
    local addFish = 0
    local lineLength = #line

    for i=1,lineLength,2 do
        local fish = tonumber(line:sub(i,i))

        local newLine = ''
        if fish == 8 then
            --print(line)
            --print('Amount chars left: ' .. (lineLength + 1 - i))
            line = (i > 1 and line:sub(1,i-2) or '') .. (string.rep(',7', math.ceil((lineLength + 1 - i)/2) ))
            break
        end

        newLine = (i > 1 and line:sub(1,i-1) or '') .. (fish == 0 and '6' or (fish - 1))

        if i <= lineLength then
            newLine = newLine .. line:sub(i+1, lineLength)
        end

        if fish == 0 then
            addFish = addFish + 1
        end
        line = newLine
    end

    line = line .. string.rep(',8', addFish)
    day = day + 1
until day == totalDays

local _, amount = string.gsub(line,',', '')
print(amount + 1)
