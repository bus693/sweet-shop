m = {}
local get_supported_mods, is_mod_supported

-- List of mods that bus693 has tested
local known_mods_by_id = {
  ["Rebalatro"] = true,
  ["extracredit"] = true,
}

-- Returns list of the metadata of each enabled and supported mod
get_supported_mods = function()
  supported_mods = {}
  for mod_name, mod_props in pairs(SMODS.Mods) do
    if ((mod_name ~= "Bus693SweetShop") and
        (not mod_props.disabled) and
        is_mod_supported(mod_props)) then
      table.insert(supported_mods, mod_props)
    end
  end
  return supported_mods
end

is_mod_supported = function(mod_props)
  if known_mods_by_id[mod_props.id] then
    return true
  end
  if not mod_props.tags then
    return false
  end
  for i, tag in pairs(mod_props.tags) do
    if tag == "vanilla_balance" then
      return true
    end
  end
  return false
end

function m.add_label(hud)
  local supported_mods = get_supported_mods()

  if (#supported_mods == 0) then
    return hud
  end

  -- only show the one with the lowest priority
  -- todo: support more than 1
  local supported_mod = supported_mods[1]
  for i, mod in pairs(supported_mods) do
    if supported_mod.priority < mod.priority or
        (supported_mod.priority == mod.priority and supported_mod.id < mod.id) then
      supported_mod = mod
    end
  end

  local leaf_nodes = {{n=G.UIT.T, config={text = " "..supported_mod.name.." v"..supported_mod.version, scale = 0.85*0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}}}

  local newNodes = {
    {n=G.UIT.R, config={align = "cm",r=0.1, padding = 0.05, colour = G.C.DYN_UI.BOSS_MAIN, id = 'mod_icon_list'}, nodes={
      {n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 5}, nodes=leaf_nodes,
    },
  }}}
  for i = 1, #newNodes do
    table.insert(hud.nodes[1].nodes[1].nodes, newNodes[i])
  end
  return hud
end

return m