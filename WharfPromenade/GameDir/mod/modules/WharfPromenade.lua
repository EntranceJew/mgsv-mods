local this = {
    debugModule = true,
}
--[[ == RESOURCE NAMES ==
Heroism
    Fame Increased
        [Holdups]
GMP
]]


--[[ LANGSTRINGS ]]
this.langStrings={
    eng={
        wpMenu="Wharf Promenade menu",
        wpGeneralPrint="Print whatever is assigned right now",
    },--eng
    help={
        eng={
            wpMenu="This is where I keep shit that isn't ready to go.",
            wpGeneralPrint="Prints something, probably.",
        },
    }--help
}--langStrings

-- [[ MENUS ]]
this.registerMenus={
    "wpMenu",
}
this.wpMenu={
    parentRefs={"InfMenuDefs.safeSpaceMenu","InfMenuDefs.inMissionMenu"},
    options={
        "WharfPromenade.WpGeneralPrint",
    },
}

this.loudencer = function(input)
    local mt = input or {}
    setmetatable(mt, {
        __index = function(tbl,key)
            InfCore.Log("[LOUDENCER] index ("..tostring(tbl)..")=>["..tostring(key).."]", false, "debug")
        end,
        __newindex = function(tbl,key,val)
            InfCore.Log("[LOUDENCER] index ("..tostring(tbl)..")=>["..tostring(key).."] == ["..tostring(val) .. "]", false, "debug")
        end,
        -- __mode
        __call = function(tbl, ...)
            local think = "[LOUDENCER] call ("..tostring(tbl)..")=>["
            for i=1,select("#",...) do
                think = think .. tostring(i) .. ":" .. tostring(select(i,...)) .. ","
            end
            InfCore.Log(think .. "]", false, "debug")
        end,
        -- __metatable
        __tostring = function(tbl)
            InfCore.Log("[LOUDENCER] tostringing something!", false, "debug")
            return "[LOUDENCER]"
        end,
        __len = function(tbl)
            InfCore.Log("[LOUDENCER] len ("..tostring(tbl)..")", false, "debug")
            return 1
        end,
        -- FoxEngine? __rt
        -- FoxEngine? __as
        -- FoxEngine? __vi

        -- __pairs
        -- __ipairs
        -- __next
        -- __gc
        -- __name
        -- __close
        -- __unm
        -- __add
        -- __sub
        -- __mul
        -- __div
        -- __idiv
        -- __mod
        -- __pow
        -- __concat
        -- __band
        -- __bor
        -- __bxor
        -- __bnot
        -- __shl
        -- __shr
        -- __eq
        -- __lt
        -- __le
    })
    return mt
end

function this.Rebuild()
    -- @TODO: rebuild all lookups in here
end

-- notably this only sets the category, either the mission itself or some other
-- qualifier populates what gets said about each of these, presumably from interrogating
-- the gameId of the tagged object directly

