local DMW = DMW
DMW.Enemies, DMW.Units, DMW.Friends = {}, {}, {}
local Enemies, Units, Friends = DMW.Enemies, DMW.Units, DMW.Friends
local Unit, LocalPlayer = DMW.Classes.Unit, DMW.Classes.LocalPlayer

local function RemoveUnit(Pointer)
    if Enemies[Pointer] ~= nil then
        Enemies[Pointer] = nil
    end
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
            Enemies[k] = v
        end
    end
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