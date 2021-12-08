package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('input.txt')
local epsilonLines = {table.unpack(lines)}

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


local function buildGammaString(gammaLines, giveEpsilon)
    local bytes = {}

    for i=0, #gammaLines[1] - 1 do
        bytes[i] = {0,0}
    end

    for _,v in pairs(gammaLines) do
        local result = {}
        for letter in v:gmatch(".") do table.insert(result, letter) end

        for s,byte in pairs(result) do
            bytes[s - 1][tonumber(byte) + 1] = bytes[s-1][tonumber(byte) + 1] + 1
        end
    end

    local gammaRateString = {}
    for i =0, #bytes do
        if bytes[i][1] > bytes[i][2] then
            table.insert(gammaRateString, giveEpsilon and '0' or '1')
        else
            table.insert(gammaRateString, giveEpsilon and '1' or '0')
        end
    end

    return gammaRateString
end

local gammaStringTable = buildGammaString(lines)
local epsilonStringTable = buildGammaString(lines, true)

print('Gammastring', table.concat(gammaStringTable, ''))
print('Epsilonstring', table.concat(epsilonStringTable, ''))

local function testByteInString(bytePos, gammaStringTable, line)
    local lineTable = {}
    for letter in line:gmatch(".") do table.insert(lineTable, letter) end

    return lineTable[bytePos] == gammaStringTable[bytePos]
end

local function testGammaStringTable(bytePos, oLines, oGammaStringTable)
    local newLines = {}
    for i=1,#oLines do
        if testByteInString(bytePos, oGammaStringTable, oLines[i]) then
            table.insert(newLines, oLines[i])
        end
    end
    return newLines
end

local bytePos = 0

repeat
    lines = testGammaStringTable(bytePos, lines, gammaStringTable)
    if lines == nil or #lines == 0 then break end

    gammaStringTable = buildGammaString(lines)
    bytePos = bytePos + 1
    if bytePos > #lines[1] then
        bytePos = 0
    end
until #lines == 1

print()
print('Epsilon')
bytePos = 0
repeat
    epsilonLines = testGammaStringTable(bytePos, epsilonLines, epsilonStringTable)
    if epsilonLines == nil or #epsilonLines == 0 then break end

    epsilonStringTable = buildGammaString(epsilonLines, true)
    bytePos = bytePos + 1
    if bytePos > #epsilonLines[1] then
        bytePos = 0
    end
until #epsilonLines == 1

print('Lines', table.concat(lines, ''))
print('EpsilonLines', table.concat(epsilonLines, ''))

print()
print(tonumber(lines[1], 2))
print(tonumber(epsilonLines[1], 2))
print(tonumber(lines[1], 2) * tonumber(epsilonLines[1], 2))
