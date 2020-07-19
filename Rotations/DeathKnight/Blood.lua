local DMW = DMW
local DeathKnight = DMW.Rotations.DEATHKNIGHT
local Player, Buff, Debuff, Spell, Target, Pet, Trait, GCD, Pet5Y, Pet5YC, HUD, Player5Y, Player5YC, Talent, Item, Player8Y, Player8YC, Player15Y, Player15YC, Player20Y, Player20YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {}
        UI.AddTab("Defensive")
        UI.AddRange("Death Strike HP", "HP to use Death Strike", 0, 100, 1, 70, true)
        UI.AddToggle("Blooddrinker", "Use Blooddrinker", true)
        UI.AddRange("Blooddrinker HP", "HP to use Blooddrinker", 0, 100, 1, 50)
        UI.AddToggle("Vampiric Blood", "Use Vampiric Blood", true)
        UI.AddRange("Vampiric Blood HP", "HP to use Vampiric Blood", 0, 100, 1, 60)
        UI.AddToggle("Icebound Fortitude", "Use Icebound Fortitude", true)
        UI.AddRange("Icebound Fortitude HP", "HP to use Icebound Fortitude", 0, 100, 1, 35)
        UI.AddToggle("Rune Tap", "Use Rune Tap", true)
        UI.AddRange("Rune Tap HP", "HP to use Rune Tap", 0, 100, 1, 80)
        UI.AddToggle("Tombstone", "Use Tombstone", true)
        UI.AddRange("Tombstone HP", "HP to use Tombstone", 0, 100, 1, 65)
        UI.AddToggle("Healthstone", "Use Healthstone", true)
        UI.AddRange("Healthstone HP", "HP to use Healthstone", 0, 100, 1, 60)
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
    Item = Player.Items
    Spell = Player.Spells
    Trait = Player.Traits
    Talent = Player.Talents
    Target = Player.Target or false
    Pet = Player.Pet or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end

local function DPS()
    --Bonestorm
    if Player8YC > 2 and Player.Power >= 80 and Spell.Bonestorm:Cast(Player) then
        return true
    end
    --Death Strike
    if (Player.HP < Setting("Death Strike HP") or Player.PowerDeficit < 21) and Spell.DeathStrike:Cast(Target) then
        return true
    end
    --Consumption
    if Player5YC > 0 and Spell.Consumption:Cast(Player) then
        return true
    end
    --Marrowrend
    if ((Buff.BoneShield:Stacks() <= 7 and not Buff.DancingRuneWeapon:Exist()) or (Buff.BoneShield:Stacks() <= 6 and Buff.DancingRuneWeapon:Exist())) and Spell.Marrowrend:Cast(Target) then
        return true
    end
    --Blooddrinker
    if Setting("Blooddrinker") and Player.HP < Setting("Blooddrinker HP") and Spell.Blooddrinker:Cast(Target) then
        return true
    end
    --Blood Boil
    if Player8YC > 0 and (Player8YC == 1 or Debuff.BloodPlague:Count(Player8Y) < Player8YC or Debuff.BloodPlague:Refresh(Target) or Spell.BloodBoil:Charges() == select(2, Spell.BloodBoil:Charges())) and Spell.BloodBoil:Cast(Player) then
        return true
    end
    --Death and Decay
    if Talent.RapidDecomposition.Active then
        if Spell.DeathAndDecay:Cast(Target) then
            return true
        end
    elseif (Buff.CrimsonScourge:Exist() or select(2, Target:GetEnemies(8)) > 2) and Spell.DeathAndDecay:Cast(Target) then
        return true
    end
    --Heart Strike
    if Player.Runes >= 2 and Spell.HeartStrike:Cast(Target) then
        return true
    end
    --Rune Strike
    if Talent.RuneStrike.Active and Spell.RuneStrike:Cast(Target) then
        return true
    end
    --Mark Of Blood
    if Talent.MarkOfBlood.Active and not Debuff.MarkOfBlood:Exist(Target) and Spell.MarkOfBlood:Cast(Target) then
        return true
    end
end

local function CastTrinkets()
    if Item.Trinket1 and (Setting("Trinket 1 CD") or (Setting("Trinket 1 DPS") and Player:CDs()) or (Setting("Trinket 1 HP") > 0 and Player.HP <= Setting("Trinket 1 HP")) or (Setting("Trinket 1 Enemies") > 0 and Player5YC >= Setting("Trinket 1 Enemies"))) and Item.Trinket1:Use() then
        return true
    end
    if Item.Trinket2 and (Setting("Trinket 2 CD") or (Setting("Trinket 2 DPS") and Player:CDs()) or (Setting("Trinket 2 HP") > 0 and Player.HP <= Setting("Trinket 2 HP")) or (Setting("Trinket 2 Enemies") > 0 and Player5YC >= Setting("Trinket 2 Enemies"))) and Item.Trinket2:Use() then
        return true
    end
end

local function Defensive()
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") and Item.Healthstone:Use(Player) then
        return true
    end
end

local function Cooldowns()
    if CastTrinkets() then
        return true
    end
    --Vampiric Blood
    if Setting("Vampiric Blood") and Player.HP <= Setting("Vampiric Blood HP") and Spell.VampiricBlood:Cast(Player) then
        return true
    end
    --Icebound Fortitude
    if Setting("Icebound Fortitude") and Player.HP <= Setting("Icebound Fortitude HP") and Spell.IceboundFortitude:Cast(Player) then
        return true
    end
    --Rune Tap
    if Setting("Rune Tap") and Player.HP <= Setting("Rune Tap HP") and Spell.RuneTap:Cast(Player) then
        return true
    end
    --Tombstone
    if Talent.Tombstone.Active and Setting("Tombstone") and Player.HP <= Setting("Tombstone HP") and Buff.BoneShield:Stacks() >= 5 and Spell.Tombstone:Cast(Player) then
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
        if Player20YC > 0 and Spell.Asphyxiate:IsReady() then
            for _, Unit in pairs(Player20Y) do
                if Unit:HardCC() and Spell.Asphyxiate:Cast(Unit) then
                    return true
                end
            end
        end
    end
    return false
end

function DeathKnight.Blood()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        Player:AutoTarget(5)
        if Target and Target.ValidEnemy then
            Player5Y, Player5YC = Player:GetEnemies(5)
            Player8Y, Player8YC = Player:GetEnemies(8)
            Player15Y, Player15YC = Player:GetEnemies(15)
            Player20Y, Player20YC = Player:GetEnemies(20)
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
