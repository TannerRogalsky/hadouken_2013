Ball = class('Ball', Base):include(Stateful)
Ball.static.RADIUS = 10
Ball.static.instances = {}
Ball.static.fixtures = {}

function Ball:initialize(world, x, y)
  Base.initialize(self)

  self.world = world
  self.origin = {x = x, y = y}

  self:set_up_physics()

  Ball.instances[self] = self
end

function Ball:set_up_physics()
  local body = self.world:addBody(MOAIBox2DBody.DYNAMIC)
  local fixture = body:addCircle(self.origin.x, self.origin.y, Ball.RADIUS)
  fixture:setDensity(1)
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
  self.body:destroy()
end
