
local SpeedBoost = {} 
SpeedBoost.name		        = "Speed Boost"
SpeedBoost.short		    = "Run as fast as Chuck Norris!"
SpeedBoost.description      = "Increases your run speed by x2 for 30 seconds!"
SpeedBoost.id               = "scav_speed_boost"
SpeedBoost.price            = 125



if (SERVER) then

    hook.Add("PostCleanupMap", "ResetSpeeds", function()
        for _,ply in pairs (player.GetAll()) do
            if ply:GetWalkSpeed() > 200 then
                ply:SetWalkSpeed(200)
                ply:SetRunSpeed(200)
            end
        end
    end)

    SpeedBoost.exec = function(ply)
        if ply:GetCredits() >= SpeedBoost.price then
        
            ply:SetCredits(ply:GetCredits() - SpeedBoost.price)
            ply:SetWalkSpeed(500)
            ply:SetRunSpeed(500)
            timer.Simple(30, function()
                ply:SetWalkSpeed(200)
                ply:SetRunSpeed(200)
            end)
            return true
            
        else return false
        end
    end
end

hook.Add("OnGamemodeLoaded", "AddSpeedBoost", function()
    table.insert(power_up, SpeedBoost)
end)