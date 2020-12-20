local DMW = DMW
local DeathKnight = DMW.Rotations.DEATHKNIGHT
local Player, Buff, Debuff, Spell, Target, Pet, GCD, Pet5Y, Pet5YC, HUD, Player40Y, Player40YC, Player5Y, Player5YC
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
    Pet = Player.Pet or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end