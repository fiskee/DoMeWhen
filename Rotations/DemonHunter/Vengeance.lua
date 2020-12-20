local DMW = DMW
local DemonHunter = DMW.Rotations.DEMONHUNTER
local Player, Buff, Debuff, Spell, Target, GCD, HUD, Player40Y, Player40YC, Player5Y, Player5YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation

local function CreateSettings()
    if not UI.HUD.Options then

    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end