
local prop_count 	= 0
round 		        = {}

-- Variables;	ENUMS can be found in "sv_vars.lua" in the gamemode main folder
round.time_break	= TIME_BREAK	-- Time between rounds, in seconds
round.time_left		= -1			-- -1 defines first round
round.time_prep		= TIME_PREP		-- Time until round starts, in seconds
round.round_time	= TIME_SCAV		-- Time per round, in seconds
round.round_count	= 0				-- Current round number
round.round_max		= MAX_ROUNDS	-- Maximum rounds per map
round.round_list	= {}			-- The items required to win (Free-for-All)
round.round_blist	= {}			-- The items required to win (Blue Team)
round.round_rlist	= {}			-- The items required to win (Red  Team)
round.breaking		= false			-- Used to immediately go stale/stop the round
round.status		= 0				-- 0=stale 1=preparing 2=active 3=intermission

props_map			= {}			-- An array of prop models on map


-- Detect all map props and place it into "props_map" variable. Required to run for gamemode to work.
-- This function is only called once automatically, at map start
local function DoSetup()

	print("[DEBUG] Retrieving map's available prop_physics_multiplayer")
	
	-- Add all prop_physics_multiplayer
	for _,prop in pairs(ents.FindByClass("prop_physics_multiplayer")) do
	
		local model = prop:GetModel()
        model = string.Replace(model, "./", "")
		
		
		-- Ensure that the same prop model isn't put into the table twice
		if !table.HasValue(props_map, model) then
		
			-- Fill the table with props
			table.insert(props_map, model)
			prop_count = prop_count + 1
			
			print("[DEBUG] Inserted prop. Prop count: "..tostring(prop_count))
		end
	end
    
	-- Add all prop_physics
	for _,prop in pairs(ents.FindByClass("prop_physics")) do
	
		local model = prop:GetModel()
        model = string.Replace(model, "./", "")
		
		-- Ensure that the same prop model isn't put into the table twice
		if !table.HasValue(props_map, model) then
		
			-- Fill the table with props
			table.insert(props_map, model)
			prop_count = prop_count + 1
			
			print("[DEBUG] Inserted prop. Prop count: "..tostring(prop_count))
		end
	end
	print(prop_count)
	-- Making sure that if the amount of props available is not more than the map has to offer
	if (SCAV_MAX > prop_count or SCAV_MAX < 1) then
		SCAV_MAX = prop_count
		
		print("[DEBUG] Scavenger List Maximum was invalid! Setting to amount of (unique) props found within the map.")
		
	end
	
end

-- Run DoSetup() once all entities have been loaded
function GM:InitPostEntity()
	print("[DEBUG] Entity Load complete. Building map's available prop list...")
	DoSetup()
end

-- Fisher-Yates Shuffle to ensure props are randomized each round
-- Credit: https://stackoverflow.com/questions/35572435/how-do-you-do-the-fisher-yates-shuffle-in-lua
local function Shuffle()

	local tFinal = {}
	for i = #props_map, 1, -1 do
		local j = math.random(1, i)
		props_map[i], props_map[j] = props_map[j], props_map[i]
		table.insert(tFinal, props_map[i])
	end
	
	table.Empty(props_map)
	props_map = tFinal
	
end

-- Simple bool return
local function PlayersWaiting()

	-- Assume no players are waiting to play
	local waiting = false
	for _,ply in pairs(player.GetAll()) do
	
		-- team_enums[value] is defined in /shared.lua:3
		if !team_enums[ply:Team()] then
		
			-- Returns true if any players are on playable teams
			waiting = true
		end
	end
	return waiting
end

