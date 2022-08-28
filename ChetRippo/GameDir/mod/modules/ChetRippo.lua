--[[ questions for later:

HOW TO QUERY FOR PICKUP PROMPT (HAND GRENADES)
find closestCp:afgh_fort_cp
addFlag=16?

]]

local this = {
    debugModule = true,
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
    crProvisionalShowerLastUsed = 0,
}
this.wrap = {}
this.vars = {
    crDeathGmpLossValidDeath = false,
    
    interceptedDeployMissionBasicParams = {},
    livingDeployMissionBasicParams = {},
    interceptedDeployMissionParams = {},
    livingDeployMissionParams = {},

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
            {
                name = "crBankMenu",
                type = "menu",
                setting = {},
                description = "Chet Rippo Bank menu",
                help = "A sub-menu for financial related settings.",
                children = {
                    {
                        name = "crChetRippoBux",
                        type = "ivar",
                        setting = {
                            save=IvarProc.EXTERNAL,
                            default=this.CONSTS.MAX_LOCAL_GMP,
                            range=this.infiniteRange,
                        },
                        description = "Chet Rippo Bux",
                        help = "How many CRB/GMP you'd like to operate on.",
                    },
                    {
                        name = "bankPrintGMP",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankPrintGMP",
                        },
                        description = "Print CRB Balance",
                        help = "Shows you how much GMP you converted to Chet Rippo Bux.",
                    },
                    {
                        name = "bankDepositGMP",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankDepositGMP",
                        },
                        description = "Deposit GMP for CRB",
                        help = "Convert excess GMP into Chet Rippo Bux.",
                    },
                    {
                        name = "bankWithdrawGMP",
                        type = "command",
                        setting = {
                            command = "ChetRippo.BankWithdrawGMP"
                        },
                        description = "Withdraw CRB for GMP",
                        help = "Convert Chet Rippo Bux into GMP.",
                    },
                },
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
                    {
                        name = "crStaffAllowVolunteers",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                        },
                        description = "Allow Volunteers",
                        help = "Whether or not volunteers will appear.",
                    },
                },
            },
            {name = "crResultMenu",
                type = "menu",
                setting = {},
                description = "Results menu",
                help = "A sub-menu for rank and results related settings.",
                children = {
                    {
                        name = "crResultAllowRankRestrictedItems",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=0,
                            settingNames="set_switch",
                        },
                        description = "Allow Rank-Restricted Items",
                        help = "Whether or not your rank will be docked for having a rank restricting item.",
                    },
                },
            },
            {name = "crMiscMenu",
                type = "menu",
                setting = {},
                description = "Miscellenous menu",
                help = "A sub-menu for settings I couldn't categorize.",
                children = {
                    {
                        name = "crMiscSyncLocalTime",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=0,
                            settingNames="set_switch",
                        },
                        description = "Sync Local Time",
                        help = "If the time isn't sync'd, make it.",
                    },
                    -- {min=-math.huge,max=math.huge,increment=1}
                    {
                        name = "crMiscSyncLocalTimeOffset",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range={min=-23,max=23,increment=1},
                            default=0,
                        },
                        description = "Local Time Hour Offset",
                        help = "If the game is too bright based on local time.",
                    },
                },
            },
            {name = "crEmergencySuppliesMenu",
                type = "menu",
                setting = {},
                description = "Emergency Supplies menu",
                help = "A sub-menu for emergency supply related settings.",
                children = {
                    {
                        name = "crEmergencySuppliesSuppressorsEnable",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                        },
                        description = "Enable Emergency Suppressors",
                        help = "A suppressor will be made available every time one of yours breaks, if you can afford it.",
                    },
                    {
                        name = "crEmergencySuppliesSuppressorsCost",
                        type = "ivar",
                        setting = {
                            save=IvarProc.EXTERNAL,
                            default=1000,
                            range=this.infiniteRange,
                        },
                        description = "Emergency Suppressor Cost",
                        help = "How much GMP to spend when utilizing an emergency suppressor.",
                    },
                    {
                        name = "emergencySuppressorBuyNow",
                        type = "command",
                        setting = {
                            command = "ChetRippo.EmergencySuppressorBuyNow",
                        },
                        description = "Buy Suppressor",
                        help = "Manually buy a suppressor.",
                    },
                },
            },
            {name = "crDGMPLossMenu",
                type = "menu",
                setting = {},
                description = "Death GMP Loss menu",
                help = "A sub-menu for death related settings.",
                children = {
                    {
                        name = "crDeathGmpLossEnable",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                        },
                        description = "GMP Death Loss",
                        help = "Do you want to lose GMP when you die?",
                    },
                    {
                        name = "crDeathGmpLossIncludeGlobal",
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
                    {
                        name = "crDeathGmpLossPercentage",
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
            {name = "crProvisionalShowersMenu",
                type = "menu",
                setting = {},
                description = "Provisional Showers menu",
                help = "A sub-menu for toilet and shower related settings.",
                children = {
                    {
                        name = "crProvisionalShowerEnable",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                        },
                        description = "Toilets Are Showers",
                        help = "Do you want to get clean when you're on the john?",
                    },
                    {
                        name = "crProvisionalShowerReduceDeployTime",
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
                    {
                        name = "crProvisionalShowerWallMinutesBetweenUses",
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
                    {
                        name = "crProvisionalShowerDumpsterEnable",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                        },
                        description = "Dumpsters Make You Stinky",
                        help = "Do you want to get dirty, and keep Ocelot away from you?",
                    },
                    {
                        name = "crProvisionalShowerDumpsterDirtinessIncreaseDeployTime",
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
                    {
                        name = "crProvisionalShowerReallowQuietShowerCutscene",
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
                    {
                        name = "crProvisionalShowerSniffCheck",
                        type = "command",
                        setting = {
                            command = "ChetRippo.CrProvisionalShowerSniffCheck"
                        },
                        description = "Sniff Check",
                        help = "Get intel on how stinky you are.",
                    },
                },
            },
            {name = "crDeployTweaksMenu",
                type = "menu",
                setting = {},
                description = "Deploy Tweaks menu",
                help = "A sub-menu for tweaking deployment settings.",
                children = {
                    {
                        name = "crDeployTweaksBasicParamsMenu",
                        type = "menu",
                        setting = {},
                        description = "Basic Params menu",
                        help = "A sub-menu for tweaking basic parameters settings.",
                        children = {
                            {
                                name = "crDeployTweaksBPmissionListRefreshTimeMinute",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=12,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "missionListRefreshTimeMinute",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPdrawCountPerSr",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=10,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "drawCountPerSr",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPdrawCountPerR",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=4,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "drawCountPerR",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPpowerTransitVehicle",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=200,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "powerTransitVehicle",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPpowerBattleVehicle",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=800,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "powerBattleVehicle",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPpowerWalkerGear",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=1200,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "powerWalkerGear",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPpowerBattleGear",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=3500,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "powerBattleGear",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPminusWinRateTransitVehicle",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=5,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "minusWinRateTransitVehicle",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPminusWinRateBattleVehicle",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=10,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "minusWinRateBattleVehicle",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPminusWinRateWalkerGear",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=15,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "minusWinRateWalkerGear",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPminusWinRateBattleGear",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=50,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "minusWinRateBattleGear",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPwinRateMin",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=5,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "winRateMin",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPwinRateMax",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=95,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "winRateMax",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPdeadRateMin",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=3,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "deadRateMin",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPdeadRateMax",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=50,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "deadRateMax",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPdeadRateUpDownCorrection",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=1,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "deadRateUpDownCorrection",
                                help = "?",
                            },
                            {
                                name = "crDeployTweaksBPteamStaffCountMin",
                                type="ivar",
                                setting = {
                                    save=IvarProc.CATEGORY_EXTERNAL,
                                    range=this.infiniteRange,
                                    default=5,
                                    OnChange=this.RecomputeDeployTweaks,
                                },
                                description = "teamStaffCountMin",
                                help = "?",
                            },
                        },
                    },
                    {
                        name = "crDeployTweaksEnable",
                        type = "ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=Ivars.switchRange,
                            default=1,
                            settingNames="set_switch",
                            OnChange=this.RecomputeDeployTweaks,
                        },
                        description = "Deploy Tweaks",
                        help = "Do you want to tweak deployments?",
                    },
                    {
                        name = "crDeployTweaksTimeMinuteMin",
                        type="ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=this.infiniteRange,
                            default=10,
                            OnChange=this.RecomputeDeployTweaks,
                        },
                        description = "timeMinuteMin",
                        help = "?",
                    },
                    {
                        name = "crDeployTweaksTimeMinuteMax",
                        type="ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=this.infiniteRange,
                            default=120,
                            OnChange=this.RecomputeDeployTweaks,
                        },
                        description = "timeMinuteMax",
                        help = "?",
                    },
                    {
                        name = "crDeployTweaksTimeMinuteRandomMin",
                        type="ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=this.infiniteRange,
                            default=5,
                            OnChange=this.RecomputeDeployTweaks,
                        },
                        description = "timeMinuteRandomMin",
                        help = "?",
                    },
                    {
                        name = "crDeployTweaksTimeMinuteRandomMax",
                        type="ivar",
                        setting = {
                            save=IvarProc.CATEGORY_EXTERNAL,
                            range=this.infiniteRange,
                            default=60,
                            OnChange=this.RecomputeDeployTweaks,
                        },
                        description = "timeMinuteRandomMax",
                        help = "?",
                    },
                },
            },
            -- [[ == DEBUG == ]]
            {name = "crDebugMenu",
                type = "menu",
                debug = true,
                setting = {},
                description = "Debug menu",
                help = "A developer-only menu settings.",
                children = {
                    {
                        name = "gOREHardLoadCheckPoint",
                        type = "command",
                        setting = {
                            command = "ChetRippo.GOREHardLoadCheckPoint",
                        },
                        description = "Hard Reload",
                        help = "Reload from last checkpoint + reload scripts.",
                    },
                    {
                        name = "gORESaveCheckPoint",
                        type = "command",
                        setting = {
                            command = "ChetRippo.GORESaveCheckPoint",
                        },
                        description = "Save CheckPoint",
                        help = "Convenient place to save before a reload.",
                    },
                    {
                        name = "gOREDumpAllToFile",
                        type = "command",
                        setting = {
                            command = "ChetRippo.GOREDumpAllToFile",
                        },
                        description = "Dump: To File",
                        help = "Dump the global state to a timestamped file named \"gore_dump_\" in the /mod/ directory.",
                    },
                },
            },
        },
    },
}

