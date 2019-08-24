local DMW = DMW
local Unit = DMW.Classes.Unit

function Unit:CalculateHP()
    local Incomming = UnitGetIncomingHeals(self.Pointer)
    if Incomming then
        self.Health = self.Health + Incomming
        self.HP = self.Health / self.HealthMax * 100
    end
end