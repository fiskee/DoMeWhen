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