--[[ == VERSION HISTORY ==

    1.0     - Initial Release
    1.1     - Added weighted random distribution. Higher yields, occasionally.
            - Fixed bug preventing the rarity mode paying out correctly.
            - Added detailed resource logging mode in the iDROID.
	1.2		- Corrected some vehicles being identified as a Gerbil.
	        - Added additional radio information to the database.

]]

--[[ == MISSION BY MISSION ANIMAL AVAILABILITY ==
    00  PROLGUE: AWAKENING
    01  PHANTOM LIMBS
    02  DIAMOND DOGS
        Black Stork
            If you can get to them somehow, they're out there. In the ocean.

    03  A HERO'S WAY


    04  C2W
        Gray Wolves
            (In valley between Eastern Communications Outpost) [Respawns]
        Ravens
            (Everywhere, but particularly over the Eastern Communications Outpost)

    05  OVER THE FENCE
        Gerbil 
            (Wakh Sind Barracks, Underground, Skylight Room)
            (Wakh Sind Barracks, On the concrete slab near the awning by all the containers)
        Ravens
            (In the air, above Wakh Sind Barracks)
            (Perched on the billboards above where the Karakul Sheep spawn)
        Brown Bear
            (Near left-most helicopter landing option / mission briefing post)
        Karakul Sheep
            (Anywhere between outpost 09 and Wakh Sind Barracks)

    06  WHERE DO THE BEES SLEEP?

    07  RED BRASS
        Ravens
        Karakul Sheep

    08  OCCUPATION FORCES
    09  BACKUP, BACK DOWN
        Raven
            (Above the start point north of Yakho Oboo Supply Outpost)


    10  ANGEL WITH BROKEN WINGS
        Long-eared Hedgehog
            (In one of the cells at the Lamar Kaahte Palace)
            (On the ground floor of Lamar Kaahte Palace)
        Griffon Vulture
            (Flying near the northern cliffs around Lamar Kaahte Palace)
            (Perched on a rock north of Yakho Oboo Supply Outpost)
        Karakul Sheep
            (North of Yakho Oboo Supply Outpost)

    11  CLOAKED IN SILENCE
        Afghan Pika
            (Near the spot where Quiet jumps to after being defeated, under the crawlspace)
            (Near the buildings up on the cliffside, across the river, on the North-West part of the map)

    12  HELLBOUND
    ..
    15  FOOTPRINTS OF PHANTOMS
        Nubian Goat
            (Right out in the open, as usual.)
        
        Boer Goat
            (To the right of outpost 15)

        Trumpeter Hornbill
            (Flying above the "Cradle of Spirits")
    ..
    30  SKULL FACE
        Afghan Pika
            (In the grassy parts of OKB Zero)

        Raven
            (Flying above OKB Zero)

    31  SAHELANTHROPUS
    32  TO KNOW TOO MUCH
        Griffon Vultures
            (around Da Shago Kallai, in great quantities)


        Long-eared Hedgehog
            (inside Da Shago Kallai, by the shelves)
   /33/
   /34/
    ..
    38  EXTRAORDINARY
   /39/
   /40/
    ..
    45  A QUIET EXIT
    ..
   /49/
   /50/
    51  HUEY'S EXILE
]]