local namespace = "ChetRippo"
function this.GenerateIvars(parentMenu, depthIndex, depthValue)
    local depthName = depthValue.name
    InfCore.PrintInspect(depthValue, {varName=(parentMenu or '[unparented]') .. " => (" .. tostring(depthName) .. ": " .. tostring(depthValue) .. ")"})
    this.langStrings.eng[depthName] = depthValue.description
    this.langStrings.help.eng[depthName] = depthValue.help
    local allow_menu = (depthValue.debug == true and this.debugModule == true) or (depthValue.debug ~= true)
    -- (this.debugModule and (depthValue.debug == this.debugModule)) or (this.debugModule and (depthValue.debug == this.debugModule))
    
    
    if depthValue.type ~= nil and depthValue.type == "menu" then
        if allow_menu then
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
        end
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

--[[ === EVERYTHING ABOVE WAS BOILERPLATE THIS IS WHERE THE REAL CODE LIVES === ]]
--[[ === UTILITY === ]]

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
        --InfCore.Log("found foxTable "..k)--DEBUGNOW
        if type(k)=="string" then
          if not skipKeys[k] then
            local foxTableArray=foxTable[arrayIdent]
            if foxTableArray then
              varsTable[k]={}
              local arrayCount=foxTable[arrayCountIdent]
              --InfCore.Log("arrayCount="..arrayCount)--DEBUGNOW
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
    InfCore.Log("DumpSaveVars inputVars==nil")
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
  -- InfCore.Log("WriteTable "..fileName)

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

