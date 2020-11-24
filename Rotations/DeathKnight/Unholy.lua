local DMW = DMW
local DeathKnight = DMW.Rotations.DEATHKNIGHT
local Player, Buff, Debuff, Spell, Target, Pet, Trait, Talent, GCD, Pet5Y, Pet5YC, HUD, Player8Y, Player8YC, Player5Y, Player5YC, Player15Y, Player15YC
local WoundSpender, AnyDnD, Pooling = false, false, false
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local PetTimer = GetTime()

local function CreateSettings()
    if not UI.HUD.Options then

    end
end

local function SetDnD()
    if Spell.DeathsDue:IsKnown() then
        AnyDnD = Spell.DeathsDue
    elseif Spell.Defile:IsKnown() then
        AnyDnD = Spell.Defile
    else
        AnyDnD = Spell.DeathAndDecay
    end
end

local function SetSpender()
    if Spell.ClawingShadows:IsKnown() then
        WoundSpender = Spell.ClawingShadows
    else
        WoundSpender = Spell.ScourgeStrike
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Trait = Player.Traits
    Target = Player.Target or false
    Talent = Player.Talents
    Pet = Player.Pet or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
    SetDnD()
    SetSpender()
end

local function Cooldowns()
    -- # Potions and other on use
    -- actions.cooldowns=use_items
    -- actions.cooldowns+=/potion,if=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned.enabled&(pet.army_ghoul.active|cooldown.army_of_the_dead.remains>target.time_to_die)
    -- # Cooldowns
    -- actions.cooldowns+=/army_of_the_dead,if=cooldown.unholy_blight.remains<5&talent.unholy_blight.enabled|!talent.unholy_blight.enabled
    -- actions.cooldowns+=/unholy_blight,if=!raid_event.adds.exists&(cooldown.army_of_the_dead.remains>5|death_knight.disable_aotd)&(cooldown.apocalypse.ready&(debuff.festering_wound.stack>=4|rune>=3)|cooldown.apocalypse.remains)&!raid_event.adds.exists
    -- actions.cooldowns+=/unholy_blight,if=raid_event.adds.exists&(active_enemies>=2|raid_event.adds.in>15)
    -- actions.cooldowns+=/dark_transformation,if=!raid_event.adds.exists&cooldown.unholy_blight.remains&(!runeforge.deadliest_coil.equipped|runeforge.deadliest_coil.equipped&(!buff.dark_transformation.up&!talent.unholy_pact.enabled|talent.unholy_pact.enabled))
    -- actions.cooldowns+=/dark_transformation,if=!raid_event.adds.exists&!talent.unholy_blight.enabled
    -- actions.cooldowns+=/dark_transformation,if=raid_event.adds.exists&(active_enemies>=2|raid_event.adds.in>15)
    if Pet and not Pet.Dead and DMW.Time > PetTimer and UnitIsUnit("pettarget", Target.Pointer) and Spell.DarkTransformation:Cast(Player) then
        return true
    end
    -- actions.cooldowns+=/apocalypse,if=active_enemies=1&debuff.festering_wound.stack>=4&((!talent.unholy_blight.enabled|talent.army_of_the_damned.enabled|conduit.convocation_of_the_dead.enabled)|talent.unholy_blight.enabled&!talent.army_of_the_damned.enabled&dot.unholy_blight.remains)
    if Player5YC == 1 and Debuff.FesteringWound:Stacks(Target) >= 4 and ((not Talent.UnholyBlight.Active or Talent.ArmyOfTheDamned.Active) or (Talent.UnholyBlight.Active and not Talent.ArmyOfTheDamned.Active and Buff.UnholyBlight:Exist())) and Spell.Apocalypse:Cast(Target) then
        return true
    end
    -- actions.cooldowns+=/apocalypse,target_if=max:debuff.festering_wound.stack,if=active_enemies>=2&debuff.festering_wound.stack>=4&!death_and_decay.ticking
    if Player5YC >= 2 and not AnyDnD:Ticking() then
        local Unit, Stacks = Debuff.FesteringWound:HighestStacks(Player5Y)
        if Stacks >= 4 and Spell.Apocalypse:Cast(Unit) then
            return true
        end
    end
    -- actions.cooldowns+=/summon_gargoyle,if=runic_power.deficit<14
    -- actions.cooldowns+=/unholy_assault,if=active_enemies=1&debuff.festering_wound.stack<2&(pet.apoc_ghoul.active|conduit.convocation_of_the_dead.enabled)
    -- actions.cooldowns+=/unholy_assault,target_if=min:debuff.festering_wound.stack,if=active_enemies>=2&debuff.festering_wound.stack<2
    -- actions.cooldowns+=/soul_reaper,target_if=target.time_to_pct_35<5&target.time_to_die>5
    if ((#DMW.Friends.Units == 1 and Target.TTD < 3) or (#DMW.Friends.Units > 1 and Target.TTD > 5 and Target:GetTTD(35) < 5)) and Spell.SoulReaper:Cast(Target) then
        return true
    end
end

local function AoEBurst()
    -- actions.aoe_burst=epidemic,if=runic_power.deficit<(10+death_knight.fwounded_targets*3)&death_knight.fwounded_targets<6&!variable.pooling_for_gargoyle
    -- actions.aoe_burst+=/epidemic,if=runic_power.deficit<25&death_knight.fwounded_targets>5&!variable.pooling_for_gargoyle
    -- actions.aoe_burst+=/epidemic,if=!death_knight.fwounded_targets&!variable.pooling_for_gargoyle
    -- actions.aoe_burst+=/wound_spender
    -- actions.aoe_burst+=/epidemic,if=!variable.pooling_for_gargoyle
end

local function AoESetup()
    if Target.TTD > 5 and Spell.ShackleTheUnworthy:Cast(Target) then
        return true
    end
    -- actions.aoe_setup=any_dnd,if=death_knight.fwounded_targets=active_enemies|raid_event.adds.exists&raid_event.adds.remains<=11
    if not Player.Moving and Target.TTD > 4 and Spell.DeathAndDecay:Cast(Player) then
        return true
    end
    -- actions.aoe_setup+=/any_dnd,if=death_knight.fwounded_targets>=5
    -- actions.aoe_setup+=/epidemic,if=!variable.pooling_for_gargoyle&runic_power.deficit<20|buff.sudden_doom.react
    -- actions.aoe_setup+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack<=3&cooldown.apocalypse.remains<3
    -- actions.aoe_setup+=/festering_strike,target_if=debuff.festering_wound.stack<1
    -- actions.aoe_setup+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=rune.time_to_4<(cooldown.death_and_decay.remains&!talent.defile.enabled|cooldown.defile.remains&talent.defile.enabled)
    -- actions.aoe_setup+=/epidemic,if=!variable.pooling_for_gargoyle
end

local function AoE()
    -- actions.generic_aoe=epidemic,if=buff.sudden_doom.react
    -- actions.generic_aoe+=/epidemic,if=!variable.pooling_for_gargoyle
    -- actions.generic_aoe+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=(cooldown.apocalypse.remains>5&debuff.festering_wound.up|debuff.festering_wound.stack>4)&(fight_remains<cooldown.death_and_decay.remains+10|fight_remains>cooldown.apocalypse.remains)
    -- actions.generic_aoe+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack<=3&cooldown.apocalypse.remains<3|debuff.festering_wound.stack<1
    -- actions.generic_aoe+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=cooldown.apocalypse.remains>5&debuff.festering_wound.stack<1
end

local function SingleTarget()
    -- actions.generic=death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
    if Buff.SuddenDoom:Exist() and not Pooling and Spell.DeathCoil:Cast(Target) then --FIX THIS
        return true
    end
    -- actions.generic+=/death_coil,if=runic_power.deficit<13&!variable.pooling_for_gargoyle
    if Player.PowerDeficit < 13 and not Pooling and Spell.DeathCoil:Cast(Target) then
        return true
    end
    -- actions.generic+=/defile,if=cooldown.apocalypse.remains
    if not Player.Moving and Target.TTD > 4 and Target.Distance <= 5 and Talent.Defile.Active and Spell.Apocalypse:CD() > 0 and Spell.Defile:Cast(Player) then
        return true
    end
    -- actions.generic+=/wound_spender,if=debuff.festering_wound.stack>4
    if Debuff.FesteringWound:Stacks(Target) > 4 and WoundSpender:Cast(Target) then
        return true
    end
    -- actions.generic+=/wound_spender,if=debuff.festering_wound.up&cooldown.apocalypse.remains>5&(!talent.unholy_blight.enabled|talent.army_of_the_damned.enabled|conduit.convocation_of_the_dead.enabled|raid_event.adds.exists)
    if Debuff.FesteringWound:Exist(Target) and (Spell.Apocalypse:CD() > 5 or not Player:CDs()) and (not Talent.UnholyBlight.Active or Talent.ArmyOfTheDamned.Active) and WoundSpender:Cast(Target) then
        return true
    end
    -- actions.generic+=/wound_spender,if=debuff.festering_wound.up&talent.unholy_blight.enabled&!talent.army_of_the_damned.enabled&!conduit.convocation_of_the_dead.enabled&!raid_event.adds.exists&(cooldown.unholy_blight.remains>5&cooldown.apocalypse.ready&!dot.unholy_blight.remains|!cooldown.apocalypse.ready)
    if Debuff.FesteringWound:Exist(Target) and Talent.UnholyBlight.Active and not Talent.ArmyOfTheDamned.Active and ((Spell.UnholyBlight:CD() > 5 and Spell.Apocalypse:IsReady() and not Buff.UnholyBlight:Exist(Player)) or not Spell.Apocalypse:IsReady()) and WoundSpender:Cast(Target) then
        return true
    end
    -- actions.generic+=/death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
    if Player.PowerDeficit < 20 and not Pooling and Spell.DeathCoil:Cast(Target) then
        return true
    end
    -- actions.generic+=/festering_strike,if=debuff.festering_wound.stack<1
    if Debuff.FesteringWound:Stacks(Target) < 1 and Spell.FesteringStrike:Cast(Target) then
        return true
    end
    -- actions.generic+=/festering_strike,if=debuff.festering_wound.stack<4&cooldown.apocalypse.remains<3&(!talent.unholy_blight.enabled|talent.army_of_the_damned.enabled|conduit.convocation_of_the_dead.enabled|raid_event.adds.exists)
    if Debuff.FesteringWound:Stacks(Target) < 4 and Spell.Apocalypse:CD() < 3 and (not Talent.UnholyBlight.Active or Talent.ArmyOfTheDamned.Active) and Spell.FesteringStrike:Cast(Target) then
        return true
    end
    -- actions.generic+=/festering_strike,if=debuff.festering_wound.stack<4&talent.unholy_blight.enabled&!talent.army_of_the_damned.enabled&!conduit.convocation_of_the_dead.enabled&!raid_event.adds.exists&cooldown.apocalypse.ready&(cooldown.unholy_blight.remains<3|dot.unholy_blight.remains)
    if Debuff.FesteringWound:Stacks(Target) < 4 and Talent.UnholyBlight.Active and not Talent.ArmyOfTheDamned.Active and Spell.Apocalypse:IsReady() and (Spell.UnholyBlight:CD() < 3 or Buff.UnholyBlight:Exist(Player)) and Spell.FesteringStrike:Cast(Target) then
        return true
    end
    -- actions.generic+=/death_coil,if=!variable.pooling_for_gargoyle
    if not Pooling and Spell.DeathCoil:Cast(Target) then
        return true
    end
end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Player15YC > 0 and Spell.MindFreeze:IsReady() then
            for _, Unit in pairs(Player15Y) do
                if Unit:Interrupt() and Spell.MindFreeze:Cast(Unit) then
                    return true
                end
            end
        end
    end
    return false
end

local function Defensive()
    if Buff.DarkSuccor:Exist() and (Buff.DarkSuccor:Remain() < 2 or Target.TTD < 2) and Spell.DeathStrike:Cast(Target) then
        return true
    end
    if Player.HP < 70 and Spell.Transfusion:Cast(Player) then
        return true
    end
    if Player.HP < 78 and Spell.DeathStrike:Cast(Target) then
        return true
    end
end

local function RunRotation()
    if Defensive() then
        return true
    end
    if Interrupt() then
        return true
    end
    -- actions.cooldowns+=/raise_dead,if=!pet.ghoul.active
    if (not Pet or Pet.Dead) and Spell.RaiseDead:Cast(Player) then
        return true
    end
    if Pet and not Pet.Dead and DMW.Time > PetTimer and not UnitIsUnit("pettarget", Target.Pointer) then
        PetTimer = DMW.Time + 1.2
        PetAttack()
    end
    -- actions+=/call_action_list,name=cooldowns
    if Player:CDs() and Cooldowns() then
        return true
    end
    -- actions+=/call_action_list,name=essences
    -- actions+=/run_action_list,name=aoe_setup,if=active_enemies>=2&(cooldown.death_and_decay.remains<10&!talent.defile.enabled|cooldown.defile.remains<10&talent.defile.enabled)&!death_and_decay.ticking
    if Player5YC >= 2 and AnyDnD:CD() < 10 and not AnyDnD:Ticking() and AoESetup() then
        return true
    end
    -- actions+=/run_action_list,name=aoe_burst,if=active_enemies>=2&death_and_decay.ticking
    if Player5YC >= 2 and AnyDnD:Ticking() and AoEBurst() then
        return true
    end
    -- actions+=/run_action_list,name=generic_aoe,if=active_enemies>=2&(!death_and_decay.ticking&(cooldown.death_and_decay.remains>10&!talent.defile.enabled|cooldown.defile.remains>10&talent.defile.enabled))
    if Player5YC >= 2 and AnyDnD:CD() > 10 and not AnyDnD:Ticking() and AoE() then
        return true
    end
    -- actions+=/call_action_list,name=generic,if=active_enemies=1
    if SingleTarget() then
        return true
    end
end


function DeathKnight.Unholy()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        Player:AutoTarget(5)
        if Target and Target.ValidEnemy then
            Player5Y, Player5YC = Player:GetEnemies(5)
            Player8Y, Player8YC = Player:GetEnemies(8)
            Player15Y, Player15YC = Player:GetEnemies(15)
            if not IsCurrentSpell(6603) then
                StartAttack(Target.Pointer)
            end
            --actions+=/variable,name=pooling_for_gargoyle,value=cooldown.summon_gargoyle.remains<5&talent.summon_gargoyle.enabled
            Pooling = Talent.SummonGargoyle.Active and Spell.SummonGargoyle:CD() < 5 and Player:CDs()
            RunRotation()
            if Buff.DarkSuccor:Exist() and Spell.DeathStrike:Cast(Target) then
                return true
            end
        end
    end
end