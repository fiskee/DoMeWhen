local DMW = DMW
local AceGUI = LibStub("AceGUI-3.0")

local defaults = {
    profile = {
        MinimapIcon = {
            hide = false
        },
        HUDPosition = {
            point = "LEFT",
            relativePoint = "LEFT",
            xOfs = 40,
            yOfs = 100
        },
        HUD = {
            Rotation = 1,
            Show = true
        },
        Enemy = {
            InterruptPct = 70,
            ChannelInterrupt = 1,
            InterruptTarget = 1
        },
        DispelDelay = 1,
        Rotation = {},
        Queue = {
            Wait = 2,
            Items = true
        }
    }
}

function DMW.Init()
    DMW.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults, "Default")
    DMW.Settings:SetProfile(DMW.Enums.Specs[GetSpecializationInfo(GetSpecialization())])
    DMW.UI.Init()
end
