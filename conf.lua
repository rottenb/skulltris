-- Window init
function love.conf(t)
  t.window.height = 600
  t.window.width = 800
  t.title = "skulltris"

  t.modules.audio    = true
	t.modules.event    = true
	t.modules.graphics = true
	t.modules.image    = true
	t.modules.joystick = true
	t.modules.keyboard = true
	t.modules.math     = true
	t.modules.mouse    = true
	t.modules.physics  = true
	t.modules.sound    = true
	t.modules.system   = true
	t.modules.timer    = true
	t.modules.window   = true
end
