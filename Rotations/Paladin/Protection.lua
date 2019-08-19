local DMW = DMW
local Paladin = DMW.Rotations.PALADIN
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, HUD, Player5Y, Player5YC, Player10Y, Player10YC
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

        UI.AddHeader("Defensive")
        UI.AddToggle("Light of the Protector", "Use Light of the Protector", true)
        UI.AddRange("Light of the Protector HP", "HP to use Light of the Protector", 0, 100, 1, 70)
        UI.AddToggle("Shield of the Righteous", "Use Shield of the Righteous", true)
        UI.AddRange("Shield of the Righteous HP", "HP to use Shield of the Righteous", 0, 100, 1, 80)
        UI.AddToggle("Ardent Defender", "Use Ardent Defender", true)
        UI.AddRange("Ardent Defender HP", "HP to use Ardent Defender", 0, 100, 1, 50)
        UI.AddToggle("Guardian of Ancient Kings", "Use Guardian of Ancient Kings", true)
        UI.AddRange("Guardian of Ancient Kings HP", "HP to use Guardian of Ancient Kings", 0, 100, 1, 30)
        UI.AddToggle("Lay on Hands", "Use Lay on Hands", true)
        UI.AddRange("Lay on Hands HP", "HP to use Lay on Hands", 0, 100, 1, 20)
        UI.AddToggle("Avenging Wrath", "Use Avenging Wrath", true)
        UI.AddRange("Avenging Wrath HP", "HP to use Avenging Wrath", 0, 100, 1, 50)
        UI.AddToggle("Healthstone", "Use Healthstone", true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
        UI.AddToggle("Cleanse Toxins", "Use Cleanse Toxins", true)
        UI.AddHeader("DPS")
        UI.AddToggle("Consecration", "Use Consecration", true)
        UI.AddToggle("Seraphim", "Use Seraphim", true)
        UI.AddToggle("Avenging Wrath DPS", "Use Avenging Wrath during CDs", true)
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

local function DPS()
    -- actions+=/worldvein_resonance,if=buff.lifeblood.stack<3
    -- # Dumping SotR charges
    -- actions+=/shield_of_the_righteous,if=(buff.avengers_valor.up&cooldown.shield_of_the_righteous.charges_fractional>=2.5)&(cooldown.seraphim.remains>gcd|!talent.seraphim.enabled)
    -- actions+=/shield_of_the_righteous,if=(buff.avenging_wrath.up&!talent.seraphim.enabled)|buff.seraphim.up&buff.avengers_valor.up
    -- actions+=/shield_of_the_righteous,if=(buff.avenging_wrath.up&buff.avenging_wrath.remains<4&!talent.seraphim.enabled)|(buff.seraphim.remains<4&buff.seraphim.up)
    if (Buff.AvengersValor:Exist(Player) and Spell.ShieldOfTheRighteous:ChargesFrac() >= 2.5) or (Buff.AvengingWrath:Exist(Player) and not Talent.Seraphim.Active) or (Buff.AvengersValor:Exist(Player) and Buff.Seraphim:Exist(Player)) then
        if Spell.ShieldOfTheRighteous:Cast(Target) then
            return true
        end
    end
    -- actions+=/lights_judgment,if=buff.seraphim.up&buff.seraphim.remains<3
    -- actions+=/consecration,if=!consecration.up
    if not Player.Moving and Player5YC > 0 and (Paladin.ConsDistance() > 5 or Paladin.ConsRemain() < 2) then
        if Spell.Consecration:Cast(Player) then
            return true
        end
    end
    -- actions+=/judgment,if=(cooldown.judgment.remains<gcd&cooldown.judgment.charges_fractional>1&cooldown_react)|!talent.crusaders_judgment.enabled
    if not Talent.CrusadersJudgment.Active or Spell.Judgment:FullRechargeTime() < GCD then
        if Spell.Judgment:Cast(Target) then
            return true
        end
    end
    -- actions+=/avengers_shield,if=cooldown_react
    if Spell.AvengersShield:Cast(Target) then
        return true
    end
    -- actions+=/judgment,if=cooldown_react|!talent.crusaders_judgment.enabled
    if Spell.Judgment:Cast(Target) then
        return true
    end
    -- actions+=/concentrated_flame,if=buff.seraphim.up&!dot.concentrated_flame_burn.remains>0|essence.the_crucible_of_flame.rank<3
    if Spell.ConcentratedFlame:Cast(Target) then
        return true
    end
    -- actions+=/lights_judgment,if=!talent.seraphim.enabled|buff.seraphim.up
    -- actions+=/anima_of_death
    -- actions+=/blessed_hammer,strikes=3
    if Player5YC > 2 then
        if Spell.BlessedHammer:Cast(Player) then
            return true
        end
    end
    -- actions+=/hammer_of_the_righteous
    if Spell.HammerOfTheRighteous:Cast(Target) then
        return true
    end
    -- actions+=/consecration
    -- actions+=/heart_essence,if=!essence.the_crucible_of_flame.major|!essence.worldvein_resonance.major|!essence.anima_of_life_and_death.major|!essence.memory_of_lucid_dreams.major
end

local function Defensive()
    --HS
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") then
        if Item.Healthstone:Use(Player) then
            return true
        end
    end
    --Avenging Wrath
    if Setting("Avenging Wrath") and Player.HP <= Setting("Avenging Wrath HP") then
        if Spell.AvengingWrath:Cast(Player) then
            return true
        end
    end
    --Light of the Protector
    if Setting("Light of the Protector") and Player.HP <= Setting("Light of the Protector HP") then
        if Spell.LightOfTheProtector:Cast(Player) then
            return true
        end
        if Spell.HandOfTheProtector:Cast(Player) then
            return true
        end
    end
    --Lay On Hands
    if Setting("Lay on Hands") and Player.HP <= Setting("Lay on Hands HP") then
        if Spell.LayOnHands:Cast(Player) then
            return true
        end
    end
    --Guardian of Ancient Kings
    if Setting("Guardian of Ancient Kings") and Player.HP <= Setting("Guardian of Ancient Kings HP") then
        if Spell.GuardianOfAncientKings:Cast(Player) then
            return true
        end
    end
    --Ardent Defender
    if Setting("Ardent Defender") and Player.HP <= Setting("Ardent Defender HP") then
        if Spell.ArdentDefender:Cast(Player) then
            return true
        end
    end
    --Shield of the Righteous
    if Setting("Shield of the Righteous") and Player.HP <= Setting("Shield of the Righteous HP") and not Buff.ShieldOfTheRighteous:Exist(Player) then
        if Spell.ShieldOfTheRighteous:Cast(Player) then
            return true
        end
    end
    --Cleanse toxins
    if Setting("Cleanse Toxins") and Spell.CleanseToxins:IsReady() then
        local Player40Y = Player:GetFriends(40)
        for _, Unit in pairs(Player40Y) do
            if Unit:Dispel(Spell.CleanseToxins) then
                Spell.CleanseToxins:Cast(Unit)
            end
        end
        
    end
end

local function Cooldowns()
    --Anima
    if Spell.AnimaOfDeath:IsReady() and Player.HP < 90 then
        local _, Player8YC = Player:GetEnemies(8)
        if (Player8YC >= 4 and Player.HP < 80) or (Player:CDs() and Player.HP < 90) then
            if Spell.AnimaOfDeath:Cast(Player) then
                return true
            end
        end
    end
    --Trinkets
    if Item.Trinket1 and Player:CDs() then
        if Item.Trinket1:Use() then
            return true
        end
    end
    if Item.Trinket2 and Player:CDs() then
        if Item.Trinket2:Use() then
            return true
        end
    end
    --actions.cooldowns+=/seraphim,if=cooldown.shield_of_the_righteous.charges_fractional>=2
    if Setting("Seraphim") and Spell.ShieldOfTheRighteous:ChargesFrac() >= 2 then
        if Spell.Seraphim:Cast(Player) then
            return true
        end
    end
    --actions.cooldowns+=/avenging_wrath,if=buff.seraphim.up|cooldown.seraphim.remains<2|!talent.seraphim.enabled
    if Target.Distance < 5 and Player:CDs() and Setting("Avenging Wrath") and (not Talent.Seraphim.Active or Spell.Seraphim:CD() < 2 or Buff.Seraphim:Exist()) then
        if Spell.AvengingWrath:Cast(Player) then
            return true
        end
    end
end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Player5YC > 0 and Spell.Rebuke:IsReady() then
            for _, Unit in pairs(Player5Y) do
                if Unit:Interrupt() then
                    if Spell.Rebuke:Cast(Unit) then
                        return true
                    end
                end
            end
        end
        if Player10YC > 0 and Spell.HammerOfJustice:IsReady() then
            for _, Unit in pairs(Player10Y) do
                if Unit:HardCC() then
                    if Spell.HammerOfJustice:Cast(Unit) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Paladin.Protection()
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
            if Cooldowns() then 
                return true
            end
            if Defensive() then 
                return true
            end
            if DPS() then 
                return true
            end
        end
    end
end