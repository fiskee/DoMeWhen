local DMW = DMW
DMW.Helpers.Rotation = {}
local Rotation = DMW.Helpers.Rotation

function Rotation.Active(CastingCheck)
    CastingCheck = CastingCheck or true
    if DMW.Settings.profile.HUD.Rotation == 1 and DMW.Helpers.Navigation.Mode ~= 2 and (not CastingCheck or not DMW.Player.Casting) and not (IsMounted() or IsFlying()) and not DMW.Player.NoControl and 
        (not DMW.Player.Spells.FocusedAzeriteBeam:LastCast() or (DMW.Player.LastCast[1].SuccessTime and (DMW.Time - DMW.Player.LastCast[1].SuccessTime) > 0.2)) then
        return true
    end
    return false
end

function Rotation.GetSpellByID(SpellID)
    local SpellName = GetSpellInfo(SpellID)
    for _, Spell in pairs(DMW.Player.Spells) do
        if Spell.SpellName == SpellName then
            return Spell
        end
    end
end

function Rotation.RawDistance(X1, Y1, Z1, X2, Y2, Z2)
    return sqrt(((X1 - X2) ^ 2) + ((Y1 - Y2) ^ 2) + ((Z1 - Z2) ^ 2))
end

function Rotation.Setting(Setting)
    return DMW.Settings.profile.Rotation[Setting]
end

function Rotation.Defensive()
    local CastSpellID, ChannelSpellID
    for Pointer, _ in ipairs(DMW.Enemies) do
        CastSpellID = select(9, UnitCastingInfo(Pointer))
        ChannelSpellID = select(8, UnitChannelInfo(Pointer))
        if CastSpellID and DMW.Enums.DefensiveCast[CastSpellID] then
            return true
        elseif ChannelSpellID and DMW.Enums.DefensiveCast[ChannelSpellID] then
            return true
        end
    end
    for SpellID, _ in pairs(DMW.Enums.DefensiveDebuff) do
        if DMW.Player:AuraByID(SpellID) then
            return true
        end
    end
end