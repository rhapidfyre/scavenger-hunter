
-- Used to test spectator status without having to loop/repeat
team_enums = {
	[0] = true,		-- Team_Connecting/Joining
	[1001] = true,	-- Team_Unassigned
	[1002] = true	-- Team_Spectator
}

-- Include all shared Lua files
for _, v in pairs(file.Find("scavhunter/gamemode/sh/*.lua","LUA")) do include("sh/" .. v) end
for _, v in pairs(file.Find("scavhunter/gamemode/sh/powerups/*.lua","LUA")) do include("sh/powerups/" .. v) end

include("sh_vars.lua")

-- Credits
GM.Name 	= "Scavenger Hunter"
GM.Author	= "RhapidFyre"

function GM:OnEntityCreated(ent)
	if ent:IsPlayer() then
		ent:InstallDataTable()
		ent:NetworkVar("Int",0,"Credits")	-- Player's credit amount
		ent:NetworkVar("Int",1,"Score")		-- Individual Player Score
		ent:NetworkVar("Int",2,"Found")		-- Number of props found
		ent:NetworkVar("String",0,"PlyMdl")	-- Number of props found
	end
end
