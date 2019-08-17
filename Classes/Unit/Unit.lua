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
    self.Facing = ObjectIsFacing("Player", self.Pointer)
end

function Unit:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    if OtherUnit == DMW.Player and DMW.Enums.MeleeSpell[DMW.Player.SpecID] and IsSpellInRange(GetSpellInfo(DMW.Enums.MeleeSpell[DMW.Player.SpecID]), self.Pointer) == 1 then
        return 0
    end
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
    elseif DMW.Player.EID then
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
    local Table = {}
    local Count = 0
    for _, v in pairs(DMW.Enemies) do
        if self:GetDistance(v) <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function Unit:GetFriends(Yards)
    local Table = {}
    local Count = 0
    for _, v in pairs(DMW.Friends) do
        if self:GetDistance(v) <= Yards then
            table.insert(Table, v)
            Count = Count + 1
        end
    end
    return Table, Count
end

function Unit:Interrupt()
    local InterruptTarget = DMW.Settings.profile.Enemy.InterruptTarget
    if (InterruptTarget == 2 and not UnitIsUnit(self.Pointer, "target")) or (InterruptTarget == 3 and not UnitIsUnit(self.Pointer, "focus")) or (InterruptTarget == 4 and not UnitIsUnit(self.Pointer, "mouseover")) then
        return false
    end
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

function Unit:Dispel(Spell)
    local AuraCache = DMW.Tables.AuraCache[Unit]
    if not AuraCache or not Spell then
        return false
    end
    local DispelTypes = {}
    for k, v in pairs(DMW.Enums.DispelSpells[Spell.SpellID]) do
        DispelTypes[v] = true
    end
    local Elapsed
    local Delay = DMW.Settings.profile.DispelDelay - 0.2 + (math.random(1, 4) / 10)
    local ReturnValue = false
    --name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId
    for k, v in pairs(AuraCache) do
        Elapsed = AuraCache[5] - (AuraCache[6] - DMW.Time)
        if AuraCache[4] and DispelTypes[AuraCache[4]] and Elapsed > Delay then
            if DMW.Enums.NoDispel[AuraCache[10]] then
                ReturnValue = false
                break                
            elseif DMW.Enums.SpecialDispel[AuraCache[10]] and DMW.Enums.SpecialDispel[AuraCache[10]].Stacks then 
                if AuraCache[3] >= DMW.Enums.SpecialDispel[AuraCache[10]].Stacks then
                    ReturnValue = true
                else
                    ReturnValue = false
                    break
                end
            elseif DMW.Enums.SpecialDispel[AuraCache[10]] and DMW.Enums.SpecialDispel[AuraCache[10]].Range then
                if select(2, self:GetFriends(DMW.Enums.SpecialDispel[AuraCache[10]].Range)) < 2 then
                    ReturnValue = true
                else
                    ReturnValue = false
                    break
                end
            else
                ReturnValue = true
            end
        end
    end
    return ReturnValue
end

function Unit:PredictPosition(Time)
    local MoveDistance = GetUnitSpeed(self.Pointer) * Time
    if MoveDistance > 0 then
        local X, Y, Z = self.PosX, self.PosY, self.PosZ
        local Angle = ObjectFacing(self.Pointer)
        local UnitTargetDist = 0
        if self.Target then
            local TX, TY, TZ = ObjectPosition(self.Target)
            local TSpeed = GetUnitSpeed(self.Target)
            if TSpeed > 0 then
                local TMoveDistance = TSpeed * Time
                local TAngle = ObjectFacing(self.Target)
                TX = TX + cos(TAngle) * TMoveDistance
                TY = TY + sin(TAngle) * TMoveDistance
            end
            UnitTargetDist = sqrt(((TX - X) ^ 2) + ((TY - Y) ^ 2) + ((TZ - Z) ^ 2)) - ((self.CombatReach or 0) + (UnitCombatReach(self.Target) or 0))
            if UnitTargetDist < MoveDistance then
                MoveDistance = UnitTargetDist
            end
            Angle = rad(atan2(TY - Y, TX - X))
            if Angle < 0 then
                Angle = rad(360 + atan2(TY - Y, TX - X))
            end
        end
        X = X + cos(Angle) * MoveDistance
        Y = Y + cos(Angle) * MoveDistance
        return X, Y, Z
    end
    return self.X, self.Y, self.Z
end