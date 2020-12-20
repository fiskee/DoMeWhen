local DMW = DMW
local Priest = DMW.Rotations.PRIEST
local Player, Buff, Debuff, Spell, Target, Talent, Item, GCD, CDs, HUD, Player40Y, Player40YC, Friends40Y, Friends40YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {
            [1] = {
                Dispel = {
                    [1] = {Text = "Dispel |cFF00FF00Enabled", Tooltip = ""},
                    [2] = {Text = "Dispel |cffff0000Disabled", Tooltip = ""}
                }
            }
        }

        UI.AddTab("Healing")
        UI.AddRange("Penance HP", nil, 0, 100, 1, 70,true)
        UI.AddToggle("Shadow Mend", nil, true)
        UI.AddRange("Shadow Mend HP", nil, 0, 100, 1, 60)
        UI.AddRange("Atonement HP", "HP to use Power Word: Shield or Power Word: Radiance to apply Atonement", 0, 100, 1, 90,true)
        UI.AddToggle("Power Word: Shield", nil, true)
        UI.AddRange("Power Word: Shield HP", "HP to use Power Word: Shield", 0, 100, 1, 80)
        UI.AddToggle("Power Word: Radiance", nil, true)
        UI.AddRange("Power Word: Radiance Units", nil, 0, 10, 1, 3)
        UI.AddToggle("Divine Star", nil, true, true)
        UI.AddRange("Divine Star Units", nil, 0, 10, 1, 3)
        UI.AddRange("Divine Star HP", nil, 0, 100, 1, 80)
        UI.AddToggle("Rapture", nil, true, true)
        UI.AddRange("Rapture Units", nil, 0, 10, 1, 3)
        UI.AddRange("Rapture HP", nil, 0, 100, 1, 60)
        UI.AddToggle("Pain Suppression", nil, true)
        UI.AddRange("Pain Suppression HP", nil, 0, 100, 1, 20)
        UI.AddTab("DPS")
        UI.AddToggle("Shadow Word: Pain", nil, true)
        UI.AddRange("Shadow Word: Pain Units", "Max active Shadow Word: Pain dots active", 0, 10, 1, 3)
        UI.AddToggle("Divine Star DPS", nil, true)
        UI.AddRange("Divine Star DPS Units", nil, 0, 10, 1, 5)
        UI.AddTab("Defensive")
        UI.AddToggle("Healthstone", nil, true)
        UI.AddRange("Healthstone HP", nil, 0, 100, 1, 40)
        UI.AddToggle("Desperate Prayer", nil, true)
        UI.AddRange("Desperate Prayer HP", nil, 0, 100, 1, 20)
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
    Friends40Y, Friends40YC = Player:GetFriends(40)
    Player40Y, Player40YC = Player:GetEnemies(40)
end

local function OOC()
    for _, Friend in ipairs(Friends40Y) do
        if Buff.Atonement:Remain(Friend) < 3 then
            if Spell.PowerWordShield:Cast(Friend) then
                return true
            end
        end
    end
end