function this.MapValue(val, inMin, inMax, outMin, outMax)
    return outMin + (outMax - outMin) * ((val-inMin)/(inMax-inMin))
end

local clone = function(t)
    local rtn = {}
    for k, v in pairs(t) do rtn[k] = v end
    return rtn
end
function this.GetAvailableGMP(includeOnline)
    local totalGMP = TppMotherBaseManagement.GetGmp()
    if Tpp.IsOnlineMode() and includeOnline then
        totalGMP = totalGMP - vars.mbmServerWalletGmp
    end

    return totalGMP
end

function this.RecomputeDeployTweaks()
    -- InfCore.Log("#&#&#&# we are recomputing Deploy Tweaks", true, "debug")
    if this.vars.interceptedDeployMissionBasicParams ~= nil then
        -- InfCore.Log("%=%=%=% ben of drill", true, "debug")
        local live = this.vars.livingDeployMissionBasicParams

        live.missionListRefreshTimeMinute = Ivars.crDeployTweaksBPmissionListRefreshTimeMinute:Get()
        live.drawCountPerSr = Ivars.crDeployTweaksBPdrawCountPerSr:Get()
        live.drawCountPerR = Ivars.crDeployTweaksBPdrawCountPerR:Get()
        live.powerTransitVehicle = Ivars.crDeployTweaksBPpowerTransitVehicle:Get()
        live.powerBattleVehicle = Ivars.crDeployTweaksBPpowerBattleVehicle:Get()
        live.powerWalkerGear = Ivars.crDeployTweaksBPpowerWalkerGear:Get()
        live.powerBattleGear = Ivars.crDeployTweaksBPpowerBattleGear:Get()
        live.minusWinRateTransitVehicle = Ivars.crDeployTweaksBPminusWinRateTransitVehicle:Get()
        live.minusWinRateBattleVehicle = Ivars.crDeployTweaksBPminusWinRateBattleVehicle:Get()
        live.minusWinRateWalkerGear = Ivars.crDeployTweaksBPminusWinRateWalkerGear:Get()
        live.minusWinRateBattleGear = Ivars.crDeployTweaksBPminusWinRateBattleGear:Get()
        live.winRateMin = Ivars.crDeployTweaksBPwinRateMin:Get()
        live.winRateMax = Ivars.crDeployTweaksBPwinRateMax:Get()
        live.deadRateMin = Ivars.crDeployTweaksBPdeadRateMin:Get()
        live.deadRateMax = Ivars.crDeployTweaksBPdeadRateMax:Get()
        live.deadRateUpDownCorrection = Ivars.crDeployTweaksBPdeadRateUpDownCorrection:Get()
        live.teamStaffCountMin = Ivars.crDeployTweaksBPteamStaffCountMin:Get()
    
        InfCore.PrintInspect(live,{varName="$+$+$+$ Basic Mission Params"})
    
        this.wrap.TppMotherBaseManagement__RegisterDeployBasicParam(live)
    end

    for mission_id, mission_params in pairs(this.vars.interceptedDeployMissionParams) do
        local mdead = this.vars.interceptedDeployMissionParams[mission_id]
        local mlive = this.vars.livingDeployMissionParams[mission_id]
        --local mode = Ivars.crDeployTweaksDeadRateMode:Get()

        --[[
            winRateMin = 5,
            winRateMax = 100,
            deadRateMin = 0,
            deadRateMax = 0,
        ]]

        --[[
            baseWinRate = 50,
            deadRate = 20,
            timeMinute = 120,
            timeMinuteRandom = 60,
        ]]

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
            Ivars.crDeployTweaksTimeMinuteMin:Get(),
            Ivars.crDeployTweaksTimeMinuteMax:Get()
        )
        mlive.timeMinuteRandom = this.MapValue(mdead.timeMinuteRandom,
            this.vars.timeMinuteRandomMin,
            this.vars.timeMinuteRandomMax,
            Ivars.crDeployTweaksTimeMinuteRandomMin:Get(),
            Ivars.crDeployTweaksTimeMinuteRandomMax:Get()
        )

        --[[
        if mode == 0 then
            live.deadRate = math.floor(dead.deadRate * 2)
        elseif mode == 1 then
            live.deadRate = math.floor(dead.deadRate * (Ivars.crDeployTweaksDeadRateValue:Get()/100))
        elseif mode == 2 then
            live.deadRate = math.floor(Ivars.crDeployTweaksDeadRateValue:Get())
        end
        ]]

        -- InfCore.Log("#=#=#=# recomputing ["..mode.."] a Deploy Tweak: deployMissionId="..live.deployMissionId..",deadRate="..live.deadRate, true, "debug")

        this.wrap.TppMotherBaseManagement__RegisterDeployMissionParam(mlive)
    end
    --TppMotherBaseManagement.ResetDeploySvars()
