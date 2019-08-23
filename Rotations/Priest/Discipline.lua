local DMW = DMW
local Priest = DMW.Rotations.PRIEST
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, CDs, HUD, Player40Y, Player40YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {
            [1] = {
                CDs = {
                    [1] = {Text = "Cooldowns |cFF00FF00Auto", Tooltip = ""},
                    [2] = {Text = "Cooldowns |cFFFFFF00Always On", Tooltip = ""},
                    [3] = {Text = "Cooldowns |cffff0000Disabled", Tooltip = ""}
                }
            },
            [2] = {
                Mode = {
                    [1] = {Text = "Rotation Mode |cFF00FF00Auto", Tooltip = ""},
                    [2] = {Text = "Rotation Mode |cFFFFFF00Single", Tooltip = ""}
                }
            },
            [3] = {
                Interrupts = {
                    [1] = {Text = "Interrupts |cFF00FF00Enabled", Tooltip = ""},
                    [2] = {Text = "Interrupts |cffff0000Disabled", Tooltip = ""}
                }
            }
        }

        UI.AddHeader("General")
        UI.AddHeader("Defensive")
        UI.AddToggle("Healthstone", nil, true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Talent = Player.Talents
    Trait = Player.Traits
    Item = Player.Items
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
    CDs = Player:CDs() and Target and Target.TTD > 5 and Target.Distance < 5
end