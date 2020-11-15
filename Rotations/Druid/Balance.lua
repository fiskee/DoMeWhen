local DMW = DMW
local Druid = DMW.Rotations.DRUID
local Player, Buff, Debuff, Spell, Target, Trait, GCD, HUD, Player40Y, Player40YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation

local function CreateSettings()
    if not UI.HUD.Options then
        UI.AddTab("General")
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Trait = Player.Traits
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end

function Druid.Balance()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        Player:AutoTarget(40)
        if Target and Target.ValidEnemy then
            
        end
    end
end