end
function this.BankPrintGMP()
    InfCore.Log("Current Balance CRB [GMP "..tostring(igvars.crBalance).."]", true, "debug")
end
function this.BankDepositGMP()
    local totalGMP = this.GetAvailableGMP(true)

    --InfCore.Log("wallet=" .. tostring(vars.mbmServerWalletGmp) .. ",totalGMP="..tostring(totalGMP)..",getGMP="..tostring(TppMotherBaseManagement.GetGmp()), true, "debug")

    local actionableGMP = math.min(math.max(totalGMP,0), math.max(Ivars.crChetRippoBux:Get(),0))
    
    InfCore.Log("Deposited To CRB [GMP -"..tostring(actionableGMP).."]", true, "debug")
    igvars.crBalance = igvars.crBalance + actionableGMP

    TppTerminal.UpdateGMP({gmp=-actionableGMP})
end
function this.BankWithdrawGMP()
    local totalGMP = this.GetAvailableGMP()
    local maxWithdraw = this.CONSTS.MAX_LOCAL_GMP - totalGMP
    --InfCore.Log("wallet=" .. tostring(vars.mbmServerWalletGmp) .. ",totalGMP="..tostring(totalGMP)..",getGMP="..tostring(TppMotherBaseManagement.GetGmp())..",maxWithdraw="..tostring(maxWithdraw), true, "debug")

    local actionableGMP = math.min(math.max(Ivars.crChetRippoBux:Get(),0), math.max(maxWithdraw,0))

    --InfCore.Log("wallet=" .. tostring(vars.mbmServerWalletGmp) .. ",totalGMP="..tostring(totalGMP)..",getGMP="..tostring(TppMotherBaseManagement.GetGmp())..",maxWithdraw="..tostring(maxWithdraw)..",actionableGMP="..tostring(actionableGMP), true, "debug")
    
    InfCore.Log("Withdrew From CRB [GMP +"..tostring(actionableGMP).."]", true, "debug")
    igvars.crBalance = igvars.crBalance - actionableGMP

    TppTerminal.UpdateGMP({gmp=actionableGMP})
