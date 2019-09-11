
local F4Menu = nil
local submenu = nil
local shopmenu = nil
local dscroll = nil
local dlabel1 = nil
local dlabel2 = nil
local description1 = nil
local description2 = nil
local active = "Shopbtn"
local page = "Shop"
local category = {
	"Shop",
	"VIP",
	"Admin"
}

local function DrawShop(text1, text2)

	dlabel1 = vgui.Create("DLabel", submenu)
	dlabel1:SetSize(submenu:GetWide()*0.66, 0)
	dlabel1:SetPos(submenu:GetWide()*0.34, 24)
	dlabel1:SetFont("ChatFont")
	dlabel1:SetTextColor(Color(80,255,80))
	dlabel1:SetText(text1)
	dlabel1:SetAutoStretchVertical(true)
	dlabel1:SetWrap(true)
	
	dlabel2 = vgui.Create("DLabel", submenu)
	dlabel2:SetSize(submenu:GetWide()*0.66, 0)
	dlabel2:SetPos(submenu:GetWide()*0.34, 48)
	dlabel2:SetFont("ChatFont")
	dlabel2:SetText(text2)
	dlabel2:SetAutoStretchVertical(true)
	dlabel2:SetWrap(true)

end

local function DrawChoices(dscroll)
	local y = 4
	for k,v in pairs(power_up) do
		local button = vgui.Create("DButton", dscroll)
		button:SetText("")
		button:SetSize(dscroll:GetWide()-8, 24)
		button:SetPos(4, y)
        button.Paint = function()
            if button:IsHovered() then
                draw.RoundedBox(6, 0, 0, button:GetWide(), button:GetTall(), Color(20, 255, 20))
                draw.RoundedBox(6, 1, 1, button:GetWide() - 2, button:GetTall() - 2, Color(60, 60, 60))
                draw.SimpleText(v.name, "Trebuchet18", 12, button:GetTall()/2, Color(255, 255, 160), 0, 1)
                draw.SimpleText(v.price, "Trebuchet24", button:GetWide()-12, button:GetTall()/2, Color(255, 255, 80), 2, 1)
            else
                draw.RoundedBox(6, 0, 0, button:GetWide(), button:GetTall(), Color(200, 200, 200))
                draw.RoundedBox(6, 1, 1, button:GetWide() - 2, button:GetTall() - 2, Color(20, 20, 20))
                draw.SimpleText(v.name, "Trebuchet18", 12, button:GetTall()/2, Color(200, 200, 200), 0, 1)
                if LocalPlayer():GetCredits() >= tonumber(v["price"]) then
                    draw.SimpleText(v.price, "Trebuchet24", button:GetWide()-12, button:GetTall()/2, Color(40, 255, 40), 2, 1)
                else
                    draw.SimpleText(v.price, "Trebuchet24", button:GetWide()-12, button:GetTall()/2, Color(255, 40, 40), 2, 1)
                end
            end
        end
		function button:OnCursorEntered()
			if IsValid(dlabel1) then dlabel1:Remove() end
			if IsValid(dlabel2) then dlabel2:Remove() end
			DrawShop(v.short, v.description)
		end
        function button:DoClick()
            net.Start("SCAV_PurchasePU")
                print("(DEBUG) Player purchasing upgrade: "..(v.id).." ~")
                net.WriteString(v.id)
                net.SendToServer()
            F4Menu:SetVisible(false)
            gui.EnableScreenClicker(false)
        end
		y = y + 28
	end
end

local function DrawF4Menu()
	F4Menu = vgui.Create("DFrame")
	F4Menu:SetSize(ScrW()*0.4,ScrH()*0.6)
	F4Menu:Center()
	F4Menu:SetTitle("Credits Shop")
	F4Menu:ShowCloseButton(true)
	F4Menu:SetDraggable(false)
	F4Menu.Paint = function()
		draw.RoundedBox(4,0,0,F4Menu:GetWide(),F4Menu:GetTall(),Color(0,0,0))
		draw.RoundedBox(4,2,2,F4Menu:GetWide()-4,F4Menu:GetTall()-4,team.GetColor(LocalPlayer():Team()))
		draw.RoundedBoxEx(4,2,24,F4Menu:GetWide()-4,F4Menu:GetTall()-26,Color(80,80,80),false,false,true,true)
	end
	function F4Menu:OnClose()
		F4Menu:SetVisible(false)
		gui.EnableScreenClicker(false)
		F4Menu = nil
	end
	
	submenu = vgui.Create("DPanel", F4Menu)
	submenu:SetSize(F4Menu:GetWide()-8, F4Menu:GetTall()-52)
	submenu:SetPos(4,48)
	submenu.Paint = function()
		draw.RoundedBoxEx(4,0,0,submenu:GetWide(),submenu:GetTall(),Color(180,180,180),false,true,true,true)
		draw.RoundedBoxEx(4,2,2,submenu:GetWide()-4,submenu:GetTall()-4,Color(25,25,25),false,true,true,true)
	end
	
	dscroll = vgui.Create("DScrollPanel", submenu)
	dscroll:SetSize(submenu:GetWide()/3, submenu:GetTall())
	dscroll:SetPos(0,0)
    dscroll:SetVerticalScrollbarEnabled(false)
	dscroll.Paint = function()
		draw.RoundedBoxEx(4,0,0,dscroll:GetWide(),dscroll:GetTall(),Color(180,180,180),false,false,true,false)
		draw.RoundedBoxEx(4,2,2,dscroll:GetWide()-4,dscroll:GetTall()-4,Color(40,40,40),true,false,true,false)
	end
	
	DrawChoices(dscroll)
	
end

concommand.Add("scav_openshop", function()
	if !IsValid(F4Menu) then
        if (status == 2 or status == 1) and LocalPlayer():Team() > 0 and LocalPlayer():Team() < 4 then
            DrawF4Menu()
            gui.EnableScreenClicker(true)
        end
	else 
		if F4Menu:IsVisible() then
			F4Menu:SetVisible(false)
			gui.EnableScreenClicker(false)
			F4Menu:Close()
			F4Menu = nil
		elseif (status == 2 or status == 1) and LocalPlayer():Team() > 0 and LocalPlayer():Team() < 4 then
			F4Menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
	end
end)