local function Heals()
    --Rapture
    if Setting("Rapture") then
        if Spell.Rapture:IsReady() then
            local RaptureUnits, RaptureCount = Player:GetFriends(40, Setting("Rapture HP"))
            if RaptureCount >= Setting("Rapture Units") and Spell.Rapture:Cast(Player) then
                return true
            end
        elseif Buff.Rapture:Exist() then
            for _, Friend in ipairs(Friends40Y) do
                if Friend.HP < Setting("Power Word: Shield HP") or (Player.Instance ~= "none" and Friend.Role == "TANK") then
                    if not Buff.PowerWordShield:Exist(Friend) and Spell.PowerWordShield:Cast(Friend) then
                        return true
                    end
                end
            end
        end
    end
    --Penance
    if Player.Moving or Buff.PowerOfTheDarkSide:Exist() then
        for _, Friend in ipairs(Friends40Y) do
            if Friend.HP < Setting("Penance HP") then
                if Spell.Penance:Cast(Friend) then
                    return true
                end
            else
                break
            end
        end
    end
    --SM
    if Setting("Shadow Mend") and not Player.Moving then
        for _, Friend in ipairs(Friends40Y) do
            if Friend.HP < Setting("Shadow Mend HP") then
                if Spell.ShadowMend:Cast(Friend) then
                    return true
                end
            else
                break
            end
        end
    end
    --Divine Star
    if Talent.DivineStar and Setting("Divine Star") and Player:GetFriendsInRect(30, 12, Setting("Divine Star HP")) >= Setting("Divine Star Units") and Spell.DivineStar:Cast(Player) then
        return true
    end
    --PWR
    if not Player.Moving and not Spell.PowerWordRadiance:LastCast() and Setting("Power Word: Radiance") and Spell.PowerWordRadiance:IsReady() and not Buff.Rapture:Exist() then
        local RadianceTable, RadianceC
        for _, Friend in ipairs(Friends40Y) do
            if Friend.HP < Setting("Atonement HP") then
                RadianceTable, RadianceC = Friend:GetFriends(30, Setting("Atonement HP"))
                if RadianceC >= Setting("Power Word: Radiance Units") and Buff.Atonement:Count(RadianceTable) <= (math.max(RadianceC - Setting("Power Word: Radiance Units"), 0)) then
                    if Spell.PowerWordRadiance:Cast(Friend) then
                        return true
                    end
                end
            else
                break
            end
        end
    end
    --Dispel
    if HUD.Dispel == 1 and Spell.Purify:IsReady() then
        for _, Friend in pairs(Friends40Y) do
            if Friend:Dispel(Spell.Purify) and Spell.Purify:Cast(Friend) then
                return true
            end
        end
    end
    --PWS
    if Setting("Power Word: Shield") then
        for _, Friend in ipairs(Friends40Y) do
            if Friend.HP <= Setting("Power Word: Shield HP") or (Player.Instance ~= "none" and Friend.Role == "TANK") or (Friend.HP <= Setting("Atonement HP") and not Buff.Atonement:Exist(Friend)) then
                if not Buff.PowerWordShield:Exist(Friend) and (not Debuff.WeakenedSoul:Exist(Friend) or Buff.Rapture:Exist()) then
                    if Spell.PowerWordShield:Cast(Friend) then
                        return true
                    end
                end
            end
        end
    end
end

local function DPS()
    if Setting("Shadow Word: Pain") then
        local SWPCount = Debuff.ShadowWordPain:Count(Player40Y)
        if Friends40Y[1].HP > 50 and SWPCount <= Setting("Shadow Word: Pain Units") then
            for _, Unit in ipairs(Player40Y) do
                if Debuff.ShadowWordPain:Refresh(Unit) and (Unit.TTD - Debuff.ShadowWordPain:Remain(Unit)) > 4 and (SWPCount < Setting("Shadow Word: Pain Units") or Debuff.ShadowWordPain:Exist(Unit)) then
                    if Spell.ShadowWordPain:Cast(Unit) then
                        return true
                    end
                end
            end
        end
    end
    if Target and Target.ValidEnemy then
        if Player:CDs() and Spell.Shadowfiend:Cast(Target) then
            return true
        end
        if Talent.DivineStar and Setting("Divine Star DPS") and Player:GetEnemiesInRect(30, 12, 2) >= Setting("Divine Star DPS Units") and Spell.DivineStar:Cast(Player) then
            return true
        end
        if Target.TTD > 8 and not Player.Moving and Spell.Schism:Cast(Target) then
            return true
        end
        if Target.TTD > 4 and (Player.Moving or Buff.PowerOfTheDarkSide:Exist()) and Spell.Penance:Cast(Target) then
            return true
        end
        if Spell.PowerWordSolace:Cast(Target) then
            return true
        end
        if not Player.Moving and Spell.Smite:Cast(Target) then
            return true
        end
        if Setting("Shadow Word: Pain") then
            local LowestSWP, LowestSec = Debuff.ShadowWordPain:Lowest(Player40Y)
            if LowestSWP and LowestSec < 8 and Spell.ShadowWordPain:Cast(LowestSWP) then
                return true
            end
        end
    end
end

local function Defensive()
    --HS
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") and Item.Healthstone:Use(Player) then
        return true
    end
    --DP
    if Setting("Desperate Prayer") and Player.HP <= Setting("Desperate Prayer HP") and Spell.DesperatePrayer:Cast(Player) then
        return true
    end
    --PS
    if Setting("Pain Suppression") then
        for _, Tank in ipairs(DMW.Friends.Tanks) do
            if Tank.HP < Setting("Pain Suppression HP") and Spell.PainSuppression:Cast(Tank) then
                return true
            end
        end
    end
end

function Priest.Discipline()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat then
            -- if OOC() then
            --     return true
            -- end
            if Target and Target.ValidEnemy then
                if Spell.ShadowWordPain:Cast(Target) then
                    return true
                end
            end
        else
            Player:AutoTarget(40, true)
            if Defensive() then
                return true
            end
            if Spell.GCD:CD() == 0 then
                if Heals() then
                    return true
                end
                if DPS() then
                    return true
                end
            end
        end
    end
end
