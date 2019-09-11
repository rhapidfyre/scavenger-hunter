
    net.Receive("SCAV_PurchasePU", function(len, ply)
    
        local upgrade = net.ReadString()
        local up = nil
        
        -- Loops through power_up table and sets "up" to the chosen upgrade
        for k,v in pairs (power_up) do
        
            -- If requested upgrade is found in the table
            if upgrade == v.id then
                up = v
            end
        end
        
        -- If <upgrade>.exec returns false, they don't have the cash for it
        if !(up.exec(ply)) then
            ply:PrintMessage(HUD_PRINTCENTER, "NOT ENOUGH CREDITS")
        end
        
    end)