local DMW = DMW
local AlertTimer = GetTime()
DMW.Helpers.Trackers = {}
local LibDraw = LibStub("LibDraw-1.0")
local tX, tY, tZ

function DMW.Helpers.Trackers.Run()
    local s = 1
    for _, Unit in pairs(DMW.Units) do
        if Unit.IsQuest then
            Unit:UpdatePosition()
            tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
            LibDraw.SetWidth(4)
            LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
            LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
            LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
        end
    end
    for _, Object in pairs(DMW.GameObjects) do
        if Object.IsQuest then
            tX, tY, tZ = Object.PosX, Object.PosY, Object.PosZ
            LibDraw.SetWidth(4)
            LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
            LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
            LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
        end
    end
end