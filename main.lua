local Vector = require("vector")

local line = {
  x1=0,y1=0,x2=0,y2=0
}

local circle = {
  x=0,y=0,r=3
}

function love.update(dt)
  local k = love.keyboard

  if k.isDown('w') then line.y1 = line.y1 - (dt * 20) end
  if k.isDown('s') then line.y1 = line.y1 + (dt * 20) end
  if k.isDown('a') then line.x1 = line.x1 - (dt * 20) end
  if k.isDown('d') then line.x1 = line.x1 + (dt * 20) end

  if k.isDown('up') then line.y2 = line.y2 - (dt * 20) end
  if k.isDown('down') then line.y2 = line.y2 + (dt * 20) end
  if k.isDown('left') then line.x2 = line.x2 - (dt * 20) end
  if k.isDown('right') then line.x2 = line.x2 + (dt * 20) end
end

function love.draw()
  local g = love.graphics
  g.scale(4,4)
  g.push()
  g.translate(100,100)

  g.circle('line', circle.x, circle.y, circle.r)
  g.line(line.x1, line.y1, line.x2, line.y2)

  love.graphics.pop()
  local err, toPrint = pcall(segmentCircleDist,
    Vector(line.x1, line.y1), 
    Vector(line.x2, line.y2), 
    Vector(circle.x, circle.y),
    circle.r)
  g.scale(.25,.25)
  g.print("Err: " .. tostring(err))
  g.translate(0,10)
  g.print("toPrint: " .. tostring(toPrint))
end

-- Lua port of: http://doswa.com/2009/07/13/circle-segment-intersectioncollision.html
-- Expects 3 2d vectors
function closestPointOnSeg(seg_a, seg_b, circle_pos)
  local seg_v = seg_b - seg_a
  local pt_v = circle_pos - seg_a
  if seg_v:len() <= 0 then
    return Vector(0,0)
  end
  local proj = pt_v * seg_v:unit()
  if proj <= 0 then 
    return seg_a:copy()
  elseif proj >= seg_v:len() then
    return seg_b:copy()
  end
  local proj_v = seg_v:unit():scalar_mul(proj)
  -- Return the closest point based on projection
  return proj_v + seg_a
end

function segmentCircleDist(seg_a, seg_b, circ_pos, circ_rad)
  local err, val = pcall(closestPointOnSeg, seg_a, seg_b, circ_pos)
  if not err then
    return val
  end
  local dist_v = circ_pos - val
  if dist_v:len() > circ_rad then
    return Vector(0, 0):len()
  elseif dist_v:len() <= 0 then
    return "Circles center is exactly on segment"
  end
  local offset = dist_v:unit():scalar_mul(circ_rad - dist_v:len()) 
  return offset:len()
end

