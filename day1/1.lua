package.path = package.path .. ";../?.lua"
require('library')

-- tests the functions above
local file = 'input.txt'
local lines = lines_from(file)
local previousDepth = 0
local amountIncrementing = 0
local amountDecrementing = 0

-- print all line numbers and their contents
for k,v in pairs(lines) do
    v = tonumber(v)
    if previousDepth ~= 0 and v > previousDepth then
        amountIncrementing = amountIncrementing + 1
    end

    if previousDepth ~= 0 and v < previousDepth then
        amountDecrementing = amountDecrementing + 1
    end
    previousDepth = v
end

print('Amount incrementing ' .. amountIncrementing)
print('Amount decrementing ' .. amountDecrementing)
