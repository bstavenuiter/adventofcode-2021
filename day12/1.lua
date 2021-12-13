package.path = package.path .. ";../?.lua"
require('library')

-- local lines = lines_from('example.txt')
-- local lines = lines_from('example2.txt')
-- local lines = lines_from('example3.txt')
local lines = lines_from('input.txt')

function ExplodeLine(line)
    local lineTable = {}
    _,_, a,b = string.find(line or '', '(%a+)-(%a+)')

    return a,b
end

local baseTree = {}

function AddNode(nodes, nodeName, accessToNode)
    if nodes[nodeName] then
        nodes[nodeName]["accessTo"][accessToNode] = accessToNode
    else
        nodes[nodeName] = {
            accessTo = {accessToNode = accessToNode},
            seen = false,
            isBigCave = string.byte(nodeName) < 97,
            name = nodeName,
            isStart = nodeName == 'start',
            isEnd = nodeName == 'end'
        }
    end
    return nodes
end

for _,line in ipairs(lines) do
    local nodeLeft, nodeRight = ExplodeLine(line)
    baseTree = AddNode(baseTree, nodeLeft, nodeRight)
    baseTree = AddNode(baseTree, nodeRight, nodeLeft)
end


function Deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[Deepcopy(orig_key, copies)] = Deepcopy(orig_value, copies)
            end
            setmetatable(copy, Deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function FindPaths(tree)
    print('Start!')
    local path = 'start,'
    local node = tree['start']
    tree[node.name].seen = true

    local paths = Traverse(tree, {}, node, path)

    return paths
end

function Traverse(tree, paths, node, path)
    for _,subNode in pairs(node.accessTo) do
        local pathCopy = path
        local treeCopy = Deepcopy(tree)
        subNode = treeCopy[subNode]

        if subNode.name == 'end' then
            paths[#paths + 1] = pathCopy .. 'end'
        end

        if not subNode.isBigCave and not subNode.seen and not subNode.isEnd and not subNode.isStart then
            treeCopy[subNode.name].seen = true
            pathCopy = pathCopy .. subNode.name .. ','
            paths = Traverse(treeCopy, paths, subNode, pathCopy)
        end

        if subNode.isBigCave and not subNode.isEnd and not subNode.isStart then
            treeCopy[subNode.name].seen = true
            pathCopy = pathCopy .. subNode.name .. ','
            paths = Traverse(treeCopy, paths, subNode, pathCopy)
        end
    end
    return paths
end

function FindNext(nodes, nodeName, mayBeEnd)
    mayBeEnd = mayBeEnd or false
    local node = nodes[nodeName]

    for _,v in pairs(node.accessTo) do
        if (mayBeEnd and nodes[v].name == 'end') or nodes[v].isBigCave or not nodes[v].seen then
            return v
        end
    end
    return false
end


local paths = FindPaths(baseTree)
print()
for _,path in ipairs(paths) do
    print('Path: ' .. path)
end
print()
print('Amount paths ' .. #paths)
