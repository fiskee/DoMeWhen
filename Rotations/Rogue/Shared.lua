local DMW = DMW
DMW.Rotations.ROGUE = {}
local Rogue = DMW.Rotations.ROGUE
local Buff, Spell

function Rogue.Stealth()
    Buff = DMW.Player.Buffs
    Spell = DMW.Player.Spells
    return Buff.Stealth:Exist(DMW.Player) or Buff.Vanish:Exist(DMW.Player) or (Buff.Subterfuge and Buff.Subterfuge:Remain() > 0.4) or Spell.Vanish:LastCast()
end