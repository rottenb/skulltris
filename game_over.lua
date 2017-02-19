GameOver = {}

local y = 0

function GameOver.load()
  if MUSIC then
    hypno:stop()
  end
  deadFont = love.graphics.newFont("resources/font/skullphabet.ttf", 200)
  love.graphics.setFont(deadFont)

end

function GameOver.update(dt)
  if y <= love.graphics.getHeight()/2-100 then
    y = y + 20
  end
end

function GameOver.draw()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  love.graphics.setColor(PINK)
  love.graphics.printf("DEAD", 0, y, ww, 'center')


end

return GameOver
