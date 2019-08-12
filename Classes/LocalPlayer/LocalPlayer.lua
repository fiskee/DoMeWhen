local DMW = DMW
local LocalPlayer = DMW.Classes.LocalPlayer
local Spell = DMW.Classes.Spell
local Buff = DMW.Classes.Buff
local Debuff = DMW.Classes.Debuff

function LocalPlayer:New(Pointer)
    self.Pointer = Pointer
    self.Name = UnitName(Pointer)
    self.CombatReach = UnitCombatReach(Pointer)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(Pointer)
    self.GUID = ObjectGUID(Pointer)
    self.Class = select(2, UnitClass(Pointer))
    self.Spec = DMW.Enums.Specs[GetSpecializationInfo(GetSpecialization())] or ""
    self.Distance = 0
    DMW.Functions.AuraCache.Refresh(Pointer)
    self:GetSpells()
end

function LocalPlayer:Update()
    self.Spec = DMW.Enums.Specs[GetSpecializationInfo(GetSpecialization())] or ""
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Health = UnitHealth(self.Pointer)
    self.HealthMax = UnitHealthMax(self.Pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.Power = UnitPower(self.Pointer)
    self.PowerMax = UnitPowerMax(self.Pointer)
    self.PowerPct = self.Power / self.PowerMax * 100
    self.Instance = select(2, IsInInstance())
    self.Casting = UnitCastingInfo(self.Pointer) or UnitChannelInfo(self.Pointer)
    self.Combat = UnitAffectingCombat(self.Pointer)
    self.Moving = GetUnitSpeed(self.Pointer) > 0
end

function LocalPlayer:GetSpells()
    local CastType, Duration
    self.Spells = {}
    self.Buffs = {}
    self.Debuffs = {}
    for k,v in pairs(DMW.Enums.Spells) do
        if k == "GLOBAL" or k == self.Class then
            for Spec, SpecTable in pairs(v) do
                if Spec == "All" or Spec == self.Spec then
                    for SpellType, SpellTable in pairs(SpecTable) do
                        if SpellType == "Abilities" then
                            for SpellName,SpellInfo in pairs(SpellTable) do
                                CastType = SpellInfo.CastType or "Normal" 
                                self.Spells[SpellName] = Spell(SpellInfo.SpellID, CastType)
                            end
                        end
                        if SpellType == "Buffs" then
                            for SpellName,SpellID in pairs(SpellTable) do
                                self.Buffs[SpellName] = Buff(SpellID)
                            end
                        end
                        if SpellType == "Debuffs" then
                            for SpellName,SpellInfo in pairs(SpellTable) do
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