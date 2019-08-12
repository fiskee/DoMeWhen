local DMW = DMW

local function Reader(self, event, ...)
    if EWT then
        DMW.Functions.AuraCache.Event(CombatLogGetCurrentEventInfo())
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", Reader)