local DMW = DMW


local HUDFrame = CreateFrame("BUTTON", "DMWHUD", UIParent)
local Status = HUDFrame:CreateFontString("DMWHUDStatusText", "OVERLAY")
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
            HUDFrame:RegisterForClicks("RightButtonUp")
            HUDFrame:SetScript(
                "OnClick",
                function(self, button, down)
                    if not Settings.Active then
                        Settings.Active = true
                    else
                        Settings.Active = false
                    end
                end
            )
            HUDFrame:SetScript(
                "OnMouseDown",
                function(self, button)
                    if button == "LeftButton" and not self.isMoving then
                        self:StartMoving()
                        self.isMoving = true
                    end
                end
            )
            HUDFrame:SetScript(
                "OnMouseUp",
                function(self, button)
                    if button == "LeftButton" and self.isMoving then
                        self:StopMovingOrSizing()
                        self.isMoving = false
                        local point, _, relativePoint, xOfs, yOfs = self:GetPoint(1)
                        Settings.HUDPosition.point = point
                        Settings.HUDPosition.relativePoint = relativePoint
                        Settings.HUDPosition.xOfs = xOfs
                        Settings.HUDPosition.yOfs = yOfs
                    end
                end
            )
            Status:SetFontObject(GameFontNormalSmall)
            Status:SetJustifyH("CENTER")
            Status:SetPoint("CENTER", HUDFrame, "CENTER", 0, 0)
            Status:SetText("Rotation |cffff0000Disabled")
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
