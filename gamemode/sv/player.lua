
-- Initialize spawnpoint tables
local red_spawns    = {}
local blue_spawns   = {}
local dm_spawns     = {}
local st_spawns     = {}

function BuildSpawns()

        -- Locate RED TEAM Spawns
        red_spawns = ents.FindByClass("info_player_red")
        if #red_spawns < 1 then
            red_spawns = ents.FindByClass("info_player_terrorist")
        end
        
        -- Locate BLUE TEAM Spawns
        blue_spawns = ents.FindByClass("info_player_blue")
        if #blue_spawns < 1 then
            blue_spawns = ents.FindByClass("info_player_counterterrorist")
        end
        
        -- Locate FREE-FOR-ALL // BACKUP Spawns
        dm_spawns   = ents.FindByClass("info_player_deathmatch")
        
        -- Locate SPECTATOR // Emergency Spawns
        st_spawns   = ents.FindByClass("info_player_start")
end

-- Using this so we don't build spawn points every time a player tries to spawn/respawn
hook.Add("InitPostEntity", "BuildSpawns", BuildSpawns)
hook.Add("PostCleanupMap", "BuildSpawns", BuildSpawns)

function SetSpec(ply, obs)

	-- If obs is true (1) then set player as spectator
	if obs == 1 then
	
		-- Spectate functions
		GAMEMODE:PlayerSpawnAsSpectator(ply)
		ply:Spectate(6)
		ply:SpectateEntity(nil)
        ply:AllowFlashlight(false)
		
		-- Avoid problems of NPCs shooting spectators. Shouldn't be NPCs in this game mode but let's idiot-proof it.
		ply:SetNoTarget(true)
		
	-- If obs is false (0) then set them to unspec
	elseif obs == 0 then
		ply:UnSpectate()
		ply:SetNoTarget(false)
        ply:AllowFlashlight(true)
	end
    
end

function IsSpec(ply)
	
	-- team_enums[int] is explained in /shared.lua:2
	if ( ply:GetObserverMode() == 6 || team_enums[ply:Team()] ) then return true
	else return false
	end
	
end

function GM:PlayerShouldTakeDamage(ply, victim)
	if victim:IsPlayer() then
		if victim:Team() != 3 then
			if ply:Team() == victim:Team() and ply != victim then
				if !friendly_fire then return false end
			end
		end
	end
	return true
end

hook.Add("DoPlayerDeath", "CustomDeath", function(victim, attacker, dmginfo)
	
	victim:CreateRagdoll()
	
	-- Check for suicide
	if victim == attacker then
		print("[HUNTER] "..TimeStamp().." "..tostring(victim).." committed suicide.")
		victim:SetScore(victim:GetScore() + SCORE_SUICIDE)
	else
	
		-- Default = 0
		victim:SetScore(victim:GetScore() + SCORE_DEATH)
		if team_game and team_shares then
			team.SetScore(victim:Team(), team.GetScore(victim:Team()) + SCORE_DEATH)
		end
		
		if (attacker:IsValid() and attacker:IsPlayer()) then
			attacker:SetScore(attacker:GetScore() + SCORE_KILL)
			if team_game and team_shares then
				team.SetScore(attacker:Team(), team.GetScore(attacker:Team()) + SCORE_KILL)
			end
		end
		
	end
	
end)

function GM:PlayerDisconnected(ply)
	ply:SetPData("PlyModel", ply:GetModel())
    ply:SetPData("firsttimer", 0)
end

