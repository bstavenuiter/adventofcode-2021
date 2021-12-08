package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('example.txt')
--local lines = lines_from('example2.txt')
--local lines = lines_from('input.txt')

function signalToNumber(signal)
    local charTotal = 0
    for char in string.gmatch(signal, '.') do
        charTotal = charTotal + string.byte(char)
    end
    return charTotal
end

local s = { acedgfb= 8, cdfbe= 5, gcdfa= 2, fbcad= 3, dab= 7, cefabd= 9, cdfgeb= 6, eafb= 4, cagedb= 0, ab= 1} -- small example
local s = { gc=1, cbg=7, gcbe=4, fdgacbe=8 } -- large example
--  ....
-- .    .
-- .    .
--  ....
-- .    .
-- .    .
--  ....
--  2 segments = 1
--  3 segments = 7
--  4 segments = 4
--  5 segments either 5 or 2 or 3, its is a 2 when bl bit is set then all bits from 7 then 3 else 5
--  6 segments either 6 or 9 or 0, 4 segments overlapping then 9 else 6 if all segments of a 3 are set else 0
--  7 segments = 8
--  bl = missing bit from 8 and 9
local signalTable = {}
for k,signal in pairs(s) do
    signalTable[signalToNumber(k)] = signal
end

local amountUnique = 0
for _,line in pairs(lines) do
    line = line:sub(62,-1)
    local signals = {}
    for word in string.gmatch(line, '([^ ]+)') do
        signals[#signals + 1] = word
    end

    --local signalNumber = ''
    for _,signal in pairs(signals) do
        --signalNumber = signalNumber .. (signalTable[signalToNumber(signal)])
        if #signal == 2 or #signal == 3 or #signal == 4 or #signal == 7 then
            amountUnique = amountUnique + 1
        else
        end
    end
    --print(signalNumber)
end
print('Amount unique ' .. amountUnique)
