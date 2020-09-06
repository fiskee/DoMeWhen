local DMW = DMW
local Priest = DMW.Rotations.PRIEST
local Player, Buff, Debuff, Spell, Target, Trait, Talent, Item, GCD, CDs, HUD, Player40Y, Player40YC, Friends40Y, Friends40YC
local UI = DMW.UI
local Rotation = DMW.Helpers.Rotation
local Setting = DMW.Helpers.Rotation.Setting

local function CreateSettings()
    if not UI.HUD.Options then
        UI.HUD.Options = {
            [1] = {
                Dispel = {
                    [1] = {Text = "Dispel |cFF00FF00Enabled", Tooltip = ""},
                    [2] = {Text = "Dispel |cffff0000Disabled", Tooltip = ""}
                }
            }
        }

        UI.AddTab("DPS")
        UI.AddToggle("Shadow Word: Pain", nil, true)
        UI.AddRange("Shadow Word: Pain Units", "Max active Shadow Word: Pain dots active", 0, 10, 1, 3)
        UI.AddTab("Defensive")
        UI.AddToggle("Healthstone", nil, true)
        UI.AddRange("Healthstone HP", nil, 0, 100, 1, 40)
    end
end

local function Locals()
    Player = DMW.Player
    Buff = Player.Buffs
    Debuff = Player.Debuffs
    Spell = Player.Spells
    Talent = Player.Talents
    Trait = Player.Traits
    Item = Player.Items
    Target = Player.Target or false
    GCD = Player:GCD()
    HUD = DMW.Settings.profile.HUD
    CDs = Player:CDs() and Target and Target.TTD > 5 and Target.Distance < 5
    Friends40Y, Friends40YC = Player:GetFriends(40)
    Player40Y, Player40YC = Player:GetEnemies(40)
end

local function CDs()
    -- # Use Memory of Lucid Dreams right before you are about to fall out of Voidform
    -- actions.cds=memory_of_lucid_dreams,if=(buff.voidform.stack>20&insanity<=50)|(current_insanity_drain*((gcd.max*2)+action.mind_blast.cast_time))>insanity
    -- actions.cds+=/blood_of_the_enemy
    -- actions.cds+=/guardian_of_azeroth,if=buff.voidform.stack>15
    -- actions.cds+=/use_item,name=manifesto_of_madness,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
    -- actions.cds+=/focused_azerite_beam,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
    -- actions.cds+=/purifying_blast,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
    -- # Wait at least 6s between casting CF. Use the first cast ASAP to get it on CD, then every subsequent cast should be used when Chorus of Insanity is active or it will recharge in the next gcd, or the target is about to die.
    -- actions.cds+=/concentrated_flame,line_cd=6,if=time<=10|(buff.chorus_of_insanity.stack>=15&buff.voidform.up)|full_recharge_time<gcd|target.time_to_die<5
    -- actions.cds+=/ripple_in_space
    -- actions.cds+=/reaping_flames
    -- actions.cds+=/worldvein_resonance
    -- # Use these cooldowns in between your 1st and 2nd Void Bolt in your 2nd Voidform when you have Chorus of Insanity active
    -- actions.cds+=/call_action_list,name=crit_cds,if=(buff.voidform.up&buff.chorus_of_insanity.stack>20)|azerite.chorus_of_insanity.rank=0
    -- # Default fallback for usable items: Use on cooldown.
    -- actions.cds+=/use_items
end

local function Cleave()
    -- actions.cleave=void_eruption
    -- actions.cleave+=/dark_ascension,if=buff.voidform.down
    -- actions.cleave+=/vampiric_touch,if=!ticking&azerite.thought_harvester.rank>=1
    -- actions.cleave+=/mind_sear,if=buff.harvested_thoughts.up
    -- actions.cleave+=/void_bolt
    -- actions.cleave+=/call_action_list,name=cds
    -- actions.cleave+=/shadow_word_death,target_if=target.time_to_die<3|buff.voidform.down
    -- actions.cleave+=/surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
    -- # Use Dark Void on CD unless adds are incoming in 10s or less.
    -- actions.cleave+=/dark_void,if=raid_event.adds.in>10&(dot.shadow_word_pain.refreshable|target.time_to_die>30)
    -- actions.cleave+=/mindbender
    -- actions.cleave+=/mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
    -- actions.cleave+=/shadow_crash,if=(raid_event.adds.in>5&raid_event.adds.duration<2)|raid_event.adds.duration>2
    -- actions.cleave+=/shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
    -- actions.cleave+=/vampiric_touch,target_if=refreshable,if=target.time_to_die>((1+3.3*spell_targets.mind_sear)*variable.vt_trait_ranks_check*(1+0.10*azerite.searing_dialogue.rank*spell_targets.mind_sear))
    -- actions.cleave+=/vampiric_touch,target_if=dot.shadow_word_pain.refreshable,if=(talent.misery.enabled&target.time_to_die>((1.0+2.0*spell_targets.mind_sear)*variable.vt_mis_trait_ranks_check*(variable.vt_mis_sd_check*spell_targets.mind_sear)))
    -- actions.cleave+=/void_torrent,if=buff.voidform.up
    -- actions.cleave+=/mind_sear,target_if=spell_targets.mind_sear>1,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
    -- actions.cleave+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
    -- actions.cleave+=/shadow_word_pain
