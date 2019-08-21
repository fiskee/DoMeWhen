local DMW = DMW
local Rogue = DMW.Rotations.ROGUE
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, HUD, Player5Y, Player5YC, Player10Y, Player10YC, SingleTarget
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {
            CDs = {
                [1] = {Text = "Cooldowns |cFF00FF00Auto", Tooltip = ""},
                [2] = {Text = "Cooldowns |cFFFFFF00Always On", Tooltip = ""},
                [3] = {Text = "Cooldowns |cffff0000Disabled", Tooltip = ""}
            },
            Mode = {
                [1] = {Text = "Rotation Mode |cFF00FF00Auto", Tooltip = ""},
                [2] = {Text = "Rotation Mode |cFFFFFF00Single", Tooltip = ""}
            },
            Interrupts = {
                [1] = {Text = "Interrupts |cFF00FF00Enabled", Tooltip = ""},
                [2] = {Text = "Interrupts |cffff0000Disabled", Tooltip = ""}
            }
        }
        UI.AddHeader("General")
        UI.AddDropdown("Auto Stealth", nil, {"Disabled", "Always", "20 Yards"}, 2)
        UI.AddHeader("DPS")
        UI.AddToggle("Vendetta", "Use Vendetta", true)
        UI.AddToggle("Vanish", "Use Vanish", true)
        UI.AddHeader("Defensive")
        UI.AddToggle("Healthstone", "Use Healthstone", true)
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
    SingleTarget = #DMW.Enemies == 1
    Player5Y, Player5YC = Player:GetEnemies(5)
    Player10Y, Player10YC = Player:GetEnemies(10)
end

local function OOC()
    if not Player.Moving then
        if not Spell.DeadlyPoison:LastCast() and Buff.DeadlyPoison:Remain() < 300 then
            if Spell.DeadlyPoison:Cast(Player) then
                return true
            end
        elseif not Spell.CripplingPoison:LastCast() and Buff.CripplingPoison:Remain() < 300 then
            if Spell.CripplingPoison:Cast(Player) then
                return true
            end
        end
    end
    if Setting("Auto Stealth") ~= 1 and IsUsableSpell(Spell.Stealth.SpellName) and not Spell.Vanish:LastCast() and not IsResting() and (DMW.Time - Spell.Stealth.LastCastTime) > 0.2 then
        if Spell.Stealth:Cast(Player) then
            return true
        end
        --TODO: Add 20 yards OOC
    end
end

