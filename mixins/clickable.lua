local Clickable = {}

function Clickable:included(klass)
end

-- override this
function Clickable:contains(x, y)
  return false
  -- return math.pow(x - self.x, 2) + math.pow((y - self.y), 2) < self.radius ^ 2
end

function Clickable:clicked(x, y)
  print("clicked " .. self)
end

return Clickable
