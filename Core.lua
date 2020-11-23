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
DMW.Timers = {
    OM = {},
    Navigation = {},
    Trackers = {},
    Gatherers = {},
    Rotation = {}
}
local Init = false
local DebugStart
local RotationCount = 0

local function FindRotation()
    if DMW.Rotations[DMW.Player.Class] and DMW.Rotations[DMW.Player.Class][DMW.Player.Spec] then
        DMW.Player.Rotation = DMW.Rotations[DMW.Player.Class][DMW.Player.Spec]
    end
end

local function Initialize()
    DMW.Init()
    DMW.UI.HUD.Init()
    InitializeNavigation(
        function(Result)
            if Result then
                if DMW.Settings.profile.Navigation.WorldMapHook then
                    DMW.Helpers.Navigation:InitWorldMap()
                end
                DMW.UI.InitNavigation()
            end
        end
    )
    Init = true
end

local f = CreateFrame("Frame", "DoMeWhen", UIParent)
f:SetScript(
    "OnUpdate",
    function(self, elapsed)
        DMW.Time = GetTime()
        DMW.Pulses = DMW.Pulses + 1
        if not DMW.Enums.Specs[GetSpecializationInfo(GetSpecialization())] then
            return
        end
        if EWT ~= nil then
            LibStub("LibDraw-1.0").clearCanvas()
            if not Init then
                Initialize()
            end
            if not DMW.Player.Name then
                DMW.Player = DMW.Classes.LocalPlayer(ObjectPointer("player"))
            end
            -- if GetSpecializationInfo(GetSpecialization()) ~= DMW.Player.SpecID then
            --     ReloadUI()
            --     return
            -- end
            DebugStart = debugprofilestop()
            DMW.UpdateOM()
            DMW.Timers.OM.Last = debugprofilestop() - DebugStart
            DebugStart = debugprofilestop()
            DMW.Helpers.Trackers.Run()
            DMW.Timers.Trackers.Last = debugprofilestop() - DebugStart
            DebugStart = debugprofilestop()
            DMW.Helpers.Gatherers.Run()
            DMW.Timers.Gatherers.Last = debugprofilestop() - DebugStart
            if not DMW.Player.Rotation then
                FindRotation()
            else
                if DMW.Helpers.Queue.Run() then
                    return true
                end
                if DMW.Player.Combat then
                    RotationCount = RotationCount + 1
                    DebugStart = debugprofilestop()
                end
                DMW.Player.Rotation()
                if DMW.Player.Combat then
                    DMW.Timers.Rotation.Last = debugprofilestop() - DebugStart
                    DMW.Timers.Rotation.Total = DMW.Timers.Rotation.Total and (DMW.Timers.Rotation.Total + DMW.Timers.Rotation.Last) or DMW.Timers.Rotation.Last
                    DMW.Timers.Rotation.Average = DMW.Timers.Rotation.Total / RotationCount
                end
                if not DMW.UI.HUD.Loaded then
                    DMW.UI.HUD.Load()
                end
            end
            DebugStart = debugprofilestop()
            DMW.Helpers.Navigation:Pulse()
            DMW.Timers.Navigation.Last = debugprofilestop() - DebugStart
            DMW.UI.Debug.Run()
            DMW.Timers.OM.Total = DMW.Timers.OM.Total and (DMW.Timers.OM.Total + DMW.Timers.OM.Last) or DMW.Timers.OM.Last
            DMW.Timers.Navigation.Total = DMW.Timers.Navigation.Total and (DMW.Timers.Navigation.Total + DMW.Timers.Navigation.Last) or DMW.Timers.Navigation.Last
            DMW.Timers.Trackers.Total = DMW.Timers.Trackers.Total and (DMW.Timers.Trackers.Total + DMW.Timers.Trackers.Last) or DMW.Timers.Trackers.Last
            DMW.Timers.Gatherers.Total = DMW.Timers.Gatherers.Total and (DMW.Timers.Gatherers.Total + DMW.Timers.Gatherers.Last) or DMW.Timers.Gatherers.Last
            DMW.Timers.Rotation.Total = DMW.Timers.Rotation.Total and (DMW.Timers.Rotation.Total + DMW.Timers.Rotation.Last) or DMW.Timers.Rotation.Last or nil
            DMW.Timers.OM.Average = DMW.Timers.OM.Total / DMW.Pulses
            DMW.Timers.Navigation.Average = DMW.Timers.Navigation.Total / DMW.Pulses
            DMW.Timers.Trackers.Average = DMW.Timers.Trackers.Total / DMW.Pulses
            DMW.Timers.Gatherers.Average = DMW.Timers.Gatherers.Total / DMW.Pulses
        end
    end
)
