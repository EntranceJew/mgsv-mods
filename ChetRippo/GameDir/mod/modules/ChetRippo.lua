--[[ questions for later:

HOW TO QUERY FOR PICKUP PROMPT (HAND GRENADES)
find closestCp:afgh_fort_cp
addFlag=16?

]]

--[[
    OVERRIDES UNTIL IH UPDATES
]]
-- https://stackoverflow.com/a/1283608
InfUtil.MergeTable = function(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                this.MergeTable(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

local this = {
    debugModule = false,
}

this.CONSTS = {
    MAX_LOCAL_GMP  =  5000000,
    MAX_GLOBAL_GMP = 25000000,
    MAX_GMP        = 30000000,

    MAX_LOCAL_PROCESSED_MATERIALS  =  500000,
    MAX_GLOBAL_PROCESSED_MATERIALS = 1000000,
    MAX_PROCESSED_MATERIALS        = 1500000,

    MAX_LOCAL_HERBS  =  6000,
    MAX_GLOBAL_HERBS = 30000,
    MAX_HERBS        = 36000,

    MATERIAL_VALUE_PROCESSED_FUEL                =  100,
    MATERIAL_VALUE_PROCESSED_BIOLOGICAL_MATERIAL =  100,
    MATERIAL_VALUE_PROCESSED_COMMON_METAL        =  100,
    MATERIAL_VALUE_PROCESSED_MINOR_METAL         =  200,
    MATERIAL_VALUE_PROCESSED_PRECIOUS_METAL      = 1000,

    MEDICINAL_PLANT_VALUE_WORMWOOD           =  500,
    MEDICINAL_PLANT_VALUE_BLACK_CARROT       = 1000,
    MEDICINAL_PLANT_VALUE_GOLDEN_CRESCENT    =  500,
    MEDICINAL_PLANT_VALUE_TARRAGON           = 1000,
    MEDICINAL_PLANT_VALUE_AFRICAN_PEACH      = 1000,
    MEDICINAL_PLANT_VALUE_DIGITALIS_PURPUREA = 1000,
    MEDICINAL_PLANT_VALUE_DIGITALIS_LUTEA    = 5000,
    MEDICINAL_PLANT_VALUE_HAOMA              = 5000,

    HYGIENE_EVENT_TOILET   = "toilet",
    HYGIENE_EVENT_SHOWER   = "shower",
    HYGIENE_EVENT_DUMPSTER = "dumpster",
}
this.ivarsPersist = {
    crBalance = 0,
    crHygieneProvisionalShowerLastUsed = 0,
}
this.wrap = {}
this.vars = {
    crDeathGmpLossValidDeath = false,

    interceptedDeployMissionBasicParams = {},
    livingDeployMissionBasicParams = {},
    interceptedDeployMissionParams = {},
    livingDeployMissionParams = {},
    interceptedResourceParam = {},
    livingResourceParam = {},

    timeMinuteMin = math.huge,
    timeMinuteMax = -math.huge,
    timeMinuteRandomMin = math.huge,
    timeMinuteRandomMax = -math.huge,
}

this.infiniteRange={min=-math.huge,max=math.huge,increment=1}
this.ultraVars = {
    {
        name = "crMenu",
        type = "menu",
        setting = {},
        description = "Chet Rippo menu",
        help = "A collection of funny little things.",
        children = {
            {name = "crSettingsMenu",
                type = "menu",
                setting = {},
                description = "Chet Rippo Settings / Config menu",
                help = "All configuration options for Chet Rippo's features.",
                children = {
                    {name = "crVanillaOverridesMenu",
                        type = "menu",
                        setting = {},
                        description = "Vanilla Overrides menu",
                        help = "A sub-menu for tweaking tables the game ships with WITHOUT overriding IH files.",
                        children = {
                            {name = "crVODeployBasicParamMenu",
                                type = "menu",
                                setting = {},
                                description = "Deploy Basic Params menu",
                                help = "These settings affect configuration settings for how all (local) deployments are handled.\nSome changes can be real-time, for the others you may need to:\n1) wait for the refresh period\n2) change levels / return to Mother Base\n3) restart the game\n4) all of the above (in order)",
                                children = {
                                    {name = "crVODeployBasicParamsEnable",
                                        type = "ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=Ivars.switchRange,
                                            default=0,
                                            settingNames="set_switch",
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "Override Deploy Basic Params Enable",
                                        help = "Do you want to tweak base deployment settings?",
                                    },
                                    {name = "crDeployBasicParamVOmissionListRefreshTimeMinute",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=12,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "missionListRefreshTimeMinute",
                                        help = "The time it takes for the deployment list to re-roll a new set of deployments.",
                                    },
                                    {name = "crDeployBasicParamVOdrawCountPerSr",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=10,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "drawCountPerSr",
                                        help = "??? This value's purpose is not yet known.\nIt its believed to affect draw attempts for staff or resources of the Super Rare grade.",
                                    },
                                    {name = "crDeployBasicParamVOdrawCountPerR",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=4,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "drawCountPerR",
                                        help = "??? This value's purpose is not yet known.\nIt its believed to affect draw attempts for staff or resources of the Rare grade.",
                                    },
                                    {name = "crDeployBasicParamVOpowerTransitVehicle",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=200,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "powerTransitVehicle",
                                        help = "The additional flat Fighting Ability granted by an unarmed transport vehicle.",
                                    },
                                    {name = "crDeployBasicParamVOpowerBattleVehicle",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=800,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "powerBattleVehicle",
                                        help = "The additional flat Fighting Ability granted by an armed vehicle.",
                                    },
                                    {name = "crDeployBasicParamVOpowerWalkerGear",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=1200,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "powerWalkerGear",
                                        help = "The additional flat Fighting Ability granted by a Walker Gear.",
                                    },
                                    {name = "crDeployBasicParamVOpowerBattleGear",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=3500,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "powerBattleGear",
                                        help = "The additional Fighting Ability granted by the Battle Gear.",
                                    },
                                    {name = "crDeployBasicParamVOminusWinRateTransitVehicle",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=5,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "minusWinRateTransitVehicle",
                                        help = "The percentage deducted from your win rate by the presence of an opposing unarmed transit vehicle.",
                                    },
                                    {name = "crDeployBasicParamVOminusWinRateBattleVehicle",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=10,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "minusWinRateBattleVehicle",
                                        help = "The percentage deducted from your win rate by the presence of an opposing armed vehicle.",
                                    },
                                    {name = "crDeployBasicParamVOminusWinRateWalkerGear",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=15,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "minusWinRateWalkerGear",
                                        help = "The percentage deducted from your win rate by the presence of an opposing Walker Gear.",
                                    },
                                    {name = "crDeployBasicParamVOminusWinRateBattleGear",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=50,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "minusWinRateBattleGear",
                                        help = "The percentage deducted from your win rate by the presence of an opposing Battle Gear.",
                                    },
                                    {name = "crDeployBasicParamVOwinRateMin",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=5,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "winRateMin",
                                        help = "The lowest possible percentage your win rate can ever be. Set to 0 to always have a chance to fail horribly.",
                                    },
                                    {name = "crDeployBasicParamVOwinRateMax",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=95,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "winRateMax",
                                        help = "The highest possible percentage your win rate can ever be.\nSet to 0 along with the MIN to never win.\nSet to 100 to always have a chance for a guaranteed victory.\nSet to 100 along with the MIN to win every time.",
                                    },
                                    {name = "crDeployBasicParamVOdeadRateMin",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=3,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "deadRateMin",
                                        help = "The fewest percentage of losses from all deployed soldiers and assets you will suffer.\nA 3% means if you deploy 100 men you will be guaranteed to lose at least 3 of them, if not more.",
                                    },
                                    {name = "crDeployBasicParamVOdeadRateMax",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=50,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "deadRateMax",
                                        help = "The highest percentage of losses from all deployed soldiers and assets you will suffer.\nA 50% means if you deploy 100 men you will be guaranteed to lose 50 of them at worst.\nSet to 0 along with MIN to never suffer losses.",
                                    },
                                    {name = "crDeployBasicParamVOdeadRateUpDownCorrection",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=1,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "deadRateUpDownCorrection",
                                        help = "??? This value's purpose is not yet known.\nIt is believed to affect rounding for the computed Dead Rate.",
                                    },
                                    {name = "crDeployBasicParamVOteamStaffCountMin",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=5,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "teamStaffCountMin",
                                        help = "??? This value's purpose is not yet known.\nIt is believed to affect the fewest members in a grade designation required to form a deploy team.",
                                    },
                                },
                            },
                            {name = "crVODeployMissionParamsMenu",
                                type = "menu",
                                setting = {},
                                description = "Deploy Mission Params menu",
                                help = "These settings are for tweaking each individual deployment automatically.\nI would love to make a menu per-deployment but that is really complicated.\nSome changes can be real-time, for the others you may need to:\n1) wait for the refresh period\n2) change levels / return to Mother Base\n3) restart the game\n4) all of the above (in order)",
                                children = {
                                    {name = "crVODeployMissionParamsEnable",
                                        type = "ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=Ivars.switchRange,
                                            default=0,
                                            settingNames="set_switch",
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "Override Deploy Mission Params Enable",
                                        help = "Do you want to tweak all deployments?",
                                    },
                                    {name = "crDeployMissionParamsVOtimeMinuteMin",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=10,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "timeMinuteMin",
                                        help = "The lower bound of a deployment's duration, rescaled from their original duraiton, not including random offsets.\nSetting this to zero will not make the deploy time zero unless the Max is also zero.",
                                    },
                                    {name = "crDeployMissionParamsVOtimeMinuteMax",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=120,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "timeMinuteMax",
                                        help = "The upper bound of a deployment's duration, rescaled from their original duraiton, not including random offsets.\nSetting this to zero will not make the deploy time zero unless the Min is also zero.",
                                    },
                                    {name = "crDeployMissionParamsVOtimeMinuteRandomMin",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=5,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "timeMinuteRandomMin",
                                        help = "The lower bound of random time to get added to each deployment time, when they are rolled.",
                                    },
                                    {name = "crDeployMissionParamsVOtimeMinuteRandomMax",
                                        type="ivar",
                                        setting = {
                                            save=IvarProc.CATEGORY_EXTERNAL,
                                            range=this.infiniteRange,
                                            default=60,
                                            OnChange=this.RecomputeDeployTweaks,
                                        },
                                        description = "timeMinuteRandomMax",
                                        help = "The upper bound of random time to get added to each deployment time, when they are rolled.",
                                    },
                                },
                            },
                        },
                    },
                    {name = "crBankMenu",
                        type = "menu",
                        setting = {},
                        description = "Chet Rippo Bank menu",
                        help = "A sub-menu for financial related settings.",
                        children = {
                            {name = "crChetRippoBuxToAbsolition",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.EXTERNAL,
                                    default=1000,
                                    range=this.infiniteRange,
                                },
                                description = "CRB To Absolition",
                                help = "How many CRB you can donate for repentence.",
                            },
                        },
                    },
                    {name = "crEmergencySuppliesMenu",
                        type = "menu",
                        setting = {},
                        description = "Emergency Supplies menu",
                        help = "A sub-menu for emergency supply related settings.",
                        children = {
                            {name = "crEmergencySuppliesSuppressorsEnable",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Enable Emergency Suppressors",
                                help = "A suppressor will be made available every time one of yours breaks, if you can afford it.",
                            },
                            {name = "crEmergencySuppliesSuppressorsCost",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.EXTERNAL,
                                    default=2000,
                                    range=this.infiniteRange,
                                },
                                description = "Emergency Suppressor Cost",
                                help = "How much GMP to spend when utilizing an emergency suppressor.",
                            },
                        },
                    },
                    {name = "crDGMPLossMenu",
                        type = "menu",
                        setting = {},
                        description = "Death GMP Loss menu",
                        help = "A sub-menu for death related settings.",
                        children = {
                            {name = "crDeathGmpLossEnable",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "GMP Death Loss",
                                help = "Do you want to lose GMP when you die?",
                            },
                            {name = "crDeathGmpLossIncludeGlobal",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Include Global GMP",
                                help = "Do you want your Global GMP to count toward your percentage value?",
                            },
                            {name = "crDeathGmpLossPercentage",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.EXTERNAL,
                                    default=25,
                                    range={max=100,min=0,increment=1},
                                    isPercent=true,
                                },
                                description = "Death GMP Loss %",
                                help = "How much GMP to lose on death, as a percentage.",
                            },
                        },
                    },
                    {name = "crHygieneMenu",
                        type = "menu",
                        setting = {},
                        description = "Hygiene menu",
                        help = "A sub-menu for toilet and shower related settings.",
                        children = {
                            {name = "crHygieneProvisionalShowerEnable",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Toilets Are Showers",
                                help = "Do you want to get clean when you're on the john?",
                            },
                            {name = "crHygieneProvisionalShowerReduceDeployTime",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.EXTERNAL,
                                    default=24,
                                    range={max=72,min=0,increment=1},
                                    noBounds=true,
                                },
                                description = "Deployment Reduction Time",
                                help = "How much each shower reduces your time deployed (in in-game hours).",
                            },
                            -- TODO: set a minimum for how low deployment can be reduced to via showering
                            -- provisional shower balanced profile is: 259200 
                            {name = "crHygieneProvisionalShowerWallMinutesBetweenUses",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.EXTERNAL,
                                    default=5,
                                    range={max=60,min=0,increment=1},
                                    noBounds=true,
                                },
                                description = "Wall Minutes Between Uses",
                                help = "How many minutes (irl, regardless of time scale) between uses of a toilet as a provisional shower.",
                            },
                            {name = "crHygieneDumpsterEnable",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Dumpsters Make You Stinky",
                                help = "Do you want to get dirty, and keep Ocelot away from you?",
                            },
                            {name = "crHygieneDumpsterDirtinessIncreaseDeployTime",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.EXTERNAL,
                                    default=4,
                                    range={max=72,min=0,increment=1},
                                    noBounds=true,
                                },
                                description = "Dumpster Dirtiness Increase Time",
                                help = "How much stinkier you get for jumping into a dumpster (in in-game hours).",
                            },
                            {name = "crHygieneReallowQuietShowerCutscene",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Reallow Quiet Cutscene",
                                help = "Forcibly toggle the flag to replay the cutscene with Quiet in Mother Base by disabling the flag for having seen it, every time it is active.",
                            },
                        },
                    },
                    {name = "crTimeMenu",
                        type = "menu",
                        setting = {},
                        description = "Time menu",
                        help = "A sub-menu for financial related settings.",
                        children = {
                            {name = "crMiscSyncLocalTime",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Time: Sync Local Time",
                                help = "If you want the timescale to match your computer's time.\nYou should set timescale=1 in IH to prevent any strange behavior.\nMay make some cutscenes look weird, plese report any problems.",
                            },
                            {name = "crMiscSyncLocalTimeOffset",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range={min=-23,max=23,increment=1},
                                    default=0,
                                },
                                description = "Time: Local Time Hour Offset",
                                help = "If the game is too bright based on local time, offset it forward or backwards.\nAlso changes the resultant in-game time, not just light levels.",
                            },
                        },
                    },
                    {name = "crCombatMenu",
                        type = "menu",
                        setting = {},
                        description = "Combat menu",
                        help = "A sub-menu combat related settings.\nThese should not be run on FOB missions.",
                        children = {
                            {name = "crCombatSupportHeliFlareWarps",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Combat: Support Heli Flare Warps",
                                help = "Allow you to teleport to the location a Support Heli flare deploys.\nSupport Heli will still appear.\nWatch out for the smoke!",
                            },
                            {name = "crCombatBaitZombifiesSoldiers",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Combat: Bait Zombifies Soldiers",
                                help = "A direct hit with bait will cause soldiers to become zombified.",
                            },
                        },
                    },
                    {name = "crMiscMenu",
                        type = "menu",
                        setting = {},
                        description = "Miscellenous menu",
                        help = "A sub-menu for settings I couldn't categorize.",
                        children = {
                            -- {min=-math.huge,max=math.huge,increment=1}
                            {name = "crStaffAllowVolunteers",
                                -- was in: crStaffMenu
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=1,
                                    settingNames="set_switch",
                                },
                                description = "Staff: Allow Volunteers",
                                help = "Whether or not volunteer staff will appear.",
                            },
                            {name = "crResultAllowRankRestrictedItems",
                                type = "ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=Ivars.switchRange,
                                    default=0,
                                    settingNames="set_switch",
                                },
                                description = "Rank: Allow Rank-Restricted Items",
                                help = "Whether or not your rank will be docked for having a rank restricting item.",
                            },
                        },
                    },
                },
            },
            {name = "crActionsMenu",
                type = "menu",
                setting = {},
                description = "Chet Rippo Actions menu",
                help = "All quick-actions Chet Rippo provides.\nThese are all kept in one place so you have less menus to jump through than you would otherwise.",
                children = {
                    {name = "crChetRippoBux",
                        type = "ivar",
                        setting = {
                            save=IvarProc.EXTERNAL,
                            default=this.CONSTS.MAX_LOCAL_GMP,
                            range=this.infiniteRange,
                        },
                        description = "Bank: Chet Rippo Bux",
                        help = "How many CRB/GMP you'd like to operate on.",
                    },
                    {name = "bankPrintGMP",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankPrintGMP",
                        },
                        description = "Bank: Print CRB Balance",
                        help = "Shows you how much GMP you converted to Chet Rippo Bux.",
                    },
                    {name = "bankDepositGMP",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankDepositGMP",
                        },
                        description = "Bank: Deposit GMP for CRB",
                        help = "Convert excess GMP into Chet Rippo Bux.",
                    },
                    {name = "bankWithdrawGMP",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankWithdrawGMP"
                        },
                        description = "Bank: Withdraw CRB for GMP",
                        help = "Convert Chet Rippo Bux into GMP.",
                    },
                    {name = "bankDonateCRB",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankDonateCRB"
                        },
                        description = "Bank: Donate CRB For Absolition",
                        help = "Charitably give your CRB away.",
                    },
                    {name = "crHygieneSniffCheck",
                        type = "command",
                        setting = {
                            command = "ChetRippo.CrHygieneSniffCheck"
                        },
                        description = "Hygiene: Sniff Check",
                        help = "Get intel on how stinky you are.",
                    },
                    {name = "emergencySuppressorBuyNow",
                        type = "command",
                        setting = {
                            command = "ChetRippo.EmergencySuppressorBuyNow",
                        },
                        description = "E.Supplies: Buy Suppressor",
                        help = "Manually buy a suppressor.",
                    },
                    {name = "gOREHardLoadCheckPoint",
                        type = "command",
                        debug = true,
                        setting = {
                            command = "ChetRippo.GOREHardLoadCheckPoint",
                        },
                        description = "Debug: Hard Reload",
                        help = "Reload from last checkpoint + reload scripts.",
                    },
                    {name = "gORESaveCheckPoint",
                        type = "command",
                        debug = true,
                        setting = {
                            command = "ChetRippo.GORESaveCheckPoint",
                        },
                        description = "Debug: Save CheckPoint",
                        help = "Convenient place to save before a reload.",
                    },
                    {name = "gOREDumpAllToFile",
                        type = "command",
                        debug = true,
                        setting = {
                            command = "ChetRippo.GOREDumpAllToFile",
                        },
                        description = "Debug: Dump To File",
                        help = "Dump the global state to a timestamped file named \"gore_dump_\" in the /mod/ directory.",
                    },
                },
            },
            -- [[ == NOT READY == ]]
            --[[
            {name = "crCombatBirdsDropItems",
                type = "ivar",
                setting = {
                    save=IvarProc.CATEGORY_EXTERNAL,
                    range=Ivars.switchRange,
                    default=0,
                    settingNames="set_switch",
                },
                description = "Combat: Birds Drop Items",
                help = "Hitting a bird will cause them to drop a throwable item.\nThey love collecting trinkets.",
            },
            {name = "crInfinityMenu",
                type = "menu",
                setting = {},
                description = "Infinity menu",
                help = "A sub-menu for infinite related settings.",
                children = {
                    {
                        name = "crInfinityFultons",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                        },
                        description = "Enable Infinite Fultons",
                        help = "The indicator in-game may appear incorrectly, but you will have infinite fultons.",
                    },
                },
            },
             {name = "crStaffMenu",
                type = "menu",
                setting = {},
                description = "Staff menu",
                help = "A sub-menu for MB Staff related settings.",
                children = {
                    
                },
            },
            {name = "crResultMenu",
                type = "menu",
                setting = {},
                description = "Results menu",
                help = "A sub-menu for rank and results related settings.",
                children = {
                    
                },
            },
            {name = "crDebugMenu",
                type = "menu",
                debug = true,
                setting = {},
                description = "Debug menu",
                help = "A developer-only menu settings.",
                children = {

                },
            },
            ]]
        },
    },
}

