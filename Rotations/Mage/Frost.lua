local DMW = DMW
local Mage = DMW.Rotations.MAGE
local Player, Buff, Debuff, Spell, Target, Pet, GCD, Pet5Y, Pet5YC, HUD, Player40Y, Player40YC, Runeforge, Conduit, BlizzardUnits
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
    Runeforge = Player.Runeforge
    Conduit = Player.Conduits
    if Target then
        BlizzardUnits = select(2, Target:GetAttackable(10, 4))
    else
        BlizzardUnits = 0
    end
end

local function Defensive()
    if Player:Dispel(Spell.RemoveCurse) and Spell.RemoveCurse:Cast(Player) then
        return true
    end
end

local function CDs()
    -- actions.cds=potion,if=prev_off_gcd.icy_veins|fight_remains<30
    -- actions.cds+=/deathborne
    -- actions.cds+=/mirrors_of_torment,if=active_enemies<3&(conduit.siphoned_malice|soulbind.wasteland_propriety)
    -- actions.cds+=/rune_of_power,if=cooldown.icy_veins.remains>12&buff.rune_of_power.down
    if Player.Moving and Spell.IcyVeins:CD() > 12 and Spell.RuneOfPower:Cast(Player) then
        return true
    end
    -- actions.cds+=/icy_veins,if=buff.rune_of_power.down
    if not Buff.RuneOfPower:Exist() and Spell.IcyVeins:Cast(Player) then
        return true
    end
    -- actions.cds+=/time_warp,if=runeforge.temporal_warp&buff.exhaustion.up&(prev_off_gcd.icy_veins|fight_remains<30)
    -- actions.cds+=/use_items
    -- actions.cds+=/blood_fury
    -- actions.cds+=/berserking
    -- actions.cds+=/lights_judgment
    -- actions.cds+=/fireblood
    -- actions.cds+=/ancestral_call
    -- actions.cds+=/bag_of_tricks
end

local function Movement()
    -- actions.movement+=/ice_floes,if=buff.ice_floes.down
    -- if Player.Moving and not Buff.IceFloes:Exist() and Spell.IceFloes:Cast(Player) then
    --     return true
    -- end
    -- actions.movement+=/arcane_explosion,if=mana.pct>30&active_enemies>=2
    if Player.PowerPct > 30 and select(2, Player:GetEnemies(10)) >= 2 and Spell.ArcaneExplosion:Cast(Player) then
        return true
    end
    -- actions.movement+=/fire_blast
    if Spell.FireBlast:Cast(Target) then
        return true
    end
    -- actions.movement+=/ice_lance
    if Spell.IceLance:Cast(Target) then
        return true
    end
end

local function AoE()
    if not Player.Moving then
        -- actions.aoe=frozen_orb
        if Player:GetEnemiesInRect(35, 17, 5) >= 3 and Spell.FrozenOrb:Cast(Player) then
            return true
        end
        -- actions.aoe+=/blizzard
        if Spell.Blizzard:Cast(Target) then
            return true
        end
    end
    -- actions.aoe+=/flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&buff.fingers_of_frost.react=0)
    if not Debuff.WintersChill:Exist(Target) and (Spell.Ebonbolt:LastCast() or Buff.BrainFreeze:Exist()) and Spell.Flurry:Cast(Target) then
        return true
    end
    -- actions.aoe+=/ice_nova
    if Spell.IceNova:Cast(Target) then
        return true
    end
    -- actions.aoe+=/comet_storm
    if Spell.CometStorm:Cast(Target) then
        return true
    end
    -- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time|remaining_winters_chill&debuff.winters_chill.remains>travel_time
    if (Buff.FingersOfFrost:Exist() or Debuff.WintersChill:Remain(Target) > 1.5) and Spell.IceLance:Cast(Target) then
        return true
    end
    if not Player.Moving then
        -- actions.aoe+=/radiant_spark
        if Spell.RadiantSpark:Cast(Target) then
            return true
        end
        -- actions.aoe+=/mirrors_of_torment
        if Spell.MirrorsOfTorment:Cast(Target) then
            return true
        end
        -- actions.aoe+=/shifting_power
        if Spell.ShiftingPower:Cast() then
            return true
        end
    end
    -- actions.aoe+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
    -- actions.aoe+=/arcane_explosion,if=mana.pct>30&active_enemies>=6
    if Player.PowerPct > 30 and select(2, Player:GetEnemies(10)) >= 6 and Spell.ArcaneExplosion:Cast(Player) then
        return true
    end
    if not Player.Moving then
        -- actions.aoe+=/ebonbolt
        if Spell.Ebonbolt:Cast(Target) then
            return true
        end
        -- actions.aoe+=/ice_lance,if=runeforge.glacial_fragments&talent.splitting_ice&travel_time<ground_aoe.blizzard.remains
        -- actions.aoe+=/wait,sec=0.1,if=runeforge.glacial_fragments&talent.splitting_ice
        -- actions.aoe+=/frostbolt
        if Spell.Frostbolt:Cast(Target) then
            return true
        end
    end
end