-- This function builds our round's scavenger hunt list
function round.CreateList()
	
	-- Ensure the SCAV_MAX is never more than the number of available props in this map. It shouldn't be due to DoSetup()
	if (SCAV_MAX > prop_count or SCAV_MAX < 1) then
		SCAV_MAX = prop_count
	end
	
	if (team_game and use_differ_lists) then
	
		-- Use the current shuffled list to build Blue Team's scavenger hunt list
		for i = 1, SCAV_MAX, 1 do
			table.insert(round.round_blist, props_map[i])
		end
		
		-- Reshuffle so red team gets different items
		Shuffle()
		
		-- Use the new shuffle to build Red's list
		for i = 1, SCAV_MAX, 1 do
			table.insert(round.round_rlist, props_map[i])
		end
	
	else
	
		-- Fill the scavenger list using the shuffled prop list
		-- This is used if Red VS Blue have the same lists or if it's a free-for-all game
		for i = 1, SCAV_MAX, 1 do
			table.insert(round.round_list, props_map[i])
		end
		
	end
	
	-- Create a player "inventory", which is a key->boolean set for checking if they have all the items
	print("[DEBUG] Scavenger List Finished. Falsifying player's collection inventory...")
	for _,ply in pairs(player.GetAll()) do		
		
		-- If it's Red VS Blue, and they have their own lists, send them appropriately
		if team_game and use_differ_lists then
		
			-- Team 1 = Red Team... Send them round_rlist
			if ply:Team() == 1 then
			
				-- Falsify the player's inventory (for checking winners)
				for _,model in pairs(round.round_rlist) do
					ply.Inventory[model] = false
				end
				
				-- Changing table to string to use less bits when sending the scavenger list
				-- The client will change this back into a table for their own use
				net.Start("SCAV_SendList")
					net.WriteString(util.TableToJSON(round.round_rlist))
					net.Send(ply)
					
			-- Likewise for Blue Team, but round_blist
			elseif ply:Team() == 2 then
			
				for _,model in pairs(round.round_blist) do
					ply.Inventory[model] = false
				end
				
				net.Start("SCAV_SendList")
					net.WriteString(util.TableToJSON(round.round_blist))
					net.Send(ply)
			end
			
		-- Otherwise, Red VS Blue has the same lists or it's a free-for-all game
		else
		
			for _,model in pairs(round.round_list) do
				ply.Inventory[model] = false
			end
			
			net.Start("SCAV_SendList")
				net.WriteString(util.TableToJSON(round.round_list))
				net.Send(ply)
		end
	end
	
end

-- Anytime a round-related message is written, send it here for proper client formatting
function round.Broadcast(message)
	net.Start("RND_Message")
		net.WriteString(message)
		net.Broadcast()
		
	-- Adding a hook for server developers
	hook.Call("RoundBroadcast")
end

-- Called when break time is up and a new round is beginning
function round.Prep()

	game.CleanUpMap()

	-- Reset remaining time and change status to preparing
	round.time_left = round.time_prep
	round.status = 1
	
	-- Conduct shuffle
	Shuffle()

	-- If no players are waiting, go stale.
	if not PlayersWaiting() then round.status = 0 end

	-- (re)Spawn players
	for _,ply in pairs(player.GetAll()) do
		if !team_enums[ply:Team()] then
			ply:StripWeapons()
			ply:StripAmmo()
			ply:Spawn()
            ply:GodEnable()
            timer.Create("God"..tostring(ply:UniqueID()), (round.time_prep + 10), 1, function()
                ply:GodDisable()
            end)
		end
	end
	
	-- Reset Values for new game
	table.Empty(round.round_list)
	table.Empty(round.round_rlist)
	table.Empty(round.round_blist)
	for _,ply in pairs(player.GetAll()) do
		ply.Inventory = {}
		ply.ItemCount = 0
		net.Start("SCAV_ClearInv")
			net.Send(ply)
		ply.CanChange = true		-- Allows players to switch team again
	end

	-- Send client notification
	round.Broadcast("A new round is about to begin...")
	hook.Call("RoundPrepare")
    
	
end

-- Called when preparation ends and the game starts
function round.Begin()

	-- Reset time to round_time and set status to active
	round.time_left 	= round.round_time
	round.status		= 2
	
	-- Increase the round_count
	round.round_count 	= round.round_count + 1
	
	-- Spawn dead players / late joiners
	for _,ply in pairs(player.GetAll()) do
		if ((ply:Team() > 0 and ply:Team() < 4) and !(ply:Alive())) then
			-- Make sure Credits is not higher than the amount they're allowed to have
			if ply:GetCredits() > CREDIT_CAP then ply:SetCredits(CREDIT_CAP) end
			ply:Spawn()
		end
	end
	
	-- If no players are waiting/playing, go stale. Otherwise, make our scavenger list!
	if not PlayersWaiting() then round.status = 0 end
	
	-- Create and dispatch shopping list
	round.CreateList()

	-- Send client notification
	round.Broadcast("Round ("..(round.round_count).." of "..(round.round_max)..") has started!")
	hook.Call("RoundBegin")
	
end

