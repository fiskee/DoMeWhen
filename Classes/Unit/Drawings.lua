local DMW = DMW
local Unit = DMW.Classes.Unit
local LibDraw = LibStub("LibDraw-1.0")

local Casts = {
    [321968] = {"cone", 35, 20}, --Bewildering Pollen
    [323137] = {"cone", 35, 20}, --Bewildering Pollen
    [331718] = {"cone", 60, 15}, --Spear Flurry ???
    [334051] = {"rect", 7, 20}, --Erupting Darkness
    [324205] = {"cone", 25, 30}, --Blinding Flash
    [333294] = {"rect", 10, 25}, --Death Winds ??? or 333297
    [346866] = {"cone", 60, 15}, --Stone Breath
    [334329] = {"cone", 60, 15}, --Sweeping Slash
    [320991] = {"rect", 5, 20}, --Echoing Thrust ??? add areatriggers
    [330403] = {"rect", 10, 20}, --WingBuffet ???
    [318949] = {"cone", 60, 10} --FesteringBelch ???
}

function Unit:Drawings()
    local CastID, ChannelID = UnitCastID(self.Pointer)
    local Cast = Casts[CastID] or Casts[ChannelID]
    if Cast then
        LibDraw.SetColorRaw(0, 1, 0)
        if Cast[1] == "rect" then
            self:DrawRect(Cast[2], Cast[3])
        elseif Cast[1] == "cone" then
            self:DrawCone(Cast[2], Cast[3])
        end
        self.NextUpdate = DMW.Time
    end
end

function Unit:DrawRect(Width, Length)
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

function Unit:DrawCone(Angle, Length)
    local Rotation = select(2, ObjectFacing(self.Pointer))
    if UnitIsFacing(self.Pointer, "player", Angle / 2) and self:RawDistance(DMW.Player) <= Length then
        LibDraw.SetColorRaw(1, 0, 0)
    end
    LibDraw.Arc(self.PosX, self.PosY, self.PosZ, Length, Angle, Rotation)
end
