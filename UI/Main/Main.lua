local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI then
    print("UI Creation - Something Went Wrong")
    return
end
local UI = DMW.UI
UI.Active = false
UI.Status = {}

function UI.Show()
    if UI.Active then
        return
    end
    UI.Active = true
    local Frame = AceGUI:Create("Frame")
    Frame:SetTitle("Test")
    Frame:SetStatusText("...")
    Frame:SetCallback(
        "OnClose",
        function(widget)
            AceGUI:Release(widget)
            UI.Active = false
        end
    )
    Frame:SetStatusTable(DMW.UI.Status)
end
