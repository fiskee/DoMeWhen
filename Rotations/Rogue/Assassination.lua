local DMW = DMW
local Rogue = DMW.Rotations.ROGUE
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, HUD, Player5Y, Player5YC, Player10Y, Player10YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {
            CDs = {
                [1] = {Text = "Cooldowns |cFF00FF00Auto", Tooltip = ""},
                [2] = {Text = "Cooldowns |cFFFFFF00Always On", Tooltip = ""},
                [3] = {Text = "Cooldowns |cffff0000Disabled", Tooltip = ""}
            },
            Mode = {
                [1] = {Text = "Rotation Mode |cFF00FF00Auto", Tooltip = ""},
                [2] = {Text = "Rotation Mode |cFFFFFF00Single", Tooltip = ""}
            },
            Interrupts = {
                [1] = {Text = "Interrupts |cFF00FF00Enabled", Tooltip = ""},
                [2] = {Text = "Interrupts |cffff0000Disabled", Tooltip = ""}
            }
        }

        UI.AddHeader("DPS")
        UI.AddToggle("Vendetta", "Use Vendetta", true)
        UI.AddToggle("Vanish", "Use Vanish", true)
        UI.AddHeader("Defensive")
        UI.AddToggle("Healthstone", "Use Healthstone", true)
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
end

local function OOC()
    if not Player.Moving then
        if not Spell.DeadlyPoison:LastCast() and Buff.DeadlyPoison:Remain() < 300 then
            if Spell.DeadlyPoison:Cast(Player) then
                return true
            end
        elseif not Spell.CripplingPoison:LastCast() and Buff.CripplingPoison:Remain() < 300 then
            if Spell.CripplingPoison:Cast(Player) then
                return true
            end
        end
    end
    if IsUsableSpell(Spell.Stealth.SpellName) and not Spell.Vanish:LastCast() and not IsResting() and (DMW.Time - Spell.Stealth.LastCastTime) > 0.2 then
        if Spell.Stealth:Cast(Player) then
            return true
        end
    end
end

function Rogue.Assassination()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat then
            OOC()
        end
        if (Target and Target.ValidEnemy) or Player.Combat then
            Player:AutoTarget(5)
        end
    end
end