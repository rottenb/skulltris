NO_BRICK = 0
BRICK = 1
FLOOR = 2

BRICK_ROW = 5

stackMap = { }

function newMapRow(i)
  return {2,i,i,i,i,i,i,i,i,i,i,i,i,2}
end

function createMap()
  -- a whole lot of zeros
  for i = 1,20 do
    stackMap[i] = newMapRow(NO_BRICK)
  end
  -- final layer for the floor
  stackMap[21] = newMapRow(FLOOR)
  stackMap[22] = newMapRow(FLOOR)
end

function stackMapUpdate()
  local x, y, map = brick.get()

  for k,v in ipairs(map) do
    for i,j in ipairs(v) do
      if stackMap[k+y][i+x+1] == 0 then
        stackMap[k+y][i+x+1] = j
      end
    end
  end

  SCORE = SCORE + 50

end

-- scan for full rows
function stackRowScan()
  local rows = {}
  -- go look at each row, look for full rows
  for k,v in ipairs(stackMap) do
    local n = 0
    for i,j in ipairs(v) do
      if j < 2 then
        n = n + j
      end
    end

    -- delete the row if completed, add a new one to the top
    if n >= 12 then
      table.insert(rows, k)
    end
  end

  -- update the stackMap
  for k,v in pairs(rows) do
    stackRedrawCanvas(v)
    table.remove(stackMap, v)
    table.insert(stackMap, 1, newMapRow(0))

    SCORE = SCORE + 500
  end
end

function stackRedrawCanvas(idx)
  local dy = (idx-1) * TILE_SIZE
  local oy = TILE_SIZE
  local buffer = love.graphics.newCanvas(360,dy)

  love.graphics.setCanvas(buffer)
  --love.graphics.setColor(RED)
  --love.graphics.rectangle('fill', 0, 0, buffer:getWidth(), buffer:getHeight())
  love.graphics.draw(stackCanvas, 0, 0)
  love.graphics.setColor(WHITE)
  love.graphics.setCanvas(stackCanvas)
  love.graphics.setScissor(0,0,360,idx * TILE_SIZE)
  love.graphics.clear()
    love.graphics.setScissor()

  love.graphics.draw(buffer, 0, oy)

  love.graphics.setCanvas()
end

function stackMapPrint()
  local str = ""
  for k,v in ipairs(stackMap) do
    for i,j in ipairs(v) do
      if j == 1 then
        str = str .. "#"
      elseif j == 2 then
        str = str .. "I"
      else
        str = str .. "."
      end
    end
    str = str .. "\n"
  end

  print(str)
end
