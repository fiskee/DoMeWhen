local Spells = DMW.Enums.Spells

Spells.PALADIN = {
    Holy = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {},
        Traits = {}
    },
    Protection = {
        Abilities = {
            ArdentDefender = {SpellID = 31850},
            AvengersShield = {SpellID = 31935},
            BlessingOfSacrifice = {SpellID = 6940},
            CleanseToxins = {SpellID = 213644},
            Consecration = {SpellID = 26573},
            DivineProtection = {SpellID = 498},
            GuardianOfAncientKings = {SpellID = 86659},
            HammerOfTheRighteous = {SpellID = 53595},
            HandOfTheProtector = {SpellID = 213652},
            Judgment = {SpellID = 275779},
            LightOfTheProtector = {SpellID = 184092},
            Rebuke = {SpellID = 96231},
            RighteousFury = {SpellID = 25780},
            Seraphim = {SpellID = 152262},
            ShieldOfTheRighteous = {SpellID = 53600}
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
            AegisOfLight = 23087,
            BastionOfLIght = 22594,
            BlessedHammer = 22430,
            BlessingOfSpellwarding = 22435,
            CrusadersJudgment = 22604,
            HandOfTheProtector = 17601,
            Seraphim = 22645
        },
        Traits = {}
    },
    Retribution = {
        Abilities = {},
        Buffs = {},
        Debuffs = {},
        Talents = {},
        Traits = {}
    },
    All = {
        Abilities = {
            AvengingWrath = {SpellID = 31884},
            BlessingOfFreedom = {SpellID = 1044},
            BlessingOfProtection = {SpellID = 1022},
            CrusaderStrike = {SpellID = 35395},
            DivineShield = {SpellID = 642},
            DivineSteed = {SpellID = 190784},
            FlashOfLight = {SpellID = 19750},
            HammerOfJustice = {SpellID = 853},
            HandOfReckoning = {SpellID = 62124},
            LayOnHands = {SpellID = 633},
            Redemption = {SpellID = 7328}
        },
        Buffs = {
            AvengingWrath = 31884,
            DivineShield = 642,
            DivineSteed = 190784,
            BlessingOfProtection = 1022
        },
        Debuffs = {
            Forbearance = {SpellID = 25771}
        }
    }
}
