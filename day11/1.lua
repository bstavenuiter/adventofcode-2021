package.path = package.path .. ";../?.lua"
require('library')

-- local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

function ExplodeLine(line)
    local lineTable = {}
    for word in string.gmatch(line or '', '.') do
        lineTable[#lineTable + 1] = tonumber(word)
    end
    return lineTable
end

local grid = {}
for _,line in pairs(lines) do
    table.insert(grid, ExplodeLine(line))
end

function UpNumber(grid, x, y, newAboutToFlash)
    if grid[y] and grid[y][x] and grid[y][x] ~= 0 then
        grid[y][x] = grid[y][x] + 1
        if grid[y][x] > 9 then
            table.insert(newAboutToFlash, {y=y,x=x})
            grid[y][x] = 0
        end
    end
    return grid, newAboutToFlash
end

local step = 1
local amountLoops = 400 -- for part 1 answer set to 100
local amountFlashed = 0
repeat
    local thoseWhoAreAboutToFlash = {}
    os.execute('clear')
    for k,v in ipairs(grid) do
        local line = ''
        for j,u in ipairs(v) do
            if u == 9 then
                table.insert(thoseWhoAreAboutToFlash, {y=k,x=j})
                u = 0
            else
                u = grid[k][j] + 1
            end

            line = line .. u
        end
        print(line)
        grid[k] = ExplodeLine(line)
    end
    print('Step ' .. step)
    amountLoops = amountLoops - 1

    local amountToFlash = 0
    while #thoseWhoAreAboutToFlash > 0 do
        amountFlashed = amountFlashed + #thoseWhoAreAboutToFlash

        --part 2, all octopusses flashed
        amountToFlash = amountToFlash + #thoseWhoAreAboutToFlash
        if amountToFlash == 100 then
            print('Step ' .. step - 1)
            amountLoops = 0
        end

        local newAboutToFlash = {}

        for _,v in pairs(thoseWhoAreAboutToFlash) do
            -- right
            grid, newAboutToFlash = UpNumber(grid,v.x+1, v.y, newAboutToFlash)
            -- up
            grid, newAboutToFlash = UpNumber(grid,v.x, v.y-1, newAboutToFlash)
            -- down
            grid, newAboutToFlash = UpNumber(grid,v.x, v.y+1, newAboutToFlash)
            -- left
            grid, newAboutToFlash = UpNumber(grid,v.x-1, v.y, newAboutToFlash)
            -- top left
            grid, newAboutToFlash = UpNumber(grid,v.x-1, v.y-1, newAboutToFlash)
            -- top right
            grid, newAboutToFlash = UpNumber(grid,v.x+1, v.y-1, newAboutToFlash)
            -- bottom right
            grid, newAboutToFlash = UpNumber(grid,v.x+1, v.y+1, newAboutToFlash)
            -- bottom left
            grid, newAboutToFlash = UpNumber(grid,v.x-1, v.y+1, newAboutToFlash)
            grid[v.y][v.x] = 0
        end
        thoseWhoAreAboutToFlash = newAboutToFlash

        os.execute('sleep 0.01')
        os.execute('clear')
        for _,v in ipairs(grid) do
            local line = ''
            for _,u in ipairs(v) do
                if u == 0 then
                    u = '\27[31m' .. u .. '\27[0m'
                end
                line = line .. u
            end
            print(line)
        end
        print('Step ' .. step)
    end
    step = step+1

until amountLoops == 0

-- part 1 when loop is 100
print('Amount flashed: ' .. amountFlashed)
