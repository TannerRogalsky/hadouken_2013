SpawnZone = class('SpawnZone', Base)

SpawnZone:include(Clickable)

function SpawnZone:initialize(player, x, y)
  Base.initialize(self)

  self.player = player
  self.world = player.world
  self.x = x
  self.y = y
  self.width = 100
  self.height = 50

  local scriptDeck = MOAIScriptDeck.new()
  -- scriptDeck:setRect(-50, -25, 50, 25)
  scriptDeck:setRect(-self.width / 2, -self.height / 2, self.width / 2, self.height / 2)
  scriptDeck:setDrawCallback(function(index,xOff,yOff,xFlip,yFlip) self:render(index,xOff,yOff,xFlip,yFlip) end)

  local texture = MOAIGfxQuad2D.new ()
  if self.player.up then
    texture:setTexture ( 'images/launcherRed_flash.png' )
  else
    texture:setTexture ( 'images/launcherGreen_flash.png' )
  end
  texture:setRect (-self.width / 2, -self.height / 2, self.width / 2, self.height / 2)

  self.prop = MOAIProp2D.new()
  self.prop:setDeck(texture)
  self.prop:setLoc(self.x + self.width / 2, self.y + self.height / 2)
  local y_sign = self.player.up and 1 or -1
  self.prop:setScl(1, y_sign * 2.5)


  -- self.debug_prop = MOAIProp2D.new()
  -- self.debug_prop:setDeck(scriptDeck)
  -- self.player.layer:insertProp(self.debug_prop)
end

function SpawnZone:render(index, xOff, yOff, xFlip, yFlip)
  MOAIGfxDevice.setPenColor(unpack(self.player.color))
  MOAIDraw.drawRect(self.x, self.y, self.x + self.width, self.y + self.height)
end

function SpawnZone:contains(x, y)
  return (self.x < x and self.y < y and
          self.x + self.width > x and
          self.y + self.height > y)
end

function SpawnZone:clicked(x, y)
  local ball = Ball:new(self.player, x, y)
  local _, force_y = self.world:getGravity()
  ball.body:setLinearVelocity(0, force_y * 5)
  self.player.balls[ball] = ball
  sfxLaunch:play()
  beholder.trigger("ball_spawned", ball)
end