end

function this.HandleHygieneEvent(hygieneEvent)
    if hygieneEvent == this.CONSTS.HYGIENE_EVENT_SHOWER then
        igvars.crProvisionalShowerLastUsed = TppScriptVars.GetTotalPlayTime()
        -- we don't need to do anything because they already got showered
    elseif hygieneEvent == this.CONSTS.HYGIENE_EVENT_TOILET then
        this.CleanPlayer()
    elseif hygieneEvent == this.CONSTS.HYGIENE_EVENT_DUMPSTER then
        this.DirtyPlayer()
    end
end
function this.CleanPlayer() -- cheat
    if Ivars.crProvisionalShowerEnable:Is(0) then return end
    local previousUse = igvars.crProvisionalShowerLastUsed or 0
	local currentUse = TppScriptVars.GetTotalPlayTime()
    local timeBetweenUse = math.max(60*Ivars.crProvisionalShowerWallMinutesBetweenUses:Get(),0)
    if (currentUse - previousUse) > timeBetweenUse then
        igvars.crProvisionalShowerLastUsed = currentUse
        local mostRecentTimeOut = vars.passageSecondsSinceOutMB
        local logText = "Physically and Mentally Refreshed"
        Player.ResetDirtyEffect()
        Player.SetWetEffect()

        local newTimeOut = math.max(0, mostRecentTimeOut - (Ivars.crProvisionalShowerReduceDeployTime:Get()*60*60))
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
    if Ivars.crProvisionalShowerDumpsterEnable:Is(0) then return end

    local mostRecentTimeOut = vars.passageSecondsSinceOutMB
    local logText = "Physically and Mentally Drained"
    Player.SetWetEffect()

    local newTimeOut = math.max(0, mostRecentTimeOut + (Ivars.crProvisionalShowerDumpsterDirtinessIncreaseDeployTime:Get()*60*60))
    vars.passageSecondsSinceOutMB = newTimeOut -- 60*60*24*3 
    if vars.passageSecondsSinceOutMB >= (60*60*24*3) then
        logText = "Completely " .. logText
    end
    TppUiCommand.AnnounceLogView(logText)
