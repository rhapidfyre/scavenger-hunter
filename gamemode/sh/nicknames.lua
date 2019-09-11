
--[[
	This file contains all the props in the game that the players will need to hunt.
	Custom map items will not show names unless the mapper included a Lua file with their map.
	The Lua file will need to do a table.insert for props_names in the following format:
	
	local map_prop = {"path/to/model.mdl" = "Name of Prop"}
	table.insert(prop_names, map_prop)

	This is only be necessary on scav_maps with custom prop models, or non-hl2/non-gmod props (CSS, Ep2)
	
]]