local namespace = "ChetRippo"
function this.GenerateIvars(parentMenu, depthIndex, depthValue)
    local depthName = depthValue.name
    this.langStrings.eng[depthName] = depthValue.description
    this.langStrings.help.eng[depthName] = depthValue.help
    local allow_debug = (depthValue.debug == true and (this.debugModule == true or Ivars.debugMode:Is(1))) or (depthValue.debug ~= true)

    if allow_debug then
        if depthValue.type ~= nil and depthValue.type == "menu" then
            table.insert(this.registerMenus, depthName)
            this[depthName] = depthValue.setting
            if parentMenu == nil then
                this[depthName].parentRefs = {"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"}
            else
                this[depthName].parentRefs = {}
            end
            this[depthName].options = {}

            for childName, childValue in pairs(depthValue.children) do
                local subNs = (namespace .. "." .. depthName)
                local outNs, outVal = this.GenerateIvars(subNs, childName, childValue)
                table.insert(this[depthName].options, outNs)
            end

            return (namespace .. "." .. depthName), this[depthName]
        elseif depthValue.type ~= nil and depthValue.type == "ivar" then
            table.insert(this.registerIvars, depthName)
            this[depthName] = depthValue.setting

            -- set up the rest of the menu
            return ("Ivars." .. depthName), this[depthName]
        elseif depthValue.type ~= nil and depthValue.type == "command" then
            -- set up the rest of the menu
            return depthValue.setting.command, nil
        end
    end
