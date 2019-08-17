local DMW = DMW
DMW.Helpers.Queue = {}
local Queue = DMW.Helpers.Queue
DMW.Tables.Bindings = {}
local QueueFrame

local function GetBindings()
    table.wipe(DMW.Tables.Bindings)
    local Type, ID, Key1, Key2
    for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
        if frame.buttonType then
            Key1, Key2 = GetBindingKey(frame.buttonType..frame:GetID())
        else
            Key1, Key2 = GetBindingKey("ACTIONBUTTON"..frame:GetID())
        end
        Type, ID = GetActionInfo(frame.action)
        if Key1 then
            DMW.Tables.Bindings[Key1] = {["Type"] = Type, ["ID"] = ID}
        end
        if Key2 then
            DMW.Tables.Bindings[Key2] = {["Type"] = Type, ["ID"] = ID}
        end

    end
end

local function SpellSuccess(self, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" and Queue.Spell then
		local sourceUnit = select(1, ...)
		local spellID = select(3, ...)
		if sourceUnit == "player" then
            if spellID == Queue.Spell.SpellID then
                --print("Queue Casted: " .. Queue.Spell.SpellName)
                Queue.Spell = false
			end
		end
	end
end

local function CheckPress(self, Key)
    if DMW.Player.Combat then
		local KeyPress = ""
		if IsLeftShiftKeyDown() then
			KeyPress = "SHIFT-"
		elseif IsLeftAltKeyDown() then
			KeyPress = "ALT-"
		elseif IsLeftControlKeyDown() then
			KeyPress = "CTRL-"
		end
        KeyPress = KeyPress .. Key
        if DMW.Tables.Bindings[KeyPress] then
            local Type, ID = DMW.Tables.Bindings[KeyPress].Type, DMW.Tables.Bindings[KeyPress].ID
            if Type == "spell" then
                local Spell = DMW.Helpers.Rotation.GetSpellByID(ID)
                if Spell and Spell.BaseGCD > 0 then
                    --print("Queued: " .. Spell.SpellName)
                    Queue.Spell = Spell
                    Queue.Time = DMW.Time
                end
            end
        end
    end
end

function Queue.Run()
    if not QueueFrame then
        QueueFrame = CreateFrame("Frame")
		QueueFrame:SetPropagateKeyboardInput(true)
		QueueFrame:SetScript("OnKeyDown", CheckPress)
		QueueFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		QueueFrame:SetScript("OnEvent", SpellSuccess)
    end
    GetBindings()
    if Queue.Spell and (DMW.Time - Queue.Time) > 2 then
        Queue.Spell = false
    end
    if Queue.Spell and DMW.Player.Target then
        Queue.Spell:Cast(DMW.Player.Target)
    end
end