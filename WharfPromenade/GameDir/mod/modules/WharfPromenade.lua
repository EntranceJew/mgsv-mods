local this = {
    debugModule = true,
}

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
    -- ...
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
    --InfCore.PrintInspect(ChetRippo,{varName="ChetRippo"})
end 

-- igvars?

function this.OnScanRadioTarget(gameId, radioTargetId)
    if this.KnownRadioIDs[radioTargetId] == nil then
        InfCore.Log("#^#^# New Tag '" .. radioTargetId .. "': " .. tostring(gameId), true, "debug")
    else
        InfCore.Log("Looking At A '" .. this.KnownRadioIDs[radioTargetId] .. "': " ..  tostring(gameId), true, "debug")
    end
end

function this.HurtBird(damagedId, attackId, attackerId)
    local damagedType = GameObject.GetTypeIndex(damagedId)
    if damagedType == TppGameObject.GAME_OBJECT_TYPE_CRITTER_BIRD then
        local equipName = "EQP_SWP_Grenade_G05"
        local equipId=TppEquip[equipName]

        InfCore.DebugPrint("Bird had a '"..equipName..'". Why? Funy.')--DEBUG

        local linearMax=0.1
        local angularMax=4
        local dropOffsetY=1.2

        local dropPosition=GameObject.SendCommand(damagedId,{id="GetPosition"})
        if not dropPosition then
            InfCore.Log("[WP] WARNING: WharfPromenade.HurtBird: GetPosition nil for damagedId:"..tostring(damagedId))

            dropPosition=GameObject.SendCommand(attackerId,{id="GetPosition"})
            if not dropPosition then
                InfCore.Log("[WP] WARNING: WharfPromenade.HurtBird: GetPosition nil for attackerId:"..tostring(attackerId))
            end

            
            dropPosition=TppPlayer.GetPosition()
            if not dropPosition then
                InfCore.Log("[WP] WARNING: WharfPromenade.HurtBird: GetPosition nil for desperate attempt :(((")
            end
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
        end
    end
end

function this.Messages()
    return Tpp.StrCode32Table({
        Radio={
            {msg="EspionageRadioCandidate",func=this.OnScanRadioTarget}
        },
        GameObject={
            {msg="Damage",func=this.HurtBird}
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