end

--[[ === EVERYTHING ABOVE WAS BOILERPLATE THIS IS WHERE THE REAL CODE LIVES === ]]
--[[ === UTILITY === ]]
local clone = function(t)
    local rtn = {}
    for k, v in pairs(t) do rtn[k] = v end
    return rtn
end
local formatLikeBalance = function(thingName, quantity)
    local sign = (quantity > 0 and "+") or (quantity < 0 and "-") or ""
    return "["..thingName.." "..sign..tostring(math.abs(quantity)).."]"
end
function this.MapValue(val, inMin, inMax, outMin, outMax)
    return outMin + (outMax - outMin) * ((val-inMin)/(inMax-inMin))
end
function this.GetAvailableGMP(excludeOnline)
    local totalGMP = TppMotherBaseManagement.GetGmp()
    if Tpp.IsOnlineMode() and excludeOnline then
        totalGMP = totalGMP - vars.mbmServerWalletGmp
    end

    return totalGMP
end

--[[ === ~~~ GORE: for debugging w/o IHTearDown ~~~ === ]]
--this.GORE = {}
this.GOREDumpFoxTable = function(vars)
  local vars=vars

  local rootArrayIdent=-285212671

  local arrayIdent=-285212665
  local arrayCountIdent=-285212666

  local varsTable={}

  for k,v in pairs(vars[rootArrayIdent])do
    varsTable[k]=vars[k]
  end

  local skipKeys={
    __index=true,
    __newindex=true,
  }

  for k,foxTable in pairs(vars)do
    --tex is actually a foxTable
    if type(foxTable)=="table" then
      if foxTable[arrayCountIdent] then
        if type(k)=="string" then
          if not skipKeys[k] then
            local foxTableArray=foxTable[arrayIdent]
            if foxTableArray then
              varsTable[k]={}
              local arrayCount=foxTable[arrayCountIdent]
              for i=0,arrayCount-1 do
                varsTable[k][i]=vars[k][i]
              end
            end--if foxTableArray
          end--not skipKeys
        end--k==type string
      end--if foxTable[arrayCountIndex]
    end--foxTable==type table
  end--for vars

  return varsTable
