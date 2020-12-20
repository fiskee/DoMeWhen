local DMW = DMW
local Druid = DMW.Rotations.DRUID
local Player, Buff, Debuff, Spell, Target, GCD, HUD, Player40Y, Player40YC, Eclipse
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation

local function CreateSettings()
    if not UI.HUD.Options then
        UI.AddTab("General")
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
end

local IsInside = IsIndoors()
local OutsideTimer = GetTime()
local function IsIndoorsUpdate()
    if not IsInside and IsIndoors() then
        IsInside = true
        OutsideTimer = false
    elseif IsInside and not IsIndoors() then
        if not OutsideTimer then
            OutsideTimer = DMW.Time + 1.5
        elseif OutsideTimer < DMW.Time then
            IsInside = false
        end
    end
end

local function Fallthru()
    -- fallthru->add_action( "starsurge,if=!runeforge.balance_of_all_things.equipped" );

    -- fallthru->add_action( "sunfire,target_if=dot.moonfire.remains>remains" );
    if Debuff.Moonfire:Remain(Target) > Debuff.Sunfire:Remain(Target) and Spell.Sunfire:Cast(Target) then
        return true
    end
    -- fallthru->add_action( "moonfire" );
    if Spell.Moonfire:Cast(Target) then
        return true
    end
end

local function EclipseUpdate()
    if not Eclipse then
        Eclipse = {}
    end
    Eclipse.InLunar = Buff.EclipseLunar:Exist()
    Eclipse.InSolar = Buff.EclipseSolar:Exist()
    Eclipse.InAny = Eclipse.InLunar or Eclipse.InSolar
    Eclipse.SolarNext = Spell.Wrath:Count() == 0 and Spell.Starfire:Count() > 0
    Eclipse.LunarNext = Spell.Wrath:Count() > 0 and Spell.Starfire:Count() == 0
    Eclipse.AnyNext = not (Eclipse.SolarNext or Eclipse.LunarNext)

    if DMW.Player.Casting and ((DMW.Player.Casting == Spell.Starfire.SpellName and Eclipse.InSolar) or (DMW.Player.Casting == Spell.Wrath.SpellName and Eclipse.InLunar)) then
        SpellStopCasting()
        return true
    end
end

local function SingleTarget()
    -- prepatch_st->add_action( "moonfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check" );
    if Target.TTD > 12 and Debuff.Moonfire:Refresh(Target) and Spell.Moonfire:Cast(Target) then
        return true
    end
    -- prepatch_st->add_action( "sunfire,target_if=refreshable&target.time_to_die>12,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check" );
    if Target.TTD > 12 and Debuff.Sunfire:Refresh(Target) and Spell.Sunfire:Cast(Target) then
        return true
    end
    -- prepatch_st->add_action( "stellar_flare,target_if=refreshable&target.time_to_die>16,if=(buff.ca_inc.remains>5|!buff.ca_inc.up|astral_power<30)&ap_check" );

    -- prepatch_st->add_action( "force_of_nature,if=ap_check" );

    -- prepatch_st->add_action( "celestial_alignment,if=(astral_power>90|buff.bloodlust.up&buff.bloodlust.remains<26)&!buff.ca_inc.up" );

    -- prepatch_st->add_action( "incarnation,if=(astral_power>90|buff.bloodlust.up&buff.bloodlust.remains<36)&!buff.ca_inc.up" );

    -- prepatch_st->add_action( "variable,name=save_for_ca_inc,value=!cooldown.ca_inc.ready" );

    -- prepatch_st->add_action( "fury_of_elune,if=eclipse.in_any&ap_check&variable.save_for_ca_inc" );

    -- prepatch_st->add_action( "cancel_buff,name=starlord,if=buff.starlord.remains<6&(buff.eclipse_solar.up|buff.eclipse_lunar.up)&astral_power>90" );

    -- prepatch_st->add_action( "starsurge,if=(!azerite.streaking_stars.rank|buff.ca_inc.remains<execute_time|!variable.prev_starsurge)&(buff.ca_inc.up|astral_power>90&eclipse.in_any)" );
    if Eclipse.InAny and Spell.Starsurge:Cast(Target) then
        return true
    end
    -- prepatch_st->add_action( "starsurge,if=(!azerite.streaking_stars.rank|buff.ca_inc.remains<execute_time|!variable.prev_starsurge)&talent.starlord.enabled&(buff.starlord.up|astral_power>90)&buff.starlord.stack<3&(buff.eclipse_solar.up|buff.eclipse_lunar.up)&cooldown.ca_inc.remains>7" );

    -- prepatch_st->add_action( "starsurge,if=(!azerite.streaking_stars.rank|buff.ca_inc.remains<execute_time|!variable.prev_starsurge)&buff.eclipse_solar.remains>7&eclipse.in_solar&!talent.starlord.enabled&cooldown.ca_inc.remains>7" );

    -- prepatch_st->add_action( "new_moon,if=(buff.eclipse_lunar.up|(charges=2&recharge_time<5)|charges=3)&ap_check&variable.save_for_ca_inc" );

    -- prepatch_st->add_action( "half_moon,if=(buff.eclipse_lunar.up|(charges=2&recharge_time<5)|charges=3|buff.ca_inc.up)&ap_check&variable.save_for_ca_inc" );

    -- prepatch_st->add_action( "full_moon,if=(buff.eclipse_lunar.up|(charges=2&recharge_time<5)|charges=3|buff.ca_inc.up)&ap_check&variable.save_for_ca_inc" );

    -- prepatch_st->add_action( "warrior_of_elune" );

    -- prepatch_st->add_action( "starfire,if=(eclipse.in_lunar|eclipse.solar_next|eclipse.any_next|buff.warrior_of_elune.up&buff.eclipse_lunar.up|(buff.ca_inc.remains<action.wrath.execute_time&buff.ca_inc.up))|(azerite.dawning_sun.rank>2&buff.eclipse_solar.remains>5&!buff.dawning_sun.remains>action.wrath.execute_time)" );
    if not Player.Moving and not Eclipse.InSolar and (Eclipse.InLunar or Eclipse.SolarNext or Eclipse.AnyNext) and Spell.Starfire:Cast(Target) then
        return true
    end
    -- prepatch_st->add_action( "wrath" );
    if not Player.Moving and Spell.Wrath:Cast(Target) then
        return true
    end
    -- prepatch_st->add_action( "run_action_list,name=fallthru" );
    Fallthru()
end

function Druid.Balance()
    Locals()
    CreateSettings()
    IsIndoorsUpdate()
    if EclipseUpdate() then
        return true
    end
    if Rotation.Active() then
        Player:AutoTarget(40)
        if Target and Target.ValidEnemy and (not Player.Moving or not Buff.TravelForm:Exist()) then
            if not Buff.MoonkinForm:Exist() and Spell.MoonkinForm:Cast(Player) then
                return true
            end
            
            SingleTarget()
        end
        if not Player.Combat and Player.MovingTime > 1.5 then
            if not IsInside then
                if not Buff.TravelForm:Exist() and Spell.TravelForm:Cast(Player) then
                    return true
                end
            elseif not Buff.CatForm:Exist() and Spell.CatForm:Cast(Player) then
                return true
            end
        end 
    end
end
