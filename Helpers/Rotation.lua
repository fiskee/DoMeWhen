local DMW = DMW
DMW.Helpers.Rotation = {}
local Rotation = DMW.Helpers.Rotation

function Rotation.Active(CastingCheck)
    if DMW.Settings.profile.HUD.Rotation == 1 and DMW.Helpers.Navigation.Mode ~= 2 and (CastingCheck ~= nil or not DMW.Player.Casting) and not (IsMounted() or IsFlying()) and not DMW.Player.NoControl then
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
    local CastID, ChannelID
    for _, Unit in ipairs(DMW.Enemies) do
        CastID, ChannelID = UnitCastID(Unit.Pointer)
        if CastID and DMW.Enums.DefensiveCast[CastID] then
            return true
        elseif ChannelID and DMW.Enums.DefensiveCast[ChannelID] then
            return true
        end
    end
    for SpellID, _ in pairs(DMW.Enums.DefensiveDebuff) do
        if DMW.Player:AuraByID(SpellID) then
            return true
        end
    end
end