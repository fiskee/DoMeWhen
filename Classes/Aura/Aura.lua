local DMW = DMW
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff

function Buff:New(SpellID, BaseDuration)
    self.SpellID = SpellID
    self.SpellName = GetSpellInfo(self.SpellID)
    self.BaseDuration = BaseDuration
end

function Debuff:New(SpellID, BaseDuration)
    self.SpellID = SpellID
    self.SpellName = GetSpellInfo(self.SpellID)
    self.BaseDuration = BaseDuration
end

function Buff:Exist(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player
    return self:Query(Unit, OnlyPlayer) ~= nil
end

function Debuff:Exist(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player.Target
    return self:Query(Unit, OnlyPlayer) ~= nil
end

function Buff:Remain(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player
    local EndTime = select(6, self:Query(Unit, OnlyPlayer))
    if EndTime then
        if EndTime == 0 then
            return 999
        end
        return (EndTime - DMW.Time)
    end
    return 0
end

function Debuff:Remain(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player.Target
    local EndTime = select(6, self:Query(Unit, OnlyPlayer))
    if EndTime then
        if EndTime == 0 then
            return 999
        end
        return (EndTime - DMW.Time)
    end
    return 0
end

function Buff:Duration(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player
    local Duration = select(5, self:Query(Unit, OnlyPlayer))
    if Duration then
        return Duration
    end
    return 0
end

function Debuff:Duration(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player.Target
    local Duration = select(5, self:Query(Unit, OnlyPlayer))
    if Duration then
        return Duration
    end
    return 0
end

function Buff:Elapsed(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player
    local EndTime = select(6, self:Query(Unit, OnlyPlayer))
    local Duration = select(5, self:Query(Unit, OnlyPlayer))
    if EndTime and Duration then
        if EndTime == 0 then
            return 999
        end
        return DMW.Time - (EndTime - Duration)
    end
    return 0
end

function Debuff:Elapsed(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player.Target
    local EndTime = select(6, self:Query(Unit, OnlyPlayer))
    local Duration = select(5, self:Query(Unit, OnlyPlayer))
    if EndTime and Duration then
        if EndTime == 0 then
            return 999
        end
        return DMW.Time - (EndTime - Duration)
    end
    return 0
end

function Buff:Refresh(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player
    local Remain = self:Remain(Unit, OnlyPlayer)
    if Remain > 0 then
        local Duration = self.BaseDuration or self:Duration()
        return Remain < (Duration * 0.3)
    end
    return true
end

function Debuff:Refresh(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player.Target
    local Remain = self:Remain(Unit, OnlyPlayer)
    if Remain > 0 then
        local Duration = self.BaseDuration or self:Duration()
        return Remain < (Duration * 0.3)
    end
    return true
end

function Buff:Stacks(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player
    local Stacks = select(3, self:Query(Unit, OnlyPlayer))
    if Stacks then
        return Stacks
    end
    return 0
end

function Debuff:Stacks(Unit, OnlyPlayer)
    OnlyPlayer = OnlyPlayer or true
    Unit = Unit or DMW.Player.Target
    local Stacks = select(3, self:Query(Unit, OnlyPlayer))
    if Stacks then
        return Stacks
    end
    return 0
end

function Buff:Lowest(Table)
    local LowestSec, LowestUnit
    for _, v in pairs(Table) do
        if not LowestSec or self:Remain(v) < LowestSec then
            LowestSec = self:Remain(v)
            LowestUnit = v
        end
    end
    return LowestUnit
end

function Debuff:Lowest(Table)
    local LowestSec, LowestUnit
    for _, v in pairs(Table) do
        if not LowestSec or self:Remain(v) < LowestSec then
            LowestSec = self:Remain(v)
            LowestUnit = v
        end
    end
    return LowestUnit
end