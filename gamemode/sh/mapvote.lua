--[[
    This file handles the built in Map Voting System.
    If you want to create your own level changing system, replace this file.
    
    This file is self-sufficient, if you remove it the game will just play indefinitely on the same map.
]]
local messages = {
   "You are playing on "..GetHostName()..", enjoy the game!",
   "To nominate a map for the end-game vote, say 'nominate <map>'",
   "To see a list of map names, say 'maplist' and then check the console.",
   "To disable this gamemode-based map vote, delete 'mapvote.lua' from gamemode/sh/",
   "To change these messages, go to gamemode/sh/mapvote.lua"
   }

local MAP_MAX_CHOICES = 10

if (CLIENT) then

    net.Receive("END_StopVote", function()
        hook.Remove("HUDPaint", "MapVoteList")
    end)

    net.Receive("END_InitiateVote", function()
    
        local maplist = net.ReadTable()
        surface.PlaySound("music/hl1_song11.mp3")
       
        hook.Add("HUDPaint", "MapVoteList", function()
            local trig = math.abs(math.sin(CurTime() * 4)) * 255
            draw.SimpleTextOutlined("TYPE NUMBER IN CHAT!", "DermaLarge", 8, ScrH()/2 - 48, Color(255,0,0, trig), 0, 1, 1, Color(200,200,200))
            local y = 24
            local i = 1
            for k,v in pairs(maplist) do
                draw.SimpleTextOutlined("["..tostring(i).."] ("..(GetGlobalInt("map"..i)).."): "..v, "ChatFont", 8, (ScrH()/2 - 48) + y, Color(255,255,255), 0, 1, 1, Color(0,0,0))
                y = y + 16
                i = i + 1
            end
        end)
    end)
    
    net.Receive("VOTE_NiceString", function()
        local message = net.ReadString()
        chat.AddText(Color(200,160,80), "[SIMPLEVOTE] ", Color(0,200,200), message)
        chat.PlaySound()
    end)
end

