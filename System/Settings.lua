local DMW = DMW

local defaults = {
    profile = {
        Active = false,
        HUDPosition = {
            point = "CENTER",
            relativePoint = "TOP",
            xOfs = 2,
            yOfs = -70
        },
        HUD = {},
        Enemy = {
            InterruptPct = 70,
            ChannelInterrupt = 1
        }
    }
}

function DMW:OnInitialize()
    self.Settings = LibStub("AceDB-3.0"):New("DMWSettings", defaults)
    self.Settings:SetProfile("defaults")
end
