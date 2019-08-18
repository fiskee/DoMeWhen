local DMW = DMW
local Item = DMW.Classes.Item

function Item:New(ItemID)
    self.ItemID = ItemID
    self.ItemName = GetItemInfo(ItemID)
    self.SpellName, self.SpellID = GetItemSpell(ItemID)
    self.Cache = {}
end

function Item:Equipped()

end

function Item:CD()
    if DMW.Pulses == self.Cache.CDUpdate then
        return self.Cache.CD
    end
    self.Cache.CDUpdate = DMW.Pulses
    local Start, Duration, Enable = GetItemCooldown(self.ItemID)
    if Enable == 0 then
        return 99
    end
    local CD = Start + Duration - DMW.Time
    return CD > 0 and CD or 0
end

function Item:IsReady()
    return IsUsableItem(self.ItemID) and self:CD() == 0
end

function Item:Use()
    if self.SpellID and self:IsReady() then
        RunMacroText("/use " .. self.ItemName)
        return true
    end
    return false
end