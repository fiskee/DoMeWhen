local DMW = DMW
if DMW.Settings.Active == nil then
    DMW.Settings.Active = false
end
if DMW.Settings.Position == nil then
    DMW.Settings.Position = {}
    DMW.Settings.Position.point = "CENTER"
    DMW.Settings.Position.relativePoint = "TOP"
    DMW.Settings.Position.xOfs = 2
    DMW.Settings.Position.yOfs = -70
end

local HUDFrame = CreateFrame("BUTTON", "DMWHUD", UIParent)
local Status = HUDFrame:CreateFontString("DMWHUDStatusText", "OVERLAY")
HUDFrame:RegisterEvent("PLAYER_LOGIN")

HUDFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        local arg1, arg2, arg3 = ...
        if event == "PLAYER_LOGIN" then
            HUDFrame:SetWidth(80)
            HUDFrame:SetHeight(80)
            HUDFrame:SetPoint(DMW.Settings.Position.point, UIParent, DMW.Settings.Position.relativePoint, DMW.Settings.Position.xOfs, DMW.Settings.Position.yOfs)
            HUDFrame:SetMovable(true)
            HUDFrame:EnableMouse(true)
            HUDFrame:RegisterForClicks("RightButtonUp")
            HUDFrame:SetScript(
                "OnClick",
                function(self, button, down)
                    if not DMW.Settings.Active then
                        DMW.Settings.Active = true
                    else
                        DMW.Settings.Active = false
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
                        DMW.Settings.Position.point = point
                        DMW.Settings.Position.relativePoint = relativePoint
                        DMW.Settings.Position.xOfs = xOfs
                        DMW.Settings.Position.yOfs = yOfs
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
        if DMW.Settings.Active then
            Status:SetText("Rotation |cFF00FF00Enabled")
        end
        if not DMW.Settings.Active then
            Status:SetText("Rotation |cffff0000Disabled")
        end
    end
)
