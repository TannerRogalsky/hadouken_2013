Player = class('Player', Base):include(Stateful)

function Player:initialize(world, color)
  Base.initialize(self)

  self.color = color
  self.world = world
  self.balls = {}
  self.towers = {}
end

