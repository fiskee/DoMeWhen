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
EHFrame:RegisterEvent("UNIT_ENTERING_VEHICLE")
EHFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
EHFrame:RegisterEvent("LOOT_OPENED")
EHFrame:RegisterEvent("LOOT_CLOSED")
EHFrame:RegisterEvent("PLAYER_LEVEL_UP")
EHFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")


local function EventHandler(self, event, ...)
    if EWT and DMW.Player.UpdateEquipment then
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
            local Unit = select(1, ...)
            if UnitIsUnit(Unit, "player") then
                if GetSpecializationInfo(GetSpecialization()) ~= DMW.Player.SpecID then
                    ReloadUI()
                else
                    DMW.Player:GetTalents()
                end
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            DMW.Player.Combat = false
        elseif event == "PLAYER_REGEN_DISABLED" then
            DMW.Player.Combat = DMW.Time
            if DMW.Player.NoControl and not IsMounted() then
                DMW.Player.NoControl = false
            end
        elseif event == "PLAYER_EQUIPMENT_CHANGED" then
            DMW.Player:UpdateEquipment()
            DMW.Player:GetTraits()
        elseif event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED" then
            DMW.Player:GetTraits()
        elseif event == "AZERITE_ESSENCE_CHANGED" then
            DMW.Player:GetEssences()
        elseif event == "UNIT_ENTERING_VEHICLE" then
            local Unit = select(1, ...)
            if UnitIsUnit(Unit, "player") then
                DMW.Player.NoControl = true
            end
        elseif event == "UNIT_EXITED_VEHICLE" then
            local Unit = select(1, ...)
            if UnitIsUnit(Unit, "player") then
                DMW.Player.NoControl = false
            end
        elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
            if not IsMounted() then
                C_Timer.After(0.2, function()
                    DMW.Player.NoControl = false
                end)
                if DMW.Player.Class == "HUNTER" then
                    DMW.Player.WaitForPet = true
                    C_Timer.After(1.5, function()
                        DMW.Player.WaitForPet = false
                    end)
                end
            else
                DMW.Player.NoControl = true
                if DMW.Player.Class == "HUNTER" then
                    DMW.Player.WaitForPet = true
                end
            end
        elseif event == "PLAYER_LEVEL_UP" then
            DMW.Player.Level = UnitLevel("player")
        elseif event == "LOOT_OPENED" then
            DMW.Player.Looting = true
        elseif event == "LOOT_CLOSED" then
            DMW.Player.Looting = false
        end
    end
end

local function KeyPress(self, Key)
    if (Key == "W" or Key == "A" or Key == "S" or Key == "D") and DMW.Helpers.Navigation ~= 0 then
        DMW.Helpers.Navigation:ClearPath()
    end
end

EHFrame:SetScript("OnEvent", EventHandler)
EHFrame:SetPropagateKeyboardInput(true)
EHFrame:SetScript("OnKeyDown", KeyPress)
