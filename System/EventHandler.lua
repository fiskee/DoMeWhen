local DMW = DMW
local EHFrame = CreateFrame("Frame")
EHFrame:RegisterEvent("ENCOUNTER_START")
EHFrame:RegisterEvent("ENCOUNTER_END")

local function EventHandler(self, event, ...)
    if event == "ENCOUNTER_START" then
        DMW.Player.EID = select(1, ...)
    elseif event == "ENCOUNTER_END" then
        DMW.Player.EID = false
    end
end

EHFrame:SetScript("OnEvent", EventHandler)