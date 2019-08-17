local DMW = DMW
local Paladin = DMW.Rotations.PALADIN
local Player, Buff, Debuff, Spell, Target, Trait, Talent, GCD, HUD, Player5Y, Player5YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation

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
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Talent = Player.Talents
    Trait = Player.Traits
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end

local function DPS()
    -- actions+=/worldvein_resonance,if=buff.lifeblood.stack<3
    -- # Dumping SotR charges
    -- actions+=/shield_of_the_righteous,if=(buff.avengers_valor.up&cooldown.shield_of_the_righteous.charges_fractional>=2.5)&(cooldown.seraphim.remains>gcd|!talent.seraphim.enabled)
    if Buff.AvengersValor:Exist() and Spell.ShieldOfTheRighteous:ChargesFrac() >= 2.5 then
        if Spell.ShieldOfTheRighteous:Cast(Target) then
            return true
        end
    end
    -- actions+=/shield_of_the_righteous,if=(buff.avenging_wrath.up&!talent.seraphim.enabled)|buff.seraphim.up&buff.avengers_valor.up
    -- actions+=/shield_of_the_righteous,if=(buff.avenging_wrath.up&buff.avenging_wrath.remains<4&!talent.seraphim.enabled)|(buff.seraphim.remains<4&buff.seraphim.up)
    -- actions+=/lights_judgment,if=buff.seraphim.up&buff.seraphim.remains<3
    -- actions+=/consecration,if=!consecration.up
    if not Player.Moving and Player5YC > 0 and Paladin.ConsDistance() > 5 then
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
    
end

local function Cooldowns()
    
end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Player5YC > 0 then
            for _, Unit in pairs(Player5Y) do
                if Unit:Interrupt() then
                    if Spell.Rebuke:Cast(Unit) then
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