
local HL2Pistol = {} 
HL2Pistol.name		        = "Pistol"
HL2Pistol.short		    = "Purchase a Pistol!"
HL2Pistol.description      = "This pistol is handy for killing your enemies, because guns are dangerous!"
HL2Pistol.id               = "hl2_pistol"
HL2Pistol.price            = 50



if (SERVER) then

    HL2Pistol.exec = function(ply)
        if ply:GetCredits() >= HL2Pistol.price then
        
            ply:SetCredits(ply:GetCredits() - HL2Pistol.price)
            ply:Give("weapon_pistol")
            ply:GiveAmmo(90, 3, false)
            return true
            
        else return false
        end
    end
end

hook.Add("OnGamemodeLoaded", "AddHL2Pistol", function()
    table.insert(power_up, HL2Pistol)
end)