local function Cooldowns()
    -- actions.cds=call_action_list,name=essences,if=!stealthed.all&dot.rupture.ticking&master_assassin_remains=0
    -- # If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP.
    -- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit*1.5|combo_points.deficit>=cp_max_spend)
    -- # If no adds will die within the next 30s, use MfD on boss without any CP.
    -- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
    -- actions.cds+=/vendetta,if=!stealthed.rogue&dot.rupture.ticking&!debuff.vendetta.up&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier>1&(spell_targets.fan_of_knives<6|!cooldown.vanish.up))&(!talent.nightstalker.enabled|!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5-2*talent.deeper_stratagem.enabled)&(!equipped.azsharas_font_of_power|azerite.shrouded_suffocation.enabled|debuff.razor_coral_debuff.down|trinket.ashvanes_razor_coral.cooldown.remains<10&cooldown.toxic_blade.remains<1)
    -- # Vanish with Exsg + (Nightstalker, or Subterfuge only on 1T): Maximum CP and Exsg ready for next GCD
    -- actions.cds+=/vanish,if=talent.exsanguinate.enabled&(talent.nightstalker.enabled|talent.subterfuge.enabled&variable.single_target)&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier<=1)
    -- # Vanish with Nightstalker + No Exsg: Maximum CP and Vendetta up
    -- actions.cds+=/vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&combo_points>=cp_max_spend&debuff.vendetta.up
    -- # See full comment on https://github.com/Ravenholdt-TC/Rogue/wiki/Assassination-APL-Research.
    -- actions.cds+=/variable,name=ss_vanish_condition,value=azerite.shrouded_suffocation.enabled&(non_ss_buffed_targets>=1|spell_targets.fan_of_knives=3)&(ss_buffed_targets_above_pandemic=0|spell_targets.fan_of_knives>=6)
    -- actions.cds+=/pool_resource,for_next=1,extra_amount=45
    -- actions.cds+=/vanish,if=talent.subterfuge.enabled&!stealthed.rogue&cooldown.garrote.up&(variable.ss_vanish_condition|!azerite.shrouded_suffocation.enabled&dot.garrote.refreshable)&combo_points.deficit>=((1+2*azerite.shrouded_suffocation.enabled)*spell_targets.fan_of_knives)>?4&raid_event.adds.in>12
    -- # Vanish with Master Assasin: No stealth and no active MA buff, Rupture not in refresh range, during Vendetta+TB, during Blood essenz if available.
    -- actions.cds+=/vanish,if=talent.master_assassin.enabled&!stealthed.all&master_assassin_remains<=0&!dot.rupture.refreshable&dot.garrote.remains>3&debuff.vendetta.up&(!talent.toxic_blade.enabled|debuff.toxic_blade.up)&(!essence.blood_of_the_enemy.major|debuff.blood_of_the_enemy.up)
    -- # Shadowmeld for Shrouded Suffocation
    -- actions.cds+=/shadowmeld,if=!stealthed.all&azerite.shrouded_suffocation.enabled&dot.garrote.refreshable&dot.garrote.pmultiplier<=1&combo_points.deficit>=1
    -- # Exsanguinate when both Rupture and Garrote are up for long enough
    -- actions.cds+=/exsanguinate,if=dot.rupture.remains>4+4*cp_max_spend&!dot.garrote.refreshable
    -- actions.cds+=/toxic_blade,if=dot.rupture.ticking
    -- actions.cds+=/potion,if=buff.bloodlust.react|debuff.vendetta.up
    -- actions.cds+=/blood_fury,if=debuff.vendetta.up
    -- actions.cds+=/berserking,if=debuff.vendetta.up
    -- actions.cds+=/fireblood,if=debuff.vendetta.up
    -- actions.cds+=/ancestral_call,if=debuff.vendetta.up
    -- actions.cds+=/use_item,name=galecallers_boon,if=cooldown.vendetta.remains>45
    -- actions.cds+=/use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|debuff.vendetta.remains>10-4*equipped.azsharas_font_of_power|target.time_to_die<20
    -- actions.cds+=/use_item,name=lurkers_insidious_gift,if=debuff.vendetta.up
    -- actions.cds+=/use_item,name=lustrous_golden_plumage,if=debuff.vendetta.up
    -- actions.cds+=/use_item,effect_name=gladiators_medallion,if=debuff.vendetta.up
    -- actions.cds+=/use_item,effect_name=gladiators_badge,if=debuff.vendetta.up
    -- actions.cds+=/use_item,effect_name=cyclotronic_blast,if=master_assassin_remains=0&!debuff.vendetta.up&!debuff.toxic_blade.up&buff.memory_of_lucid_dreams.down&energy<80&dot.rupture.remains>4
    -- # Default fallback for usable items: Use on cooldown.
    -- actions.cds+=/use_items
end