function GM:PlayerSpawn(ply)

    -- Tell new players the key commands    
    if ply:GetPData("firsttimer", 1) == 1 then
        net.Start("HUD_FirstTimer")
            net.Send(ply)
        ply:SetPData("firsttimer", 0)
    end
    
	-- If the player isn't a spectator, give loadout
	if !team_enums[ply:Team()] then
    
		SetSpec(ply, 0)
        ply:Give("weapon_stunstick")
        
        ply:AllowFlashlight(true)
        ply:SetNoCollideWithTeammates(true)
		
		local saved_model = ply:GetPData("PlyModel")
		if saved_model == nil or saved_model == "" or saved_model == "models/player.mdl" then
			ply:SetModel("models/player/kleiner.mdl")
		else
			ply:SetModel(saved_model)
		end
		
		if !ply:IsBot() then
			local saved_color = util.StringToType(ply:GetPData("PlyColor"), "Vector")
			if saved_color == nil or saved_color == "" or saved_color == Vector(0,0,0) then
				if ply:Team() == 1 then
					ply:SetPlayerColor(Vector(1,0,0))
				elseif ply:Team() == 2 then
					ply:SetPlayerColor(Vector(0,0,1))
				else
					ply:SetPlayerColor(Vector(1,1,1))
				end
			else
				ply:SetPlayerColor(saved_color) -- Errors
			end
			
			ply:SetPData("PlyModel", ply:GetModel())
			ply:SetPData("PlyColor", util.TypeToString(ply:GetPlayerColor()))
			ply:SetupHands()
            
        -- Give late joiners a prop list
        if round.status == 2 and ply.Inventory == nil then
            if team_game and use_differ_lists then
                if ply:Team() == 1 then
                    net.Start("SCAV_SendList")
                        net.WriteString(util.TableToJSON(round.round_rlist))
                        net.Send(ply)
                    ply.Inventory = {}
                    ply.ItemCount = 0
                    for _,model in pairs(round.round_rlist) do
                        ply.Inventory[model] = false
                    end
                else
                    net.Start("SCAV_SendList")
                        net.WriteString(util.TableToJSON(round.round_blist))
                        net.Send(ply)
                    ply.Inventory = {}
                    ply.ItemCount = 0
                    for _,model in pairs(round.round_blist) do
                        ply.Inventory[model] = false
                    end
                end
            else
                net.Start("SCAV_SendList")
                    net.WriteString(util.TableToJSON(round.round_list))
                    net.Send(ply)
                ply.Inventory = {}
                ply.ItemCount = 0
                for _,model in pairs(round.round_list) do
                    ply.Inventory[model] = false
                end
            end
        end

		end
	-- Otherwise strip their stuff and ensure set to spectator
	else
		ply:StripAmmo()
		ply:StripWeapons()
        ply:AllowFlashlight(false)
		SetSpec(ply, 1)
	end
	
end

function GM:AllowPlayerPickup(ply, ent)
	return true
end

function GM:PlayerInitialSpawn(ply)
	-- Set player as spectator
	SetSpec(ply, 1)
	
	-- Open team select menu
	ply:ConCommand("scav_helpmenu")
	
	-- Let player choose a team
	ply.CanChange = true
    
    ply:SetRunSpeed(200)
    
end

-- Don't play the flatline sound effect
function GM:PlayerDeathSound()
	return false
end

