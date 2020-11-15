local Spells = DMW.Enums.Spells

Spells.PALADIN = {
    Holy = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {
            AvengingCrusader = 22190,
            Awakening = 22484,
            BeaconOfFaith = 21671,
            BeaconOfVirtue = 21203,
            BestowFaith = 17567,
            CrusadersMight = 17565,
            GlimmerOfLight = 21201,
            JudgmentOfLight = 17575,
            RuleOfLaw = 17593,
            SanctifiedWrath = 23191,
            SavedByTheLight = 22176
        },
        Traits = {}
    },
    Protection = {
        Abilities = {
            ArdentDefender = {SpellID = 31850},
            AvengersShield = {SpellID = 231665},
            BlessedHammer = {SpellID = 229976},
            CleanseToxins = {SpellID = 213644},
            Consecration = {SpellID = 344172},
            CrusaderStrike = {SpellID = 342348},
            DivineProtection = {SpellID = 498},
            GrandCrusader = {SpellID = 85043},
            GuardianOfAncientKings = {SpellID = 86659},
            HammerOfTheRighteous = {SpellID = 317854},
            Judgment = {SpellID = 315867},
            JudgmentsOfTheWise = {SpellID = 105424},
            Rebuke = {SpellID = 96231, SpellType = "Interrupt"},
            RighteousFury = {SpellID = 25780},
            Riposte = {SpellID = 161800},
            Sanctuary = {SpellID = 105805},
            ShiningLight = {SpellID = 321136},
            WordOfGlory = {SpellID = 315921},
            BlessedHammer = {SpellID = 204019},
            BlessingOfSpellwarding = {SpellID = 204018},
            MomentOfGlory = {SpellID = 327193},
        },
        Buffs = {
            ArdentDefender = 31850,
            AvengersValor = 197561,
            GuardianOfAncientKings = 86659,
            Seraphim = 152262,
            ShieldOfTheRighteous = 132403
        },
        Debuffs = {
            BlessedHammer = {SpellID = 204301},
            JudgmentOfLight = {SpellID = 196941}
        },
        Talents = {
            BlessedHammer = 23469,
            BlessingOfSpellwarding = 22435,
            ConsecratedGround = 22438,
            CrusadersJudgment = 22604,
            FinalStand = 22645,
            FirstAvenger = 22431,
            HandOfTheProtector = 22189,
            HolyShield = 22428,
            JudgmentOfLight = 23087,
            MomentOfGlory = 23468,
            Redoubt = 22558,
            RighteousProtector = 21202,
            SanctifiedWrath = 23457
        },
        Traits = {}
    },
    Retribution = {
        Abilities = {
            ArtOfWar = {SpellID = 317912},
            BladeOfJustice = {SpellID = 327981},
            CleanseToxins = {SpellID = 213644},
            Crusade = {SpellID = 231895},
            CrusaderStrike = {SpellID = 342348},
            DivineStorm = {SpellID = 53385},
            ExecutionSentence = {SpellID = 343527},
            EyeForAnEye = {SpellID = 205191},
            FinalReckoning = {SpellID = 343721},
            FiresOfJustice = {SpellID = 203316},
            HandOfHindrance = {SpellID = 183218},
            Judgment = {SpellID = 315867},
            JusticarsVengeance = {SpellID = 215661},
            Rebuke = {SpellID = 96231, SpellType = "Interrupt"},
            ShieldOfVengeance = {SpellID = 184662},
            TemplarsVerdict = {SpellID = 85256},
            WakeOfAshes = {SpellID = 255937},
        },
        Buffs = {
            AvengingWrathAutocrit = 294027,
            Crusade = 231895,
            DivinePurpose = 223817,
            EmpyreanPower = 286393,
            Inquisition = 84963
        },
        Debuffs = {
            Judgment = {SpellID = 20271}
        },
        Talents = {
            BladeOfWrath = 22592,
            Crusade = 22215,
            EmpyreanPower = 23466,
            ExecutionSentence = 23467,
            EyeForAnEye = 22183,
            FinalReckoning = 22634,
            FiresOfJustice = 22319,
            HealingHands = 23086,
            JusticarsVengeance = 22483,
            RighteousVerdict = 22557,
            SanctifiedWrath = 23456,
            SelflessHealer = 23167,
            Zeal = 22590
        },
        Traits = {}
    },
    All = {
        Abilities = {
            AvengingWrath = {SpellID = 31884},
            BlessingOfFreedom = {SpellID = 1044},
            BlessingOfProtection = {SpellID = 1022},
            BlindingLight = {SpellID = 115750},
            CrusaderStrike = {SpellID = 35395},
            DivineShield = {SpellID = 642},
            DivineSteed = {SpellID = 190784},
            FlashOfLight = {SpellID = 19750},
            HammerOfJustice = {SpellID = 853},
            HandOfReckoning = {SpellID = 62124},
            HolyAvenger = {SpellID = 105809},
            HolyPrism = {SpellID = 114165},
            Judgment = {SpellID = 275779},
            LayOnHands = {SpellID = 633},
            LightsHammer = {SpellID = 114158},
            Redemption = {SpellID = 7328},
            Repentance = {SpellID = 20066},
            Seraphim = {SpellID = 152262},
        },
        Buffs = {
            AvengingWrath = 31884,
            BlessingOfProtection = 1022,
            DivineShield = 642,
            DivineSteed = 190784
        },
        Debuffs = {
            Forbearance = {SpellID = 25771}
        },
        Talents = {
            BlindingLight = 21811,
            Cavalier = 22434,
            DivinePurpose = 17597,
            FistOfJustice = 22179,
            HolyAvenger = 17599,
            HolyPrism = 17577,
            LightsHammer = 17569,
            Repentance = 22180,
            Seraphim = 17601,
            UnbreakableSpirit = 22433
        }
    }
}