-- Called when time runs out or a player wins
function round.End(winner)

	-- If players are waiting, set status to intermission and reset timeleft
	if PlayersWaiting() then
		round.time_left = round.time_break
		round.status = 3
		
	-- If players are not waiting, set the gamemode to go stale
	else
		print("[HUNTER] "..TimeStamp().." No players currently assigned to team(s). Going stale...")
		round.time_left = -1
		round.status = 0
		round.Stale()
		
		-- Send clock and status to clients
		SetGlobalInt("RoundTimeLeft", round.time_left)
		SetGlobalInt("RoundStatus", round.status)
		net.Start("RND_Clock")
			net.WriteInt(round.time_left, 16)
			net.WriteInt(round.status, 4)
			net.Broadcast()	
			
	end
	
	-- FLAG (boolean variable) sets TRUE if there was a winner
	local win_team = nil
	local flag = false
	if winner != nil then
		win_team = winner:Team()
		flag = true
		
		if team_game then
			round.Broadcast(team.GetName(winner:Team()).." won!")
		end
		
		-- HUD_Message: first WriteString is the message to display - second WriteString is the title of the alert
		-- You can find "HUD_Message" in /cl/notify.lua
		net.Start("HUD_Message")
			net.WriteString("Prepare for round "..tostring(round.round_count + 1)..".")
			net.WriteString("++ WINNER: "..winner:Name().." ++ ")
			net.Broadcast()
	else
		round.Broadcast("Time has run out, the round was terminated!")
		net.Start("HUD_Message")
			net.WriteString("Time's up! Prepare for round "..tostring(round.round_count + 1)..".")
			net.WriteString("ROUND COMPLETE!")
			net.Broadcast()
	end
	
	-- Award points (if flag is false then time ran out; No winner)
	for _,ply in pairs(player.GetAll()) do
		if flag then
		
			-- All these ENUM values can be found in /sv_vars.lua
		
			-- If the winner is the player found in the table this iteration, give them the winning bonus
			if winner == ply then
				ply:SetCredits(ply:GetCredits() + PAYMENT_WIN)
				ply:SetScore(ply:GetScore() + SCORE_WIN)
			else
				-- If it's Red VS Blue, disperse winner/loser bonuses
				if team_game then
				
					-- Give winning team bonus
					if winner:Team() == ply:Team() then
						ply:SetCredits(ply:GetCredits() + PAYMENT_TEAM)
						ply:SetScore(ply:GetScore() + SCORE_WIN)
						
					-- Give good sport bonus
					else
						ply:SetCredits(ply:GetCredits() + PAYMENT_LOSE)
						ply:SetScore(ply:GetScore() + SCORE_LOSE)
					end
				end
			end
			
		-- If there was no winner (time ran out), everyone loses! Give a good sport bonus
		else
			ply:SetCredits(ply:GetCredits() + PAYMENT_LOSE)
			ply:SetScore(ply:GetScore() + SCORE_LOSE)
		end
		
		-- Ensure player sdon't get more credits than the server's maximum
		if ply:GetCredits() > CREDIT_CAP then ply:SetCredits(CREDIT_CAP) end
		
	end
	
	-- Award team points
	if team_game and flag then
		team.SetScore(win_team, team.GetScore(win_team) + SCORE_TEAMWIN)
	end
	
	hook.Call("RoundEnd")
	
end

-- Called when there are less than two players
function round.Stale()

	if PlayersWaiting() then
	
		-- Log the time the gamemode reactivated and set the status/timeleft appropriately to restart the gamemode
		print("[HUNTER] "..os.date("%d/%m/%Y @ %H:%M:%S", os.time()).." Player(s) waiting to play. Reactivating!")
		
		-- Get rid of the stale timer and reinstate the round controller
		timer.Remove("Stale")
		timer.Create("Controller", 1, 0, round.Control)
        
        round.Prep()
		
	else
		-- If nobody is waiting, remove the round controller and check every second until players are ready to play
		timer.Remove("Controller")
		timer.Create("Stale", 1, 0, round.Stale)
		
	end
	
	hook.Call("RoundStale")
end

-- Handles logical operations of the round
function round.Control()

	-- Send clock and status to clients
	SetGlobalInt("RoundTimeLeft", round.time_left)
	SetGlobalInt("RoundStatus", round.status)
	net.Start("RND_Clock")
		net.WriteInt(round.time_left, 16)
		net.WriteInt(round.status, 4)
		net.Broadcast()
		
	-- Stale (Prep and Begin set round.Stats == 0 if no players are on any teams)
	if round.status == 0 then
		print("[HUNTER] "..TimeStamp().." No players currently assigned to team(s). Going stale...")
		round.Stale()
		round.time_left = -1
	end
	
	-- If there is no more time remaining, make a status change
	if round.time_left <= 0 then
	
		-- Preparing
		if round.status == 1 then
			print("[HUNTER] "..TimeStamp().." Round #"..tostring(round.round_count + 1).."/"..tostring(round.round_max).." is starting...")
			round.Begin()
			
		-- Active
		elseif round.status == 2 then
			print("[HUNTER] "..TimeStamp().." Round #"..tostring(round.round_count).."/"..tostring(round.round_max).." has concluded!")
			round.End(nil)
		
		-- Intermission
		elseif round.status == 3 then
			print("[HUNTER] "..TimeStamp().." Intermission has finished. Beginning round #"..tostring(round.round_count + 1))
			round.Prep()
			
		end
		
	end
	
	-- If round is active and the payment timer hits its iteration
	if round.status == 2 and (round.time_left % TIMER_PAY == 0) then
		for _,ply in pairs(player.GetAll()) do
		
			-- If the player isn't capped on money
			if (ply:GetCredits() <= CREDIT_CAP + PAYMENT_ALIVE) then
			
				-- If the player is on a playable team and alive
				if !team_enums[ply:Team()] and ply:Alive() then
				
					-- Award bonus for being alive
					ply:SetCredits(ply:GetCredits() + PAYMENT_ALIVE)
					
				end
			end
		end
	end
	
	-- Decrease time_left by 1
	round.time_left = (round.time_left - 1)
	hook.Call("RoundController")

