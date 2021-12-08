package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('input.txt')

local x = 0 --forward position
local y = 0 --depth
local aim = 0 
local part2 = true

function Split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

for k,v in pairs(lines) do
    local split_string = Split(v, ' ')
    local direction = split_string[1]
    local amountInDirection = tonumber(split_string[2])

    if direction == 'forward' then
        x = x + amountInDirection
        if part2 and aim ~= 0 then
            y = y + (aim * amountInDirection)
        end
    end

    if direction == 'up' then
        if part2 then
            aim = aim - amountInDirection
        else
            y = y - amountInDirection
        end
        if y < 0 then
            print'woaw above surface'
            y = 0
        end
    end

    if direction == 'down' then
        if part2 then
            aim = aim + amountInDirection
        else
            y = y + amountInDirection
        end
    end
    print (x, y)
end

print('Position x: ' .. x .. ' y: ' .. y)
print(x * y)

-- 1957702160 too high
-- 1956047400
