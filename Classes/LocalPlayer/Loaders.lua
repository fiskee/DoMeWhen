local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer
local Spell = DMW.Classes.Spell
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff
local AzeriteItem, AzeriteEmpoweredItem = C_AzeriteItem, C_AzeriteEmpoweredItem

function LocalPlayer:GetSpells()
    self.Spells = {}
    self.Buffs = {}
    self.Debuffs = {}
    local CastType, Duration
    for Class, ClassTable in pairs(DMW.Enums.Spells) do
        if Class == "GLOBAL" or Class == self.Class then
            for Spec, SpecTable in pairs(ClassTable) do
                if Spec == "All" or Spec == self.Spec then
                    for SpellType, SpellTable in pairs(SpecTable) do
                        if SpellType == "Abilities" then
                            for SpellName, SpellInfo in pairs(SpellTable) do
                                CastType = SpellInfo.CastType or "Normal"
                                self.Spells[SpellName] = Spell(SpellInfo.SpellID, CastType)
                            end
                        elseif SpellType == "Buffs" then
                            for SpellName, SpellID in pairs(SpellTable) do
                                self.Buffs[SpellName] = Buff(SpellID)
                            end
                        elseif SpellType == "Debuffs" then
                            for SpellName, SpellInfo in pairs(SpellTable) do
                                Duration = SpellInfo.BaseDuration or nil
                                self.Debuffs[SpellName] = Debuff(SpellInfo.SpellID, Duration)
                            end
                        end
                    end
                end
            end
        end
    end
end

function LocalPlayer:GetTalents()
    local Selected
    local ActiveSpec = GetActiveSpecGroup()
    if self.Talents then
        table.wipe(self.Talents)
    else
        self.Talents = {}
    end
    for TalentName, TalentID in pairs(DMW.Enums.Spells[self.Class][self.Spec].Talents) do
        Selected = select(4, GetTalentInfoByID(TalentID, ActiveSpec))
        if Selected then
            self.Talents[TalentName] = {Active = true, Value = 1}
        else
            self.Talents[TalentName] = {Active = false, Value = 0}
        end
    end
end

function LocalPlayer:GetTraits()
    local AzeriteItemLocation = AzeriteItem.FindActiveAzeriteItem()
    local Traits = DMW.Enums.Spells[self.Class][self.Spec].Traits
    if self.Traits then
        table.wipe(self.Traits)
    else
        self.Traits = {}
    end
    for TraitName, _ in pairs(Traits) do
        self.Traits[TraitName] = {Active = false, Rank = 0, Value = 0}
    end
    if not AzeriteItemLocation then
        return false
    end
    local IsSelected, PowerInfo, AzeriteSpellID, TierInfo, ItemLocation, item
    local AzeritePowerLevel = AzeriteItem.GetPowerLevel(AzeriteItemLocation)
    for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED - 1 do
        item = Item:CreateFromEquipmentSlot(slot)
        if not item:IsItemEmpty() then
            ItemLocation = item:GetItemLocation()
            if AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(ItemLocation) then
                TierInfo = AzeriteEmpoweredItem.GetAllTierInfo(ItemLocation)
                for _, Info in next, TierInfo do
                    if (Info.unlockLevel <= AzeritePowerLevel) then
                        for _, PowerID in next, Info.azeritePowerIDs do
                            IsSelected = AzeriteEmpoweredItem.IsPowerSelected(ItemLocation, PowerID)
                            PowerInfo = AzeriteEmpoweredItem.GetPowerInfo(PowerID)
                            if PowerInfo and IsSelected then
                                AzeriteSpellID = PowerInfo.spellID
                                for TraitName, SpellID in pairs(Traits) do
                                    if SpellID == AzeriteSpellID then
                                        self.Traits[TraitName].Active = true
                                        self.Traits[TraitName].Rank = self.Traits[TraitName].Rank + 1
                                        self.Traits[TraitName].Value = 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function LocalPlayer:GetEssences()
    local Essences = DMW.Enums.Spells.GLOBAL.All.Essences
    if self.Essences then
        table.wipe(self.Essences)
    else
        self.Essences = {}
    end
    for EssenceName, _ in pairs(Essences) do
        self.Essences[EssenceName] = {Active = false, Rank = 0, Value = 0}
    end
    if self.Level == 120 then
        local PlayerEssences = C_AzeriteEssence.GetEssences()
        if PlayerEssences then
            for _, Essence in pairs(PlayerEssences) do
                if Essence.unlocked then
                    for EssenceName, EssenceID in pairs(Essences) do
                        if EssenceID == Essence.ID then
                            self.Essences[EssenceName].Active = true
                            self.Essences[EssenceName].Rank = Essence.rank
                            self.Essences[EssenceName].Value = 1
                            if EssenceID == C_AzeriteEssence.GetMilestoneEssence(115) then
                                self.Essences[EssenceName].Major = true
                            else
                                self.Essences[EssenceName].Major = false
                            end
                        end
                    end
                end
            end
        end
    end
end

function LocalPlayer:UpdateEquipment()
    table.wipe(self.Equipment)
    self.Items.Trinket1 = nil
    self.Items.Trinket2 = nil
    local ItemID
    for i = 1, 19 do
        ItemID = GetInventoryItemID("player", i)
        if ItemID then
            self.Equipment[i] = ItemID
            if i == 13 then
                self.Items.Trinket1 = DMW.Classes.Item(ItemID)
            elseif i == 14 then
                self.Items.Trinket2 = DMW.Classes.Item(ItemID)
            end
        end
    end
end

function LocalPlayer:GetItems()
    local Item = DMW.Classes.Item
    for Name, ItemID in pairs(DMW.Enums.Items) do
        self.Items[Name] = Item(ItemID)
    end
end