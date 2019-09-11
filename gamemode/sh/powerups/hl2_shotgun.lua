
local HL2Shotgun = {} 
HL2Shotgun.name		       = "Shotgun"
HL2Shotgun.short		       = "Purchase a Shotgun!"
HL2Shotgun.description      = "Turn your enemies"
HL2Shotgun.id               = "hl2_shotgun"
HL2Shotgun.price            = 120

if (SERVER) then

    HL2Shotgun.exec = function(ply)
        if ply:GetCredits() >= HL2Shotgun.price then
        
            ply:SetCredits(ply:GetCredits() - HL2Shotgun.price)
            ply:Give("weapon_shotgun")
            ply:GiveAmmo(40, 7, false)
            return true
            
        else return false
        end
    end
end

hook.Add("OnGamemodeLoaded", "AddHL2Shotgun", function()
    table.insert(power_up, HL2Shotgun)
end)