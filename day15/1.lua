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

local visited = {}
local nodes = {}
for i = 1,#positionTable do
    visited[i] = {}
    nodes[i] = {}
    for j = 1,#positionTable do
        visited[i][j] = false
        nodes[i][j] = math.huge
    end
end

nodes[1][1] = 0
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
        if visited[v.y] ~= nil and visited[v.y][v.x] == false then
            nodes[v.y][v.x] = math.min(currentNode.v + positionTable[v.y][v.x], nodes[v.y][v.x])
        end
    end

    visited[currentNode.y][currentNode.x] = true

    local smallestIndex = nil
    local smallest = math.huge
    for k,v in pairs(nodes) do
        for j,s in pairs(v) do
            if visited[k][j] == false and smallest > s then
                smallest = s
                smallestIndex = {x=j,y=k,v=s}
            end
        end
    end

    if visited[length][length] or not smallestIndex then
        break
    end
    --print('new smallest index ' .. smallestIndex.y .. '-' .. smallestIndex.x)
    currentNode = smallestIndex
    steps = steps+1
until steps ==10000

if visited[length][length] then
    print('Shortest path to end ' .. nodes[length][length])
end
