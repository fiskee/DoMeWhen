local DMW = DMW
local Unit = DMW.Classes.Unit
local QuestPlateTooltip = CreateFrame("GameTooltip", "QuestPlateTooltip", nil, "GameTooltipTemplate")
local LineText, LineCache, p1, p2
QuestPlateTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

function Unit:IsQuestUnit()
    if (not self.Dead or UnitCanBeLooted(self.Pointer)) and not UnitIsTapDenied(self.Pointer) then
        LineCache = {}
        QuestPlateTooltip:SetHyperlink("unit:" .. self.GUID)
        for i = 1, QuestPlateTooltip:NumLines() do
            LineCache[i] = _G["QuestPlateTooltipTextLeft" .. i]
        end
        if LineCache then
            for i = 1, #LineCache do
                LineText = LineCache[i]:GetText()
                if LineText and not LineText:match(THREAT_TOOLTIP) then
                    p1, p2 = LineText:match("(%d+)/(%d+)")
                    if p1 and p2 and p1 ~= p2 then
                        return true
                    elseif not p1 then
                        p1 = LineText:match("(%d+%%)")
                        if p1 and p1 ~= "100%" then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