end


function this.DemoOverride()
    if Ivars.crProvisionalShowerReallowQuietShowerCutscene:Get(1) and
        TppDemo.IsPlayedMBEventDemo("SnakeHasBadSmell_000") then
        TppDemo.ClearPlayedMBEventDemoFlag("SnakeHasBadSmell_000")
    end
end

function this.CrProvisionalShowerSniffCheck()
    local daysUnbathed = (vars.passageSecondsSinceOutMB/60/60/24)
    local unstinkAmount = Ivars.crProvisionalShowerReduceDeployTime:Get()*60*60

    local previousUse = igvars.crProvisionalShowerLastUsed or 0
	local currentUse = TppScriptVars.GetTotalPlayTime()
    local timeBetweenUse = math.max(60*Ivars.crProvisionalShowerWallMinutesBetweenUses:Get(),0)
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

    TppUiCommand.AnnounceLogView("smallFlyLevel="..tostring(Player.GetSmallFlyLevel())..",rawStink="..tostring(vars.passageSecondsSinceOutMB)..",canBathe="..tostring(canBathe))
    TppUiCommand.AnnounceLogView("daysUnbathed="..tostring(daysUnbathed)..",previousUse="..tostring(previousUse)..",now="..tostring(currentUse))
    TppUiCommand.AnnounceLogView("timeBetweenUse="..tostring(timeBetweenUse)..",unstinkAmount="..tostring(unstinkAmount))
    TppUiCommand.AnnounceLogView(outText)
end

function this.OnFadeInForShower()
    this.DemoOverride()
end

function this.OnFadeIn()
    if Ivars.crDeathGmpLossEnable:Is(0) then return end
    local totalGMP = this.GetAvailableGMP(Ivars.crDeathGmpLossIncludeGlobal:Is(0))

	if this.vars.crDeathGmpLossValidDeath and totalGMP > 0 then
        local cost = math.floor(totalGMP * (Ivars.crDeathGmpLossPercentage:Get()/100))

        if cost > 0 then
            TppTerminal.UpdateGMP({gmp=-cost})
            TppUiCommand.AnnounceLogView("[Medical]: Resuscitation Supplies [GMP -" .. tostring(cost) .. "]")
        end
		TppMission.UpdateCheckPointAtCurrentPosition()
	end
	this.vars.crDeathGmpLossValidDeath = false
end

function this.OnFulton(gameObjectId, gimmckInstance, gimmckDataSet, staffID)
    if Ivars.crInfinityFultons:Is(1) and svars.FulltonCount ~= nil then
        svars.FulltonCount = svars.FulltonCount + 1 
    end
    -- svars.trm_missionFultonCount
    --TppMotherBaseManagement.DirectAddStaff{ staffId=staffID, section = "Develop" }
end

function this.OnDeath(playerId,deathTypeStr32)
    -- InfCore.Log("[dead] playerId="..tostring(playerId)..",deathType="..deathTypeStr32, true, "debug")
    if Ivars.crDeathGmpLossEnable:Is(0) then return end
	if (deathTypeStr32~=InfCore.StrCode32("FallDeath")) and 
		(deathTypeStr32~=InfCore.StrCode32("Suicide")) and 
		(not TppMission.IsFOBMission(vars.missionCode)) then
		this.vars.crDeathGmpLossValidDeath = true
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
    --[[
    vars.ammoStockCounts[16] = 54000
    vars.ammoStockCounts[17] = 54000
    vars.totalBatteryPowerAsGmp = 61525
    ]]
    --TppPlayer.SetMissionStartAmmoCount()
    --InfCore.Log("oy")
end

function this.Rebuild()
    this.registerIvars={}
    this.registerMenus={}
    this.langStrings={
        eng={},
        help={
            eng={},
        },
    }
    --this.GenerateIvars(nil, nil, this.ultraVars)
    for var, value in pairs(this.ultraVars) do
        this.GenerateIvars(nil, var, value)
    end
    -- InfCore.PrintInspect(this, {varName="ChetRippo"})
    -- @TODO: rebuild all lookups in here
