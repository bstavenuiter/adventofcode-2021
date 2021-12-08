package.path = package.path .. ";../?.lua"
require('library')

local file = './input.txt'
local lines = lines_from(file)

local amountIncrease = 0
local amountDecrease = 0
local previousSlidingMeasure = 0
local currentSlidingMeasure = 0

for k,v in pairs(lines) do
    v = tonumber(v)

    if k > 3 then
        currentSlidingMeasure = lines[k-2] + lines[k-1] + lines[k]
        previousSlidingMeasure = lines[k-3] + lines[k-2] + lines[k-1]
    end

    if currentSlidingMeasure ~= 0 and previousSlidingMeasure ~= 0 then
        if currentSlidingMeasure > previousSlidingMeasure then
            amountIncrease = amountIncrease + 1
            print('increase')
        end
        if currentSlidingMeasure == previousSlidingMeasure then
            print('no increase')
        end
        if currentSlidingMeasure < previousSlidingMeasure then
            amountDecrease = amountDecrease + 1
            print('decrease')
        end
    end
end

print ("Amount increase" .. amountIncrease)
print ("Amount decrease" .. amountDecrease)