--[[ == THINGS THAT DON'T HAVE IDS THAT I TOTALLY EXPECTED TO HAVE THEM ==
- Claymores
- The pods salad-throws-puss spawn to search you out
- inflatable Decoys
- child soldiers [just regular SOLDIER2s]
- anything to do with the factory in VOICES (volgin, mantis, water explosives, the victims)
]]
this.KnownRadioIDs = {
    -- [Decoy] ?
    -- ...
    [3]  = "Heavy Machine Gun [Gun Emplacement]",
    [4]  = "Mortar Launcher [Mortar]",
    [5]  = "Anti-Aircraft Gun [Anti-Air Cannon]",
    [6]  = "Communications Equipment [Transmitter]",
    [7]  = "Power Generator (Outdoors)",
    [8]  = "Power Generator (GZ)",
    [9]  = "Communications Radar [Antenna]",
    -- ...
    [11] = "Searchlight",
    [12] = "Surveillance Camera [Surveillance Camera]",
    [13] = "Target Container (Code Talker's Materials) [Container]",
    -- ...
    [15] = "IR-Sensors",
    [16] = "PF Soldier / Child Soldier", -- from Mission 22: RETAKE THE PLATFORM
    [17] = "Anti-Air Radar",
    [18] = "Dumpster [Dumpster]",
    [19] = "Metal Drum (Explosive)",
    [20] = "Portable Toilet [Toilet]",
    [21] = "Skull Soldier", -- Quiet / Skull Sniper / Armor Skull ",
    -- ...
    [23] = "Anti-Theft Device / Alarm Trigger",
    [24] = "Temporary Shower Unit [Shower]", -- from Over the Fence
    [25] = "Gun Camera [Gun Camera]",
    [26] = "UAV [UAV]", -- from YELLOW ASSET
    [27] = "Military Four-Wheel Drive [Four-Wheel Drive]",
    [28] = "Military Truck [Truck]",
    [29] = "Armored Vehicle (APC) [Armored Vehicle]",
    [30] = "Tank",
    [31] = "Walker Gear (Empty) [Walker Gear]",
    [32] = "Walker Gear (Manned) [Walker Gear]",
    [33] = "CFA Soldier [CFA Soldier]",
    [34] = "Rogue Coyote Soldier [Rogue Coyote Soldier]",
    [35] = "Zero Risk Security Soldier [ZRS Soldier]",
    [36] = "XOF Soldier [XOF Soldier]",
    [37] = "Puppet Soldier [Puppet Soldier]",
    -- ...
    [40] = "Gerbil", -- animal
    [41] = "Long-eared Hedgehog [Rodent]", --animal
    [42] = "Four-toed Hedgehog [Rodent]", -- [TBD, NEVER HAS FUNCTIONAL RADIO?]
    [43] = "Afghan Pika [Rabbit]", -- animal
    [44] = "Raven [Bird]", -- animal
    [45] = "Trumpeter Hornbill [Bird]", -- animal
    [46] = "Oriental Stork [Bird]", -- animal [TBD, NEVER HAS FUNCTIONAL RADIO]
    [47] = "Black Stork [Bird]", -- animal
    [48] = "Jehuty [Jehuty]", -- animal
    [49] = "Griffon Vulture [Bird]", -- animal
    [50] = "Lappet-faced Vulture [Bird]", -- animal
    [51] = "Martial Eagle [Bird]", --animal
    [52] = "Cashmere Goat [Goat]", -- animal
    [53] = "Karakul Sheep [Sheep]", -- animal
    [54] = "Nubian Goat [Goat]", -- animal
    [55] = "Boer Goat [Goat]", -- animal
    [56] = "Wild Ass [Donkey]", -- animal
    [57] = "Zebra [Horse]", -- animal
    [58] = "Okapi [Okapi]", -- animal
    [59] = "Gray Wolf [Wolf]", --animal
    [60] = "African Wild Dog [Wolf]", --animal
    [61] = "Side-striped Jackal [Jackal]", --animal
    [62] = "Anubis [Anubis]", --animal
    [63] = "Brown Bear [Bear]", --animal
    [64] = "Himalayian Brown Bear [Himalayian Brown Bear]", --animal
    [65] = "Soviet Soldier [Soviet Soldier]",
    -- ...
    [4294967295] = "Invalid", -- should be "-1", usually set by some sort of override
}

