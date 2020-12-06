local DMW = DMW
local Druid = DMW.Rotations.DRUID
local Player, Buff, Debuff, Spell, Target, Talent, Trait, GCD, HUD, Player40Y, Player40YC, Player5Y, Player5YC, Player8Y, Player8YC, Player15Y, Player15YC, Item
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {}
        UI.AddTab("Defensive")
        UI.AddRange("Frenzied Regeneration 2 Stacks HP", "HP to use Frenzied Regeneration with 2 stacks", 0, 100, 1, 80)
        UI.AddRange("Frenzied Regeneration HP", "HP to use Frenzied Regeneration", 0, 100, 1, 60)
        UI.AddRange("Ironfur HP", "HP to use Ironfur", 0, 100, 1, 75, true)
        UI.AddRange("Bristling Fur HP", "HP to use Bristling Fur", 0, 100, 1, 70, true)
        UI.AddToggle("Healthstone", "Use Healthstone", true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
        UI.AddRange("Defensive HP", "HP to start using defensive CDs", 0, 100, 1, 60, true)
        UI.AddToggle("Berserk Defensive", "Use Berserk Defensively", false)
        UI.AddToggle("Incarnation Defensive", "Use Incarnation Defensively", false)
        UI.AddToggle("Survival Instincts Defensive", "Use Survival Instincts Defensively", true)
        UI.AddToggle("Barkskin Defensive", "Use Barkskin Defensively", true)
        UI.AddTab("DPS")
        UI.AddToggle("Ravenous Frenzy", "Use Ravenous Frenzy with Berserk/Incarnation up", true, true)
        UI.AddToggle("Berserk", "Use Berserk during DPS CDs", true)
        UI.AddRange("Berserk AoE", "Enemies to use Berserk (0 to disable option)", 0, 10, 1, 3)
        UI.AddToggle("Incarnation", "Use Incarnation during DPS CDs", true)
        UI.AddRange("Incarnation AoE", "Enemies to use Incarnation (0 to disable option)", 0, 10, 1, 3)
        UI.AddTab("Trinkets")
        UI.AddHeader("Trinket 1")
        UI.AddToggle("Trinket 1 CD", "Use Trinket 1 on CD", false, true)
        UI.AddToggle("Trinket 1 DPS", "Use Trinket 1 during DPS CDs", true, true)
        UI.AddRange("Trinket 1 HP", "HP to use Trinket 1 (0 to Disable)", 0, 100, 1, 0, true)
        UI.AddRange("Trinket 1 Enemies", "Enemies to use Trinket 1 (0 to Disable)", 0, 20, 1, 0, true)
        UI.AddDropdown("Trinket 1 Target", "Select Trinket 1 Target", {"Player", "Target", "Ground"}, 1, true)
        UI.AddHeader("Trinket 2")
        UI.AddToggle("Trinket 2 CD", "Use Trinket 2 on CD", false, true)
        UI.AddToggle("Trinket 2 DPS", "Use Trinket 2 during DPS CDs", true, true)
        UI.AddRange("Trinket 2 HP", "HP to use Trinket 2 (0 to Disable)", 0, 100, 1, 0, true)
        UI.AddRange("Trinket 2 Enemies", "Enemies to use Trinket 2 (0 to Disable)", 0, 20, 1, 0, true)
        UI.AddDropdown("Trinket 2 Target", "Select Trinket 2 Target", {"Player", "Target", "Ground"}, 1, true)
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Trait = Player.Traits
    Item = Player.Items
    Talent = Player.Talents
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end

local function DPS()
    if Target.TTD > 8 and Setting("Berserk AoE") > 0 and Player8YC >= Setting("Berserk AoE") and not Talent.IncarnationGuardianOfUrsoc.Active and Spell.Berserk:Cast(Player) then
        return true
    end
    if Target.TTD > 8 and Setting("Incarnation AoE") > 0 and Player8YC >= Setting("Incarnation AoE") and Spell.IncarnationGuardianOfUrsoc:Cast(Player) then
        return true
    end
    if Talent.Pulverize.Active and Debuff.Thrash:Stacks(Target) >= 3 and Spell.Pulverize:Cast(Target) then
        return true
    end
    if Talent.GalacticGuardian.Active and Buff.GalacticGuardian:Exist() then
        for _,Unit in ipairs(Player40Y) do
            if Debuff.Moonfire:Refresh(Unit) and Spell.Moonfire:Cast(Unit) then
                return true
            end
        end
    end
    if Player.PowerDeficit < 12 and Player.HP >= 75 and Spell.Maul:Cast(Target) then
        return true
    end
    if Talent.ToothAndClaw.Active and Buff.ToothAndClaw:Exist() and not Debuff.ToothAndClaw:Exist(Target) and Spell.Maul:Cast(Target) then
        return true
    end
    if Debuff.Thrash:Stacks(Target) >= 3 and not Debuff.Thrash:Refresh(Target) and Player8YC < 2 and Spell.Mangle:Cast(Target) then
        return true
    end
    if Spell.Thrash:Cast(Player) then
        return true
    end
    if Spell.Mangle:Cast(Target) then
        return true
    end
    if Debuff.Moonfire:Refresh(Target) and Spell.Moonfire:Cast(Target) then
        return true
    end
    if Spell.Swipe:Cast(Player) then
        return true
    end
end

local function CastTrinkets()
    if Item.Trinket1 and (Setting("Trinket 1 CD") or (Setting("Trinket 1 DPS") and Player:CDs()) or (Setting("Trinket 1 HP") > 0 and Player.HP <= Setting("Trinket 1 HP")) or (Setting("Trinket 1 Enemies") > 0 and Player5YC >= Setting("Trinket 1 Enemies"))) then
        if Setting("Trinket 1 Target") == 1 and Item.Trinket1:Use() then
            return true
        elseif Setting("Trinket 1 Target") == 2 and Item.Trinket1:Use(Target) then
            return true
        end
    end
    if Item.Trinket2 and (Setting("Trinket 2 CD") or (Setting("Trinket 2 DPS") and Player:CDs()) or (Setting("Trinket 2 HP") > 0 and Player.HP <= Setting("Trinket 2 HP")) or (Setting("Trinket 2 Enemies") > 0 and Player5YC >= Setting("Trinket 2 Enemies"))) then
        if Setting("Trinket 2 Target") == 1 and Item.Trinket2:Use() then
            return true
        elseif Setting("Trinket 2 Target") == 2 and Item.Trinket2:Use(Target) then
            return true
        end
    end
end

local function Defensive()
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") and Item.Healthstone:Use(Player) then
        return true
    end
    if Rotation.Defensive() or Player.HP <= Setting("Defensive HP") then
        if Setting("Berserk Defensive") and not Talent.IncarnationGuardianOfUrsoc.Active and Spell.Berserk:Cast(Player) then
            return true
        end
        if Setting("Incarnation Defensive") and Spell.IncarnationGuardianOfUrsoc:Cast(Player) then
            return true
        end
        if Setting("Survival Instincts Defensive") and Player.HP < 35 and Spell.SurvivalInstincts:Cast(Player) then
            return true
        end
        if Setting("Barkskin Defensive") and not Buff.SurvivalInstincts:Exist() and Buff.Ironfur:Stacks() < 2 and Spell.Barkskin:Cast(Player) then
            return true
        end
        if (Player.HP < 50 or (Buff.Ironfur:Remain() < 1.5 and not Buff.SurvivalInstincts:Exist() and not Buff.Barkskin:Exist())) and Spell.Ironfur:Cast(Player) then
            return true
        end
        if Talent.BristlingFur.Active and not Buff.SurvivalInstincts:Exist() and not Buff.Barkskin:Exist() and Spell.BristlingFur:Cast(Player) then
            return true
        end
    end
    if Player.HP < Setting("Ironfur HP") and Buff.Ironfur:Remain() < 1.5 and not Buff.SurvivalInstincts:Exist() and not Buff.Barkskin:Exist() and Spell.Ironfur:Cast(Player) then
        return true
    end
    if Talent.BristlingFur.Active and Player.HP < Setting("Bristling Fur HP") and not Buff.SurvivalInstincts:Exist() and not Buff.Barkskin:Exist() and Spell.BristlingFur:Cast(Player) then
        return true
    end
    if Player.HP < Setting("Frenzied Regeneration 2 Stacks HP") and Spell.FrenziedRegeneration:Charges() == 2 and Spell.FrenziedRegeneration:Cast(Player) then
        return true
    end
    if Player.HP < Setting("Frenzied Regeneration HP") and Spell.FrenziedRegeneration:Cast(Player) then
        return true
    end
end

local function Cooldowns()
    if CastTrinkets() then
        return true
    end
    if Setting("Ravenous Frenzy") and (Buff.Berserk:Exist() or Buff.IncarnationGuardianOfUrsoc:Exist()) and Spell.RavenousFrenzy:Cast(Player) then
        return true
    end
    if Target.TTD > 8 and Setting("Berserk") and not Talent.IncarnationGuardianOfUrsoc.Active and Player:CDs() and Spell.Berserk:Cast(Player) then
        return true
    end
    if Target.TTD > 8 and Setting("Incarnation") and Talent.IncarnationGuardianOfUrsoc.Active and Player:CDs() and Spell.IncarnationGuardianOfUrsoc:Cast(Player) then
        return true
    end
end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Target.Distance < 13 and Target:Interrupt() and Spell.SkullBash:Cast(Target) then
            return true
        end
        if Player5YC > 0 and Spell.SkullBash:IsReady() then
            for _, Unit in pairs(Player5Y) do
                if Unit:Interrupt() and Spell.SkullBash:Cast(Unit) then
                    return true
                end
            end
        end
    end
    return false
end

function Druid.Guardian()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        Player:AutoTarget(5)
        if Target and Target.ValidEnemy then
            Player5Y, Player5YC = Player:GetEnemies(5)
            Player8Y, Player8YC = Player:GetEnemies(8)
            Player15Y, Player15YC = Player:GetEnemies(15)
            Player40Y, Player40YC = Player:GetEnemies(15)
            if not Buff.BearForm:Exist() then
                if Spell.BearForm:Cast(Player) then
                    return true
                end
            else
                if not IsCurrentSpell(6603) then
                    StartAttack(Target.Pointer)
                end
                if Interrupt() then
                    return true
                end
                if Cooldowns() then
                    return true
                end
                if Defensive() then
                    return true
                end
                if Target.Distance < 8 then
                    if DPS() then
                        return true
                    end
                else
                    for _,Unit in ipairs(Player40Y) do
                        if Debuff.Moonfire:Refresh(Unit) and Spell.Moonfire:Cast(Unit) then
                            return true
                        end
                    end
                end
            end
        end
    end
end
