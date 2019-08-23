local DMW = DMW
local Priest = DMW.Rotations.PRIEST
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, CDs, HUD, Player40Y, Player40YC, Friends40Y, Friends40YC
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
    Friends40Y, Friends40YC = Player:GetFriends(40)
    Player40Y, Player40YC = Player:GetEnemies(40)
end

local function OOC()
    for _, Unit in ipairs(Friends40Y) do
        if Buff.Atonement:Remain(Unit) < 3 then
            if Spell.PowerWordShield:Cast(Unit) then
                return true
            end
        end
    end
end

local function Heals()

end

local function DPS()
    --SWP
    for _, Unit in ipairs(Player40Y) do
        if Debuff.ShadowWordPain:Refresh(Unit) then
            if Spell.ShadowWordPain:Cast(Unit) then
                return true
            end
        end
    end
    if Target and Target.ValidEnemy then
        if Target.TTD > 4 and Spell.Penance:Cast(Target) then
            return true
        end
        if Spell.Smite:Cast(Target) then
            return true
        end
    end
end

function Priest.Discipline()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat then
            if OOC() then
                return true
            end
            if Target and Target.ValidEnemy then
                if Spell.ShadowWordPain:Cast(Target) then
                    return true
                end
            end
        else
            if Heals() then
                return true
            end
            if DPS() then
                return true
            end
        end
    end
end