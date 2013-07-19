local Main = Game:addState('Main')

function Main:enteredState()
  self.main_layer = MOAILayer2D.new()
  self.main_layer:setViewport(self.viewport)
  MOAIRenderMgr.pushRenderPass(self.main_layer)

  self.up_layer = MOAILayer2D.new()
  self.up_layer:setViewport(self.viewport)
  MOAIRenderMgr.pushRenderPass(self.up_layer)

  self.down_layer = MOAILayer2D.new()
  self.down_layer:setViewport(self.viewport)
  MOAIRenderMgr.pushRenderPass(self.down_layer)

  self:set_up_physics()
  self:set_up_bounds(self.up_world)
  self:set_up_bounds(self.down_world)

  self.up_player = Player:new(self.up_world, {1, 0, 0, 1}, self.up_layer)
  self.down_player = Player:new(self.down_world, {0, 0, 1, 1}, self.down_layer)

  self.fps_textbox = MOAITextBox.new()
  self.fps_textbox:setFont(self.font)
  self.fps_textbox:setTextSize(20)
  self.fps_textbox:setRect(-SCREEN_UNITS_X/2, -SCREEN_UNITS_Y/2, SCREEN_UNITS_X/2, SCREEN_UNITS_Y/2)
  self.fps_textbox:setYFlip(true)
  self.fps_textbox:setColor(0, 1, 0)
  self.up_layer:insertProp(self.fps_textbox)


  self.towers = {}
  local num_towers = 10
  local tower_offset = 75
  local function gen_all_towers(up, owner)
    local y_sign = up and 1 or -1
    for i=1,num_towers do
      local tower = Tower:new(owner, (i - 1 - num_towers / 2) * tower_offset + 20, (44 + tower_offset) * y_sign)
      self.towers[tower] = tower
      owner.towers[tower] = tower
    end
    for i=1,num_towers do
      local tower = Tower:new(owner, (i - 1 - num_towers / 2) * tower_offset + 20 + tower_offset / 2, (44 + tower_offset * 2) * y_sign)
      self.towers[tower] = tower
      owner.towers[tower] = tower
    end
    for i=1,num_towers do
      local tower = Tower:new(owner, (i - 1 - num_towers / 2) * tower_offset + 20, (44 + tower_offset * 3) * y_sign)
      self.towers[tower] = tower
      owner.towers[tower] = tower
    end
    for i=1,num_towers do
      local tower = Tower:new(owner, (i - 1 - num_towers / 2) * tower_offset + 20 + tower_offset / 2, (44 + tower_offset * 4) * y_sign)
      self.towers[tower] = tower
      owner.towers[tower] = tower
    end
    for i=1,num_towers do
      local tower = Tower:new(owner, (i - 1 - num_towers / 2) * tower_offset + 20, (44 + tower_offset * 5) * y_sign)
      self.towers[tower] = tower
      owner.towers[tower] = tower
    end
  end
  gen_all_towers(true, self.up_player)
  gen_all_towers(false, self.down_player)

  self.clickable_entities = {}
  for _,tower in pairs(self.towers) do
    self.clickable_entities[tower] = tower
  end

  for i=1,3 do
    local spawn_zone = SpawnZone:new(self.down_player, (i - 2) * 300 - 50, 25)
    self.main_layer:insertProp(spawn_zone.prop)
    self.clickable_entities[spawn_zone] = spawn_zone

    local spawn_zone = SpawnZone:new(self.up_player, (i - 2) * 300 - 50, -75)
    self.main_layer:insertProp(spawn_zone.prop)
    self.clickable_entities[spawn_zone] = spawn_zone
  end
end

function Main:set_up_physics()
  self.up_world = MOAIBox2DWorld.new()
  self.up_world:setGravity(0, 10)
  self.up_world:setUnitsToMeters(0.25)
  self.up_world:start()
  -- self.up_layer:setBox2DWorld(self.up_world)

  self.down_world = MOAIBox2DWorld.new()
  self.down_world:setGravity(0, -10)
  self.down_world:setUnitsToMeters(0.25)
  self.down_world:start()
  -- self.down_layer:setBox2DWorld(self.down_world)
end

function Main:set_up_bounds(world)
  local body = world:addBody(MOAIBox2DBody.STATIC)
  local w, h = 25, 25
  body:setTransform(-SCREEN_UNITS_X / 2 - w, -SCREEN_UNITS_Y / 2)
  local fixture = body:addRect(0, 0, w, SCREEN_UNITS_Y)

  body = world:addBody(MOAIBox2DBody.STATIC)
  body:setTransform(SCREEN_UNITS_X / 2, -SCREEN_UNITS_Y / 2)
  fixture = body:addRect(0, 0, w, SCREEN_UNITS_Y)

  body = world:addBody(MOAIBox2DBody.STATIC)
  body:setTransform(0, -SCREEN_UNITS_Y / 2)
  fixture = body:addRect(-SCREEN_UNITS_X / 2, -h, SCREEN_UNITS_X / 2, 0)

  body = world:addBody(MOAIBox2DBody.STATIC)
  body:setTransform(0, SCREEN_UNITS_Y / 2)
  fixture = body:addRect(-SCREEN_UNITS_X / 2, 0, SCREEN_UNITS_X / 2, h)
end

function Main:update(dt)
  self.fps_textbox:setString("FPS: " .. math.round(MOAISim.getPerformance()))
  cron.update(dt)
end

function Main:mouse_down(x, y, button)
  local world_x, world_y = self.main_layer:wndToWorld(x, y)

  for _,entity in pairs(self.clickable_entities) do
    if entity:contains(world_x, world_y) then
      entity:clicked(world_x, world_y)
    end
  end
end

function Main:mouse_up(x, y, button)
end

function Main:mouse_moved(x, y)
end

function Main:key_down(key, unicode)
end

function Main:key_up(key, unicode)
end

function Main:exitedState()
end

function Main:quit()
end

return Main
