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
    if self:IsReady() and Unit.Distance <= self.MaxRange then
        CastSpellByName(self.SpellName, Unit.Pointer)
        self.LastBotTarget = Unit.Pointer
        return true
    end
    return false
end