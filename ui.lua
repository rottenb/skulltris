UI = {}

function UI.draw()
    local bx = WW/2-180
    local by = 1
    local bw = BOARD_WIDTH * TILE_SIZE
    local bh = BOARD_HEIGHT * TILE_SIZE
    local ts = TILE_SIZE

    love.graphics.setColor(WHITE)
    love.graphics.setLineWidth(2)

    -- BACKGROUND --
    if SHADER then
      love.graphics.setShader(waveShader)
      local p = math.random(1,1.1)
      love.graphics.draw(backgroundImg, math.random(-1,1), math.random(-1,1), 0, 1.6*p, 1.6*p)
      love.graphics.setShader()
    else
      love.graphics.draw(backgroundImg, 0, 0, 0, 1.6, 1.6)
    end

    if LEVEL < 15 then
      love.graphics.setColor(DARK_GREY)
    elseif LEVEL >= 15 and LEVEL < 30 then
      love.graphics.setColor(DARK_RED)
    elseif LEVEL >= 30 and LEVEL < 45 then
      love.graphics.setColor(DARK_GREEN)
    elseif LEVEL >= 45 and LEVEL < 60 then
      love.graphics.setColor(DARK_PINK)
    elseif LEVEL >= 60 and LEVEL < 75 then
      love.graphics.setColor(DARK_BLUE)
    else
      love.graphics.setColor(DARK_YELLOW)
    end
    love.graphics.rectangle('fill', 0, 0, WW, WH)

    -- SCOREBOARD --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 10, 10, 200, 220, 5)
    love.graphics.setColor(RED)
    love.graphics.rectangle('line', 10, 10, 200, 220, 5)
    love.graphics.setFont(gameFont)
    love.graphics.printf("Score:", 20, 20, WW, 'left')
    local str = string.format("%010d", SCORE)
    love.graphics.printf(str, 23, 65, WW, 'left')
    love.graphics.printf("Level:", 60, 150, WW, 'left')
    str = string.format("%03d", LEVEL)
    love.graphics.printf(str, 80, 190, WW, 'left')

    -- TOGGLES --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 10, 240, 200, WH-250, 5)
    love.graphics.setColor(RED)
    love.graphics.rectangle('line', 10, 240, 200, WH - 250, 5)
    love.graphics.setFont(gameFont)

    love.graphics.printf("MUSIC:", 20, 250, WW, 'left')
    if MUSIC then
      love.graphics.printf("On", 130, 250, WW, 'left')
    else
      love.graphics.printf("Off", 130, 250, WW, 'left')
    end

    love.graphics.printf("EFFECTS:", 20, 300, WW, 'left')
    if SHADER then
      love.graphics.printf("On", 160, 300, WW, 'left')
    else
      love.graphics.printf("Off", 160, 300, WW, 'left')
    end

    love.graphics.printf("DEBUG:", 20, 350, WW, 'left')
    if DEBUG then
      love.graphics.printf("On", 130, 350, WW, 'left')
    else
      love.graphics.printf("Off", 130, 350, WW, 'left')
    end

    -- GAME BOARD --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', bx, by, bw, bh, 5)

    love.graphics.setColor(DARK_BLUE)
    for i = 1, 20 do -- vertical
      love.graphics.line(bx, ts * i, bx+bw, ts * i )
    end
    for i = 1, 12 do -- horizontal
      love.graphics.line((bx) + (ts * i), by, (bx) + (ts * i), bh)
    end

    -- BORDER AROUND NEXT BRICK --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 590, 10, 200, 200, 5)
    love.graphics.setColor(GREEN)
    love.graphics.rectangle('line', 590, 10, 200, 200, 5)

    if SHADER then
      love.graphics.setShader(waveShader)
    end

    brick.draw()

    if SHADER then
      love.graphics.setShader()
    end

    -- BOARD OUTLINE --
    love.graphics.setColor(BLUE)
    love.graphics.rectangle('line', bx, by+2, bw, bh-4, 5)

    love.graphics.setColor(100, 0, 0, 255)
    love.graphics.line(bx+2, TILE_SIZE, bx+358, TILE_SIZE)

    if SHADER then
      love.graphics.setShader()
    end

    -- INSTRUCTIONS --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 590, 220, 200, 370, 5)
    love.graphics.setColor(GREEN)
    love.graphics.rectangle('line', 590, 220, 200, 370, 5)
    love.graphics.setFont(keysFont)
    love.graphics.print("L/R Arrows: move", 600, 230)
    love.graphics.print("S/D: rotate", 600, 260)
    love.graphics.print("Space: drop", 600, 290)
    love.graphics.print("U: increase level", 600, 320)
    love.graphics.print("T: toggle debug", 600, 350)
    love.graphics.print("W: toggle SFX", 600, 380)
    love.graphics.print("M: toggle music", 600, 410)
    love.graphics.print("ESC: quit nonsense", 600, 440)

    -- DEBUG --
    if DEBUG then
      -- FPS counter
      love.graphics.setColor(RED)
      love.graphics.printf("FPS:", 20, 555, WW, 'left')
      love.graphics.printf(love.timer.getFPS(), 100, 555, WW, 'left')

      -- Brick outline and rotation center
      love.graphics.circle('fill', currentBrick.x+currentBrick.ox, currentBrick.y+currentBrick.oy, 3)
      love.graphics.rectangle('line', currentBrick.x,
                                      currentBrick.y,
                                      currentBrick.img:getWidth(), currentBrick.img:getHeight())

      -- Grid count (brick)
      love.graphics.setFont(gridFont)
      love.graphics.setColor(GREEN)
      love.graphics.print("1", currentBrick.x+15, currentBrick.y+10)
      for i = 2,5 do
        love.graphics.print(i, currentBrick.x+15, currentBrick.y+(30*(i-1))+10)
        love.graphics.print(i, currentBrick.x+(30*(i-1))+15, currentBrick.y+10)
      end

      -- Grid count (board)
      love.graphics.print("1", WW/2-165, 10)
      for i = 2,20 do
        love.graphics.print(i, WW/2-165, (30*(i-1))+10)
      end
      for i = 2,12 do
        love.graphics.print(i, (WW/2-168)+(30*(i-1)), 10)
      end

      love.graphics.setColor(WHITE)
    end


end

return UI
