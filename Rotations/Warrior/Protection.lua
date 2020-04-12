local DMW = DMW
local Warrior = DMW.Rotations.WARRIOR
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, HUD, Player5Y, Player5YC, Player10Y, Player10YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {
        }
        UI.AddTab("General")
        UI.AddToggle("Dump Rage", "Use Ignore Pain to dump rage", true)
        UI.AddTab("Defensive")
        UI.AddToggle("Healthstone", "Use Healthstone", true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
        UI.AddTab("DPS")
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

local function Cooldowns()
    -- actions+=/use_items,if=cooldown.avatar.remains<=gcd|buff.avatar.up
    -- actions+=/blood_fury
    -- actions+=/berserking
    -- actions+=/arcane_torrent
    -- actions+=/lights_judgment
    -- actions+=/fireblood
    -- actions+=/ancestral_call
    -- actions+=/bag_of_tricks
    -- actions+=/potion,if=buff.avatar.up|target.time_to_die<25
    -- actions+=/worldvein_resonance,if=cooldown.avatar.remains<=2
    -- actions+=/ripple_in_space
    -- actions+=/memory_of_lucid_dreams
    -- actions+=/concentrated_flame,if=buff.avatar.down&!dot.concentrated_flame_burn.remains>0|essence.the_crucible_of_flame.rank<3
    -- actions+=/avatar
end

local function AoE()
    -- actions.aoe=thunder_clap
    if Spell.ThunderClap:Cast(Player) then
        return true
    end
    -- actions.aoe+=/memory_of_lucid_dreams,if=buff.avatar.down
    -- actions.aoe+=/demoralizing_shout,if=talent.booming_voice.enabled
    -- actions.aoe+=/anima_of_death,if=buff.last_stand.up
    -- actions.aoe+=/dragon_roar
    if Spell.DragonRoar:Cast(Player) then
        return true
    end
    -- actions.aoe+=/revenge
    if Spell.Revenge:Cast(Target) then
        return true
    end
    -- actions.aoe+=/use_item,name=grongs_primal_rage,if=buff.avatar.down|cooldown.thunder_clap.remains>=4
    -- actions.aoe+=/ravager
    if Spell.Ravager:Cast(Target) then
        return true
    end
end

local function SingleTarget()
    -- actions.st=thunder_clap,if=spell_targets.thunder_clap=2&talent.unstoppable_force.enabled&buff.avatar.up
    if Player10YC == 2 and Talent.UnstoppableForce.Active and Buff.Avatar:Exist() then
        if Spell.ThunderClap:Cast(Player) then
            return true
        end
    end
    -- actions.st+=/shield_block,if=cooldown.shield_slam.ready&buff.shield_block.down
    if Spell.ShieldSlam:IsReady() and not Buff.ShieldBlock:Exist() then
        if Spell.ShieldBlock:Cast(Player) then
            return true
        end
    end
    -- actions.st+=/shield_slam,if=buff.shield_block.up
    if Buff.ShieldBlock:Exist() then
        if Spell.ShieldSlam:Cast(Target) then
            return true
        end
    end
    -- actions.st+=/thunder_clap,if=(talent.unstoppable_force.enabled&buff.avatar.up)
    if Player5YC > 0 and Talent.UnstoppableForce.Active and Buff.Avatar:Exist() then
        if Spell.ThunderClap:Cast(Player) then
            return true
        end
    end
    -- actions.st+=/demoralizing_shout,if=talent.booming_voice.enabled
    if Player5YC > 0 and Talent.BoomingVoice.Active then
        if Spell.DemoralizingShout:Cast(Player) then
            return true
        end
    end
    -- actions.st+=/anima_of_death,if=buff.last_stand.up
    -- actions.st+=/shield_slam
    if Spell.ShieldSlam:Cast(Target) then
        return true
    end
    -- actions.st+=/use_item,name=ashvanes_razor_coral,target_if=debuff.razor_coral_debuff.stack=0
    -- actions.st+=/use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.stack>7&(cooldown.avatar.remains<5|buff.avatar.up)
    -- actions.st+=/dragon_roar
    if Player5YC > 0 and Spell.DragonRoar:Cast(Player) then
        return true
    end
    -- actions.st+=/thunder_clap
    if Player5YC > 0 and Spell.ThunderClap:Cast(Player) then
        return true
    end
    -- actions.st+=/revenge
    if Spell.Revenge:Cast(Target) then
        return true
    end
    -- actions.st+=/use_item,name=grongs_primal_rage,if=buff.avatar.down|cooldown.shield_slam.remains>=4
    -- actions.st+=/ravager
    if Spell.Ravager:Cast(Target) then
        return true
    end
    -- actions.st+=/devastate
    if Spell.Devastate:Cast(Target) then
        return true
    end
end

local function DPSRotation()
    -- # use Ignore Pain to avoid rage capping
    -- actions+=/ignore_pain,if=rage.deficit<25+20*talent.booming_voice.enabled*cooldown.demoralizing_shout.ready
    if Setting("Dump Rage") and ((Spell.DemoralizingShout:IsReady() and Talent.BoomingVoice.Active and Player.PowerDeficit < 45) or Player.PowerDeficit < 25) then
        if Spell.IgnorePain:Cast(Player) then
            return true
        end
    end
    -- CDs
    if Cooldowns() then
        return true
    end
    -- actions+=/run_action_list,name=aoe,if=spell_targets.thunder_clap>=3
    if Player10YC >= 3 and AoE() then
        return true
    end
    -- actions+=/call_action_list,name=st
    if SingleTarget() then
        return true
    end
end

local function Defensive()
    if Spell.VictoryRush:IsReady() and Player.HP < 90 then
        Spell.VictoryRush:Cast(Target)
    end
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") then
        if Item.Healthstone:Use(Player) then
            return true
        end
    end
    if not Buff.IgnorePain:Exist() then
        if Spell.IgnorePain:Cast(Player) then
            return true
        end
    end
end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Player5YC > 0 and Spell.Pummel:IsReady() then
            for _, Unit in pairs(Player5Y) do
                if Unit:Interrupt() then
                    if Spell.Pummel:Cast(Unit) then
                        return true
                    end
                end
            end
        end
        if Spell.StormBolt:IsReady() then
            for _, Unit in ipairs(Player:GetEnemies(20)) do
                if Unit:HardCC() then
                    if Spell.StormBolt:Cast(Unit) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Warrior.Protection()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        Player:AutoTarget(5)
        if Target and Target.ValidEnemy then
            if not Buff.BattleShout:Exist(Player) and Spell.BattleShout:Cast(Player) then
                return true
            end
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
            if DPSRotation() then
                return true
            end
        end
    end
end
