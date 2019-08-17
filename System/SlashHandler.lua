local DMW = DMW

local function SplitMessage(Message)
    Message = string.upper(Message)
    local MessageTable = {}
    for Msg in string.gmatch(Message, "%S+") do
        table.insert(MessageTable, Msg)
    end
    return MessageTable
end

local function SlashHandler(Message)
    Message = SplitMessage(Message)
    if Message[1] == nil then
        DMW.UI.Show()
    end
    if Message[1] == "HUD" then
        if DMW.UI.HUD.Frame:IsShown() then
            DMW.UI.HUD.Frame:Hide()
        else
            DMW.UI.HUD.Frame:Show()
        end
    end
end

SLASH_DMW1 = "/DMW"
SlashCmdList["DMW"] = SlashHandler