package.path = package.path .. ";../?.lua"
require('library')

--local lines = lines_from('example.txt')
--local lines = lines_from('example2.txt')
local lines = lines_from('input.txt')

function signalToNumber(signal)
    local charTotal = 0
    for char in string.gmatch(signal, '.') do
        charTotal = charTotal + string.byte(char)
    end
    return charTotal
end

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
--  5 segments either 5 or 2 or 3, 3 when all bits from 7 is set
--  6 segments either 6 or 9 or 0, all bith compared to a 3 are set then 9
--  7 segments = 8

-- first find 1 4 7 and 8
-- find 3 via 7
-- find 9 via 3
-- find 5 and 2 via 9, not 3 and 2 missing then 2, 1 missing then 5
-- find 6 via 5, only 1 missing, else it is a 0
--
-- other solution might be deducing what bits represent what
--             a
--           ....
--        f .    . b
--          .    . <- 00100000
--           ....  g <- 00000001
--        e .    . c
--          .    .
--           ....
--             d
--
--    a = diff 7 and 1
--    g = not set bit in 8
--    f = when 4 all bits in 1 and g
--    d = all bits of 7 and 4 exept one
--    c = a & g & f & d remaining bit not b not e
--    b = 1 bit minus c bit
--    e = last bit

function amountOverLapping(string1, string2)
    local string1Table =  {}
    for word in string.gmatch(string1, '(.)') do
        table.insert(string1Table, word)
    end

    local amountFound = 0
    for _,v in pairs(string1Table) do
        for word in string.gmatch(string2, '(.)') do
            if v == word then
                amountFound = amountFound + 1
            end
        end
    end
    return amountFound
end

function findSignalNumber(signalTable, signal)
    for signalNumber, s in pairs(signalTable) do
        local amountFound = 0
        if #s == #signal then
            for string1 in string.gmatch(signal, '.') do
                for string2 in string.gmatch(s, '.') do
                    if string2 == string1 then
                        amountFound = amountFound + 1
                    end
                end
            end
            if amountFound == #signal then
                return signalNumber
            end
        end
    end
end

local totalAmount = 0
for _,line in pairs(lines) do
    local signalTable = {}
    local breakUntil = 1000
    local secondPartOfLine = line:sub(62,-1)
    line = line:sub(1, 58)
    local signals = {}
    for word in string.gmatch(line, '([^ ]+)') do
        signals[#signals + 1] = word
    end

    local amountFound = 0
    repeat
        for _,signal in pairs(signals) do
            if #signal == 2 and signalTable[1] == nil then
                signalTable[1] = signal
                amountFound = amountFound + 1
            end
            if #signal == 3 and signalTable[7] == nil then
                signalTable[7] = signal
                amountFound = amountFound + 1
            end
            if #signal == 4 and signalTable[4] == nil then
                signalTable[4] = signal
                amountFound = amountFound + 1
            end
            if #signal == 7 and signalTable[8] == nil then
                signalTable[8] = signal
                amountFound = amountFound + 1
            end

            -- find 5,2 of 3
            if #signal == 5 then
                if signalTable[7] ~= nil and signalTable[3] == nil then
                    if amountOverLapping(signalTable[7], signal) == 3 then
                        signalTable[3] = signal
                        amountFound = amountFound + 1
                    end
                end
                --9 has been found and also 3
                if signalTable[9] ~= nil and signalTable[3] ~= signal then
                    if signalTable[2] == nil and amountOverLapping(signalTable[9], signal) == 4 then
                        --should be 2
                        signalTable[2] = signal
                        amountFound = amountFound + 1
                    end

                    if signalTable[5] == nil and amountOverLapping(signalTable[9], signal) == 5 then
                        --should be 5
                        signalTable[5] = signal
                        amountFound = amountFound + 1
                    end
                end
            end

            -- find 6,9 or 0
            if #signal == 6 then
                if signalTable[9] == nil and signalTable[3] ~= nil then
                    if amountOverLapping(signalTable[3], signal) == 5 then
                        signalTable[9] = signal
                        amountFound = amountFound + 1
                    end
                end

                if signalTable[5] ~= nil and signal ~= signalTable[9] then
                    if signalTable[6] == nil and amountOverLapping(signalTable[5], signal) == 5 then
                        signalTable[6] = signal
                        amountFound = amountFound + 1
                    end
                    if signalTable[0] == nil and amountOverLapping(signalTable[5], signal) == 4 then
                        signalTable[0] = signal
                        amountFound = amountFound + 1
                    end
                end
            end
        end
        breakUntil = breakUntil - 1
    until #signalTable == 10 or amountFound == 10 or breakUntil == 0
    --print('Break until' .. breakUntil)

    local signals = {}
    for word in string.gmatch(secondPartOfLine, '([^ ]+)') do
        signals[#signals + 1] = word
    end

    local signalNumber = ''
    for _,signal in pairs(signals) do
        signalNumber = signalNumber .. (findSignalNumber(signalTable, signal))
    end
    print(signalNumber)
    totalAmount = totalAmount + tonumber(signalNumber)
end
print('Total amount: ' .. totalAmount)