end
function this.EmergencySuppressorBuyNow()
    this.GiveSuppressor()
end
function this.GiveSuppressor()
    local cost = Ivars.crEmergencySuppliesSuppressorsCost:Get()
    if Ivars.crEmergencySuppliesSuppressorsEnable:Is(0) or this.GetAvailableGMP() < cost then return end
    local equipName = "EQP_AB_Suppressor"--=categoryTable[math.random(#categoryTable)]
    local equipId=TppEquip[equipName]

    local linearMax=0.1
    local angularMax=4
    local dropOffsetY=1.2

    -- tax fraud scam please ignore
    --[[
    local newBird = GameObject.CreateGameObjectId("TppCritterBird", 42069)
    GameObject.SendCommand(newBird,{id="SetEnabled",enabled=true})
    GameObject.SendCommand(newBird,{id="SetPosition",position=TppPlayer.GetPosition(),rotY=0})
    GameObject.SendCommand(newBird,{id="SetResourceType",type=TppCollection.TYPE_DIAMOND_LARGE})
    ]]

    local dropPosition=TppPlayer.GetPosition()
    if not dropPosition then
        InfCore.Log("[WAR] WARNING: ChetRippo.GiveSuppressor: GetPosition nil for desperate attempt :(((")
    end
    if dropPosition then
        dropPosition=Vector3(dropPosition[1],dropPosition[2]+dropOffsetY,dropPosition[3])
        thing = TppPickable.DropItem({
            equipId=equipId,
            number=number,
            position=dropPosition,
            rotation=Quat.RotationY(0),
            linearVelocity=Vector3(math.random(-linearMax,linearMax),math.random(-linearMax,linearMax),math.random(-linearMax,linearMax)),
            angularVelocity=Vector3(math.random(-angularMax,angularMax),math.random(-angularMax,angularMax),math.random(-angularMax,angularMax)),
        })
        TppSoundDaemon.PostEvent("sfx_s_item_appear")
        InfCore.Log("[Support]: Emergency Suppressor Deployed [GMP -"..tostring(cost).."]", true, "debug")
        TppTerminal.UpdateGMP({gmp=-cost})

        -- tax fraud scam plese ignore
        --[[
        GameObject.SendCommand(thing,{id="SetEnabled",enabled=true})
        GameObject.SendCommand(thing,{id="SetPosition",position=TppPlayer.GetPosition(),rotY=0})
        GameObject.SendCommand(thing,{id="SetResourceType",type=TppCollection.TYPE_DIAMOND_LARGE})
        ]]
    end
end

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
            {msg="Damage",func=this.HurtBird}
        },
        ]]
        GameObject={
            {msg="Fulton",func=this.OnFulton},
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
        UI = {
            {msg="EndFadeIn",sender="FadeInOnStartMissionGame",func=this.OnFadeIn}, 
            {msg="EndFadeIn",sender="FadeInOnGameStart",func=this.OnFadeIn},
            {msg="EndFadeIn",sender="FadeInOnStartMissionGame",func=this.OnFadeInForShower}, 
            {msg="EndFadeIn",sender="FadeInOnGameStart",func=this.OnFadeInForShower},
            {msg="EndFadeOut",sender="OnEstablishMissionClearFadeOut",func=this.DemoOverride},
        },
    })
    -- InfCore.PrintInspect(dinko, {varName="dinko"})
    return dinko
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.CaptureRegisterDeployBasicParam(basic_params)
    this.vars.interceptedDeployMissionBasicParams = basic_params
    this.vars.livingDeployMissionBasicParams = clone(basic_params)

    if next(this.vars.interceptedDeployMissionBasicParams) ~= nil then
        InfCore.Log("VXVXVX initiating parameters", true, "debug")
    else
        InfCore.Log("VXVXVX called again?", true, "debug")
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
        this.wrap.TppTerminal__AddVolunteerStaffs(...)
    end
    -- else: buzz off
