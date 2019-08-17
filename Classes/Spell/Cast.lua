local DMW = DMW
local Spell = DMW.Classes.Spell

local function FacingCast(SpellName, Target)
	local CastTime = select(4, GetSpellInfo(SpellName))
	if CastTime == 0 and UnitIsVisible(Target or "Target") and not ObjectIsFacing("Player", Target or "Target") and not UnitIsUnit("Player", Target or "Target") then
		local Facing = ObjectFacing("Player")
		local MouselookActive = false
		if IsMouselooking() then
			MouselookActive = true
			MouselookStop()
		end
		FaceDirection(Target or "Target", true)
		CastSpellByName(SpellName, Target)
		FaceDirection(Facing)
		if MouselookActive then
			MouselookStart()
		end
		C_Timer.After(0.1, function()
			FaceDirection(ObjectFacing("player"), true)
        end)
	else
		CastSpellByName(SpellName, Target)
	end
end

function Spell:Cast(Unit)
    if not Unit then
        if self.IsHarmful and DMW.Player.Target then
            Unit = DMW.Player.Target
        elseif self.IsHelpful then
            Unit = DMW.Player
        else
            return false
        end
    end
    if self:IsReady() and (Unit.Distance <= self.MaxRange or IsSpellInRange(self.SpellName, Unit.Pointer) == 1) then
        if self.CastType == "Ground" then
            if self:CastGround(Unit.PosX, Unit.PosY, Unit.PosZ) then
                self.LastBotTarget = Unit.Pointer
            else
                return false
            end
        else
            FacingCast(self.SpellName, Unit.Pointer)
            self.LastBotTarget = Unit.Pointer
        end
        return true
    end
    return false
end

function Spell:CastGround(X, Y, Z)
    if self:IsReady() then
        local PX, PY, PZ = DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ
        local Distance = (((X - PX) ^ 2) + ((Y - PY) ^ 2) + ((Z - PZ) ^ 2))
        if Distance > self.MaxRange then 
            X,Y,Z = GetPositionBetweenPositions (X, Y, Z, PX, PY, PZ, Distance - self.MaxRange)
        end
        Z = select(3,TraceLine(X, Y, Z+5, X, Y, Z-5, 0x110))
        if Z ~= nil and TraceLine(PX, PY, PZ+2, X, Y, Z+1, 0x100010) == nil and TraceLine(X, Y, Z+4, X, Y, Z, 0x1) == nil then
            CastSpellByName(self.SpellName)
            ClickPosition(X, Y, Z)
            return true
        end
    end
    return false
end

function Spell:CastBestConeEnemy(Length, Angle, MinHit, TTD)
	if not self:IsReady() then
		return false
    end
    MinHit = MinHit or 1
    TTD = TTD or 0
    local Table, TableCount = DMW.Player:GetEnemies("player", Length)
    if TableCount < MinHit then
        return false
    end
	local PX, PY, PZ = DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ
    local ConeTable = {}
    local X, Y, Z, AngleToUnit
    for _, Unit in pairs(Table) do
        if Unit.TTD >= TTD then
            X, Y, Z = Unit.PosX, Unit.PosY, Unit.PosZ
            AngleToUnit = rad(atan2(Y - PY, X - PX))
            if AngleToUnit < 0 then
                AngleToUnit = rad(360 + atan2(Y - PY, X - PX))
            end
            tinsert(ConeTable, AngleToUnit)
        end
	end
    local Facing, BestAngle, MostHit, Units = 0, 0, 0, 0
    local AngleToUnit, AngleDifference, ShortestAngle, FinalAngle
	while Facing <= 6.2 do
		Units = 0
		for i = 1, #ConeTable do
			AngleToUnit = ConeTable[i]
			AngleDifference = Facing > AngleToUnit and Facing - AngleToUnit or AngleToUnit - Facing
			ShortestAngle = AngleDifference < math.pi and AngleDifference or math.pi * 2 - AngleDifference
			FinalAngle = ShortestAngle * 180 / math.pi
			if FinalAngle < Angle / 2 then
				Units = Units + 1
			end
		end
		if Units > MostHit then
			MostHit = Units
			BestAngle = Facing
		end
		Facing = Facing + 0.05
	end
    if MostHit >= MinHit then
        local CurrentFacing = ObjectFacing("player")
		local mouselookActive = false
		if IsMouselooking() then
			mouselookActive = true
			MouselookStop()
			TurnOrActionStop()
			MoveAndSteerStop()
		end
		FaceDirection(BestAngle, true)
		CastSpellByName(self.SpellName)
		FaceDirection(CurrentFacing)
		if mouselookActive then
			MouselookStart()
		end
		C_Timer.After(0.1, function()
			FaceDirection(ObjectFacing("player"), true)
        end)
		return true
	end
	return false
end

function Spell:CastBestConeFriend(Length, Angle, MinHit, HP)
	if not self:IsReady() then
		return false
    end
    MinHit = MinHit or 1
    HP = HP or 100
    local Table, TableCount = DMW.Player:GetEnemies("player", Length)
    if TableCount < MinHit then
        return false
    end
	local PX, PY, PZ = DMW.Player.PosX, DMW.Player.PosY, DMW.Player.PosZ
    local ConeTable = {}
    local X, Y, Z, AngleToUnit
    for _, Unit in pairs(Table) do
        if Unit.HP <= HP then
            X, Y, Z = Unit.PosX, Unit.PosY, Unit.PosZ
            AngleToUnit = rad(atan2(Y - PY, X - PX))
            if AngleToUnit < 0 then
                AngleToUnit = rad(360 + atan2(Y - PY, X - PX))
            end
            tinsert(ConeTable, AngleToUnit)
        end
	end
    local Facing, BestAngle, MostHit, Units = 0, 0, 0, 0
    local AngleToUnit, AngleDifference, ShortestAngle, FinalAngle
	while Facing <= 6.2 do
		Units = 0
		for i = 1, #ConeTable do
			AngleToUnit = ConeTable[i]
			AngleDifference = Facing > AngleToUnit and Facing - AngleToUnit or AngleToUnit - Facing
			ShortestAngle = AngleDifference < math.pi and AngleDifference or math.pi * 2 - AngleDifference
			FinalAngle = ShortestAngle * 180 / math.pi
			if FinalAngle < Angle / 2 then
				Units = Units + 1
			end
		end
		if Units > MostHit then
			MostHit = Units
			BestAngle = Facing
		end
		Facing = Facing + 0.05
	end
    if MostHit >= MinHit then
        local CurrentFacing = ObjectFacing("player")
		local mouselookActive = false
		if IsMouselooking() then
			mouselookActive = true
			MouselookStop()
			TurnOrActionStop()
			MoveAndSteerStop()
		end
		FaceDirection(BestAngle, true)
		CastSpellByName(self.SpellName)
		FaceDirection(CurrentFacing)
		if mouselookActive then
			MouselookStart()
		end
		C_Timer.After(0.1, function()
			FaceDirection(ObjectFacing("player"), true)
        end)
		return true
	end
	return false
end