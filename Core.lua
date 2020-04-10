DMW = LibStub("AceAddon-3.0"):NewAddon("DMW", "AceConsole-3.0")
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
local Init = false

local function FindRotation()
    if DMW.Rotations[DMW.Player.Class] and DMW.Rotations[DMW.Player.Class][DMW.Player.Spec] then
        DMW.Player.Rotation = DMW.Rotations[DMW.Player.Class][DMW.Player.Spec]
    end
end

local function Initialize()
    DMW.Init()
    DMW.UI.HUD.Init()
    InitializeNavigation(function(Result)
        if Result then
            if DMW.Settings.profile.Navigation.WorldMapHook then
                DMW.Helpers.Navigation:InitWorldMap()
            end
            DMW.UI.InitNavigation()
        end
    end)
    Init = true
end

local f = CreateFrame("Frame", "DoMeWhen", UIParent)
f:SetScript(
    "OnUpdate",
    function(self, elapsed)
        DMW.Time = GetTime()
        DMW.Pulses = DMW.Pulses + 1
        if EWT ~= nil then
            LibStub("LibDraw-1.0").clearCanvas()
            if not Init then
                Initialize()
            end
            if not DMW.Player.Name then
                DMW.Player = DMW.Classes.LocalPlayer(ObjectPointer("player"))
            end
            if GetSpecializationInfo(GetSpecialization()) ~= DMW.Player.SpecID then
                ReloadUI()
                return
            end
            DMW.UpdateOM()
            DMW.Helpers.Trackers.Run()
            DMW.Helpers.Gatherers.Run()
            if not DMW.Player.Rotation then
                FindRotation()
            else
                if DMW.Helpers.Queue.Run() then
                    return true
                end
                DMW.Player.Rotation()
                if not DMW.UI.HUD.Loaded then
                    DMW.UI.HUD.Load()
                end
            end
            DMW.Helpers.Navigation:Pulse()
            DMW.UI.Debug.Run()
        end
    end
)
