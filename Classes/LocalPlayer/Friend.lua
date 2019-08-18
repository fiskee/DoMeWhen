local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer

function LocalPlayer:GetFriends(Yards)
    local Table = {}
    local Count = 0
    for _, v in pairs(DMW.Friends.Units) do
        if v.Distance <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function LocalPlayer:GetFriendsRect(Length, Width, HP)
    local Count = 0
    local Table, TableCount = self:GetFriends(Length)
    if TableCount > 0 then
        HP = HP or 100
        local Facing = ObjectFacing(self.Pointer)
        local nlX, nlY, nlZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, Width/2, Facing + math.rad(90), 0)
        local nrX, nrY, nrZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, Width/2, Facing + math.rad(270), 0)
        local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, Length, Facing, 0)
        for _, Unit in pairs(Table) do
            if Unit.PosX > nlX and Unit.PosX < frX and Unit.PosY > nlY and Unit.PosY < frY and Unit.HP <= HP then
                Count = Count + 1
            end
        end
    end
    return Count
end

function LocalPlayer:GetFriendsCone(Length, Angle, HP)
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