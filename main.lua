DEBUG = false
MUSIC = true
SHADER = true

SPLASH = 1
GAME = 2
GAME_OVER = 3
ROTATE_BOARD = 4
GAME_STATE = SPLASH

TEST_BRICK = 0

SCORE = 0
LEVEL = 1
DROP_COUNT = 1
DROP_TIMER = 0

-- OFT-USED COLORS --
BLACK =         {  0,  0,  0, 255}
WHITE =         {255,255,255, 255}
LIGHT_GREY =    {180,180,180, 255}
GREY =          {180,180,180, 255}
DARK_GREY =     {  0,  0,  0, 150}
RED =           {255,  0,  0, 200}
DARK_RED =      {100,  0,  0, 100}
GREEN =         {  0,255,  0, 200}
DARK_GREEN =    {  0,100,  0, 100}
BLUE =          {  0,  0,255, 200}
DARK_BLUE =     {  0,  0,150, 100}
YELLOW =        {255,255,  0, 255}
DARK_YELLOW =   {100,100,  0, 100}
ORANGE =        {255,153,  0, 255}
DARK_ORANGE =   {180, 80,  0, 255}
PINK =          {255,  0,255, 255}

OUTLINE = {0,0,0,255}

-- INCLUDES --
lume = require "lume"
shader = require "shader"
brick = require "brick"
splashScreen = require "splash"
gameOver = require "game_over"
require "stack_map"
require "controls"

-- CONSTS --
BOARD_WIDTH = 12
BOARD_HEIGHT = 20
TILE_SIZE = 30
MAX_BRICKS = 7

function love.load()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  gameFont = love.graphics.newFont("resources/font/ledcounter7.ttf", 30)
  keysFont = love.graphics.newFont("resources/font/ledcounter7.ttf", 20)
  gridFont = love.graphics.newFont("resources/font/ledcounter7.ttf", 10)

  hypno = love.audio.newSource("resources/sfx/hypno.wav")
  hypno:setLooping(true)

  splashScreen.load()
  gameOver.load()

  waveShader = shader.new("waves", "rgb")
  waveTimer = 0.1

  love.keyboard.setKeyRepeat(true)

  backgroundImg = love.graphics.newImage("resources/wallpaper.jpg")

  stackCanvas = love.graphics.newCanvas(360,600)


  createMap()

  if TEST_BRICK > 0 then
    currentBrick = brick.new(TEST_BRICK)
    nextBrick = brick.new(TEST_BRICK)
  else
    math.randomseed(os.time())
    currentBrick = brick.new(math.random(1, MAX_BRICKS))
    nextBrick = brick.new(math.random(1, MAX_BRICKS))
  end

  local r = math.random(1,5)
  if r == 1 then
    currentBrick.r = 90
  elseif r == 2 then
    currentBrick.r = 180
  elseif r == 3 then
    currentBrick.r = 270
  else
    currentBrick.r = 0
  end
end -- love.load()


-- UPDATE ---
function love.update(dt)
  if GAME_STATE == SPLASH then
    splashScreen.update(dt)
  elseif GAME_STATE == GAME_OVER then
    gameOver.update(dt)
  elseif GAME_STATE == GAME then
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    -- update timers
    if SHADER then
      waveTimer = waveTimer + dt
      waveShader:send("waves_time", waveTimer)
    end

    if DROP_TIMER >= DROP_COUNT then
      DROP_TIMER = 0
      moveDown()
    else
      DROP_TIMER = DROP_TIMER + dt
    end

    SCORE = SCORE + 1
    LEVEL = SCORE / 2000

    if LEVEL % 5 == 0 then
      hypno:setPitch(1+LEVEL*0.01)
    end

    -- check for collision with brick stack ( and bottomBorder)
    if currentBrick.stacked then
      -- add brick image to the brick stack
      love.graphics.setColor(WHITE)
      stackCanvas:renderTo(function()
      love.graphics.draw(currentBrick.img,
                          currentBrick.x-(ww/2-180)+currentBrick.ox,
                          currentBrick.y+currentBrick.oy,
                          math.rad(currentBrick.r), 1, 1, currentBrick.ox, currentBrick.oy)
                        end)

      -- add brick to the internal map
      stackMapUpdate()

      -- look for full rows, remove if found
      stackRowScan()

      -- move on to the next brick
      currentBrick = brick.copy(nextBrick)
      currentBrick.stacked = false

      if TEST_BRICK > 0 then
        nextBrick = brick.new(TEST_BRICK)
      else
        local b = math.random(1, MAX_BRICKS)
        if b == currentBrick.type then
          b = math.random(1, MAX_BRICKS)
        end
        nextBrick = brick.new(b)
      end
    end
  end

end -- love.update()



