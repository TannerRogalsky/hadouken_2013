-- screen / window init
SCREEN_WIDTH, SCREEN_HEIGHT = MOAIEnvironment.screenWidth or 768, MOAIEnvironment.screenHeight or 1024
SCREEN_UNITS_X, SCREEN_UNITS_Y = 768, 1024
MOAISim.openWindow("Template", SCREEN_WIDTH, SCREEN_HEIGHT )


-- requirements
dofile("config.lua")

-- initialize things here
beholder.observe("key_down", "esc", function()
  os.exit()
end)
game = Game:new()


-- main simulation loop
local mainThread = MOAICoroutine.new ()
mainThread:run(function()
  while true do
    local dt = MOAISim.getStep()
    game:update(dt)
    coroutine.yield()
  end
end)