end

local function DoGMPickup(ply, ent)
		
	-- vars
	local ent_model = string.Replace(ent:GetModel(), "./", "")
	local write		= ""
	local distance	= ply:GetPos():Distance(ent:GetPos())
	
	-- Make sure the player is not a spectator and close enough to pick it up
	if !(team_enums[ply:Team()]) and (distance < 72) then
		
		-- Making a table for copying, so that we don't mess with the scavenger hunt list
		local test_table = {}
		
		-- If Red VS Blue and using different scavenger hunt lists, copy them respectively
		if team_game and use_differ_lists then
			if ply:Team() == 1 then
				test_table = table.Copy(round.round_rlist)
			else
				test_table = table.Copy(round.round_blist)
			end
			
		-- Otherwise, copy the scavenger hunt list
		else
			test_table = table.Copy(round.round_list)
		end
		
		
		-- Make sure the prop is something they have to find
        PrintTable(test_table)
        print("Searching for: "..ent_model)
		if table.HasValue(test_table, ent_model) then
		
			print("[DEBUG] "..tostring(ent_model).. " located in scavenger hunt!")
		
			-- If the player hasn't collected it already
			if ply.Inventory[ent_model] == false then
				print("[DEBUG] Player will collect "..tostring(ent_model))
			
				-- Fire off a sound so all players know an item was collected
				sound.Play("garrysmod/save_load1.wav", ent:GetPos())
				write = "found"
				
				-- Set inventory flag to true (they've found it), and increase their item count
				ply.Inventory[ent_model] = true
				ply.ItemCount = ply.ItemCount + 1
				ply:SetFound(ply.ItemCount)
				
				-- Award collection points
				ply:SetScore(ply:GetScore() + SCORE_COLLECT)
				if team_game and team_shares then
					team.SetScore(ply:Team(), team.GetScore(ply:Team()) + SCORE_COLLECT)
				end
				
				-- Update the client with the new information
				net.Start("SCAV_Item")
					net.WriteString(write)
					net.WriteString(ent_model)
					net.Send(ply)
			end
			
		else
		
			print("[DEBUG] "..tostring(ent_model).. " not found in scavenger hunt.")
			
		end
		
		-- If the player's collected item count matches the amount of items they have to find, check if they won
		-- This should be accurate regardless of if it's a team game, or if different lists are used
		if ply.ItemCount == SCAV_MAX then
		
			-- Assume they won
			local win = true
		
			-- Verify the win
			for _,check in pairs(ply.Inventory) do
			
				-- If any inventory models are still false, they didn't win
				if ply.Inventory[check] == false then win = false end
				
			end
		
			if win then
			
				-- Notify the players of the win!
				net.Start("SCAV_Winner")
					net.WriteString(ply:Name())
					net.Broadcast()
				
				-- Victory cheer for everyone to hear!
				-- [DEBUG] Update to work with female/male player model choice
				sound.Play("vo/coast/odessa/male01/nlo_cheer0"..math.random(1,4)..".wav", ply:GetPos())
				
				-- End the round and pass the player as the winner
				round.End(ply)
			
			end
		
		end
		
	elseif !(team_enums[ply:Team()]) and distance >= 96 then
		print("[DEBUG] "..tostring(ply:Name()).. " failed to collect a prop (too far away)")
	
	else
		print("[DEBUG] "..tostring(ply:Name()).. " failed to collect a prop (spectator)")
	
	end
end

hook.Add("KeyPress", "PickupProp", function(ply, key)

	if key == IN_USE and round.status == 2 then
	
		local eyetrace = ply:GetEyeTraceNoCursor()
		
		-- Make sure the entity is valid so we're not generating errors
		if IsValid(eyetrace.Entity) then
			
            local allowable = {
                ["prop_physics"] = true,
                ["prop_dynamic"] = true,
                ["prop_physics_multiplayer"] = true,
                ["prop_physics_respawnable"] = true,
                ["scav_prop"] = true}
            
			local ent 		= eyetrace.Entity
            print(ent:GetClass())
            print(allowable[ent:GetClass()])
            if allowable[ent:GetClass()] then
                DoGMPickup(ply, ent)
            end
			
		end
	
	end

end)

timer.Create("Controller", 1, 0, round.Control)

concommand.Add("proplist", function()
    PrintTable(props_map)
end)
