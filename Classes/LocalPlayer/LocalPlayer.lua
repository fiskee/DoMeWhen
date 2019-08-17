local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer

function LocalPlayer:New(Pointer)
    self.Pointer = Pointer
    self.Name = UnitName(Pointer)
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.GUID = ObjectGUID(Pointer)
    self.Class = select(2, UnitClass(Pointer)):gsub("%s+", "")
    self.SpecID = GetSpecializationInfo(GetSpecialization())
    self.Spec = DMW.Enums.Specs[self.SpecID] or ""
    self.Distance = 0
    self.EID = false
    DMW.Functions.AuraCache.Refresh(Pointer)
    self:GetSpells()
    self:GetTalents()
    self:GetTraits()
    self:GetEssences()
end

function LocalPlayer:Update()
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Health = UnitHealth(self.Pointer)
    self.HealthMax = UnitHealthMax(self.Pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.Power = UnitPower(self.Pointer)
    self.PowerMax = UnitPowerMax(self.Pointer)
    self.PowerPct = self.Power / self.PowerMax * 100
    self.PowerRegen = GetPowerRegen()
    self.Instance = select(2, IsInInstance())
    self.Casting = UnitCastingInfo(self.Pointer) or UnitChannelInfo(self.Pointer)
    self.Combat = UnitAffectingCombat(self.Pointer)
    self.Moving = GetUnitSpeed(self.Pointer) > 0
    self.PetActive = UnitIsVisible("pet")
    self.InGroup = IsInGroup()
end

function LocalPlayer:GCD()
    if DMW.Enums.GCDOneSec[self.SpecID] then
        return 1
    else
        return math.max(1.5 / (1 + GetHaste() / 100), 0.75)
    end
end

function LocalPlayer:GCDMax()
    if DMW.Enums.GCDOneSec[self.SpecID] then
        return 1
    else
        return 1.5
    end
end

function LocalPlayer:CDs()
    if DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 3 then
        return false
    elseif DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 2 then
        return true
    elseif self.Target and self.Target:IsBoss() then
        return true
    end
    return false
end

function LocalPlayer:CritPct()
    return GetCritChance()
end

function LocalPlayer:TTM()
    local PowerMissing = self.PowerMax - self.Power
    if PowerMissing > 0 then
        return PowerMissing / self.PowerRegen
    else
        return 0
    end
end

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
    local EnemyTable = {}
    local Count = 0
    for _, v in pairs(DMW.Enemies) do
        if v:GetDistance(self) <= Yards then
            table.insert(EnemyTable, v)
            Count = Count + 1
        end
    end
    return EnemyTable, Count
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
