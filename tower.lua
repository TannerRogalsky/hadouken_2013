Tower = class('Tower', Base)

Tower:include(Stateful)
Tower:include(Clickable)

Tower.static.RADIUS = 10

function Tower:initialize(player, x, y)
  Base.initialize(self)

  self.player = player
  self.world = player.world
  self.layer = player.layer
  self.origin = {x = x, y = y}
  self.radius = Tower.RADIUS

  self:set_up_physics()

  local texture = MOAIGfxQuad2D.new ()
  texture:setTexture ( 'images/peg.png' )
  texture:setRect ( -12, -12, 12, 12 )

  local sprite = MOAIProp2D.new ()
  sprite:setDeck ( texture )
  sprite:setParent ( self.body )
  self.layer:insertProp ( sprite )
  self.sprite = sprite
end

function Tower:set_up_physics()
  local body = self.world:addBody(MOAIBox2DBody.STATIC)
  body:setTransform(self.origin.x, self.origin.y)
  local fixture = body:addCircle(0, 0, self.radius)
  fixture:setFilter(1, 1, -1)

  local function on_collide_with_ball( phase, fixtureA, fixtureB, arbiter )
   -- sfx: Tower & Ball Collision
    sfxPeg:play()
  end

  fixture:setCollisionHandler ( on_collide_with_ball, MOAIBox2DArbiter.BEGIN, 2)

  self.body = body
end

function Tower:contains(x, y)
  return math.pow(x - self.origin.x, 2) + math.pow((y - self.origin.y), 2) < (self.radius * 3) ^ 2
end

function Tower:clicked()
  sfxBuild:play()
  self:gotoState("Gun")
end