function this.WpGeneralPrint()
    --[[
    local outtbl = {}
    for i = 0, GameObject.NULL_ID, 1 do
        local out = InfLookup.ObjectNameForGameId(i)
        outtbl[i] = out
    end
    --InfCore.PrintInspect(TppScriptVars.GetTotalPlayTime(),{varName="GetTotalPlayTime"})
    ]]
    --[[
    InfCore.PrintInspect(ChetRippo.vars.livingResourceParam,{varName="AssBlaster"})
    for k, v in pairs(ChetRippo.vars.livingResourceParam) do
        local usable = TppMotherBaseManagement.GetResourceUsableCount({
            resource=k
        })
        InfCore.Log("hunk: [" .. k .. "] x "..usable .. ", (" .. v.baseSalePrice.. ")")
    end

    TppMotherBaseManagement.SaleResource{resource="BioticResource",count=3,isNew=true}
    ]]

    
    InfCore.PrintInspect(TppWeather, {varName="TppWeather"})
    InfCore.PrintInspect(InfWeather, {varName="InfWeather"})
    --InfCore.PrintInspect(ChetRippo.vars, {varName="ChetRippo.vars"})
    --InfCore.PrintInspect(TppResult, {varName="TppResult"})

    --for missionCodeStr,enum in pairs(TppDefine.MISSION_ENUM)do
    if Player.IsStaffInSortie(PlayerInfo.GetLocalPlayerIndex()) then
        InfCore.Log("staff in sortie !!! ", true, "trace")
    else
        InfCore.Log("no staff in sortie ... ", true, "trace")
    end

    if vars.playerType == PlayerType.DD_FEMALE or vars.playerType == PlayerType.DD_MALE then
        local staffId = Player.GetStaffIdAtInstanceIndex(PlayerInfo.GetLocalPlayerIndex())
        --InfCore.Log("is DD, got staffId="..tostring(staffId).." ... ", true, "trace")

        --InfCore.Log("gunning down ... ", true, "trace")
        --TppMotherBaseManagement.SetRemoverReason(this.loudencer, this.loudencer, this.loudencer, this.loudencer)

        --[[
        InfCore.Log("attempting crossing 1 ... TppMotherBaseManagement.AddStaffMeritMedalPointByStaffId", true, "trace")
        --InfCore.Log("murder attempted ... ", true, "trace")
        TppMotherBaseManagement.AddStaffMeritMedalPointByStaffId(this.loudencer({staffId=staffId,addPoint=99}), this.loudencer(), this.loudencer(), this.loudencer())
        InfCore.Log("attempting crossing 2 ... TppMotherBaseManagement.AwardedHonorMedalToStaff", true, "trace")
        TppMotherBaseManagement.AwardedHonorMedalToStaff (this.loudencer({staffId=staffId}), this.loudencer(), this.loudencer(), this.loudencer())
        InfCore.Log("attempting crossing 3 ... TppMotherBaseManagement.AwardedMeritMedalPointToPlayerStaff", true, "trace")
        TppMotherBaseManagement.AwardedMeritMedalPointToPlayerStaff(this.loudencer({clearRank=TppDefine.MISSION_CLEAR_RANK.S}), this.loudencer(), this.loudencer(), this.loudencer())
        InfCore.Log("attempting crossing 4 ... TppMotherBaseManagement.AwardedMeritMedalPointToStaff", true, "trace")
        TppMotherBaseManagement.AwardedMeritMedalPointToStaff(this.loudencer({staffId=staffId}), this.loudencer(), this.loudencer(), this.loudencer())
        InfCore.Log("attempting crossing 5 ... TppMotherBaseManagement.BanHeuy", true, "trace")
        TppMotherBaseManagement.BanHeuy (this.loudencer(), this.loudencer(), this.loudencer(), this.loudencer())
        ]]

        -- >>> YOU WERE HERE LOOK HERE THIS IS WHAT YOU WERE DOING IGNORE EVERYTHING ELSE <<<
        --[[
        InfCore.Log("attempting crossing 1 ... TppMotherBaseManagement.GetOutOnMotherBaseStaffs", true, "trace")
        local di = {TppMotherBaseManagement.GetOutOnMotherBaseStaffs(this.loudencer({sectionId=TppMotherBaseManagementConst.SECTION_COMBAT}),this.loudencer(),this.loudencer(),this.loudencer())}
        InfCore.Log("was ... " .. tostring(type(di)), true, "trace")
        InfCore.PrintInspect(di, {varName="TppMotherBaseManagement.GetOutOnMotherBaseStaffs"})
        ]]

        --[[
        InfCore.Log("attempting crossing 2 ... DesDaemon.PrintDesObjectAll", true, "trace")
        local x = DesDaemon.PrintDesObjectAll(di)
        InfCore.Log("was ... " .. tostring(type(x)), true, "trace")
        InfCore.PrintInspect(x, {varName="DesDaemon.PrintDesObjectAll"})
        ]]

        --[[
            TppMotherBaseManagement.SetStaffCrossMedalByStaffId({staffId=0,got=bool})
            
            TppMotherBaseManagement.SetStaffHonorMedalByStaffId({staffId=0,got=bool})
            TppMotherBaseManagement.AwardedHonorMedalToPlayerStaff() --no signature
            TppMotherBaseManagement.AwardedHonorMedalToStaff({staffId=0})

            TppMotherBaseManagement.AddStaffMeritMedalPointByStaffId({staffId=0,addPoint=number?})
            TppMotherBaseManagement.AwardedMeritMedalPointToPlayerStaff({clearRank=number?})
            TppMotherBaseManagement.AwardedMeritMedalPointToStaff({staffId=0,addPoint=number?}) --checks staffId before proceeding

            CaptureCage.GetCaptureAnimalList() --no signature

            DesDaemon.GetInstance() --no signature, returns userdata<Des.DesDaemon:Entity>
            DesDaemon.PrintDesObjectAll(Entity) --returns userdata

            HudCommonDataManager.GetInstance() --returns userdata
        ]]
    end

    --TppUiCommand.SetGameOverType( "Cyprus" )
    --TppMission.ShowGameOverMenu{}
    --InfCore.PrintInspect(ChetRippo.vars,{varName="ChetRippo.vars"})
end 

-- igvars?

function this.OnScanRadioTarget(gameId, radioTargetId)
    if this.KnownRadioIDs[radioTargetId] == nil then
        InfCore.Log("#^#^# New Tag '" .. radioTargetId .. "': " .. tostring(gameId), true, "debug")
    else
        InfCore.Log("Looking At A '" .. this.KnownRadioIDs[radioTargetId] .. "': " ..  tostring(gameId), true, "debug")
    end
end

function this.Messages()
    return Tpp.StrCode32Table({
        Radio={
            {msg="EspionageRadioCandidate",func=this.OnScanRadioTarget}
        },
        GameObject={
            {msg="Damage",func=function(...)
                --this.HurtBird(...)
                --this.WolfPissed(...)
            end}
        },
    })
end

function this.OnMessage(sender, messageId, arg0, arg1, arg2, arg3, strLogText)
    Tpp.DoMessage(this.messageExecTable, TppMission.CheckMessageOption, sender, messageId, arg0, arg1, arg2, arg3, strLogText)
end

function this.Init(missionTable)
  this.Rebuild()
  this.messageExecTable=nil
  this.messageExecTable = Tpp.MakeMessageExecTable(this.Messages())
end

this.OnReload = this.Init
return this