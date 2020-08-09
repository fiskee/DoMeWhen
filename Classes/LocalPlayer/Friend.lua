local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer

local function IsInside(x, y, ax, ay, bx, by, dx, dy) -- Stolen at BadRotations
    local bax = bx - ax
    local bay = by - ay
    local dax = dx - ax
    local day = dy - ay
    if ((x - ax) * bax + (y - ay) * bay <= 0.0) then
        return false
    end
    if ((x - bx) * bax + (y - by) * bay >= 0.0) then
        return false
    end
    if ((x - ax) * dax + (y - ay) * day <= 0.0) then
        return false
    end
    if ((x - dx) * dax + (y - dy) * day >= 0.0) then
        return false
    end
    return true
end

function LocalPlayer:GetFriends(Yards, HP)
    local Table = {}
    local Count = 0
    for _, v in ipairs(DMW.Friends.Units) do
        if v.Distance <= Yards and (not HP or v.HP < HP) then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function LocalPlayer:GetFriendsInCone(Length, Angle, HP)
    local Count = 0
    local Table, TableCount = self:GetFriends(Length)
    if TableCount > 0 then
        HP = HP or 100
        local Facing = ObjectFacing(self.Pointer)
        for _, Unit in pairs(Table) do
            if Unit.HP <= HP and UnitIsFacing(self.Pointer, Unit.Pointer, Angle/2) then
                Count = Count + 1
            end
        end
    end
    return Count
end

function LocalPlayer:GetFriendsInRect(Length, Width, HP)
    local Count = 0
    local Table, TableCount = self:GetFriends(Length)
    if TableCount > 0 then
        TTD = TTD or 0
        local Facing = ObjectFacing(self.Pointer)
        local nlX, nlY, nlZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, Width / 2, Facing + math.rad(90), 0)
        local nrX, nrY, nrZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, Width / 2, Facing + math.rad(270), 0)
        local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, Length, Facing, 0)
        for _, Unit in pairs(Table) do
            if Unit.HP <= HP and IsInside(Unit.PosX, Unit.PosY, nlX, nlY, nrX, nrY, frX, frY) then
                Count = Count + 1
            end
        end
    end
    return Count
end