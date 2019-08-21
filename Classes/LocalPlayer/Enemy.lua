local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer

function LocalPlayer:AutoTarget(Yards)
    if not self.Target and self.Combat then
        for k,v in pairs(DMW.Enemies) do
            if v.Distance <= Yards then
                TargetUnit(v.Pointer)
                return true
            end
        end
    end
end

function LocalPlayer:GetEnemies(Yards)
    local Table = {}
    local Count = 0
    for _, v in pairs(DMW.Enemies) do
        if v.Distance <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function LocalPlayer:GetAttackable(Yards)
    local Table = {}
    local Count = 0
    for _, v in pairs(DMW.Attackable) do
        if v.Distance <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function LocalPlayer:GetEnemiesRect(Length, Width, TTD)
    local Count = 0
    local Table, TableCount = self:GetEnemies(Length)
    if TableCount > 0 then
        TTD = TTD or 0
        local Facing = ObjectFacing(self.Pointer)
        local nlX, nlY, nlZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, Width/2, Facing + math.rad(90), 0)
        local nrX, nrY, nrZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, Width/2, Facing + math.rad(270), 0)
        local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, Length, Facing, 0)
        for _, Unit in pairs(Table) do
            if Unit.PosX > nlX and Unit.PosX < frX and Unit.PosY > nlY and Unit.PosY < frY and Unit.TTD >= TTD then
                Count = Count + 1
            end
        end
    end
    return Count
end

function LocalPlayer:GetEnemiesCone(Length, Angle, TTD)
    local Count = 0
    local Table, TableCount = self:GetEnemies(Length)
    if TableCount > 0 then
        TTD = TTD or 0
        local Facing = ObjectFacing(self.Pointer)
        for _, Unit in pairs(Table) do
            if Unit.TTD >= TTD and UnitIsFacing(self.Pointer, Unit.Pointer, Angle/2) then
                Count = Count + 1
            end
        end
    end
    return Count
end