-- GM:PlayerSetHandsModel() Credit: http://wiki.garrysmod.org/
function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:PlayerSelectSpawn(ply)
    
	local spawn_error   = false -- Insufficient Spawns Found if TRUE
    local spawn_failure = false -- NO spawn points in this map if TRUE
	local spawns        = {}    -- Used to compile valid spawn points
    
    if team_game then
        
        -- RED TEAM SPAWNPOINTS
        if ply:Team() == 1 and #red_spawns > 0 then
            spawns       = red_spawns
        
        -- BLUE TEAM SPAWNPOINTS
        elseif ply:Team() == 2 and #blue_spawns > 0 then
            spawns       = blue_spawns
        
        -- TEAM GAME BUT NO TEAM SPAWNS AVAILABLE
        else
            if gm_warnings then
            MsgC(Color(255,180,180), "\n[HUNTER] ", Color(255,255,255), "------------------------GAMEMODE-NOTICE-------------------------------\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(000,200,200), "You have the server set to TEAM-BASED Scavenger Hunt. There are no team-based spawn points on this map.\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(000,200,200), "That's only a problem if you don't want people spawning mixed/random. If that's OK, ignore this notice.\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "MAPPERS: Team 1 Entities: info_player_red / info_player_terrorist\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "MAPPERS: Team 2 Entities: info_player_blue / info_player_counterterrorist\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "MAPPERS: Team Spectator : info_player_start\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(000,255,000), "To disable these notices, use scav_warnings 0\n")
            MsgC(Color(255,180,180), "[HUNTER] ", Color(255,255,255), "----------------------------------------------------------------------\n")
            end
            spawn_error = true
        
        end
    end
    
    -- SPECTATOR SPAWNPOINTS
	if team_enums[ply:Team()] then
        spawns = st_spawns
        if #spawns < 1 then
            spawn_error = true
        end
    end
    
    -- NOT A TEAM GAME, COMBINE ALL//TEAM GAME BUT NOT SPAWNS FOUND
    if !team_game or spawn_error then
		spawns = dm_spawns
        
        -- If there's still no spawns, then just use info_player_start's
		if #spawns < 1 then
			spawns = st_spawns
            if #spawns < 1 then
                MsgC(Color(255,180,180), "[HUNTER] ", Color(255,255,255), "------------------------GAMEMODE-WARNING-------------------------------\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(000,200,200), "!!SPAWN FAILURE!! NO spawn points in this map compatible with this gamemode.\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(000,200,200), "The map creator did not use any of the following valid spawnpoints:\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "+ info_player_deathmatch\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "+ info_player_start\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "+ info_player_red\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "+ info_player_blue\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "+ info_player_terrorist\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "+ info_player_counterterrorist\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(255,000,000), "This warning cannot be disabled\n")
                MsgC(Color(255,180,180), "[HUNTER] ", Color(255,255,255), "----------------------------------------------------------------------\n")
                spawn_failure = true
            end
		end
		
	end
    
    local index = math.random(1, #spawns)
    if spawn_failure then
        MsgC(Color(255,180,180), "[HUNTER] ", Color(180,180,000), "Spawn Failure. Spawning player at WORLDSPAWN (Vector(0, 0, 0))\n")
        return Vector(0, 0, 0)
    else
        return (spawns[index])
    end

end

net.Receive("CL_ChangeModel", function(len, ply)

	local newmodel  = net.ReadString()
	local color		= net.ReadVector()
	
	if ply_models[newmodel] then
	
		ply:SetModel(newmodel)
		ply:SetPData("PlyModel", newmodel)
		
		ply:SetPlayerColor(color)
		ply:SetPData("PlyColor", util.TypeToString(ply:GetPlayerColor()))
		
		ply:SetupHands()
	
	end

end)

net.Receive("SCAV_ChangeTeam", function(len, ply)

	local new_team = net.ReadInt(4)
	local cur_team = ply:Team()
	
	-- Used "4" to keep the ReadInt to 4 bits, change it to 1002 (TEAM_SPECTATOR)
	if new_team == 4 then new_team = 1002 end
	
	-- If the player is joining Spectators, let them
	if team_enums[new_team] then
	
		-- Make the player a spectator
		SetSpec(ply, 1)
		
		-- Make a note of the last team the player was on, to be used on/around line 147
		ply.LastTeam = cur_team
		
	-- Player is joining a gameplay team
	else
	
		-- If the player hasn't changed teams this round already
		if ply.CanChange then
	
			-- Get number of players on destination and current team
			local size_team_old = team.NumPlayers(cur_team)
			local size_team_new = team.NumPlayers(new_team)
			
			-- If the new team has less players, or they are a spectator let them change
			if team_enums[cur_team] or (size_team_new < size_team_old) then
			
				-- Since player changed teams, deny another change until next round
				-- /sv/controller.lua sets this back to TRUE on round.Prep()
				ply.CanChange = false
				ply.LastTeam = cur_team
				
				-- Used for balancing the teams
				ply.JoinTime = CurTime()
				
				-- If the player is alive and not a spectator, kill them
				if ply:Alive() and !IsSpec(ply) then
					ply:Kill()
				end
				
				-- Set the new team
				ply:SetTeam(new_team)
				
				-- Notify the player of the team change
				net.Start("RND_Message")
					net.WriteString("You have moved to "..team.GetName(new_team).."!")
					net.Send(ply)
				
				-- Respawn the player
				timer.Simple(1, function() ply:Spawn() end)
				
			-- Destination team would have more players if they switched
			else
				net.Start("SCAV_OpenSpare2")
					net.Send(ply)
			end
		
		-- If they're NOT joining spectator, and they're NOT allowed to switch teams
		else
		
			-- Returns spectating player to previous team
			if team_enums[ply:Team()] then
			
				-- Take them off spectator
				SetSpec(ply, 0)
				
				-- Send them back to their previous team
				ply:SetTeam(ply.LastTeam)
				timer.Simple(1, function() ply:Spawn() end)
					
			-- Not joining spectator, not allowed to switch, and is not already a spectator
			else
				net.Start("SCAV_OpenSpare2")
					net.Send(ply)
			end
		end
	end

end)