end
function this.WrapIsUsedRankLimitedItem(...)
    if Ivars.crResultAllowRankRestrictedItems:Is(1) then
        this.wrap.TppResult__IsUsedRankLimitedItem(...)
    end
    -- else: buzz off
end

--[[
function this.ExploreWrap(...)
    local data = {...}
    local mission_param = data[1]
    
    InfCore.Log("#explorewrap: found DeployMissionParam:", true, "debug")
    InfCore.PrintInspect(...)
    if mission_param.deployMissionId ~= nil then
        mission_param.latitude = 27.87
        mission_param.longitude = -82.74
        -- mission_param.deadRate = 100
        this.vars.interceptedDeployMissionParams[mission_param.deployMissionId] = mission_param
        this.vars.livingDeployMissionParams[mission_param.deployMissionId] = clone(mission_param)
    else
        InfCore.Log("#explorewrap: this next param is fucked up:", true, "debug")
        InfCore.PrintInspect(...)
    end

    this.wrap.TppMotherBaseManagement__RegisterDeployMissionParam(this.vars.livingDeployMissionParams[mission_param.deployMissionId])
end
]]
if this.wrap.TppMotherBaseManagement__RegisterDeployBasicParam == nil then
    InfCore.Log("#*#*#*# GODZILLA MOMENT -- wrapping RegisterDeployBasicParam the first time", true, "debug")
    this.wrap.TppMotherBaseManagement__RegisterDeployBasicParam = TppMotherBaseManagement.RegisterDeployBasicParam
    TppMotherBaseManagement.RegisterDeployBasicParam = this.CaptureRegisterDeployBasicParam
else
    InfCore.Log("#*#*#*# GODZILLA MOMENT -- wrapping RegisterDeployBasicParam a second time!!!", true, "debug")
end
if this.wrap.TppMotherBaseManagement__RegisterDeployMissionParam == nil then
    InfCore.Log("#*#*#*# GAMERA MOMENT -- wrapping RegisterDeployMissionParam the first time", true, "debug")
    this.wrap.TppMotherBaseManagement__RegisterDeployMissionParam = TppMotherBaseManagement.RegisterDeployMissionParam
    TppMotherBaseManagement.RegisterDeployMissionParam = this.CaptureRegisterDeployMissionParam
else
    InfCore.Log("#*#*#*# GAMERA MOMENT -- wrapping RegisterDeployMissionParam a second time!!!", true, "debug")
end
if this.wrap.TppTerminal__AddVolunteerStaffs == nil then
    this.wrap.TppTerminal__AddVolunteerStaffs = TppTerminal.AddVolunteerStaffs
    TppTerminal.AddVolunteerStaffs = this.WrapAddVolunteerStaffs
else
    InfCore.Log("#*#*#*# GAMERA MOMENT -- wrapping this.WrapAddVolunteerStaff a second time!!!", true, "debug")
end
if this.wrap.TppResult__IsUsedRankLimitedItem == nil then
    this.wrap.TppResult__IsUsedRankLimitedItem = TppResult.IsUsedRankLimitedItem
    TppResult.IsUsedRankLimitedItem = this.WrapIsUsedRankLimitedItem
else
    InfCore.Log("#*#*#*# GAMERA MOMENT -- wrapping this.WrapIsUsedRankLimitedItem a second time!!!", true, "debug")
end

--[[
function this.ExploreWrap2(...)
    local data = {...}
    InfCore.Log("#explorewrap: found RegisterDeployBasicParam:", true, "debug")
    InfCore.PrintInspect(...)

    this.wrap.TppMotherBaseManagement__RegisterDeployBasicParam(unpack(data))
end
if this.wrap.TppMotherBaseManagement__RegisterDeployBasicParam == nil then
    this.wrap.TppMotherBaseManagement__RegisterDeployBasicParam = TppMotherBaseManagement.RegisterDeployBasicParam
    TppMotherBaseManagement.RegisterDeployBasicParam = this.ExploreWrap2
end
]]




function this.Init(missionTable)
  --this.Rebuild()
  this.messageExecTable=nil
  this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())

  this.RecomputeDeployTweaks()
  --this.Rebuild()
end

this.OnReload = this.Init
-- we have to do this part as early as possible for ivar related reasons
this.Rebuild()

return this