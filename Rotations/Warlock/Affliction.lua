local DMW = DMW
local Warlock = DMW.Rotations.WARLOCK
local Player, Buff, Debuff, Spell, Target

function Warlock.Affliction()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Target = Player.Target or false

    if not Player.Casting and Target and Target.ValidEnemy then
        if Debuff.Agony:Refresh(Target) then
            if Spell.Agony:Cast(Target) then
                return true
            end
        end
        if Debuff.Corruption:Refresh(Target) then
            if Spell.Corruption:Cast(Target) then
                return true
            end
        end
    end
end