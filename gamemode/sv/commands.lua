
-- Find and return a player entity
function SelectPlayer(name)
	for k,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(tostring(name))) != nil then
			return v
		end
	end
end

-- Opens the team select menu when ShowSpare2 is struck (Default: F1)
function GM:ShowHelp(ply)
	ply:ConCommand("scav_helpmenu")
end

-- Opens the team select menu when ShowSpare2 is struck (Default: F1)
function GM:ShowTeam(ply)
	ply:SendLua("GAMEMODE:ShowTeam()")
end

-- Opens the team select menu when ShowSpare2 is struck (Default: F3)
function GM:ShowSpare1(ply)
	ply:ConCommand("scav_modelselect")
end

-- Opens the model select menu when ShowSpare2 is struck (Default: F4)
function GM:ShowSpare2(ply)
	ply:ConCommand("scav_openshop")
end

concommand.Add("scav_team", function(ply, cmd, args)
    if ply:IsAdmin() then
        -- Find player entity based on string argument
        local target = SelectPlayer(args[1])
        
        -- If no value is given return team number
        if args[2] == nil then
            print("[HUNTER] "..target:Name().." is "..team.GetName(target:Team()).." ["..target:Team().."]")
            
        -- If a value is given, assign the new team
        else
            target:SetTeam(args[2])
            print("[HUNTER] Moved "..target:Name().." to "..team.GetName(target:Team()))
            target:Spawn()
        end
    end
end)

concommand.Add("scav_message", function(ply, cmd, args)
    if ply:IsAdmin() then
        -- Send message to all clients
        net.Start("HUD_Message")
        
            -- This little loop changes each piece of the argument string into one combined string
            local str = ""
            for i = 1, #args, 1 do
                str = str.." "..args[i]
            end
            
            --- First write: Message
            -- Second write: Title
            net.WriteString(str)
            net.WriteString("Server Alert")
            
            -- Send to all clients
            net.Broadcast()
    end
end)