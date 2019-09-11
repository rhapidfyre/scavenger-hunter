
local AmmoRe = {} 
AmmoRe.name		        = "Ammo Resupply"
AmmoRe.short		    = "Resupply Current Gun's Ammo!"
AmmoRe.description      = "Give 100 rounds of ammunition for the gun you are holding when you buy this power up!"
AmmoRe.id               = "scav_ammo_resupply"
AmmoRe.price            = 25

if (SERVER) then
    AmmoRe.exec = function(ply)
        if ply:GetCredits() >= AmmoRe.price then
        
            local weapon = ply:GetActiveWeapon()
            
            if weapon:GetMaxClip1() > 0 and weapon:GetPrimaryAmmoType() >= 0 then
            
                ply:SetCredits(ply:GetCredits() - AmmoRe.price)
                
                local ammoType  = weapon:GetPrimaryAmmoType()
                ply:GiveAmmo(100, ammoType, false)
                
            end
            return true
        else return false
        
        end
    end
end

hook.Add("OnGamemodeLoaded", "AddAmmoRe", function()
    table.insert(power_up, AmmoRe)
end)