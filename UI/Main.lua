local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local DMW = DMW
local UI = DMW.UI
local RotationOrder = 1
local CurrentTab = "GeneralTab"
local TabIndex = 2

local Options = {
    name = "DoMeWhen",
    handler = DMW,
    type = "group",
    childGroups = "tab",
    args = {
        RotationTab = {
            name = "Rotation",
            type = "group",
            order = 1,
            args = {}
        },
        GeneralTab = {
            name = "General",
            type = "group",
            order = 2,
            args = {
                DisplayTab = {
                    type = "group",
                    order = 1,
                    name = "Display",
                    args = {
                        HUDEnabled = {
                            type = "toggle",
                            order = 1,
                            name = "Show HUD",
                            desc = "Toggle to show/hide the HUD",
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
                        },
                        MMIconEnabled = {
                            type = "toggle",
                            order = 2,
                            name = "Show Minimap Icon",
                            desc = "Toggle to show/hide the minimap icon",
                            width = "full",
                            get = function()
                                return not DMW.Settings.profile.MinimapIcon.hide
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.MinimapIcon.hide = not value
                                if value then
                                    UI.MinimapIcon:Show("MinimapIcon")
                                else
                                    UI.MinimapIcon:Hide("MinimapIcon")
                                end
                            end
                        }
                    }
                },
                TrackersTab = {
                    type = "group",
                    order = 2,
                    name = "Trackers",
                    args = {
                        Quests = {
                            type = "toggle",
                            order = 1,
                            name = "Quest Tracker",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Trackers.Quests
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Trackers.Quests = value
                            end
                        },
                        QuestsPct = {
                            type = "toggle",
                            order = 2,
                            name = "Quest Tracker - Pct Based",
                            desc = "Track % based quest units",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Trackers.QuestsPct
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Trackers.QuestsPct = value
                            end
                        },
                        HorrificVisions = {
                            type = "toggle",
                            order = 3,
                            name = "Horrific Visions",
                            desc = "Show Horrific Visions Objects",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Trackers.HorrificVisions
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Trackers.HorrificVisions = value
                            end
                        },
                        Herbs = {
                            type = "toggle",
                            order = 4,
                            name = "Herbalism",
                            desc = "Show BfA Herbalism Objects",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Trackers.Herbs
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Trackers.Herbs = value
                            end
                        },
                        Ore = {
                            type = "toggle",
                            order = 5,
                            name = "Mining",
                            desc = "Show BfA Mining Nodes",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Trackers.Ore
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Trackers.Ore = value
                            end
                        }
                    }
                },
                GatherersTab = {
                    type = "group",
                    order = 3,
                    name = "Gatherers",
                    args = {
                        AutoLoot = {
                            type = "toggle",
                            order = 1,
                            name = "Auto Loot",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Gatherers.AutoLoot
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Gatherers.AutoLoot = value
                            end
                        },
                        AutoSkinning = {
                            type = "toggle",
                            order = 2,
                            name = "Auto Skinning",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Gatherers.AutoSkinning
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Gatherers.AutoSkinning = value
                            end
                        },
                        AutoGather = {
                            type = "toggle",
                            order = 3,
                            name = "Auto Herb/Mine",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Gatherers.AutoGather
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Gatherers.AutoGather = value
                            end
                        }
                    }
                },
                DeveloperTab = {
                    type = "group",
                    order = 4,
                    name = "Developer",
                    args = {
                        Units = {
                            type = "toggle",
                            order = 1,
                            name = "Units",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Developer.Units
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Developer.Units = value
                            end
                        },
                        GameObjects = {
                            type = "toggle",
                            order = 2,
                            name = "Game Objects",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Developer.GameObjects
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Developer.GameObjects = value
                            end
                        },
                        AreaTriggers = {
                            type = "toggle",
                            order = 3,
                            name = "Area Triggers",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Developer.AreaTriggers
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Developer.AreaTriggers = value
                            end
                        }
                    }
                }
            }
        },
        EnemyTab = {
            name = "Enemy",
            type = "group",
            order = 3,
            args = {
                InterruptHeader = {
                    type = "group",
                    order = 1,
                    name = "Interrupts",
                    args = {
                        InterruptPct = {
                            type = "range",
                            order = 2,
                            name = "Interrupt %",
                            desc = "Set desired % for interrupting enemy casts",
                            width = "full",
                            min = 0,
                            max = 100,
                            step = 1,
                            get = function()
                                return DMW.Settings.profile.Enemy.InterruptPct
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Enemy.InterruptPct = value
                            end
                        },
                        ChannelInterrupt = {
                            type = "range",
                            order = 3,
                            name = "Channel Interrupt",
                            desc = "Set seconds to wait before interrupting enemy channels",
                            width = "full",
                            min = 0.0,
                            max = 3.0,
                            step = 0.1,
                            get = function()
                                return DMW.Settings.profile.Enemy.ChannelInterrupt
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Enemy.ChannelInterrupt = value
                            end
                        },
                        InterruptTarget = {
                            type = "select",
                            order = 4,
                            name = "Interrupt Target",
                            desc = "Select desired target setting for interrupts",
                            width = "full",
                            values = {"Any", "Target", "Focus", "Mouseover"},
                            style = "dropdown",
                            get = function()
                                return DMW.Settings.profile.Enemy.InterruptTarget
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Enemy.InterruptTarget = value
                            end
                        }
                    }
                }
            }
        },
        FriendTab = {
            name = "Friend",
            type = "group",
            order = 4,
            args = {
                DispelDelay = {
                    type = "range",
                    order = 1,
                    name = "Dispel Delay",
                    desc = "Set seconds to wait before casting dispel",
                    width = "full",
                    min = 0.0,
                    max = 3.0,
                    step = 0.1,
                    get = function()
                        return DMW.Settings.profile.DispelDelay
                    end,
                    set = function(info, value)
                        DMW.Settings.profile.DispelDelay = value
                    end
                }
            }
        },
        QueueTab = {
            name = "Queue",
            type = "group",
            order = 5,
            args = {
                SettingsTab = {
                    name = "Settings",
                    type = "group",
                    order = 1,
                    args = {
                        QueueTime = {
                            type = "range",
                            order = 1,
                            name = "Queue Time",
                            desc = "Set maximum seconds to attempt casting queued spell",
                            width = "full",
                            min = 0,
                            max = 5,
                            step = 0.5,
                            get = function()
                                return DMW.Settings.profile.Queue.Wait
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Queue.Wait = value
                            end
                        },
                        QueueItems = {
                            type = "toggle",
                            order = 2,
                            name = "Items",
                            desc = "Enable item queue",
                            width = "full",
                            get = function()
                                return DMW.Settings.profile.Queue.Items
                            end,
                            set = function(info, value)
                                DMW.Settings.profile.Queue.Items = value
                            end
                        }
                    }
                },
                ClassTab = {
                    name = "Class",
                    type = "group",
                    order = 2,
                    args = {
                    }
                },
                EssencesTab = {
                    name = "Essences",
                    type = "group",
                    order = 3,
                    args = {
                    }
                }
            }
        }
    }
}

