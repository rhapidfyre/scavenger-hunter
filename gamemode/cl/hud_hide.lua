
local hide = {
	CHudHealth 					= true, -- Default health display
	CHudAmmo 					= true, -- Default ammo count
	CHudBattery 				= true, -- Default armor display
	CHudDeathNotice 			= true, -- Death notices (top right)
	CHudPoisonDamageIndicator 	= true, -- Toxin Detection
	CHudSecondaryAmmo 			= true, -- Default secondary ammo display
	CHudSquadStatus 			= true, -- Civilians following you
	CHudGeiger 					= true	-- Radioactive Symbol/Screen Flash
}

hook.Add("HUDShouldDraw", "RemoveGeneric", function(name)
	if (hide[name]) then return false end
end)
