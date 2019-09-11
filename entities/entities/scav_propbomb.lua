
AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName		= "Prop Bomb"
ENT.Author			= "RhapidFyre"
ENT.Purpose			= "Trick Your Opponents!"

-- This following section updates client menus. It must all be given values!
local PropBomb = {}
PropBomb.name		    = "Prop Bomb"
PropBomb.short		    = "Trick Your Opponents!"
PropBomb.description    = "This spawns a prop in front of you that looks like an item from the enemies scavenger hunt list. However, this tricky little guy EXPLODES when the player presses (E) on the object, consuming them in a gigantic ball of fire!"
PropBomb.id             = "scav_propbomb"
PropBomb.price          = 10
--------------------------------------------------------

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end


function ENT:OnRemove()
end


function ENT:PhysicsCollide( data, physobj )
end


function ENT:PhysicsUpdate( physobj )
end

if ( CLIENT ) then
	function ENT:Draw() self:DrawModel()
    end
end

if (SERVER) then

    PropBomb.exec = function(ply)
    
        if ply:GetCredits() >= PropBomb.price then
        
            ply:SetCredits(ply:GetCredits() - PropBomb.price)
            
            bomb = ents.Create("scav_propbomb")
            bomb:SetNWInt("team", ply:Team())
            bomb:SetNWEntity("owner", ply)
            bomb:SetPos(ply:GetShootPos() + ply:GetAimVector()*96)
            bomb:Spawn()
            return true
        else
            return false
        end
    end

	function ENT:StartTouch( entity )
	end

	function ENT:EndTouch( entity )
	end

	function ENT:Touch( entity )
	end

	function ENT:Use(activator, user, use_type, value)
        if activator:IsPlayer() then
            if (team_game and activator:Team() != self:GetNWInt("team")) or (!team_game and activator != self:GetNWEntity("owner")) then
                boom = ents.Create("env_explosion")
                boom:SetPos(self:GetPos())
                boom:SetOwner(activator)
                boom:Spawn()
                self:Remove()
                boom:SetKeyValue("iMagnitude", "220")
                boom:SetKeyValue("iRadiusOverride", "128")
                boom:Fire("Explode", "", 0)
                boom:EmitSound("ambient/explosions/explode_"..math.random(1, 9)..".wav")
                PrintMessage(HUD_PRINTTALK, activator:GetName().." discovered a bomb prop!")
                
            else
                if self:IsPlayerHolding() then return end
                    activator:PickupObject(self)
            end
            
        end
        self.last_use = CurTime()
	end
	
	function ENT:Initialize()
        -- If each team has a unique list
        if team_game and use_differ_lists then
        
            -- Prop model must match the opposing team's list=
            if self:GetNWInt("team") == 1 then
                self:SetModel(table.Random(round.round_blist))
            else
                self:SetModel(table.Random(round.round_rlist))
            end
            
        -- Otherwise use the master list.
        else
            self:SetModel(table.Random(round.round_list))
        end
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_BBOX )
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
        
		self.last_use = CurTime()
        self:SetUseType(SIMPLE_USE)
	end
    
	function ENT:PhysicsSimulate( phys, deltatime )
		return SIM_NOTHING
	end

end

hook.Add("OnGamemodeLoaded", "AddPropBomb", function()
    table.insert(power_up, PropBomb)
end)
