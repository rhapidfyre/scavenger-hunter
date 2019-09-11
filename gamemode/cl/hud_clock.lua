
--[[

	If you want to make a custom clock, replace this file with your new HUD Clock.
	The following steps must be noted for your custom HUD Clock to work correctly.
	
	Step 1)		Hook into "HUDPaint"
	Step 2)		Important Values:
	
		GetGlobalInt("RoundTimeLeft") 	/or/ 	net.Receive("RND_Clock")
										-> 	Round Timeleft, unformatted integer value
											Using net.Receive version includes both timeleft and round status
										
		GetGlobalInt("RoundStatus") 	-> 	Round Status, unformatted integer value
										
		status							-> 	Numeric Value of round status
		
											0 = Stale
											1 = Preparing
											2 = Active
											3 = Intermission/Break
	
		collected (variable)			-> How many props have been collected so far
		#inventory (length of table)	-> How many props needed to win
		sounds (bool variable)			-> Boolean for whether to play sounds or not
		
]]

function VOXRemaining()
    if sounds then
        if status == 2 then
            if clock == 62 then
            surface.PlaySound("hl1/fvox/time_remaining.wav")
            timer.Simple(2, function() surface.PlaySound("hl1/fvox/60.wav") end)
            timer.Simple(3, function() surface.PlaySound("hl1/fvox/seconds.wav") end)
            elseif clock == 30 then
            surface.PlaySound("hl1/fvox/30.wav")
            timer.Simple(1, function() surface.PlaySound("hl1/fvox/seconds.wav") end)
            timer.Simple(2, function() surface.PlaySound("hl1/fvox/remaining.wav") end)
            elseif clock < 6 then
                if clock > 0 then
                    surface.PlaySound("hl1/fvox/"..(clock)..".wav")
                end
            -- Clock can't equal zero because the round updates before it gets here so we'll set it to 1 and make a 1 second timer
            elseif clock == 1 then
                timer.Simple(1, function() surface.PlaySound("ambient/alarms/warningbell1.wav") end)
            end
        end
    end
end

-- Turns our int status into a string status players can understand
local function IntToString(value)
	if value == 0 then 		return "Waiting"
	elseif value == 1 then 	return "Prep Round"
	elseif value == 2 then 	return "In Progress"
	elseif value == 3 then 	return "Intermission"
	else 					return "-ERROR-"
	end
end

local function TimeFlash()

	if clock < 11 then
		return math.abs(math.sin(CurTime()*3)*200)
	else
		return 200
	end

end

-- Draw the HUD Clock
local function HUDClock()

	draw.RoundedBoxEx(4,(ScrW()/2)-384,0,768,24,team.GetColor(LocalPlayer():Team()),false,false,true,true)
	draw.RoundedBoxEx(8,(ScrW()/2)-96,0,192,48,Color(80,80,80,255),false,false,true,true)
	
	draw.RoundedBoxEx(16,(ScrW()/2)-92,4,184,40,Color(20,20,20),true,true,false,false)	-- Black background
	surface.SetDrawColor(40,40,40,255)
	surface.DrawRect((ScrW()/2)-382, 2, 268, 20)	-- Props Collected Background
	surface.DrawRect((ScrW()/2)+114, 2, 268, 20)	-- Round Status Background
	
	draw.SimpleText("Props Collected:", "TargetIDSmall", (ScrW()/2)-378, 4, Color(200,200,200), 0, 0)
	draw.SimpleText(collected, "TargetIDSmall", (ScrW()/2)-146, 4, Color(80,255,80), 2, 0)
	draw.SimpleText("/"..(#scavenger_list), "TargetIDSmall", (ScrW()/2)-146, 4, Color(200,200,200), 0, 0)
	
	draw.SimpleText("Round Status:", "TargetIDSmall", (ScrW()/2)+118, 4, Color(200,200,200), 0, 0)
	draw.SimpleText(IntToString(status), "TargetIDSmall", (ScrW()/2)+378, 4, Color(0,255,0), 2, 0)
	
	local clocktime 	= 1
	local flash			= 200
	
	if status != 0 then
		clocktime		= clock
		if status == 2 then
			flash 		= TimeFlash()
		end
	end
	
	if status != 0 then
		draw.SimpleText(string.FormattedTime(clocktime, "%02i:%02i"), "HUDClock2", ScrW()/2, 2, Color(200,flash,flash), 1, 0)
		draw.SimpleText(string.FormattedTime(clocktime, "%02i:%02i"), "HUDClock1", ScrW()/2, 2, Color(200,flash,flash), 1, 0)
	end
	
end

-- Add the Custom HUD Clock
hook.Add("HUDPaint", "timeleft", function()
    if LocalPlayer():Team() > 0 and LocalPlayer():Team() < 4 then
        HUDClock()
    end
end)
