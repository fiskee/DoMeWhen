local DMW = DMW
local GameObject = DMW.Classes.GameObject

function GameObject:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
end

function GameObject:Update()
    self.NextUpdate = DMW.Time + (math.random(100, 400) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    if not self.Name or self.Name == "" then
        self.Name = ObjectName(self.Pointer)
    end
    self.Quest = self:IsQuest()
    self.Herb = self:IsHerb()
    self.Ore = self:IsOre()
    self.Trackable = self:IsTrackable()
end

function GameObject:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function GameObject:IsQuest() --TODO: Actual code
    return false
end

function GameObject:IsHerb() --TODO: Actual code
    return false
end

function GameObject:IsOre() --TODO: Actual code
    return false
end

function GameObject:IsTrackable() --TODO: Actual code
    return false
end
