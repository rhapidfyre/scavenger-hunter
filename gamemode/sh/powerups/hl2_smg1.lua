
local HL2SMG1 = {} 
HL2SMG1.name		        = "Submachine Gun"
HL2SMG1.short		    = "Purchase an SMG!"
HL2SMG1.description      = "pewpewpewpewpew"
HL2SMG1.id               = "hl2_smg1"
HL2SMG1.price            = 300



if (SERVER) then

    HL2SMG1.exec = function(ply)
        if ply:GetCredits() >= HL2SMG1.price then
        
            ply:SetCredits(ply:GetCredits() - HL2SMG1.price)
            ply:Give("weapon_smg1")
            ply:GiveAmmo(240, 4, false)
            return true
            
        else return false
        end
    end
end

hook.Add("OnGamemodeLoaded", "AddHL2SMG1", function()
    table.insert(power_up, HL2SMG1)
end)