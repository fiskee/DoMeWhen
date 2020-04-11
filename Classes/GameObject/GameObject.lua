local DMW = DMW
local GameObject = DMW.Classes.GameObject

function GameObject:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
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
end

function GameObject:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function GameObject:IsQuestObject() --TODO: Actual code
    local glow = ObjectDescriptor(self.Pointer, GetOffset("CGObjectData__DynamicFlags"), "uint")
    if glow and (bit.band(glow, 0x4) ~= 0 or bit.band(glow, 0x20) ~= 0) then
        return true
    end
    return false
end

function GameObject:IsHerb() --TODO: Actual code
    return false
end

function GameObject:IsOre() --TODO: Actual code
    return false
end

function GameObject:IsTracking() --TODO: Actual code
    return false
end
