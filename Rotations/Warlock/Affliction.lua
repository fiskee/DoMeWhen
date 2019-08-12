local DMW = DMW
if not DMW.Rotations.WARLOCK then
    DMW.Rotations.WARLOCK = {}
end
local Warlock = DMW.Rotations.WARLOCK
local Player, Buff, Debuff, Spell, Target

function Warlock.Affliction()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Target = Player.Target or false

    if not Player.Casting then
        
    end
end