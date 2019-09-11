
-- Since we're using this multiple times, and it's static, declaring once and done
local color_bkg = Color(80,80,80,255)

--[[
	Table is used to detect weapons that don't have clips, and instead, use PrimaryAmmoType as the clip
	Add all custom weapons to this table if the custom weapon doesn't use clips
	(RPG, Slams, Grenades, etc)
]]
local NonClipWeapons = {
	["weapon_rpg"] = true,
	["weapon_slam"] = true,
	["weapon_frag"] = true
}

local function NewHealth()
	local myself = LocalPlayer()
	--					  r		 x			y		 	w		h		color								TopL	TopR	BtmL	BtmR
	draw.RoundedBoxEx	(10,		23,		ScrH()-97,		258,	66,		color_black,					false,	true,	false,	false)	-- Background Outline
	draw.RoundedBoxEx	(10,		24,		ScrH()-96,		256,	64,		color_bkg,						false,	true,	false,	false)	-- Background
	draw.RoundedBoxEx	(10,		26,		ScrH()-94,		252,	18,		team.GetColor(myself:Team()),	false, 	true, 	false, 	false)	-- Team Color Bar
	draw.RoundedBoxEx	(10,		26,		ScrH()-74,		64,		40,		color_black,					false,	false,	false,	true)	-- Health Box
	draw.RoundedBoxEx	(10,		92,		ScrH()-74,		64,		40,		color_black,					false,	false,	true,	true)	-- Armor Box
	draw.RoundedBoxEx	(10,		158,	ScrH()-74,		120,	40,		color_black,					false,	false,	true,	false)	-- Credits Box
	
	--						text										font			x.pos	y.pos		color					horz	vert	width	color2
	draw.SimpleTextOutlined	(string.upper(team.GetName(myself:Team())),	"ChatFont",		28,		ScrH()-95,	color_white,			0,		0,		1,		color_black)	-- Team Name
	draw.SimpleTextOutlined	("HEALTH",									"HUDFont2",		58,		ScrH()-72,	Color(255,25,25),		1,		0,		1,		color_black)	-- "HEALTH"
	draw.SimpleTextOutlined	(myself:Health(),							"HUDFont1",		58,		ScrH()-66,	Color(255,200,200),		1,		0,		1,		color_black)	-- Health Value
	draw.SimpleTextOutlined	("ARMOR",									"HUDFont2",		124,	ScrH()-72,	Color(255,255,25),		1,		0,		1,		color_black)	-- "ARMOR"
	draw.SimpleTextOutlined	(myself:Armor(),							"HUDFont1",		124,	ScrH()-66,	Color(255,255,200),		1,		0,		1,		color_black)	-- Armor Value
	draw.SimpleTextOutlined	("CREDITS",									"HUDFont2",		218,	ScrH()-72,	Color(25,255,25),		1,		0,		1,		color_black)	-- "CREDITS"
	draw.SimpleTextOutlined	(myself:GetCredits(),						"HUDFont1",		218,	ScrH()-66,	Color(200,255,200),		1,		0,		1,		color_black)	-- Credit Value
	
end

