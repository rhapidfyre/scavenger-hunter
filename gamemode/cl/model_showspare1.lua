
--[[

	For custom menus, replace this file or comment it out, and use the following concommand:	
	"scav_modelselect"		-> The console command that opens this menu (note: all lowercase)

]]

local F3Menu = nil
local sub_left_top = nil
local sub_left_btm = nil
local sub_right = nil
local rgbpanel = nil
local viewmodel = nil

local chosen_model = nil
local chosen_color = nil

local function ColorPicker()

	rgbpanel = vgui.Create("DColorMixer", sub_left_btm)
	--rgbpanel:SetSize(sub_left_btm:GetWide(), sub_left_btm:GetTall())
	rgbpanel:Dock(FILL)
	rgbpanel:SetPalette(true)
	rgbpanel:SetAlphaBar(false)
	rgbpanel:SetWangs(false)
	rgbpanel:SetColor(Color(255,255,255))
	
end

local function MdlButtons()
	local x = 4
	local y = 4
	for model,_ in pairs(ply_models) do
		local background = vgui.Create("DPanel", sub_left_top)
		background:SetSize(96, 96)
		background:SetPos(x, y)
		background.Paint = function()
			draw.RoundedBox(4,0,0,background:GetWide(),background:GetTall(),Color(125,125,125,255))
			draw.RoundedBox(4,2,2,background:GetWide()-4,background:GetTall()-4,Color(20,20,20,255))
		end
		
		local viewer = vgui.Create("DModelPanel", background)
		viewer:SetSize(background:GetWide() - 4, background:GetTall() - 4)
		viewer:Center()
		viewer:SetModel(model)
		
		local button = vgui.Create("DButton", background)
		button:SetSize(viewer:GetSize())
		button:Center()
		button:SetText("")
		button.Paint = function()
		end
		button.DoClick = function()
			viewmodel = model
		end
		x = x + (96+4)
		if x > (sub_left_top:GetWide() - 96) then
			x = 4
			y = y + (96+4)
		end
	end
end

local function CloseButton()
	local button = vgui.Create("DButton", sub_right)
	button:SetSize(sub_right:GetWide()/2 - 8, 24)
	button:SetPos(sub_right:GetWide()/2 - (button:GetWide()/2), sub_right:GetTall() - 28)
	button:SetText("")
	button.Paint = function()
		draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
		if button:IsHovered() then
			draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(180,180,180,255))
			draw.SimpleTextOutlined("Close Menu", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,180,180), 1, 1, 1, Color(0,0,0))
		else
			draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(120,120,120,125))
			draw.SimpleTextOutlined("Close Menu", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(180,120,120), 1, 1, 1, Color(0,0,0))
		end
	end
	
	button.DoClick = function()
		F3Menu:SetVisible(false)
		gui.EnableScreenClicker(false)
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	button.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
	
	local button = vgui.Create("DButton", sub_right)
	button:SetSize(sub_right:GetWide()/2 - 8, 24)
	button:SetPos(sub_right:GetWide()/2 - (button:GetWide()/2), sub_right:GetTall() - 54)
	button:SetText("")
	button.Paint = function()
		draw.RoundedBox(8, 0, 0, button:GetWide(), button:GetTall(), Color(0,0,0,200))
		if button:IsHovered() then
			draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(180,180,180,255))
			draw.SimpleTextOutlined("Confirm Change", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(180,255,180), 1, 1, 1, Color(0,0,0))
		else
			draw.RoundedBox(8, 2, 2, button:GetWide()-4, button:GetTall()-4, Color(120,120,120,125))
			draw.SimpleTextOutlined("Confirm Change", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(120,180,120), 1, 1, 1, Color(0,0,0))
		end
	end
	
	button.DoClick = function()
	
		local colr = rgbpanel:GetColor()
		net.Start("CL_ChangeModel")
			net.WriteString(viewmodel)
			net.WriteVector(Vector(tonumber(colr.r)/255,tonumber(colr.g)/255,tonumber(colr.b)/255))
			net.SendToServer()
		
		F3Menu:SetVisible(false)
		gui.EnableScreenClicker(false)
		surface.PlaySound("garrysmod/ui_click.wav")

	end
	button.OnCursorEntered = function()
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
end

local function DrawF3Menu()
	F3Menu = vgui.Create("DFrame")
	F3Menu:SetSize(ScrW()*0.4,ScrH()*0.6)
	F3Menu:Center()
	F3Menu:SetTitle("")
	F3Menu:ShowCloseButton(false)
	F3Menu:SetDraggable(false)
	F3Menu.Paint = function()
		draw.RoundedBox(4,0,0,F3Menu:GetWide(),F3Menu:GetTall(),Color(0,0,0))
		draw.RoundedBox(4,2,2,F3Menu:GetWide()-4,F3Menu:GetTall()-4,Color(80,80,80))
	end
	
	sub_left_top = vgui.Create("DScrollPanel", F3Menu)
	sub_left_btm = vgui.Create("DPanel", F3Menu)
	sub_right 	 = vgui.Create("DPanel", F3Menu)
	
	sub_left_top:SetSize(F3Menu:GetWide()/2 - 4, F3Menu:GetTall()/2 - 4)
	sub_left_top:SetPos(4,4)
	sub_left_top.Paint = function()
		draw.RoundedBox(4,0,0,sub_left_top:GetWide(),sub_left_top:GetTall(),Color(40,40,40,255))
	end
	
	sub_left_btm:SetSize(F3Menu:GetWide()/2 - 4, F3Menu:GetTall()/2 - 8)
	sub_left_btm:SetPos(4,F3Menu:GetTall()/2 + 4)
	sub_left_btm.Paint = function()
		draw.RoundedBox(4,0,0,sub_left_btm:GetWide(),sub_left_btm:GetTall(),Color(40,40,40,255))
	end
	
	sub_right:SetSize(F3Menu:GetWide()/2 - 8, F3Menu:GetTall() - 8)
	sub_right:SetPos(F3Menu:GetWide() - (sub_right:GetWide() + 4),4)
	local viewer = vgui.Create("DModelPanel", sub_right)
	viewer:SetSize(sub_right:GetWide()*2,sub_right:GetTall())
	viewer:SetPos(0 - (sub_right:GetWide()/2),-8)
	viewer:SetAnimated(true)
	sub_right.Paint = function()
		draw.RoundedBox(4,0,0,sub_right:GetWide(),sub_right:GetTall(),Color(40,40,40,255))
		draw.SimpleText("Preview", "DermaLarge", sub_right:GetWide()/2, 0,Color(40,160,40,255),1)
		viewer:SetModel(viewmodel)
		local col = rgbpanel:GetColor()
		function viewer.Entity:GetPlayerColor()
			return Vector(tonumber(col.r)/255,tonumber(col.g)/255,tonumber(col.b)/255)
		end
	end
	
end

concommand.Add("scav_modelselect", function()
	viewmodel = LocalPlayer():GetModel()
	if !IsValid(F3Menu) then
		DrawF3Menu()
		ColorPicker()
		MdlButtons()
		CloseButton()
		gui.EnableScreenClicker(true)
	else
		if F3Menu:IsVisible() then
			F3Menu:SetVisible(false)
			gui.EnableScreenClicker(false)
		else
			F3Menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
	end
end)