end
this.GOREDumpSaveTable = function(inputVars)
  if inputVars==nil then
    return
  end

  local varsTable={}

  --tex svars.__as is non array vars
  for k,v in pairs(inputVars.__as or {}) do
    varsTable[k]=v
  end

  --tex svars.__rt is array vars
  --REF
  --  __rt = {
  --      InterrogationNormal = {
  --      __vi = 224,
  --      <metatable> = <table 1>
  --    },
  for k,v in pairs(inputVars.__rt or {}) do
    varsTable[k]={}
    local arraySize=v.__vi--DEBUGNOW not sure if this is right
    for i=0,arraySize-1 do
      varsTable[k][i]=inputVars[k][i]
    end
  end

  return varsTable
end
this.GOREWriteString = function(filePath,someString)
  local file,error=io.open(filePath,"w")
  if not file or error then
      return
  end

  file:write(someString)
  file:close()
end
this.GOREWriteTable = function(fileName,header,t)
  if t==nil then
      return
  end

  local all=InfInspect.Inspect(t)
  all="local this="..all.."\r\n".."return this"
  if header then
      all=header.."\r\n"..all
  end

  this.GOREWriteString(fileName,all)
end
this.GOREDumpAllToFile = function()
  this.GOREWriteTable(InfCore.gamePath..InfCore.modSubPath .. "/gore_dump_" .. os.time() .. ".lua", "-- GoreModule.lua dump", {
    vars = this.GOREDumpFoxTable(vars),
    svars = this.GOREDumpSaveTable(svars),
    gvars = this.GOREDumpSaveTable(gvars),
    mvars = mvars,
  })
end
this.GOREHardLoadCheckPoint = function()
  InfMain.LoadExternalModules()
  TppMission.ContinueFromCheckPoint()
end
this.GORESaveCheckPoint = function()
  InfMenuCommands.CheckPointSave()
end


function this.RecomputeDeployTweaks()
    if this.vars.interceptedDeployMissionBasicParams ~= nil then
        local live = this.vars.livingDeployMissionBasicParams

        if Ivars.crVODeployBasicParamsEnable:Is(1) then
            live.missionListRefreshTimeMinute = Ivars.crDeployBasicParamVOmissionListRefreshTimeMinute:Get()
            live.drawCountPerSr = Ivars.crDeployBasicParamVOdrawCountPerSr:Get()
            live.drawCountPerR = Ivars.crDeployBasicParamVOdrawCountPerR:Get()
            live.powerTransitVehicle = Ivars.crDeployBasicParamVOpowerTransitVehicle:Get()
            live.powerBattleVehicle = Ivars.crDeployBasicParamVOpowerBattleVehicle:Get()
            live.powerWalkerGear = Ivars.crDeployBasicParamVOpowerWalkerGear:Get()
            live.powerBattleGear = Ivars.crDeployBasicParamVOpowerBattleGear:Get()
            live.minusWinRateTransitVehicle = Ivars.crDeployBasicParamVOminusWinRateTransitVehicle:Get()
            live.minusWinRateBattleVehicle = Ivars.crDeployBasicParamVOminusWinRateBattleVehicle:Get()
            live.minusWinRateWalkerGear = Ivars.crDeployBasicParamVOminusWinRateWalkerGear:Get()
            live.minusWinRateBattleGear = Ivars.crDeployBasicParamVOminusWinRateBattleGear:Get()
            live.winRateMin = Ivars.crDeployBasicParamVOwinRateMin:Get()
            live.winRateMax = Ivars.crDeployBasicParamVOwinRateMax:Get()
            live.deadRateMin = Ivars.crDeployBasicParamVOdeadRateMin:Get()
            live.deadRateMax = Ivars.crDeployBasicParamVOdeadRateMax:Get()
            live.deadRateUpDownCorrection = Ivars.crDeployBasicParamVOdeadRateUpDownCorrection:Get()
            live.teamStaffCountMin = Ivars.crDeployBasicParamVOteamStaffCountMin:Get()
        end

        this.wrap.TppMotherBaseManagement.RegisterDeployBasicParam(live)
    end

    for mission_id, mission_params in pairs(this.vars.interceptedDeployMissionParams) do
        local mdead = this.vars.interceptedDeployMissionParams[mission_id]
        local mlive = this.vars.livingDeployMissionParams[mission_id]

        if Ivars.crVODeployMissionParamsEnable:Is(1) then
            mlive.deadRate = this.MapValue(mdead.deadRate,
                this.vars.interceptedDeployMissionBasicParams.deadRateMin,
                this.vars.interceptedDeployMissionBasicParams.deadRateMax,
                this.vars.livingDeployMissionBasicParams.deadRateMin,
                this.vars.livingDeployMissionBasicParams.deadRateMax
            )
            mlive.baseWinRate = this.MapValue(mdead.baseWinRate,
                this.vars.interceptedDeployMissionBasicParams.winRateMin,
                this.vars.interceptedDeployMissionBasicParams.winRateMax,
                this.vars.livingDeployMissionBasicParams.winRateMin,
                this.vars.livingDeployMissionBasicParams.winRateMax
            )

            mlive.timeMinute = this.MapValue(mdead.timeMinute,
                this.vars.timeMinuteMin,
                this.vars.timeMinuteMax,
                Ivars.crDeployMissionParamsVOtimeMinuteMin:Get(),
                Ivars.crDeployMissionParamsVOtimeMinuteMax:Get()
            )
            mlive.timeMinuteRandom = this.MapValue(mdead.timeMinuteRandom,
                this.vars.timeMinuteRandomMin,
                this.vars.timeMinuteRandomMax,
                Ivars.crDeployMissionParamsVOtimeMinuteRandomMin:Get(),
                Ivars.crDeployMissionParamsVOtimeMinuteRandomMax:Get()
            )
        end

        this.wrap.TppMotherBaseManagement.RegisterDeployMissionParam(mlive)
    end
end

function this.BankPrintGMP()
    TppUiCommand.AnnounceLogView("Current Balance: "..formatLikeBalance("CRB", igvars.crBalance))
end

function this.BankDepositGMP()
    local totalGMP = this.GetAvailableGMP(true)
    local actionableGMP = math.min(math.max(totalGMP,0), math.max(Ivars.crChetRippoBux:Get(),0))

    TppUiCommand.AnnounceLogView("Deposited To CRB "..formatLikeBalance("GMP", -actionableGMP))
    igvars.crBalance = igvars.crBalance + actionableGMP

    TppTerminal.UpdateGMP({gmp=-actionableGMP})
end

function this.BankWithdrawGMP()
    local totalGMP = this.GetAvailableGMP(true)
    local maxWithdraw = this.CONSTS.MAX_LOCAL_GMP - totalGMP
    local actionableGMP = math.min(math.max(Ivars.crChetRippoBux:Get(),0), math.max(maxWithdraw,0))

    TppUiCommand.AnnounceLogView("Withdrew From CRB " .. formatLikeBalance("GMP", actionableGMP))
    igvars.crBalance = igvars.crBalance - actionableGMP

    TppTerminal.UpdateGMP({gmp=actionableGMP})
end

function this.BankDonateCRB()
    local totalCRB = igvars.crBalance
    local spending = math.max(Ivars.crChetRippoBuxToAbsolition:Get(),0)

    local actionableCRB = math.min(math.max(Ivars.crChetRippoBux:Get(),0), math.max(totalCRB,0))
    local changeInHeroism = math.floor(math.max(actionableCRB/spending, 0))

    TppMotherBaseManagement.AddHeroicPoint({
        heroicPoint=changeInHeroism
    })
    TppMotherBaseManagement.SubOgrePoint({
        ogrePoint=-changeInHeroism
    })
    igvars.crBalance = math.max(igvars.crBalance - actionableCRB, 0)

    TppUiCommand.AnnounceLogView("Donated CRB: "..formatLikeBalance("CRB", -actionableCRB).." "..formatLikeBalance("Heroism", changeInHeroism))
end

function this.HandleHygieneEvent(hygieneEvent)
    if hygieneEvent == this.CONSTS.HYGIENE_EVENT_SHOWER then
        igvars.crHygieneProvisionalShowerLastUsed = TppScriptVars.GetTotalPlayTime()
        -- we don't need to do anything because they already got showered
    elseif hygieneEvent == this.CONSTS.HYGIENE_EVENT_TOILET then
        this.CleanPlayer()
    elseif hygieneEvent == this.CONSTS.HYGIENE_EVENT_DUMPSTER then
        this.DirtyPlayer()
    end
end

function this.CleanPlayer() -- cheat
    if Ivars.crHygieneProvisionalShowerEnable:Is(0) then return end
    local previousUse = igvars.crHygieneProvisionalShowerLastUsed or 0
	local currentUse = TppScriptVars.GetTotalPlayTime()
    local timeBetweenUse = math.max(60*Ivars.crHygieneProvisionalShowerWallMinutesBetweenUses:Get(),0)
    if (currentUse - previousUse) > timeBetweenUse then
        igvars.crHygieneProvisionalShowerLastUsed = currentUse
        local mostRecentTimeOut = vars.passageSecondsSinceOutMB
        local logText = "Physically and Mentally Refreshed"
        Player.ResetDirtyEffect()
        Player.SetWetEffect()

        local newTimeOut = math.max(0, mostRecentTimeOut - (Ivars.crHygieneProvisionalShowerReduceDeployTime:Get()*60*60))
        vars.passageSecondsSinceOutMB = newTimeOut -- 60*60*24*3 
        if vars.passageSecondsSinceOutMB > 0 then
            logText = "Partially " .. logText
        else
            -- in case anyone is listening on this
            -- for some reason
            TppPlayer.Refresh()
        end
        TppUiCommand.AnnounceLogView(logText)
    end
end

function this.DirtyPlayer()
    if Ivars.crHygieneDumpsterEnable:Is(0) then return end

    local mostRecentTimeOut = vars.passageSecondsSinceOutMB
    local logText = "Physically and Mentally Drained"
    Player.SetWetEffect()

    local newTimeOut = math.max(0, mostRecentTimeOut + (Ivars.crHygieneDumpsterDirtinessIncreaseDeployTime:Get()*60*60))
    vars.passageSecondsSinceOutMB = newTimeOut -- 60*60*24*3 
    if vars.passageSecondsSinceOutMB >= (60*60*24*3) then
        logText = "Completely " .. logText
    end
    TppUiCommand.AnnounceLogView(logText)
end


function this.DemoOverride()
    if Ivars.crHygieneReallowQuietShowerCutscene:Get(1) and
        TppDemo.IsPlayedMBEventDemo("SnakeHasBadSmell_000") then
        TppDemo.ClearPlayedMBEventDemoFlag("SnakeHasBadSmell_000")
    end
end

function this.CrHygieneSniffCheck()
    local daysUnbathed = (vars.passageSecondsSinceOutMB/60/60/24)
    local unstinkAmount = Ivars.crHygieneProvisionalShowerReduceDeployTime:Get()*60*60

    local previousUse = igvars.crHygieneProvisionalShowerLastUsed or 0
	local currentUse = TppScriptVars.GetTotalPlayTime()
    local timeBetweenUse = math.max(60*Ivars.crHygieneProvisionalShowerWallMinutesBetweenUses:Get(),0)
    local canBathe = (currentUse - previousUse) > timeBetweenUse

    local stinky = Player.GetSmallFlyLevel() >= 1
    local outText = "Intel Stench Report: "
    if daysUnbathed >= 3 or stinky then
        outText = outText .. "You stink. You should have bathed "..math.ceil(daysUnbathed).." day(s) ago."
    elseif daysUnbathed < 1 then
        outText = outText .. "You're good! You've still got "..math.floor(24-(daysUnbathed*24)).." hour(s) to go."
    elseif daysUnbathed < 3 then
        outText = outText .. "Not good. Seek a shower in the next "..math.floor(72-(daysUnbathed*24)).." hour(s), or else!"
    else
        outText = outText .. "What have you done?!"
    end

    -- outText

    --TppUiCommand.AnnounceLogView("smallFlyLevel="..tostring(Player.GetSmallFlyLevel())..",rawStink="..tostring(vars.passageSecondsSinceOutMB)..",canBathe="..tostring(canBathe))
    --TppUiCommand.AnnounceLogView("daysUnbathed="..tostring(daysUnbathed)..",previousUse="..tostring(previousUse)..",now="..tostring(currentUse))
    --TppUiCommand.AnnounceLogView("timeBetweenUse="..tostring(timeBetweenUse)..",unstinkAmount="..tostring(unstinkAmount))
    TppUiCommand.AnnounceLogView(outText)
end

function this.OnFadeInForShower()
    this.DemoOverride()
end

function this.OnFadeInForGMPLoss()
    if Ivars.crDeathGmpLossEnable:Is(0) then return end
    local totalGMP = this.GetAvailableGMP(not Ivars.crDeathGmpLossIncludeGlobal:Is(1))

	if this.vars.crDeathGmpLossValidDeath and totalGMP > 0 then
        local cost = math.floor(totalGMP * (Ivars.crDeathGmpLossPercentage:Get()/100))

        if cost > 0 then
            TppTerminal.UpdateGMP({gmp=-cost})
            TppUiCommand.AnnounceLogView("Resuscitation Supplies: [GMP -" .. tostring(cost) .. "]")
        end
		TppMission.UpdateCheckPointAtCurrentPosition()
	end
	this.vars.crDeathGmpLossValidDeath = false
end

function this.OnFulton(gameObjectId, gimmckInstance, gimmckDataSet, staffID)
    if false and Ivars.crInfinityFultons:Is(1) and svars.FulltonCount ~= nil then
        svars.FulltonCount = svars.FulltonCount + 1
    end
    -- svars.trm_missionFultonCount
    --TppMotherBaseManagement.DirectAddStaff{ staffId=staffID, section = "Develop" }
end

function this.OnDeath(playerId,deathTypeStr32)
    if Ivars.crDeathGmpLossEnable:Is(0) then return end
	if (deathTypeStr32~=InfCore.StrCode32("FallDeath")) and 
		(deathTypeStr32~=InfCore.StrCode32("Suicide")) and 
		(not TppMission.IsFOBMission(vars.missionCode)) then
		this.vars.crDeathGmpLossValidDeath = true
    end
end

function this.Zombify(gameId,opts)
    local options = InfUtil.MergeTable({
        disableDamage=false,
        isHalf=false,
        isMsf=false,
        life=300,
        stamina=200,
        --
        ignoreFlag=0,
        isHagure=true,
        isZombieSkin=true,
        useZombieRoute=false,
    }, opts or {})
    local damagedType = GameObject.GetTypeIndex(gameId)
    if damagedType == TppGameObject.GAME_OBJECT_TYPE_SOLDIER2 then
        GameObject.SendCommand(gameId,{id="SetZombie",enabled=true,isHalf=options.isHalf,isZombieSkin=options.isZombieSkin,isHagure=options.isHagure,isMsf=options.isMsf})
        GameObject.SendCommand(gameId,{id="SetMaxLife",life=options.life,stamina=options.stamina})
        GameObject.SendCommand(gameId,{id="SetZombieUseRoute",enabled=options.useZombieRoute})
        if options.disableDamage then
            GameObject.SendCommand(gameId,{id="SetDisableDamage",life=false,faint=true,sleep=true})
        end
        if options.isHalf then
            GameObject.SendCommand(gameId,{id="SetIgnoreDamageAction",flag=options.ignoreFlag})
        end
    end
end

function this.ZombifyWithBait(damagedId, attackId, attackerId)
    if Ivars.crCombatBaitZombifiesSoldiers:Is(0) then return end
    if attackId == TppDamage.ATK_KibidangoHit then
        this.Zombify(damagedId)
    end
end

function this.SyncLocalTime()
    if Ivars.crMiscSyncLocalTime:Is(1) and (not (mvars.mis_missionStateIsNotInGame or mvars.mis_loadRequest or vars.missionCode==50050)) then
        local todaysDate=os.date("*t")
        local todaysTime=math.fmod(todaysDate.hour+Ivars.crMiscSyncLocalTimeOffset:Get(), 24)*60*60+todaysDate.min*60+todaysDate.sec
        vars.clock=todaysTime
    end
end

-- not OnUpdate
function this.Update()
    this.SyncLocalTime()
end

function this.EmergencySuppressorBuyNow()
    this.GiveSuppressor()
end

function this.LocatePlayer()
    local outPos = TppPlayer.GetPosition()
    outPos = Vector3(outPos[1],outPos[2],outPos[3])
    return outPos
end

function this.LocateObject(gameId,fallBackToPlayer)
    local outPos=GameObject.SendCommand(gameId,{id="GetPosition"})
    if not outPos then
        if fallBackToPlayer then
            outPos = TppPlayer.GetPosition()
            outPos = Vector3(outPos[1],outPos[2],outPos[3])
        else
            InfCore.Log("WARNING: ChetRippo.LocateObject: GetPosition nil for gameId:"..tostring(gameId)..", no player fallback", false, "warn")
        end
    else
        outPos=Vector3(outPos:GetX(),outPos:GetY(),outPos:GetZ())
    end
    return outPos
end

function this.RandomVector3(extent)
    return Vector3(
        math.random(-extent, extent),
        math.random(-extent, extent),
        math.random(-extent, extent)
    )
end

function this.FindEquipNameFromEquipId(equipId)

end

--TppEquip.GetSupportWeaponTypeId()
-- SWP_TYPE_
-- SWP_TYPE_Grenade 
-- SWP_TYPE_SmokeGrenade 
-- Player.GetItemLevel( TppEquip.EQP_IT_Fulton_Child ) 
-- TppMotherBaseManagement.IsEquipDeveloped

-- 1) take a weapon's name, reduce it to type
-- 2) find the highest grade the player has
function this.GetPlayerGradeForEquip(equipName)
    local inputEquipId = TppEquip[equipName]
    if inputEquipId == nil then return nil end -- NOT FOUND

    local swt = TppEquip.GetSupportWeaponTypeId( inputEquipId )
    local matchIndex = -1
    for i=0,7 do
        local gswt = TppEquip.GetSupportWeaponTypeId( vars.supportWeapons[i] )
        if swt == gswt then
            matchIndex = i
            break
        end
    end

    if matchIndex > -1 then
        -- the player has the weapon
        local matchingEquipId = vars.supportWeapons[matchIndex]
        local matchingEquipName = InfLookup.TppEquip.equipId[ matchingEquipId ]
        if matchingEquipName then
            InfCore.Log("ChetRippo.GetPlayerGradeForEquip: found it " .. matchingEquipName, false, "debug")
            return matchingEquipName
        end
    else
        -- the player does not have the weapon
        -- we're going to do very drastic things now
        local base = this.GetBaseItemNameFromGraded(equipName)
    end
