m = {}
local create_overlay, get_enabled_mods, get_overlay_location, enabled_mods_lines, overlay_location
local is_overlay_on = false

function create_overlay(mods, location)
  love.graphics.push()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(enabled_mods_lines, location.x, location.y, 0, 0.75)
  love.graphics.pop()
end

-- Returns list of the metadata of every enabled mod
get_enabled_mods = function(smods_mods, top_keys)
  mods = {
    top = {},
    other = {}
  }
  for mod_id, mod_props in pairs(smods_mods) do
    if not mod_props.disabled then
      if mod_id == 'Balatro' or mod_id == 'Lovely' or mod_id == 'Steamodded' then
        table.insert(mods.top, mod_props)
      else
        table.insert(mods.other, mod_props)
      end
    end
  end
  table.sort(mods.top, function(a, b) return a.id < b.id end)
  table.sort(mods.other, function(a, b) return a.name < b.name end)
  return mods
end

get_enabled_mods_lines = function(enabled_mods)
  local eml = ""
  for i, mod in pairs(enabled_mods.top) do
    eml = eml..string.format("%s v%s\n", mod.id, mod.version)
  end
  eml = eml.."\n"
  for i, mod in pairs(enabled_mods.other) do
    eml = eml..string.format("%s v%s\n", mod.name, mod.version)
  end
  eml = eml.."\nPress [F12] to hide\n"
  return eml
end

get_overlay_location = function()
  width, height = love.graphics.getDimensions()

  return {x = width * 0.8, y = height * 0.33}
end


function m.init()
  local love_keypressed_ref = love.keypressed
  function love.keypressed(key, scancode, isrepeat)
    love_keypressed_ref(key, scancode, isrepeat)
    if key == 'f12' and not isrepeat then
      is_overlay_on = not is_overlay_on
    end
  end

  enabled_mods_lines = get_enabled_mods_lines(get_enabled_mods(SMODS.Mods)) 
  overlay_location = get_overlay_location()

  local game_draw_ref = Game.draw
  function Game:draw()
    game_draw_ref(self)
    if is_overlay_on then
      create_overlay(supported_mods_lines, overlay_location)
    end
  end  
end

return m