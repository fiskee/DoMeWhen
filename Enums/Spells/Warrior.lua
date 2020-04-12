local Spells = DMW.Enums.Spells

Spells.WARRIOR = {
    Arms = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {},
        Traits = {}
    },
    Fury = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {},
        Traits = {}
    },
    Protection = {
        Abilities = {
            Avatar = {SpellID = 107574},
            DemoralizingShout = {SpellID = 1160},
            Devastate = {SpellID = 20243},
            IgnorePain = {SpellID = 258024},
            Intercept = {SpellID = 198304},
            LastStand = {SpellID = 12975},
            Revenge = {SpellID = 6572},
            ShieldBlock = {SpellID = 132404},
            ShieldSlam = {SpellID = 231834},
            ShieldWall = {SpellID = 871},
            Shockwave = {SpellID = 46968},
            SpellReflection = {SpellID = 23920},
            ThunderClap = {SpellID = 6343}
        },
        Buffs = {
            LastStand = 12975,
            ShieldBlock = 132404,
            ShieldWall = 871,
            SpellReflection = 23920
        },
        Debuffs = {
            DemoralizingShout = 1160
        },
        Talents = {},
        Traits = {}
    },
    All = {
        Abilities = {
            BattleShout = {SpellID = 6673},
            BerserkerRage = {SpellID = 18499},
            Charge = {SpellID = 100},
            HeroicLeap = {SpellID = 6544, CastType = "Ground"},
            HeroicThrow = {SpellID = 57755},
            IntimidatingShout = {SpellID = 5246},
            Pummel = {SpellID = 6552, SpellType = "Interrupt"},
            RallyingCry = {SpellID = 97462},
            Recklessness = {SpellID = 1719},
            Taunt = {SpellID = 355},
            VictoryRush = {SpellID = 34428}
        },
        Buffs = {
            BattleShout = 6673,
            RallyingCry = 97462,
            Recklessness = 1719
        },
        Debuffs = {}
    }
}
