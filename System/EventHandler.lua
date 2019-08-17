local DMW = DMW
local EHFrame = CreateFrame("Frame")
EHFrame:RegisterEvent("ENCOUNTER_START")
EHFrame:RegisterEvent("ENCOUNTER_END")
EHFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")

local function EventHandler(self, event, ...)
    if event == "ENCOUNTER_START" then
        DMW.Player.EID = select(1, ...)
    elseif event == "ENCOUNTER_END" then
        DMW.Player.EID = false
    elseif event == "PLAYER_TOTEM_UPDATE" then
        if DMW.Player.Class == "PALADIN" then
            if GetTotemInfo(1) then
                DMW.Player.Consecration = {
                    PosX = DMW.Player.PosX,
                    PosY = DMW.Player.PosY,
                    PosZ = DMW.Player.PosZ,
                }
            else
                DMW.Player.Consecration = false
            end
        end
    end
end

EHFrame:SetScript("OnEvent", EventHandler)