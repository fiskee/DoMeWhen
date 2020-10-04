local DMW = DMW
DMW.Helpers.Gatherers = {}
local Looting = false
local Skinning = false
local NextFishCast = false

function DMW.Helpers.Gatherers.Run()
    if DMW.Player:Standing() and not DMW.Player.Casting and not UnitIsDeadOrGhost("player") then
        if Looting and (DMW.Time - Looting) > 0 and not DMW.Player.Looting then
            Looting = false
        end
        if DMW.Settings.profile.Gatherers.AutoLoot and not IsMounted() then
            if not Looting and not DMW.Player.Combat then
                for _, Unit in pairs(DMW.Units) do
                    if Unit.Dead and Unit.Distance < 1.5 and UnitCanBeLooted(Unit.Pointer) then
                        InteractUnit(Unit.Pointer)
                        Looting = DMW.Time + 0.6
                    end
                end
            end
        end
        if DMW.Settings.profile.Gatherers.AutoSkinning and not IsMounted() then
            if Skinning and (DMW.Time - Skinning) > 2.3 then
                Skinning = false
            end
            if not Skinning and not DMW.Player.Combat and not DMW.Player.Moving and not DMW.Player.Casting then
                for _, Unit in pairs(DMW.Units) do
                    if Unit.Dead and Unit.Distance < 1.5 and UnitCanBeSkinned(Unit.Pointer) then
                        InteractUnit(Unit.Pointer)
                        Skinning = DMW.Time
                    end
                end
            end
        end
        if DMW.Settings.profile.Gatherers.AutoGather then
            if not Looting and not DMW.Player.Combat and not DMW.Player.Moving then
                for _, Object in pairs(DMW.GameObjects) do
                    if Object.Distance < 5 then
                        if Object.Herb and (not DMW.Player.Spells.HerbGathering:LastCast() or (DMW.Player.LastCast[1].SuccessTime and (DMW.Time - DMW.Player.LastCast[1].SuccessTime) > 2)) then
                            ObjectInteract(Object.Pointer)
                            Looting = DMW.Time + 0.3
                        elseif Object.Ore and (not DMW.Player.Spells.Mining:LastCast() or (DMW.Player.LastCast[1].SuccessTime and (DMW.Time - DMW.Player.LastCast[1].SuccessTime) > 2)) then
                            ObjectInteract(Object.Pointer)
                            Looting = DMW.Time + 0.3
                        elseif Object.Trackable then
                            ObjectInteract(Object.Pointer)
                            Looting = DMW.Time + 0.6
                        end
                    end
                end
            end
        end
        if DMW.Settings.profile.Gatherers.AutoFishing and not Looting then
            if not DMW.Player.Casting and not DMW.Player.Looting then
                if not NextFishCast then
                    NextFishCast = DMW.Time + (math.random(1300, 2900) / 1000)
                elseif DMW.Time > NextFishCast and DMW.Player.Spells.Fishing:Cast(DMW.Player) then
                    Looting = DMW.Time + 0.3
                    NextFishCast = false
                end
            end
        end
    end
end
