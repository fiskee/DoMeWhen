local DMW = DMW
local AlertTimer = GetTime()
DMW.Helpers.Trackers = {}
local LibDraw = LibStub("LibDraw-1.0")
local tX, tY, tZ
local Settings

function DMW.Helpers.DrawLineDMW(sx, sy, sz, ex, ey, ez)
    local function WorldToScreen(wX, wY, wZ)
        local sX, sY = _G.WorldToScreen(wX, wY, wZ)
        if sX and sY then
            return sX, -(WorldFrame:GetTop() - sY)
        else
            return sX, sY
        end
    end
    local startx, starty = WorldToScreen(sx, sy, sz)
    local endx, endy = WorldToScreen(ex, ey, ez)
    if (endx == nil or endy == nil) and (startx and starty) then
        local i = 1
        while (endx == nil or endy == nil) and i < 50 do
            endx, endy = WorldToScreen(GetPositionBetweenPositions(ex, ey, ez, sx, sy, sz, i))
            i = i + 1
        end
    end
    if (startx == nil or starty == nil) and (endx and endy) then
        local i = 1
        while (startx == nil or starty == nil) and i < 50 do
            startx, starty = WorldToScreen(GetPositionBetweenPositions(sx, sy, sz, ex, ey, ez, i))
            i = i + 1
        end
    end
    LibDraw.Draw2DLine(startx, starty, endx, endy)
end

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
        if Settings.Developer.Units or (DMW.Enums.Tracker.MountsRare[Unit.ObjectID] and not Unit.Dead) then
            LibDraw.Text("Unit: " .. Unit.Name .. " (" .. Unit.ObjectID .. ") - " .. math.floor(Unit.Distance) .. " Yards", "GameFontNormal", Unit.PosX, Unit.PosY, Unit.PosZ + 2)
        end
        if DMW.Enums.Tracker.MountsRare[Unit.ObjectID] and not Unit.Dead then
            if (AlertTimer + 5) < DMW.Time and not IsForeground() then
                FlashClientIcon()
                AlertTimer = DMW.Time
            end
            tX, tY, tZ = Unit.PosX, Unit.PosY, Unit.PosZ
            LibDraw.SetWidth(4)
            DMW.Helpers.DrawLineDMW(tX, tY, tZ, DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ + 2)
        end
    end
    for _, Object in pairs(DMW.GameObjects) do
        if Settings.Trackers.Quests and Object.IsQuest then
            tX, tY, tZ = Object.PosX, Object.PosY, Object.PosZ
            LibDraw.SetWidth(4)
            LibDraw.Line(tX, tY, tZ + s * 1.3, tX, tY, tZ)
            LibDraw.Line(tX - s, tY, tZ, tX + s, tY, tZ)
            LibDraw.Line(tX, tY - s, tZ, tX, tY + s, tZ)
        end
        if Settings.Developer.GameObjects then
            LibDraw.Text("GO: " .. Object.Name .. " (" .. Object.ObjectID .. ") - " .. math.floor(Object.Distance) .. " Yards - " .. string.format("%X", ObjectDescriptor(Object.Pointer, GetOffset("CGObjectData__DynamicFlags"), "byte")), "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
        elseif Settings.Trackers.HorrificVisions and (DMW.Enums.Tracker.Visions[Object.ObjectID] or Object.Name == "Black Empire Cache" or Object.Name == "Odd Crystal")  then
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
        elseif Settings.Trackers.Herbs and Object:IsHerb() then
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
        elseif Settings.Trackers.Ore and Object:IsOre() then
            LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormal", Object.PosX, Object.PosY, Object.PosZ + 2)
        end
    end
    for _, AreaTrigger in pairs(DMW.AreaTriggers) do
        if Settings.Developer.AreaTriggers then
            LibDraw.Text("Area Trigger: " .. AreaTrigger.ObjectID .. " - " .. math.floor(AreaTrigger.Distance) .. " Yards", "GameFontNormal", AreaTrigger.PosX, AreaTrigger.PosY, AreaTrigger.PosZ + 2)
        end
    end
end