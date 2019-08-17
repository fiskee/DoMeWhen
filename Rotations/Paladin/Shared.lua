local DMW = DMW
DMW.Rotations.PALADIN = {}
local Paladin = DMW.Rotations.PALADIN

function Paladin.ConsActive()
    if DMW.Player.Consecration then
        return true
    end
    return false
end

function Paladin.ConsDistance()
    if DMW.Player.Consecration then
        local X, Y, Z = DMW.Player.Consecration.PosX, DMW.Player.Consecration.PosY, DMW.Player.Consecration.PosZ
        local PX, PY, PZ = DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ
        return sqrt(((X - PX) ^ 2) + ((Y - PY) ^ 2) + ((Z - PZ) ^ 2))
    end
    return 99
end

function Paladin.ConsRemain()
    local active, _, startTime, duration = GetTotemInfo(1)
    if active then
        return startTime + duration - DMW.Time
    end
    return 0
end