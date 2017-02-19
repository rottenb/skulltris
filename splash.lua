SplashScreen = {}

PLAY = 1
EXIT = 2
SELECTED = PLAY

local titleX = 0
local titleY = 0
local chimePlay = true

function SplashScreen.load()
  setKeyBindings()

  splashFont = love.graphics.newFont("resources/font/skullphabet.ttf", 120)
  selectFont = love.graphics.newFont("resources/font/skullphabet.ttf", 80)
  notSelectFont = love.graphics.newFont("resources/font/skullphabet.ttf", 50)
  splashImg = love.graphics.newImage("resources/wallpaper3.jpg")

  chime = love.audio.newSource("resources/sfx/smb3_coin.wav", 'static')
end

function SplashScreen.update()
  if titleY < 150 then
    titleY = titleY + 10
  end

  if titleY == 150 and chimePlay then
    chimePlay = false
    chime:play()
  end

end

function SplashScreen.draw()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  love.graphics.setColor(WHITE)
  love.graphics.draw(splashImg, 0, 0)

  love.graphics.setFont(splashFont)
  love.graphics.printf("SKULLTRIS", 0, titleY, ww, 'center')
  love.graphics.setShader()

  if titleY >= 150 then
    if SELECTED == PLAY then
      love.graphics.setColor(YELLOW)
      love.graphics.setFont(selectFont)
      love.graphics.printf("PLAY", 0, 300, ww, 'center')
      love.graphics.setFont(notSelectFont)
      love.graphics.setColor(ORANGE)
      love.graphics.printf("EXIT", 0, 400, ww, 'center')
    else
      love.graphics.setColor(ORANGE)
      love.graphics.setFont(notSelectFont)
      love.graphics.printf("PLAY", 0, 300, ww, 'center')
      love.graphics.setFont(selectFont)
      love.graphics.setColor(YELLOW)
      love.graphics.printf("EXIT", 0, 400, ww, 'center')
    end
  end
end

return SplashScreen
