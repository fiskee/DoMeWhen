local DMW = DMW
DMW.Helpers.Rotation = {}
local Rotation = DMW.Helpers.Rotation
local Player = DMW.Player

function Rotation.Active()
    if DMW.Settings.profile.Active and not (IsMounted() or IsFlying()) then
        return true
    end
    return false
end

function Rotation.GetSpellByID(SpellID)
    for _, Spell in pairs(DMW.Player.Spells) do
        if Spell.SpellID == SpellID then
            return Spell
        end
    end
end

function Rotation.RawDistance(X1, Y1, Z1, X2, Y2, Z2)
    return sqrt(((X1 - X2) ^ 2) + ((Y1 - Y2) ^ 2) + ((Z1 - Z2) ^ 2))
end