local function Direct()
    -- # Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up.
    -- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
    local RegenCombined = Player.PowerRegen + ((Debuff.Garrote:Count() + Debuff.Rupture:Count()) * 7 / (2 * (1 / (1 + (GetHaste()/100)))))
    if Player.ComboPoints >= (Player.ComboMax - 1) and (Debuff.Vendetta:Exist() or Debuff.ToxicBlade:Exist() or Player.PowerDeficit <= (25 + RegenCombined) or Player10YC > 1) and (not Talent.Exsanguinate.Active or Spell.Exsanguinate:CD() > 2) then
        if Spell.Envenom:Cast(Target) then
            return true
        end
    end
    -- actions.direct+=/variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
    local UseFiller = (Player.ComboDeficit > 1 or Player.PowerDeficit <= (25 + RegenCombined) or Player10YC > 1) and not Rogue.Stealth()
    -- # With Echoing Blades, Fan of Knives at 2+ targets.
    -- actions.direct+=/fan_of_knives,if=variable.use_filler&azerite.echoing_blades.enabled&spell_targets.fan_of_knives>=2
    if UseFiller and Trait.EchoingBlades.Active and Player10YC > 1 then
        if Spell.FanOfKnives:Cast(Player) then
            return true
        end
    end
    -- # Fan of Knives at 19+ stacks of Hidden Blades or against 4+ (5+ with Double Dose) targets.
    -- actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|(!priority_rotation&spell_targets.fan_of_knives>=4+(azerite.double_dose.rank>2)+stealthed.rogue))
    if UseFiller and (Buff.HiddenBlades:Stacks() >= 19 or (Player10YC >= (4 + (Trait.DoubleDose.Rank > 2 and 1 or 0) + (Rogue.Stealth() and 1 or 0)))) then
        if Spell.FanOfKnives:Cast(Player) then
            return true
        end
    end
    -- # Fan of Knives to apply Deadly Poison if inactive on any target at 3 targets.
    -- actions.direct+=/fan_of_knives,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives>=3
    if UseFiller and Player10YC >= 3 then
        local FoKUnit = Debuff.DeadlyPoison:Lowest(Player10Y)
        if not Debuff.DeadlyPoison:Exist(FoKUnit) then
            if Spell.FanOfKnives:Cast(Player) then
                return true
            end
        end
    end
    -- actions.direct+=/blindside,if=variable.use_filler&(buff.blindside.up|!talent.venom_rush.enabled&!azerite.double_dose.enabled)
    if UseFiller and Talent.Blindside.Active and (Buff.Blindside:Exist() or (not Talent.VenomRush.Active and not Trait.DoubleDose.Active and Target.HP < 35)) then
        if Spell.Blindside:Cast(Target) then
            return true
        end
    end
    -- # Tab-Mutilate to apply Deadly Poison at 2 targets
    -- actions.direct+=/mutilate,target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives=2
    if UseFiller and Player10YC == 2 then
        for _, Unit in pairs(Player10Y) do
            if not Debuff.DeadlyPoison:Exist(Unit) then
                if Spell.Mutilate:Cast(Unit) then
                    return true
                end
            end
        end  
    end
    -- actions.direct+=/mutilate,if=variable.use_filler
    if UseFiller then
        if Spell.Mutilate:Cast(Target) then
            return true
        end
    end
end

