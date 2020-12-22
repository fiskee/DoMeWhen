local Spells = DMW.Enums.Spells

Spells.WARLOCK = {
    Affliction = {
        Abilities = {
            Agony = {SpellID = 980},
            Corruption = {SpellID = 172},
            DarkSoulMisery = {SpellID = 113860},
            Deathbolt = {SpellID = 264106},
            DrainLife = {SpellID = 234153, CastType = "Channel"},
            DrainSoul = {SpellID = 198590, CastType = "Channel"},
            GrimoireOfSacrifice = {SpellID = 108503},
            Haunt = {SpellID = 48181},
            PhantomSingularity = {SpellID = 205179, CastType = "Ground"},
            SeedOfCorruption = {SpellID = 27243},
            ShadowBolt = {SpellID = 232670},
            SiphonLife = {SpellID = 63106},
            SpellLock = {SpellID = 19647},
            SpellLockGrimoire = {SpellID = 132409},
            SummonDarkglare = {SpellID = 205180},
            UnstableAffliction = {SpellID = 30108},
            VileTaint = {SpellID = 278350, CastType = "Ground"}
        },
        Buffs = {},
        Debuffs = {
            Agony = {SpellID = 980, BaseDuration = 18},
            Corruption = {SpellID = 146739, BaseDuration = 14},
            Haunt = {SpellID = 48181, BaseDuration = 15},
            PhantomSingularity = {SpellID = 205179},
            SeedOfCorruption = {SpellID = 27243},
            ShadowEmbrace = {SpellID = 32388},
            SiphonLife = {SpellID = 63106, BaseDuration = 15},
            UnstableAffliction1 = {SpellID = 233490},
            UnstableAffliction2 = {SpellID = 233496},
            UnstableAffliction3 = {SpellID = 233497},
            UnstableAffliction4 = {SpellID = 233498},
            UnstableAffliction5 = {SpellID = 233499}
        },
        Talents = {
            AbsoluteCorruption = 21180,
            CreepingDeath = 19281,
            DarkCaller = 23139,
            DarkSoulMisery = 19293,
            DrainSoul = 23141,
            Haunt = 23159,
            InevitableDemise = 23140,
            Nightfall = 22039,
            SiphonLife = 22089,
            SowTheSeeds = 19279,
            VileTaint = 22046,
            WritheInAgony = 22044
        }
    },
    Demonology = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            BilescourgeBombers = 22048,
            DemonicCalling = 22045,
            DemonicConsumption = 22479,
            DemonicStrength = 23138,
            Doom = 23158,
            Dreadlash = 19290,
            FromTheShadows = 22477,
            GrimoireFelguard = 21717,
            InnerDemons = 23146,
            NetherPortal = 23091,
            PowerSiphon = 21694,
            SacrificedSouls = 23161,
            SoulConduit = 23147,
            SoulStrike = 22042,
            SummonVilefiend = 23160
        }
    },
    Destruction = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            Cataclysm = 23143,
            ChannelDemonfire = 23144,
            DarkSoulInstability = 23092,
            Eradication = 22090,
            FireAndBrimstone = 22043,
            Flashover = 22038,
            Inferno = 22480,
            InternalCombustion = 21695,
            RainOfChaos = 23156,
            ReverseEntropy = 23148,
            RoaringBlaze = 23155,
            Shadowburn = 23157,
            SoulFire = 22040
        }
    },
    All = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            BurningRush = 19285,
            DarkPact = 19286,
            Darkfury = 22047,
            DemonSkin = 19280,
            GrimoireOfSacrifice = 19295,
            HowlOfTerror = 23465,
            MortalCoil = 19291,
            PhantomSingularity = 19292,
            SoulConduit = 19284
        }
    }
}