local MinimapIcon =
    LibStub("LibDataBroker-1.1"):NewDataObject(
    "MinimapIcon",
    {
        type = "data source",
        text = "DMW",
        icon = "Interface\\Icons\\Achievement_dungeon_utgardepinnacle_25man",
        OnClick = function(self, button)
            if button == "LeftButton" then
                UI.Show()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("DoMeWhen", 1, 1, 1)
        end
    }
)

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
    LibStub("AceConfig-3.0"):RegisterOptionsTable("DMW", Options)
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("DMW", 580, 750)
    UI.MinimapIcon = LibStub("LibDBIcon-1.0")
    UI.MinimapIcon:Register("MinimapIcon", MinimapIcon, DMW.Settings.profile.MinimapIcon)
end

function UI.AddHeader(Text)
    if RotationOrder > 1 then
        Options.args.RotationTab.args[CurrentTab].args["Blank" .. RotationOrder] = {
            type = "description",
            order = RotationOrder,
            name = " ",
            width = "full"
        }
        RotationOrder = RotationOrder + 1
    end
    local Setting = Text:gsub("%s+", "")
    Options.args.RotationTab.args[CurrentTab].args[Setting .. "Header"] = {
        type = "header",
        order = RotationOrder,
        name = Text
    }
    RotationOrder = RotationOrder + 1
end

function UI.AddToggle(Name, Desc, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args[Name] = {
        type = "toggle",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = Width,
        get = function()
            return DMW.Settings.profile.Rotation[Name]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Name] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Name] == nil then
        DMW.Settings.profile.Rotation[Name] = Default
    end
    RotationOrder = RotationOrder + 1
end

function UI.AddRange(Name, Desc, Min, Max, Step, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args[Name] = {
        type = "range",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = Width,
        min = Min,
        max = Max,
        step = Step,
        get = function()
            return DMW.Settings.profile.Rotation[Name]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Name] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Name] == nil then
        DMW.Settings.profile.Rotation[Name] = Default
    end
    RotationOrder = RotationOrder + 1
end

