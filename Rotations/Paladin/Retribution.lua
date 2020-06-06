local DMW = DMW
local Paladin = DMW.Rotations.PALADIN
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, HUD, Player5Y, Player5YC, Player10Y, Player10YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {}

        UI.AddTab("Defensive")
        UI.AddToggle("Lay on Hands", "Use Lay on Hands", true)
        UI.AddRange("Lay on Hands HP", "HP to use Lay on Hands", 0, 100, 1, 20)
        UI.AddToggle("Healthstone", "Use Healthstone", true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
        UI.AddToggle("Cleanse Toxins", "Use Cleanse Toxins", true)
        UI.AddTab("DPS")
        UI.AddToggle("Avenging Wrath", "Use Avenging Wrath during CDs", true, true)
        UI.AddTab("Trinkets")
        UI.AddHeader("Trinket 1")
        UI.AddToggle("Trinket 1 CD", "Use Trinket 1 on CD", false, true)
        UI.AddToggle("Trinket 1 DPS", "Use Trinket 1 during DPS CDs", true, true)
        UI.AddRange("Trinket 1 HP", "HP to use Trinket 1 (0 to Disable)", 0, 100, 1, 0, true)
        UI.AddRange("Trinket 1 Enemies", "Enemies to use Trinket 1 (0 to Disable)", 0, 20, 1, 0, true)
        UI.AddHeader("Trinket 2")
        UI.AddToggle("Trinket 2 CD", "Use Trinket 2 on CD", false, true)
        UI.AddToggle("Trinket 2 DPS", "Use Trinket 2 during DPS CDs", true, true)
        UI.AddRange("Trinket 2 HP", "HP to use Trinket 2 (0 to Disable)", 0, 100, 1, 0, true)
        UI.AddRange("Trinket 2 Enemies", "Enemies to use Trinket 2 (0 to Disable)", 0, 20, 1, 0, true)
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
end

local function CastTrinkets()
    --Trinkets
    if Item.Trinket1 and (Setting("Trinket 1 CD") or (Setting("Trinket 1 DPS") and Player:CDs()) or (Setting("Trinket 1 HP") > 0 and Player.HP <= Setting("Trinket 1 HP")) or (Setting("Trinket 1 Enemies") > 0 and Player5YC >= Setting("Trinket 1 Enemies"))) and Item.Trinket1:Use() then
        return true
    end
    if Item.Trinket2 and (Setting("Trinket 2 CD") or (Setting("Trinket 2 DPS") and Player:CDs()) or (Setting("Trinket 2 HP") > 0 and Player.HP <= Setting("Trinket 2 HP")) or (Setting("Trinket 2 Enemies") > 0 and Player5YC >= Setting("Trinket 2 Enemies"))) and Item.Trinket2:Use() then
        return true
    end
end

local function Defensive()
    --HS
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") and Item.Healthstone:Use(Player) then
        return true
    end
    --Avenging Wrath
    if Setting("Avenging Wrath") and Player.HP <= Setting("Avenging Wrath HP") and Spell.AvengingWrath:Cast(Player) then
        return true
    end
    --Lay On Hands
    if Setting("Lay on Hands") and Player.HP <= Setting("Lay on Hands HP") and Spell.LayOnHands:Cast(Player) then
        return true
    end
    --Cleanse toxins
    if Setting("Cleanse Toxins") and Spell.CleanseToxins:IsReady() then
        local Player40Y = Player:GetFriends(40)
        for _, Unit in pairs(Player40Y) do
            if Unit:Dispel(Spell.CleanseToxins) and Spell.CleanseToxins:Cast(Unit) then
                return true
            end
        end
    end
end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Player5YC > 0 and Spell.Rebuke:IsReady() then
            for _, Unit in pairs(Player5Y) do
                if Unit:Interrupt() and Spell.Rebuke:Cast(Unit) then
                    return true
                end
            end
        end
        if Player10YC > 0 and Spell.HammerOfJustice:IsReady() then
            for _, Unit in pairs(Player10Y) do
                if Unit:HardCC() and Spell.HammerOfJustice:Cast(Unit) then
                    return true
                end
            end
        end
    end
    return false
end
local WingsPool, DSCastable = false, false
local function Finishers()
    -- actions.finishers=variable,name=wings_pool,value=!equipped.169314&(!talent.crusade.enabled&cooldown.avenging_wrath.remains>gcd*3|cooldown.crusade.remains>gcd*3)|equipped.169314&(!talent.crusade.enabled&cooldown.avenging_wrath.remains>gcd*6|cooldown.crusade.remains>gcd*6)
    WingsPool = Player:CDs() and ((not Player:HasItemEquipped(169314) and ((not Talent.Crusade.Active and Spell.AvengingWrath:CD() < (GCD * 3)) or Spell.Crusade:CD() < (GCD * 3))) or (Player:HasItemEquipped(169314) and ((not Talent.Crusade.Active and Spell.AvengingWrath:CD() < (GCD * 6)) or Spell.Crusade:CD() < (GCD * 6))))
    -- actions.finishers+=/variable,name=ds_castable,value=spell_targets.divine_storm>=2&!talent.righteous_verdict.enabled|spell_targets.divine_storm>=3&talent.righteous_verdict.enabled|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down&buff.avenging_wrath_autocrit.down
    -- actions.finishers+=/inquisition,if=buff.avenging_wrath.down&(buff.inquisition.down|buff.inquisition.remains<8&holy_power>=3|talent.execution_sentence.enabled&cooldown.execution_sentence.remains<10&buff.inquisition.remains<15|cooldown.avenging_wrath.remains<15&buff.inquisition.remains<20&holy_power>=3)
    -- actions.finishers+=/execution_sentence,if=spell_targets.divine_storm<=2&(!talent.crusade.enabled&cooldown.avenging_wrath.remains>10|talent.crusade.enabled&buff.crusade.down&cooldown.crusade.remains>10|buff.crusade.stack>=7)
    -- actions.finishers+=/divine_storm,if=variable.ds_castable&variable.wings_pool&((!talent.execution_sentence.enabled|(spell_targets.divine_storm>=2|cooldown.execution_sentence.remains>gcd*2))|(cooldown.avenging_wrath.remains>gcd*3&cooldown.avenging_wrath.remains<10|cooldown.crusade.remains>gcd*3&cooldown.crusade.remains<10|buff.crusade.up&buff.crusade.stack<10))
    -- actions.finishers+=/templars_verdict,if=variable.wings_pool&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*2|cooldown.avenging_wrath.remains>gcd*3&cooldown.avenging_wrath.remains<10|cooldown.crusade.remains>gcd*3&cooldown.crusade.remains<10|buff.crusade.up&buff.crusade.stack<10)
