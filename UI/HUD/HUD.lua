local DMW = DMW
DMW.UI.HUD = {}
local HUD = DMW.UI.HUD
HUD.Frame = CreateFrame("BUTTON", "DMWHUD", UIParent)
local HUDFrame = HUD.Frame
local Status = CreateFrame("BUTTON", "DMWHUDStatusText", HUDFrame)
HUDFrame:RegisterEvent("PLAYER_LOGIN")

HUDFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        local arg1, arg2, arg3 = ...
        if event == "PLAYER_LOGIN" then
            local Settings = DMW.Settings.profile
            HUDFrame:SetWidth(120)
            HUDFrame:SetHeight(80)
            HUDFrame:SetPoint(Settings.HUDPosition.point, UIParent, Settings.HUDPosition.relativePoint, Settings.HUDPosition.xOfs, Settings.HUDPosition.yOfs)
            HUDFrame:SetMovable(true)
            HUDFrame:EnableMouse(true)
            Status:SetScript(
                "OnMouseDown",
                function(self, button)
                    if button == "LeftButton" and not HUDFrame.IsMoving and IsShiftKeyDown() then
                        HUDFrame:StartMoving()
                        HUDFrame.IsMoving = true
                    end
                end
            )
            Status:SetScript(
                "OnMouseUp",
                function(self, button)
                    if button == "LeftButton" and HUDFrame.IsMoving then
                        HUDFrame:StopMovingOrSizing()
                        HUDFrame.IsMoving = false
                        local point, _, relativePoint, xOfs, yOfs = HUDFrame:GetPoint(1)
                        Settings.HUDPosition.point = point
                        Settings.HUDPosition.relativePoint = relativePoint
                        Settings.HUDPosition.xOfs = xOfs
                        Settings.HUDPosition.yOfs = yOfs
                    else
                        if not Settings.Active then
                            Settings.Active = true
                        else
                            Settings.Active = false
                        end
                    end
                end
            )
            Status:SetWidth(120)
            Status:SetHeight(22)
            Status:SetNormalFontObject(GameFontNormalSmall)
            Status:SetHighlightFontObject(GameFontHighlightSmall)
            Status:SetPoint("TOP", HUDFrame, "TOP", 0, 0)
            Status:SetText("Rotation |cffff0000Disabled")
        end
    end
)

function HUD.Load()
    local Settings = DMW.Settings.profile
    local ofsy = -22
    local Frame
    if HUD.Options then
        for k, v in pairs(HUD.Options) do
            local OptionsCount = 0
            for k,_ in pairs(v) do
                OptionsCount = OptionsCount + 1
            end
            Frame = CreateFrame("BUTTON", "DMWHUD" .. k, HUDFrame)
            Frame.HUDName = k
            Frame.Options = v
            Frame.OptionsCount = #v
            Frame.Index = 1
            Frame.Toggle = function(self, Index)
                if Index and self.Options[Index] then
                    self:SetText(self.Options[Index].Text)
                    self.Index = Index
                    Settings.HUD[self.HUDName] = Index
                    return
                elseif not Index then
                    local NewIndex
                    if self.Index < self.OptionsCount then
                        NewIndex = self.Index + 1
                    else
                        NewIndex = 1
                    end
                    self:SetText(self.Options[NewIndex].Text)
                    self.Index = NewIndex
                    Settings.HUD[self.HUDName] = NewIndex
                    return
                end
                print("HUD: Invalid Index Supplied")
            end
            Frame:SetWidth(120)
            Frame:SetHeight(22)
            Frame:SetNormalFontObject(GameFontNormalSmall)
            Frame:SetHighlightFontObject(GameFontHighlightSmall)
            Frame:SetPoint("TOP", HUDFrame, "TOP", 0, ofsy)
            Frame:SetText(Frame.Options[1].Text)
            Frame:SetScript(
                "OnMouseDown",
                function(self, button)
                    if button == "LeftButton" and not HUDFrame.IsMoving and IsShiftKeyDown() then
                        HUDFrame:StartMoving()
                        HUDFrame.IsMoving = true
                    end
                end
            )
            Frame:SetScript(
                "OnMouseUp",
                function(self, button)
                    if button == "LeftButton" and HUDFrame.IsMoving then
                        HUDFrame:StopMovingOrSizing()
                        HUDFrame.IsMoving = false
                        local point, _, relativePoint, xOfs, yOfs = HUDFrame:GetPoint(1)
                        Settings.HUDPosition.point = point
                        Settings.HUDPosition.relativePoint = relativePoint
                        Settings.HUDPosition.xOfs = xOfs
                        Settings.HUDPosition.yOfs = yOfs
                    elseif button == "LeftButton" then
                        self:Toggle()
                    elseif button == "RightButton" then
                        local NewIndex
                        if self.Index > 1 then
                            NewIndex = self.Index - 1
                        else
                            NewIndex = self.OptionsCount
                        end
                        self:SetText(self.Options[NewIndex].Text)
                        self.Index = NewIndex
                        Settings.HUD[self.HUDName] = NewIndex
                    end
                end
            )
            if Settings.HUD[k] then
                Frame:Toggle(Settings.HUD[k])
            else
                Frame:Toggle(1)
            end
            ofsy = ofsy - 22
        end
        HUDFrame:SetHeight(math.abs(ofsy))
        HUD.Loaded = true
    end
end

HUDFrame:SetScript(
    "OnUpdate",
    function(self, elapsed)
        if DMW.Settings.profile.Active then
            Status:SetText("Rotation |cFF00FF00Enabled")
        else
            Status:SetText("Rotation |cffff0000Disabled")
        end
        if HUDFrame:IsShown() and not DMW.Settings.profile.HUD.Show then
            HUDFrame:Hide()
        elseif not HUDFrame:IsShown() and DMW.Settings.profile.HUD.Show then
            HUDFrame:Show()
        end
    end
)
