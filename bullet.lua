Bullet = class('Bullet', Base)
Bullet.static.RADIUS = 2
Bullet.static.fixtures = {}

function Bullet:initialize(player, x, y, force_x, force_y)
  Base.initialize(self)

  self.player = player
  self.world = player.world
  self.layer = player.layer
  self.origin = {x = x, y = y}

  self:set_up_physics()
  self.body:applyForce(force_x, force_y)

  local texture = MOAIGfxQuad2D.new ()
  texture:setTexture ( 'images/towerSplash.png' )
  texture:setRect ( -2, -2, 2, 2 )

  local sprite = MOAIProp2D.new ()
  sprite:setDeck ( texture )
  sprite:setParent ( self.body )
  self.layer:insertProp ( sprite )
  self.sprite = sprite

  self.clean_up_timer = cron.after(3, self.destroy, self)
end

function Bullet:set_up_physics()
  local body = self.world:addBody(MOAIBox2DBody.DYNAMIC)
  body:setBullet(true)
  body:setTransform(self.origin.x, self.origin.y)
  local fixture = body:addCircle(0, 0, Bullet.RADIUS)
  fixture:setDensity(0.0001)
  fixture:setFilter(1, 1, -1)
  Bullet.fixtures[fixture] = self

  local function on_collide_with_ball( phase, fixtureA, fixtureB, arbiter )
    self:on_collide_with_ball(phase, fixtureA, fixtureB, arbiter)
  end

  fixture:setCollisionHandler ( on_collide_with_ball, MOAIBox2DArbiter.BEGIN, 2)

  body:resetMassData()
  self.fixture = fixture
  self.body = body
end

function Bullet:destroy()
  self.body:destroy()
  self.layer:removeProp(self.sprite)
  cron.cancel(self.clean_up_timer)
  Bullet.fixtures[self.fixture] = nil
end

function Bullet:on_collide_with_ball(phase, fixtureA, fixtureB, arbiter)
  -- print("collision", Bullet.fixtures[fixtureA], Ball.fixtures[fixtureB])
  local ball = Ball.fixtures[fixtureB]

  self:destroy()
  ball:destroy()

  beholder.trigger("ball_destroyed", ball)
end