end


function this.GetBaseItemNameFromGraded(equipName)
    local outName = string.match(equipName, "(.+)_G%d%d$")
    if outName ~= nil then
        return outName
    else
        return equipName
    end
end

function this.SpawnObject(itemInput, extraData)
    local itemDef = InfUtil.MergeTable({
        number          = 1,
        rotation        = Quat.RotationY(0),
        linearVelocity  = this.RandomVector3(extraData.randomLinearVelocity or 0),
        angularVelocity = this.RandomVector3(extraData.randomAngularVelocity or 0),
    }, itemInput)
    local item = TppPickable.DropItem(itemDef)
    TppSoundDaemon.PostEvent("sfx_s_item_appear")
    return item
end

function this.GiveSuppressor()
    local cost = Ivars.crEmergencySuppliesSuppressorsCost:Get()
    if Ivars.crEmergencySuppliesSuppressorsEnable:Is(0) or this.GetAvailableGMP(true) < cost then return end

    local linearMax=0
    local angularMax=0
    local dropOffsetY=0.5

    local dropPosition = this.LocatePlayer()
    if dropPosition then
        local item = this.SpawnObject({
            equipId  = TppEquip.EQP_AB_Suppressor,
            position = Vector3.Add(dropPosition,Vector3(0, dropOffsetY, 0)),
        }, {
            randomLinearVelocity = linearMax,
            randomAngularVelocity = angularMax,
        })

        TppUiCommand.AnnounceLogView("Emergency Suppressor Deployed: [GMP -"..tostring(cost).."]")
        TppTerminal.UpdateGMP({gmp=-cost})
        return item
    end
