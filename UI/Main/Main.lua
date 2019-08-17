local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local DMW = DMW
local UI = DMW.UI

UI.Options = {
    name = "DoMeWhen",
    handler = DMW,
    type = "group",
    childGroups = "tab",
    args = {
        RotationTab = {
            name = "Rotation",
            type = "group",
            order = 1,
            args = {
            }
        },
        GeneralTab = {
            name = "General",
            type = "group",
            order = 2,
            args = {
                GeneralHeader = {
                    type = "header",
                    order = 1,
                    name = "General"
                },
                HUDEnabled = {
                    type = "toggle",
                    order = 2,
                    name = "Show HUD",
                    desc = "Show HUD",
                    width = "full",
                    get = function()
                        return DMW.Settings.profile.HUD.Show
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.HUD.Show = value
                        if value then
                            DMW.UI.HUD.Frame:Show()
                        else
                            DMW.UI.HUD.Frame:Hide()
                        end
                    end
                }
            }
        },
    }
}

function UI.Show()
    if not UI.ConfigFrame then
        UI.ConfigFrame = AceGUI:Create("Frame")
        UI.ConfigFrame:Hide()
        _G["DMWConfigFrame"] = UI.ConfigFrame.frame
        table.insert(UISpecialFrames, "DMWConfigFrame")
    end
    if not UI.ConfigFrame:IsShown() then
        LibStub("AceConfigDialog-3.0"):Open("DMW", UI.ConfigFrame)
    else
        UI.ConfigFrame:Hide()
    end
end

function UI.Init()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("DMW", UI.Options)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("DMW", 380, 600)
end

function UI.AddHeader(Text)
    local Setting = Text:gsub("%s+", "")
    UI.Options.args.RotationTab.args[Setting .. "Header"] = {
        GeneralHeader = {
            type = "header",
            name = Text
        },
    }
end

function UI.AddToggle(Name, Desc, Default)
    local Setting = Name:gsub("%s+", "")
    UI.Options.args.RotationTab.args[Setting] = {
        type = "toggle",
        name = Name,
        desc = Desc,
        width = "full",
        get = function()
            return DMW.Settings.profile.Rotation[Setting]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Setting] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Setting] == nil then
        DMW.Settings.profile.Rotation[Setting] = Default
    end
end

function UI.AddRange(Name, Desc, Min, Max, Step, Default)
    local Setting = Name:gsub("%s+", "")
    UI.Options.args.RotationTab.args[Setting] = {
        type = "range",
        name = Name,
        desc = Desc,
        width = "full",
        min = Min,
        max = Max,
        step = Step,
        get = function()
            return DMW.Settings.profile.Rotation[Setting]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Setting] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Setting] == nil then
        DMW.Settings.profile.Rotation[Setting] = Default
    end
end

function UI.AddDropdown(Name, Desc, Values, Default)
    local Setting = Name:gsub("%s+", "")
    UI.Options.args.RotationTab.args[Setting] = {
        type = "select",
        name = Name,
        desc = Desc,
        width = "full",
        values = Values,
        style = "dropdown",
        get = function()
            return DMW.Settings.profile.Rotation[Setting]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Setting] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Setting] == nil then
        DMW.Settings.profile.Rotation[Setting] = Default
    end
end