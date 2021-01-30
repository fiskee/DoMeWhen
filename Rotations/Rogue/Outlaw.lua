local DMW = DMW
local Rogue = DMW.Rotations.ROGUE
local Player, Buff, Debuff, Spell, Target, Talent, Item, GCD, CDs, HUD, Player5Y, Player5YC, Player10Y, Player10YC, SingleTarget, PriorityRotation, Stealth
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {

        }
        UI.AddTab("General")
        UI.AddDropdown("Auto Stealth", nil, {"Disabled", "Always", "20 Yards"}, 2)
        UI.AddDropdown("Auto Tricks", "Select Tricks of the Trade Option", {"Disabled", "Tank", "Focus"}, 2)
        UI.AddTab("DPS")
        UI.AddToggle("Trinkets", nil, true)
        UI.AddToggle("Vanish", nil, true, true)
        UI.AddTab("Defensive")
        UI.AddToggle("Healthstone", nil, true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
        UI.AddToggle("Crimson Vial", "Use Crimson Vial", true)
        UI.AddRange("Crimson Vial HP", "HP to use Crimson Vial", 0, 100, 1, 30)
        UI.AddToggle("Feint", "Use Feint", false)
        UI.AddRange("Feint HP", "HP to use Feint", 0, 100, 1, 20)
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Talent = Player.Talents
    Item = Player.Items
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
    CDs = Player:CDs() and Target and Target.TTD > 5 and Target.Distance < 5
    Stealth = Rogue.Stealth()
    Player5Y, Player5YC = Player:GetEnemies(5)
    Player10Y, Player10YC = Player:GetEnemies(10)
    SingleTarget = Player10YC == 1
    PriorityRotation = HUD.Priority == 2
end

local function RtBCount()
    local Count = 0
    if Buff.Broadsides:Exist() then
        Count = Count + 1
    end
    if Buff.BuriedTreasure:Exist() then
        Count = Count + 1
    end
    if Buff.TrueBearing:Exist() then
        Count = Count + 1
    end
    if Buff.RuthlessPrecision:Exist() then
        Count = Count + 1
    end
    if Buff.GrandMelee:Exist() then
        Count = Count + 1
    end
    if Buff.SkullAndCrossbones:Exist() then
        Count = Count + 1
    end
    return Count
end

local function RtBRemain()
    local Remain = Buff.Broadsides:Remain()
    if Remain > 0 then
        return Remain
    end
    Remain = Buff.BuriedTreasure:Remain()
    if Remain > 0 then
        return Remain
    end
    Remain = Buff.TrueBearing:Remain()
    if Remain > 0 then
        return Remain
    end
    Remain = Buff.RuthlessPrecision:Remain()
    if Remain > 0 then
        return Remain
    end
    Remain = Buff.GrandMelee:Remain()
    if Remain > 0 then
        return Remain
    end
    Remain = Buff.SkullAndCrossbones:Remain()
    if Remain > 0 then
        return Remain
    end
    return 0
end

local function OOC()
    if not Player.Moving then
        if not Spell.InstantPoison:LastCast() and Buff.InstantPoison:Remain() < 300 then
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

end


local function Stealthed()

end

local function Interrupt()
    if HUD.Interrupts == 1 then
        if Player5YC > 0 and Spell.Kick:IsReady() then
            for _, Unit in ipairs(Player5Y) do
                if Unit:Interrupt() then
                    if Spell.Kick:Cast(Unit) then
                        return true
                    end
                end
            end
        end
        if Player5YC > 0 and Player.ComboPoints <= 3 and Spell.KidneyShot:IsReady() then
            for _, Unit in ipairs(Player5Y) do
                if Unit:HardCC() then
                    if Spell.KidneyShot:Cast(Unit) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function Tricks()
    if Setting("Auto Tricks") == 2 then
        if DMW.Friends.Tanks[1] and Target.Distance < 5 and UnitThreatSituation("player") and UnitThreatSituation("player") >= 2 then
            Spell.TricksOfTheTrade:Cast(DMW.Friends.Tanks[1])
        end
    elseif Setting("Auto Tricks") == 3 then
        if Player.Focus and Target.Distance < 5 and UnitThreatSituation("player") and UnitThreatSituation("player") >= 2 then
            Spell.TricksOfTheTrade:Cast(Player.Focus)
        end
    end
end

local function Defensives()
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") then
        if Item.Healthstone:Use(Player) then
            return true
        end
    end
    if Setting("Crimsom Vial") and Player.HP <= Setting("Crimsom Vial HP") then
        if Spell.CrimsonVial:Cast(Player) then
            return true
        end
    end
    if Setting("Feint") and Player.HP <= Setting("Feint HP") then
        if Spell.Feint:Cast(Player) then
            return true
        end
    end
end

function Rogue.Outlaw()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat and not Spell.Vanish:LastCast() then
            OOC()
        end
        if not Stealth and Player.Combat then
            Player:AutoTarget(5)
        end
        if (Target and Target.ValidEnemy) then
            if not Stealth and Interrupt() then
                return true
            end
            Tricks()
            if Spell.GCD:CD() == 0 then
                if Target.Distance < 5 and not IsCurrentSpell(6603) and not Stealth then
                    StartAttack(Target.Pointer)
                end
                if Defensives() then
                    return true
                end
                if not Stealth and Cooldowns() then
                    return true
                end
                if Stealth and Stealthed() then
                    return true
                end
            end
        end
    end
end
