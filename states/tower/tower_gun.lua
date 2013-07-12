local Gun = Tower:addState('Gun')

function Gun:enteredState()
  print(self .. " became a gun")

  local other_player = game.up_player.towers[self] and game.up_player or game.down_player
  local player = game.down_player.towers[self] and game.up_player or game.down_player

  local _, target = next(other_player.balls)
  if target then
    self:shoot_at(target)
  end

  beholder.observe("ball_destroyed", function(ball)
    if ball == self.target then
      print(ball)
      self:clear_target()
      local _, target = next(other_player.balls)
      print(target)
      if target then
        self:shoot_at(target)
      end
    end
  end)

  beholder.observe("ball_spawned", function(ball)
    if self.target == nil then
      self:shoot_at(ball)
    end
  end)
end

function Gun:shoot_at(target)
  assert(self.firing_cron_id == nil)
  self.target = target
  -- print(target)
  -- Gun.targets[self.target.id] = self.target
  self.firing_cron_id = cron.every(0.5, self.fire, self)
end

-- should only really be used by cron
function Gun:fire()
  assert(self.target ~= nil)
  assert(instanceOf(Ball, self.target))
  -- print("fire")
  local center_x, center_y = self.body:getWorldCenter()
  local tx, ty = self.target.body:getWorldCenter()

  local fx, fy = component_vectors(center_x, center_y, tx, ty)

  local speed = 20
  local firing_angle = math.rad(0)
  local bullet = Bullet:new(self.world, center_x, center_y, speed * fx, speed * fy)

end

function Gun:clear_target()
  -- Gun.targets[self.target.id] = nil
  print("clear")
  self.target = nil
  cron.cancel(self.firing_cron_id)
  self.firing_cron_id = nil
end

function Gun:exitedState()
end

return Gun
