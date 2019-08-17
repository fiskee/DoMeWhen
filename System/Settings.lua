local DMW = DMW
local AceGUI = LibStub("AceGUI-3.0")

local defaults = {
    profile = {
        Active = false,
        HUDPosition = {
            point = "LEFT",
            relativePoint = "LEFT",
            xOfs = 40,
            yOfs = 100
        },
        HUD = {
            Show = true
        },
        Enemy = {
            InterruptPct = 70,
            ChannelInterrupt = 1,
            InterruptTarget = 1
        },
        Rotation = {
        }
    }
}

function DMW.Init()
    DMW.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults, "Default")
    DMW.Settings:SetProfile(DMW.Enums.Specs[GetSpecializationInfo(GetSpecialization())])
    DMW.UI.Init()
end