local DMW = DMW
local Player, Buff, Debuff, Spell
local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript(
    "OnEvent",
    function(self, event)
        self:Reader(event, CombatLogGetCurrentEventInfo())
    end
)

function frame:Reader(event, ...)
    if EWT then
        timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
        Locals()
        DMW.Functions.AuraCache.Event(...)
        if source == Player.GUID then
            if Player.SpecID == 259 then --Assassination Rogue
                if param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH" then
                    if spellName == Debuff.Rupture.SpellName then
                        Debuff.Rupture:SetPMultiplier(destination)
                        Debuff.Rupture:ResetExsanguinate(destination)
                    elseif spellName == Debuff.Garrote.SpellName then
                        Debuff.Garrote:SetPMultiplier(destination)
                        Debuff.Garrote:ResetExsanguinate(destination)
                    end
                elseif param == "SPELL_AURA_REMOVED" then
                    if spellName == Debuff.Rupture.SpellName then
                        Debuff.Rupture:ResetPMultiplier(destination)
                        Debuff.Rupture:ResetExsanguinate(destination)
                    elseif spellName == Debuff.Garrote.SpellName then
                        Debuff.Garrote:ResetPMultiplier(destination)
                        Debuff.Garrote:ResetExsanguinate(destination)
                    end
                elseif param == "SPELL_CAST_SUCCESS" then
                    if spellName == Spell.Exsanguinate.SpellName then
                        Debuff.Rupture:AddExsanguinate(destination)
                        Debuff.Garrote:AddExsanguinate(destination)
                    end
                end
            end
        end
    end
end
