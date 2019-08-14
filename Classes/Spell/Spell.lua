local DMW = DMW
local Spell = DMW.Classes.Spell

function Spell:New(SpellID, CastType)
    self.SpellID = SpellID
    self.SpellName = GetSpellInfo(self.SpellID)
    self.BaseCD = GetSpellBaseCooldown(self.SpellID) / 1000
    self.BaseGCD = select(2, GetSpellBaseCooldown(self.SpellID)) / 1000
    self.MinRange = select(5,GetSpellInfo(self.SpellID)) or 0
    self.MaxRange = select(6,GetSpellInfo(self.SpellID)) or 0
    self.Cost = 0
    self.CastType = CastType or "Normal" -- Ground, Normal, Pet ect.
    self.IsHarmful = IsHarmfulSpell(self.SpellName) or false
    self.IsHelpful = IsHelpfulSpell(self.SpellName) or false
    self.LastCastTime = 0
    self.LastBotTarget = ""
    local costTable = GetSpellPowerCost(self.SpellName)
    if costTable then
        for _, costInfo in pairs(costTable) do
            if costInfo.cost > 0 then
                self.Cost = costInfo.cost
            end
            if costInfo.costPerSec > 0 then
                self.Cost = costInfo.costPerSec
                self.CastType = "Channel"
            end
        end
    end
end

function Spell:CurrentCD()
    if DMW.Pulses == self.CDUpdate then
        return self.CD
    end
    self.CDUpdate = DMW.Pulses
    local locStart, locDuration = GetSpellLossOfControlCooldown(self.SpellID)
	local Start, CD = GetSpellCooldown(self.SpellID)
	if (locStart + locDuration) > (Start + CD) then
		Start = locStart
		CD = locDuration
	end
    local MyCD = 0
    if Start > 0 and CD > 0 then
        MyCD = Start + CD - DMW.Time
    else
        self.CD = 0
        return 0
    end
    MyCD = MyCD - 0.1
    if MyCD < 0 then MyCD = 0 end
    self.CD = MyCD
    return MyCD
end

function Spell:IsReady()
    -- for k, v in pairs(DMW.Player.Spells) do
    --     if v.CastType ~= "Special" and IsCurrentSpell(v.SpellID) then
    --         return false
    --     end
    -- end
    if GetSpellInfo(self.SpellName) and IsUsableSpell(self.SpellID) and self:CurrentCD() == 0 then
        return true
    end
    return false
end

function Spell:Charges()
    return GetSpellCharges(self.SpellID)
end

function Spell:ChargesFrac()
    local Charges, MaxCharges, Start, Duration = GetSpellCharges(self.SpellID)
    if Charges ~= MaxCharges then
        return Charges + (1 - (Start + Duration - DMW.Time) / Duration)
    else
        return Charges
    end
end

function Spell:RechargeTime()
    local Charges, MaxCharges, Start, Duration = GetSpellCharges(self.SpellID)
    if Charges ~= MaxCharges then
        return Start + Duration - DMW.Time
    else
        return 0
    end
end

function Spell:FullRechargeTime()
    local Charges, MaxCharges, Start, Duration = GetSpellCharges(self.SpellID)
    if Charges ~= MaxCharges then
        local ChargesFracRemain = MaxCharges - (Charges + (1 - (Start + Duration - DMW.Time) / Duration))
        return ChargesFracRemain * Duration
    else
        return 0
    end
end