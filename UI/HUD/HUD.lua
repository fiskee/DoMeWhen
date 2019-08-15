local DMW = DMW


local HUDFrame = CreateFrame("BUTTON", "DMWHUD", UIParent)
local Status = CreateFrame("BUTTON", "DMWHUDStatusText", HUDFrame, "UIPanelButtonTemplate")
HUDFrame:RegisterEvent("PLAYER_LOGIN")

HUDFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        local arg1, arg2, arg3 = ...
        if event == "PLAYER_LOGIN" then
            local Settings = DMW.Settings.profile
            HUDFrame:SetWidth(80)
            HUDFrame:SetHeight(80)
            HUDFrame:SetPoint(Settings.HUDPosition.point, UIParent, Settings.HUDPosition.relativePoint, Settings.HUDPosition.xOfs, Settings.HUDPosition.yOfs)
            HUDFrame:SetMovable(true)
            HUDFrame:EnableMouse(true)
            HUDFrame:SetScript(
                "OnMouseDown",
                function(self, button)
                    if button == "LeftButton" and not self.IsMoving then
                        self:StartMoving()
                        self.IsMoving = true
                    end
                end
            )
            HUDFrame:SetScript(
                "OnMouseUp",
                function(self, button)
                    if button == "LeftButton" and self.IsMoving then
                        self:StopMovingOrSizing()
                        self.IsMoving = false
                        local point, _, relativePoint, xOfs, yOfs = self:GetPoint(1)
                        Settings.HUDPosition.point = point
                        Settings.HUDPosition.relativePoint = relativePoint
                        Settings.HUDPosition.xOfs = xOfs
                        Settings.HUDPosition.yOfs = yOfs
                    end
                end
            )
            Status:SetWidth(80)
            Status:SetHeight(22)
            Status:SetNormalFontObject(GameFontNormalSmall)
            Status:DisableDrawLayer("BACKGROUND")
            Status:SetPoint("CENTER", HUDFrame, "CENTER", 0, 0)
            Status:SetText("Rotation |cffff0000Disabled")
            Status:SetScript(
                "OnClick",
                function(self, button, down)
                    if not Settings.Active then
                        Settings.Active = true
                    else
                        Settings.Active = false
                    end
                end
            )
        end
    end
)

HUDFrame:SetScript(
    "OnUpdate",
    function(self, elapsed)
        if DMW.Settings.profile.Active then
            Status:SetText("Rotation |cFF00FF00Enabled")
        end
        if not DMW.Settings.profile.Active then
            Status:SetText("Rotation |cffff0000Disabled")
        end
    end
)
