local DMW = DMW
DMW.Enemies, DMW.Units, DMW.Friends = {}, {}, {}
local Enemies, Units, Friends = DMW.Enemies, DMW.Units, DMW.Friends
local Unit, LocalPlayer = DMW.Classes.Unit, DMW.Classes.LocalPlayer

local function RemoveUnit(Pointer)
    if Units[Pointer] ~= nil then
        Units[Pointer] = nil
    end
    if Friends[Pointer] ~= nil then
        Friends[Pointer] = nil
    end
    if DMW.Player and DMW.Player.Pointer == Pointer then
        DMW.Player = nil
    end
    if DMW.Tables.TTD[Pointer] ~= nil then
        DMW.Tables.TTD[Pointer] = nil
    end
    if DMW.Tables.AuraCache[Pointer] ~= nil then
        DMW.Tables.AuraCache[Pointer] = nil
    end
end

local function SortEnemies()
    local LowestHealth, HighestHealth, HealthNorm, EnemyScore, RaidTarget
    for _, v in pairs(Enemies) do
        if not LowestHealth or v.Health < LowestHealth then
            LowestHealth = v.Health
        end
        if not HighestHealth or v.Health > HighestHealth then
            HighestHealth = v.Health
        end
    end
    for _, v in pairs(Enemies) do
        HealthNorm = (10 - 1) / (HighestHealth - LowestHealth) * (v.Health - HighestHealth) + 10
        if HealthNorm ~= HealthNorm or tostring(HealthNorm) == tostring(0 / 0) then
            HealthNorm = 0
        end
        EnemyScore = HealthNorm
        if v.TTD > 1.5 then
            EnemyScore = EnemyScore + 5
        end
        RaidTarget = GetRaidTargetIndex(v.Pointer)
        if RaidTarget ~= nil then
            EnemyScore = EnemyScore + RaidTarget * 3
            if RaidTarget == 8 then
                EnemyScore = EnemyScore + 5
            end
        end
        v.EnemyScore = EnemyScore
    end
    if #Enemies > 1 then
        table.sort(
            Enemies,
            function(x, y)
                return x.EnemyScore > y.EnemyScore
            end
        )
        table.sort(
            Enemies,
            function(x)
                if UnitIsUnit(x.Pointer, "target") then
                    return true
                else
                    return false
                end
            end
        )
    end
end

local function UpdateUnits()
    table.wipe(Enemies)
    DMW.Player.Target = nil
    DMW.Player.Pet = nil
    for k, v in pairs(Units) do
        if not v.NextUpdate or v.NextUpdate < DMW.Time then
            v:Update()
        end
        if not DMW.Player.Target and UnitIsUnit(k, "target") then
            DMW.Player.Target = v
        elseif DMW.Player.PetActive and not DMW.Player.Pet and UnitIsUnit(k, "pet") then
            DMW.Player.Pet = v
        end
        if v.ValidEnemy then
            table.insert(Enemies, v)
        end
    end
    SortEnemies()
end

function DMW.UpdateOM()
    local _, updated, added, removed = GetObjectCount(true)
    if updated and #removed > 0 then
        for _, v in pairs(removed) do
            RemoveUnit(v)
        end
    end
    if updated and #added > 0 then
        for _, v in pairs(added) do
            if ObjectIsUnit(v) then
                Units[v] = Unit(v)
            end
        end
    end
    DMW.Player:Update()
    UpdateUnits()
end
