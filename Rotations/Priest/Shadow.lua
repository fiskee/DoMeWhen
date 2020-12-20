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

        UI.AddTab("DPS")
        UI.AddToggle("Shadow Word: Pain", nil, true)
        UI.AddRange("Shadow Word: Pain Units", "Max active Shadow Word: Pain dots active", 0, 10, 1, 3)
        UI.AddTab("Defensive")
        UI.AddToggle("Healthstone", nil, true)
        UI.AddRange("Healthstone HP", nil, 0, 100, 1, 40)
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

local function CDs()

end

local function Cleave()

end

local function Single()

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
end

function Priest.Shadow()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat then
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
                if Cleave() then
                    return true
                elseif Single() then
                    return true
                end
            end
        end
    end
end
