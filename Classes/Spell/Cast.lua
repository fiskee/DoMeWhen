local DMW = DMW
local Spell = DMW.Classes.Spell

local function FacingCast(SpellName, Target)
	local CastTime = select(4, GetSpellInfo(SpellName))
	if CastTime == 0 and UnitIsVisible(Target or "Target") and not ObjectIsFacing("Player", Target or "Target") and not UnitIsUnit("Player", Target or "Target") then
		local Facing = ObjectFacing("Player")
		local MouselookActive = false
		if IsMouselooking() then
			MouselookActive = true
			MouselookStop()
		end
		FaceDirection(Target or "Target", true)
		CastSpellByName(SpellName, Target)
		FaceDirection(Facing)
		if MouselookActive then
			MouselookStart()
		end
		C_Timer.After(0.1, function()
			FaceDirection(ObjectFacing("player"), true)
        end)
	else
		CastSpellByName(SpellName, Target)
	end
end

function Spell:Cast(Unit)
    if not Unit then
        if self.IsHarmful and DMW.Player.Target then
            Unit = DMW.Player.Target
        elseif self.IsHelpful then
            Unit = DMW.Player
        end
    end
    if self:IsReady() and (Unit.Distance <= self.MaxRange or IsSpellInRange(self.SpellName, Unit.Pointer) == 1) then
        if self.CastType == "Ground" then
            CastSpellByName(self.SpellName)
            ClickPosition(Unit.PosX, Unit.PosY, Unit.PosZ)
            self.LastBotTarget = Unit.Pointer
        else
            FacingCast(self.SpellName, Unit.Pointer)
            self.LastBotTarget = Unit.Pointer
        end
        --print("Casted: " .. self.SpellName)
        return true
    end
    return false
end