
local F1Menu = nil
local submenu = nil
local category = 0
        
local btn = {}
    btn.highlight   = Color(80, 255, 80)
    btn.idle        = Color(80, 80, 80)
    btn.active      = Color(255, 255, 80)

local back = {}
    back.selected   = Color(100, 100, 100)
    back.high       = Color(120, 120, 120)
    back.low        = Color(60, 60, 60)
    back.stroke     = Color(200, 200, 200)
    
local function OpenSettings()
    local submenu = vgui.Create("DPanel", F1Menu)
    submenu:SetSize(F1Menu:GetWide()*0.66, F1Menu:GetTall()-8)
    submenu:SetPos(F1Menu:GetWide()*0.2, 0)
    submenu.Paint = function()
        draw.RoundedBox(8,0,0,submenu:GetWide(),submenu:GetTall(),Color(200,200,200))
        draw.RoundedBox(8,1,1,submenu:GetWide()-2,submenu:GetTall()-2,Color(40,40,40))
        draw.SimpleText("Created by RhapidFyre - STEAM_0:0:6473491 (2018)", "DebugFixed", submenu:GetWide()/2, submenu:GetTall() - 20, Color(255,140,140), 1)
        draw.SimpleTextOutlined("SCAVENGER HUNTER", "DermaLarge", submenu:GetWide()/2, 4, Color(200,200,200), 1, 0, 1, team.GetColor())
        draw.SimpleText("Server Settings Report", "DermaDefaultBold", submenu:GetWide()/2, 32, team.GetColor(), 1)
    end
    
    local dlist = vgui.Create("DListView", submenu)
    dlist:SetSize(submenu:GetWide()/2 - 16, submenu:GetTall() - 86)
    dlist:SetPos(8, 64)
    dlist:AddColumn("SERVER SETTING")
    dlist:AddColumn("VALUE")
    for k,v in pairs ( gmSettings ) do
        dlist:AddLine(v["name"], v["value"])
    end
    
    local vlist = vgui.Create("DListView", submenu)
    vlist:SetSize(submenu:GetWide()/2 - 16, submenu:GetTall() - 86)
    vlist:SetPos(submenu:GetWide()/2 + 8, 64)
    vlist:AddColumn("DESCRIPTION")
    vlist:AddColumn("VALUE")
    for k,v in pairs ( gmValues ) do
        vlist:AddLine(v["name"], v["value"])
    end
end

local function OpenMainPage()
    local submenu = vgui.Create("DPanel", F1Menu)
    submenu:SetSize(F1Menu:GetWide()*0.66, F1Menu:GetTall()-8)
    submenu:SetPos(F1Menu:GetWide()*0.2, 0)
    submenu.Paint = function()
        draw.RoundedBox(8,0,0,submenu:GetWide(),submenu:GetTall(),Color(200,200,200))
        draw.RoundedBox(8,1,1,submenu:GetWide()-2,submenu:GetTall()-2,Color(40,40,40))
        draw.SimpleText("Created by RhapidFyre - STEAM_0:0:6473491 (2018)", "DebugFixed", submenu:GetWide()/2, submenu:GetTall() - 20, Color(255,140,140), 1)
        draw.SimpleTextOutlined("SCAVENGER HUNTER", "DermaLarge", submenu:GetWide()/2, 4, Color(200,200,200), 1, 0, 1, team.GetColor())
        draw.SimpleText("A violent take on the popular party game!", "DermaDefaultBold", submenu:GetWide()/2, 32, team.GetColor(), 1)
        
        draw.SimpleText("CURRENT GAMEPLAY MODE IS SET TO", "DermaDefaultBold", submenu:GetWide()/2, submenu:GetTall() * 0.25, Color(220,220,220), 1)
        if team_game then
            draw.SimpleText("TEAM COLLECTION", "DermaLarge", submenu:GetWide()/2, submenu:GetTall() * 0.25 + 12, Color(0,255,255), 1)
            draw.SimpleText("Team wins by one player collecting all the props on the list!", "ChatFont", submenu:GetWide()/2, submenu:GetTall()/2 + 24, Color(220,220,220), 1)
            draw.SimpleText("The team with the most props collected will gain bonus points.", "ChatFont", submenu:GetWide()/2, submenu:GetTall()/2 + 48, Color(220,220,220), 1)
            draw.SimpleText("Check GAME SETTINGS for bonus points and credits.", "ChatFont", submenu:GetWide()/2, submenu:GetTall()/2 + 96, Color(220,220,220), 1)
        else
            draw.SimpleText("FREE-FOR-ALL", "DermaLarge", submenu:GetWide()/2, submenu:GetTall() * 0.25 + 12, Color(255,180,0), 1)
            draw.SimpleText("The first player to collect all the props wins!", "ChatFont", submenu:GetWide()/2, submenu:GetTall()/2 + 24, Color(220,220,220), 1)
            draw.SimpleText("Check GAME SETTINGS for bonus points and credits.", "ChatFont", submenu:GetWide()/2, submenu:GetTall()/2 + 48, Color(220,220,220), 1)
        end
        
        draw.SimpleTextOutlined("C", "DermaLarge", 24, submenu:GetTall() - 82, Color(220,220,220), 0, 0, 1, Color(255,255,255))
        draw.SimpleText("Scavenger List", "DermaLarge", 24, submenu:GetTall() - 48, Color(220,220,220), 0)
        draw.SimpleTextOutlined("F4", "DermaLarge", submenu:GetWide() - 24, submenu:GetTall() - 82, Color(220,220,220), 2, 0, 1, Color(255,255,255))
        draw.SimpleText("View Upgrades", "DermaLarge", submenu:GetWide() - 24, submenu:GetTall() - 48, Color(220,220,220), 2)
    end