function UI.AddDropdown(Name, Desc, Values, Default, FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args[Name] = {
        type = "select",
        order = RotationOrder,
        name = Name,
        desc = Desc,
        width = Width,
        values = Values,
        style = "dropdown",
        get = function()
            return DMW.Settings.profile.Rotation[Name]
        end,
        set = function(info, value)
            DMW.Settings.profile.Rotation[Name] = value
        end
    }
    if Default and DMW.Settings.profile.Rotation[Name] == nil then
        DMW.Settings.profile.Rotation[Name] = Default
    end
    RotationOrder = RotationOrder + 1
end

function UI.AddBlank(FullWidth)
    local Width = FullWidth and "full" or 0.9
    Options.args.RotationTab.args[CurrentTab].args["Blank" .. RotationOrder] = {
        type = "description",
        order = RotationOrder,
        name = " ",
        width = Width
    }
    RotationOrder = RotationOrder + 1
end

function UI.AddTab(Name)
    Options.args.RotationTab.args[Name .. "Tab"] = {
        name = Name,
        type = "group",
        order = TabIndex,
        args = {}
    }
    TabIndex = TabIndex + 1
    CurrentTab = Name .. "Tab"
    RotationOrder = 1
end

function UI.InitQueue()
    for k, v in pairs(DMW.Player.Spells) do
        if v.CastType ~= "Profession" and v.CastType ~= "Toggle" and v.SpellType ~= "GCD" and v.SpellType ~= "Essence" then
            Options.args.QueueTab.args.ClassTab.args[k] = {
                type = "select",
                name = v.SpellName,
                --desc = Desc,
                width = "full",
                values = {"Disabled", "Normal", "Mouseover", "Cursor", "Cursor - No Cast"},
                style = "dropdown",
                get = function()
                    return DMW.Settings.profile.Queue[v.SpellName]
                end,
                set = function(info, value)
                    DMW.Settings.profile.Queue[v.SpellName] = value
                end
            }
            if DMW.Settings.profile.Queue[v.SpellName] == nil then
                DMW.Settings.profile.Queue[v.SpellName] = 1
            end
        elseif v.SpellType == "Essence" then
            Options.args.QueueTab.args.EssencesTab.args[k] = {
                type = "select",
                name = v.SpellName,
                --desc = Desc,
                width = "full",
                values = {"Disabled", "Normal", "Mouseover", "Cursor", "Cursor - No Cast"},
                style = "dropdown",
                get = function()
                    return DMW.Settings.profile.Queue[v.SpellName]
                end,
                set = function(info, value)
                    DMW.Settings.profile.Queue[v.SpellName] = value
                end
            }
            if DMW.Settings.profile.Queue[v.SpellName] == nil then
                DMW.Settings.profile.Queue[v.SpellName] = 1
            end
        end
    end
end

function UI.InitNavigation()
    Options.args.NavigationTab = {
        name = "Navigation",
        type = "group",
        order = 6,
        args = {
            Enable = {
                type = "toggle",
                order = 1,
                name = "Enable Grinding",
                desc = "Check to enable grinding",
                width = "full",
                get = function()
                    return DMW.Helpers.Navigation.Mode == 1
                end,
                set = function(info, value)
                    if value then
                        DMW.Helpers.Navigation.Mode = 1
                    else
                        DMW.Helpers.Navigation.Mode = 0
                    end
                end
            },
            AttackDistance = {
                type = "range",
                order = 2,
                name = "Attack Distance",
                desc = "Set distance to stop moving towards target",
                width = "full",
                min = 0.0,
                max = 40.0,
                step = 0.2,
                get = function()
                    return DMW.Settings.profile.Navigation.AttackDistance
                end,
                set = function(info, value)
                    DMW.Settings.profile.Navigation.AttackDistance = value
                end
            },
            MaxDistance = {
                type = "range",
                order = 3,
                name = "Max Attack Distance",
                desc = "Set distance to start moving towards target again",
                width = "full",
                min = 0.0,
                max = 40.0,
                step = 0.2,
                get = function()
                    return DMW.Settings.profile.Navigation.MaxDistance
                end,
                set = function(info, value)
                    DMW.Settings.profile.Navigation.MaxDistance = value
                end
            },
            LevelRange = {
                type = "range",
                order = 4,
                name = "Max level difference",
                desc = "Set max level difference of mobs",
                width = "full",
                min = 0,
                max = 60,
                step = 1,
                get = function()
                    return DMW.Settings.profile.Navigation.LevelRange
                end,
                set = function(info, value)
                    DMW.Settings.profile.Navigation.LevelRange = value
                end
            },
            WorldMapHook = {
                type = "toggle",
                order = 5,
                name = "World Map Hook",
                desc = "Check to enable world map hook, hold shift and click on world map to generate path",
                width = "full",
                get = function()
                    return DMW.Settings.profile.Navigation.WorldMapHook
                end,
                set = function(info, value)
                    DMW.Settings.profile.Navigation.WorldMapHook = value
                    ReloadUI()
                end
            },
            FoodHP = {
                type = "range",
                order = 6,
                name = "Food HP",
                desc = "Set HP to eat at, remember to set item id for food",
                width = 2,
                min = 0,
                max = 100,
                step = 1,
                get = function()
                    return DMW.Settings.profile.Navigation.FoodHP
                end,
                set = function(info, value)
                    DMW.Settings.profile.Navigation.FoodHP = value
                end
            },
            FoodID = {
                type = "input",
                order = 7,
                name = "Food ID",
                desc = "Enter item id of food",
                width = 0.6,
                get = function()
                    return tostring(DMW.Settings.profile.Navigation.FoodID)
                end,
                set = function(info, value)
                    if tonumber(value) then
                        DMW.Settings.profile.Navigation.FoodID = tonumber(value)
                    else
                        DMW.Settings.profile.Navigation.FoodID = 0
                    end
                end
            }
        }
    }
end