local function NewAmmo()

	local myself = LocalPlayer()
	
	--					 r		x				y		 	w		h			color						TopL	TopR	BtmL	BtmR
	draw.RoundedBoxEx	(10,	ScrW()-283,		ScrH()-97,	258,	66,		color_black,					true,	false,	false,	false)	-- Background Outline
	draw.RoundedBoxEx	(10,	ScrW()-282,		ScrH()-96,	256,	64,		color_bkg,						true,	false,	false,	false)	-- Background
	draw.RoundedBoxEx	(10,	ScrW()-280,		ScrH()-94,	252,	18,		team.GetColor(myself:Team()),	true,	false,	false,	false)	-- Team Color Bar
	draw.RoundedBoxEx	(16,	ScrW()-280,		ScrH()-74,	120,	40,		color_black,					false,	false,	false,	true)	-- Magazine Box
	draw.RoundedBoxEx	(16,	ScrW()-158,		ScrH()-74,	64,		40,		color_black,					false,	false,	true,	true)	-- Reserve Box
	draw.RoundedBoxEx	(16,	ScrW()-92,		ScrH()-74,	64,		40,		color_black,					false,	false,	true,	false)	-- Secondary Box
	
	local wepn = LocalPlayer():GetActiveWeapon()
	if wepn:IsValid() then
	
		local wClass = wepn:GetClass()
		local wName	 = string.upper(wepn:GetPrintName())
		
		-- If player's weapon has a name, display it
		if wName != nil and wName != "" then
			draw.SimpleTextOutlined(wName, "ChatFont", ScrW()-32, ScrH()-94, Color(255,255,255,255), 2, 0, 1, Color(0,0,0,255))
		end
		
		local ammo_num 	= wepn:Clip1()
		local pri_dash 	= LocalPlayer():GetAmmoCount(wepn:GetPrimaryAmmoType())
		local cValue = Color(255,255,255,255)
		
		-- if ammo_num isn't negative 1, then it uses a magazine/ammo clip
		if ammo_num != -1 then
		
			-- Find the percent of ammo player has remaining
			local ammo_percent  = math.Round(wepn:Clip1() / wepn:GetMaxClip1(), 2)
			local color			= ammo_percent * 255 -- Setup color var for flashing check below
			
			-- If the player has less than 18% ammo remaining, flash the value
			if ammo_percent < 0.18 then color = math.abs(math.sin(CurTime()*6)*255)	end
			
			-- Draw the reserve/spare ammo, this gun uses clips
			draw.SimpleText(LocalPlayer():GetAmmoCount(wepn:GetPrimaryAmmoType()), "HUDFont1", ScrW()-126, ScrH()-66, Color(200,200,200,255),TEXT_ALIGN_CENTER,0)
			cValue = Color(255,color,color,255)
			
		-- Otherwise, we want the CLIP position on the HUD to display the single-type ammo (RPG, Frags, etc)
		else
			if pri_dash >= 0 then
				ammo_num = pri_dash
			end
			pri_dash = "-"
		end
		
		-- Display Clip1 Ammo, or primary ammo if weapon isn't a clipped gun
		draw.SimpleText(ammo_num, "HUDAmmo1", ScrW()-220, ScrH()-77, cValue,TEXT_ALIGN_CENTER,0)
		
		-- Display spare ammo (or "-" if weapon doesn't use spare ammo)
		draw.SimpleTextOutlined	("SPARE",		"HUDFont2",		ScrW()-126,		ScrH()-72,	Color(200,200,200),		1,		0,		1,		color_black)	-- "SPARE"
		draw.SimpleText(pri_dash, "HUDFont1", ScrW()-126, ScrH()-66, Color(200,200,200,255),TEXT_ALIGN_CENTER,0)
		
		-- SECONDARY AMMO SLOT
		draw.SimpleTextOutlined	("SECONDARY",	"HUDFont2",		ScrW()-60,		ScrH()-72,	Color(200,200,200),		1,		0,		1,		color_black)	-- "SECONDARY"
		local secAmmo = LocalPlayer():GetAmmoCount(wepn:GetSecondaryAmmoType())
		if secAmmo > 0 then
			draw.SimpleText(secAmmo, "HUDFont1", ScrW()-60, ScrH()-66, Color(200,200,200,255),TEXT_ALIGN_CENTER,0)
		else
			draw.SimpleText("-", "HUDFont1", ScrW()-60, ScrH()-66, Color(200,200,200,255),TEXT_ALIGN_CENTER,0)
		end
	
	end
	
end

hook.Add("HUDPaint", "NewHUD", function()

	local ply = LocalPlayer()
	
	-- Make sure the HUD is only drawn iff the player is in no way a spectator, and not dead
	if !team_enums[ply:Team()] and ply:Alive() and ply:GetObserverMode() != 6 then
		NewHealth()
		NewAmmo()
	end
	
end)