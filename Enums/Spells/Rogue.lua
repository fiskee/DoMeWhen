local Spells = DMW.Enums.Spells

Spells.ROGUE = {
    Assassination = {
        Abilities = {
            CrimsonTempest = {SpellID = 121411},
            CripplingPoison = {SpellID = 3408},
            DeadlyPoison = {SpellID = 2823},
            Envenom = {SpellID = 32645},
            Evasion = {SpellID = 5277},
            Eviscerate = {SpellID = 196819},
            Exsanguinate = {SpellID = 200806},
            FanOfKnives = {SpellID = 51723},
            Garrote = {SpellID = 703},
            KidneyShot = {SpellID = 408},
            Mutilate = {SpellID = 1329},
            PoisonedKnife = {SpellID = 185565},
            Rupture = {SpellID = 1943},
            ToxicBlade = {SpellID = 245388},
            Vendetta = {SpellID = 79140},
            WoundPoison = {SpellID = 8679}
        },
        Buffs = {
            CripplingPoison = 3408,
            DeadlyPoison = 2823,
            ElaboratePlanning = 193641,
            Envenom = 32645,
            HiddenBlades = 270070,
            MasterAssassin = 256735,
            Subterfuge = 115192,
            WoundPoison = 8679
        },
        Debuffs = {
            CrimsonTempest = {SpellID = 121411},
            CripplingPoison = {SpellID = 3409},
            DeadlyPoison = {SpellID = 2818},
            Garrote = {SpellID = 703, BaseDuration = 18},
            KidneyShot = {SpellID = 408},
            Rupture = {SpellID = 1943},
            ToxicBlade = {SpellID = 245389},
            Vendetta = {SpellID = 79140},
            WoundPoison = {SpellID = 8680}
        },
        Talents = {
            Alacrity = 23015,
            Blindside = 22339,
            CrimsonTempest = 23174,
            Exsanguinate = 22344,
            HiddenBlades = 22133,
            InternalBleeding = 19245,
            IronWire = 23037,
            LeechingPoison = 22340,
            MasterAssassin = 23022,
            MasterPoisoner = 22337,
            PoisonBomb = 21186,
            VenomRush = 22343
        }
    },
    Outlaw = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            AcrobaticStrikes = 23470,
            Alacrity = 23128,
            BladeRush = 23075,
            BlindingPowder = 22114,
            DancingSteel = 22125,
            DirtyTricks = 23077,
            Dreadblades = 19250,
            GhostlyStrike = 22120,
            HitAndRun = 19238,
            IronStomach = 22121,
            KillingSpree = 23175,
            LoadedDice = 21990,
            QuickDraw = 22119,
            RetractableHook = 19237,
            Weaponmaster = 22118
        }
    },
    Subtlety = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            Alacrity = 19249,
            DarkShadow = 22335,
            EnvelopingShadows = 22336,
            Gloomblade = 19235,
            MasterOfShadows = 22132,
            NightTerrors = 23036,
            Premeditation = 19234,
            SecretTechnique = 23183,
            ShadowFocus = 22333,
            ShotInTheDark = 23078,
            ShurikenTornado = 21188,
            SoothingDarkness = 22128,
            Weaponmaster = 19233
        }
    },
    All = {
        Abilities = {
            Blind = {SpellID = 2094},
            CheapShot = {SpellID = 1833},
            CloakOfShadows = {SpellID = 31224},
            CrimsonVial = {SpellID = 185311},
            Distract = {SpellID = 219677, CastType = "Ground"},
            Feint = {SpellID = 1966},
            Kick = {SpellID = 1766, SpellType = "Interrupt"},
            MarkedForDeath = {SpellID = 137619},
            Sap = {SpellID = 6770},
            Stealth = {SpellID = 115191},
            TricksOfTheTrade = {SpellID = 57934},
            Vanish = {SpellID = 1856}
        },
        Buffs = {
            Stealth = 115191,
            Vanish = 11327
        },
        Debuffs = {},
        Talents = {
            CheatDeath = 22122,
            DeeperStratagem = 19240,
            ElaboratePlanning = 22338,
            Elusiveness = 22123,
            MarkedForDeath = 19241,
            Nightstalker = 22331,
            PreyOnTheWeak = 22115,
            Subterfuge = 22332,
            Vigor = 19239
        }
    }
}