end

local function Single()
    -- actions.single=void_eruption
    -- actions.single+=/dark_ascension,if=buff.voidform.down
    -- actions.single+=/void_bolt
    -- actions.single+=/call_action_list,name=cds
    -- # Use Mind Sear on ST only if you get a Thought Harvester Proc with at least 1 Searing Dialogue Trait.
    -- actions.single+=/mind_sear,if=buff.harvested_thoughts.up&cooldown.void_bolt.remains>=1.5&azerite.searing_dialogue.rank>=1
    -- # Use SWD before capping charges, or the target is about to die.
    -- actions.single+=/shadow_word_death,if=target.time_to_die<3|cooldown.shadow_word_death.charges=2|(cooldown.shadow_word_death.charges=1&cooldown.shadow_word_death.remains<gcd.max)
    -- actions.single+=/surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
    -- # Use Dark Void on CD unless adds are incoming in 10s or less.
    -- actions.single+=/dark_void,if=raid_event.adds.in>10
    -- # Use Mindbender at 19 or more stacks, or if the target will die in less than 15s.
    -- actions.single+=/mindbender,if=talent.mindbender.enabled|(buff.voidform.stack>18|target.time_to_die<15)
    -- actions.single+=/shadow_word_death,if=!buff.voidform.up|(cooldown.shadow_word_death.charges=2&buff.voidform.stack<15)
    -- # Use Shadow Crash on CD unless there are adds incoming.
    -- actions.single+=/shadow_crash,if=raid_event.adds.in>5&raid_event.adds.duration<20
    -- # Bank the Shadow Word: Void charges for a bit to try and avoid overcapping on Insanity.
    -- actions.single+=/mind_blast,if=variable.dots_up&((raid_event.movement.in>cast_time+0.5&raid_event.movement.in<4)|!talent.shadow_word_void.enabled|buff.voidform.down|buff.voidform.stack>14&(insanity<70|charges_fractional>1.33)|buff.voidform.stack<=14&(insanity<60|charges_fractional>1.33))
    -- actions.single+=/void_torrent,if=dot.shadow_word_pain.remains>4&dot.vampiric_touch.remains>4&buff.voidform.up
    -- actions.single+=/shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
    -- actions.single+=/vampiric_touch,if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)
    -- actions.single+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
    -- actions.single+=/shadow_word_pain

    if Setting("Shadow Word: Pain") then
        local SWPCount = Debuff.ShadowWordPain:Count(Player40Y)
        if Friends40Y[1].HP > 50 and SWPCount <= Setting("Shadow Word: Pain Units") then
            for _, Unit in ipairs(Player40Y) do
                if Debuff.ShadowWordPain:Refresh(Unit) and (Unit.TTD - Debuff.ShadowWordPain:Remain(Unit)) > 4 and (SWPCount < Setting("Shadow Word: Pain Units") or Debuff.ShadowWordPain:Exist(Unit)) then
                    if Spell.ShadowWordPain:Cast(Unit) then
                        return true
                    end
                end
            end
        end
    end
    if Target and Target.ValidEnemy then
        if Setting("Shadow Word: Pain") then
            local LowestSWP, LowestSec = Debuff.ShadowWordPain:Lowest(Player40Y)
            if LowestSWP and LowestSec < 8 and Spell.ShadowWordPain:Cast(LowestSWP) then
                return true
            end
        end
    end
end

local function Defensive()
    --HS
    if Setting("Healthstone") and Player.HP <= Setting("Healthstone HP") and Item.Healthstone:Use(Player) then
        return true
    end
end

function Priest.Shadow()
    Locals()
    CreateSettings()
    if Rotation.Active() then
        if not Player.Combat then
            if Target and Target.ValidEnemy then
                if Spell.ShadowWordPain:Cast(Target) then
                    return true
                end
            end
        else
            Player:AutoTarget(40, true)
            if Defensive() then
                return true
            end
            if Spell.GCD:CD() == 0 then
                if Cleave() then
                    return true
                elseif Single() then
                    return true
                end
            end
        end
    end
end
