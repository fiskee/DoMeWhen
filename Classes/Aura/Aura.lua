local DMW = DMW
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff

function Buff:New(SpellID)
    self.SpellID = SpellID
    self.SpellName = GetSpellInfo(self.SpellID)
end

function Debuff:New(SpellID)
    self.SpellID = SpellID
    self.SpellName = GetSpellInfo(self.SpellID)
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