end

local function Cooldowns()
    -- actions.cooldowns=potion,if=(cooldown.guardian_of_azeroth.remains>90|!essence.condensed_lifeforce.major)&(buff.bloodlust.react|buff.avenging_wrath.up&buff.avenging_wrath.remains>18|buff.crusade.up&buff.crusade.remains<25)
    -- actions.cooldowns+=/lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
    -- actions.cooldowns+=/fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
    -- actions.cooldowns+=/shield_of_vengeance,if=buff.seething_rage.down&buff.memory_of_lucid_dreams.down
    -- actions.cooldowns+=/use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|(buff.avenging_wrath.remains>=20|buff.crusade.stack=10&buff.crusade.remains>15)&(cooldown.guardian_of_azeroth.remains>90|target.time_to_die<30|!essence.condensed_lifeforce.major)
    -- actions.cooldowns+=/the_unbound_force,if=time<=2|buff.reckless_force.up
    -- actions.cooldowns+=/blood_of_the_enemy,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
    -- actions.cooldowns+=/guardian_of_azeroth,if=!talent.crusade.enabled&(cooldown.avenging_wrath.remains<5&holy_power>=3&(buff.inquisition.up|!talent.inquisition.enabled)|cooldown.avenging_wrath.remains>=45)|(talent.crusade.enabled&cooldown.crusade.remains<gcd&holy_power>=4|holy_power>=3&time<10&talent.wake_of_ashes.enabled|cooldown.crusade.remains>=45)
    -- actions.cooldowns+=/worldvein_resonance,if=cooldown.avenging_wrath.remains<gcd&holy_power>=3|talent.crusade.enabled&cooldown.crusade.remains<gcd&holy_power>=4|cooldown.avenging_wrath.remains>=45|cooldown.crusade.remains>=45
    -- actions.cooldowns+=/focused_azerite_beam,if=(!raid_event.adds.exists|raid_event.adds.in>30|spell_targets.divine_storm>=2)&!(buff.avenging_wrath.up|buff.crusade.up)&(cooldown.blade_of_justice.remains>gcd*3&cooldown.judgment.remains>gcd*3)
    -- actions.cooldowns+=/memory_of_lucid_dreams,if=(buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10)&holy_power<=3
    -- actions.cooldowns+=/purifying_blast,if=(!raid_event.adds.exists|raid_event.adds.in>30|spell_targets.divine_storm>=2)
    -- actions.cooldowns+=/use_item,effect_name=cyclotronic_blast,if=!(buff.avenging_wrath.up|buff.crusade.up)&(cooldown.blade_of_justice.remains>gcd*3&cooldown.judgment.remains>gcd*3)
    -- actions.cooldowns+=/avenging_wrath,if=(!talent.inquisition.enabled|buff.inquisition.up)&holy_power>=3
    -- actions.cooldowns+=/crusade,if=holy_power>=4|holy_power>=3&time<10&talent.wake_of_ashes.enabled
