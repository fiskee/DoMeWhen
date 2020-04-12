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
            DragonRoar = {SpellID = 118000},
            IgnorePain = {SpellID = 190456},
            Intercept = {SpellID = 198304},
            LastStand = {SpellID = 12975},
            Ravager = {SpellID = 228920, CastType = "Ground"},
            Revenge = {SpellID = 6572},
            ShieldBlock = {SpellID = 132404},
            ShieldSlam = {SpellID = 23922},
            ShieldWall = {SpellID = 871},
            Shockwave = {SpellID = 46968},
            SpellReflection = {SpellID = 23920},
            ThunderClap = {SpellID = 6343}
        },
        Buffs = {
            Avatar = 107574,
            LastStand = 12975,
            ShieldBlock = 132404,
            ShieldWall = 871,
            SpellReflection = 23920
        },
        Debuffs = {
            DemoralizingShout = {SpellID = 1160},
            DragonRoar = {SpellID = 118000}
        },
        Talents = {
            IntoTheFray = 15760,
            Punish = 15759,
            ImpendingVictory = 15774,
            CracklingThunder = 22373,
            BoundingStride = 22629,
            Safeguard = 22409,
            BestServedCold = 22378,
            UnstoppableForce = 22626,
            DragonRoar = 23260,
            Indomitable = 23096,
            NeverSurrender = 23261,
            Bolster = 22488,
            Menace = 22384,
            RumblingEarth = 22631,
            StormBolt = 22800,
            BoomingVoice = 22395,
            Vengeance = 22544,
            Devastator = 22401,
            AngerManagement = 21204,
            HeavyRepercussions = 22406,
            Ravager = 23099
        },
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
            StormBolt = {SpellID = 107570, SpellType = "Stun"},
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
