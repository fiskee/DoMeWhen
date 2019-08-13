local DMW = DMW
local Spell = DMW.Classes.Spell

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
            CastSpellByName(self.SpellName, Unit.Pointer)
            self.LastBotTarget = Unit.Pointer
        end
        --print("Casted: " .. self.SpellName)
        return true
    end
    return false
end