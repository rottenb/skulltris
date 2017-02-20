brickImgName = {"L", "Lf", "C", "T", "S", "Sf", "I"}

-- BOUNDING BOXES FOR PIECES --           -- VERTICES --
Boxes = {
  --#1 L
  {ox = 75, oy = 75, stacked = false,
    map = { {{0,0,0,0,0}, -- 0
             {0,0,1,0,0},
             {0,0,1,0,0},
             {0,0,1,1,0},
             {0,0,0,0,0}},

            {{0,0,0,0,0}, -- 90/-270
             {0,0,0,0,0},
             {0,1,1,1,0},
             {0,1,0,0,0},
             {0,0,0,0,0}},

            {{0,0,0,0,0}, -- 180/-180
             {0,1,1,0,0},
             {0,0,1,0,0},
             {0,0,1,0,0},
             {0,0,0,0,0}},

            {{0,0,0,0,0}, -- 270/-90
             {0,0,0,1,0},
             {0,1,1,1,0},
             {0,0,0,0,0},
             {0,0,0,0,0}} }
  },
  --#2 L flipped
  {ox = 75, oy = 75, stacked = false,
   map = { {{0,0,0,0,0}, -- 0
            {0,0,1,0,0},
            {0,0,1,0,0},
            {0,1,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 90/-270
            {0,1,0,0,0},
            {0,1,1,1,0},
            {0,0,0,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 180/-180
            {0,0,1,1,0},
            {0,0,1,0,0},
            {0,0,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 270/-90
            {0,0,0,0,0},
            {0,1,1,1,0},
            {0,0,0,1,0},
            {0,0,0,0,0}} }
 },
  --#3 Cube
  {ox = 60, oy = 90, stacked = false,
   map = { {{0,0,0,0,0}, -- 0
            {0,0,0,0,0},
            {0,1,1,0,0},
            {0,1,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 90/-270
            {0,0,0,0,0},
            {0,1,1,0,0},
            {0,1,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 180/-180
            {0,0,0,0,0},
            {0,1,1,0,0},
            {0,1,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 270/-90
            {0,0,0,0,0},
            {0,1,1,0,0},
            {0,1,1,0,0},
            {0,0,0,0,0}} }
 },
  --#4 T
  {ox = 75, oy = 75, stacked = false,
   map = { {{0,0,0,0,0}, -- 0
            {0,0,1,0,0},
            {0,1,1,1,0},
            {0,0,0,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 90/-270
            {0,0,1,0,0},
            {0,0,1,1,0},
            {0,0,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 180/-180
            {0,0,0,0,0},
            {0,1,1,1,0},
            {0,0,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 270/-90
            {0,0,1,0,0},
            {0,1,1,0,0},
            {0,0,1,0,0},
            {0,0,0,0,0}} }
 },
  --#5 S
  {ox = 75, oy = 75, stacked = false,
   map = { {{0,0,0,0,0}, -- 0
            {0,1,0,0,0},
            {0,1,1,0,0},
            {0,0,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 90/-270
            {0,0,1,1,0},
            {0,1,1,0,0},
            {0,0,0,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 180/-180
            {0,0,1,0,0},
            {0,0,1,1,0},
            {0,0,0,1,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 270/-90
            {0,0,0,0,0},
            {0,0,1,1,0},
            {0,1,1,0,0},
            {0,0,0,0,0}} }
 },
  --#6 S flipped
  {ox = 75, oy = 75, stacked = false,
   map = { {{0,0,0,0,0}, -- 0
            {0,0,0,1,0},
            {0,0,1,1,0},
            {0,0,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 90/-270
            {0,0,0,0,0},
            {0,1,1,0,0},
            {0,0,1,1,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 180/-180
            {0,0,1,0,0},
            {0,1,1,0,0},
            {0,1,0,0,0},
            {0,0,0,0,0}},
-- ????????????????????????????????
           {{0,0,0,0,0}, -- 270/-90
            {0,1,1,0,0},
            {0,0,1,1,0},
            {0,0,0,0,0},
            {0,0,0,0,0}} }
 },
  --#7 I
  {ox = 75, oy = 75, stacked = false,
   map = { {{0,0,1,0,0}, -- 0
            {0,0,1,0,0},
            {0,0,1,0,0},
            {0,0,1,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 90/-270
            {0,0,0,0,0},
            {0,1,1,1,1},
            {0,0,0,0,0},
            {0,0,0,0,0}},

           {{0,0,0,0,0}, -- 180/-180
            {0,0,1,0,0},
            {0,0,1,0,0},
            {0,0,1,0,0},
            {0,0,1,0,0}},

           {{0,0,0,0,0}, -- 270/-90
            {0,0,0,0,0},
            {1,1,1,1,0},
            {0,0,0,0,0},
            {0,0,0,0,0}} }
 },
}



local Brick = { }

function Brick.new(type)
  local w = love.graphics.getWidth()/2 - TILE_SIZE
  local path = "resources/tiles/"..brickImgName[type]..".png"

  local a = 0
  local n = math.random(1,5)
  if n == 1 then
   a = 90
  elseif n == 2 then
   a = 180
  elseif n == 3 then
   a = 270
  end

  return {img = love.graphics.newImage(path),
                 x = w,
                 y = 0,
                 ox = Boxes[type].ox,
                 oy = Boxes[type].oy,
                 r = a,
                 type = type,
                 map = Boxes[type].map }


end

function Brick.get()
  local x = (currentBrick.x-(love.graphics.getWidth()/2-180))/TILE_SIZE
  local y = (currentBrick.y/TILE_SIZE)
  local r = currentBrick.r

  local map = {}
  if r == 90 or r == -270 then
    map = Boxes[currentBrick.type].map[2]
  elseif r == 180 or r == -180 then
    map = Boxes[currentBrick.type].map[3]
  elseif r == 270 or r == -90 then
    map = Boxes[currentBrick.type].map[4]
  else -- 0/360
    map = Boxes[currentBrick.type].map[1]
  end

  return x, y, map
end

function Brick.copy(src)
  local dest = {}
  for k,v in pairs(src) do
    dest[k] = v
  end

  return dest
end

function Brick.draw()
  -- CURRENT BRICK --
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
  love.graphics.draw(stackCanvas, WW/2-180, 0)

  -- NEXT BLOCK --
  x, y, r, sx, sy = 700, 106, 0, 1, 1
  if SHADER then
    x = WW/2+292 + math.random(-1, 1)
    y = 106 + math.random(-1, 1)
    sx = math.random(0.9, 1.1)
    sy = math.random(0.9, 1.1)
    r = math.random(-2, 2)
  end

  love.graphics.setColor(GREY)
  love.graphics.draw(nextBrick.img, x, y, math.rad(r), sx, sy, nextBrick.ox, nextBrick.oy)

end

return Brick
