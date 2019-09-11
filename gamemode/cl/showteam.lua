
--[[

	I didn't bother commenting much of this because it's a bunch of drawing functions for various crap in the team selection F2Menu.
	If you want to make your own team selection F2Menu, here is all you need to know:
	
	scav_teamselect		    -> Console Command that opens F2/Team Select
    team_game               -> BOOLEAN/ If TRUE, game is using teams. If FALSE, it's a free for all.
]]


local F2Menu = nil

local function GameButtons()

	if team_game then
	
		-- Play as Red Team (Team #1)
		local button = vgui.Create("DButton", F2Menu)
		button:SetSize(F2Menu:GetWide()*0.45, ScrH()*0.03)
		button:SetPos(0, 0)
		button:SetText("")
		button.Paint = function()
			draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
			if button:IsHovered() and LocalPlayer():Team() != 1 then
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(180,80,80,255))
				draw.SimpleTextOutlined("Red Team ["..team.NumPlayers(1).."]", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,225), 1, 1, 1, Color(0,0,0))
			else
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(180,80,80,125))
				draw.SimpleTextOutlined("Red Team ["..team.NumPlayers(1).."]", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,180,180), 1, 1, 1, Color(0,0,0))
			end
		end
		button.DoClick = function()
			if LocalPlayer():Team() != 1 then
                net.Start("SCAV_ChangeTeam")
                    net.WriteInt(1, 4)
                    net.SendToServer()
                surface.PlaySound("garrysmod/ui_click.wav")
				F2Menu:SetVisible(false)
				gui.EnableScreenClicker(false)
                
			else
				surface.PlaySound("buttons/button10.wav")
			end
		end
		button.OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
		end
		
		-- Play as Blue Team (Team #2)
		local button = vgui.Create("DButton", F2Menu)
		button:SetSize(F2Menu:GetWide()*0.45, ScrH()*0.03)
		button:SetPos(F2Menu:GetWide() - F2Menu:GetWide()*0.45, 0)
		button:SetText("")
		button.Paint = function()
			draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
			if button:IsHovered() and LocalPlayer():Team() != 2 then
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(80,80,180,255))
				draw.SimpleTextOutlined("Blue Team ["..team.NumPlayers(2).."]", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(225,225,255), 1, 1, 1, Color(0,0,0))
			else
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(80,80,180,125))
				draw.SimpleTextOutlined("Blue Team ["..team.NumPlayers(2).."]", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(180,180,255), 1, 1, 1, Color(0,0,0))
			end
		end
		button.DoClick = function()
			if LocalPlayer():Team() != 2 then
			net.Start("SCAV_ChangeTeam")
				net.WriteInt(2, 4)
				net.SendToServer()
			surface.PlaySound("garrysmod/ui_click.wav")
				F2Menu:SetVisible(false)
				gui.EnableScreenClicker(false)
			else
				surface.PlaySound("buttons/button10.wav")
			end
		end
		button.OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
		end
	else
	
		-- Play as Freelance (non-team game)
		local button = vgui.Create("DButton", F2Menu)
		button:SetSize(F2Menu:GetWide(), ScrH()*0.03)
		button:SetPos(F2Menu:GetWide()/2 - button:GetWide()/2, 0)
		button:SetText("")
		button.Paint = function()
			draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
			if button:IsHovered() and LocalPlayer():Team() != 3 then
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(80,180,80,255))
				draw.SimpleTextOutlined("Play Free-for-All", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
			else
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(80,180,80,125))
				draw.SimpleTextOutlined("Play Free-for-All", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(180,255,180), 1, 1, 1, Color(0,0,0))
			end
		end
		button.DoClick = function()
			if LocalPlayer():Team() != 3 then
				net.Start("SCAV_ChangeTeam")
					net.WriteInt(3, 4)
					net.SendToServer()
				surface.PlaySound("garrysmod/ui_click.wav")
				F2Menu:SetVisible(false)
				gui.EnableScreenClicker(false)
			else
				surface.PlaySound("buttons/button10.wav")
			end
		end
		button.OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
		end
	end
	
	-- Spectator Select
		local button = vgui.Create("DButton", F2Menu)
		button:SetSize(F2Menu:GetWide(), ScrH()*0.03)
		button:SetPos(F2Menu:GetWide()/2 - button:GetWide()/2, ScrH()*0.03 + 8)
		button:SetText("")
		button.Paint = function()
			draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
			if button:IsHovered() and LocalPlayer():Team() != 4 then
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(180,180,180,255))
				draw.SimpleTextOutlined("Spectate", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,180), 1, 1, 1, Color(0,0,0))
			else
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(120,120,120,125))
				draw.SimpleTextOutlined("Spectate", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(180,180,180), 1, 1, 1, Color(0,0,0))
			end
		end
		button.DoClick = function()
			if LocalPlayer():Team() != 4 then
				net.Start("SCAV_ChangeTeam")
					net.WriteInt(4, 4)
					net.SendToServer()
				surface.PlaySound("garrysmod/ui_click.wav")
				F2Menu:SetVisible(false)
				gui.EnableScreenClicker(false)
			else
				surface.PlaySound("buttons/button10.wav")
			end
		end
		button.OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
		end
end

local function CloseButton()
		local button = vgui.Create("DButton", F2Menu)
		button:SetSize(F2Menu:GetWide(), ScrH()*0.03)
		button:SetPos(F2Menu:GetWide()/2 - button:GetWide()/2, ScrH()*0.06 + 16)
		button:SetText("")
		button.Paint = function()
			draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
			if button:IsHovered() then
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(180,180,180,255))
				draw.SimpleTextOutlined("Exit Team Selection", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,180), 1, 1, 1, Color(0,0,0))
			else
				draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(120,120,120,125))
				draw.SimpleTextOutlined("Exit Team Selection", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(180,180,180), 1, 1, 1, Color(0,0,0))
			end
		end
		button.DoClick = function()
			if LocalPlayer():Team() != TEAM_UNASSIGNED then
				F2Menu:SetVisible(false)
				gui.EnableScreenClicker(false)
				surface.PlaySound("garrysmod/ui_click.wav")
			else
				surface.PlaySound("buttons/button10.wav")
			end
		end
		button.OnCursorEntered = function()
			surface.PlaySound("garrysmod/ui_hover.wav")
		end
end

local function DrawF2Menu()
    team_game = GetConVar("scav_teamgame"):GetBool()
	F2Menu = vgui.Create("DFrame")
	F2Menu:SetSize(ScrW()*0.3, ScrH()*0.6)
	F2Menu:Center()
	F2Menu:SetTitle("")
	F2Menu:SetDraggable(false)
	F2Menu:ShowCloseButton(false)
	F2Menu.Paint = function()
	end
	
end

function GM:ShowTeam()
	if !IsValid(F2Menu) then
		DrawF2Menu()
		GameButtons()
		CloseButton()
		gui.EnableScreenClicker(true)
	else
		-- Disallow new players from closing the menu
		if F2Menu:IsVisible() and LocalPlayer():Team() != TEAM_UNASSIGNED then
			F2Menu:SetVisible(false)
			gui.EnableScreenClicker(false)
		else
			F2Menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
	end
end
--concommand.Add("scav_teamselect", ToggleTeamSelect)

net.Receive("SCAV_OpenSpare2", function()
	if IsValid(F2Menu) then
		if !F2Menu:IsVisible() then
			F2Menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
	end
end)