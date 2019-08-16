local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer
local Spell = DMW.Classes.Spell
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff
local AzeriteItem, AzeriteEmpoweredItem = C_AzeriteItem, C_AzeriteEmpoweredItem

function LocalPlayer:New(Pointer)
    self.Pointer = Pointer
    self.Name = UnitName(Pointer)
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.GUID = ObjectGUID(Pointer)
    self.Class = select(2, UnitClass(Pointer)):gsub("%s+", "")
    self.Spec = DMW.Enums.Specs[GetSpecializationInfo(GetSpecialization())] or ""
    self.Distance = 0
    self.EID = false
    DMW.Functions.AuraCache.Refresh(Pointer)
    self:GetSpells()
    self:GetTalents()
    self:GetTraits()
    self:GetEssences()
end

function LocalPlayer:Update()
    self.SpecID = GetSpecializationInfo(GetSpecialization())
    self.Spec = DMW.Enums.Specs[self.SpecID] or ""
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Health = UnitHealth(self.Pointer)
    self.HealthMax = UnitHealthMax(self.Pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.Power = UnitPower(self.Pointer)
    self.PowerMax = UnitPowerMax(self.Pointer)
    self.PowerPct = self.Power / self.PowerMax * 100
    self.PowerRegen = GetPowerRegen()
    self.Instance = select(2, IsInInstance())
    self.Casting = UnitCastingInfo(self.Pointer) or UnitChannelInfo(self.Pointer)
    self.Combat = UnitAffectingCombat(self.Pointer)
    self.Moving = GetUnitSpeed(self.Pointer) > 0
    self.PetActive = UnitIsVisible("pet")
    self.InGroup = IsInGroup()
end

function LocalPlayer:GCD()
    if DMW.Enums.GCDOneSec[self.SpecID] then
        return 1
    else
        return math.max(1.5 / (1 + GetHaste() / 100), 0.75)
    end
end

function LocalPlayer:GCDMax()
    if DMW.Enums.GCDOneSec[self.SpecID] then
        return 1
    else
        return 1.5
    end
end

function LocalPlayer:CDs()
    if DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 3 then
        return false
    elseif DMW.Settings.profile.HUD.CDs and DMW.Settings.profile.HUD.CDs == 2 then
        return true
    elseif self.Target and self.Target:IsBoss() then
        return true
    end
    return false
end

function LocalPlayer:CritPct()
    return GetCritChance()
end

function LocalPlayer:TTM()
    local PowerMissing = self.PowerMax - self.Power
    if PowerMissing > 0 then
        return PowerMissing / self.PowerRegen
    else
        return 0
    end
end

function LocalPlayer:AutoTarget(Yards)
    if not self.Target and self.Combat then
        for k,v in pairs(DMW.Enemies) do
            if v.Distance <= Yards then
                TargetUnit(v.Pointer)
                return true
            end
        end
    end
end

function LocalPlayer:GetEnemies(Yards)
    local EnemyTable = {}
    local Count = 0
    for _, v in pairs(DMW.Enemies) do
        if v:GetDistance(self) <= Yards then
            table.insert(EnemyTable, v)
            Count = Count + 1
        end
    end
    return EnemyTable, Count
end

function LocalPlayer:GetSpells()
    local CastType, Duration
    self.Spells = {}
    self.Buffs = {}
    self.Debuffs = {}
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
    local PlayerEssences = C_AzeriteEssence.GetEssences()
    if PlayerEssences then
        for _, Essence in pairs(PlayerEssences) do
            if Essence.unlocked then
                for EssenceName, EssenceID in pairs(Essences) do
                    if EssenceID == Essence.ID then
                        self.Essences[EssenceName].Active = true
                        self.Essences[EssenceName].Rank = Essence.rank
                        self.Essences[EssenceName].Value = 1
                    end
                end
            end
        end
    end
end
