local DMW = DMW
local Unit = DMW.Classes.Unit

function Unit:New(Pointer)
    self.Pointer = Pointer
    self.Name = UnitName(Pointer)
    self.Player = UnitIsPlayer(Pointer)
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.ObjectID = ObjectID(Pointer)
    DMW.Functions.AuraCache.Refresh(Pointer)
end

function Unit:Update()
    self.NextUpdate = DMW.Time + (math.random(100, 400) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    self.Dead = UnitIsDeadOrGhost(self.Pointer)
    self.Health = UnitHealth(self.Pointer)
    self.HealthMax = UnitHealthMax(self.Pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.TTD = self:GetTTD()
    self.LoS = false
    if self.Distance < 50 and not self.Dead then
        self.LoS = self:LineOfSight()
    end
    self.ValidEnemy = self:IsEnemy()
    self.Target = UnitTarget(self.Pointer)
    self.Moving = GetUnitSpeed(self.Pointer) > 0
end

function Unit:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2)) - ((self.CombatReach or 0) + (OtherUnit.CombatReach or 0))
end

function Unit:LineOfSight(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return TraceLine(self.PosX, self.PosY, self.PosZ + 2, OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ + 2, 0x100010) == nil
end

function Unit:IsEnemy()
    return self.LoS and UnitCanAttack("player", self.Pointer) and self:HasThreat()
end

function Unit:IsBoss()
    local Classification = UnitClassification(self.Pointer)
    if Classification == "worldboss" or Classification == "rareelite" then
        return true
    end
    if DMW.Player.EID then
        for i = 1, 5 do
            if UnitIsUnit("boss" .. i, self.Pointer) then
                return true
            end
        end
    end
    return false
end

function Unit:HasThreat()
    if DMW.Player.Instance ~= "none" and UnitAffectingCombat(self.Pointer) then
        return true
    elseif DMW.Player.Instance == "none" and UnitIsUnit(self.Pointer, "target") then
        return true
    end
    if self.Target and (UnitIsUnit(self.Target, "player") or UnitIsUnit(self.Target, "pet") or UnitInParty(self.Target)) then
        return true
    end
    return false
end

function Unit:GetEnemies(Yards)
    local EnemyTable = {}
    local Count = 0
    for _, v in pairs(DMW.Enemies) do
        if self:GetDistance(v) <= Yards then
            table.insert(EnemyTable, v)
            Count = Count + 1
        end
    end
    return EnemyTable, Count
end

function Unit:Interrupt()
    local Settings = DMW.Settings.profile
    local StartTime, EndTime, SpellID, Type
    local CastingInfo = {UnitCastingInfo(self.Pointer)} --name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId
    local ChannelInfo = {UnitChannelInfo(self.Pointer)} --name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId
    if CastingInfo[5] and not CastingInfo[8] then
        StartTime = CastingInfo[4] / 1000
        EndTime = CastingInfo[5] / 1000
        SpellID = CastingInfo[9]
        Type = "Cast"
    elseif ChannelInfo[5] and not ChannelInfo[7] then
        StartTime = ChannelInfo[4] / 1000
        SpellID = ChannelInfo[8]
        Type = "Channel"
    else
        return false
    end
    if Type == "Cast" then
        local Pct = (DMW.Time - StartTime) / (EndTime - StartTime) * 100
        if Pct >= Settings.Enemy.InterruptPct then
            return true
        end
    else
        local Delay = Settings.Enemy.ChannelInterrupt - 0.2 + (math.random(1, 4) / 10)
        if Delay < 0.1 then
            Delay = 0.1
        end
        if (DMW.Time - StartTime) > Delay then
            return true
        end
    end
    return false
end
