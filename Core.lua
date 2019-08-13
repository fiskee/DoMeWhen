DMW = {}
local DMW = DMW
DMW.Tables = {}
DMW.Enums = {}
DMW.Functions = {}
DMW.Rotations = {}
DMW.Player = {}
DMW.UI = {}
DMW.Pulses = 0

local function FindRotation()
    if DMW.Rotations[DMW.Player.Class] and DMW.Rotations[DMW.Player.Class][DMW.Player.Spec] then
        DMW.Player.Rotation = DMW.Rotations[DMW.Player.Class][DMW.Player.Spec]
    end
end

local function Init()
    if type(DMWSettings) ~= "table" then
        DMWSettings = {}
    end
    DMW.Settings = DMWSettings
end

local f = CreateFrame("Frame", "DoMeWhen", UIParent)
f:SetScript("OnUpdate", function(self, elapsed)
    DMW.Time = GetTime()
    DMW.Pulses = DMW.Pulses + 1
    if EWT ~= nil then
        if not DMW.Player.Name then
            DMW.Player = DMW.Classes.LocalPlayer(ObjectPointer("player"))
        end
        DMW.UpdateOM()
        if not DMW.Player.Rotation then
            FindRotation()
        elseif not (IsMounted() or IsFlying()) and DMW.Settings.Active then
            DMW.Player.Rotation()
        end
    end
end)