
function GM:PropBreak(ply, prop)

	net.Start("SCAV_Break")
		net.Send(ply)
		
	local newprop = ents.Create("prop_physics_multiplayer")
	newprop:SetPos(prop:GetPos())
	newprop:SetModel(prop:GetModel())
	newprop:SetAngles(prop:GetAngles())
	newprop:SetVelocity(prop:GetVelocity())
	newprop:Spawn()
	
	newprop:SetHealth(9999)
	
	sound.Play("friends/friend_online.wav", newprop:GetPos())
	
end