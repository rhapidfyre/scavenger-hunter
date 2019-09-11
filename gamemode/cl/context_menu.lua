-- Context Menu
local CMenu 		= nil
local scrollpanel 	= nil
local layout  		= nil
local hover_info	= nil

local function GetPropName(prop)

end

local function ScavengerList()

	if scavenger_list[1] == nil then
	
		local label = vgui.Create("DPanel", scrollpanel)
		label:SetSize(256, 64)
		label:SetPos(8,4)
		label.Paint = function()
			draw.SimpleText("NO PROPS FOUND", "TargetIDSmall", scrollpanel:GetWide()/2, 12, Color(255,120,120),1,1)
			draw.SimpleText("Refresh after round starts", "TargetIDSmall", scrollpanel:GetWide()/2, 32, Color(255,120,120),1,1)
		end
		
	else
	
		local x = 16
		local y = 8
		
		for _,v in pairs(scavenger_list) do
		
			-- Colored background. Red if they don't have it, green if they do
			local backstop = vgui.Create("DPanel", scrollpanel)
			backstop:SetSize(96,108)
			backstop:SetPos(x, y)
			backstop.Paint = function()
			
				local color  = Color(180,80,80)
				local tcol	 = Color(255,0,0)
				local status = "NOT FOUND"
				
				if inventory[v] then
					color  = Color(80,180,80)
					tcol   = Color(0,255,0)
					status = "FOUND"
				end
					draw.RoundedBox(4,0,0,96,96,color)
					draw.RoundedBox(0,4,4,88,79,Color(0,0,0))
					draw.SimpleText(status, "BudgetLabel", backstop:GetWide()/2, backstop:GetTall()-18, tcol, 1, 1, 1, Color(0,0,0))
			end
			-- Use view models otherwise we'd have to make a table of model = name for display
			local item = vgui.Create("DModelPanel", backstop)
			item:SetModel(v)
			item:SetPos(4,4)
			item:SetSize(80,79)
			item:SetCamPos(Vector(90,128,32))
			item:SetLookAt(Vector(0,0,8))
			item:SetFOV(20)
			
			-- Using this to set hover_info for model name incase the player can't see the view model
			local btn = vgui.Create("DButton", item)
			btn:SetSize(backstop:GetWide(), backstop:GetTall())
			btn:SetText("")
			btn.Paint = function()
				if btn:IsHovered() then
					hover_info = v
				end
			end
			
			-- Mathematical operations to make sure everything stays nice
			x = x + 96 + 8
			if x > 208 then
				x = 16
				y = y + 96 + 8
			end
		end
	end
end


function GM:OnContextMenuOpen()

	local me 	= LocalPlayer()
	local h 	= 512
	local w 	= 256
	local sh 	= ScrH()/2
	local sw	= ScrW()/2
	local pos_y = sh-(h/2)
	
	local myTeam = me:Team()
	
	if not IsValid(CMenu) then
	
		CMenu = vgui.Create("DFrame")
		CMenu:SetSize(ScrW(), ScrH())
		CMenu:SetPos(0, 0)
		CMenu:SetTitle("")
		CMenu:SetDraggable(false)
		CMenu:ShowCloseButton(false)
		CMenu:SetDeleteOnClose(true)
		CMenu.Paint = function()
			surface.SetDrawColor(125,125,125,120) -- Silver
			surface.DrawRect(24,pos_y,w,h) -- Background
			surface.SetDrawColor(0,0,0,255) -- Black
			surface.DrawOutlinedRect(24,pos_y,w,h) -- Outline
			draw.SimpleTextOutlined("HUNT LIST", "DermaLarge", 308/2, pos_y + 18, Color(60,240,140), 1, 1, 1, Color(0,0,0))
			local display = hover_info
			if hover_info ~= nil then
				newstring = string.Split(hover_info, "/")
				display = newstring[#newstring]
			else
				display = "Hover for Modelname"
			end
			draw.SimpleTextOutlined(display, "ChatFont", 308/2, pos_y + 40, Color(80,180,80,200), 1, 1, 1, Color(0,0,0))
			
		end
		
		scrollpanel = vgui.Create("DScrollPanel", CMenu)
		scrollpanel:SetSize(248, 460)
		scrollpanel:SetPos(28,pos_y + 48)
		scrollpanel.Paint = function()
			-- Just for testing, delete me... [DEBUG]
			draw.RoundedBox(0,0,0,scrollpanel:GetWide(), scrollpanel:GetTall(), Color(0,0,0))
		end
	
		ScavengerList()
		
		CMenu:Show()
		CMenu:MakePopup()
		surface.PlaySound("garrysmod/content_downloaded.wav")
	
	end
	
	
end

function GM:OnContextMenuClose()

	if IsValid(CMenu) then
		CMenu:Remove()
		hover_info = nil
		surface.PlaySound("garrysmod/ui_return.wav")
	end
	
end