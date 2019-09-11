local HUDHelp = nil
local help_time = 20

net.Receive("HUD_FirstTimer", function()
    HUDHelp = vgui.Create("DPanel")
    HUDHelp:SetPos(8,ScrH()/2 - ScrH()*0.25)
    HUDHelp:SetSize(256, ScrH()/2)
    HUDHelp.Paint = function()
        draw.SimpleTextOutlined("How to play:", "DermaLarge", 8, 0, Color(0,0,255,math.abs(math.sin(CurTime()*4))*25.5), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("Auto-closes in 20 seconds -", "Trebuchet18", 8, 28, Color(255,255,255), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("You will not see this window again~", "Trebuchet18", 8, 42, Color(255,255,255), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("Default Key                Action", "Trebuchet18", 8, 78, Color(80,255,80), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("[ C ]           Scavenger List", "ChatFont", 8, 96, Color(255,255,255), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("[F1]           Help / Settings", "ChatFont", 8, 118, Color(255,255,255), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("[F2]           Team Select", "ChatFont", 8, 140, Color(255,255,255), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("[F3]           Model Select", "ChatFont", 8, 162, Color(255,255,255), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("[F4]           Upgrades", "ChatFont", 8, 184, Color(255,200,200), 0, 0, 1, Color(0,0,0))
        draw.SimpleTextOutlined("[ E ]           Collect/Pickup", "ChatFont", 8, 206, Color(255,200,200), 0, 0, 1, Color(0,0,0))
    end
    
    timer.Create("HUDFirstTimerHelp", help_time, 1, function()
        HUDHelp:Remove()
    end)
    
end)