-- DRAW --
function love.draw()
  if GAME_STATE == SPLASH then
    splashScreen.draw()
  elseif GAME_STATE == GAME_OVER then
    gameOver.draw()
  elseif GAME_STATE == GAME then
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local bx = ww/2-180
    local by = 1
    local bw = BOARD_WIDTH * TILE_SIZE
    local bh = BOARD_HEIGHT * TILE_SIZE
    local ts = TILE_SIZE

    love.graphics.setColor(WHITE)
    -- BACKGROUND --
    if SHADER then
      love.graphics.setShader(waveShader)
      local p = math.random(1,1.1)
      love.graphics.draw(backgroundImg, math.random(-1,1), math.random(-1,1), 0, 1.6*p, 1.6*p)
      love.graphics.setShader()
    else
      love.graphics.draw(backgroundImg, 0, 0, 0, 1.6, 1.6)
    end

    if LEVEL < 5 then
      love.graphics.setColor(DARK_GREY)
    elseif LEVEL >= 5 and LEVEL < 10 then
      love.graphics.setColor(DARK_RED)
    elseif LEVEL >= 10 and LEVEL < 15 then
      love.graphics.setColor(DARK_GREEN)
    elseif LEVEL >= 15 and LEVEL < 20 then
      love.graphics.setColor(DARK_BLUE)
    else
      love.graphics.setColor(DARK_YELLOW)
    end

    love.graphics.rectangle('fill', 0, 0, ww, wh)

    -- SCOREBOARD --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 10, 10, 200, 220, 5)
    love.graphics.setColor(RED)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle('line', 10, 10, 200, 220, 5)
    love.graphics.setLineWidth(1)
    love.graphics.setFont(gameFont)
    love.graphics.printf("Score:", 20, 20, ww, 'left')
    local str = string.format("%010d", SCORE)
    love.graphics.printf(str, 23, 65, ww, 'left')
    love.graphics.printf("Level:", 60, 150, ww, 'left')
    str = string.format("%03d", LEVEL)
    love.graphics.printf(str, 80, 190, ww, 'left')

    -- KEYS --
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 10, 240, 200, wh-250, 5)
    love.graphics.setLineWidth(2)
    love.graphics.setColor(RED)
    love.graphics.rectangle('line', 10, 240, 200, wh - 250, 5)
    love.graphics.setLineWidth(1)
    love.graphics.setFont(gameFont)

    love.graphics.printf("MUSIC:", 20, 250, ww, 'left')
    if MUSIC then
      love.graphics.printf("On", 130, 250, ww, 'left')
    else
      love.graphics.printf("Off", 130, 250, ww, 'left')
    end

    love.graphics.printf("EFFECTS:", 20, 300, ww, 'left')
    if SHADER then
      love.graphics.printf("On", 160, 300, ww, 'left')
    else
      love.graphics.printf("Off", 160, 300, ww, 'left')
    end

    love.graphics.printf("DEBUG:", 20, 350, ww, 'left')
    if DEBUG then
      love.graphics.printf("On", 130, 350, ww, 'left')
    else
      love.graphics.printf("Off", 130, 350, ww, 'left')
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

    if SHADER then
      love.graphics.setShader(waveShader)
    end

    -- BRICK --
    love.graphics.setColor(WHITE)
    local x = currentBrick.x+currentBrick.ox
    local y = currentBrick.y+currentBrick.oy
    local sx = 1
    local sy = 1
    local r = currentBrick.r

    love.graphics.draw(currentBrick.img, x, y, math.rad(r), sx,sy, currentBrick.ox, currentBrick.oy)

      -- BRICK STACK --
    love.graphics.setColor(LIGHT_GREY)
    r = math.random(-1,1)
    love.graphics.draw(stackCanvas, ww/2-180, 0)

    if SHADER then
      love.graphics.setShader()
    end

    -- BOARD OUTLINE --
    love.graphics.setColor(BLUE)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', bx, by+2, bw, bh-4, 5)

    love.graphics.setColor(100, 0, 0, 255)
    love.graphics.line(bx+2, TILE_SIZE, bx+358, TILE_SIZE)

    -- NEXT BLOCK --
    love.graphics.setColor(GREEN)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle('line', 590, 10, 200, 200, 5)
    love.graphics.setColor(DARK_GREY)
    love.graphics.rectangle('fill', 590, 10, 200, 200, 5)

    local x, y, r, sx, sy = 700, 106, 0, 1, 1
    if SHADER then
      love.graphics.setShader(waveShader)
      x = ww/2+292 + math.random(-1, 1)
      y = 106 + math.random(-1, 1)
      sx = math.random(0.9, 1.1)
      sy = math.random(0.9, 1.1)
      r = math.random(-2, 2)
    end

    love.graphics.setColor(GREY)
    love.graphics.draw(nextBrick.img, x, y, math.rad(r), sx, sy, nextBrick.ox, nextBrick.oy)

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
      love.graphics.printf("FPS:", 20, 555, ww, 'left')
      love.graphics.printf(love.timer.getFPS(), 100, 555, ww, 'left')

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
      love.graphics.print("1", ww/2-165, 10)
      for i = 2,20 do
        love.graphics.print(i, ww/2-165, (30*(i-1))+10)
      end
      for i = 2,12 do
        love.graphics.print(i, (ww/2-168)+(30*(i-1)), 10)
      end

      love.graphics.setColor(WHITE)
    end

  end
end -- love.draw()