if (SERVER) then

    util.AddNetworkString("END_InitiateVote")
    util.AddNetworkString("END_StopVote")
    util.AddNetworkString("VOTE_Send")
    util.AddNetworkString("VOTE_NiceString")

    local nominate = {}
        nominate.maps = {}  -- List of maps located by the gamemode
        nominate.noms = {} -- List of maps nominated by players (KEY = Map Name / VAL = Player Unique ID)
        nominate.pick = {} -- List of maps chosen to be voted upon (KEY = Index Number / VAL = Mapname)
        nominate.vote = {} -- List of maps to vote on (KEY = Index Number / VAL = Player Unique ID)
        nominate.prog = false -- Is there a vote in progress (used as a flag)
        nominate.time = 12 -- Time until map vote finishes
    
    -- Scans for all maps and puts it into 'nominate.maps'
    for k,v in pairs (file.Find("maps/*.bsp", "GAME")) do
        local mapname = string.StripExtension(v)
        table.insert(nominate.maps, mapname)
    end
    
    local function DoMapVote()
        
        -- Ensure map votes are empty to begin with
        nominate.prog = true
        nominate.pick = {}
        nominate.vote = {}
    
        -- Add nominated maps to nominate.pick table
        local count = 0
        if nominate.noms != nil then
            for mapname,_ in pairs (nominate.noms) do
                if nominate.noms[mapname] != nil then
                    count = count + 1
                    nominate.pick[count] = mapname
                    table.RemoveByValue(nominate.maps, mapname)
                end
            end
        end
        
        -- Fill remaining maps with random maps from generated maplist
        while count <= MAP_MAX_CHOICES do
            count = count + 1
            local random = math.random(1, #nominate.maps)
            nominate.pick[count] = nominate.maps[random]
            table.remove(nominate.maps, random)
        end
        
        local slot = 1
        for k,v in pairs (nominate.pick) do
            nominate.vote[slot] = 0
            slot = slot + 1
        end
        
        -- Send compiled map eligibility list to players for voting
        net.Start("END_InitiateVote")
            net.WriteTable(nominate.pick)
            net.Broadcast()
        
        timer.Simple(nominate.time, function()
            
            local winner = 1
            local votes  = nominate.vote[winner]
            for index,ballets in pairs (nominate.vote) do
                if nominate.vote[index] > votes then
                    winner = index
                    votes = nominate.vote[index]
                end
            end
            
            net.Start("VOTE_NiceString")
                net.WriteString("'"..nominate.pick[winner].."' got the most votes! ("..(votes)..")")
                net.Broadcast()
            
            net.Start("END_StopVote")
                net.Broadcast()
                
            timer.Simple(3, function()
                RunConsoleCommand("changelevel", (nominate.pick[winner]))
            end)
        end)
        
    end
    
    -- Handles map nominations, and end game voting.
    hook.Add("PlayerSay", "NominateMap", function(ply, text, teamOnly)
    
        local detect  = string.Split(text, " ")
        local command = detect[1]
        local mapname = detect[2]
        local puid    = ply:UniqueID()
        
        -- A player says "nominate", and a vote isn't currently in progress already (end of game)
        if (command == "maplist") then
            net.Start("VOTE_NiceString")
                net.WriteString("Messaged "..ply:GetName().." a list of votable maps!")
                    net.Broadcast()
            for k,v in pairs(nominate.maps) do
                net.WriteString("Check your console ([`] by default) for a full list of maps.")
                    net.Broadcast()
                ply:PrintMessage(HUD_PRINTCONSOLE, v)
            end
        end
        if (command == "nominate" or command == "Nominate" or command == "NOMINATE") and !nominate.prog then
            
            if ply.NomTime == nil then ply.NomTime = (0 - 30) end
            
            -- If the map isn't on the server, tell them
            if !table.HasValue(nominate.maps, mapname) then
                net.Start("VOTE_NiceString")
                    net.WriteString("Couldn't find a map with the filename '"..mapname.."'")
                    net.Send(ply)
            
            -- Map exists, continue
            else 
            
                -- If they haven't recently nominated, let it go through
                if (ply.NomTime + 30) < CurTime() then  
                    ply.NomTime = CurTime()
                    if nominate.noms[mapname] == nil then
                        nominate.noms[mapname] = {}
                        nominate.noms[mapname][puid] = ply
                    else
                        nominate.noms[mapname][puid] = ply
                    end
                    
                    local count = 0
                    for k,v in pairs (nominate.noms[mapname]) do
                        count = count + 1
                    end
                    
                    ply.Nominated = mapname
                    net.Start("VOTE_NiceString")
                        net.WriteString(ply:GetName().." has nominated '"..mapname.."'. ("..count.." Nominations).")
                        net.Broadcast()
                
                -- Must wait 30 seconds between nominations
                else
                    net.Start("VOTE_NiceString")
                        net.WriteString("You recently nominated '"..(ply.Nominated).."'. Try again later...")
                        net.Send(ply)
                end
            end
        end
        
        -- If the vote is in progress
        if nominate.prog then
            local index = tonumber(command)
            if index > 0 and index < MAP_MAX_CHOICES then
                -- Check to see if player already voted by scanning the table values for their PUID
                if ply.MapVoted then
                
                    nominate.vote[ply.VotedFor] = nominate.vote[ply.VotedFor] - 1
                    net.Start("VOTE_NiceString")
                        net.WriteString("You have changed your vote to '"..nominate.pick[index].."'.")
                        net.Send(ply)
                    
                -- Otherwise, add it to their vote
                else
                    ply.MapVoted = true
                    net.Start("VOTE_NiceString")
                        net.WriteString("You have voted to play '"..nominate.pick[index].."' next.")
                        net.Send(ply)
                end
                
                -- Insert vote and update vote count global int
                ply.VotedFor = index
                nominate.vote[index] = nominate.vote[index] + 1
                for ind,ct in pairs (nominate.vote) do
                    SetGlobalInt("map"..ind, ct)
                end
                
            -- Vote is out of range
            else
                net.Start("VOTE_NiceString")
                    net.WriteString("Invalid Number - Vote did not register.")
                    net.Send(ply)
            end
        end
        
    end)
    
    -- Random Messages
    timer.Create("MapVoteHelper", 45, 0, function()
    
        net.Start("VOTE_NiceString")
            net.WriteString(table.Random(messages))
            net.Broadcast()
    
    end)
    
    -- Send notice that round will be the final round
    hook.Add("RoundPrepare", "EndNotice", function()
        if ((round.round_count + 1) >= MAX_ROUNDS) or (CurTime() > (MAX_TIME*60)) then
            end_game = true
            net.Start("VOTE_NiceString")
                net.WriteString("!! THIS WILL BE THE FINAL ROUND !!")
                net.Broadcast()
        end
    end)
    
    -- Conduct the mapvote
    hook.Add("RoundEnd", "DoMapVote", function()
        if ((round.round_count) >= MAX_ROUNDS) or (end_game) then DoMapVote() end
    end)
end