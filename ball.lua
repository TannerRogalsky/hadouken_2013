Ball = class('Ball', Base):include(Stateful)
Ball.static.RADIUS = 10
Ball.static.instances = {}
Ball.static.fixtures = {}

function Ball:initialize(player, x, y)
  Base.initialize(self)

  self.player = player
  self.world = player.world
  self.layer = player.layer
  self.origin = {x = x, y = y}

  self:set_up_physics()

  local texture = MOAIGfxQuad2D.new ()
  if self.player.up then
    texture:setTexture ( 'images/ballRed.png' )
  else
    texture:setTexture ( 'images/ballGreen.png' )
  end
  texture:setRect ( -10, -10, 10, 10 )

  local sprite = MOAIProp2D.new ()
  sprite:setDeck ( texture )
  sprite:setParent ( self.body )
  self.layer:insertProp ( sprite )
  self.sprite = sprite

  Ball.instances[self] = self
end

function Ball:set_up_physics()
  local body = self.world:addBody(MOAIBox2DBody.DYNAMIC)
  local fixture = body:addCircle(0, 0, Ball.RADIUS)
  body:setTransform(self.origin.x, self.origin.y)
  fixture:setDensity(0.01)
  fixture:setFriction(0.3)
  fixture:setRestitution(0.5)
  fixture:setFilter(3, 3)
  Ball.fixtures[fixture] = self

  body:resetMassData()
  self.fixture = fixture
  self.body = body
end

function Ball:destroy()
  Ball.instances[self] = nil
  Ball.fixtures[self.fixture] = nil
  game.up_player.balls[self] = nil
  game.down_player.balls[self] = nil
  self.layer:removeProp(self.sprite)
  self.body:destroy()
end
