local DMW = DMW
local AceGUI = LibStub("AceGUI-3.0")

local defaults = {
    profile = {
        Active = false,
        HUDPosition = {
            point = "CENTER",
            relativePoint = "TOP",
            xOfs = 2,
            yOfs = -70
        },
        HUD = {
            Show = true
        },
        Enemy = {
            InterruptPct = 70,
            ChannelInterrupt = 1
        },
        Rotation = {
        }
    }
}

function DMW:OnInitialize()
    self.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults)
    self.Settings:SetProfile("defaults")
    DMW.UI.Init()
end