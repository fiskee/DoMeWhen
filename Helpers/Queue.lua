local DMW = DMW
DMW.Helpers.Queue = {}
local Queue = DMW.Helpers.Queue
DMW.Tables.Bindings = {}

function Queue.GetBindings()
    local Type, ID, Key1, Key2
    for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
        if frame.buttonType then
            Key1, Key2 = GetBindingKey(frame.buttonType..frame:GetID())
            Type, ID = GetActionInfo(frame.action)
            if Key1 then
                DMW.Tables.Bindings[Key1] = {["Type"] = Type, ["ID"] = ID}
            end
            if Key2 then
                DMW.Tables.Bindings[Key2] = {["Type"] = Type, ["ID"] = ID}
            end
        end
    end
end
