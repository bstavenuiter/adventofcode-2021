package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('input.txt')

--local testString = [[
--00100
--11110
--10110
--10111
--10101
--01111
--00111
--11100
--10000
--11001
--00010
--01010]]

local bytes = {}

for i=0, #lines[1] - 1 do
    bytes[i] = {0,0}
    i = i+1
end

for k,v in pairs(lines) do
    local result = {}
    for letter in v:gmatch(".") do table.insert(result, letter) end

    for s,byte in pairs(result) do
        bytes[s - 1][tonumber(byte) + 1] = bytes[s-1][tonumber(byte) + 1] + 1
    end
end

local gammaRateString = ""
local epsilonString = ""

for i =0, #bytes do
    if bytes[i][1] > bytes[i][2] then
        gammaRateString = gammaRateString .. '0'
        epsilonString = epsilonString .. '1'
    else
        gammaRateString = gammaRateString .. '1'
        epsilonString = epsilonString .. '0'
    end
    i = i + 1
end

print(tonumber(gammaRateString, 2))
print(tonumber(epsilonString, 2))
print(tonumber(gammaRateString, 2) * tonumber(epsilonString, 2))
