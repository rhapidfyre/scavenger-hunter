
surface.CreateFont(
"FloatFont1",
{
	font 		= "TargetID",
	extended 	= false,
	size 		= 14,
	weight 		= 100,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
}
)

surface.CreateFont(
"FloatFont2",
{
	font 		= "halflife2",
	extended 	= false,
	size 		= 16,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= true
}
)

iFlag = true

function HoveringNames()
	
	local flash = 255 - math.abs( math.sin(CurTime()) * 0.5 ) * 255
	for _, target in pairs(player.GetAll()) do
		if target:Alive() and target != LocalPlayer() then
		
			local dispCol = Color(255,255,80)
			if target:Team() == 1 then
				dispCol = Color(255,80,80)
			elseif target:Team() == 2 then
				dispCol = Color(80,80,255)
			end
			local targetPos = target:GetPos() + Vector(0,0,72)
			local targetDistance = math.floor((LocalPlayer():GetPos():Distance(targetPos)))
			local targetScreenpos = targetPos:ToScreen()
			
			if player_manager.GetPlayerClass(target) == "MEDIC" then symbol = "+" end
			
			if targetDistance <= 512 and LocalPlayer():IsLineOfSightClear(targetPos - Vector(0,0,8)) then
				draw.SimpleText(target:Nick(), "FloatFont1", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), dispCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			elseif targetDistance > 512 and LocalPlayer():IsLineOfSightClear(targetPos - Vector(0,0,8)) then
				draw.SimpleText("@", "FloatFont2", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), dispCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
		end
	end
    -- (DEBUG)
	for _, target in pairs(ents.FindByClass("info_player_*")) do
		local dispCol = Color(255,255,80)
		local targetPos = target:GetPos() + Vector(0,0,72)
		local targetDistance = math.floor((LocalPlayer():GetPos():Distance(targetPos)))
		local targetScreenpos = targetPos:ToScreen()
		
		draw.SimpleText("SPAWNPOINT", "BudgetLabel", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), dispCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		
	end
	
end

hook.Add("HUDPaint", "HoveringNames", HoveringNames)