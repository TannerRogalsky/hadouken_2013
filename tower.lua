Tower = class('Tower', Base)

Tower:include(Stateful)
Tower:include(Clickable)

Tower.static.RADIUS = 10

function Tower:initialize(world, x, y)
  Base.initialize(self)

  self.world = world
  self.origin = {x = x, y = y}
  self.radius = Tower.RADIUS

  self:set_up_physics()
end

function Tower:set_up_physics()
  local body = self.world:addBody(MOAIBox2DBody.STATIC)
  body:setTransform(self.origin.x, self.origin.y)
  local fixture = body:addCircle(0, 0, self.radius)
  fixture:setFilter(1, 1, -1)

  self.body = body
end

function Tower:contains(x, y)
  return math.pow(x - self.origin.x, 2) + math.pow((y - self.origin.y), 2) < (self.radius * 3) ^ 2
end

function Tower:clicked()
  self:gotoState("Gun")
end
