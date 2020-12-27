local DMW = DMW
local Mage = DMW.Rotations.MAGE
local Player, Buff, Debuff, Spell, Target, GCD, HUD, Talent, Player40Y, Player40YC, Runeforge, Conduit, FlamestrikeUnits
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
    Runeforge = Player.Runeforge
    Conduit = Player.Conduits
    Talent = Player.Talents
    if Target then
        FlamestrikeUnits = select(2, Target:GetAttackable(8))
    else
        FlamestrikeUnits = 0
    end
end

local function Defensive()
    if Player:Dispel(Spell.RemoveCurse) and Spell.RemoveCurse:Cast(Player) then
        return true
    end
end

local function Fallback()
    if not Talent.FromTheAshes.Active and Debuff.Ignite:Exist(Target) and Spell.PhoenixFlames:Charges() == Spell.PhoenixFlames:MaxCharges() and Spell.PhoenixFlames:Cast(Target) then
        return true
    end
    if Spell.Scorch:Cast(Target) then
        return true
    end
end

local function Standing()
    if not Player.Combat and not Spell.Pyroblast:LastCast() and not Spell.Pyroblast:LastCast(2) and Spell.Pyroblast:Cast(Target) then
        return true
    end
    if FlamestrikeUnits >= 3 and not Spell.Pyroblast:LastCast() and Spell.Pyroblast:LastCast(2) and not Buff.Combustion:Exist() and Spell.PhoenixFlames:Cast(Target) then
        return true
    end
    if (Spell.Combustion:CD() > 20 or not Player:CDs()) and Target.TTD > 8 and not Buff.RuneOfPower:Exist() and Spell.RuneOfPower:Cast(Player) then
        return true
    end
    if Talent.Meteor.Active and not Target.Moving and (((Spell.Combustion:CD() == 0 or Spell.Combustion:CD() > 40) and Player:CDs()) or FlamestrikeUnits >= 3) and Spell.Meteor:Cast(Target) then
        return true
    end
    if Player.Combat and Player:CDs() and Target.TTD > 8 then
        if not Talent.Firestarter.Active and not Buff.Combustion:Exist() and Spell.Combustion:Cast(Player) then
            return true
        end
        if Talent.Firestarter.Active and (Target.HP < 90 or FlamestrikeUnits >= 3) and not Buff.Combustion:Exist() and Spell.Combustion:Cast(Player) then
            return true
        end
    end
    if FlamestrikeUnits >= 3 and Buff.HotStreak:Exist() then
        if not Talent.FlamePatch.Active then
            if Conduit.MasterFlame then
                if (FlamestrikeUnits >= 4 or Spell.PhoenixFlames:Charges() == 0) and Spell.Flamestrike:Cast(Target) then
                    return true
                end
            else
                if (FlamestrikeUnits >= 5 or Spell.PhoenixFlames:Charges() == 0) and Spell.Flamestrike:Cast(Target) then
                    return true
                end
            end
        elseif Spell.Flamestrike:Cast(Target) then
            return true
        end
    end
    if Buff.HotStreak:Exist() and Spell.Pyroblast:Cast(Target) then
        return true
    end
    if not Spell.FireBlast:LastCast() and Buff.Combustion:Exist() and Spell.FireBlast:Cast(Target) then
        return true
    end
    if Talent.Pyroclasm.Active and Buff.Pyroclasm:Exist() and (Buff.Combustion:Remain() > Spell.Pyroblast:CastTime() or not Buff.Combustion:Exist()) and Spell.Pyroblast:Cast(Target) then
        return true
    end
    if Buff.HeatingUp:Exist() and (Buff.Combustion:Exist() or Buff.RuneOfPower:Exist() or Spell.FireBlast:FullRechargeTime() < Spell.Combustion:CD() or Target.TTD < 8 or not Player:CDs()) and Spell.FireBlast:Cast(Target) then
        return true
    end
    if Buff.Combustion:Exist() and Spell.PhoenixFlames:Cast(Target) then
        return true
    end
    if Buff.Combustion:Remain() > GCD and Spell.Scorch:Cast(Target) then
        return true
    end
    if Spell.Combustion:CD() > 15 and not Buff.RuneOfPower:Exist() and Spell.ShiftingPower:Cast(Player) then
        return true
    end
    if not Talent.FromTheAshes.Active and Debuff.Ignite:Exist(Target) and Spell.PhoenixFlames:Charges() == Spell.PhoenixFlames:MaxCharges() and Spell.PhoenixFlames:Cast(Target) then
        return true
    end
    if Talent.SearingTouch.Active and Target.HP < 30 and Spell.Scorch:Cast(Target) then
        return true
    end
    if Spell.Fireball:Cast(Target) then
        return true
    end
end

local function Interrupt()
end

local function RunRotation()
    if not IsCurrentSpell(6603) then
        StartAttack(Target.Pointer)
    end
    if Player.Casting then
        if Buff.HeatingUp:Exist() and (Buff.Combustion:Exist() or Buff.RuneOfPower:Exist() or Spell.FireBlast:FullRechargeTime() < Spell.Combustion:CD() or Target.TTD < 8) and Spell.FireBlast:Cast(Target) then
            return true
        end
    else
        if Defensive() then
            return true
        end
        if Interrupt() then
            return true
        end
        if not Player.Moving and Standing() then
            return true
        end
        if Fallback() then
            return true
        end
    end
end

function Mage.Fire()
    Locals()
    CreateSettings()
    if Rotation.Active(false) then
        Player:AutoTarget(40)
        if Target and Target.ValidEnemy then
            RunRotation()
        end
    end
end