local function SingleTarget()
    -- actions.st=flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)
    --&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.glacial_spike|prev_gcd.1.frostbolt&
    --(!conduit.ire_of_the_ascended|cooldown.radiant_spark.remains|runeforge.freezing_winds)|prev_gcd.1.radiant_spark|buff.fingers_of_frost.react=0&
    --(debuff.mirrors_of_torment.up|buff.freezing_winds.up|buff.expanded_potential.react)))
    if not Debuff.WintersChill:Exist(Target) and (Spell.Ebonbolt:LastCast() or (Buff.BrainFreeze:Exist() and (Spell.GlacialSpike:LastCast() or Spell.Frostbolt:LastCast())) or Spell.RadiantSpark:LastCast()) and Spell.Flurry:Cast(Target) then
        return true
    end
    -- actions.st+=/frozen_orb
    local OrbTargets = Player:CDs() and 1 or 2
    if Player:GetEnemiesInRect(35, 17, 5) > OrbTargets and Spell.FrozenOrb:Cast(Player) then
        return true
    end
    -- actions.st+=/blizzard,if=buff.freezing_rain.up|active_enemies>=2
    if (Buff.FreezingRain:Exist() or (not Player.Moving and BlizzardUnits >= 2)) and Spell.Blizzard:Cast(Target) then
        return true
    end
    if not Player.Moving then
        -- actions.st+=/ray_of_frost,if=remaining_winters_chill=1&debuff.winters_chill.remains
        if Debuff.WintersChill:Exist(Target) and Spell.RayOfFrost:Cast(Target) then
            return true
        end
        -- actions.st+=/glacial_spike,if=remaining_winters_chill&debuff.winters_chill.remains>cast_time+travel_time
        if Debuff.WintersChill:Remain(Target) > Spell.GlacialSpike:CastTime() + 1.5 and Spell.GlacialSpike:Cast(Target) then
            return true
        end
    end
    -- actions.st+=/ice_lance,if=remaining_winters_chill&remaining_winters_chill>buff.fingers_of_frost.react&debuff.winters_chill.remains>travel_time
    if Debuff.WintersChill:Remain(Target) > 1.5 and Spell.IceLance:Cast(Target) then
        return true
    end
    -- actions.st+=/comet_storm
    if Spell.CometStorm:Cast(Target) then
        return true
    end
    -- actions.st+=/ice_nova
    if Spell.IceNova:Cast(Target) then
        return true
    end
    -- actions.st+=/radiant_spark,if=buff.freezing_winds.up&active_enemies=1
    if not Player.Moving and Buff.FreezingWinds:Exist() and BlizzardUnits == 1 and Spell.RadiantSpark:Cast(Target) then
        return true
    end
    -- actions.st+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time
    if Buff.FingersOfFrost:Exist() and Spell.IceLance:Cast(Target) then
        return true
    end
    if not Player.Moving then
        -- actions.st+=/ebonbolt
        if Spell.Ebonbolt:Cast(Target) then
            return true
        end
        -- actions.st+=/radiant_spark,if=(!runeforge.freezing_winds|active_enemies>=2)&buff.brain_freeze.react
        if (not Runeforge.FreezingWinds or BlizzardUnits >= 2) and Buff.BrainFreeze:Exist() and Spell.RadiantSpark:Cast(Target) then
            return true
        end
        -- actions.st+=/mirrors_of_torment
        if Spell.MirrorsOfTorment:Cast(Target) then
            return true
        end
        -- actions.st+=/shifting_power,if=buff.rune_of_power.down&(soulbind.grove_invigoration|soulbind.field_of_blossoms|active_enemies>=2)
        if not Buff.RuneOfPower:Exist() and BlizzardUnits >= 2 and Spell.ShiftingPower:Cast() then
            return true
        end
    end
    -- actions.st+=/arcane_explosion,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_arcane.down
    -- actions.st+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
    -- actions.st+=/glacial_spike,if=buff.brain_freeze.react
    if not Player.Moving then
        if Buff.BrainFreeze:Exist() and Spell.GlacialSpike:Cast(Target) then
            return true
        end
        -- actions.st+=/frostbolt
        if Spell.Frostbolt:Cast(Target) then
            return true
        end
    end
end

local function PetStuff()
end

local function Interrupt()
end

local function RunRotation()
    if not IsCurrentSpell(6603) then
        StartAttack(Target.Pointer)
    end
    if Pet and not Pet.Dead and not UnitIsUnit("pettarget", Target.Pointer) then
        PetAttack()
    end
    Pet5YC = 0
    if Pet then
        Pet5Y, Pet5YC = Pet:GetEnemies(5)
    end
    if Defensive() then
        return true
    end
    if Interrupt() then
        return true
    end
    --actions+=/call_action_list,name=cds
    if Player:CDs() and CDs() then
        return true
    end
    --actions+=/call_action_list,name=aoe,if=active_enemies>=3
    if BlizzardUnits >= 3 and AoE() then
        return true
    end
    --actions+=/call_action_list,name=st,if=active_enemies<3
    if BlizzardUnits < 3 and SingleTarget() then
        return true
    end
    --actions+=/call_action_list,name=movement
    if Movement() then
        return true
    end
end

function Mage.Frost()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if PetStuff() then
            return true
        end
        Player:AutoTarget(40)
        if Target and Target.ValidEnemy then
            RunRotation()
        end
    end
end
