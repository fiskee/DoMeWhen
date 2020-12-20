local Spells = DMW.Enums.Spells

Spells.PRIEST = {
    Discipline = {
        Abilities = {
            AngelicFeather = {SpellID = 121536},
            DivineStar = {SpellID = 110744},
            DesperatePrayer = {SpellID = 19236},
            Evangelism = {SpellID = 246287},
            Halo = {SpellID = 120517},
            LeapOfFaith = {SpellID = 73325},
            LuminousBarrier = {SpellID = 271466},
            Mindbender = {SpellID = 123040},
            MindControl = {SpellID = 205364},
            PainSuppression = {SpellID = 33206},
            Penance = {SpellID = 47540},
            PowerWordBarrier = {SpellID = 62618},
            PowerWordRadiance = {SpellID = 194509},
            PowerWordShield = {SpellID = 17},
            PowerWordSolace = {SpellID = 129250},
            PsychicScream = {SpellID = 8122},
            PurgeTheWicked = {SpellID = 204197},
            Purify = {SpellID = 527},
            Rapture = {SpellID = 47536},
            Schism = {SpellID = 214621},
            ShadowCovenant = {SpellID = 204065},
            Shadowfiend = {SpellID = 34433},
            ShadowMend = {SpellID = 186263},
            ShadowWordPain = {SpellID = 589},
            ShiningForce = {SpellID = 204263},
            SinsOfTheMany = {SpellID = 198076},
            Smite = {SpellID = 585}
        },
        Buffs = {
            AngelicFeather = 121557,
            Atonement = 194384,
            BodyAndSoul = 65081,
            BorrowedTime = 197763,
            OverloadedWithLight = 223166,
            Penitent = 246519,
            PowerOfTheDarkSide = 198069,
            PowerWordShield = 17,
            Rapture = 47536,
            SymbolOfHope = 64901
        },
        Debuffs = {
            PurgeTheWicked = {SpellID = 204213},
            Schism = {SpellID = 214621},
            ShadowMend = {SpellID = 187464},
            ShadowWordPain = {SpellID = 589, BaseDuration = 16},
            Smite = {SpellID = 585},
            WeakenedSoul = {SpellID = 6788}
        },
        Talents = {
            DivineStar = 19760
        }
    },
    Holy = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {}
    },
    Shadow = {
        Abilities = {
            DarkAscension = {SpellID = 280711},
            DarkVoid = {SpellID = 263346},
            MindBlast = {SpellID = 8092},
            MindFlay = {SpellID = 15407},
            MindSear = {SpellID = 48045},
            Mindbender = {SpellID = 200174},
            ShadowCrash = {SpellID = 205385},
            ShadowWordDeath = {SpellID = 32379},
            ShadowWordPain = {SpellID = 589},
            SurrenderToMadness = {SpellID = 193223},
            VampiricTouch = {SpellID = 34914},
            VoidBolt = {SpellID = 228266},
            VoidEruption = {SpellID = 228260}
        },
        Buffs = {
            HarvestedThoughts = 273321,
            Voidform = 228264
        },
        Debuffs = {
            ShadowWordPain = {SpellID = 589, BaseDuration = 16}
        },
        Talents = {
            DarkVoid = 121557,
            Mindbender = 121557,
            Misery = 121557,
            ShadowWordVoid = 121557
        }
    },
    All = {
        Abilities = {
            DispelMagic = {SpellID = 528},
            Fade = {SpellID = 586},
            Levitate = {SpellID = 1706},
            MassDispel = {SpellID = 32375},
            MindControl = {SpellID = 605},
            Resurrection = {SpellID = 2006},
            ShackleUndead = {SpellID = 9484}
        },
        Buffs = {},
        Debuffs = {}
    }
}
