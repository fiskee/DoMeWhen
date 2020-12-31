local DMW = DMW
local Unit = DMW.Classes.Unit
local LibDraw = LibStub("LibDraw-1.0")

local Casts = {
    --Shadowlands Credit Immy
    --NecroticWake
    [324323] = {"cone", 5, 120}, --Gruesome Cleave
    -- [333489] = {"rect", 25, 10}, --Amarth Necrotic Breath???????????????????????
    [333477] = {"cone", 10, 60}, -- Gut Slice
    --De Other Side
    [334051] = {"rect", 20, 7}, --Erupting Darkness
    --Mists of Tirna Scithe
    [323137] = {"cone", 35, 20}, --Bewildering Pollen
    [321968] = {"cone", 35, 20}, --Bewildering Pollen
    [340160] = {"cone", 20, 45}, --Radiant Breath
    [340300] = {"cone", 12, 60}, --Tongue Lashing
    --PlagueFall
    [324667] = {"cone", 100, 60}, -- Slime Wave
    [328395] = {"cone", 15, 30}, --Venompiercer
    [330404] = {"rect", 15, 10}, --Wing Buffet
    [318949] = {"cone", 20, 60}, --FesteringBelch
    [327233] = {"cone", 30, 45}, --Belch Plague
    --Halls of Attonement
    -- [325797] = {"cone"} -- Rapid Fire 325797 325793 325799 not found
    --322936 First boss ???
    [346866] = {"cone", 15, 60}, --Stone Breath
    [325523] = {"cone", 8, 40}, --Deadly Thrust
    [326623] = {"cone", 8, 90}, --Reaping Strike
    [326997] = {"cone", 7, 60}, --Powerful Swipe
    [323236] = {"cone", 25, 30}, --Unleashed Suffering
    --Sanguine Depths
    [320991] = {"rect", 8, 5}, --Echoing Thrust ??? add areatriggers
    [322429] = {"cone", 8, 60}, --Severing Slice
    --Spires of Ascension
    [317943] = {"cone", 8, 60}, --Sweeping Blow
    [323943] = {"rect", 25, 4}, --Run Through
    [324205] = {"cone", 30, 25}, --Blinding Flash
    --Theeatre of Pain
    --misc
    [331718] = {"cone", 60, 15}, --Spear Flurry ???
    [333294] = {"rect", 25, 10}, --Death Winds ??? or 333297
    [334329] = {"cone", 60, 15}, --Sweeping Slash
    -- [330403] = {"rect", 10, 20}, --WingBuffet ???
    [329518] = {"cone", 60, 20},
    [326455] = {"cone", 75, 10},
    [329181] = {"rect", 15, 5} --last Cleave
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

function Unit:DrawRect(Length, Width)
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