end

function this.BirdGotHurt(damagedId, attackId, attackerId)
    if Ivars.crCombatBirdsDropItems:Is(0) then return end
    local damagedType = GameObject.GetTypeIndex(damagedId)
    if damagedType ~= TppGameObject.GAME_OBJECT_TYPE_CRITTER_BIRD then return end

    -- TODO: build dropPool from EQP_TYPE_Throwing matches
    local dropPool = {
        "EQP_SWP_Grenade",
        "EQP_SWP_StunGrenade",
        "EQP_SWP_SmokeGrenade",
    }
    local objectToDrop = dropPool[math.random(#dropPool)]
    local thingo = this.GetPlayerGradeForEquip(objectToDrop)

    if thingo ~= nil and TppEquip[thingo] then
        objectToDrop = TppEquip[thingo]
    else
        objectToDrop = TppEquip[objectToDrop]
    end

    local linearMax=0
    local angularMax=0
    local dropOffsetY=0.5

    local dropPosition = this.LocateObject(damagedId, true)
    if dropPosition then
        local item = this.SpawnObject({
            equipId  = objectToDrop,
            position = Vector3.Add(dropPosition,Vector3(0, dropOffsetY, 0)),
        }, {
            randomLinearVelocity = linearMax,
            randomAngularVelocity = angularMax,
        })

        TppUiCommand.AnnounceLogView("Bird Dropped Item!")
        return item
    end
end

-- [[ == WRAPPING MODULES == ]]
-- stuff that we don't want to force into IH

function this.CaptureRegisterResourceParam(resource_params)
    if resource_params.resource ~= nil then
        if this.vars.interceptedResourceParam[resource_params.resource] == nil then
            this.vars.interceptedResourceParam[resource_params.resource] = resource_params
            this.vars.livingResourceParam[resource_params.resource] = clone(resource_params)

            -- if we're editing do it here:

            -- survey for the time ranges to create a baseline scale range
            --[[
            if mission_param.timeMinute > this.vars.timeMinuteMax then
                this.vars.timeMinuteMax = mission_param.timeMinute
            end
            if mission_param.timeMinute < this.vars.timeMinuteMin then
                this.vars.timeMinuteMin = mission_param.timeMinute
            end
            if mission_param.timeMinuteRandom > this.vars.timeMinuteRandomMax then
                this.vars.timeMinuteRandomMax = mission_param.timeMinuteRandom
            end
            if mission_param.timeMinuteRandom < this.vars.timeMinuteRandomMin then
                this.vars.timeMinuteRandomMin = mission_param.timeMinuteRandom
            end
            ]]

            this.wrap.TppMotherBaseManagement.RegisterResourceParam(this.vars.livingResourceParam[resource_params.resource])
        end
    end
end

function this.CaptureRegisterDeployBasicParam(basic_params)
    this.vars.interceptedDeployMissionBasicParams = basic_params
    this.vars.livingDeployMissionBasicParams = clone(basic_params)

    if next(this.vars.interceptedDeployMissionBasicParams) ~= nil then
        InfCore.Log("ChetRippo.CaptureRegisterDeployBasicParam initalizing", false, "debug")
    else
        InfCore.Log("WARNING: ChetRippo.CaptureRegisterDeployBasicParam called twice?", false, "critical")
    end
end

function this.CaptureRegisterDeployMissionParam(mission_param)
    if mission_param.deployMissionId ~= nil then
        if this.vars.interceptedDeployMissionParams[mission_param.deployMissionId] == nil then
            this.vars.interceptedDeployMissionParams[mission_param.deployMissionId] = mission_param
            this.vars.livingDeployMissionParams[mission_param.deployMissionId] = clone(mission_param)

            -- survey for the time ranges to create a baseline scale range
            if mission_param.timeMinute > this.vars.timeMinuteMax then
                this.vars.timeMinuteMax = mission_param.timeMinute
            end
            if mission_param.timeMinute < this.vars.timeMinuteMin then
                this.vars.timeMinuteMin = mission_param.timeMinute
            end
            if mission_param.timeMinuteRandom > this.vars.timeMinuteRandomMax then
                this.vars.timeMinuteRandomMax = mission_param.timeMinuteRandom
            end
            if mission_param.timeMinuteRandom < this.vars.timeMinuteRandomMin then
                this.vars.timeMinuteRandomMin = mission_param.timeMinuteRandom
            end
        end
    end
end

function this.WrapAddVolunteerStaffs(...)
    if Ivars.crStaffAllowVolunteers:Is(1) then
        this.wrap.TppTerminal.AddVolunteerStaffs(...)
    end
    -- else: buzz off
end
function this.WrapIsUsedRankLimitedItem(...)
    if Ivars.crResultAllowRankRestrictedItems:Is(1) then
        this.wrap.TppResult.IsUsedRankLimitedItem(...)
    end
    -- else: buzz off
end


local function GenerateWrapper(path,wrapFunc)
    local tree = InfUtil.Split(path, ".")
    local root = this.wrap
    local wrappingPath = _G
    local stop =  tree[#tree]
    for _, v in ipairs(tree) do
        if v ~= stop then
            if root[v] == nil then
                root[v] = {}
            end
            root = root[v]
            wrappingPath = wrappingPath[v]
        end
    end

    if root[stop] == nil then
        root[stop] = wrappingPath[stop]
        wrappingPath[stop] = wrapFunc
    else
        InfCore.Log("WARNING: ChetRippo.GenerateWrapper wrapping [" .. path .. "] a second time!!!", false, "warn")
    end
end

GenerateWrapper("TppMotherBaseManagement.RegisterResourceParam", this.CaptureRegisterResourceParam)
GenerateWrapper("TppMotherBaseManagement.RegisterDeployBasicParam", this.CaptureRegisterDeployBasicParam)
GenerateWrapper("TppMotherBaseManagement.RegisterDeployMissionParam", this.CaptureRegisterDeployMissionParam)
GenerateWrapper("TppTerminal.AddVolunteerStaffs", this.WrapAddVolunteerStaffs)
GenerateWrapper("TppResult.IsUsedRankLimitedItem", this.WrapIsUsedRankLimitedItem)

--[[ == IH/IHHOOK STUFF HERE == ]]
function this.Messages()
    local dinko = Tpp.StrCode32Table({
        --[[
        Radio={
            {msg="EspionageRadioCandidate",func=this.OnScanRadioTarget}
        },
        Marker={
            {msg="ChangeToEnable",func=this.RadioOverride}
        },
        GameObject={
            {msg="Fulton",func=this.OnFulton},
        },
        ]]
        GameObject={
            {msg="Damage",func=function(...)
                this.ZombifyWithBait(...)
                --this.BirdGotHurt(...)
            end,}
        },
        Player={
            {msg="Dead",func=this.OnDeath, option={isExecGameOver=true}},

            -- [[ == PROVISIONAL SHOWERS == ]]
            {msg="PlayerShowerEnd",func=function(...)
                this.HandleHygieneEvent(this.CONSTS.HYGIENE_EVENT_SHOWER, ...)
            end,},
            {msg="OnPlayerToilet",func=function(...)
                this.HandleHygieneEvent(this.CONSTS.HYGIENE_EVENT_TOILET, ...)
            end,},
            {msg="OnPlayerTrashBox",func=function(...)
                this.HandleHygieneEvent(this.CONSTS.HYGIENE_EVENT_DUMPSTER, ...)
            end,},

            {msg="SuppressorIsBroken",func=this.GiveSuppressor},
        },
        Throwing = {
            {msg="NotifyStartWarningFlare",func=function(x,y,z)
                local offSetUp=1.5

                TppPlayer.Warp{pos={x,y+offSetUp,z},rotY=vars.playerCameraRotation[1]}
            end,}
        },
        UI = {
            {msg="EndFadeIn",sender="FadeInOnStartMissionGame",func=function(...)
                this.OnFadeInForGMPLoss(...)
                this.OnFadeInForShower(...)
            end,},
            {msg="EndFadeIn",sender="FadeInOnGameStart",func=function(...)
                this.OnFadeInForGMPLoss(...)
                this.OnFadeInForShower(...)
            end,},

            {msg="EndFadeOut",sender="OnEstablishMissionClearFadeOut",func=this.DemoOverride},
        },
    })
    return dinko
end

function this.OnMessage(sender, messageId, ...)
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, ...)
end

function this.Init(missionTable)
  -- NOTE: rebuilding in here has NEVER worked out well
  this.messageExecTable=nil
  this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())

  this.RecomputeDeployTweaks()
end

this.OnReload = this.Init
-- we have to do this part as early as possible for ivar related reasons
function this.Rebuild()
    this.registerIvars={}
    this.registerMenus={}
    this.langStrings={
        eng={},
        help={
            eng={},
        },
    }

    for var, value in pairs(this.ultraVars) do
        this.GenerateIvars(nil, var, value)
    end
    -- InfCore.PrintInspect(this, {varName="ChetRippo"})
    -- @TODO: rebuild all lookups in here
end
this.Rebuild()

return this
