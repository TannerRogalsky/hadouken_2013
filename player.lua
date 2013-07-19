Player = class('Player', Base):include(Stateful)

function Player:initialize(world, color, layer)
  Base.initialize(self)

  self.color = color
  self.world = world
  self.layer = layer
  self.balls = {}
  self.towers = {}

  local _, grav_y = self.world:getGravity()
  self.up = grav_y > 0 and true or false
end