end

local function Generators()
    -- actions.generators=variable,name=HoW,value=(!talent.hammer_of_wrath.enabled|target.health.pct>=20&!(buff.avenging_wrath.up|buff.crusade.up))
    -- actions.generators+=/call_action_list,name=finishers,if=holy_power>=5|buff.memory_of_lucid_dreams.up|buff.seething_rage.up|talent.inquisition.enabled&buff.inquisition.down&holy_power>=3
    -- actions.generators+=/wake_of_ashes,if=(!raid_event.adds.exists|raid_event.adds.in>15|spell_targets.wake_of_ashes>=2)&(holy_power<=0|holy_power=1&cooldown.blade_of_justice.remains>gcd)&(cooldown.avenging_wrath.remains>10|talent.crusade.enabled&cooldown.crusade.remains>10)
    -- actions.generators+=/blade_of_justice,if=holy_power<=2|(holy_power=3&(cooldown.hammer_of_wrath.remains>gcd*2|variable.HoW))
    -- actions.generators+=/judgment,if=holy_power<=2|(holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|variable.HoW))
    -- actions.generators+=/hammer_of_wrath,if=holy_power<=4
    -- actions.generators+=/consecration,if=holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2
    -- actions.generators+=/call_action_list,name=finishers,if=talent.hammer_of_wrath.enabled&target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up
    -- actions.generators+=/crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2&cooldown.consecration.remains>gcd*2)
    -- actions.generators+=/call_action_list,name=finishers
    -- actions.generators+=/concentrated_flame
    -- actions.generators+=/reaping_flames
    -- actions.generators+=/crusader_strike,if=holy_power<=4
    -- actions.generators+=/arcane_torrent,if=holy_power<=4
end

function Paladin.Retribution()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        Player:AutoTarget(5)
        if Target and Target.ValidEnemy then
            Player5Y, Player5YC = Player:GetEnemies(5)
            Player10Y, Player10YC = Player:GetEnemies(10)
            if not IsCurrentSpell(6603) then
                StartAttack(Target.Pointer)
            end
            Interrupt()
            if Defensive() then
                return true
            end
            if Cooldowns() then
                return true
            end
            if Generators() then
                return true
            end
        end
    end
end