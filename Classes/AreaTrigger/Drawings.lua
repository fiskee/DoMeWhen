local DMW = DMW
local AreaTrigger = DMW.Classes.AreaTrigger
local LibDraw = LibStub("LibDraw-1.0")

local Triggers = {
    [23839] = {"rect", 30, 2}, --First boss
    [23813] = {"rect", 40, 2} --Second boss
}

function AreaTrigger:Drawings()
    local Trigger = Triggers[self.ObjectID]
    if Trigger then
        LibDraw.SetColorRaw(0, 1, 0)
        if Trigger[1] == "rect" then
            self:DrawRect(Trigger[2], Trigger[3])
        elseif Trigger[1] == "cone" then
            self:DrawCone(Trigger[2], Trigger[3])
        end
        self.NextUpdate = DMW.Time
    end
end

function AreaTrigger:DrawRect(Length, Width)
    local function IsInside(x, y, ax, ay, bx, by, dx, dy)
        local bax = bx - ax
        local bay = by - ay
        local dax = dx - ax
        local day = dy - ay
        if ((x - ax) * bax + (y - ay) * bay <= 0.0) then
            return false
        end
        if ((x - bx) * bax + (y - by) * bay >= 0.0) then
            return false
        end
        if ((x - ax) * dax + (y - ay) * day <= 0.0) then
            return false
        end
        if ((x - dx) * dax + (y - dy) * day >= 0.0) then
            return false
        end
        return true
    end
    local Rotation = select(2, ObjectFacing(self.Pointer)) or 0
    local halfWidth = Width / 2
    local nlX, nlY, nlZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, halfWidth, Rotation + rad(90), 0)
    local nrX, nrY, nrZ = GetPositionFromPosition(self.PosX, self.PosY, self.PosZ, halfWidth, Rotation + rad(270), 0)
    local flX, flY, flZ = GetPositionFromPosition(nlX, nlY, nlZ, Length, Rotation, 0)
    local frX, frY, frZ = GetPositionFromPosition(nrX, nrY, nrZ, Length, Rotation, 0)
    if IsInside(DMW.Player.PosX, DMW.Player.PosY, nlX, nlY, nrX, nrY, frX, frY) then
        LibDraw.SetColorRaw(1, 0, 0)
    end
    DMW.Helpers.DrawLineDMW(flX, flY, DMW.Player.PosZ, nlX, nlY, DMW.Player.PosZ)
    DMW.Helpers.DrawLineDMW(frX, frY, DMW.Player.PosZ, nrX, nrY, DMW.Player.PosZ)
    DMW.Helpers.DrawLineDMW(frX, frY, DMW.Player.PosZ, flX, flY, DMW.Player.PosZ)
    DMW.Helpers.DrawLineDMW(nlX, nlY, DMW.Player.PosZ, nrX, nrY, DMW.Player.PosZ)
end

function AreaTrigger:DrawCone(Angle, Length)
    local Rotation = select(2, ObjectFacing(self.Pointer))
    if UnitIsFacing(self.Pointer, "player", Angle / 2) and self:RawDistance(DMW.Player) <= Length then
        LibDraw.SetColorRaw(1, 0, 0)
    end
    LibDraw.Arc(self.PosX, self.PosY, self.PosZ, Length, Angle, Rotation)
end
