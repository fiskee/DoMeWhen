local DMW = DMW
local EHFrame = CreateFrame("Frame")
EHFrame:RegisterEvent("ENCOUNTER_START")
EHFrame:RegisterEvent("ENCOUNTER_END")
EHFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
EHFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
EHFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
EHFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
EHFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
EHFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
EHFrame:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
EHFrame:RegisterEvent("AZERITE_ESSENCE_CHANGED")
local function EventHandler(self, event, ...)
    if EWT then
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
                        PosZ = DMW.Player.PosZ
                    }
                else
                    DMW.Player.Consecration = false
                end
            end
        elseif event == "ACTIONBAR_SLOT_CHANGED" then
            DMW.Helpers.Queue.GetBindings()
        elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
            DMW.Player:GetTalents()
        elseif event == "PLAYER_REGEN_ENABLED" then
            DMW.Player.Combat = false
        elseif event == "PLAYER_REGEN_DISABLED" then
            DMW.Player.Combat = DMW.Time
        elseif event == "PLAYER_EQUIPMENT_CHANGED" then
            DMW.Player:UpdateEquipment()
            DMW.Player:GetTraits()
        elseif event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED" then
            DMW.Player:GetTraits()
        elseif event == "AZERITE_ESSENCE_CHANGED" then
            DMW.Player:GetEssences()
        end
    end
end

EHFrame:SetScript("OnEvent", EventHandler)
