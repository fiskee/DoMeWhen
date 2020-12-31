local DMW = DMW
local AreaTrigger = DMW.Classes.AreaTrigger

function AreaTrigger:New(Pointer)
    self.Pointer = Pointer
    self.Name = ObjectName(Pointer)
    self.ObjectID = ObjectID(Pointer)
    if self.ObjectID == 12765 then
        DMW.Tables.Sanguine[Pointer] = {}
        DMW.Tables.Sanguine[Pointer].PosX, DMW.Tables.Sanguine[Pointer].PosY, DMW.Tables.Sanguine[Pointer].PosZ = ObjectPosition(Pointer)
    end
end

function AreaTrigger:Update()
    self.NextUpdate = DMW.Time + (math.random(100, 800) / 1000)
    self.PosX, self.PosY, self.PosZ = ObjectPosition(self.Pointer)
    self.Distance = self:GetDistance()
    if not self.Name or self.Name == "" then
        self.Name = ObjectName(self.Pointer)
    end
    self.Tracking = self:IsTracking()
    if DMW.Settings.profile.Enemy.DrawDangerous then
        self:Drawings()
    end
end

function AreaTrigger:GetDistance(OtherUnit)
    OtherUnit = OtherUnit or DMW.Player
    return sqrt(((self.PosX - OtherUnit.PosX) ^ 2) + ((self.PosY - OtherUnit.PosY) ^ 2) + ((self.PosZ - OtherUnit.PosZ) ^ 2))
end

function AreaTrigger:IsTracking() --TODO: Actual code
    return false
end
