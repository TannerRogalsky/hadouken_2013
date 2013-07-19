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

----------------------------------------------------------------
-- audio play code
----------------------------------------------------------------
-- initialize audio system
MOAIUntzSystem.initialize()
MOAIUntzSystem.setVolume(1)
volumeValue = MOAIUntzSystem.getVolume()

sfxPeg = MOAIUntzSound.new()
sfxPeg:load("sounds/peg.mp3")
sfxPeg:setVolume(1)
sfxPeg:setLooping(false)

sfxLaunch = MOAIUntzSound.new()
sfxLaunch:load("sounds/launch.mp3")
sfxLaunch:setVolume(1)
sfxLaunch:setLooping(false)

sfxBasket = MOAIUntzSound.new()
sfxBasket:load("sounds/basket.mp3")
sfxBasket:setVolume(1)
sfxBasket:setLooping(false)

sfxShoot = MOAIUntzSound.new()
sfxShoot:load("sounds/shoot.mp3")
sfxShoot:setVolume(1)
sfxShoot:setLooping(false)

sfxShot = MOAIUntzSound.new()
sfxShot:load("sounds/shot.mp3")
sfxShot:setVolume(1)
sfxShot:setLooping(false)

sfxPop = MOAIUntzSound.new()
sfxPop:load("sounds/pop.mp3")
sfxPop:setVolume(1)
sfxPop:setLooping(false)

sfxBuild = MOAIUntzSound.new()
sfxBuild:load("sounds/build.mp3")
sfxBuild:setVolume(1)
sfxBuild:setLooping(false)

music = MOAIUntzSound.new()
music:load("sounds/bgMusic.mp3")
music:setVolume(1)
music:setLooping(true)

game = Game:new()
music:play()

-- main simulation loop
local mainThread = MOAICoroutine.new ()
mainThread:run(function()

  while true do
    local dt = MOAISim.getStep()
    game:update(dt)
    coroutine.yield()
  end
end)
