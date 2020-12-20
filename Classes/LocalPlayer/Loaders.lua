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
                                self.Spells[SpellName] = Spell(SpellInfo.SpellID, CastType, SpellInfo.SpellType)
                            end
                        elseif SpellType == "Buffs" then
                            for SpellName, SpellInfo in pairs(SpellTable) do
                                if type(SpellInfo) ~= "number" then
                                    self.Buffs[SpellName] = Buff(SpellInfo.SpellID)
                                else
                                    self.Buffs[SpellName] = Buff(SpellInfo)
                                end
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
    if DMW.Enums.Spells[self.Class].All.Talents then
        for TalentName, TalentID in pairs(DMW.Enums.Spells[self.Class].All.Talents) do
            Selected = select(4, GetTalentInfoByID(TalentID, ActiveSpec))
            if Selected then
                self.Talents[TalentName] = {Active = true, Value = 1}
            else
                self.Talents[TalentName] = {Active = false, Value = 0}
            end
        end
    end
end

function LocalPlayer:UpdateEquipment()
    table.wipe(self.Equipment)
    table.wipe(self.EquipmentID)
    table.wipe(self.Runeforge)
    self.Items.Trinket1 = nil
    self.Items.Trinket2 = nil
    local FoundRuneforge = false
    local ItemID
    for i = 1, 19 do
        ItemID = GetInventoryItemID("player", i)
        if ItemID then
            self.EquipmentID[ItemID] = true
            self.Equipment[i] = ItemID
            if i == 13 then
                self.Items.Trinket1 = DMW.Classes.Item(ItemID)
            elseif i == 14 then
                self.Items.Trinket2 = DMW.Classes.Item(ItemID)
            end
            if not FoundRuneforge then
                local string = GetInventoryItemLink("player", i)
                if string then
                    local LegendaryID = select(15, strsplit(":", string))
                    if DMW.Enums.Runeforge[tonumber(legID)] then
                        self.Runeforge[DMW.Enums.Runeforge[tonumber(LegendaryID)]] = true
                        FoundRuneforge = true
                    end
                end
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

function LocalPlayer:GetCovenantData()
    table.wipe(self.Conduits)
    local ActiveCovenantID = C_Covenants.GetActiveCovenantID()
    if ActiveCovenantID > 0 then
        local CovenantData = C_Covenants.GetCovenantData(ActiveCovenantID)
        if CovenantData then
            self.Covenant = CovenantData.textureKit
        end
        local Data = C_Soulbinds.GetSoulbindData(C_Soulbinds.GetActiveSoulbindID())
        local ID
        for _, node in pairs(Data.tree.nodes) do
            if node.state == 3 and node.conduitID and DMW.Enums.Conduits[node.conduitID] then
                self.Conduits[DMW.Enums.Conduits[node.conduitID]] = true
            end
        end
    end
end