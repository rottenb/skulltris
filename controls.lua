

buttons = {
  [1] = "rotccw",
  [2] = "rotcw",
  [13] = "quitgame",
  [14] = "debug",
}

gamepad = {
  u = "moveup",
  d = "movedown",
  l = "moveleft",
  r = "moveright",
}

function InitJoystick()
  local jsList = love.joystick.getJoysticks()
  joystick = jsList[1]
end

function toggleDebug()
  if DEBUG then
    DEBUG = false
  else
    DEBUG = true
  end
end

function setKeyBindings()

  if GAME_STATE == SPLASH then
    bindings = {
      moveup = function() menuUp() end,
      movedown = function() menuDown() end,
      select = function() menuSelect() end,
    }

    keys = {
      up = "moveup",
      down = "movedown",
      ['return'] = "select",
    }
  else
    bindings = {
      quitgame = function() returnMenu() end,
      rotcw = function() rotateCW() end,
      rotccw = function() rotateCCW() end,
      moveleft = function() moveLeft() end,
      moveright = function() moveRight() end,
      moveup = function() moveUp() end,
      movedown = function() moveDown() end,
      drop = function() drop() end,
      debug = function() toggleDebug() end,
      music = function() toggleMusic() end,
      shader = function() toggleShadder() end,
      levelup = function() levelUp() end,
      dumpmap = function() stackMapPrint() end,
    }

    keys = {
      escape = "quitgame",
      up = "drop",
      down = "movedown",
      left = "moveleft",
      right = "moveright",
      d = "rotcw",
      s = "rotccw",
      space = "drop",
      t = "debug",
      m = "music",
      w = "shader",
      u = "levelup",
      k = "dumpmap",
    }
  end
end

function toggleMusic()
  if MUSIC then
    MUSIC = false
    hypno:stop()
  else
    MUSIC = true
    hypno:play()
  end
end

function toggleShadder()
  if SHADER then
    SHADER = false
  else
    SHADER = true
  end
end

function levelUp()
  LEVEL = LEVEL + 1
end

function inputHandler(input)
  local action = bindings[input]
  if action then return action() end
end

function love.keypressed(key, scancode, isrepeat)
  local binding = keys[key]
  return inputHandler(binding)
end

function love.keyreleased(key, scancode)
  local binding = keys["released"]
  return inputHandler(binding)
end

function love.joystickpressed(joystick, button)
  local binding = buttons[button]
  return inputHandler(binding)
end

function love.joystickreleased(joystick, button)
  local binding = buttons["released"]
  return inputHandler(binding)
end

function love.joystickhat(joystick, hat, dir)
  local binding = gamepad[dir]
  return inputHandler(binding)
end

function rotateCW()
  if not checkDirection("L") and
      not checkDirection("R") and
      not checkDirection("D") then
    if currentBrick.r == 270 then
      currentBrick.r = 0
    else
      currentBrick.r = currentBrick.r + 90
    end
  end
end

function rotateCCW()
  if not checkDirection("L") and
      not checkDirection("R") and
      not checkDirection("D") then
    if currentBrick.r == -270 then
      currentBrick.r = 0
    else
      currentBrick.r = currentBrick.r - 90
    end
  end
end

function moveLeft()
  if not checkDirection("L") then
    currentBrick.x = currentBrick.x - 30
  end
end

function moveRight()
  if not checkDirection("R") then
    currentBrick.x = currentBrick.x + 30
  end
end

function moveUp()
    currentBrick.y = currentBrick.y - 30
end

function moveDown()
  if checkDirection("D") then
    currentBrick.stacked = true
  else
    currentBrick.stacked = false
    currentBrick.y = currentBrick.y + 30
  end
end

function drop()
  while not currentBrick.stacked do
    moveDown()
  end
end

function checkDirection(dir)
  local x, y, map = brick.get()

  for k,v in ipairs(map) do
    for i,j in ipairs(v) do
      local b = 0
      if dir == "D" then
        b = stackMap[y+k+1][x+i+1]
      elseif dir == "R" then
        b = stackMap[y+k][x+i+2]
      elseif dir == "L" then
        b = stackMap[y+k][x+i]
      else
        b = 0
      end


      if j == BRICK and b >= 1 then
        return true
      end
    end
  end
  return false
end

function menuUp()
  if SELECTED == PLAY then
    SELECTED = EXIT
  else
    SELECTED = PLAY
  end
end

function menuDown()
  if SELECTED == PLAY then
    SELECTED = EXIT
  else
    SELECTED = PLAY
  end
end

function returnMenu()
  GAME_STATE = SPLASH
  if MUSIC then
    hypno:stop()
  end
  SELECTED = PLAY
  setKeyBindings()
end

function menuSelect()
  if SELECTED == EXIT then
    love.event.quit()
  else
    GAME_STATE = GAME
    if MUSIC then
      hypno:play()
    end
    setKeyBindings()
  end
end
