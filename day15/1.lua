package.path = package.path .. ";../?.lua"
require('library')

-- local lines = lines_from('example.txt')
local lines = lines_from('input.txt')

function ExplodeLine(line, delimiter)
    local lineDigits = {}
    for k in string.gmatch(line or '', delimiter) do
        lineDigits[#lineDigits + 1] = tonumber(k)
    end
    return lineDigits
end

local positionTable = {}
for k,line in pairs(lines) do
    positionTable[k] = ExplodeLine(line, '.')
end

local nodes = {{0}}
local visited = {}
local steps = 0
local currentNode = {x=1,y=1,v=0}
local length = #positionTable
repeat
    local neighbours = {
        {x=currentNode.x+1,y=currentNode.y},
        {x=currentNode.x-1,y=currentNode.y},
        {x=currentNode.x,y=currentNode.y+1},
        {x=currentNode.x,y=currentNode.y-1}
    }
    for _,v in ipairs(neighbours) do
        if v.y > 0 and v.y <= length and v.x > 0 and v.x <= length then
            if visited[v.y] == nil then
                visited[v.y] = {}
            end
            if visited[v.y][v.x] == nil then
                if nodes[v.y] == nil then
                    nodes[v.y] = {}
                end
                nodes[v.y][v.x] = math.min(currentNode.v + positionTable[v.y][v.x], nodes[v.y][v.x] and nodes[v.y][v.x] or math.huge)
            end
        end
    end

    if visited[currentNode.y] == nil then
        visited[currentNode.y] = {}
    end

    visited[currentNode.y][currentNode.x] = true

    local smallestIndex = nil
    local smallest = math.huge
    for k,v in pairs(nodes) do
        for j,s in pairs(v) do
            if visited[k][j] == nil and smallest > s then
                smallest = s
                smallestIndex = {x=j,y=k,v=s}
            end
        end
    end

    if (visited[length] and visited[length][length]) or not smallestIndex then
        break
    end
    --print('new smallest index ' .. smallestIndex.y .. '-' .. smallestIndex.x)
    currentNode = smallestIndex
    steps = steps+1
until steps ==10000

if visited[length] and visited[length][length] then
    print('Shortest path to end ' .. nodes[length][length])
end
