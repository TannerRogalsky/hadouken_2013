----------------------------------------------------------------
-- Copyright (c) 2010-2011 Zipline Games, Inc.
-- All Rights Reserved.
-- http://getmoai.com
----------------------------------------------------------------

local function printf ( ... )
  return io.stdout:write ( string.format ( ... ))
end

MOAISim.openWindow ( "test", 640, 480 )

viewport = MOAIViewport.new ()
viewport:setSize ( 640, 480 )
viewport:setScale ( 16, 0 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

function onCollide ( event )

  if event == MOAIBox2DArbiter.BEGIN then
    print ( 'begin!' )
  end

  if event == MOAIBox2DArbiter.END then
    print ( 'end!' )
  end

  if event == MOAIBox2DArbiter.PRE_SOLVE then
    print ( 'pre!' )
  end

  if event == MOAIBox2DArbiter.POST_SOLVE then
    print ( 'post!' )
  end
end

-- set up the world and start its simulation
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, -10 )
world:setUnitsToMeters ( 2 )
world:start ()
layer:setBox2DWorld ( world )

body = world:addBody ( MOAIBox2DBody.DYNAMIC )

poly = {
  0, -1,
  1, 0,
  0, 1,
  -1, 0,
}

-- fixture = body:addPolygon ( poly )
-- fixture = body:addRect(-1, -1, 1, 1)
fixture = body:addCircle(0, 0, 0.5)
fixture:setDensity ( 1 )
fixture:setFriction ( 0.3 )
fixture:setFilter ( 0 )
fixture:setRestitution( 0.5 )
fixture:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END )

body:resetMassData ()
body:applyAngularImpulse ( 2 )

for i=1,5 do
  body2 = world:addBody ( MOAIBox2DBody.STATIC )
  body2:setTransform(i * 2 - 5, -3)
  fixture2 = body2:addCircle(0, 0, 0.2)
  fixture2:setFilter ( 0x02 )
end

for i=1,5 do
  body2 = world:addBody ( MOAIBox2DBody.STATIC )
  body2:setTransform((i * 2 - 5) + 1, -5)
  fixture2 = body2:addCircle(0, 0, 0.2)
  fixture2:setFilter ( 0x02 )
end
-- body2 = world:addBody ( MOAIBox2DBody.STATIC )
-- body2:setTransform(0, -5)
-- fixture2 = body2:addRect ( -5, -1, 5, 1 )
-- fixture2 = body2:addCircle(0, 0, 0.2)
-- fixture2:setFilter ( 0x02 )
-- fixture2:setCollisionHandler ( onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x00 )

-- texture = MOAIGfxQuad2D.new ()
-- texture:setTexture ( 'moai.png' )
-- texture:setRect ( -1, -1, 1, 1 )

-- sprite = MOAIProp2D.new ()
-- sprite:setDeck ( texture )
-- sprite:setParent ( body )
-- layer:insertProp ( sprite )
