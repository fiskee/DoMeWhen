local DMW = DMW
local GameObject = DMW.Classes.GameObject

function GameObject:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
    self.TypeID, self.Type = GetGameObjectType(Pointer)
end

function GameObject:Update()
    self.NextUpdate = DMW.Time + (math.random(100, 800) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    if not self.Name or self.Name == "" then
        self.Name = ObjectName(self.Pointer)
    end
    self.Herb = self:IsHerb()
    self.Ore = self:IsOre()
    self.Tracking = self:IsTracking()
    self.IsQuest = self:IsQuestObject()
    if self.TypeID == 17 and (DMW.Settings.profile.Gatherers.FishingHelper or DMW.Settings.profile.Gatherers.AutoFishing) and DMW.Player.Casting and DMW.Player.Casting == DMW.Player.Spells.Fishing.SpellName then
        self:Fishing()
    end
end

function GameObject:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

local glow = 0
function GameObject:IsQuestObject() --TODO: Better code
    glow = ObjectDescriptor(self.Pointer, GetOffset("CGObjectData__DynamicFlags"), "uint") or 0
    if bit.band(glow, 0x4) ~= 0 or bit.band(glow, 0x20) ~= 0 then
        return true
    end
    return false
end

function GameObject:IsHerb()
    if DMW.Enums.Tracker.Herbs[self.ObjectID] and ObjectDescriptor(self.Pointer, GetOffset("CGObjectData__DynamicFlags"), "byte") == 0x00 then
        return true
    end
    return false
end

function GameObject:IsOre()
    if DMW.Enums.Tracker.Ore[self.ObjectID] and ObjectDescriptor(self.Pointer, GetOffset("CGObjectData__DynamicFlags"), "byte") == 0x00 then
        return true
    end
    return false
end

function GameObject:IsTracking()
    return false
end

function GameObject:Fishing()
    if ObjectAnimation(self.Pointer) == 1 and UnitIsUnit("player", ObjectCreator(self.Pointer)) then
        self.NextUpdate = DMW.Time + 0.1
        if not self.BobbingTime then
            self.BobbingTime = DMW.Time + (math.random(350, 850) / 1000)
        elseif self.BobbingTime < DMW.Time then
            ObjectInteract(self.Pointer)
            self.BobbingTime = false
        end
        return
    end
    if self.BobbingTime then
        self.BobbingTime = false
    end
end