local function Dots()
    -- # Limit Garrotes on non-primrary targets for the priority rotation if 5+ bleeds are already up
    -- actions.dot=variable,name=skip_cycle_garrote,value=priority_rotation&spell_targets.fan_of_knives>3&(dot.garrote.remains<cooldown.garrote.duration|poisoned_bleeds>5)
    -- # Limit Ruptures on non-primrary targets for the priority rotation if 5+ bleeds are already up
    -- actions.dot+=/variable,name=skip_cycle_rupture,value=priority_rotation&spell_targets.fan_of_knives>3&(debuff.toxic_blade.up|(poisoned_bleeds>5&!azerite.scent_of_blood.enabled))
    -- # Limit Ruptures if Vendetta+Toxic Blade/Master Assassin is up and we have 2+ seconds left on the Rupture DoT
    -- actions.dot+=/variable,name=skip_rupture,value=debuff.vendetta.up&(debuff.toxic_blade.up|master_assassin_remains>0)&dot.rupture.remains>2
    -- # Special Rupture setup for Exsg
    -- actions.dot+=/rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2)))
    if Talent.Exsanguinate.Active and ((Player.ComboPoints >= Player.ComboMax and Spell.Exsanguinate:CD() < 1) or (not Debuff.Rupture:Exist(Target) and (Player.CombatTime > 10 or Player.ComboPoints >= 2))) then
        if Spell.Rupture:Cast(Target) then
            return true
        end
    end
    -- # Garrote upkeep, also tries to use it as a special generator for the last CP before a finisher
    -- actions.dot+=/pool_resource,for_next=1
    -- actions.dot+=/garrote,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1+3*(azerite.shrouded_suffocation.enabled&cooldown.vanish.up)&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&!ss_buffed&(target.time_to_die-remains)>4&(master_assassin_remains=0|!ticking&azerite.shrouded_suffocation.enabled)
    local TickTime = 2 / (1 + (GetHaste()/100))
    if (not Talent.Subterfuge.Active or not (Spell.Vanish:CD() > 0 and Spell.Vendetta:CD() <= 4)) and Player.ComboDeficit >= 1 + 3 * (Trait.ShroudedSuffocation.Active and Spell.Vanish:CD() > 0 and 1 or 0) and Debuff.Garrote:Refresh() and (Debuff.Garrote:PMultiplier() == 1 or (Debuff.Garrote:Remain() <= TickTime and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (not Debuff.Garrote:Exsanguinated() or (Debuff.Garrote:Remain() <= (TickTime * 2) and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (Debuff.Garrote:PMultiplier() == 1 or not Trait.ShroudedSuffocation.Active) and (Target.TTD - Debuff.Garrote:Remain()) > 4 and (not Buff.MasterAssassin:Exist() or (Trait.ShroudedSuffocation.Active and not Debuff.Garrote:Exist())) then
        if Spell.Garrote:CastPool(Target) then
            return true
        end
    end
    -- actions.dot+=/pool_resource,for_next=1
    -- actions.dot+=/garrote,cycle_targets=1,if=!variable.skip_cycle_garrote&target!=self.target&(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1+3*(azerite.shrouded_suffocation.enabled&cooldown.vanish.up)&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&!ss_buffed&(target.time_to_die-remains)>12&(master_assassin_remains=0|!ticking&azerite.shrouded_suffocation.enabled)
    for _, Unit in pairs(Player5Y) do
        if (not Talent.Subterfuge.Active or not (Spell.Vanish:CD() > 0 and Spell.Vendetta:CD() <= 4)) and Player.ComboDeficit >= 1 + 3 * (Trait.ShroudedSuffocation.Active and Spell.Vanish:CD() > 0 and 1 or 0) and Debuff.Garrote:Refresh(Unit) and (Debuff.Garrote:PMultiplier(Unit) == 1 or (Debuff.Garrote:Remain(Unit) <= TickTime and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (not Debuff.Garrote:Exsanguinated(Unit) or (Debuff.Garrote:Remain(Unit) <= (TickTime * 2) and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (Debuff.Garrote:PMultiplier(Unit) == 1 or not Trait.ShroudedSuffocation.Active) and (Unit.TTD - Debuff.Garrote:Remain()) > 12 and (not Buff.MasterAssassin:Exist() or (Trait.ShroudedSuffocation.Active and not Debuff.Garrote:Exist(Unit))) then
            if Spell.Garrote:CastPool(Unit) then
                return true
            end
        end
    end
    
    -- # Crimson Tempest only on multiple targets at 4+ CP when running out in 2s (up to 4 targets) or 3s (5+ targets)
    -- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4
    if Player10YC > 1 and Debuff.CrimsonTempest:Remain() < 2 + (Player10YC > 4 and 1 or 0) and Player.ComboPoints > 3 then
        if Spell.CrimsonTempest:Cast(Player) then
            return true
        end
    end
    -- # Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)
    -- actions.dot+=/rupture,if=!variable.skip_rupture&combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&target.time_to_die-remains>4
    if Player.ComboPoints > 3 and Debuff.Rupture:Refresh() and (Debuff.Rupture:PMultiplier() <= 1 or (Debuff.Rupture:Remain() <= TickTime and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (not Debuff.Rupture:Exsanguinated() or (Debuff.Rupture:Remain() <= TickTime * 2 and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (Target.TTD - Debuff.Rupture:Remain()) > 4 then
        if Spell.Rupture:Cast(Target) then
            return true
        end
    end
    -- actions.dot+=/rupture,cycle_targets=1,if=!variable.skip_cycle_rupture&!variable.skip_rupture&target!=self.target&combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3+azerite.shrouded_suffocation.enabled)&target.time_to_die-remains>4
    for _, Unit in pairs(Player5Y) do
        if Player.ComboPoints > 3 and Debuff.Rupture:Refresh(Unit) and (Debuff.Rupture:PMultiplier(Unit) <= 1 or (Debuff.Rupture:Remain(Unit) <= TickTime and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (not Debuff.Rupture:Exsanguinated(Unit) or (Debuff.Rupture:Remain(Unit) <= TickTime * 2 and Player10YC >= (3 + Trait.ShroudedSuffocation.Value))) and (Unit.TTD - Debuff.Rupture:Remain(Unit)) > 4 then
            if Spell.Rupture:Cast(Unit) then
                return true
            end
        end
    end
    
end

local function Essences()
    -- actions.essences=concentrated_flame,if=energy.time_to_max>1&!debuff.vendetta.up&(!dot.concentrated_flame_burn.ticking&!action.concentrated_flame.in_flight|full_recharge_time<gcd.max)
    -- # Always use Blood with Vendetta up. Also use with TB up before a finisher (if talented) as long as it runs for 10s during Vendetta.
    -- actions.essences+=/blood_of_the_enemy,if=debuff.vendetta.up&(!talent.toxic_blade.enabled|debuff.toxic_blade.up&combo_points.deficit<=1|debuff.vendetta.remains<=10)|target.time_to_die<=10
    -- # Attempt to align Guardian with Vendetta as long as it won't result in losing a full-value cast over the remaining duration of the fight
    -- actions.essences+=/guardian_of_azeroth,if=cooldown.vendetta.remains<3|debuff.vendetta.up|target.time_to_die<30
    -- actions.essences+=/guardian_of_azeroth,if=floor((target.time_to_die-30)%cooldown)>floor((target.time_to_die-30-cooldown.vendetta.remains)%cooldown)
    -- actions.essences+=/focused_azerite_beam,if=spell_targets.fan_of_knives>=2|raid_event.adds.in>60&energy<70
    -- actions.essences+=/purifying_blast,if=spell_targets.fan_of_knives>=2|raid_event.adds.in>60
    -- actions.essences+=/the_unbound_force,if=buff.reckless_force.up|buff.reckless_force_counter.stack<10
    -- actions.essences+=/ripple_in_space
    -- actions.essences+=/worldvein_resonance,if=buff.lifeblood.stack<3
    -- actions.essences+=/memory_of_lucid_dreams,if=energy<50&!cooldown.vendetta.up
end

local function Stealthed()
    -- # Nighstalker, or Subt+Exsg on 1T: Snapshot Rupture
    -- actions.stealthed=rupture,if=combo_points>=4&(talent.nightstalker.enabled|talent.subterfuge.enabled&(talent.exsanguinate.enabled&cooldown.exsanguinate.remains<=2|!ticking)&variable.single_target)&target.time_to_die-remains>6
    if Player.ComboPoints >= 4 and (Talent.Nightstalker.Active or (Talent.Subterfuge.Active and ((Talent.Exsanguinate.Active and Spell.Exsanguinate:CD() <= 2) or not Debuff.Rupture:Exist(Target)) and SingleTarget)) and (Target.TTD - Debuff.Rupture:Remain(Target)) > 6 then
        if Spell.Rupture:Cast(Target) then
            return true
        end
    end
    -- # Subterfuge + Shrouded Suffocation: Ensure we use one global to apply Garrote to the main target if it is not snapshot yet, so all other main target abilities profit.
    -- actions.stealthed+=/pool_resource,for_next=1
    -- actions.stealthed+=/garrote,if=azerite.shrouded_suffocation.enabled&buff.subterfuge.up&buff.subterfuge.remains<1.3&!ss_buffed
    if Trait.ShroudedSuffocation.Active and Buff.Subterfuge:Exist() and Buff.Subterfuge:Remain() < 1.3 and Debuff.Garrote:PMultiplier(Target) == 1 then
        if Spell.Garrote:CastPool(Target) then
            return true
        end
    end
    -- # Subterfuge: Apply or Refresh with buffed Garrotes
    -- actions.stealthed+=/pool_resource,for_next=1
    -- actions.stealthed+=/garrote,target_if=min:remains,if=talent.subterfuge.enabled&(remains<12|pmultiplier<=1)&target.time_to_die-remains>2
    table.sort(Player5Y, function(x,y)
        return Debuff.Garrote:Remain(x.Pointer) < Debuff.Garrote:Remain(y.Pointer)
    end)
    if Talent.Subterfuge.Active then
        for _, Unit in pairs(Player5Y) do
            if (Debuff.Garrote:Remain(Unit) < 12 or Debuff.Garrote:PMultiplier(Unit) == 1) and (Unit.TTD - Debuff.Garrote:Remain(Unit)) > 2 then
                if Spell.Garrote:CastPool(Unit) then
                    return true
                end
            end
        end
    end
    -- # Subterfuge + Shrouded Suffocation in ST: Apply early Rupture that will be refreshed for pandemic
    -- actions.stealthed+=/rupture,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&!dot.rupture.ticking&variable.single_target
    if Talent.Subterfuge.Active and Trait.ShroudedSuffocation.Active and SingleTarget and not Debuff.Rupture:Exist(Target) then
        if Spell.Rupture:Cast(Target) then
            return true
        end
    end
    -- # Subterfuge w/ Shrouded Suffocation: Reapply for bonus CP and/or extended snapshot duration.
    -- actions.stealthed+=/pool_resource,for_next=1
    -- actions.stealthed+=/garrote,target_if=min:remains,if=talent.subterfuge.enabled&azerite.shrouded_suffocation.enabled&target.time_to_die>remains&(remains<18|!ss_buffed)
    if Talent.Subterfuge.Active and Trait.ShroudedSuffocation.Active then
        for _, Unit in pairs(Player5Y) do
            if Unit.TTD > Debuff.Garrote:Remain(Unit) and (Debuff.Garrote:Remain(Unit) < 18 or Debuff.Garrote:PMultiplier(Unit) == 1) then
                if Spell.Garrote:CastPool(Unit) then
                    return true
                end
            end
        end
    end
    -- # Subterfuge + Exsg: Even override a snapshot Garrote right after Rupture before Exsanguination
    -- actions.stealthed+=/pool_resource,for_next=1
    -- actions.stealthed+=/garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&prev_gcd.1.rupture&dot.rupture.remains>5+4*cp_max_spend
    if Talent.Subterfuge.Active and Talent.Exsanguinate.Active and Spell.Exsanguinate:CD() < 1 and Spell.Rupture:LastCast() and Debuff.Rupture:Remain() > (5 + 4 * Player.ComboMax) then
        if Spell.Garrote:CastPool(Target) then
            return true
        end
    end
end

function Rogue.Assassination()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat then
            OOC()
        end
        if (Target and Target.ValidEnemy) or Player.Combat then
            Player:AutoTarget(5)
            if Rogue.Stealth() then
                if Stealthed() then
                    return true
                end
            end
            if Dots() then
                return true
            end
            if Direct() then
                return true
            end
        end
    end
end