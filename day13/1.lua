package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('example.txt')
-- local lines = lines_from('input.txt')

function ExplodeLine(line, pattern)
    local _,_, a,b = string.find(line or '', pattern)

    return a,b
end

local dots = {}
local instructions = {}

for _,line in ipairs(lines) do
    if string.find(line, ',') then
        local x,y = ExplodeLine(line, '(%d+),(%d+)')
        dots[x..','..y] = {x=tonumber(x),y=tonumber(y)}
    elseif #line ~= 0 then
        local direction, lineNr = ExplodeLine(line, 'fold along (%a+)=(%d+)')
        instructions[#instructions + 1] = {direction = direction, foldAlong = tonumber(lineNr)}
    end
end

function Fold(dots, instructions, times)
    for _, instruction in ipairs(instructions) do
        local newDots = {}
        print('Folding on ' .. instruction.direction .. '=' .. instruction.foldAlong)
        for k,dot in pairs(dots) do
            if instruction.direction == 'y' then
                if dot.y > instruction.foldAlong then
                    local newDotY = instruction.foldAlong - (dot.y-instruction.foldAlong)
                    newDots[dot.x .. ',' .. newDotY] = {x=dot.x, y=newDotY}
                else
                    newDots[dot.x .. ',' .. dot.y] = {x=dot.x, y=dot.y}
                end
            end

            if instruction.direction == 'x' then
                if dot.x > instruction.foldAlong then
                    local newDotX = instruction.foldAlong - (dot.x-instruction.foldAlong)
                    newDots[newDotX .. ',' .. dot.y] = {x=newDotX, y=dot.y}
                else
                    newDots[dot.x .. ',' .. dot.y] = {x=dot.x, y=dot.y}
                end
            end

        end
        dots = newDots

        times = times - 1
        if times == 0 then
            break
        end
    end
    return dots
end

function PrintDots(dots)
    local yMax = 0
    local xMax = 0
    for _,dot in pairs(dots) do
        yMax = math.max(dot.y, yMax) xMax = math.max(dot.x, xMax)
    end

    for y=0,yMax do
        local line = ''
        for x=0,xMax do
            if dots[x..','..y] then
                line = line .. '#'
            else
                line = line .. '.'
            end
        end
        print(line)
    end
end

function PrintAmountDots(dots)
    local amountDots = 0
    for _,_ in pairs(dots) do
        amountDots = amountDots + 1
    end
    print('Amount dots ' .. amountDots)
end

PrintAmountDots(dots)

print('Answer part 1:')
PrintAmountDots(Fold(dots, instructions, 1))
print()

PrintDots(Fold(dots, instructions, 100))