end

local function DrawF1Menu()

	F1Menu = vgui.Create("DFrame")
	F1Menu:SetSize(ScrW()*0.6,ScrH()/2)
	F1Menu:Center()
	F1Menu:SetTitle("")
	F1Menu:ShowCloseButton(false)
	F1Menu:SetDraggable(false)
	F1Menu.Paint = function()
		--draw.RoundedBox(4,0,0,F1Menu:GetWide(),F1Menu:GetTall(),Color(0,0,0))
	end
    
    OpenMainPage()
    
    local btnmenu = vgui.Create("DPanel", F1Menu)
    btnmenu:SetSize(F1Menu:GetWide()*0.2, F1Menu:GetTall()-8)
    btnmenu:SetPos(0,4)
    btnmenu.Paint = function()
        --draw.RoundedBox(8,0,0,btnmenu:GetWide(),btnmenu:GetTall(),Color(255,255,255))
    end
	local teambtn = vgui.Create("DButton", F1Menu)
	teambtn:SetSize(btnmenu:GetWide() - 4, 24)
	teambtn:SetPos(2,2)
	teambtn:SetText("")
    teambtn.Paint = function()
        if teambtn:IsHovered() then
            draw.RoundedBox(8, 0, 0, teambtn:GetWide(), teambtn:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, teambtn:GetWide()-2, teambtn:GetTall()-2, back.selected)
            draw.SimpleText("PLAY NOW!", "DermaDefaultBold", teambtn:GetWide()/2, teambtn:GetTall()/2 -2, btn.highlight, 1, 1)
        else
            draw.RoundedBox(8, 0, 0, teambtn:GetWide(), teambtn:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, teambtn:GetWide()-2, teambtn:GetTall()-2, back.low)
            draw.SimpleText("PLAY NOW!", "DermaDefaultBold", teambtn:GetWide()/2, teambtn:GetTall()/2 -2, Color(200,200,200), 1, 1)
        end
    end
	teambtn.DoClick = function()
		F1Menu:SetVisible(false)
		GAMEMODE:ShowTeam()
	end
    
	local modelbtn = vgui.Create("DButton", F1Menu)
	modelbtn:SetSize(btnmenu:GetWide() - 4, 24)
	modelbtn:SetPos(2,32)
	modelbtn:SetText("")
    modelbtn.Paint = function()
        if modelbtn:IsHovered() then
            draw.RoundedBox(8, 0, 0, modelbtn:GetWide(), modelbtn:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, modelbtn:GetWide()-2, modelbtn:GetTall()-2, back.selected)
            draw.SimpleText("MODEL SELECT", "DermaDefaultBold", modelbtn:GetWide()/2, modelbtn:GetTall()/2 -2, btn.highlight, 1, 1)
        else
            draw.RoundedBox(8, 0, 0, modelbtn:GetWide(), modelbtn:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, modelbtn:GetWide()-2, modelbtn:GetTall()-2, back.low)
            draw.SimpleText("MODEL SELECT", "DermaDefaultBold", modelbtn:GetWide()/2, modelbtn:GetTall()/2 -2, Color(200,200,200), 1, 1)
        end
    end
	modelbtn.DoClick = function()
		F1Menu:SetVisible(false)
		LocalPlayer():ConCommand("scav_modelselect")
	end
	
	local settings = vgui.Create("DButton", F1Menu)
	settings:SetSize(btnmenu:GetWide() - 4, 24)
	settings:SetPos(2,92)
	settings:SetText("")
    settings.Paint = function()
        if settings:IsHovered() then
            draw.RoundedBox(8, 0, 0, settings:GetWide(), settings:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, settings:GetWide()-2, settings:GetTall()-2, back.selected)
            draw.SimpleText("HELP / INFO", "DermaDefaultBold", settings:GetWide()/2, settings:GetTall()/2 -2, btn.highlight, 1, 1)
        else
            draw.RoundedBox(8, 0, 0, settings:GetWide(), settings:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, settings:GetWide()-2, settings:GetTall()-2, back.low)
            draw.SimpleText("HELP / INFO", "DermaDefaultBold", settings:GetWide()/2, settings:GetTall()/2 -2, Color(200,200,200), 1, 1)
        end
    end
	settings.DoClick = function()
		OpenMainPage()
	end
    
	local settings = vgui.Create("DButton", F1Menu)
	settings:SetSize(btnmenu:GetWide() - 4, 24)
	settings:SetPos(2,122)
	settings:SetText("")
    settings.Paint = function()
        if settings:IsHovered() then
            draw.RoundedBox(8, 0, 0, settings:GetWide(), settings:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, settings:GetWide()-2, settings:GetTall()-2, back.selected)
            draw.SimpleText("GAME SETTINGS", "DermaDefaultBold", settings:GetWide()/2, settings:GetTall()/2 -2, btn.highlight, 1, 1)
        else
            draw.RoundedBox(8, 0, 0, settings:GetWide(), settings:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, settings:GetWide()-2, settings:GetTall()-2, back.low)
            draw.SimpleText("GAME SETTINGS", "DermaDefaultBold", settings:GetWide()/2, settings:GetTall()/2 -2, Color(200,200,200), 1, 1)
        end
    end
	settings.DoClick = function()
		OpenSettings()
	end
    
    local closebtn = vgui.Create("DButton", F1Menu)
    closebtn:SetSize(btnmenu:GetWide() - 4, 24)
    closebtn:SetPos(2,btnmenu:GetTall()- 24)
    closebtn:SetText("")
    closebtn.Paint = function()
        if closebtn:IsHovered() then
            draw.RoundedBox(8, 0, 0, closebtn:GetWide(), closebtn:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, closebtn:GetWide()-2, closebtn:GetTall()-2, back.selected)
            draw.SimpleText("CLOSE", "DermaDefaultBold", closebtn:GetWide()/2, closebtn:GetTall()/2 -2, btn.highlight, 1, 1)
        else
            draw.RoundedBox(8, 0, 0, closebtn:GetWide(), closebtn:GetTall(), back.high)
            draw.RoundedBox(8, 1,1, closebtn:GetWide()-2, closebtn:GetTall()-2, back.low)
            draw.SimpleText("CLOSE", "DermaDefaultBold", closebtn:GetWide()/2, closebtn:GetTall()/2 -2, Color(200,200,200), 1, 1)
        end
    end
    closebtn.DoClick = function()
        F1Menu:Remove()
        gui.EnableScreenClicker(false)
    end
    
end

concommand.Add("scav_helpmenu", function()
	if !IsValid(F1Menu) then
		DrawF1Menu()
		gui.EnableScreenClicker(true)
	else
		if F1Menu:IsVisible() then
			F1Menu:SetVisible(false)
			gui.EnableScreenClicker(false)
		else
			F1Menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
	end
end)