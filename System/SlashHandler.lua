local DMW = DMW

DMW:RegisterChatCommand("dmw", "ChatCommand")

local function SplitInput(Input)
    local Table = {}
	for i in string.gmatch(Input, "%S+") do
        table.insert(Table, i)
    end
    return table
end

function DMW:ChatCommand(Input)
    if not Input or Input:trim() == "" then
        DMW.UI.Show()
    else
        local Commands = SplitInput(Input)
        if Commands[1] == "HUD" then
            
        else
            LibStub("AceConfigCmd-3.0").HandleCommand(DMW, "dmw", "DMW", Input)
        end
    end
end
