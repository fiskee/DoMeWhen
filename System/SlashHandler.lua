local DMW = DMW

DMW:RegisterChatCommand("dmw", "ChatCommand")

function DMW:ChatCommand(input)
    if not input or input:trim() == "" then
        DMW.UI.Show()
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(DMW, "dmw", "DMW", input)
    end
end
