local Gun = Tower:addState('Gun')

function Gun:enteredState()

  local other_player = game.up_player.towers[self] and game.up_player or game.down_player
  local player = game.down_player.towers[self] and game.up_player or game.down_player

  self.targets = other_player.balls

  self:shoot_at(self:get_target())

  beholder.observe("ball_destroyed", function(ball)
    if ball == self.target then
      self:clear_target()
      self:shoot_at(self:get_target())
    end
  end)

  beholder.observe("ball_spawned", function(ball)
    if self.target == nil and self.targets[ball] then
      self:shoot_at(ball)
    end
  end)
end

function Gun:shoot_at(target)
  assert(self.firing_cron_id == nil)
  if target then
    self.target = target
    self.firing_cron_id = cron.every(0.5, self.fire, self)
  end
end

-- should only really be used by cron
function Gun:fire()
  assert(self.target ~= nil)
  assert(instanceOf(Ball, self.target))
  local center_x, center_y = self.body:getWorldCenter()
  local tx, ty = self.target.body:getWorldCenter()

  local fx, fy = component_vectors(center_x, center_y, tx, ty)

  local speed = 20
  local bullet = Bullet:new(self.world, center_x, center_y, speed * fx, speed * fy)
end

function Gun:clear_target()
  self.target = nil
  cron.cancel(self.firing_cron_id)
  self.firing_cron_id = nil
end

function Gun:get_target()
  -- this seems to be a pretty common pattern. Maybe refactor?
  local _,closest = next(self.targets)
  local distances = {closest = math.huge}
  local x, y = self.body:getWorldCenter()

  for _,ball in pairs(self.targets) do

    local ball_x, ball_y = ball.body:getWorldCenter()
    local distance = math.sqrt(math.pow(ball_x - x, 2) + math.pow(ball_y - y, 2))
    distances[ball] = distance

    if distance < distances[closest] then
      closest = ball
    end
  end

  return closest
end

function Gun:exitedState()
end

return Gun
