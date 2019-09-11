
local scoreboard = scoreboard or {}

local function ScrollPanel(sboard, teamNum, height)


    -- Sort player list by Score
    local plylist = player.GetAll()
	table.sort(plylist, function(a,b)
		return a:GetScore() > b:GetScore()
	end)
    
    -- Scoreboard Coloring Scheme
    local colorEven
    local colorOdd
    if teamNum == 1 then     -- Red
        colorEven = Color(200, 80, 80, 100)
        colorOdd  = Color(200, 40, 40, 100)
    elseif teamNum == 2 then -- Blue 
        colorEven = Color(80, 80, 200, 100)
        colorOdd  = Color(40, 40, 200, 100)
    elseif teamNum == 3 then -- Free for All
        colorEven = Color(200, 200, 80, 100)
        colorOdd  = Color(200, 200, 40, 100)
    else                     -- Spectator
        colorEven = Color(200, 200, 200, 100)
        colorOdd  = Color(160, 160, 160, 100)
    end

    -- Scrollpanel Attachment
	local scroller  = vgui.Create("DScrollPanel", sboard)
	scroller:SetPos(32,(sboard:GetTall()*0.125 + 56) + height)
	
	local i = 0
    
	for _,ply in pairs(plylist) do
        
        if ply:Team() == teamNum then
			local drawBox = colorEven
                if (i%2 == 0) then drawBox = colorOdd
			end
				
			local color = Color(255,255,255)
			if ply == LocalPlayer() then color = Color(255,255,0) end
			local pnl = scroller:Add("DPanel")
			pnl:SetPos(0,0)
			pnl:Dock(TOP)
			pnl:SetSize(scroller:GetWide()-8, 24)
			pnl.Paint = function()
				draw.RoundedBox(8, 2, 2, pnl:GetWide()-8, pnl:GetTall()-2, drawBox)
				draw.SimpleText(ply:Name(), 		"ChatFont", pnl:GetWide()*0.05, 12, color, 0, 1)
				draw.SimpleText(ply:GetScore(), 	"ChatFont", pnl:GetWide()*0.5, 12, color, 1, 1)
				draw.SimpleText(ply:GetFound(), 	"ChatFont", pnl:GetWide()*0.6, 12, color, 1, 1)
				draw.SimpleText(ply:Frags(), 		"ChatFont", pnl:GetWide()*0.7, 12, color, 1, 1)
				draw.SimpleText(ply:Deaths(), 	    "ChatFont", pnl:GetWide()*0.8, 12, color, 1, 1)
				draw.SimpleText(ply:Ping(), 		"ChatFont", pnl:GetWide()*0.9, 12, color, 1, 1)
			end
			
			height = height + 24
			i = i + 1
			
		end
		
	end
	
	if height > sboard:GetTall()*0.3 then
		height = sboard:GetTall()*0.3
	end
	scroller:SetSize(sboard:GetWide()-64, height)
    return height
end

function scoreboard:show()

	local teams = GetConVar("scav_teamgame"):GetBool()
	

	local sboard = vgui.Create("DFrame")
	sboard:SetSize(ScrW()*0.4,ScrH()*0.75)
	sboard:Center()
	sboard:ShowCloseButton(false)
	sboard:SetTitle("")
	sboard.Paint = function()
		--draw.RoundedBox(16, 0, 0, sboard:GetWide(), sboard:GetTall(), Color(100,100,100,100), true, true, false, false)
	end
	
	local title = vgui.Create("DPanel", sboard)
	title:SetSize(sboard:GetWide()-8, sboard:GetTall()*0.125)
	title:SetPos(4,4)
	title.Paint = function()
		draw.RoundedBoxEx(16, 0, 0, title:GetWide(), title:GetTall(), Color(40,40,40,255), true, true, false, false)
		draw.SimpleText("Scavenger Hunt(er)", "HUDScore1", title:GetWide()/2, title:GetTall()*0.1, Color(255,255,0), 1, 0)
		draw.SimpleText("Scavenger Hunt(er)", "HUDScore2", title:GetWide()/2, title:GetTall()*0.1, Color(80,255,80), 1, 0)
		local strn = "A game of scavenger hunt, but with graphical violence!"
		if status == 1 then
			strn = "Get ready! The round is about to begin."
		elseif status == 2 then
			strn = "Eliminate your opponents, and collect all of your props!"
		elseif status == 3 then
			strn = "The current round has concluded."
		end
		draw.SimpleText(strn, "HUDScore3", title:GetWide()/2, title:GetTall()*0.65, Color(180,180,180), 1, 0)
	end
	
	local teamscore = vgui.Create("DPanel", sboard)
	teamscore:SetPos(32, sboard:GetTall()*0.125 + 8)
	teamscore:SetSize(sboard:GetWide()-64, 48)
	teamscore.Paint = function()
		draw.RoundedBox(8, 2, 2, teamscore:GetWide()-8, teamscore:GetTall()-2, Color(80,80,80,255))
		draw.SimpleTextOutlined("PLAYER NAME", "Trebuchet18", teamscore:GetWide()*0.05, 40, Color(220,220,220), 0, 1, 1, Color(0,0,0))
		draw.SimpleTextOutlined("SCORE", "Trebuchet18", teamscore:GetWide()*0.5, 40, Color(220,220,220), 1, 1, 1, Color(0,0,0))
		draw.SimpleTextOutlined("FOUND", "Trebuchet18", teamscore:GetWide()*0.6, 40, Color(220,220,220), 1, 1, 1, Color(0,0,0))
		draw.SimpleTextOutlined("KILLS", "Trebuchet18", teamscore:GetWide()*0.7, 40, Color(220,220,220), 1, 1, 1, Color(0,0,0))
		draw.SimpleTextOutlined("DEATHS", "Trebuchet18", teamscore:GetWide()*0.8, 40, Color(220,220,220), 1, 1, 1, Color(0,0,0))
		draw.SimpleTextOutlined("PING", "Trebuchet18", teamscore:GetWide()*0.9, 40, Color(220,220,220), 1, 1, 1, Color(0,0,0))
		if teams then
			draw.SimpleTextOutlined("RED - "..team.GetScore(1), "HUDFont1", teamscore:GetWide()*0.25, 16, Color(220,220,220), 1, 1, 1, Color(0,0,0))
			draw.SimpleTextOutlined("BLUE - "..team.GetScore(2), "HUDFont1", teamscore:GetWide()*0.75, 16, Color(220,220,220), 1, 1, 1, Color(0,0,0))
		else
			draw.SimpleTextOutlined("Free-for-All Mode", "HUDFont1", teamscore:GetWide()/2, 16, Color(125,255,125), 1, 1, 1, Color(0,0,0))
		end
	end
    
    -- Draw the individual player panels
    local height = 0
	if teams then
        if team.GetScore(1) > team.GetScore(2) then
            height = ScrollPanel(sboard, 1, height)
            height = ScrollPanel(sboard, 2, height)
        else
            height = ScrollPanel(sboard, 2, height)
            height = ScrollPanel(sboard, 1, height)
        end
        ScrollPanel(sboard, 1002, height)
	else
        height = ScrollPanel(sboard, 3, height)
        ScrollPanel(sboard, 1002, height)
	end

	function scoreboard:hide()
		sboard:Remove()
	end
	
end

function GM:ScoreboardShow()
	scoreboard:show()
	gui.EnableScreenClicker(true)
end

function GM:ScoreboardHide()
	scoreboard:hide()
	gui.EnableScreenClicker(false)
end