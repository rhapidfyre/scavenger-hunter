
-- include root folder and first-order Lua files
include("sv_vars.lua")
include("shared.lua")
include("sh/utils.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

-- Load the rest of the Lua files, order not important
local LuaFiles = { ["lua"] = true, }
ProcDirTree("scavhunter/gamemode/sv", "LUA", include, LuaFiles)
ProcDirTree("scavhunter/gamemode/cl", "LUA", AddCSLuaFile, LuaFiles)
ProcDirTree("scavhunter/gamemode/sh", "LUA", AddCSLuaFile, LuaFiles)
ProcDirTree("scavhunter/gamemode/sh/powerups", "LUA", AddCSLuaFile, LuaFiles)

-- Before the gamemode loads, precache models and sounds
function GM:PreGamemodeLoaded()
	ProcDirTree("gamemodes/scavhunter/content", "GAME", util.PrecacheModel, { ["mdl"] = true, ["vmt"] = true, })
	ProcDirTree("gamemodes/scavhunter/content", "GAME", util.PrecacheSound, { ["wav"] = true, ["mp3"] = true, })
end
