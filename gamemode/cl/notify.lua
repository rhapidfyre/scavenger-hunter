
local message1	= ""
local message2	= ""
local popup	 	= nil

-- Returning this true on client stops blood decals
function GM:ScalePlayerDamage( )
	return true
end

local function DisplayGameMessage()
	
	if message1 != "" then
		draw.RoundedBox(16, ScrW()/2 - 386, 128, 772, 100, Color(0,0,0,180))
		draw.RoundedBox(16, ScrW()/2 - 384, 130, 768, 96, Color(80,80,80,100))
		
		local alpha = 255
		if message2 == "Server Alert" then
			alpha = math.abs(math.sin(CurTime()*6)*255)
		end
		
		draw.SimpleText(message2, "HUDFont1", ScrW()/2, 148, Color(255,alpha,alpha,255), 1, 1, 1, Color(0,0,0))		
		draw.SimpleText(message1, "HUDAmmo1", ScrW()/2, 192, Color(255,255,255,255), 1, 1, 1, Color(0,0,0))
	end
	
end
hook.Add("HUDPaint", "GMMessage", DisplayGameMessage)

net.Receive("SCAV_Item", function()

	collected = collected + 1
	local notify = net.ReadString()
	local modelname = net.ReadString()
	
	if notify == "found" then
		chat.AddText(gm_color, "["..gm_title.."] ", Color(40,255,40), "You have collected an item!")
		inventory[modelname] = true
	end

end)

net.Receive("SCAV_Break", function()

	chat.AddText(gm_color, "["..gm_title.."] ", Color(180,40,40), "Please do not break props, hide them instead!")

end)

net.Receive("SCAV_Winner", function()

	if sounds then surface.PlaySound("ambient/alarms/warningbell1.wav") end
	chat.AddText(gm_color, "["..gm_title.."] ", Color(255,255,0), net.ReadString(), Color(0,255,0), " has collected all the items and wins the round!")

end)

net.Receive("RND_Message", function()

	if sounds then surface.PlaySound("buttons/lightswitch2.wav") end
	chat.AddText(gm_color, "["..gm_title.."] ", Color(220,220,220), net.ReadString())

end)

net.Receive("HUD_Message", function()

	if message1 == "" then
	
		message1 = net.ReadString()
		message2 = net.ReadString()
		
		timer.Simple(5, function()
			message1 = ""
			message2 = ""
		end)
	end

end)