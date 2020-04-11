local DMW = DMW
local AlertTimer = GetTime()
DMW.Helpers.Trackers = {}
local LibDraw = LibStub("LibDraw-1.0")
local tX, tY, tZ
local Settings

function DMW.Helpers.Trackers.Run()
    if not Settings then
        Settings = DMW.Settings.profile
    end
    local s = 1
    for _, Unit in pairs(DMW.Units) do
        if Settings.Trackers.Quests and Unit.IsQuest then
            Unit:UpdatePosition()
            tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
            LibDraw.SetWidth(4)
            LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
            LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
            LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
        end
        if Settings.Developer.Units then
            LibDraw.Text("Unit: " .. Unit.Name .. " (" .. Unit.ObjectID .. ") - " .. math.floor(Unit.Distance) .. " Yards", "GameFontNormal", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
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
        if Settings.Developer.GameObjects then
            LibDraw.Text("GO: " .. Object.Name .. " (" .. Object.ObjectID .. ") - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
        end
    end
    for _, AreaTrigger in pairs(DMW.AreaTriggers) do
        if Settings.Developer.AreaTriggers then
            LibDraw.Text("AT: " .. AreaTrigger.ObjectID .. " - " .. math.floor(AreaTrigger.Distance) .. " Yards", "GameFontNormal", AreaTrigger.PosX, AreaTrigger.PosY, AreaTrigger.PosZ + 2)
        end
    end
end