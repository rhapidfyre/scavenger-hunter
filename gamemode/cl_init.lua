
-- Include client code
include("shared.lua")
ProcDirTree("scavhunter/gamemode/cl", "LUA", include, { ["lua"] = true, })
ProcDirTree("scavhunter/gamemode/cl", "LUA", AddCSLuaFile, { ["lua"] = true, })

function GM:PreGamemodeLoaded()
	-- Precache content
	ProcDirTree("gamemodes/scavhunter/content", "GAME", util.PrecacheModel, { ["mdl"] = true, ["vmt"] = true, })
	ProcDirTree("gamemodes/scavhunter/content", "GAME", util.PrecacheSound, { ["wav"] = true, ["mp3"] = true, })
end

scavenger_list 	= {}
inventory 		= {}
collected 		= 0
gm_color 		= Color(60, 200, 160)
gm_title 		= "HUNTER"
sounds 			= true
team_game       = 1

hook.Add("PostGamemodeLoaded", "LoadConVarsCL", function()
    team_game = GetConVar("scav_teamgame"):GetBool()

    gmSettings = {
        [1] = {
            ["name"] = "Unique List per Team",
            ["value"] = GetConVar("scav_difflists"):GetBool(),
            },
        [2] = {
            ["name"] = "Friendly Fire",
            ["value"] = GetConVar("scav_friendlyfire"):GetBool(),
            },
        [3] = {
            ["name"] = "Using Auto-Balance",
            ["value"] = GetConVar("scav_teambalance"):GetBool(),
            },
        [4] = {
            ["name"] = "Team Gets Player Points",
            ["value"] = GetConVar("scav_teamshares"):GetBool(),
            },
        [5] = {
            ["name"] = "Max Time per Map (Minutes)",
            ["value"] = GetConVar("scav_maxtime"):GetInt(),
            },
        [6] = {
            ["name"] = "Max Rounds per Map",
            ["value"] = GetConVar("scav_maxrounds"):GetInt(),
            },
        [7] = {
            ["name"] = "Number of Props to Find",
            ["value"] = GetConVar("scav_findcount"):GetInt(),
            },
        [8] = {
            ["name"] = "Seconds Per Round",
            ["value"] = GetConVar("scav_roundtime"):GetInt(),
            },
        [9] = {
            ["name"] = "Credit Interval",
            ["value"] = GetConVar("scav_paytimer"):GetInt(),
            },
        [10] = {
            ["name"] = "Credit Payment per Interval",
            ["value"] = GetConVar("scav_payalive"):GetInt(),
            }
        }
        
    gmValues = {
        [1] = {
            ["name"] = "Team Points: Win Round",
            ["value"] = GetConVar("scav_scorewin"):GetInt(),
            },
        [2] = {
            ["name"] = "Player Points: Found Prop",
            ["value"] = GetConVar("scav_scorecollect"):GetInt(),
            },
        [3] = {
            ["name"] = "Player Points: Win Round",
            ["value"] = GetConVar("scav_scoreteam"):GetInt(),
            },
        [4] = {
            ["name"] = "Player Points: Lose Round",
            ["value"] = GetConVar("scav_scorelose"):GetInt(),
            },
        [5] = {
            ["name"] = "Player Points: Kill Player",
            ["value"] = GetConVar("scav_scorekill"):GetInt(),
            },
        [6] = {
            ["name"] = "Player Points: Died",
            ["value"] = GetConVar("scav_scoredeath"):GetInt(),
            },
        [7] = {
            ["name"] = "Player Points: Suicide",
            ["value"] = GetConVar("scav_scoresuicide"):GetInt(),
            },
        [8] = {
            ["name"] = "Player Credits: Win Round",
            ["value"] = GetConVar("scav_paywin"):GetInt(),
            },
        [9] = {
            ["name"] = "Team Credits: Win Round",
            ["value"] = GetConVar("scav_payteam"):GetInt(),
            },
        [10] = {
            ["name"] = "Player Credits: Lose Round",
            ["value"] = GetConVar("scav_paylose"):GetInt(),
            },
        [11] = {
            ["name"] = "Maximum Credits At Once",
            ["value"] = GetConVar("scav_paymax"):GetInt(),
            }
        }
end)

-- Round Controller
clock 			= 0
status 			= 0

net.Receive("SCAV_SendList", function()

	scavenger_list = util.JSONToTable(net.ReadString())
	
	-- Sets up the items that the player has
	inventory = {}
	for _,v in pairs(scavenger_list) do
		inventory[v] = false
	end
	
end)

net.Receive("SCAV_ClearInv", function()
	scavenger_list = {}
	inventory = {}
	collected = 0
end)


net.Receive("RND_Clock", function()
	clock 	= net.ReadInt(16)
	status 	= net.ReadInt(4)
    VOXRemaining()
end)
