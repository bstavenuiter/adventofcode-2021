package.path = package.path .. ";../?.lua"
require('library')

--local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

local grid = {}
local enableStep2 = true
for _,line in pairs(lines) do
    local _,_,x1,y1,x2,y2 = string.find(line, "(%d+),(%d+)[^0-9]+(%d+),(%d+)")
    y1 = tonumber(y1)
    y2 = tonumber(y2)
    x1 = tonumber(x1)
    x2 = tonumber(x2)
    --0,9 -> 5,9
    if grid[x1] == nil then
        grid[x1] = {}
    end

    if  x1 > x2 then
        x1,x2 = x2,x1
        if enableStep2 then
            y1,y2 = y2,y1
        end
    end

    if enableStep2 and x1 ~= x2 and y1 ~= y2 then
        -- 6,4 -> 2,0
        --print('diagonal' .. line)
        local steps = 0
        for i=x1,x2 do
            if grid[i] == nil then grid[i] = {} end
            grid[i][y1 + steps] = grid[i][y1 + steps] and grid[i][y1 + steps] + 1 or 1
            if y1 < y2 then
                --print('Adding ' .. i .. ',' .. (y1 + steps))
                steps = steps + 1
            end

            if y1 > y2 then
                --print('Adding ' .. i .. ',' .. (y1 + steps))
                steps = steps - 1
            end
        end
    end

    if y1 > y2 then
        y1,y2 = y2,y1
    end

    --going horizontal
    if x1 == x2 then
        if grid[x1] == nil then grid[x1] = {} end
        for i=y1,y2 do
            grid[x1][i] = grid[x1][i] and grid[x1][i] + 1 or 1
            print(x1 .. ',' .. i .. ':' .. grid[x1][i])
        end
        print()
    end

    --going vertical
    if y1 == y2 then
        for i=x1,x2 do
            if grid[i] == nil then grid[i] = {} end
            grid[i][y1] = grid[i][y1] and grid[i][y1] + 1 or 1
            print(i .. ',' .. y1 .. ':' .. grid[i][y1])
        end
        print()
    end

end

local amount = 0
for _,line in pairs(grid) do
    for _,value in pairs(line) do
        if value > 1 then
            amount = amount + 1
        end
    end
end

print(amount)
