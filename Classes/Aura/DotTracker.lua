local DMW = DMW
DMW.Tables.PMultiplier = {}
DMW.Tables.Exsanguinated = {}
local Debuff = DMW.Classes.Debuff

function Debuff:PMultiplier(Unit)
    Unit = Unit or DMW.Player.Target
    if not DMW.Tables.PMultiplier[self.SpellName] then
        DMW.Tables.PMultiplier[self.SpellName] = {}
    end
    if DMW.Tables.PMultiplier[self.SpellName][Unit.GUID] then
        return DMW.Tables.PMultiplier[self.SpellName][Unit.GUID]
    end
    return 1
end

function Debuff:Exsanguinated(Unit)
    Unit = Unit or DMW.Player.Target
    if not DMW.Tables.Exsanguinated[self.SpellName] then
        DMW.Tables.Exsanguinated[self.SpellName] = {}
    end
    return DMW.Tables.Exsanguinated[self.SpellName][Unit.GUID] ~= nil
end

function Debuff:SetPMultiplier(GUID)
    if not DMW.Tables.PMultiplier[self.SpellName] then
        DMW.Tables.PMultiplier[self.SpellName] = {}
    end
    if DMW.Player.SpecID == 259 then
        if DMW.Rotations.ROGUE.Stealth() then
            if DMW.Player.Talents.Subterfuge.Active and self.SpellID == DMW.Player.Debuffs.Garrote.SpellID then
                DMW.Tables.PMultiplier[self.SpellName][GUID] = 1.8
            elseif DMW.Player.Talents.Nightstalker.Active then
                DMW.Tables.PMultiplier[self.SpellName][GUID] = 1.5
            end
        end
    end
end

function Debuff:ResetPMultiplier(GUID)
    if not DMW.Tables.PMultiplier[self.SpellName] then
        DMW.Tables.PMultiplier[self.SpellName] = {}
    end
    if DMW.Tables.PMultiplier[self.SpellName][GUID] then
        DMW.Tables.PMultiplier[self.SpellName][GUID] = nil
    end
end

function Debuff:AddExsanguinate(GUID)
    if not DMW.Tables.Exsanguinated[self.SpellName] then
        DMW.Tables.Exsanguinated[self.SpellName] = {}
    end
    DMW.Tables.Exsanguinated[self.SpellName][GUID] = true
end

function Debuff:ResetExsanguinate(GUID)
    if not DMW.Tables.Exsanguinated[self.SpellName] then
        DMW.Tables.Exsanguinated[self.SpellName] = {}
    end
    if DMW.Tables.Exsanguinated[self.SpellName][GUID] then
        DMW.Tables.Exsanguinated[self.SpellName][GUID] = nil
    end
end