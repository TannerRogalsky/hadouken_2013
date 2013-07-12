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

  self.prop = MOAIProp2D.new()
  self.prop:setDeck(scriptDeck)
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
  local ball = Ball:new(self.world, x, y)
  ball.body:applyAngularImpulse(2000)
  self.player.balls[ball] = ball

  beholder.trigger("ball_spawned", ball)
end
