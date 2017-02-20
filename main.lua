DEBUG = false
MUSIC = false
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
DARK_PINK =     {255,  0,255, 100}

OUTLINE = {0,0,0,255}

-- INCLUDES --
lume = require "lume"
shader = require "shader"
brick = require "brick"
splashScreen = require "splash"
gameOver = require "game_over"
ui = require "ui"
require "stack_map"
require "controls"

-- CONSTS --
BOARD_WIDTH = 12
BOARD_HEIGHT = 20
TILE_SIZE = 30
MAX_BRICKS = 7
WW = love.graphics.getWidth()
WH = love.graphics.getHeight()

function love.load()
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
      DROP_COUNT = DROP_COUNT - 0.20
    end

    -- check for collision with brick stack (and bottomBorder)
    if currentBrick.stacked then
      -- add brick image to the brick stack
      love.graphics.setColor(WHITE)
      stackCanvas:renderTo(function()
      love.graphics.draw(currentBrick.img,
                          currentBrick.x-(WW/2-180)+currentBrick.ox,
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
    UI.draw()
  end
end -- love.draw()
