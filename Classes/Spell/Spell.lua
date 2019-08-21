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

function Spell:CD()
    if DMW.Pulses == self.CDUpdate then
        return self.CDCache
    end
    self.CDUpdate = DMW.Pulses
    local LocStart, LocDuration = GetSpellLossOfControlCooldown(self.SpellName)
    local Start, CD = GetSpellCooldown(self.SpellName)
    if not Start then
        Start, CD = GetSpellCooldown(self.SpellID)
    end
	if LocStart and (LocStart + LocDuration) > (Start + CD) then
		Start = LocStart
		CD = LocDuration
	end
    local FinalCD = 0
    if Start > 0 and CD > 0 then
        FinalCD = Start + CD - DMW.Time
    else
        self.CDCache = 0
        return 0
    end
    FinalCD = FinalCD - 0.1
    if FinalCD < 0 then FinalCD = 0 end
    self.CDCache = FinalCD
    return FinalCD
end

function Spell:IsReady()
    -- for k, v in pairs(DMW.Player.Spells) do
    --     if v.CastType ~= "Special" and IsCurrentSpell(v.SpellID) then
    --         return false
    --     end
    -- end
    if GetSpellInfo(self.SpellName) and IsUsableSpell(self.SpellName) and self:CD() == 0 then
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

function Spell:CastTime()
    return select(4, GetSpellInfo(self.SpellName))
end
