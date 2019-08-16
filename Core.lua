DMW = LibStub("AceAddon-3.0"):NewAddon("DMW")
local DMW = DMW
DMW.Tables = {}
DMW.Enums = {}
DMW.Functions = {}
DMW.Rotations = {}
DMW.Player = {}
DMW.UI = {}
DMW.Settings = {}
DMW.Helpers = {}
DMW.Pulses = 0

local function FindRotation()
    if DMW.Rotations[DMW.Player.Class] and DMW.Rotations[DMW.Player.Class][DMW.Player.Spec] then
        DMW.Player.Rotation = DMW.Rotations[DMW.Player.Class][DMW.Player.Spec]
    end
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
        elseif DMW.Settings.profile.Active then
            DMW.Player.Rotation()
        end
        if not DMW.UI.HUD.Loaded then
            DMW.UI.HUD.Load()
        end
    end
end)