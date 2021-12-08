package.path = package.path .. ";../?.lua"
require('library')

local lines = lines_from('input.txt')

local enablePart2 = true
local numbers = lines[1]
lines[1] = nil

Board = {bingoLines = {}}
Board.__index = Board
Cell = {value = 0, marked = false}

function Board:create(lines)
   local board = {bingoLines = {}}             -- our new object
   setmetatable(board,Board)  -- make Account handle lookup
    for _,line in pairs(lines) do
        local bingoLine = {}
        for match in string.gmatch(line, "%S+") do
            local cell = Cell.new({value = match, marked = false})
            table.insert(bingoLine, cell)
        end
        if bingoLine[2] ~= nil then --todo fix this, shouldn be needed to check
            table.insert(board.bingoLines, bingoLine)
        end
    end
   return board
end

function Cell:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function Board:markNumber(number)
    for _,bingoLine in pairs(self.bingoLines) do
        for _,cell in pairs(bingoLine) do
            if tonumber(cell.value) == tonumber(number) then
                cell.marked = true
            end
        end
    end
end

function Board:hasMarkedALine()
    local amountLines = #self.bingoLines
    for k,bingoLine in pairs(self.bingoLines) do
        local foundMarkedLined = 0
        for _,cell in pairs(bingoLine) do
            if cell.marked then
                foundMarkedLined = foundMarkedLined + 1
            end
        end
        if foundMarkedLined == amountLines then
            return true
        end

        foundMarkedLined = 0
        for i=1,amountLines do
            if self.bingoLines[i][k].marked then
                foundMarkedLined = foundMarkedLined + 1
            end
        end
        if foundMarkedLined == amountLines then
            return true
        end
    end
    return false
end

function Board:sumOfAllUnMarkedNumber()
    local sum = 0
    for _,line in pairs(self.bingoLines) do
        for _,cell in pairs(line) do
            if not cell.marked then
                sum = sum + cell.value
            end
        end
    end
    return sum
end

--start at three, that is where the boards start
local boards = {}
for i=3,#lines, 6 do
    local board = Board:create(table.pack(table.unpack(lines, i, i+5)))
    table.insert(boards, board)
end

for number in string.gmatch(numbers, "([^,]+)") do
    print('Number: ' .. number)
    for b,board in pairs(boards) do
        board:markNumber(number)
        if board:hasMarkedALine() then
            print('Found a board that has a marked line: ' .. b)
            print('Sum of all unmarked: ' .. board:sumOfAllUnMarkedNumber())
            print('Produce of number found and unmarkedLines' .. (number * board:sumOfAllUnMarkedNumber()))
            boards[b] = nil
        end
    end
end
