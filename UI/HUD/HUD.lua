local DMWSettings = DMWSettings
if DMWSettings.Active == nil then
    DMWSettings.Active = false
end
if DMWSettings.Position == nil then
    DMWSettings.Position = {}
    DMWSettings.Position.point = "CENTER"
    DMWSettings.Position.relativePoint = "TOP"
    DMWSettings.Position.xOfs = 2
    DMWSettings.Position.yOfs = -70
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
            HUDFrame:SetPoint(DMWSettings.Position.point, UIParent, DMWSettings.Position.relativePoint, DMWSettings.Position.xOfs, DMWSettings.Position.yOfs)
            HUDFrame:SetMovable(true)
            HUDFrame:EnableMouse(true)
            HUDFrame:RegisterForClicks("RightButtonUp")
            HUDFrame:SetScript(
                "OnClick",
                function(self, button, down)
                    if not DMWSettings.Active then
                        DMWSettings.Active = true
                    else
                        DMWSettings.Active = false
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
                        DMWSettings.Position.point = point
                        DMWSettings.Position.relativePoint = relativePoint
                        DMWSettings.Position.xOfs = xOfs
                        DMWSettings.Position.yOfs = yOfs
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
        if DMWSettings.Active then
            Status:SetText("Rotation |cFF00FF00Enabled")
        end
        if not DMWSettings.Active then
            Status:SetText("Rotation |cffff0000Disabled")
        end
    end
)