local this = {
    debugModule = false,
    unknownGimmickIds = {
        0, -- jeep, or a rat shaped gerbil
        25602, -- human getting abudcted in a vehicle
        25607, -- 
        65535, -- human
        4064465703, -- turret
        2165395217, -- other turret
        2165395217, -- another turret
        2165395217, -- another turret
        1853533060, -- turret
        3436548607, -- big anti-air gun
        3436548607, -- big anti-air gun
        3380953481, -- mortar
        3380953481, -- mortar
        373126284, -- mortar
        373126284, -- mortar
        467170509, -- mortar
        467170509, -- mortar
        467170509, -- mortar
        1428066287, -- common metal (10,000)
        3989812181, -- biological materials (1500)
        1428066287, -- biological materials (1500)
        3500478141, -- biological materials (1500)
    },
    cageTiers = {
        [2] = {"C", "UC"},
        [3] = {"C", "UC", "R"},
        [4] = {"C", "UC", "R", "SR", "UR"},
    },
    plantNames = {
        [TppCollection.TYPE_HERB_B_CARROT]    = "Black Carrot",
        [TppCollection.TYPE_HERB_WORM_WOOD]   = "Wormwood",
        [TppCollection.TYPE_HERB_G_CRESCENT]  = "Golden Crescent",
        [TppCollection.TYPE_HERB_DIGITALIS_P] = "Digitalis (Purpurea)",
        [TppCollection.TYPE_HERB_TARRAGON]    = "Tarragon",
        [TppCollection.TYPE_HERB_A_PEACH]     = "African Peach",
        [TppCollection.TYPE_HERB_HAOMA]       = "Haoma",
        [TppCollection.TYPE_HERB_DIGITALIS_R] = "Digitalis (Lutea)",
    },
    rarityTiers = {
        "C", "UC", "R", "SR", "UR"
    },
    rarityBasedTiers = {
        afgh = {
            C = {
                [TppCollection.TYPE_HERB_B_CARROT]    = 5,
            },
            UC = {
                [TppCollection.TYPE_HERB_WORM_WOOD]   = 5,
            },
            R = {

            },
            SR = {
                [TppCollection.TYPE_HERB_TARRAGON]    = 4,
            },
            UR = {
                [TppCollection.TYPE_HERB_HAOMA]       = 2,
            },
        },
        mafr = {
            C = {
                [TppCollection.TYPE_HERB_B_CARROT]    = 5,
            },
            UC = {
                [TppCollection.TYPE_HERB_WORM_WOOD]   = 5,
                [TppCollection.TYPE_HERB_G_CRESCENT]  = 5,
            },
            R = {
                [TppCollection.TYPE_HERB_DIGITALIS_P] = 4,
            },
            SR = {
                [TppCollection.TYPE_HERB_A_PEACH]     = 4,
            },
            UR = {
                [TppCollection.TYPE_HERB_DIGITALIS_R] = 2,
            },
        },
    },
    animalEncyclopedia = {
        [1]  = {
            name = "Gerbil",
            mapName = "???",
            regions = {"afgh", "mafr"},
            rarity = "C",
            fulton = false,
            carry = true,
            trap = true,
            value = 500,
            ids = {
                0, -- gerbils in mission 38 have this?
                1, -- anml_rat_00
            },
            radioTargetId = 40,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_RAT,
            -- appears everywhere in both maps
        },
        [2]  = {
            -- ALLEGEDLY in mission 10
            name = "Long-eared Hedgehog",
            mapName = "Rodent",
            regions = {"afgh"},
            rarity = "UC",
            fulton = false,
            carry = true,
            trap = true,
            value = 2000,
            ids = {
                4, -- anml_rat_01
            },
            radioTargetId = 41, 
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_RAT,
        },
        [3]  = {
            name = "Four-toed Hedgehog",
            mapName = "Rodent",
            regions = {"mafr"},
            rarity = "UC",
            fulton = false,
            carry = true,
            trap = true,
            value = 2000,
            ids = {
                5, -- anml_rat_02
            },
            radioTargetId = 42, -- ???
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_RAT,
            -- appears everywhere
        },
        [4]  = {
            -- can be found to carry in Mission 11
            name = "Afghan Pika",
            mapName = "Rabbit",
            regions = {"afgh"},
            rarity = "R",
            fulton = false,
            carry = true,
            trap = true,
            value = 5000,
            ids = {
                6, -- anml_rat_01, anml_rat_02, anml_rat_03, anml_rat_04
            },
            radioTargetId = 43, -- ???
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_RAT,
        },
        [5]  = {
            name = "Common Raven",
            mapName = "Bird",
            regions = {"afgh", "mafr"},
            rarity = "C",
            fulton = false,
            carry = true,
            trap = true,
            value = 500,
            ids = {
                7,
            },
            radioTargetId = 44,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_CRITTER_BIRD,
        },
        [6]  = {
            -- appear East of outpost 15 during Mission FOOTPRINTS OF PHANTOMS, and on the mountain
            -- also appear at Nova Braga airport during Mission TRAITORS' CARAVAN
            name = "Trumpeter Hornbill",
            mapName = "Bird",
            regions = {"mafr"},
            rarity = "C",
            fulton = false,
            carry = true,
            trap = true,
            value = 500,
            ids = {
                8,
            },
            radioTargetId = 45,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_CRITTER_BIRD,
        },
        [7]  = {
            -- found during Mission 21
            -- also found above the mansion in CURSED LEGACY
            name = "Black Stork",
            mapName = "Bird",
            regions = {"afgh", "mafr"},
            rarity = "R",
            fulton = false,
            carry = true,
            trap = true,
            value = 5000,
            ids = {
                10,
            },
            radioTargetId = 47,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_STORK,
            -- these are all the plants in the Mission 21 area
            -- there are about 5 or so of them 
            drops = {
                [TppCollection.TYPE_HERB_DIGITALIS_P] = 4,
                [TppCollection.TYPE_HERB_A_PEACH]     = 5,
                [TppCollection.TYPE_HERB_B_CARROT]    = 7,
                [TppCollection.TYPE_HERB_WORM_WOOD]   = 7,
            },
        },
        [8]  = {
            -- only? available during Mission 11
            name = "Oriental Stork",
            mapName = "Bird",
            regions = {"afgh"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = true,
            value = 500,
            ids = {
                9,
            },
            radioTargetId = 46, --- ???
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_STORK,
            -- all plant pickups inside of its mission FOM
            drops = {
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 1,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 2,
                [TppCollection.TYPE_HERB_TARRAGON]   = 2,
            },
        },
        [9]  = {
            -- only available during Side Op 49
            name = "Jehuty",
            mapName = "Jehuty",
            regions = {"mafr"},
            rarity = "UR",
            fulton = false,
            carry = true,
            trap = false,
            value = 200000,
            ids = {
                11, -- anml_quest_00
            },
            radioTargetId = 48,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_STORK,
            -- these are all the plants in the FOM for its sideop,
            -- but most notably it prefers to perch near Digitalis (Lutea)
            drops = {
                [TppCollection.TYPE_HERB_DIGITALIS_R] = 1,
                [TppCollection.TYPE_HERB_DIGITALIS_P] = 3,
                [TppCollection.TYPE_HERB_A_PEACH]     = 3,
                [TppCollection.TYPE_HERB_B_CARROT]    = 7,
                [TppCollection.TYPE_HERB_WORM_WOOD]   = 9,
            },
        },
        [10] = {
            -- available in the Spugmay Keep during Mission 38
            -- encyclopedia habitat information is only accurate for Mission 8
            name = "Griffon Vulture",
            mapName = "Bird",
            regions = {"afgh"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = true,
            value = 50000,
            ids = {
                12,
            },
            radioTargetId = 49,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_EAGLE,
            -- all plant pickups in side the escape zone of Mission 38
            drops = {
                -- rough diamonds (L)
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 8,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 3,
                [TppCollection.TYPE_HERB_B_CARROT]   = 7,
                [TppCollection.TYPE_HERB_TARRAGON]   = 5,
            },
        },
        [11] = {
            -- NOT available during Mission 18 in their habitat, available pretty much anywhere else
            name = "Lappet-faced Vulture",
            mapName = "Bird",
            regions = {"mafr"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = true,
            value = 500,
            ids = {
                13,
            },
            radioTargetId = 50,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_EAGLE,
            -- from its stated habitat, despite it not appearing there
            drops = {
                [TppCollection.TYPE_HERB_DIGITALIS_P] = 1,
                [TppCollection.TYPE_HERB_A_PEACH]     = 2,
                [TppCollection.TYPE_HERB_B_CARROT]    = 1,
                [TppCollection.TYPE_HERB_WORM_WOOD]   = 2,
            },
        },
        [12] = {
            -- found during mission 24 in its stated habitat
            name = "Martial Eagle",
            mapName = "Bird",
            regions = {"mafr"},
            rarity = "R",
            fulton = true,
            carry = false,
            trap = true,
            value = 5000,
            ids = {
                14,
            },
            drops = {
                [TppCollection.TYPE_HERB_DIGITALIS_P] = 6,
                [TppCollection.TYPE_HERB_A_PEACH]     = 1,
                [TppCollection.TYPE_HERB_B_CARROT]    = 5,
                [TppCollection.TYPE_HERB_WORM_WOOD]   = 9,
            },
            radioTargetId = 51,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_EAGLE,
        },
        [13] = {
            name = "Karakul Sheep",
            mapName = "???",
            regions = {"afgh"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                23,
                24, -- anml_goat_01
                25,
                26,
                27, -- anml_goat_00
                28,
                29,
                30,
            },
            radioTargetId = 53,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_GOAT,
            -- drops from its largest habitat in free-roam
            drops = {
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 7,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 7,
                [TppCollection.TYPE_HERB_TARRAGON]   = 1,
            },
            -- drops from its southernmost habitat in free-roam
            drops2 = {
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 2,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 4,
                [TppCollection.TYPE_HERB_TARRAGON]   = 3,
                [TppCollection.TYPE_HERB_HAOMA]      = 1,
            },
            -- drops from its southwest habitat south of Yakho Oboo Supply Outpost in free-roam
            drops3 = {
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 1,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 4,
                [TppCollection.TYPE_HERB_HAOMA]      = 1,
            },
            -- drops from its northwest habitat north of Yakho Oboo Supply Outpost in free-roam
            drops4 = {
                [TppCollection.TYPE_HERB_HAOMA]      = 1,
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 1,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 1,
                [TppCollection.TYPE_HERB_B_CARROT]   = 1,
                [TppCollection.TYPE_HERB_TARRAGON]   = 1,
            },
        },
        [14] = {
            name = "Cashmere Goat",
            mapName = "Goat",
            regions = {"afgh"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                15,
                16,
                17,
                18,
                19, -- assuming
                20,
                21,
                22,
            },
            radioTargetId = 52,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_GOAT,
            -- drops from its habitat of Aabe Shifap Ruins in free-roam
            drops = {
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 2,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 3,
                [TppCollection.TYPE_HERB_B_CARROT]   = 4,
            },
            -- drops from its habitat east of Da Shago Kallah in free-roam
            drops2 = {
                [TppCollection.TYPE_HERB_WORM_WOOD]  = 13,
                [TppCollection.TYPE_HERB_G_CRESCENT] = 6,
                [TppCollection.TYPE_HERB_B_CARROT]   = 3,
                [TppCollection.TYPE_HERB_TARRAGON]   = 2,
            },
        },
        [15] = {
            name = "Nubian",
            mapName = "Goat",
            regions = {"mafr"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                31, -- CONFIRMED NUBIAN
                32,
                33,
                34,
                35,
                36,
                37,
                38,
                39,
                40,
                41,
                42,
                43,
                44, 
                45, 
                46, -- CONFIRMED NUBIAN
            },
            radioTargetId = 54,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_NUBIAN,
        },
        [16] = {
            name = "Boer Goat",
            mapName = "Goat",
            regions = {"mafr"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                47, -- CONFIRMED BOER
                48,
                49,
                50, 
                51,
                52,
                53,
                54,
                55,
                56,
                57,
                58,
                59,
                60,
                61, -- CONFIRMED BOER
                62,
            },
            radioTargetId = 55,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_NUBIAN,
        },
        [17] = {
            name = "Wild Ass",
            mapName = "Donkey",
            regions = {"afgh", "mafr"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                63, -- anml_Zebra_00, anml_Zebra_01
            },
            radioTargetId = 56,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_ZEBRA,
        },
        [18] = {
            name = "Grant's Zebra",
            mapName = "Horse",
            regions = {"mafr"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                64, -- anml_Zebra_02
            },
            radioTargetId = 57,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_ZEBRA,
        },
        [19] = {
            name = "Okapi",
            mapName = "Okapi",
            regions = {"mafr"},
            rarity = "SR",
            fulton = true,
            carry = false,
            trap = false,
            value = 50000,
            ids = {
                65, -- anml_Zebra_00, anml_Zebra_01
            },
            radioTargetId = 58,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_ZEBRA,
            drops = {
                -- Okapi has no plants inside its spawn radius near the Kungenga Mine :(
            },
        },
        [20] = {
            name = "Gray Wolf",
            mapName = "Wolf",
            regions = {"afgh"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                66, --anml_wolf_00
            },
            radioTargetId = 59,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_WOLF,
        },
        [21] = {
            name = "African Wild Dog",
            mapName = "Wolf",
            regions = {"mafr"},
            rarity = "R",
            fulton = true,
            carry = false,
            trap = false,
            value = 5000,
            ids = {
                67, --anml_jackal_00, anml_jackal_01
            },
            radioTargetId = 60,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_JACKAL,
        },
        [22] = {
            name = "Side-striped Jackal",
            mapName = "Jackal",
            regions = {"mafr"},
            rarity = "C",
            fulton = true,
            carry = false,
            trap = false,
            value = 500,
            ids = {
                68, --anml_jackal_02
            },
            radioTargetId = 61,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_JACKAL,
            -- is of TppGameObject.GAME_OBJECT_TYPE_WOLF when spawned in Anubis' pack
        },
        [23] = {
            name = "Anubis",
            mapName = "Anubis",
            regions = {"mafr"},
            rarity = "SR",
            fulton = true,
            carry = false,
            trap = false,
            value = 50000,
            ids = {
                69,
            },
            radioTargetId = 62,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_WOLF,
        },
        [24] = {
            name = "Brown Bear",
            mapName = "Bear",
            regions = {"afgh"},
            rarity = "R",
            fulton = true,
            carry = false,
            trap = false,
            value = 5000,
            ids = {
                70, --anml_bear_00
            },
            radioTargetId = 63,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_BEAR,
        },
        [25] = {
            name = "Himalayan Brown Bear",
            mapName = "Himalayian Brown Bear",
            regions = {"afgh"},
            rarity = "SR",
            fulton = true,
            carry = false,
            trap = false,
            value = 50000,
            ids = {
                71, --anml_bear_01
            },
            radioTargetId = 64,
            gameObjectType = TppGameObject.GAME_OBJECT_TYPE_BEAR,
        },
        [26] = {
            name = "Deathstalker",
            regions = {"afgh"},
            rarity = "C",
            fulton = false,
            carry = false,
            trap = true,
            value = 500,
        },
        [27] = {
            name = "Emperor Scorpion",
            regions = {"mafr"},
            rarity = "C",
            fulton = false,
            carry = false,
            trap = true,
            value = 500,
        },
        [28] = {
            name = "Oriental Ratsnake",
            regions = {"afgh"},
            rarity = "UC",
            fulton = false,
            carry = false,
            trap = true,
            value = 2000,
        },
        [29] = {
            name = "Black Mamba",
            regions = {"mafr"},
            rarity = "UC",
            fulton = false,
            carry = false,
            trap = true,
            value = 2000,
        },
        [30] = {
            name = "Tsuchinoko",
            regions = {"mafr"},
            rarity = "UR",
            fulton = false,
            carry = false,
            trap = true,
            value = 200000,
        },
        [31] = {
            name = "Rainbow Agama",
            regions = {"mafr"},
            rarity = "UC",
            fulton = false,
            carry = false,
            trap = true,
            value = 2000,
        },
        [32] = {
            name = "Namaqua Chameleon",
            regions = {"mafr"},
            rarity = "R",
            fulton = false,
            carry = false,
            trap = true,
            value = 5000,
        },
        [33] = {
            name = "Leopard Gecko",
            regions = {"afgh"},
            rarity = "C",
            fulton = false,
            carry = false,
            trap = true,
            value = 500,
        },
        [34] = {
            name = "African Fat-tailed Gecko",
            regions = {"mafr"},
            rarity = "C",
            fulton = false,
            carry = false,
            trap = true,
            value = 500,
        },
        [35] = {
            name = "African Bullfrog",
            regions = {"mafr"},
            rarity = "R",
            fulton = false,
            carry = false,
            trap = true,
            value = 5000,
        },
        [36] = {
            name = "Russian Tortoise",
            regions = {"afgh"},
            rarity = "UC",
            fulton = false,
            carry = false,
            trap = true,
            value = 2000,
        },
        [37] = {
            name = "Leopard Tortise",
            regions = {"mafr"},
            rarity = "UC",
            fulton = false,
            carry = false,
            trap = true,
            value = 2000,
        },
        [38] = {
            name = "Bechstein's Bat",
            regions = {"afgh"},
            rarity = "C",
            fulton = false,
            carry = false,
            trap = true,
            value = 500,
        },
        [39] = {
            name = "Rock Hyrax",
            regions = {"mafr"},
            rarity = "R",
            fulton = false,
            carry = false,
            trap = true,
            value = 5000,
        },
        [40] = {
            name = "Tree Pangolin",
            regions = {"mafr"},
            rarity = "SR",
            fulton = false,
            carry = false,
            trap = true,
            value = 50000,
        },
        [41] = {
            name = "Sand Cat",
            regions = {"afgh"},
            rarity = "R",
            fulton = false,
            carry = false,
            trap = true,
            value = 5000,
        },
        [42] = {
            name = "Caracal",
            regions = {"afgh"},
            rarity = "SR",
            fulton = false,
            carry = false,
            trap = true,
            value = 50000,
        },
        [43] = {
            name = "African Civet",
            regions = {"mafr"},
            rarity = "SR",
            fulton = false,
            carry = false,
            trap = true,
            value = 50000,
        },
        [44] = {
            name = "Marsh Mongoose",
            regions = {"mafr"},
            rarity = "SR",
            fulton = false,
            carry = false,
            trap = true,
            value = 50000,
        },
        [45] = {
            name = "Red Fox",
            regions = {"afgh"},
            rarity = "R",
            fulton = false,
            carry = false,
            trap = true,
            value = 5000,
        },
        [46] = {
            name = "Blanford's Fox",
            regions = {"afgh"},
            rarity = "SR",
            fulton = false,
            carry = false,
            trap = true,
            value = 50000,
        },
        [47] = {
            name = "Honey Badger",
            regions = {"afgh", "mafr"},
            rarity = "SR",
            fulton = false,
            carry = false,
            trap = true,
            value = 50000,
        },
    },

    -- [[ TEMP TABLES ]]
    animalLookup = {},
    rarityLookup = {},
    rarityTierCount = 0,
}

--[[ IVARS ]]
this.registerIvars={
    "farUseWeightedRandom",
    "farRarityResourceScale",
    "farLogResources",
}
this.farUseWeightedRandom={
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    default=1,
    settingNames="set_switch",
}
this.farRarityResourceScale={
    save=IvarProc.EXTERNAL,
    default=(1/3)*100,
    range={max=200,min=0,increment=1},
    isPercent=true,
}
this.farLogResources={
    save=IvarProc.CATEGORY_EXTERNAL,
    range=Ivars.switchRange,
    default=1,
    settingNames="set_switch",
}

--[[ LANGSTRINGS ]]
this.langStrings={
    eng={
        farMenu="Fultoned Animal Resources menu",
        farUseWeightedRandom="Use weighted random",
        farRarityResourceScale="Rarity based resource scaling",
        farLogResources="Log resource collection",
    },--eng
    help={
        eng={
            farMenu="Options for bonus resources upon extracting animals.",
            farUseWeightedRandom="Whether to use a random chance to roll for each possible plant rather than restricting it strictly to matching ranks.",
            farRarityResourceScale="A multiplier on the amount of resources received from an animal. This applies to every rarity tier.",
            farLogResources="Whether to log in the iDROID the resources an animal collects for us.",
        },
    }--help
}--langStrings

-- [[ MENUS ]]
this.registerMenus={
    "farMenu",
}
this.farMenu={
    parentRefs={"InfMenuDefs.inMissionMenu"},
    options={
        "Ivars.farUseWeightedRandom",
        "Ivars.farRarityResourceScale",
        "Ivars.farLogResources",
    },
}

-- make it more difficult to roll beneath this value based on number of options
-- see: https://www.desmos.com/calculator/optj2625xr
function this.GetCocaine(i, plusL, plusB, plusM)
    local plusL = plusL or 0
    local plusB = plusB or 0
    local plusM = plusM or 0

    local l = this.rarityTierCount + plusL
    local b = (1 - (1/l)) + plusB
    local m = ((-1/l) + (1/(l*(l-1)))) + plusM

    local y = m*(i-1) + b

    return y
end

-- make it easier to get a higher value based on number of options
-- see: https://www.desmos.com/calculator/1gkrdxxj8e
function this.GetOppositeOfCocaine(i, plusL, plusB, plusM)
    local plusL = plusL or 0
    local plusB = plusB or 0
    local plusM = plusM or 0

    local l = this.rarityTierCount + plusL
    local b = (1/l) + plusB
    local m = ((1/l) - (1/(l*(l-1)))) + plusM

    local y = m*(i-1) + b

    return y
end

local perc = function(n, d)
    local d = d or 0
    return string.format("%."..tostring(d).."f%%", n*100)
end

function this.GiveResource(gameId, animalId)
    if this.animalLookup[animalId] ~= nil and Tpp.IsAnimal(gameId) then
        local animal = this.animalEncyclopedia[ this.animalLookup[animalId] ]
        local res = ""

        local animalName = animal.name

        local payout = {}
        for _, region in pairs(animal.regions) do
            local regionalPay = this.rarityBasedTiers[ region ]
            for rarityIndex, rarity in ipairs(this.rarityTiers) do
                for item, quantity in pairs(regionalPay[rarity]) do
                    local resItem = TppTerminal.RESOURCE_INFORMATION_TABLE[item]
                    if resItem ~= nil then
                        if payout[item] == nil then
                            payout[item] = 0
                        end

                        local obtained = quantity * resItem.count

                        if Ivars.farUseWeightedRandom:Is(1) then
                            local roll = math.random()
                            local challenge = this.GetCocaine(rarityIndex)
                            local pass = roll <= challenge
                            local overkill = (challenge - roll)
                            local spice = overkill + this.GetOppositeOfCocaine(this.rarityLookup[ animal.rarity ])
                            local base = obtained
                            obtained = math.max(0, math.ceil(base * spice))

                            if pass then
                                payout[item] = payout[item] + obtained
                            end

                            if Ivars.farLogResources:Is(1) and this.debugModule then
                                InfCore.Log("[FAR]: " .. (pass and 'PASS' or 'FAIL') .. " '" .. this.plantNames[item] .. "': roll=" .. perc(roll) .. ",challenge=" .. perc(challenge) .. ",spice=" .. perc(spice,2) .. ",base=" .. base .. ",obtained=" .. obtained, true)
                            end
                        else
                            payout[item] = payout[item] + obtained
                            -- stop paying out once we get max rarity
                            if rarity == animal.rarity then break end
                        end
                    end
                end
            end
        end

        local resourceScale = (Ivars.farRarityResourceScale:Get()/100)
        local thingsGot = {}
        local gotAny = false
        for item, quantity in pairs(payout) do
            local resItem = TppTerminal.RESOURCE_INFORMATION_TABLE[item]
            if resItem ~= nil then
                local c = math.floor(quantity * resourceScale)

                if c > 0 then
                    gotAny = true
                    table.insert(thingsGot, c .. "x" .. this.plantNames[item])
                    TppMotherBaseManagement.AddTempResource({resource=resItem.resourceName,count=c})
                end
            end
        end
        if Ivars.farLogResources:Is(1) then
            if gotAny then
                InfCore.Log("[Support]: Captured animal '" .. animalName .. "' had resources: " .. table.concat(thingsGot, ", "), true)
            else
                InfCore.Log("[Support]: Captured animal '" .. animalName .. "' had no resources.", true)
            end
        end


        --[[
        if animal.drops ~= nil then
            for k, v in pairs(animal.drops) do
                if TppTerminal.RESOURCE_INFORMATION_TABLE[k] ~= nil then
                    local n = TppTerminal.RESOURCE_INFORMATION_TABLE[k].resourceName
                    local c = TppTerminal.RESOURCE_INFORMATION_TABLE[k].count * math.random(1,v)

                    res = res .. " " .. n .. "(" .. c .. ")"
                    TppMotherBaseManagement.DirectAddResource({
                        resource=n,
                        count=c,
                        isNew=false
                    })
                end
            end
            InfCore.Log("#!#!# Got Resources From " .. tostring(animalId) .. ": " .. res, true, "debug")
        else
            InfCore.Log("#!#!# Animal Had No Configured Drops: "..tostring(gameId).." ["..animalId.."] ", true, "warn")    
        end 
        ]]       
    end
end

function this.OnFulton(gameId,gimmickInstanceOrAnimalId, gimmickDataSet, staffIdOrResourceId)
    --if this.debugModule then
        --InfLookup.PrintStatus(gameId)
    --end

    if this.debugModule then
        local theName = ''
        if this.animalLookup[gimmickInstanceOrAnimalId] ~= nil then
            local animal = this.animalEncyclopedia[ this.animalLookup[gimmickInstanceOrAnimalId] ]
            
            theName = animal.name
        end

        theName = theName .. "=" .. table.concat({InfLookup.ObjectNameForGameId(gameId)}, "|")
        local typeIndex = GameObject.GetTypeIndex(gameId)
        local typeStr = InfLookup.TppGameObject.typeIndex[typeIndex]

        local debuggerboy = theName .. "[al=" .. tostring(this.animalLookup[gimmickInstanceOrAnimalId]) .. ",gid=" .. gimmickInstanceOrAnimalId .. ",typeIndex=" .. tostring(typeIndex) .. ",typeStr=" .. typeStr .."]"

        InfCore.Log("[FAL]: A '" .. debuggerboy .. "' was something I stole.", true, "debug")
    end

    -- GAME_OBJECT_TYPE_RAT

    if this.animalLookup[gimmickInstanceOrAnimalId] ~= nil then
        this.GiveResource(gameId,gimmickInstanceOrAnimalId)
    --else
        --InfCore.Log("#!#!# Unknown Animal For Resources: "..tostring(gameId) .. " > " .. tostring(GameObject.GetTypeIndex(gameId)).." ["..gimmickInstanceOrAnimalId.."] ", true, "warn")
    end
end

function this.Rebuild()
    -- @TODO: loop through animal table, build short-lookup for IDs
    this.animalLookup = {}
    for encId, animal in pairs(this.animalEncyclopedia) do
        if animal.ids ~= nil then
            for _, animalId in ipairs(animal.ids) do
                this.animalLookup[animalId] = encId
            end
        end
    end

    this.rarityLookup = {}
    for rarityIndex, rarity in ipairs(this.rarityTiers) do
        this.rarityLookup[ rarity ] = rarityIndex
        this.rarityTierCount = rarityIndex
    end
end


function this.Messages()
    local dinko = Tpp.StrCode32Table({
        GameObject={
            {msg="Fulton",func=this.OnFulton},
        },
    })
    InfCore.PrintInspect(dinko)
    return dinko
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