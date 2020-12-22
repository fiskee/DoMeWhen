local Spells = DMW.Enums.Spells

Spells.WARRIOR = {
    Arms = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            AngerManagement = 21204,
            Avatar = 22397,
            Cleave = 22362,
            CollateralDamage = 22392,
            DeadlyCalm = 22399,
            DefensiveStance = 22628,
            Dreadnaught = 22407,
            FervorOfBattle = 22489,
            ImpendingVictory = 22372,
            InForTheKill = 22394,
            Massacre = 22380,
            Ravager = 21667,
            Rend = 19138,
            SecondWind = 15757,
            Skullsplitter = 22371,
            StormBolt = 22789,
            SuddenDeath = 22360,
            WarMachine = 22624,
            Warbreaker = 22391
        }
    },
    Fury = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            AngerManagement = 22405,
            Bladestorm = 22400,
            Cruelty = 19140,
            DragonRoar = 22398,
            Frenzy = 22381,
            FreshMeat = 22491,
            FrothingBerserker = 22393,
            FuriousCharge = 23097,
            ImpendingVictory = 22625,
            Massacre = 22379,
            MeatCleaver = 22396,
            Onslaught = 23372,
            RecklessAbandon = 22402,
            Seethe = 22383,
            Siegebreaker = 16037,
            StormBolt = 23093,
            SuddenDeath = 22633,
            WarMachine = 22632,
            Warpaint = 22382
        }
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
            IgnorePain = 190456,
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
            AngerManagement = 23455,
            BestServedCold = 22378,
            Bolster = 23099,
            BoomingVoice = 22626,
            CracklingThunder = 23096,
            Devastator = 15774,
            DragonRoar = 23260,
            HeavyRepercussions = 22406,
            ImpendingVictory = 22800,
            Indomitable = 22631,
            IntoTheFray = 22395,
            Menace = 22488,
            NeverSurrender = 22384,
            Punish = 15759,
            Ravager = 22401,
            RumblingEarth = 22629,
            StormBolt = 22409,
            UnstoppableForce = 22544,
            WarMachine = 15760
        }
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
        Debuffs = {},
        Talents = {
            BoundingStride = 22627,
            DoubleTime = 19676
        }
    }
}
