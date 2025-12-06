ctld = {} -- DONT REMOVE!

--- Identifier. All output in DCS.log will start with this.
ctld.Id = "CTLD - "

--- Version.
ctld.Version = "20250610"

-- debug level, specific to this module
ctld.Debug = false
-- trace level, specific to this module
ctld.Trace = true

ctld.alreadyInitialized = false -- if true, ctld.initialize() will not run

function ctld.i18n_translate(text, ...)
    local args = { ... }
    for i = 1, #args do
        text = string.gsub(text, "%%" .. i, tostring(args[i]))
    end
    return text
end
-- ************************************************************************
-- *********************  USER CONFIGURATION ******************************
-- ************************************************************************
ctld.staticBugWorkaround = false --  DCS had a bug where destroying statics would cause a crash. If this happens again, set this to TRUE


if ctld.Debug == false then
    ctld.UnitLimitPerPlayer = {
        ["主战坦克(Tank)"] = 4,
        ["步兵战车(IFV)"] = 3,
        ["远程火力(Artillery)"] = 5,
        ["近程防空(Short Range AA)"] = 3,
        ["中远程防空(Mid&Long Range AA)"] = 3,
        ["无人机、悍马JTAC、FOB等"] = 4,
    }
    ctld.logisticUnits = {}
    ctld.fobLocation = {}
    ctld.FOBLimit = 1
    ctld.CoalitionKillerLimit = 4 --红方的阵营级大杀器

    ctld.F10RefreshTime = 60
    ctld.disableAllSmoke = false -- if true, all smoke is diabled at pickup and drop off zones regardless of settings below. Leave false to respect settings below
    
    ctld.hoverPickup = false --  if set to false you can load crates with the F10 menu instead of hovering... Only if not using real crates!

    ctld.enableCrates = true -- if false, Helis will not be able to spawn or unpack crates so will be normal CTTS
    ctld.slingLoad = false -- if false, crates can be used WITHOUT slingloading, by hovering above the crate, simulating slingloading but not the weight...
    -- There are some bug with Sling-loading that can cause crashes, if these occur set slingLoad to false
    -- to use the other method.
    -- Set staticBugFix  to FALSE if use set ctld.slingLoad to TRUE

    ctld.enableSmokeDrop = false -- if false, helis and c-130 will not be able to drop smoke

    ctld.maxExtractDistance = 125 -- max distance from vehicle to troops to allow a group extraction
    ctld.multiCrateMaxDistance = 100 --生成一个组需要的箱子之间的最大距离
    ctld.maximumDistanceLogistic = 200 -- max distance from vehicle to logistics to allow a loading or spawning operation
    ctld.maximumSearchDistance = 4000 -- max distance for troops to search for enemy
    ctld.maximumMoveDistance = 2000 -- max distance for troops to move from drop point if no enemy is nearby

    ctld.minimumDeployDistance = 900 -- minimum distance from a friendly pickup zone where you can deploy a crate
    ctld.minimumDistanceBetweenFobs = 1
    ctld.spawnRPGWithCoalition = true --spawns a friendly RPG unit with Coalition forces
    ctld.spawnStinger = false -- spawns a stinger / igla soldier with a group of 6 or more soldiers!

    ctld.enabledFOBBuilding = true -- if true, you can load a crate INTO a C-130 than when unpacked creates a Forward Operating Base (FOB) which is a new place to spawn (crates) and carry crates from
    -- In future i'd like it to be a FARP but so far that seems impossible...
    -- You can also enable troop Pickup at FOBS
    ctld.cratesRequiredForFOB = 1 -- The amount of crates required to build a FOB. Once built, helis can spawn crates at this outpost to be carried and deployed in another area.
    -- The large crates can only be loaded and dropped by large aircraft, like the C-130 and listed in ctld.vehicleTransportEnabled
    -- Small FOB crates can be moved by helicopter. The FOB will require ctld.cratesRequiredForFOB larges crates and small crates are 1/3 of a large fob crate
    -- To build the FOB entirely out of small crates you will need ctld.cratesRequiredForFOB * 3
    ctld.troopPickupAtFOB = true -- if true, troops can also be picked up at a created FOB
    ctld.buildTimeFOB = 60 --time in seconds for the FOB to be built
    --ctld.crateWaitTime = 20 -- time in seconds to wait before you can spawn another crate
    ctld.crateWaitTime = 1
    ctld.forceCrateToBeMoved = false -- a crate must be picked up at least once and moved before it can be unpacked. Helps to reduce crate spam
    ctld.UseInfraRed = false
    ctld.unitActions = {
        --["SA342Mistral"] = {crates=true, troops=true},
        --["SA342L"] = {crates=true, troops=true},
        --["SA342M"] = {crates=true, troops=true},
        ["UH-1H"] = {crates=true, troops=true},
        ["Mi-8MT"] = {crates=true, troops=true},
        ["Mi-8MTV2"] = {crates=true, troops=true},
        ["Mi-24P"] = {crates=true, troops=true},
    }
    ctld.unloadTroopsTime = 10
else
    --测试用的参数
    ctld.UnitLimitPerPlayer = {
        ["主战坦克(Tank)"] = 2,
        ["步兵战车(IFV)"] = 2,
        ["远程火力(Artillery)"] = 2,
        ["近程防空(Short Range AA)"] = 2,
        ["无人机、悍马JTAC、FOB等"] = 2,
        ["中远程防空(Mid&Long Range AA)"] = 2,
    }
    ctld.logisticUnits = {
        -- "造船厂Blue",
        -- "造船厂Red",
    }--动态保存会刷新一次，所以不用手动添加了
    ctld.fobLocation = {}
    ctld.FOBLimit = 1
    ctld.CoalitionKillerLimit = 2 --红方的阵营级大杀器
    ctld.F10RefreshTime = 60
    ctld.IsCheckfarEnoughFromLogisticZone = false
    ctld.disableAllSmoke = false -- if true, all smoke is diabled at pickup and drop off zones regardless of settings below. Leave false to respect settings below

    ctld.hoverPickup = false --  if set to false you can load crates with the F10 menu instead of hovering... Only if not using real crates!

    ctld.enableCrates = true -- if false, Helis will not be able to spawn or unpack crates so will be normal CTTS
    ctld.slingLoad = false -- if false, crates can be used WITHOUT slingloading, by hovering above the crate, simulating slingloading but not the weight...
    -- There are some bug with Sling-loading that can cause crashes, if these occur set slingLoad to false
    -- to use the other method.
    -- Set staticBugFix  to FALSE if use set ctld.slingLoad to TRUE

    ctld.enableSmokeDrop = false -- if false, helis and c-130 will not be able to drop smoke

    ctld.maxExtractDistance = 125 -- max distance from vehicle to troops to allow a group extraction
    ctld.multiCrateMaxDistance = 100 --生成一个组需要的箱子之间的最大距离
    ctld.maximumDistanceLogistic = 1000 -- max distance from vehicle to logistics to allow a loading or spawning operation
    ctld.maximumSearchDistance = 4000 -- max distance for troops to search for enemy
    ctld.maximumMoveDistance = 2000 -- max distance for troops to move from drop point if no enemy is nearby

    ctld.minimumDeployDistance = 1 -- minimum distance from a friendly pickup zone where you can deploy a crate
    ctld.minimumDistanceBetweenFobs = 1
    ctld.spawnRPGWithCoalition = true --spawns a friendly RPG unit with Coalition forces
    ctld.spawnStinger = false -- spawns a stinger / igla soldier with a group of 6 or more soldiers!

    ctld.enabledFOBBuilding = true -- if true, you can load a crate INTO a C-130 than when unpacked creates a Forward Operating Base (FOB) which is a new place to spawn (crates) and carry crates from
    -- In future i'd like it to be a FARP but so far that seems impossible...
    -- You can also enable troop Pickup at FOBS
    ctld.cratesRequiredForFOB = 1 -- The amount of crates required to build a FOB. Once built, helis can spawn crates at this outpost to be carried and deployed in another area.
    -- The large crates can only be loaded and dropped by large aircraft, like the C-130 and listed in ctld.vehicleTransportEnabled
    -- Small FOB crates can be moved by helicopter. The FOB will require ctld.cratesRequiredForFOB larges crates and small crates are 1/3 of a large fob crate
    -- To build the FOB entirely out of small crates you will need ctld.cratesRequiredForFOB * 3
    ctld.troopPickupAtFOB = true -- if true, troops can also be picked up at a created FOB
    ctld.buildTimeFOB = 1 --time in seconds for the FOB to be built
    --ctld.crateWaitTime = 20 -- time in seconds to wait before you can spawn another crate
    ctld.crateWaitTime = 1
    ctld.forceCrateToBeMoved = false -- a crate must be picked up at least once and moved before it can be unpacked. Helps to reduce crate spam
	ctld.UseInfraRed = false
    ctld.unitActions = {
        --["SA342Mistral"] = {crates=true, troops=true},
        --["SA342L"] = {crates=true, troops=true},
        --["SA342M"] = {crates=true, troops=true},
        ["UH-1H"] = {crates=true, troops=true},
        ["Mi-8MT"] = {crates=true, troops=true},
        ["Mi-8MTV2"] = {crates=true, troops=true},
        ["Mi-24P"] = {crates=true, troops=true},
    }
    ctld.unloadTroopsTime = 10
end

ctld.numberOfTroops = 10 -- default number of troops to load on a transport heli or C-130 
-- also works as maximum size of group that'll fit into a helicopter unless overridden
ctld.enableFastRopeInsertion = true -- allows you to drop troops by fast rope
ctld.fastRopeMaximumHeight = 18.28 -- in meters which is 60 ft max fast rope (not rappell) safe height

ctld.vehiclesForTransportRED = { "BRDM-2", "BTR_D" } -- vehicles to load onto Il-76 - Alternatives {"Strela-1 9P31","BMP-1"}
ctld.vehiclesForTransportBLUE = { "M1045 HMMWV TOW", "M1043 HMMWV Armament" } -- vehicles to load onto c130 - Alternatives {"M1128 Stryker MGS","M1097 Avenger"}
ctld.vehiclesWeight = {
    ["BRDM-2"] = 7000,
    ["BTR_D"] = 8000,
    ["M1045 HMMWV TOW"] = 3220,
    ["M1043 HMMWV Armament"] = 2500
}

--ctld.aaLaunchers = 3 -- controls how many launchers to add to the kub/buk when its spawned.
--ctld.hawkLaunchers = 8 -- controls how many launchers to add to the hawk when its spawned.


ctld.radioSound = "beacon.ogg" -- the name of the sound file to use for the FOB radio beacons. If this isnt added to the mission BEACONS WONT WORK!
ctld.radioSoundFC3 = "beaconsilent.ogg" -- name of the second silent radio file, used so FC3 aircraft dont hear ALL the beacon noises... :)

ctld.deployedBeaconBattery = 30 -- the battery on deployed beacons will last for this number minutes before needing to be re-deployed

ctld.enabledRadioBeaconDrop = false -- if its set to false then beacons cannot be dropped by units

ctld.allowRandomAiTeamPickups = false -- Allows the AI to randomize the loading of infantry teams (specified below) at pickup zones

-- Simulated Sling load configuration

ctld.minimumHoverHeight = 7.5 -- Lowest allowable height for crate hover
ctld.maximumHoverHeight = 12.0 -- Highest allowable height for crate hover
ctld.maxDistanceFromCrate = 5.5 -- Maximum distance from from crate for hover
ctld.hoverTime = 10 -- Time to hold hover above a crate for loading in seconds

ctld.airDropHeight = 15
-- end of Simulated Sling load configuration

-- AA SYSTEM CONFIG --
-- Sets a limit on the number of active AA systems that can be built for RED.
-- A system is counted as Active if its fully functional and has all parts
-- If a system is partially destroyed, it no longer counts towards the total
-- When this limit is hit, a player will still be able to get crates for an AA system, just unable
-- to unpack them

--ctld.AASystemLimitRED = 20 -- Red side limit --不再使用阵营总计数
--ctld.AASystemLimitBLUE = 20 -- Blue side limit

ctld.UnitLimitPlayerInfo = {}
ctld.UnitLimitCoalitionInfo = {}

--END AA SYSTEM CONFIG --
-- ***************** JTAC CONFIGURATION *****************

--ctld.JTAC_LIMIT_RED = 9999 -- max number of JTAC Crates for the RED Side
--ctld.JTAC_LIMIT_BLUE = 9999 -- max number of JTAC Crates for the BLUE Side

ctld.JTAC_dropEnabled = true -- allow JTAC Crate spawn from F10 menu

ctld.JTAC_maxDistance = 10000 -- How far a JTAC can "see" in meters (with Line of Sight)

ctld.JTAC_smokeOn_RED = true -- enables marking of target with smoke for RED forces
ctld.JTAC_smokeOn_BLUE = true -- enables marking of target with smoke for BLUE forces

ctld.JTAC_smokeColour_RED = 4 -- RED side smoke colour -- Green = 0 , Red = 1, White = 2, Orange = 3, Blue = 4
ctld.JTAC_smokeColour_BLUE = 1 -- BLUE side smoke colour -- Green = 0 , Red = 1, White = 2, Orange = 3, Blue = 4

ctld.JTAC_jtacStatusF10 = true -- enables F10 JTAC Status menu

ctld.JTAC_location = true -- shows location of target in JTAC message
ctld.location_DMS = false -- shows coordinates as Degrees Minutes Seconds instead of Degrees Decimal minutes

ctld.JTAC_lock = "vehicle" -- "vehicle" OR "troop" OR "all" forces JTAC to only lock vehicles or troops or all ground units

ctld.JTAC_SearchObjectsCategory = { Object.Category.UNIT, Object.Category.STATIC } --jatc理论上也需要搜索FOB,但是目前毛都没有

-- ***************** Pickup, dropoff and waypoint zones *****************

-- Available colors (anything else like "none" disables smoke): "green", "red", "white", "orange", "blue", "none",

-- Use any of the predefined names or set your own ones

-- You can add number as a third option to limit the number of soldier or vehicle groups that can be loaded from a zone.
-- Dropping back a group at a limited zone will add one more to the limit

-- If a zone isn't ACTIVE then you can't pickup from that zone until the zone is activated by ctld.activatePickupZone
-- using the Mission editor

-- You can pickup from a SHIP by adding the SHIP UNIT NAME instead of a zone name

-- Side - Controls which side can load/unload troops at the zone

-- Flag Number - Optional last field. If set the current number of groups remaining can be obtained from the flag value

--pickupZones = { "Zone name or Ship Unit Name", "smoke color", "limit (-1 unlimited)", "ACTIVE (yes/no)", "side (0 = Both sides / 1 = Red / 2 = Blue )", flag number (optional) }
ctld.pickupZones = {
    { "pickzone1", "blue", -1, "yes", 0 },
    { "pickzone2", "red", -1, "yes", 0 },
    { "pickzone3", "none", -1, "yes", 0 },
    { "pickzone4", "none", -1, "yes", 0 },
    { "pickzone5", "none", -1, "yes", 0 },
    { "pickzone6", "none", -1, "yes", 0 },
    { "pickzone7", "none", -1, "yes", 0 },
    { "pickzone8", "none", -1, "yes", 0 },
    { "pickzone9", "none", 5, "yes", 1 }, -- limits pickup zone 9 to 5 groups of soldiers or vehicles, only red can pick up
    { "pickzone10", "none", 10, "yes", 2 }, -- limits pickup zone 10 to 10 groups of soldiers or vehicles, only blue can pick up

    { "pickzone11", "blue", 20, "no", 2 }, -- limits pickup zone 11 to 20 groups of soldiers or vehicles, only blue can pick up. Zone starts inactive!
    { "pickzone12", "red", 20, "no", 1 }, -- limits pickup zone 11 to 20 groups of soldiers or vehicles, only blue can pick up. Zone starts inactive!
    { "pickzone13", "none", -1, "yes", 0 },
    { "pickzone14", "none", -1, "yes", 0 },
    { "pickzone15", "none", -1, "yes", 0 },
    { "pickzone16", "none", -1, "yes", 0 },
    { "pickzone17", "none", -1, "yes", 0 },
    { "pickzone18", "none", -1, "yes", 0 },
    { "pickzone19", "none", 5, "yes", 0 },
    { "pickzone20", "none", 10, "yes", 0, 1000 }, -- optional extra flag number to store the current number of groups available in

    { "USA Carrier", "blue", 10, "yes", 0, 1001 }, -- instead of a Zone Name you can also use the UNIT NAME of a ship
}


-- dropOffZones = {"name","smoke colour",0,side 1 = Red or 2 = Blue or 0 = Both sides}
ctld.dropOffZones = {
    { "dropzone1", "green", 2 },
    { "dropzone2", "blue", 2 },
    { "dropzone3", "orange", 2 },
    { "dropzone4", "none", 2 },
    { "dropzone5", "none", 1 },
    { "dropzone6", "none", 1 },
    { "dropzone7", "none", 1 },
    { "dropzone8", "none", 1 },
    { "dropzone9", "none", 1 },
    { "dropzone10", "none", 1 },
}


--wpZones = { "Zone name", "smoke color",  "ACTIVE (yes/no)", "side (0 = Both sides / 1 = Red / 2 = Blue )", }
ctld.wpZones = {
    { "wpzone1", "green", "yes", 2 },
    { "wpzone2", "blue", "yes", 2 },
    { "wpzone3", "orange", "yes", 2 },
    { "wpzone4", "none", "yes", 2 },
    { "wpzone5", "none", "yes", 2 },
    { "wpzone6", "none", "yes", 1 },
    { "wpzone7", "none", "yes", 1 },
    { "wpzone8", "none", "yes", 1 },
    { "wpzone9", "none", "yes", 1 },
    { "wpzone10", "none", "no", 0 }, -- Both sides as its set to 0
}


-- ******************** Transports names **********************

-- Use any of the predefined names or set your own ones
ctld.transportPilotNames = {

    "【库塔伊西】蚊子（运输）R1-1",
    "【库塔伊西】蚊子（运输）R1-2",

    "【科尔奇】蚊子（运输）R1-1",
    "【科尔奇】蚊子（运输）R1-2",

    "【阿纳克里厄】蚊子（运输）R1-1",
    "【阿纳克里厄】蚊子（运输）R1-2",

    "【奥恰姆奇拉】蚊子（运输）R1-1",
    "【奥恰姆奇拉】蚊子（运输）R1-2",

    "【苏呼米】蚊子（运输）R1-1",
    "【苏呼米】蚊子（运输）R1-2",

    "【古达乌塔】蚊子（运输）R1-1",
    "【古达乌塔】蚊子（运输）R1-2",


    "【库塔伊西】野驴（运输）R1-1",
    "【库塔伊西】野驴（运输）R1-2",

    "【科尔奇】野驴（运输）R1-1",
    "【科尔奇】野驴（运输）R1-2",

    "【阿纳克里厄】野驴（运输）R1-1",
    "【阿纳克里厄】野驴（运输）R1-2",

    "【奥恰姆奇拉】野驴（运输）R1-1",
    "【奥恰姆奇拉】野驴（运输）R1-2",

    "【苏呼米】野驴（运输）R1-1",
    "【苏呼米】野驴（运输）R1-2",

    "【古达乌塔】野驴（运输）R1-1",
    "【古达乌塔】野驴（运输）R1-2",

    "【科尔奇】支奴干（运输）R1-1",
    "【科尔奇】支奴干（运输）R1-2",

    "【阿纳克里厄】支奴干（运输）R1-1",
    "【阿纳克里厄】支奴干（运输）R1-2",

    "【奥恰姆奇拉】支奴干（运输）R1-1",
    "【奥恰姆奇拉】支奴干（运输）R1-2",

    "【苏呼米】支奴干（运输）R1-1",
    "【苏呼米】支奴干（运输）R1-2",

    "【古达乌塔】支奴干（运输）R1-1",
    "【古达乌塔】支奴干（运输）R1-2",

    "【库塔伊西】蚊子（运输）B1-1",
    "【库塔伊西】蚊子（运输）B1-2",

    "【科尔奇】蚊子（运输）B1-1",
    "【科尔奇】蚊子（运输）B1-2",

    "【阿纳克里厄】蚊子（运输）B1-1",
    "【阿纳克里厄】蚊子（运输）B1-2",

    "【奥恰姆奇拉】蚊子（运输）B1-1",
    "【奥恰姆奇拉】蚊子（运输）B1-2",

    "【苏呼米】蚊子（运输）B1-1",
    "【苏呼米】蚊子（运输）B1-2",

    "【古达乌塔】蚊子（运输）B1-1",
    "【古达乌塔】蚊子（运输）B1-2",


    "【库塔伊西】野驴（运输）B1-1",
    "【库塔伊西】野驴（运输）B1-2",

    "【科尔奇】野驴（运输）B1-1",
    "【科尔奇】野驴（运输）B1-2",

    "【阿纳克里厄】野驴（运输）B1-1",
    "【阿纳克里厄】野驴（运输）B1-2",

    "【奥恰姆奇拉】野驴（运输）B1-1",
    "【奥恰姆奇拉】野驴（运输）B1-2",

    "【苏呼米】野驴（运输）B1-1",
    "【苏呼米】野驴（运输）B1-2",

    "【古达乌塔】野驴（运输）B1-1",
    "【古达乌塔】野驴（运输）B1-2",

    "【库塔伊西】支奴干（运输）B1-1",
    "【库塔伊西】支奴干（运输）B1-2",

    "【科尔奇】支奴干（运输）B1-1",
    "【科尔奇】支奴干（运输）B1-2",

    "【阿纳克里厄】支奴干（运输）B1-1",
    "【阿纳克里厄】支奴干（运输）B1-2",

    "【奥恰姆奇拉】支奴干（运输）B1-1",
    "【奥恰姆奇拉】支奴干（运输）B1-2",

    "【苏呼米】支奴干（运输）B1-1",
    "【苏呼米】支奴干（运输）B1-2",

}

-- *************** Optional Extractable GROUPS *****************

-- Use any of the predefined names or set your own ones

ctld.extractableGroups = {
}

-- ************** Logistics UNITS FOR CRATE SPAWNING ******************

-- Use any of the predefined names or set your own ones
-- When a logistic unit is destroyed, you will no longer be able to spawn crates


ctld.shipYards={
    "造船厂Blue",
    "造船厂Red",
}
-- ************** UNITS ABLE TO TRANSPORT VEHICLES ******************
-- Add the model name of the unit that you want to be able to transport and deploy vehicles
-- units db has all the names or you can extract a mission.miz file by making it a zip and looking
-- in the contained mission file
ctld.vehicleTransportEnabled = {
    "76MD",     -- the il-76 mod doesnt use a normal - sign so il-76md wont match... !!!! GRR
    "Hercules",
    --"CH-47Fbl1",
}

-- ************** Units able to use DCS dynamic cargo system ******************
-- DCS (version) added the ability to load and unload cargo from aircraft.
-- Units listed here will spawn a cargo static that can be loaded with the standard DCS cargo system
-- We will also use this to make modifications to the menu and other checks and messages
ctld.dynamicCargoUnits = {
   --"CH-47Fbl1",
   --"UH-1H",
}

-- ************** Maximum Units SETUP for UNITS ******************

-- Put the name of the Unit you want to limit group sizes too
-- i.e
-- ["UH-1H"] = 10,
--
-- Will limit UH1 to only transport groups with a size 10 or less
-- Make sure the unit name is exactly right or it wont work

ctld.unitLoadLimits = {

    -- Remove the -- below to turn on options
    -- ["SA342Mistral"] = 4,
    -- ["SA342L"] = 4,
    -- ["SA342M"] = 4,

    --%%%%% MODS %%%%%
    --["Bronco-OV-10A"] = 4,
    ["Hercules"] = 30,
    --["SK-60"] = 1,
    ["UH-60L"] = 12,
    --["T-45"] = 1,

    --%%%%% CHOPPERS %%%%%
    ["Mi-8MT"] = 16,
    ["Mi-24P"] = 10,
    --["SA342L"] = 4,
    --["SA342M"] = 4,
    --["SA342Mistral"] = 4,
    --["SA342Minigun"] = 3,
    ["UH-1H"] = 8,
    ["CH-47Fbl1"] = 33,

    --%%%%% AIRCRAFTS %%%%%
    --["C-101EB"] = 1,
    --["C-101CC"] = 1,
    --["Christen Eagle II"] = 1,
    --["L-39C"] = 1,
    --["L-39ZA"] = 1,
    --["MB-339A"] = 1,
    --["MB-339APAN"] = 1,
    --["Mirage-F1B"] = 1,
    --["Mirage-F1BD"] = 1,
    --["Mirage-F1BE"] = 1,
    --["Mirage-F1BQ"] = 1,
    --["Mirage-F1DDA"] = 1,
    --["Su-25T"] = 1,
    --["Yak-52"] = 1,

    --%%%%% WARBIRDS %%%%%
    --["Bf-109K-4"] = 1,
    --["Fw 190A8"] = 1,
    --["FW-190D9"] = 1,
    --["I-16"] = 1,
    --["MosquitoFBMkVI"] = 1,
    --["P-47D-30"] = 1,
    --["P-47D-40"] = 1,
    --["P-51D"] = 1,
    --["P-51D-30-NA"] = 1,
    --["SpitfireLFMkIX"] = 1,
    --["SpitfireLFMkIXCW"] = 1,
    --["TF-51D"] = 1,
}

-- Put the name of the Unit you want to enable loading multiple crates
ctld.internalCargoLimits = {

    -- Remove the -- below to turn on options
    ["Mi-8MT"] = 2,
    ["CH-47Fbl1"] = 8,
}


-- ************** Allowable actions for UNIT TYPES ******************
-- Put the name of the Unit you want to limit actions for
-- NOTE - the unit must've been listed in the transportPilotNames list above
-- This can be used in conjunction with the options above for group sizes
-- By default you can load both crates and troops unless overriden below
-- i.e
-- ["UH-1H"] = {crates=true, troops=false},
--
-- Will limit UH1 to only transport CRATES but NOT TROOPS
--
-- ["SA342Mistral"] = {crates=fales, troops=true},
-- Will allow Mistral Gazelle to only transport crates, not troops

ctld.unitActions = {

    -- Remove the -- below to turn on options
    -- ["SA342Mistral"] = {crates=true, troops=true},
    -- ["SA342L"] = {crates=false, troops=true},
    -- ["SA342M"] = {crates=false, troops=true},

    --%%%%% MODS %%%%%
    --["Bronco-OV-10A"] = {crates=true, troops=true},
    ["Hercules"] = { crates = true, troops = true },
    ["SK-60"] = { crates = true, troops = true },
    ["UH-60L"] = { crates = true, troops = true },
    --["T-45"] = {crates=true, troops=true},

    --%%%%% CHOPPERS %%%%%
    --["Ka-50"] = {crates=true, troops=false},
    --["Ka-50_3"] = {crates=true, troops=false},
    ["Mi-8MT"] = { crates = true, troops = true },
    ["Mi-24P"] = { crates = true, troops = true },
    --["SA342L"] = {crates=false, troops=true},
    --["SA342M"] = {crates=false, troops=true},
    --["SA342Mistral"] = {crates=false, troops=true},
    --["SA342Minigun"] = {crates=false, troops=true},
    ["UH-1H"] = { crates = true, troops = true },
    ["CH-47Fbl1"] = { crates = true, troops = true },

    --%%%%% AIRCRAFTS %%%%%
    --["C-101EB"] = {crates=true, troops=true},
    --["C-101CC"] = {crates=true, troops=true},
    --["Christen Eagle II"] = {crates=true, troops=true},
    --["L-39C"] = {crates=true, troops=true},
    --["L-39ZA"] = {crates=true, troops=true},
    --["MB-339A"] = {crates=true, troops=true},
    --["MB-339APAN"] = {crates=true, troops=true},
    --["Mirage-F1B"] = {crates=true, troops=true},
    --["Mirage-F1BD"] = {crates=true, troops=true},
    --["Mirage-F1BE"] = {crates=true, troops=true},
    --["Mirage-F1BQ"] = {crates=true, troops=true},
    --["Mirage-F1DDA"] = {crates=true, troops=true},
    --["Su-25T"]= {crates=true, troops=false},
    --["Yak-52"] = {crates=true, troops=true},

    --%%%%% WARBIRDS %%%%%
    --["Bf-109K-4"] = {crates=true, troops=false},
    --["Fw 190A8"] = {crates=true, troops=false},
    --["FW-190D9"] = {crates=true, troops=false},
    --["I-16"] = {crates=true, troops=false},
    --["MosquitoFBMkVI"] = {crates=true, troops=true},
    --["P-47D-30"] = {crates=true, troops=false},
    --["P-47D-40"] = {crates=true, troops=false},
    --["P-51D"] = {crates=true, troops=false},
    --["P-51D-30-NA"] = {crates=true, troops=false},
    --["SpitfireLFMkIX"] = {crates=true, troops=false},
    --["SpitfireLFMkIXCW"] = {crates=true, troops=false},
    --["TF-51D"] = {crates=true, troops=true},
}

-- ************** WEIGHT CALCULATIONS FOR INFANTRY GROUPS ******************

-- Infantry groups weight is calculated based on the soldiers' roles, and the weight of their kit
-- Every soldier weights between 90% and 120% of ctld.SOLDIER_WEIGHT, and they all carry a backpack and their helmet (ctld.KIT_WEIGHT)
-- Standard grunts have a rifle and ammo (ctld.RIFLE_WEIGHT)
-- AA soldiers have a MANPAD tube (ctld.MANPAD_WEIGHT)
-- Anti-tank soldiers have a RPG and a rocket (ctld.RPG_WEIGHT)
-- Machine gunners have the squad MG and 200 bullets (ctld.MG_WEIGHT)
-- JTAC have the laser sight, radio and binoculars (ctld.JTAC_WEIGHT)
-- Mortar servants carry their tube and a few rounds (ctld.MORTAR_WEIGHT)

ctld.SOLDIER_WEIGHT = 80 -- kg, will be randomized between 90% and 120%
ctld.KIT_WEIGHT = 20     -- kg
ctld.RIFLE_WEIGHT = 5    -- kg
ctld.MANPAD_WEIGHT = 18  -- kg
ctld.RPG_WEIGHT = 7.6    -- kg
ctld.MG_WEIGHT = 10      -- kg
ctld.MORTAR_WEIGHT = 26  -- kg
ctld.JTAC_WEIGHT = 15    -- kg

-- ************** INFANTRY GROUPS FOR PICKUP ******************
-- Unit Types
-- inf is normal infantry
-- mg is M249
-- at is RPG-16
-- aa is Stinger or Igla
-- mortar is a 2B11 mortar unit
-- jtac is a JTAC soldier, which will use JTACAutoLase
-- You must add a name to the group for it to work
-- You can also add an optional coalition side to limit the group to one side
-- for the side - 2 is BLUE and 1 is RED
ctld.loadableGroups = {
    { name = "Standard Group",                   inf = 6,    mg = 2,  at = 2 }, -- will make a loadable group with 6 infantry, 2 MGs and 2 anti-tank for both coalitions
    { name = "Anti Air",                         inf = 2,    aa = 3 },
    { name = "Anti Tank",                        inf = 2,    at = 6 },
    { name = "Mortar Squad",                     mortar = 6 },
    { name = "JTAC Group",                       inf = 4,    jtac = 1 }, -- will make a loadable group with 4 infantry and a JTAC soldier for both coalitions
    { name = "Single JTAC",                      jtac = 1 }, -- will make a loadable group witha single JTAC soldier for both coalitions
    { name = "2x - Standard Groups",             inf = 12,   mg = 4,  at = 4 },
    { name = "2x - Anti Air",                    inf = 4,    aa = 6 },
    { name = "2x - Anti Tank",                   inf = 4,    at = 12 },
    { name = "2x - Standard Groups + 2x Mortar", inf = 12,   mg = 4,  at = 4, mortar = 12 },
    { name = "3x - Standard Groups",             inf = 18,   mg = 6,  at = 6 },
    { name = "3x - Anti Air",                    inf = 6,    aa = 9 },
    { name = "3x - Anti Tank",                   inf = 6,    at = 18 },
    { name = "3x - Mortar Squad",                mortar = 18 },
    { name = "5x - Mortar Squad",                mortar = 30 },
    -- {name = "Mortar Squad Red"), inf = 2, mortar = 5, side =1 }, --would make a group loadable by RED only
}

-- ************** SPAWNABLE CRATES ******************
-- Weights must be unique as we use the weight to change the cargo to the correct unit
-- when we unpack
--
ctld.spawnableCrates = {
    -- 有序数组结构，保证菜单显示顺序
    {
        name = "主战坦克(Tank)",
        items = {
            { weight = 1200, desc = "随机主战坦克(Random MBT)", unit = "Tank RandomGroup" }, --* 重量算法：原载具重量抹零然后除以5
        }
    },
    {
        name = "步兵战车(IFV)",
        items = {
            { weight = 400*2, desc = "04A式履带步战车(1箱1车)", unit = "ZBD04A" },  --? 要不要乘以车辆数呢...感觉太重不好
            { weight = 330*2, desc = "M1134反坦克导弹车(1箱2车)", unit = "M1134 Stryker ATGM Group" },
            --{ weight = 300*2, desc = "步兵装甲战车(BTR-82A)", unit = "BTR82 Group" },
            { weight = 256*2, desc = "LAV-25步战车(1箱2车)", unit = "LAV-25 Group" },
            { weight = 552*2, desc = "M2布莱德利步战车(1箱2车)", unit = "M-2 Bradley Group" },
            { weight = 552*2, desc = "BMPT坦克支援战车(1箱2车)", unit = "BMPT Group" },
        }
    },
    {
        name = "远程火力(Artillery)",
        items = {
            { weight = 800*2, desc = "PLZ05自行火炮(1箱2车)", unit = "PLZ05 Group" },
            --{ weight = 840*2, desc = "2S19自行火炮(1箱2车)", unit = "SAU Msta Group" },
            --{ weight = 550*2, desc = "M109自行火炮(1箱2车)", unit = "M109 Group" },
            { weight = 940*2, desc = "T155自行火炮(1箱2车)", unit = "T155 Group" },
            { weight = 585*2, desc = "达纳卡车炮(1箱2车)", unit = "Dana Group" },
            { weight = 400+50, desc = "TOS-1A火箭炮阵地(2箱2车+补给)", unit = "TOS1A Group" },
            --{ weight = 400+50, desc = "BM27远程火箭炮阵地(2箱2车+补给)", unit = "BM27 Group" },
            --{ weight = 400+50, desc = "BM30远程火箭炮阵地(3箱2车+补给)", unit = "Smerch_HE Group" },
            { weight = 400+50, desc = "MLRS远程火箭炮阵地(3箱2车+补给)", unit = "MLRS Group" },
            { weight = 400+50, desc = "GMLRS制导火箭炮阵地(3箱2车+补给)", unit = "GMLRS Group" },
            --{ weight = 1000, desc = "【导弹】ATACMS(集束)(1箱1车)", unit = "ATACMSCM Group" },
            { weight = 1000, desc = "【导弹】伊斯坎德尔(高爆)(2箱1车)", unit = "9K720HE Group" },
            { weight = 1000, desc = "【导弹】伊斯坎德尔（集束）(2箱1车)", unit = "9K720CM Group" },
            --{ weight = 1000, desc = "【导弹】ATACMS（高爆）(2箱1车)", unit = "ATACMSHE Group" },
        }
    },
    {
        name = "近程防空(Short Range AA)",
        items = {
            --{ weight = 965, desc = "ZU-23卡车高炮(1箱2车)", unit = "ZU23 Group" },
            { weight = 960, desc = "猎豹(Gepard)双管自行高炮(1箱2车)", unit = "Gepard Group" },
            { weight = 964, desc = "箭-10(SA-13)红外地空导弹发射车(1箱2车)", unit = "Strela-10M3 Group" },
            { weight = 966, desc = "C-RAM近防炮(1箱1车)", unit = "HEMTT_C-RAM_Phalanx" },
            { weight = 1206, desc = "通古斯卡(SA-19)弹炮一体系统(1箱1车)", unit = "2S6 Tunguska" },
        }
    },
    {
        name = "中远程防空(Mid&Long Range AA)",
        items = {
            { weight = 680, desc = "罗兰(Roland)地空导弹(1箱2车)", unit = "Roland Group" },
            { weight = 296, desc = "HQ-7LNE地空导弹(2箱2车)", unit = "HQ-7_Group" },
            { weight = 640, desc = "道尔M2地空导弹(3箱1车)", unit = "CHAP_TorM2" , cratesRequired = 3},
            -- { weight = 680, desc = "铠甲S1弹炮一体系统(2箱1车)", unit = "CHAP_PantsirS1", cratesRequired = 2},
            -- { weight = 1480, desc = "【阵地】道尔M1地空导弹(2箱3车+补给)", unit = "SA-15 Buk" },
            -- { weight = 560, desc = "【阵地】IRIS-T地空导弹(2箱2车+补给)", unit = "IRIST" },
            -- --{ weight = 1449, desc = "(小队)库班河(SA-6)地空导弹阵地(3箱4车+补给)", unit = "SA-6 Buk" },
            -- { weight = 1880, desc = "【阵地】山毛榉地空导弹(3箱3车+补给)", unit = "SA-11 Buk" },
        }
    },
    {
        name = "修理箱(repair)",
        items = {
            -- { weight = 823, desc = "IRIS-T维护箱", unit = "IRIST Repair" },
            -- { weight = 823, desc = "道尔M1维护箱", unit = "SA-15 BUK Repair" },
            -- { weight = 821, desc = "山毛榉维护箱", unit = "SA-11 BUK Repair" },
            { weight = 824, desc = "TOS-1A火箭炮阵地维护箱", unit = "TOS1A Group Repair" },
            --{ weight = 824, desc = "BM27火箭炮阵地维护箱", unit = "BM27 Group Repair" },
            --{ weight = 824, desc = "BM30火箭炮阵地维护箱", unit = "Smerch_HE Group Repair" },
            { weight = 824, desc = "MLRS远程火箭炮阵地维护箱", unit = "MLRS Group Repair" },
            { weight = 824, desc = "GMLRS制导火箭炮阵地维护箱", unit = "GMLRS Group Repair" },
        }
    },
    {
        name = "无人机、悍马JTAC、FOB等",
        items = {
            { weight = 492, desc = "悍马吉普 JTAC(侦察）", unit = "M1043 HMMWV Armament" },
            { weight = 402, desc = "补给车(Supply Truck)", unit = "M 818" },
            { weight = 591, desc = "陶悍马(TOW HUMVEE)", unit = "M1045 HMMWV TOW" },
            { weight = 401, desc = "彩蛋(Easter Egg)", unit = "Pz_IV_H" },
            { weight = 325, desc = "无人机 JTAC", unit = "RQ-1A Predator" },
            { weight = 800, desc = "FOB Crate", unit = "FOB" },
        }
    },
    {
        name = "阵营级大杀器",
        items = {
            { weight = 963, desc = "后卫(M6)野战红外地空导弹战车", unit = "M6 Linebacker" },
        }
    },
    {
        name = "造船厂(SHIP)集装箱",
        items = {
            { weight = 1409, desc = "22160护卫舰+道尔M2(3箱1船)", unit = "CHAP_Project22160_TorM2KM", cratesRequired = 3, isShip = true },
            { weight = 1409, desc = "不惧级护卫舰(2箱1船)", unit = "NEUSTRASH", cratesRequired = 2, isShip = true },
            { weight = 1315, desc = "勇士级导弹艇(1箱1船)", unit = "La_Combattante_II", cratesRequired = 1, isShip = true },
        }
    },
}
ctld.lastRepairTimes = {}
--- 3D model that will be used to represent a loadable crate ; by default, a generator
ctld.spawnableCratesModel_load = {
    ["category"] = "Fortifications",
    ["shape_name"] = "iso_container_small_cargo",
    ["type"] = "iso_container_small"
}

--- 3D model that will be used to represent a slingable crate ; by default, a crate
ctld.spawnableCratesModel_sling = {
    ["category"] = "Cargos",
    ["shape_name"] = "bw_container_cargo",
    ["type"] = "container_cargo"
}

--[[ Placeholder for different type of cargo containers. Let's say pipes and trunks, fuel for FOB building
    ["shape_name"] = "ab-212_cargo",
    ["type"] = "uh1h_cargo" --new type for the container previously used

    ["shape_name"] = "ammo_box_cargo",
    ["type"] = "ammo_cargo",

    ["shape_name"] = "barrels_cargo",
    ["type"] = "barrels_cargo",

    ["shape_name"] = "bw_container_cargo",
    ["type"] = "container_cargo",

    ["shape_name"] = "f_bar_cargo",
    ["type"] = "f_bar_cargo",

    ["shape_name"] = "fueltank_cargo",
    ["type"] = "fueltank_cargo",

    ["shape_name"] = "iso_container_cargo",
    ["type"] = "iso_container",

    ["shape_name"] = "iso_container_small_cargo",
    ["type"] = "iso_container_small",

    ["shape_name"] = "oiltank_cargo",
    ["type"] = "oiltank_cargo",

    ["shape_name"] = "pipes_big_cargo",
    ["type"] = "pipes_big_cargo",

    ["shape_name"] = "pipes_small_cargo",
    ["type"] = "pipes_small_cargo",

    ["shape_name"] = "tetrapod_cargo",
    ["type"] = "tetrapod_cargo",

    ["shape_name"] = "trunks_long_cargo",
    ["type"] = "trunks_long_cargo",

    ["shape_name"] = "trunks_small_cargo",
    ["type"] = "trunks_small_cargo",
]]--

-- if the unit is on this list, it will be made into a JTAC when deployed
ctld.jtacUnitTypes = {
    "SKP",
    "M1043 HMMWV Armament",
    "RQ-1A Predator", --there are some wierd encoding issues so if you write SKP-11 it wont match as the - sign is encoded differently...
}


-- ***************************************************************
-- **************** Mission Editor Functions *********************
-- ***************************************************************

function ctld.RefreshConfig()
    local Players = net.get_player_list()
        local totalPlayers = 0
        for PlayerIDIndex, playerID in pairs(Players) do
            -- is player still in a valid slot
            local _playerDetails = net.get_player_info(playerID)
            if _playerDetails ~= nil and _playerDetails.side ~= 0 and _playerDetails.slot ~= "" and _playerDetails.slot ~= nil then
                totalPlayers = totalPlayers + 1
            end
        end
    if totalPlayers > Bomber.MinimumNukePlayers then
        ctld.UnitLimitPerPlayer = {
            ["主战坦克(Tank)"] = 4,
            ["步兵战车(IFV)"] = 3,
            ["远程火力(Artillery)"] = 5,
            ["近程防空(Short Range AA)"] = 4,
            ["中远程防空(Mid&Long Range AA)"] = 4,
            ["无人机、悍马JTAC、FOB等"] = 5,
        }
        ctld.FOBLimit = 1
        ctld.CoalitionKillerLimit = 4 --红方的阵营级大杀器

        ctld.F10RefreshTime = 60
        ctld.disableAllSmoke = false -- if true, all smoke is diabled at pickup and drop off zones regardless of settings below. Leave false to respect settings below

        ctld.hoverPickup = false --  if set to false you can load crates with the F10 menu instead of hovering... Only if not using real crates!

        ctld.enableCrates = true -- if false, Helis will not be able to spawn or unpack crates so will be normal CTTS
        ctld.slingLoad = false -- if false, crates can be used WITHOUT slingloading, by hovering above the crate, simulating slingloading but not the weight...
        -- There are some bug with Sling-loading that can cause crashes, if these occur set slingLoad to false
        -- to use the other method.
        -- Set staticBugFix  to FALSE if use set ctld.slingLoad to TRUE

        ctld.enableSmokeDrop = false -- if false, helis and c-130 will not be able to drop smoke

        ctld.maxExtractDistance = 125 -- max distance from vehicle to troops to allow a group extraction
        ctld.multiCrateMaxDistance = 100 --生成一个组需要的箱子之间的最大距离
        ctld.maximumDistanceLogistic = 200 -- max distance from vehicle to logistics to allow a loading or spawning operation
        ctld.maximumSearchDistance = 4000 -- max distance for troops to search for enemy
        ctld.maximumMoveDistance = 2000 -- max distance for troops to move from drop point if no enemy is nearby

        ctld.minimumDeployDistance = 900 -- minimum distance from a friendly pickup zone where you can deploy a crate
        ctld.minimumDistanceBetweenFobs = 1
        ctld.spawnRPGWithCoalition = true --spawns a friendly RPG unit with Coalition forces
        ctld.spawnStinger = false -- spawns a stinger / igla soldier with a group of 6 or more soldiers!

        ctld.enabledFOBBuilding = true -- if true, you can load a crate INTO a C-130 than when unpacked creates a Forward Operating Base (FOB) which is a new place to spawn (crates) and carry crates from
        -- In future i'd like it to be a FARP but so far that seems impossible...
        -- You can also enable troop Pickup at FOBS
        ctld.cratesRequiredForFOB = 1 -- The amount of crates required to build a FOB. Once built, helis can spawn crates at this outpost to be carried and deployed in another area.
        -- The large crates can only be loaded and dropped by large aircraft, like the C-130 and listed in ctld.vehicleTransportEnabled
        -- Small FOB crates can be moved by helicopter. The FOB will require ctld.cratesRequiredForFOB larges crates and small crates are 1/3 of a large fob crate
        -- To build the FOB entirely out of small crates you will need ctld.cratesRequiredForFOB * 3
        ctld.troopPickupAtFOB = true -- if true, troops can also be picked up at a created FOB
        ctld.buildTimeFOB = 60 --time in seconds for the FOB to be built
        --ctld.crateWaitTime = 20 -- time in seconds to wait before you can spawn another crate
        ctld.crateWaitTime = 1
        ctld.forceCrateToBeMoved = false -- a crate must be picked up at least once and moved before it can be unpacked. Helps to reduce crate spam
        ctld.UseInfraRed = false
        ctld.unitActions = {
            --["SA342Mistral"] = {crates=true, troops=true},
            --["SA342L"] = {crates=true, troops=true},
            --["SA342M"] = {crates=true, troops=true},
            ["UH-1H"] = {crates=true, troops=true},
            ["Mi-8MT"] = {crates=true, troops=true},
            ["Mi-8MTV2"] = {crates=true, troops=true},
            ["Mi-24P"] = {crates=true, troops=true},
        }
        ctld.unloadTroopsTime = 10
        ctld.logInfo("当前在线玩家数正常，使用正常参数")
    else
        ctld.UnitLimitPerPlayer = {
            ["主战坦克(Tank)"] = 4,
            ["步兵战车(IFV)"] = 3,
            ["远程火力(Artillery)"] = 5,
            ["近程防空(Short Range AA)"] = 4,
            ["中远程防空(Mid&Long Range AA)"] = 4,
            ["无人机、悍马JTAC、FOB等"] = 5,
        }
        ctld.FOBLimit = 0
        ctld.CoalitionKillerLimit = 1 --红方的阵营级大杀器

        ctld.F10RefreshTime = 60
        ctld.disableAllSmoke = false -- if true, all smoke is diabled at pickup and drop off zones regardless of settings below. Leave false to respect settings below

        ctld.hoverPickup = false --  if set to false you can load crates with the F10 menu instead of hovering... Only if not using real crates!

        ctld.enableCrates = true -- if false, Helis will not be able to spawn or unpack crates so will be normal CTTS
        ctld.slingLoad = false -- if false, crates can be used WITHOUT slingloading, by hovering above the crate, simulating slingloading but not the weight...
        -- There are some bug with Sling-loading that can cause crashes, if these occur set slingLoad to false
        -- to use the other method.
        -- Set staticBugFix  to FALSE if use set ctld.slingLoad to TRUE

        ctld.enableSmokeDrop = false -- if false, helis and c-130 will not be able to drop smoke

        ctld.maxExtractDistance = 125 -- max distance from vehicle to troops to allow a group extraction
        ctld.multiCrateMaxDistance = 100 --生成一个组需要的箱子之间的最大距离
        ctld.maximumDistanceLogistic = 200 -- max distance from vehicle to logistics to allow a loading or spawning operation
        ctld.maximumSearchDistance = 4000 -- max distance for troops to search for enemy
        ctld.maximumMoveDistance = 2000 -- max distance for troops to move from drop point if no enemy is nearby

        ctld.minimumDeployDistance = 900 -- minimum distance from a friendly pickup zone where you can deploy a crate
        ctld.minimumDistanceBetweenFobs = 1
        ctld.spawnRPGWithCoalition = true --spawns a friendly RPG unit with Coalition forces
        ctld.spawnStinger = false -- spawns a stinger / igla soldier with a group of 6 or more soldiers!

        ctld.enabledFOBBuilding = true -- if true, you can load a crate INTO a C-130 than when unpacked creates a Forward Operating Base (FOB) which is a new place to spawn (crates) and carry crates from
        -- In future i'd like it to be a FARP but so far that seems impossible...
        -- You can also enable troop Pickup at FOBS
        ctld.cratesRequiredForFOB = 1 -- The amount of crates required to build a FOB. Once built, helis can spawn crates at this outpost to be carried and deployed in another area.
        -- The large crates can only be loaded and dropped by large aircraft, like the C-130 and listed in ctld.vehicleTransportEnabled
        -- Small FOB crates can be moved by helicopter. The FOB will require ctld.cratesRequiredForFOB larges crates and small crates are 1/3 of a large fob crate
        -- To build the FOB entirely out of small crates you will need ctld.cratesRequiredForFOB * 3
        ctld.troopPickupAtFOB = true -- if true, troops can also be picked up at a created FOB
        ctld.buildTimeFOB = 60 --time in seconds for the FOB to be built
        --ctld.crateWaitTime = 20 -- time in seconds to wait before you can spawn another crate
        ctld.crateWaitTime = 1
        ctld.forceCrateToBeMoved = false -- a crate must be picked up at least once and moved before it can be unpacked. Helps to reduce crate spam
        ctld.UseInfraRed = false
        ctld.unitActions = {
            --["SA342Mistral"] = {crates=true, troops=true},
            --["SA342L"] = {crates=true, troops=true},
            --["SA342M"] = {crates=true, troops=true},
            ["UH-1H"] = {crates=true, troops=true},
            ["Mi-8MT"] = {crates=true, troops=true},
            ["Mi-8MTV2"] = {crates=true, troops=true},
            ["Mi-24P"] = {crates=true, troops=true},
        }
        ctld.unloadTroopsTime = 10
        ctld.logInfo("当前在线玩家数过少，已启用低人数参数")
        trigger.action.outText("当前在线玩家数小于"..Bomber.MinimumNukePlayers.."人，禁止部署FOB！",15)
    end
end

-----------------------------------------------------------------
-- Spawn group at a trigger and set them as extractable. Usage:
-- ctld.spawnGroupAtTrigger("groupside", number, "triggerName", radius)
-- Variables:
-- "groupSide" = "red" for Russia "blue" for USA
-- _number = number of groups to spawn OR Group description
-- "triggerName" = trigger name in mission editor between commas
-- _searchRadius = random distance for units to move from spawn zone (0 will leave troops at the spawn position - no search for enemy)
--
-- Example: ctld.spawnGroupAtTrigger("red", 2, "spawn1", 1000)
--
-- This example will spawn 2 groups of russians at the specified point
-- and they will search for enemy or move randomly withing 1000m
-- OR
--
-- ctld.spawnGroupAtTrigger("blue", {mg=1,at=2,aa=3,inf=4,mortar=5},"spawn2", 2000)
-- Spawns 1 machine gun, 2 anti tank, 3 anti air, 4 standard soldiers and 5 mortars
--
function ctld.spawnGroupAtTrigger(_groupSide, _number, _triggerName, _searchRadius)
    local _spawnTrigger = trigger.misc.getZone(_triggerName)     -- trigger to use as reference position

    if _spawnTrigger == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find trigger called " .. _triggerName, 10)
        return
    end

    local _country
    if _groupSide == "red" then
        _groupSide = 1
        _country = 0
    else
        _groupSide = 2
        _country = 2
    end

    if _searchRadius < 0 then
        _searchRadius = 0
    end

    local _pos2 = { x = _spawnTrigger.point.x, y = _spawnTrigger.point.z }
    local _alt = land.getHeight(_pos2)
    local _pos3 = { x = _pos2.x, y = _alt, z = _pos2.y }

    local _groupDetails = ctld.generateTroopTypes(_groupSide, _number, _country)

    local _droppedTroops = ctld.spawnDroppedGroup(_pos3, _groupDetails, false, _searchRadius);

    if _groupSide == 1 then
        table.insert(ctld.droppedTroopsRED, _droppedTroops:getName())
    else
        table.insert(ctld.droppedTroopsBLUE, _droppedTroops:getName())
    end
end

-----------------------------------------------------------------
-- Spawn group at a Vec3 Point and set them as extractable. Usage:
-- ctld.spawnGroupAtPoint("groupside", number,Vec3 Point, radius)
-- Variables:
-- "groupSide" = "red" for Russia "blue" for USA
-- _number = number of groups to spawn OR Group Description
-- Vec3 Point = A vec3 point like {x=1,y=2,z=3}. Can be obtained from a unit like so: Unit.getName("Unit1"):getPoint()
-- _searchRadius = random distance for units to move from spawn zone (0 will leave troops at the spawn position - no search for enemy)
--
-- Example: ctld.spawnGroupAtPoint("red", 2, {x=1,y=2,z=3}, 1000)
--
-- This example will spawn 2 groups of russians at the specified point
-- and they will search for enemy or move randomly withing 1000m
-- OR
--
-- ctld.spawnGroupAtPoint("blue", {mg=1,at=2,aa=3,inf=4,mortar=5}, {x=1,y=2,z=3}, 2000)
-- Spawns 1 machine gun, 2 anti tank, 3 anti air, 4 standard soldiers and 5 mortars
function ctld.spawnGroupAtPoint(_groupSide, _number, _point, _searchRadius)
    local _country
    if _groupSide == "red" then
        _groupSide = 1
        _country = 0
    else
        _groupSide = 2
        _country = 2
    end

    if _searchRadius < 0 then
        _searchRadius = 0
    end

    local _groupDetails = ctld.generateTroopTypes(_groupSide, _number, _country)

    local _droppedTroops = ctld.spawnDroppedGroup(_point, _groupDetails, false, _searchRadius);

    if _groupSide == 1 then
        table.insert(ctld.droppedTroopsRED, _droppedTroops:getName())
    else
        table.insert(ctld.droppedTroopsBLUE, _droppedTroops:getName())
    end
end

-- Preloads a transport with troops or vehicles
-- replaces any troops currently on board
function ctld.preLoadTransport(_unitName, _number, _troops)
    local _unit = ctld.getTransportUnit(_unitName)

    if _unit ~= nil then
        -- will replace any units currently on board
        --                if not ctld.troopsOnboard(_unit,_troops)    then
        ctld.loadTroops(_unit, _troops, _number)
        --                end
    end
end

-- Continuously counts the number of crates in a zone and sets the value of the passed in flag
-- to the count amount
-- This means you can trigger actions based on the count and also trigger messages before the count is reached
-- Just pass in the zone name and flag number like so as a single (NOT Continuous) Trigger
-- This will now work for Mission Editor and Spawned Crates
-- e.g. ctld.cratesInZone("DropZone1", 5)
function ctld.cratesInZone(_zone, _flagNumber)
    local _triggerZone = trigger.misc.getZone(_zone) -- trigger to use as reference position

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zone, 10)
        return
    end

    local _zonePos = mist.utils.zoneToVec3(_zone)

    --ignore side, if crate has been used its discounted from the count
    local _crateTables = { ctld.spawnedCratesRED, ctld.spawnedCratesBLUE, ctld.missionEditorCargoCrates }

    local _crateCount = 0

    for _, _crates in pairs(_crateTables) do

        for _crateName, _dontUse in pairs(_crates) do

            --get crate
            local _crate = ctld.getCrateObject(_crateName)

            --in air seems buggy with crates so if in air is true, get the height above ground and the speed magnitude
            if _crate ~= nil and _crate:getLife() > 0
                    and (ctld.inAir(_crate) == false) then

                local _dist = ctld.getDistance(_crate:getPoint(), _zonePos)

                if _dist <= _triggerZone.radius then
                    _crateCount = _crateCount + 1
                end
            end
        end
    end

    --set flag stuff
    trigger.action.setUserFlag(_flagNumber, _crateCount)

    -- ctld.logInfo("FLAG ".._flagNumber.." crates ".._crateCount)

    --retrigger in 5 seconds
    timer.scheduleFunction(function(_args)

        ctld.cratesInZone(_args[1], _args[2])
    end, { _zone, _flagNumber }, timer.getTime() + 5)
end

-- Creates an extraction zone
-- any Soldiers (not vehicles) dropped at this zone by a helicopter will disappear
-- and be added to a running total of soldiers for a set flag number
-- The idea is you can then drop say 20 troops in a zone and trigger an action using the mission editor triggers
-- and the flag value
--
-- The ctld.createExtractZone function needs to be called once in a trigger action do script.
-- if you dont want smoke, pass -1 to the function.
--Green = 0 , Red = 1, White = 2, Orange = 3, Blue = 4, NO SMOKE = -1
--
-- e.g. ctld.createExtractZone("extractzone1", 2, -1) will create an extraction zone at trigger zone "extractzone1", store the number of troops dropped at
-- the zone in flag 2 and not have smoke
--
--
--
function ctld.createExtractZone(_zone, _flagNumber, _smoke)
    local _triggerZone = trigger.misc.getZone(_zone)     -- trigger to use as reference position

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zone, 10)
        return
    end

    local _pos2 = { x = _triggerZone.point.x, y = _triggerZone.point.z }
    local _alt = land.getHeight(_pos2)
    local _pos3 = { x = _pos2.x, y = _alt, z = _pos2.y }

    trigger.action.setUserFlag(_flagNumber, 0)     --start at 0

    local _details = { point = _pos3, name = _zone, smoke = _smoke, flag = _flagNumber, radius = _triggerZone.radius }

    ctld.extractZones[_zone .. "-" .. _flagNumber] = _details

    if _smoke ~= nil and _smoke > -1 then

        local _smokeFunction

        _smokeFunction = function(_args)

            local _extractDetails = ctld.extractZones[_zone .. "-" .. _flagNumber]
            -- check zone is still active
            if _extractDetails == nil then
                -- stop refreshing smoke, zone is done
                return
            end

            trigger.action.smoke(_args.point, _args.smoke)
            --refresh in 5 minutes
            timer.scheduleFunction(_smokeFunction, _args, timer.getTime() + 300)
        end

        --run local function
        _smokeFunction(_details)
    end
end

-- Removes an extraction zone
--
-- The smoke will take up to 5 minutes to disappear depending on the last time the smoke was activated
--
-- The ctld.removeExtractZone function needs to be called once in a trigger action do script.
--
-- e.g. ctld.removeExtractZone("extractzone1", 2) will remove an extraction zone at trigger zone "extractzone1"
-- that was setup with flag 2
--
--
--
function ctld.removeExtractZone(_zone, _flagNumber)

    local _extractDetails = ctld.extractZones[_zone .. "-" .. _flagNumber]

    if _extractDetails ~= nil then
        --remove zone
        ctld.extractZones[_zone .. "-" .. _flagNumber] = nil

    end
end

-- CONTINUOUS TRIGGER FUNCTION
-- This function will count the current number of extractable RED and BLUE
-- GROUPS in a zone and store the values in two flags
-- A group is only counted as being in a zone when the leader of that group
-- is in the zone
-- Use: ctld.countDroppedGroupsInZone("Zone Name", flagBlue, flagRed)
function ctld.countDroppedGroupsInZone(_zone, _blueFlag, _redFlag)

    local _triggerZone = trigger.misc.getZone(_zone) -- trigger to use as reference position

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zone, 10)
        return
    end

    local _zonePos = mist.utils.zoneToVec3(_zone)

    local _redCount = 0;
    local _blueCount = 0;

    local _allGroups = { ctld.droppedTroopsRED, ctld.droppedTroopsBLUE, ctld.droppedVehiclesRED, ctld.droppedVehiclesBLUE }
    for _, _extractGroups in pairs(_allGroups) do
        for _, _groupName in pairs(_extractGroups) do
            local _groupUnits = ctld.getGroup(_groupName)

            if #_groupUnits > 0 then
                local _zonePos = mist.utils.zoneToVec3(_zone)
                local _dist = ctld.getDistance(_groupUnits[1]:getPoint(), _zonePos)

                if _dist <= _triggerZone.radius then
                    if (_groupUnits[1]:getCoalition() == 1) then
                        _redCount = _redCount + 1;
                    else
                        _blueCount = _blueCount + 1;
                    end
                end
            end
        end
    end
    --set flag stuff
    trigger.action.setUserFlag(_blueFlag, _blueCount)
    trigger.action.setUserFlag(_redFlag, _redCount)

    --  ctld.logInfo("Groups in zone ".._blueCount.." ".._redCount)

end

-- CONTINUOUS TRIGGER FUNCTION
-- This function will count the current number of extractable RED and BLUE
-- UNITS in a zone and store the values in two flags

-- Use: ctld.countDroppedUnitsInZone("Zone Name", flagBlue, flagRed)
function ctld.countDroppedUnitsInZone(_zone, _blueFlag, _redFlag)

    local _triggerZone = trigger.misc.getZone(_zone) -- trigger to use as reference position

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zone, 10)
        return
    end

    local _zonePos = mist.utils.zoneToVec3(_zone)

    local _redCount = 0;
    local _blueCount = 0;

    local _allGroups = { ctld.droppedTroopsRED, ctld.droppedTroopsBLUE, ctld.droppedVehiclesRED, ctld.droppedVehiclesBLUE }

    for _, _extractGroups in pairs(_allGroups) do
        for _, _groupName in pairs(_extractGroups) do
            local _groupUnits = ctld.getGroup(_groupName)

            if #_groupUnits > 0 then

                local _zonePos = mist.utils.zoneToVec3(_zone)
                for _, _unit in pairs(_groupUnits) do
                    local _dist = ctld.getDistance(_unit:getPoint(), _zonePos)

                    if _dist <= _triggerZone.radius then

                        if (_unit:getCoalition() == 1) then
                            _redCount = _redCount + 1;
                        else
                            _blueCount = _blueCount + 1;
                        end
                    end
                end
            end
        end
    end


    --set flag stuff
    trigger.action.setUserFlag(_blueFlag, _blueCount)
    trigger.action.setUserFlag(_redFlag, _redCount)

    --  ctld.logInfo("Units in zone ".._blueCount.." ".._redCount)
end


-- Creates a radio beacon on a random UHF - VHF and HF/FM frequency for homing
-- This WILL NOT WORK if you dont add beacon.ogg and beaconsilent.ogg to the mission!!!
-- e.g. ctld.createRadioBeaconAtZone("beaconZone","red", 1440,"Waypoint 1") will create a beacon at trigger zone "beaconZone" for the Red side
-- that will last 1440 minutes (24 hours ) and named "Waypoint 1" in the list of radio beacons
--
-- e.g. ctld.createRadioBeaconAtZone("beaconZoneBlue","blue", 20) will create a beacon at trigger zone "beaconZoneBlue" for the Blue side
-- that will last 20 minutes
function ctld.createRadioBeaconAtZone(_zone, _coalition, _batteryLife, _name)
    local _triggerZone = trigger.misc.getZone(_zone) -- trigger to use as reference position

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zone, 10)
        return
    end

    local _zonePos = mist.utils.zoneToVec3(_zone)

    ctld.beaconCount = ctld.beaconCount + 1

    if _name == nil or _name == "" then
        _name = "Beacon #" .. ctld.beaconCount
    end

    if _coalition == "red" then
        ctld.createRadioBeacon(_zonePos, 1, 0, _name, _batteryLife) --1440
    else
        ctld.createRadioBeacon(_zonePos, 2, 2, _name, _batteryLife) --1440
    end
end


-- Activates a pickup zone
-- Activates a pickup zone when called from a trigger
-- EG: ctld.activatePickupZone("pickzone3")
-- This is enable pickzone3 to be used as a pickup zone for the team set
function ctld.activatePickupZone(_zoneName)
    ctld.logDebug(string.format("ctld.activatePickupZone(_zoneName=%s)", ctld.p(_zoneName)))

    local _triggerZone = trigger.misc.getZone(_zoneName) -- trigger to use as reference position

    if _triggerZone == nil then
        local _ship = ctld.getTransportUnit(_triggerZone)

        if _ship then
            local _point = _ship:getPoint()
            _triggerZone = {}
            _triggerZone.point = _point
        end

    end

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone or ship called " .. _zoneName, 10)
    end

    for _, _zoneDetails in pairs(ctld.pickupZones) do

        if _zoneName == _zoneDetails[1] then

            --smoke could get messy if designer keeps calling this on an active zone, check its not active first
            if _zoneDetails[4] == 1 then
                -- they might have a continuous trigger so i've hidden the warning
                --trigger.action.outText("CTLD.lua ERROR: Pickup Zone already active: " .. _zoneName, 10)
                return
            end

            _zoneDetails[4] = 1 --activate zone

            if ctld.disableAllSmoke == true then
                --smoke disabled
                return
            end

            if _zoneDetails[2] >= 0 then

                -- Trigger smoke marker
                -- This will cause an overlapping smoke marker on next refreshsmoke call
                -- but will only happen once
                local _pos2 = { x = _triggerZone.point.x, y = _triggerZone.point.z }
                local _alt = land.getHeight(_pos2)
                local _pos3 = { x = _pos2.x, y = _alt, z = _pos2.y }

                trigger.action.smoke(_pos3, _zoneDetails[2])
            end
        end
    end
end


-- Deactivates a pickup zone
-- Deactivates a pickup zone when called from a trigger
-- EG: ctld.deactivatePickupZone("pickzone3")
-- This is disables pickzone3 and can no longer be used to as a pickup zone
-- These functions can be called by triggers, like if a set of buildings is used, you can trigger the zone to be 'not operational'
-- once they are destroyed
function ctld.deactivatePickupZone(_zoneName)

    local _triggerZone = trigger.misc.getZone(_zoneName) -- trigger to use as reference position

    if _triggerZone == nil then
        local _ship = ctld.getTransportUnit(_triggerZone)

        if _ship then
            local _point = _ship:getPoint()
            _triggerZone = {}
            _triggerZone.point = _point
        end

    end

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zoneName, 10)
        return
    end

    for _, _zoneDetails in pairs(ctld.pickupZones) do

        if _zoneName == _zoneDetails[1] then

            -- i'd just ignore it if its already been deactivated
            --            if _zoneDetails[4] == 0 then --this really needed??
            --            trigger.action.outText("CTLD.lua ERROR: Pickup Zone already deactiveated: " .. _zoneName, 10)
            --            return
            --            end

            _zoneDetails[4] = 0 --deactivate zone
        end
    end
end

-- Change the remaining groups currently available for pickup at a zone
-- e.g. ctld.changeRemainingGroupsForPickupZone("pickup1", 5) -- adds 5 groups
-- ctld.changeRemainingGroupsForPickupZone("pickup1", -3) -- remove 3 groups
function ctld.changeRemainingGroupsForPickupZone(_zoneName, _amount)
    local _triggerZone = trigger.misc.getZone(_zoneName) -- trigger to use as reference position

    if _triggerZone == nil then
        local _ship = ctld.getTransportUnit(_triggerZone)

        if _ship then
            local _point = _ship:getPoint()
            _triggerZone = {}
            _triggerZone.point = _point
        end

    end

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ctld.changeRemainingGroupsForPickupZone ERROR: Cant find zone called " .. _zoneName, 10)
        return
    end

    for _, _zoneDetails in pairs(ctld.pickupZones) do

        if _zoneName == _zoneDetails[1] then
            ctld.updateZoneCounter(_zoneName, _amount)
        end
    end


end

-- Activates a Waypoint zone
-- Activates a Waypoint zone when called from a trigger
-- EG: ctld.activateWaypointZone("pickzone3")
-- This means that troops dropped within the radius of the zone will head to the center
-- of the zone instead of searching for troops
function ctld.activateWaypointZone(_zoneName)
    local _triggerZone = trigger.misc.getZone(_zoneName) -- trigger to use as reference position


    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone  called " .. _zoneName, 10)

        return
    end

    for _, _zoneDetails in pairs(ctld.wpZones) do

        if _zoneName == _zoneDetails[1] then

            --smoke could get messy if designer keeps calling this on an active zone, check its not active first
            if _zoneDetails[3] == 1 then
                -- they might have a continuous trigger so i've hidden the warning
                --trigger.action.outText("CTLD.lua ERROR: Pickup Zone already active: " .. _zoneName, 10)
                return
            end

            _zoneDetails[3] = 1 --activate zone

            if ctld.disableAllSmoke == true then
                --smoke disabled
                return
            end

            if _zoneDetails[2] >= 0 then

                -- Trigger smoke marker
                -- This will cause an overlapping smoke marker on next refreshsmoke call
                -- but will only happen once
                local _pos2 = { x = _triggerZone.point.x, y = _triggerZone.point.z }
                local _alt = land.getHeight(_pos2)
                local _pos3 = { x = _pos2.x, y = _alt, z = _pos2.y }

                trigger.action.smoke(_pos3, _zoneDetails[2])
            end
        end
    end
end


-- Deactivates a Waypoint zone
-- Deactivates a Waypoint zone when called from a trigger
-- EG: ctld.deactivateWaypointZone("wpzone3")
-- This  disables wpzone3 so that troops dropped in this zone will search for troops as normal
-- These functions can be called by triggers
function ctld.deactivateWaypointZone(_zoneName)

    local _triggerZone = trigger.misc.getZone(_zoneName)

    if _triggerZone == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zoneName, 10)
        return
    end

    for _, _zoneDetails in pairs(ctld.pickupZones) do

        if _zoneName == _zoneDetails[1] then

            _zoneDetails[3] = 0 --deactivate zone
        end
    end
end

-- Continuous Trigger Function
-- Causes an AI unit with the specified name to unload troops / vehicles when
-- an enemy is detected within a specified distance
-- The enemy must have Line or Sight to the unit to be detected
function ctld.unloadInProximityToEnemy(_unitName, _distance)

    local _unit = ctld.getTransportUnit(_unitName)

    if _unit ~= nil and _unit:getPlayerName() == nil then

        -- no player name means AI!
        -- the findNearest visible enemy you'd want to modify as it'll find enemies quite far away
        -- limited by  ctld.JTAC_maxDistance
        local _nearestEnemy = ctld.findNearestVisibleEnemy(_unit, "all", _distance)

        if _nearestEnemy ~= nil then

            if ctld.troopsOnboard(_unit, true) then
                ctld.deployTroops(_unit, true)
                return true
            end

            if ctld.unitCanCarryVehicles(_unit) and ctld.troopsOnboard(_unit, false) then
                ctld.deployTroops(_unit, false)
                return true
            end
        end
    end

    return false

end



-- Unit will unload any units onboard if the unit is on the ground
-- when this function is called
function ctld.unloadTransport(_unitName)

    local _unit = ctld.getTransportUnit(_unitName)

    if _unit ~= nil then

        if ctld.troopsOnboard(_unit, true) then
            ctld.unloadTroops({ _unitName, true })
        end

        if ctld.unitCanCarryVehicles(_unit) and ctld.troopsOnboard(_unit, false) then
            ctld.unloadTroops({ _unitName, false })
        end
    end

end

-- Loads Troops and Vehicles from a zone or picks up nearby troops or vehicles
function ctld.loadTransport(_unitName)

    local _unit = ctld.getTransportUnit(_unitName)

    if _unit ~= nil then

        ctld.loadTroopsFromZone({ _unitName, true, "", true })

        if ctld.unitCanCarryVehicles(_unit) then
            ctld.loadTroopsFromZone({ _unitName, false, "", true })
        end

    end

end

-- adds a callback that will be called for many actions ingame
function ctld.addCallback(_callback)

    table.insert(ctld.callbacks, _callback)

end

-- Spawns a sling loadable crate at a Trigger Zone
--
-- Weights can be found in the ctld.spawnableCrates list
-- e.g. ctld.spawnCrateAtZone("red", 500,"triggerzone1") -- spawn a humvee at triggerzone 1 for red side
-- e.g. ctld.spawnCrateAtZone("blue", 505,"triggerzone1") -- spawn a tow humvee at triggerzone1 for blue side
--
function ctld.spawnCrateAtZone(_side, _desc, _zone)
    local _spawnTrigger = trigger.misc.getZone(_zone) -- trigger to use as reference position

    if _spawnTrigger == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find zone called " .. _zone, 10)
        return
    end

    local _crateType = ctld.crateLookupTable[tostring(_desc)]

    if _crateType == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find crate with description " .. _desc, 10)
        return
    end

    local _country
    if _side == "red" then
        _side = 1
        _country = 0
    else
        _side = 2
        _country = 2
    end

    local _pos2 = { x = _spawnTrigger.point.x, y = _spawnTrigger.point.z }
    local _alt = land.getHeight(_pos2)
    local _point = { x = _pos2.x, y = _alt, z = _pos2.y }

    local _unitId = ctld.getNextUnitId()

    local _name = string.format("%s #%i", _crateType.desc, _unitId)

    local _spawnedCrate = ctld.spawnCrateStatic(_country, _unitId, _point, _name, _crateType.desc, _side)

end

-- Spawns a sling loadable crate at a Point
--
-- Weights can be found in the ctld.spawnableCrates list
-- Points can be made by hand or obtained from a Unit position by Unit.getByName("PilotName"):getPoint()
-- e.g. ctld.spawnCrateAtZone("red", 500,{x=1,y=2,z=3}) -- spawn a humvee at triggerzone 1 for red side at a specified point
-- e.g. ctld.spawnCrateAtZone("blue", 505,{x=1,y=2,z=3}) -- spawn a tow humvee at triggerzone1 for blue side at a specified point
--
--
function ctld.spawnCrateAtPoint(_side, _desc, _point)


    local _crateType = ctld.crateLookupTable[tostring(_desc)]

    if _crateType == nil then
        trigger.action.outText("CTLD.lua ERROR: Cant find crate with description " .. _desc, 10)
        return
    end

    local _country
    if _side == "red" then
        _side = 1
        _country = 0
    else
        _side = 2
        _country = 2
    end

    local _unitId = ctld.getNextUnitId()

    local _name = string.format("%s #%i", _crateType.desc, _unitId)

    local _spawnedCrate = ctld.spawnCrateStatic(_country, _unitId, _point, _name, _crateType.desc, _side)

end

-- ***************************************************************
-- **************** BE CAREFUL BELOW HERE ************************
-- ***************************************************************

--- Tells CTLD What multipart AA Systems there are and what parts they need
-- A New system added here also needs the launcher added

ctld.RandomTankPool = {
    'Tank RandomGroup L2A6 Group',
    --'Tank RandomGroup L2A4 Group',
    'Tank RandomGroup M1A2 Group',
    'Tank RandomGroup Lec Group',
    'Tank RandomGroup Challenger2 Group',
    'Tank RandomGroup ZTZ96B Group',
    'Tank RandomGroup Merkava Group',
    'Tank RandomGroup T-80 Group',
    --'Tank RandomGroup T-84 Group',
    --'Tank RandomGroup T-90M Group',
    'Tank RandomGroup T-90 Group',
    --'Tank RandomGroup L2A5 Group'
}

ctld.GroupSystemTemplate = {
    {
        name = "随机坦克",
        sysName = "Tank RandomGroup",
    },

    {
        name = "轮式轻型坦克(M1128)小队",
        sysName = "M1128 Stryker MGS Group",
        cratesRequired = 1,
        aaLaunchers = 2,
        count = 1,
        hasLimit = false,
        parts = {
            { name = "M1128 Stryker MGS", desc = "轮式轻型坦克(M1128)", launcher = true },
        },
        --repair = "BTR_D Group Repair",
    },
    {
        name = "步兵装甲战车(04A)小队",
        sysName = "ZBD04A Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "ZBD04A", desc = "步兵装甲战车(04A)", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    --{ weight = 925, desc = "主战坦克M1A2", unit = "M-1 Abrams", cratesRequired = 1, loadable = false },
    {
        name = "主战坦克M1A2小队",
        sysName = "Tank RandomGroup M1A2 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "M-1 Abrams", desc = "主战坦克M1A2", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克豹2A6小队",
        sysName = "Tank RandomGroup L2A6 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Leopard-2", desc = "主战坦克豹2A6", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克豹2A5小队",
        sysName = "Tank RandomGroup L2A5 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Leopard-2A5", desc = "主战坦克豹2A5", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克豹2A4小队",
        sysName = "Tank RandomGroup L2A4 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "leopard-2A4", desc = "主战坦克豹2A4", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克勒克莱尔小队",
        sysName = "Tank RandomGroup Lec Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Leclerc", desc = "主战坦克勒克莱尔", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克挑战者2小队",
        sysName = "Tank RandomGroup Challenger2 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Challenger2", desc = "主战坦克挑战者2", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克梅卡瓦4小队",
        sysName = "Tank RandomGroup Merkava Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Merkava_Mk4", desc = "主战坦克梅卡瓦", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克T80U小队",
        sysName = "Tank RandomGroup T-80 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "T-80UD", desc = "主战坦克T-80", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克T84小队",
        sysName = "Tank RandomGroup T-84 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_T84OplotM", desc = "主战坦克T-84", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克T90M小队",
        sysName = "Tank RandomGroup T-90M Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_T90M", desc = "主战坦克T-90M", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克T-90小队",
        sysName = "Tank RandomGroup T-90 Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "T-90", desc = "主战坦克T-90", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "主战坦克ZTZ96B小队",
        sysName = "Tank RandomGroup ZTZ96B Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "ZTZ96B", desc = "主战坦克ZTZ96B", launcher = true },
        },
        --repair = "ZBD04A Group Repair",
    },
    {
        name = "步兵装甲战车(BTR82)小队",
        sysName = "BTR82 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "BTR-82A", desc = "步兵装甲战车(BTR-82)", launcher = true },
        },
        --repair = "BTR82 Group Repair",
    },
    {
        name = "步兵装甲战车(BMP-2)小队",
        sysName = "BMP2 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "BMP-2", desc = "步兵装甲战车(BMP-2)", launcher = true },
        },
        --repair = "BTR82 Group Repair",
    },
    --[[{
        name = "步兵装甲战车(MCV80武士)小队",
		sysName = "MCV80 Group",
		cratesRequired = 1,
		aaLaunchers = 2,

        count = 1,
		hasLimit = false,
        parts = {
            {name = "MCV-80", desc = "步兵装甲战车(MCV80)" , launcher = true},
        },
        --repair = "BTR82 Group Repair",
    },
    {
        name = "步兵装甲战车(黄鼠狼)小队",
		sysName = "Marder Group",
		cratesRequired = 1,
		aaLaunchers = 3,

        count = 1,
		hasLimit = false,
        parts = {
            {name = "Marder", desc = "步兵装甲战车(黄鼠狼)" , launcher = true},
        },
        --repair = "BTR82 Group Repair",
    },]]
    {
        name = "ZU-23卡车高炮小队",
        sysName = "ZU23 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Ural-375 ZU-23 Insurgent", desc = "ZU-23卡车高炮", launcher = true },
        },
        --repair = "HQ-7_LN_SP Group Repair",
    },
    {
        name = "罗兰近程地空导弹小队",
        sysName = "Roland Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Roland ADS", desc = "罗兰自行防空导弹车", launcher = true },
        },
        --repair = "HQ-7_LN_SP Group Repair",
    },
    {
        name = "红旗-7(HQ-7)近程地空导弹小队",
        sysName = "HQ-7_Group",
        cratesRequired = 2,
        aaLaunchers = 2,

        count = 1,
        hasLimit = true,
        parts = {
            { name = "HQ-7_LN_P", desc = "光电红旗-7(HQ-7LNE)近程地空导弹发射车", launcher = true },
            --{name = "HQ-7_STR_SP", desc = "红旗-7(HQ-7)近程地空导弹雷达车" },
        },
        --repair = "HQ-7_LN_SP Group Repair",
    },
    {
        name = "猎豹(Gepard)双管自行高炮小队",
        sysName = "Gepard Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "Gepard", desc = "猎豹(Gepard)双管自行高炮", launcher = true },
        },
        --repair = "HQ-7_LN_SP Group Repair",
    },
    {
        name = "TOS1A火箭炮阵地",
        sysName = "TOS1A Group",
        cratesRequired = 2,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "CHAP_TOS1A", desc = "火箭炮(TOS1A)", launcher = true },
            { name = "ZIL-135", desc = "远程火箭炮(TOS1A)补弹车" },
        },
        repair = "TOS1A Group Repair",
    },
    {
        name = "BM27远程火箭炮阵地",
        sysName = "BM27 Group",
        cratesRequired = 2,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "Uragan_BM-27", desc = "远程火箭炮(BM27)", launcher = true },
            { name = "ZIL-135", desc = "远程火箭炮(BM27)补弹车2" },
        },
        repair = "BM27 Group Repair",
    },
    {
        name = "BM30远程火箭炮阵地",
        sysName = "Smerch_HE Group",
        cratesRequired = 3,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "Smerch_HE", desc = "远程火箭炮(BM30)", launcher = true },
            { name = "ZIL-135", desc = "远程火箭炮(BM30)补弹车2" },
        },
        repair = "Smerch_HE Group Repair",
    },
    {
        name = "MLRS远程火箭炮阵地",
        sysName = "MLRS Group",
        cratesRequired = 3,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "MLRS", desc = "远程火箭炮(海马斯)", launcher = true },
            { name = "M 818", desc = "远程火箭炮(海马斯)补弹车2" },
        },
        repair = "MLRS Group Repair",
    },
    {
        name = "GMLRS制导火箭炮阵地",
        sysName = "GMLRS Group",
        cratesRequired = 3,
        aaLaunchers = 2,

        count = 2,
        hasLimit = false,
        parts = {
            { name = "CHAP_M142_GMLRS_M31", desc = "远程火箭炮(海马斯)", launcher = true },
            { name = "M 818", desc = "远程火箭炮(海马斯)补弹车2" },
        },
        repair = "GMLRS Group Repair",
    },
    {
        name = "山毛榉(SA-11)地空导弹阵地",
        sysName = "SA-11 Buk",
        cratesRequired = 3,
        aaLaunchers = 3,
        unitsCnt = 7,
        count = 5,
        hasLimit = true,
        parts = {
            { name = "SA-11 Buk LN 9A310M1", desc = "山毛榉地空导弹发射车", launcher = true },
            { name = "SA-11 Buk CC 9S470M1", desc = "山毛榉地空导弹指挥车" },
            { name = "SA-11 Buk SR 9S18M1", desc = "山毛榉地空导弹雷达车" },
            { name = "ZIL-135", desc = "山毛榉(SA-11)地空导弹阵地补弹车2" },
        },
        repair = "SA-11 BUK Repair",
    },
    {
        name = "库班河(SA-6)地空导弹阵地",
        sysName = "SA-6 Buk",
        cratesRequired = 2,
        aaLaunchers = 3,
        unitsCnt = 5,
        count = 3,
        hasLimit = true,
        parts = {
            { name = "Kub 2P25 ln", desc = "库班河地空导弹发射车", launcher = true },
            { name = "Kub 1S91 str", desc = "库班河地空导弹雷达车" },
            { name = "ZIL-135", desc = "库班河(SA-6)地空导弹阵地补弹车" },
        },
        repair = "SA-6 BUK Repair",
    },
    --[[{
        name = "NASAMS地空导弹阵地",
		sysName = "NASAMS Group",
		cratesRequired = 2,
		aaLaunchers = 2,
		unitsCnt = 6,
        count = 4,
		hasLimit = false,
        parts = {
            {name = "NASAMS_LN_C", desc = "NASAMS地空导弹发射车" , launcher = true},
            {name = "NASAMS_Radar_MPQ64F1", desc = "NASAMS地空导弹雷达车"},
            {name = "NASAMS_Command_Post", desc = "NASAMS地空导弹指挥车"},
			{name = "ZIL-135", desc = "NASAMS地空导弹阵地补弹车2"},
        },
        repair = "NASAMS Repair",
    },]]
    {
        name = "道尔阵地（2箱3车+补给）",
        sysName = "SA-15 Buk",
        cratesRequired = 2,
        aaLaunchers = 3,
        unitsCnt = 5,
        count = 3,
        hasLimit = true,
        parts = {
            --{name = "SA-11 Buk LN 9A310M1", desc = "山毛榉地空导弹发射车" , launcher = true},
            --{name = "SA-11 Buk CC 9S470M1", desc = "山毛榉地空导弹指挥车"},
            -- {name = "SA-11 Buk SR 9S18M1", desc = "山毛榉地空导弹雷达车"},
            { name = "ZIL-135", desc = "道尔(SA-15)地空导弹阵地补弹车2" },
            { name = "Tor 9A331", desc = "道尔(SA-15)雷达地空导弹发射车", launcher = true },
            --{name = "Dog Ear radar", desc = "指挥车"},
            --{ weight = 625, desc = "通古斯卡(SA-19)防空系统战车", unit = "2S6 Tunguska", cratesRequired = 1, loadable = false },
            --{ weight = 775, desc = "山毛榉(SA-11)地空导弹阵地", unit = "SA-11 Buk", cratesRequired = 2, loadable = false },
        },
        repair = "SA-15 BUK Repair",
    },
    {
        name = "IRIST阵地（2箱2车+补给）",
        sysName = "IRIST",
        cratesRequired = 2,
        aaLaunchers = 2,
        unitsCnt = 6,
        count = 3,
        hasLimit = true,
        parts = {
            { name = "ZIL-135", desc = "IRIST补弹车" },
            { name = "CHAP_IRISTSLM_CP", desc = "IRIST指挥车" },
            { name = "CHAP_IRISTSLM_LN", desc = "IRIST发射车", launcher = true },
            { name = "CHAP_IRISTSLM_STR", desc = "IRIST雷达车", launcher = true},
        },
        repair = "IRIST Repair",
    },
    {
        name = "补给小队",
        sysName = "Back Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 2,
        hasLimit = false,
        parts = {
            --{name = "Ural-375", desc = "补弹车1"},
            { name = "M 818", desc = "补弹车2" },
        }, },
    {
        name = "SAU Msta小队",
        sysName = "SAU Msta Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "SAU Msta", desc = "SAU Msta自行火炮", launcher = true },

        }, },
    {
        name = "M109小队",
        sysName = "M109 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "M-109", desc = "M109自行火炮", launcher = true },

        }, },
    {
        name = "PLZ05小队",
        sysName = "PLZ05 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "PLZ05", desc = "M109自行火炮", launcher = true },

        }, },
    {
        name = "T155小队",
        sysName = "T155 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "T155_Firtina", desc = "T155自行火炮", launcher = true },

        }, },
    {
        name = "达纳小队",
        sysName = "Dana Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "SpGH_Dana", desc = "达纳卡车炮", launcher = true },

        }, },
    {
        name = "M1045 HMMWV Armament小队",
        sysName = "M1045 HMMWV Armament Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "M1045 HMMWV Armament", desc = "M1045 HMMWV Armament陶氏悍马", launcher = true },
        }, },
    {
        name = "LAV-25小队",
        sysName = "LAV-25 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "LAV-25", desc = "LAV-25步战车", launcher = true },
        }, },
    {
        name = "M-2 Bradley小队",
        sysName = "M-2 Bradley Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "M-2 Bradley", desc = "M-2 Bradley步战", launcher = true },
        }, },
    {
        name = "BMPT小队",
        sysName = "BMPT Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_BMPT", desc = "BMPT步战", launcher = true },
        }, },
    {
        name = "M1134 Stryker ATGM小队",
        sysName = "M1134 Stryker ATGM Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "M1134 Stryker ATGM", desc = "M1134 Stryker ATGM导弹车", launcher = true },
        }, },


    {
        name = "箭10小队",
        sysName = "Strela-10M3 Group",
        cratesRequired = 1,
        aaLaunchers = 2,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "Strela-10M3", desc = "箭10", launcher = true },
        }, },

    {
        name = "伊斯坎德尔（高爆）",
        sysName = "9K720HE Group",
        cratesRequired = 2,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_9K720_HE", desc = "伊斯坎德尔（高爆）", launcher = true },
        }, },

    {
        name = "伊斯坎德尔（集束）",
        sysName = "9K720CM Group",
        cratesRequired = 2,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_9K720_Cluster", desc = "伊斯坎德尔（集束）", launcher = true },
        }, },

    {
        name = "ATACMS（高爆）",
        sysName = "ATACMSHE Group",
        cratesRequired = 2,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_M142_ATACMS_M39A1", desc = "ATACMS（高爆）", launcher = true },
        }, },

    {
        name = "ATACMS（集束）",
        sysName = "ATACMSCM Group",
        cratesRequired = 1,
        aaLaunchers = 1,

        count = 1,
        hasLimit = false,
        parts = {
            { name = "CHAP_M142_ATACMS_M39A1", desc = "ATACMS（集束）", launcher = true },
        }, },
}

ctld.crateWait = {}
ctld.crateMove = {}

---------------- INTERNAL FUNCTIONS ----------------
---
---
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utility methods
-------------------------------------------------------------------------------------------------------------------------------------------------------------

--- print an object for a debugging log
function ctld.p(o, level)
    local MAX_LEVEL = 20
    if level == nil then
        level = 0
    end
    if level > MAX_LEVEL then
        ctld.logError("max depth reached in ctld.p : " .. tostring(MAX_LEVEL))
        return ""
    end
    local text = ""
    if (type(o) == "table") then
        text = "\n"
        for key, value in pairs(o) do
            for i = 0, level do
                text = text .. " "
            end
            text = text .. "." .. key .. "=" .. ctld.p(value, level + 1) .. "\n"
        end
    elseif (type(o) == "function") then
        text = "[function]"
    elseif (type(o) == "boolean") then
        if o == true then
            text = "[true]"
        else
            text = "[false]"
        end
    else
        if o == nil then
            text = "[nil]"
        else
            text = tostring(o)
        end
    end
    return text
end

function ctld.logError(message)
    env.info("[CTLD] Err: " .. message)
end

function ctld.logInfo(message)
    env.info("[CTLD] Info: " .. message)
end

function ctld.logDebug(message)
    if message and ctld.Debug then
        env.info("[CTLD] Debug: " .. message)
    end
end

function ctld.logTrace(message)
    if message and ctld.Trace then
        env.info("[CTLD] Trace - " .. ctld.Id .. message)
    end
end

function ctld.formatTable(t, tabcount)
    tabcount = tabcount or 0
    if tabcount > 5 then
        --防止栈溢出
        return "<table too deep>" .. tostring(t)
    end
    local str = ""
    if type(t) == "table" then
        for k, v in pairs(t) do
            local tab = string.rep("\t", tabcount)
            if type(v) == "table" then
                str = str .. tab .. string.format("[%s] = {", ctld.formatValue(k)) .. '\n'
                str = str .. ctld.formatTable(v, tabcount + 1) .. tab .. '}\n'
            else
                str = str .. tab .. string.format("[%s] = %s", ctld.formatValue(k), ctld.formatValue(v)) .. ',\n'
            end
        end
    else
        str = str .. tostring(t) .. '\n'
    end
    return str
end
function ctld.formatValue(val)
    if type(val) == "string" then
        return string.format("%q", val)
    end
    return tostring(val)
end

ctld.nextUnitId = 1;
ctld.getNextUnitId = function()
    ctld.nextUnitId = ctld.nextUnitId + 1

    return ctld.nextUnitId
end

ctld.nextGroupId = 1;

ctld.getNextGroupId = function()
    ctld.nextGroupId = ctld.nextGroupId + 1

    return ctld.nextGroupId
end

function ctld.getTransportUnit(_unitName)

    if _unitName == nil then
        return nil
    end

    local _heli = Unit.getByName(_unitName)

    if _heli ~= nil and _heli:isActive() and _heli:getLife() > 0 then

        return _heli
    end

    return nil
end

function ctld.getAddGroupUnit(_unitName)
    if _unitName == nil then
        return nil
    end

    local _unit = Unit.getByName(_unitName)

    if _unit ~= nil and _unit:getLife() > 0 then

        return _unit
    end

    return nil
end

function ctld.spawnCrateStatic(_country, _unitId, _point, _name, _desc, _side)

    local _crate
    local _spawnedCrate

    local _crateType = ctld.crateLookupTable[_desc]

    if _side == 1 then
        ctld.spawnedCratesRED[_name] = _crateType
    else
        ctld.spawnedCratesBLUE[_name] = _crateType
    end

    if ctld.staticBugWorkaround and ctld.slingLoad == false then
        local _groupId = ctld.getNextGroupId()
        local _groupName = "Crate Group #" .. _groupId

        local _group = {
            ["visible"] = false,
            -- ["groupId"] = _groupId,
            ["hidden"] = false,
            ["units"] = {},
            --        ["y"] = _positions[1].z,
            --        ["x"] = _positions[1].x,
            ["name"] = _groupName,
            ["task"] = {},
        }

        _group.units[1] = ctld.createUnit(_point.x, _point.z, 0, { type = "UAZ-469", name = _name, unitId = _unitId })

        --switch to MIST
        _group.category = Group.Category.GROUND;
        _group.country = _country;

        local _spawnedGroup = Group.getByName(mist.dynAdd(_group).name)

        -- Turn off AI
        trigger.action.setGroupAIOff(_spawnedGroup)

        _spawnedCrate = Unit.getByName(_name)
    else

        if ctld.slingLoad then
            _crate = mist.utils.deepCopy(ctld.spawnableCratesModel_sling)
            _crate["canCargo"] = true
        else
            _crate = mist.utils.deepCopy(ctld.spawnableCratesModel_load)
            _crate["canCargo"] = true
        end

        _crate["y"] = _point.z
        _crate["x"] = _point.x
        --_crate["z"] = land.getHeight({x = _point.x, y = _point.z}) --INOP
        _crate["mass"] = _crateType.weight
        _crate["name"] = _name
        _crate["heading"] = 0
        _crate["country"] = _country

        ctld.logTrace(string.format("_crate=%s", ctld.p(_crate)))
        mist.dynAddStatic(_crate)

        _spawnedCrate = StaticObject.getByName(_crate["name"])
    end

    return _spawnedCrate
end

function ctld.spawnFOBCrateStatic(_country, _unitId, _point, _name)

    local _crate = {
        ["category"] = "Fortifications",
        ["shape_name"] = "konteiner_red1",
        ["type"] = "Container red 1",
        --   ["unitId"] = _unitId,
        ["y"] = _point.z,
        ["x"] = _point.x,
        ["name"] = _name,
        ["canCargo"] = true,
        ["heading"] = 0,
    }

    _crate["country"] = _country

    mist.dynAddStatic(_crate)

    local _spawnedCrate = StaticObject.getByName(_crate["name"])
    --local _spawnedCrate = coalition.addStaticObject(_country, _crate)

    return _spawnedCrate
end

function ctld.spawnFOB(_country, _unitId, _point, _name)

    local _crate = {
        ["category"] = "Fortifications",
        ["type"] = "outpost",
        --  ["unitId"] = _unitId,
        ["y"] = _point.z + 60,
        ["x"] = _point.x + 60,
        ["name"] = _name,
        ["canCargo"] = false,
        ["heading"] = 0,
    }

    _crate["country"] = _country
    mist.dynAddStatic(_crate)
    local _spawnedCrate = StaticObject.getByName(_crate["name"])
    --local _spawnedCrate = coalition.addStaticObject(_country, _crate)

    --不需要额外的装饰物
    --[[    local _id = ctld.getNextUnitId()
        local _tower = {
            ["type"] = "house2arm",
         --   ["unitId"] = _id,
            ["rate"] = 100,
            ["y"] = _point.z + -36.57142857,
            ["x"] = _point.x + 14.85714286,
            ["name"] = "FOB Watchtower #" .. _id,
            ["category"] = "Fortifications",
            ["canCargo"] = false,
            ["heading"] = 0,
        }
        --coalition.addStaticObject(_country, _tower)
        _tower["country"] = _country

        mist.dynAddStatic(_tower)]]

    return _spawnedCrate
end

function ctld.spawnCrate(_arguments)

    local _status, _err = pcall(function(_args)

        -- use the cargo weight to guess the type of unit as no way to add description :(

        local _crateType = ctld.crateLookupTable[tostring(_args[2])]
        local _heli = ctld.getTransportUnit(_args[1])

        if _crateType ~= nil and _heli ~= nil and ctld.inAir(_heli) == false then

            if ctld.inLogisticsZone(_heli) == false then

                --ctld.displayMessageToGroup(_heli, "You are not close enough to friendly logistics to get a crate!", 10)
                ctld.displayMessageToGroup(_heli, "距离CC或FOB超过"..ctld.maximumDistanceLogistic.."米，无法获取箱子！", 10)

                return
            end

            --取消官方的jtac限制
            --if ctld.isJTACUnitType(_crateType.unit) then
            --
            --    local _limitHit = false
            --
            --    if _heli:getCoalition() == 1 then
            --
            --        if ctld.JTAC_LIMIT_RED == 0 then
            --            _limitHit = true
            --        else
            --            ctld.JTAC_LIMIT_RED = ctld.JTAC_LIMIT_RED - 1
            --        end
            --    else
            --        if ctld.JTAC_LIMIT_BLUE == 0 then
            --            _limitHit = true
            --        else
            --            ctld.JTAC_LIMIT_BLUE = ctld.JTAC_LIMIT_BLUE - 1
            --        end
            --    end
            --
            --    if _limitHit then
            --        --ctld.displayMessageToGroup(_heli, "No more JTAC Crates Left!", 10)
            --        ctld.displayMessageToGroup(_heli, "JTAC 箱子用完了！", 10)
            --        return
            --    end
            --end

            local _position = _heli:getPosition()

            -- check crate spam
            if _heli:getPlayerName() ~= nil and ctld.crateWait[_heli:getPlayerName()] and ctld.crateWait[_heli:getPlayerName()] > timer.getTime() then

                --ctld.displayMessageToGroup(_heli, "Sorry you must wait " .. (ctld.crateWait[_heli:getPlayerName()] - timer.getTime()) .. " seconds before you can get another crate", 20)
                ctld.displayMessageToGroup(_heli, "Sorry！你需要等 " .. (ctld.crateWait[_heli:getPlayerName()] - timer.getTime()) .. " 秒后才能叫出箱子", 20)
                return
            end

            if _heli:getPlayerName() ~= nil then
                ctld.crateWait[_heli:getPlayerName()] = timer.getTime() + ctld.crateWaitTime
            end
            --   trigger.action.outText("Spawn Crate".._args[1].." ".._args[2],10)

            local _heli = ctld.getTransportUnit(_args[1])

            local _point = ctld.getPointAt12Oclock(_heli, 30)

            local _unitId = ctld.getNextUnitId()

            local _side = _heli:getCoalition()

            local _name = string.format("%s #%i", _crateType.desc, _unitId)

            local _spawnedCrate = ctld.spawnCrateStatic(_heli:getCountry(), _unitId, _point, _name, _crateType.desc, _side)

            -- add to move table
            ctld.crateMove[_name] = _name

            --ctld.displayMessageToGroup(_heli, string.format("A %s crate weighing %s kg has been brought out and is at your 12 o'clock ", _crateType.desc, _crateType.weight), 20)
            ctld.displayMessageToGroup(_heli, string.format("一个 %s 箱子已调出，重量为 %s kg 位于你的12点钟方向 ", _crateType.desc, _crateType.weight), 20)

        else
            ctld.logInfo("Couldn't find crate item to spawn")
        end
    end, _arguments)

    if (not _status) then
        env.error(string.format("CTLD ERROR: %s", _err))
    end
end

function ctld.getPointAt12Oclock(_unit, _offset)

    local _position = _unit:getPosition()
    local _angle = math.atan2(_position.x.z, _position.x.x)
    local _xOffset = math.cos(_angle) * _offset
    local _yOffset = math.sin(_angle) * _offset

    local _point = _unit:getPoint()
    return { x = _point.x + _xOffset, z = _point.z + _yOffset, y = _point.y }
end

function ctld.troopsOnboard(_heli, _troops)

    if ctld.inTransitTroops[_heli:getName()] ~= nil then

        local _onboard = ctld.inTransitTroops[_heli:getName()]

        if _troops then

            if _onboard.troops ~= nil and _onboard.troops.units ~= nil and #_onboard.troops.units > 0 then
                return true
            else
                return false
            end
        else

            if _onboard.vehicles ~= nil and _onboard.vehicles.units ~= nil and #_onboard.vehicles.units > 0 then
                return true
            else
                return false
            end
        end

    else
        return false
    end
end

-- if its dropped by AI then there is no player name so return the type of unit
function ctld.getPlayerNameOrType(_heli)

    if _heli:getPlayerName() == nil then

        return _heli:getTypeName()
    else
        return _heli:getPlayerName()
    end
end

function ctld.inExtractZone(_heli)

    local _heliPoint = _heli:getPoint()

    for _, _zoneDetails in pairs(ctld.extractZones) do

        --get distance to center
        local _dist = ctld.getDistance(_heliPoint, _zoneDetails.point)

        if _dist <= _zoneDetails.radius then
            return _zoneDetails
        end
    end

    return false
end

-- safe to fast rope if speed is less than 0.5 Meters per second
function ctld.safeToFastRope(_heli)

    if ctld.enableFastRopeInsertion == false then
        return false
    end

    --landed or speed is less than 8 km/h and height is less than fast rope height
    if (ctld.inAir(_heli) == false or (ctld.heightDiff(_heli) <= ctld.fastRopeMaximumHeight + 3.0 and mist.vec.mag(_heli:getVelocity()) < 2.2)) then
        return true
    end
end

function ctld.metersToFeet(_meters)

    local _feet = _meters * 3.2808399

    return mist.utils.round(_feet)
end

function ctld.inAir(_heli)

    if _heli:inAir() == false or (_heli:getDesc().category == Unit.Category.AIRPLANE and ctld.heightDiff(_heli) <= ctld.airDropHeight) then
        return false  -- allow load/unload
    end

    -- less than 5 cm/s a second so landed
    -- BUT AI can hold a perfect hover so ignore AI
    if mist.vec.mag(_heli:getVelocity()) < 0.05 and _heli:getPlayerName() ~= nil then
        return false
    end
    return true
end

function ctld.deployTroops(_heli, _troops)

    local _onboard = ctld.inTransitTroops[_heli:getName()]

    -- deloy troops
    if _troops then
        if _onboard.troops ~= nil and #_onboard.troops.units > 0 then
            if ctld.inAir(_heli) == false or ctld.safeToFastRope(_heli) then

                -- check we're not in extract zone
                local _extractZone = ctld.inExtractZone(_heli)

                if _extractZone == false then

                    local _droppedTroops = ctld.spawnDroppedGroup(_heli:getPoint(), _onboard.troops, false)
                    ctld.logTrace(string.format("_onboard.troops=%s", ctld.p(_onboard.troops)))
                    if _onboard.troops.jtac or _droppedTroops:getName():lower():find("jtac") then
                        local _code = table.remove(ctld.jtacGeneratedLaserCodes, 1)
                        ctld.logTrace(string.format("_code=%s", ctld.p(_code)))
                        table.insert(ctld.jtacGeneratedLaserCodes, _code)
                        ctld.logTrace(string.format("_droppedTroops:getName()=%s", ctld.p(_droppedTroops:getName())))
                        ctld.JTACAutoLase(_droppedTroops:getName(), _code)
                    end

                    if _heli:getCoalition() == 1 then

                        table.insert(ctld.droppedTroopsRED, _droppedTroops:getName())
                    else

                        table.insert(ctld.droppedTroopsBLUE, _droppedTroops:getName())
                    end

                    ctld.inTransitTroops[_heli:getName()].troops = nil
                    ctld.adaptWeightToCargo(_heli:getName())

                    if ctld.inAir(_heli) then
                        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " fast-ropped troops from " .. _heli:getTypeName() .. " into combat", 10)
                    else
                        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " dropped troops from " .. _heli:getTypeName() .. " into combat", 10)
                    end

                    ctld.processCallback({ unit = _heli, unloaded = _droppedTroops, action = "dropped_troops" })


                else
                    --extract zone!
                    local _droppedCount = trigger.misc.getUserFlag(_extractZone.flag)

                    _droppedCount = (#_onboard.troops.units) + _droppedCount

                    trigger.action.setUserFlag(_extractZone.flag, _droppedCount)

                    ctld.inTransitTroops[_heli:getName()].troops = nil
                    ctld.adaptWeightToCargo(_heli:getName())

                    if ctld.inAir(_heli) then
                        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " troops fast-ropped from " .. _heli:getTypeName() .. " into " .. _extractZone.name, 10)
                    else
                        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " troops dropped from " .. _heli:getTypeName() .. " into " .. _extractZone.name, 10)
                    end
                end
            else
                ctld.displayMessageToGroup(_heli, "Too high or too fast to drop troops into combat! Hover below " .. ctld.metersToFeet(ctld.fastRopeMaximumHeight) .. " feet or land.", 10)
            end
        end

    else
        if ctld.inAir(_heli) == false then
            if _onboard.vehicles ~= nil and #_onboard.vehicles.units > 0 then

                local _droppedVehicles = ctld.spawnDroppedGroup(_heli:getPoint(), _onboard.vehicles, true)

                if _heli:getCoalition() == 1 then

                    table.insert(ctld.droppedVehiclesRED, _droppedVehicles:getName())
                else

                    table.insert(ctld.droppedVehiclesBLUE, _droppedVehicles:getName())
                end

                ctld.inTransitTroops[_heli:getName()].vehicles = nil
                ctld.adaptWeightToCargo(_heli:getName())

                ctld.processCallback({ unit = _heli, unloaded = _droppedVehicles, action = "dropped_vehicles" })

                trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " dropped vehicles from " .. _heli:getTypeName() .. " into combat", 10)
            end
        end
    end
end

function ctld.insertIntoTroopsArray(_troopType, _count, _troopArray, _troopName)

    for _i = 1, _count do
        local _unitId = ctld.getNextUnitId()
        table.insert(_troopArray, { type = _troopType, unitId = _unitId, name = string.format("Dropped %s #%i", _troopName or _troopType, _unitId) })
    end

    return _troopArray

end

function ctld.generateTroopTypes(_side, _countOrTemplate, _country)
    local _troops = {}
    local _weight = 0
    local _hasJTAC = false

    local function getSoldiersWeight(count, additionalWeight)
        local _weight = 0
        for i = 1, count do
            local _soldierWeight = math.random(90, 120) * ctld.SOLDIER_WEIGHT / 100
            ctld.logTrace(string.format("_soldierWeight=%s", ctld.p(_soldierWeight)))
            _weight = _weight + _soldierWeight + ctld.KIT_WEIGHT + additionalWeight
        end
        return _weight
    end

    if type(_countOrTemplate) == "table" then

        if _countOrTemplate.aa then
            ctld.logTrace(string.format("_countOrTemplate.aa=%s", ctld.p(_countOrTemplate.aa)))
            if _side == 2 then
                _troops = ctld.insertIntoTroopsArray("Soldier stinger", _countOrTemplate.aa, _troops)
            else
                _troops = ctld.insertIntoTroopsArray("SA-18 Igla manpad", _countOrTemplate.aa, _troops)
            end
            _weight = _weight + getSoldiersWeight(_countOrTemplate.aa, ctld.MANPAD_WEIGHT)
            ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
        end

        if _countOrTemplate.inf then
            ctld.logTrace(string.format("_countOrTemplate.inf=%s", ctld.p(_countOrTemplate.inf)))
            if _side == 2 then
                _troops = ctld.insertIntoTroopsArray("Soldier M4", _countOrTemplate.inf, _troops)
            else
                _troops = ctld.insertIntoTroopsArray("Soldier AK", _countOrTemplate.inf, _troops)
            end
            _weight = _weight + getSoldiersWeight(_countOrTemplate.inf, ctld.RIFLE_WEIGHT)
            ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
        end

        if _countOrTemplate.mg then
            ctld.logTrace(string.format("_countOrTemplate.mg=%s", ctld.p(_countOrTemplate.mg)))
            if _side == 2 then
                _troops = ctld.insertIntoTroopsArray("Soldier M249", _countOrTemplate.mg, _troops)
            else
                _troops = ctld.insertIntoTroopsArray("Paratrooper AKS-74", _countOrTemplate.mg, _troops)
            end
            _weight = _weight + getSoldiersWeight(_countOrTemplate.mg, ctld.MG_WEIGHT)
            ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
        end

        if _countOrTemplate.at then
            ctld.logTrace(string.format("_countOrTemplate.at=%s", ctld.p(_countOrTemplate.at)))
            _troops = ctld.insertIntoTroopsArray("Paratrooper RPG-16", _countOrTemplate.at, _troops)
            _weight = _weight + getSoldiersWeight(_countOrTemplate.at, ctld.RPG_WEIGHT)
            ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
        end

        if _countOrTemplate.mortar then
            ctld.logTrace(string.format("_countOrTemplate.mortar=%s", ctld.p(_countOrTemplate.mortar)))
            _troops = ctld.insertIntoTroopsArray("2B11 mortar", _countOrTemplate.mortar, _troops)
            _weight = _weight + getSoldiersWeight(_countOrTemplate.mortar, ctld.MORTAR_WEIGHT)
            ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
        end

        if _countOrTemplate.jtac then
            ctld.logTrace(string.format("_countOrTemplate.jtac=%s", ctld.p(_countOrTemplate.jtac)))
            if _side == 2 then
                _troops = ctld.insertIntoTroopsArray("Soldier M4", _countOrTemplate.jtac, _troops, "JTAC")
            else
                _troops = ctld.insertIntoTroopsArray("Soldier AK", _countOrTemplate.jtac, _troops, "JTAC")
            end
            _hasJTAC = true
            _weight = _weight + getSoldiersWeight(_countOrTemplate.jtac, ctld.JTAC_WEIGHT + ctld.RIFLE_WEIGHT)
            ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
        end

    else
        for _i = 1, _countOrTemplate do

            local _unitType = "Soldier AK"

            if _side == 2 then
                if _i <= 2 then
                    _unitType = "Soldier M249"
                    _weight = _weight + getSoldiersWeight(1, ctld.MG_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                elseif ctld.spawnRPGWithCoalition and _i > 2 and _i <= 4 then
                    _unitType = "Paratrooper RPG-16"
                    _weight = _weight + getSoldiersWeight(1, ctld.RPG_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                elseif ctld.spawnStinger and _i > 4 and _i <= 5 then
                    _unitType = "Soldier stinger"
                    _weight = _weight + getSoldiersWeight(1, ctld.MANPAD_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                else
                    _unitType = "Soldier M4"
                    _weight = _weight + getSoldiersWeight(1, ctld.RIFLE_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                end
            else
                if _i <= 2 then
                    _unitType = "Paratrooper AKS-74"
                    _weight = _weight + getSoldiersWeight(1, ctld.MG_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                elseif ctld.spawnRPGWithCoalition and _i > 2 and _i <= 4 then
                    _unitType = "Paratrooper RPG-16"
                    _weight = _weight + getSoldiersWeight(1, ctld.RPG_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                elseif ctld.spawnStinger and _i > 4 and _i <= 5 then
                    _unitType = "SA-18 Igla manpad"
                    _weight = _weight + getSoldiersWeight(1, ctld.MANPAD_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                else
                    _unitType = "Infantry AK"
                    _weight = _weight + getSoldiersWeight(1, ctld.RIFLE_WEIGHT)
                    ctld.logTrace(string.format("_unitType=%s, _weight=%s", ctld.p(_unitType), ctld.p(_weight)))
                end
            end

            local _unitId = ctld.getNextUnitId()

            _troops[_i] = { type = _unitType, unitId = _unitId, name = string.format("Dropped %s #%i", _unitType, _unitId) }
        end
    end

    local _groupId = ctld.getNextGroupId()
    local _groupName = "Dropped Group"
    if _hasJTAC then
        _groupName = "Dropped JTAC Group"
    end
    local _details = { units = _troops, groupId = _groupId, groupName = string.format("%s %i", _groupName, _groupId), side = _side, country = _country, weight = _weight, jtac = _hasJTAC }
    ctld.logTrace(string.format("total  weight=%s", ctld.p(_weight)))

    return _details
end

--Special F10 function for players for troops
function ctld.unloadExtractTroops(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    if ctld.inLogisticsZone(_heli) ==true then
        ctld.displayMessageToGroup(_heli, "离cc太近，不能放下部队", 10)
        return
    end

    if _heli == nil then
        return false
    end

    timer.scheduleFunction(function(_args)
        local _heli = _args[1]

        if ctld.inAir(_heli) then
            ctld.displayMessageToGroup(_heli, "飞机没有停稳，步兵行动失败", 10)
            return
        end

        local _extract = nil
        if not ctld.inAir(_heli) then
            if _heli:getCoalition() == 1 then
                _extract = ctld.findNearestGroup(_heli, ctld.droppedTroopsRED)
            else
                _extract = ctld.findNearestGroup(_heli, ctld.droppedTroopsBLUE)
            end

        end

        if _extract ~= nil and not ctld.troopsOnboard(_heli, true) then
            -- search for nearest troops to pickup
            return ctld.extractTroops({ _heli:getName(), true })
        else
            return ctld.unloadTroops({ _heli:getName(), true, true })
        end
    end, { _heli }, timer.getTime() + ctld.unloadTroopsTime)
    ctld.displayMessageToGroup(_heli, "步兵行动中，"..ctld.unloadTroopsTime.."秒后完成", 10)

end

-- load troops onto vehicle
function ctld.loadTroops(_heli, _troops, _numberOrTemplate)

    -- load troops + vehicles if c130 or herc
    -- "M1045 HMMWV TOW"
    -- "M1043 HMMWV Armament"
    local _onboard = ctld.inTransitTroops[_heli:getName()]

    --number doesnt apply to vehicles
    if _numberOrTemplate == nil or (type(_numberOrTemplate) ~= "table" and type(_numberOrTemplate) ~= "number") then
        _numberOrTemplate = ctld.numberOfTroops
    end

    if _onboard == nil then
        _onboard = { troops = {}, vehicles = {} }
    end

    local _list
    if _heli:getCoalition() == 1 then
        _list = ctld.vehiclesForTransportRED
    else
        _list = ctld.vehiclesForTransportBLUE
    end

    ctld.logTrace(string.format("_troops=%s", ctld.p(_troops)))
    if _troops then
        _onboard.troops = ctld.generateTroopTypes(_heli:getCoalition(), _numberOrTemplate, _heli:getCountry())
        ctld.logTrace(string.format("_onboard.troops=%s", ctld.p(_onboard.troops)))
        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " loaded troops into " .. _heli:getTypeName(), 10)

        ctld.processCallback({ unit = _heli, onboard = _onboard.troops, action = "load_troops" })
    else

        _onboard.vehicles = ctld.generateVehiclesForTransport(_heli:getCoalition(), _heli:getCountry())

        local _count = #_list

        ctld.processCallback({ unit = _heli, onboard = _onboard.vehicles, action = "load_vehicles" })

        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " loaded " .. _count .. " vehicles into " .. _heli:getTypeName(), 10)
    end

    ctld.inTransitTroops[_heli:getName()] = _onboard
    ctld.logTrace(string.format("ctld.inTransitTroops=%s", ctld.p(ctld.inTransitTroops[_heli:getName()])))
    ctld.adaptWeightToCargo(_heli:getName())
end

function ctld.generateVehiclesForTransport(_side, _country)

    local _vehicles = {}
    local _list
    if _side == 1 then
        _list = ctld.vehiclesForTransportRED
    else
        _list = ctld.vehiclesForTransportBLUE
    end

    for _i, _type in ipairs(_list) do

        local _unitId = ctld.getNextUnitId()
        local _weight = ctld.vehiclesWeight[_type] or 2500
        _vehicles[_i] = { type = _type, unitId = _unitId, name = string.format("Dropped %s #%i", _type, _unitId), weight = _weight }
    end

    local _groupId = ctld.getNextGroupId()
    local _details = { units = _vehicles, groupId = _groupId, groupName = string.format("Dropped Group %i", _groupId), side = _side, country = _country }

    return _details
end

function ctld.loadUnloadFOBCrate(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _troops = _args[2]

    if _heli == nil then
        return
    end

    if ctld.inAir(_heli) == true then
        return
    end

    local _side = _heli:getCoalition()

    local _inZone = ctld.inLogisticsZone(_heli)
    local _crateOnboard = ctld.inTransitFOBCrates[_heli:getName()] ~= nil

    if _inZone == false and _crateOnboard == true then

        ctld.inTransitFOBCrates[_heli:getName()] = nil

        local _position = _heli:getPosition()

        --try to spawn at 6 oclock to us
        local _angle = math.atan2(_position.x.z, _position.x.x)
        local _xOffset = math.cos(_angle) * -60
        local _yOffset = math.sin(_angle) * -60

        local _point = _heli:getPoint()

        local _side = _heli:getCoalition()

        local _unitId = ctld.getNextUnitId()

        local _name = string.format("FOB Crate #%i", _unitId)

        local _spawnedCrate = ctld.spawnFOBCrateStatic(_heli:getCountry(), ctld.getNextUnitId(), { x = _point.x + _xOffset, z = _point.z + _yOffset }, _name)

        if _side == 1 then
            ctld.droppedFOBCratesRED[_name] = _name
        else
            ctld.droppedFOBCratesBLUE[_name] = _name
        end

        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " delivered a FOB Crate", 10)

        ctld.displayMessageToGroup(_heli, "Delivered FOB Crate 60m at 6'oclock to you", 10)

    elseif _inZone == true and _crateOnboard == true then

        ctld.displayMessageToGroup(_heli, "FOB Crate dropped back to base", 10)

        ctld.inTransitFOBCrates[_heli:getName()] = nil

    elseif _inZone == true and _crateOnboard == false then
        ctld.displayMessageToGroup(_heli, "FOB Crate Loaded", 10)

        ctld.inTransitFOBCrates[_heli:getName()] = true

        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " loaded a FOB Crate ready for delivery!", 10)

    else

        -- nearest Crate
        local _crates = ctld.getCratesAndDistance(_heli)
        local _nearestCrate = ctld.getClosestCrate(_heli, _crates, "FOB")

        if _nearestCrate ~= nil and _nearestCrate.dist < 150 then

            ctld.displayMessageToGroup(_heli, "FOB Crate Loaded", 10)
            ctld.inTransitFOBCrates[_heli:getName()] = true

            trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " loaded a FOB Crate ready for delivery!", 10)

            if _side == 1 then
                ctld.droppedFOBCratesRED[_nearestCrate.crateUnit:getName()] = nil
            else
                ctld.droppedFOBCratesBLUE[_nearestCrate.crateUnit:getName()] = nil
            end

            --remove
            _nearestCrate.crateUnit:destroy()

        else
            ctld.displayMessageToGroup(_heli, "There are no friendly logistic units nearby to load a FOB crate from!", 10)
        end
    end
end

function ctld.loadTroopsFromZone(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _troops = _args[2]
    local _groupTemplate = _args[3] or ""
    local _allowExtract = _args[4]

    if _heli == nil then
        return false
    end

    local _inZone = ctld.inLogisticsZone(_heli)
    --local _zone = ctld.inPickupZone(_heli)

    if ctld.troopsOnboard(_heli, _troops) then

        if _troops then
            ctld.displayMessageToGroup(_heli, "You already have troops onboard.", 10)
        else
            ctld.displayMessageToGroup(_heli, "You already have vehicles onboard.", 10)
        end

        return false
    end

    local _extract

    if _allowExtract then
        -- first check for extractable troops regardless of if we're in a zone or not
        if _troops then
            if _heli:getCoalition() == 1 then
                _extract = ctld.findNearestGroup(_heli, ctld.droppedTroopsRED)
            else
                _extract = ctld.findNearestGroup(_heli, ctld.droppedTroopsBLUE)
            end
        else

            if _heli:getCoalition() == 1 then
                _extract = ctld.findNearestGroup(_heli, ctld.droppedVehiclesRED)
            else
                _extract = ctld.findNearestGroup(_heli, ctld.droppedVehiclesBLUE)
            end
        end
    end

    if _extract ~= nil then
        -- search for nearest troops to pickup
        return ctld.extractTroops({ _heli:getName(), _troops })
    elseif _inZone == true then
        ctld.loadTroops(_heli, _troops, _groupTemplate)
        --if _zone.limit - 1 >= 0 then
        --    -- decrease zone counter by 1
        --    ctld.updateZoneCounter(_zone.index, -1)
        --
        --    ctld.loadTroops(_heli, _troops, _groupTemplate)
        --
        --    return true
        --else
        --    ctld.displayMessageToGroup(_heli, "This area has no more reinforcements available!", 20)
        --
        --    return false
        --end

    else
        if _allowExtract then
            ctld.displayMessageToGroup(_heli, "You are not in a cc and no one is nearby to extract", 10)
        else
            ctld.displayMessageToGroup(_heli, "You are not in a cc", 10)
        end

        return false
    end
end

function ctld.unloadTroops(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _troops = _args[2]

    if _heli == nil then
        return false
    end

    local _zone = ctld.inPickupZone(_heli)
    if not ctld.troopsOnboard(_heli, _troops) then

        ctld.displayMessageToGroup(_heli, "No one to unload", 10)

        return false
    else

        -- troops must be onboard to get here
        if _zone.inZone == true then

            if _troops then
                ctld.displayMessageToGroup(_heli, "Dropped troops back to base", 20)

                ctld.processCallback({ unit = _heli, unloaded = ctld.inTransitTroops[_heli:getName()].troops, action = "unload_troops_zone" })

                ctld.inTransitTroops[_heli:getName()].troops = nil

            else
                ctld.displayMessageToGroup(_heli, "Dropped vehicles back to base", 20)

                ctld.processCallback({ unit = _heli, unloaded = ctld.inTransitTroops[_heli:getName()].vehicles, action = "unload_vehicles_zone" })

                ctld.inTransitTroops[_heli:getName()].vehicles = nil
            end

            ctld.adaptWeightToCargo(_heli:getName())

            -- increase zone counter by 1
            ctld.updateZoneCounter(_zone.index, 1)

            return true

        elseif ctld.troopsOnboard(_heli, _troops) then

            return ctld.deployTroops(_heli, _troops)
        end
    end

end

function ctld.extractTroops(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _troops = _args[2]

    if _heli == nil then
        return false
    end

    if ctld.inAir(_heli) then
        return false
    end

    if ctld.troopsOnboard(_heli, _troops) then
        if _troops then
            ctld.displayMessageToGroup(_heli, "You already have troops onboard.", 10)
        else
            ctld.displayMessageToGroup(_heli, "You already have vehicles onboard.", 10)
        end

        return false
    end

    local _onboard = ctld.inTransitTroops[_heli:getName()]

    if _onboard == nil then
        _onboard = { troops = nil, vehicles = nil }
    end

    local _extracted = false

    if _troops then

        local _extractTroops

        if _heli:getCoalition() == 1 then
            _extractTroops = ctld.findNearestGroup(_heli, ctld.droppedTroopsRED)
        else
            _extractTroops = ctld.findNearestGroup(_heli, ctld.droppedTroopsBLUE)
        end

        if _extractTroops ~= nil then

            local _limit = ctld.getTransportLimit(_heli:getTypeName())

            local _size = #_extractTroops.group:getUnits()

            if _limit < #_extractTroops.group:getUnits() then

                ctld.displayMessageToGroup(_heli, "Sorry - The group of " .. _size .. " is too large to fit. \n\nLimit is " .. _limit .. " for " .. _heli:getTypeName(), 20)

                return
            end

            _onboard.troops = _extractTroops.details
            _onboard.troops.weight = #_extractTroops.group:getUnits() * 130 -- default to 130kg per soldier

            if _extractTroops.group:getName():lower():find("jtac") then
                _onboard.troops.jtac = true
            end

            trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " extracted troops in " .. _heli:getTypeName() .. " from combat", 10)

            if _heli:getCoalition() == 1 then
                ctld.droppedTroopsRED[_extractTroops.group:getName()] = nil
            else
                ctld.droppedTroopsBLUE[_extractTroops.group:getName()] = nil
            end

            ctld.processCallback({ unit = _heli, extracted = _extractTroops, action = "extract_troops" })

            --remove
            _extractTroops.group:destroy()

            _extracted = true
        else
            _onboard.troops = nil
            ctld.displayMessageToGroup(_heli, "No extractable troops nearby!", 20)
        end

    else

        local _extractVehicles

        if _heli:getCoalition() == 1 then

            _extractVehicles = ctld.findNearestGroup(_heli, ctld.droppedVehiclesRED)
        else

            _extractVehicles = ctld.findNearestGroup(_heli, ctld.droppedVehiclesBLUE)
        end

        if _extractVehicles ~= nil then
            _onboard.vehicles = _extractVehicles.details

            if _heli:getCoalition() == 1 then

                ctld.droppedVehiclesRED[_extractVehicles.group:getName()] = nil
            else

                ctld.droppedVehiclesBLUE[_extractVehicles.group:getName()] = nil
            end

            trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " extracted vehicles in " .. _heli:getTypeName() .. " from combat", 10)

            ctld.processCallback({ unit = _heli, extracted = _extractVehicles, action = "extract_vehicles" })
            --remove
            _extractVehicles.group:destroy()
            _extracted = true

        else
            _onboard.vehicles = nil
            ctld.displayMessageToGroup(_heli, "No extractable vehicles nearby!", 20)
        end
    end

    ctld.inTransitTroops[_heli:getName()] = _onboard
    ctld.adaptWeightToCargo(_heli:getName())

    return _extracted
end

function ctld.checkTroopStatus(_args)
    local _unitName = _args[1]
    local _heli = ctld.getTransportUnit(_unitName)
    if _heli == nil then return end

    -- 获取所有箱子信息
    local _message = ""
    local _crates = ctld.inTransitSlingLoadCrates[_unitName] or {}
    if #_crates > 0 then
        _message = "当前运输的箱子:\n"
        for i, crate in ipairs(_crates) do
            _message = _message .. i .. ": " .. crate.desc .. " (" .. crate.weight .. "kg)\n"
        end
    else
        _message = "没有运输任何箱子"
    end

    ctld.displayMessageToGroup(_heli, _message, 10)
end

-- Removes troops from transport when it dies
function ctld.checkTransportStatus()

    timer.scheduleFunction(ctld.checkTransportStatus, nil, timer.getTime() + 10)

    for _, _name in ipairs(ctld.transportPilotNames) do

        local _transUnit = ctld.getTransportUnit(_name)

        if _transUnit == nil then
            --ctld.logInfo("CTLD Transport Unit Dead event")
            ctld.inTransitTroops[_name] = nil
            ctld.inTransitFOBCrates[_name] = nil
            ctld.inTransitSlingLoadCrates[_name] = nil
        end
    end
end

function ctld.adaptWeightToCargo(unitName)
    local _weight = ctld.getWeightOfCargo(unitName)
    trigger.action.setUnitInternalCargo(unitName, _weight)
end

function ctld.getWeightOfCargo(unitName)
    ctld.logDebug(string.format("ctld.getWeightOfCargo(%s)", ctld.p(unitName)))

    local FOB_CRATE_WEIGHT = 800
    local _weight = 0
    local _description = ""

    -- add troops weight
    if ctld.inTransitTroops[unitName] then
        ctld.logTrace("ctld.inTransitTroops = true")
        local _inTransit = ctld.inTransitTroops[unitName]
        if _inTransit then
            ctld.logTrace(string.format("_inTransit=%s", ctld.p(_inTransit)))
            local _troops = _inTransit.troops
            if _troops and _troops.units then
                ctld.logTrace(string.format("_troops.weight=%s", ctld.p(_troops.weight)))
                _description = _description .. string.format("%s troops onboard (%s kg)\n", #_troops.units, _troops.weight)
                _weight = _weight + _troops.weight
            end
            local _vehicles = _inTransit.vehicles
            if _vehicles and _vehicles.units then
                for _, _unit in pairs(_vehicles.units) do
                    _weight = _weight + _unit.weight
                end
                ctld.logTrace(string.format("_weight=%s", ctld.p(_weight)))
                _description = _description .. string.format("%s vehicles onboard (%s kg)\n", #_vehicles.units, _weight)
            end
        end
    end
    ctld.logTrace(string.format("with troops and vehicles : weight = %s", tostring(_weight)))

    -- add FOB crates weight
    if ctld.inTransitFOBCrates[unitName] then
        ctld.logTrace("ctld.inTransitFOBCrates = true")
        _weight = _weight + FOB_CRATE_WEIGHT
        _description = _description .. string.format("1 FOB Crate oboard (%s kg)\n", FOB_CRATE_WEIGHT)
    end
    ctld.logTrace(string.format("with FOB crates : weight = %s", tostring(_weight)))

    -- add simulated slingload crates weight
    local _crate = ctld.inTransitSlingLoadCrates[unitName]
    if _crate then
        ctld.logTrace(string.format("_crate=%s", ctld.p(_crate)))
        for _, crate in pairs(_crate) do
            local crateWeight = tonumber(crate.weight) or 0
            ctld.logTrace(string.format("crate.weight=%s", crateWeight))
            _weight = _weight + crateWeight
            _description = _description .. string.format("1 %s crate onboard (%s kg)\n", crate.desc or "unknown", crateWeight)
        end
    end
    ctld.logTrace(string.format("with simulated slingload crates : weight = %s", tostring(_weight)))
    if _description ~= "" then
        _description = _description .. string.format("Total weight of cargo : %s kg\n", _weight)
    else
        _description = "No cargo."
    end
    ctld.logTrace(string.format("_description = %s", tostring(_description)))

    return _weight, _description
end

function ctld.checkHoverStatus()
    --ctld.logDebug(string.format("ctld.checkHoverStatus()"))
    timer.scheduleFunction(ctld.checkHoverStatus, nil, timer.getTime() + 5)

    local _status, _result = pcall(function()

        for _, _name in ipairs(ctld.transportPilotNames) do

            local _reset = true
            local _transUnit = ctld.getTransportUnit(_name)

            --only check transports that are hovering and not planes
            if _transUnit ~= nil and ctld.inTransitSlingLoadCrates[_name] == nil and ctld.inAir(_transUnit) and ctld.unitCanCarryVehicles(_transUnit) == false then

                --ctld.logTrace(string.format("%s - capable of slingloading", ctld.p(_name)))

                local _crates = ctld.getCratesAndDistance(_transUnit)
                --ctld.logTrace(string.format("_crates = %s", ctld.p(_crates)))

                for _, _crate in pairs(_crates) do
                    --ctld.logTrace(string.format("_crate = %s", ctld.p(_crate)))
                    if _crate.dist < ctld.maxDistanceFromCrate and _crate.details.unit ~= "FOB" then

                        --check height!
                        local _height = _transUnit:getPoint().y - _crate.crateUnit:getPoint().y
                        --ctld.logInfo("HEIGHT " .. _name .. " " .. _height .. " " .. _transUnit:getPoint().y .. " " .. _crate.crateUnit:getPoint().y)
                        --  ctld.heightDiff(_transUnit)
                        --ctld.logInfo("HEIGHT ABOVE GROUD ".._name.." ".._height.." ".._transUnit:getPoint().y.." ".._crate.crateUnit:getPoint().y)
                        --ctld.logTrace(string.format("_height = %s", ctld.p(_height)))

                        if _height > ctld.minimumHoverHeight and _height <= ctld.maximumHoverHeight then

                            local _time = ctld.hoverStatus[_transUnit:getName()]
                            --ctld.logTrace(string.format("_time = %s", ctld.p(_time)))

                            if _time == nil then
                                ctld.hoverStatus[_transUnit:getName()] = ctld.hoverTime
                                _time = ctld.hoverTime
                            else
                                _time = ctld.hoverStatus[_transUnit:getName()] - 1
                                ctld.hoverStatus[_transUnit:getName()] = _time
                            end

                            if _time > 0 then
                                ctld.displayMessageToGroup(_transUnit, "Hovering above " .. _crate.details.desc .. " crate. \n\nHold hover for " .. _time .. " seconds! \n\nIf the countdown stops you're too far away!", 10, true)
                            else
                                ctld.hoverStatus[_transUnit:getName()] = nil
                                --ctld.displayMessageToGroup(_transUnit, "Loaded  " .. _crate.details.desc .. " crate!", 10, true)
                                ctld.displayMessageToGroup(_transUnit, "装载  " .. _crate.details.desc .. " 箱子", 10, true)

                                --crates been moved once!
                                ctld.crateMove[_crate.crateUnit:getName()] = nil

                                if _transUnit:getCoalition() == 1 then
                                    ctld.spawnedCratesRED[_crate.crateUnit:getName()] = nil
                                else
                                    ctld.spawnedCratesBLUE[_crate.crateUnit:getName()] = nil
                                end

                                _crate.crateUnit:destroy()

                                local _copiedCrate = mist.utils.deepCopy(_crate.details)
                                _copiedCrate.simulatedSlingload = true
                                --ctld.logTrace(string.format("_copiedCrate = %s", ctld.p(_copiedCrate)))
                                ctld.inTransitSlingLoadCrates[_name] = _copiedCrate
                                ctld.adaptWeightToCargo(_name)
                            end

                            _reset = false

                            break
                        elseif _height <= ctld.minimumHoverHeight then
                            ctld.displayMessageToGroup(_transUnit, "Too low to hook " .. _crate.details.desc .. " crate.\n\nHold hover for " .. ctld.hoverTime .. " seconds", 5, true)
                            break
                        else
                            ctld.displayMessageToGroup(_transUnit, "Too high to hook " .. _crate.details.desc .. " crate.\n\nHold hover for " .. ctld.hoverTime .. " seconds", 5, true)
                            break
                        end
                    end
                end
            end

            if _reset then
                ctld.hoverStatus[_name] = nil
            end
        end
    end)

    if (not _status) then
        env.error(string.format("CTLD ERROR: %s", _result))
    end
end

function ctld.loadNearbyCrate(_name)
    local _transUnit = ctld.getTransportUnit(_name)
    if _transUnit == nil then return end

    -- 初始化运输箱数组
    ctld.inTransitSlingLoadCrates[_name] = ctld.inTransitSlingLoadCrates[_name] or {}
    local _crateCount = #ctld.inTransitSlingLoadCrates[_name]
    local availableUnitTypes = {"MosquitoFBMkVI", "CH-47Fbl1"}
    local unitType = _transUnit:getTypeName()
    if unitType == "C-130J-30" then
        local _msg = "C-130J 请使用自带装卸面板装载箱子！"
        ctld.displayMessageToGroup(_transUnit, _msg, 10, true)
        return
    end
    local _maxCrates = 1
    for _, typename in ipairs(availableUnitTypes) do
                if unitType == typename then
                    _maxCrates = 2
                    break -- Exit loop once found to save time
                end
            end
    if _crateCount >= _maxCrates then
        local _msg = "你已经拥有".._maxCrates.."个箱子，装不下更多了"
        ctld.displayMessageToGroup(_transUnit, _msg, 10, true)
        return
    end

    if ctld.inAir(_transUnit) then
        ctld.displayMessageToGroup(_transUnit, "你必须先着陆才能装箱子！", 10, true)
        return
    end

    -- 装载箱子
    local _crates = ctld.getCratesAndDistance(_transUnit)
    local _inRangeCrates = {}
    for _, _crate in pairs(_crates) do
        if _crate.dist < 50.0 then
            table.insert(_inRangeCrates, _crate)
        end
    end

    if #_inRangeCrates == 0 then
        ctld.displayMessageToGroup(_transUnit, "50米内未找到可装载的箱子！", 10, true)
        return
    end
    --距离排序
    table.sort(_inRangeCrates, function(a, b)
        return a.dist < b.dist
    end)
    local _nearestCrate = _inRangeCrates[1]

    ctld.displayMessageToGroup(_transUnit, "装载 " .. _nearestCrate.details.desc .. " 箱子\n你已增重".._nearestCrate.details.weight.."kg", 10, true)

    -- 移除场景中的箱子
    if _transUnit:getCoalition() == 1 then
        ctld.spawnedCratesRED[_nearestCrate.crateUnit:getName()] = nil
    else
        ctld.spawnedCratesBLUE[_nearestCrate.crateUnit:getName()] = nil
    end
    _nearestCrate.crateUnit:destroy()

    -- 添加箱子到运输列表
    _nearestCrate.simulatedSlingload = true
    table.insert(ctld.inTransitSlingLoadCrates[_name], mist.utils.deepCopy(_nearestCrate.details))
    ctld.adaptWeightToCargo(_name)
end

--recreates beacons to make sure they work!
function ctld.refreshRadioBeacons()

    timer.scheduleFunction(ctld.refreshRadioBeacons, nil, timer.getTime() + 30)

    for _index, _beaconDetails in ipairs(ctld.deployedRadioBeacons) do

        --trigger.action.outTextForCoalition(_beaconDetails.coalition,_beaconDetails.text,10)
        if ctld.updateRadioBeacon(_beaconDetails) == false then

            --search used frequencies + remove, add back to unused

            for _i, _freq in ipairs(ctld.usedUHFFrequencies) do
                if _freq == _beaconDetails.uhf then

                    table.insert(ctld.freeUHFFrequencies, _freq)
                    table.remove(ctld.usedUHFFrequencies, _i)
                end
            end

            for _i, _freq in ipairs(ctld.usedVHFFrequencies) do
                if _freq == _beaconDetails.vhf then

                    table.insert(ctld.freeVHFFrequencies, _freq)
                    table.remove(ctld.usedVHFFrequencies, _i)
                end
            end

            for _i, _freq in ipairs(ctld.usedFMFrequencies) do
                if _freq == _beaconDetails.fm then

                    table.insert(ctld.freeFMFrequencies, _freq)
                    table.remove(ctld.usedFMFrequencies, _i)
                end
            end

            --clean up beacon table
            table.remove(ctld.deployedRadioBeacons, _index)
        end
    end
end

function ctld.getClockDirection(_heli, _crate)

    -- Source: Helicopter Script - Thanks!

    local _position = _crate:getPosition().p -- get position of crate
    local _playerPosition = _heli:getPosition().p -- get position of helicopter
    local _relativePosition = mist.vec.sub(_position, _playerPosition)

    local _playerHeading = mist.getHeading(_heli) -- the rest of the code determines the 'o'clock' bearing of the missile relative to the helicopter

    local _headingVector = { x = math.cos(_playerHeading), y = 0, z = math.sin(_playerHeading) }

    local _headingVectorPerpendicular = { x = math.cos(_playerHeading + math.pi / 2), y = 0, z = math.sin(_playerHeading + math.pi / 2) }

    local _forwardDistance = mist.vec.dp(_relativePosition, _headingVector)

    local _rightDistance = mist.vec.dp(_relativePosition, _headingVectorPerpendicular)

    local _angle = math.atan2(_rightDistance, _forwardDistance) * 180 / math.pi

    if _angle < 0 then
        _angle = 360 + _angle
    end
    _angle = math.floor(_angle * 12 / 360 + 0.5)
    if _angle == 0 then
        _angle = 12
    end

    return _angle
end

function ctld.getCompassBearing(_ref, _unitPos)

    _ref = mist.utils.makeVec3(_ref, 0) -- turn it into Vec3 if it is not already.
    _unitPos = mist.utils.makeVec3(_unitPos, 0) -- turn it into Vec3 if it is not already.

    local _vec = { x = _unitPos.x - _ref.x, y = _unitPos.y - _ref.y, z = _unitPos.z - _ref.z }

    local _dir = mist.utils.getDir(_vec, _ref)

    local _bearing = mist.utils.round(mist.utils.toDegree(_dir), 0)

    return _bearing
end

function ctld.listNearbyCrates(_args)

    local _message = ""

    local _heli = ctld.getTransportUnit(_args[1])

    if _heli == nil then

        return -- no heli!
    end

    local _crates = ctld.getCratesAndDistance(_heli)

    --sort
    local _sort = function(a, b)
        return a.dist < b.dist
    end
    table.sort(_crates, _sort)

    for _, _crate in pairs(_crates) do

        if _crate.dist < 1000 and _crate.details.unit ~= "FOB" then
            _message = string.format("%s\n%s crate - kg %i - %i m - %d o'clock", _message, _crate.details.desc, _crate.details.weight, _crate.dist, ctld.getClockDirection(_heli, _crate.crateUnit))
        end
    end

    local _fobMsg = ""
    for _, _fobCrate in pairs(_crates) do

        if _fobCrate.dist < 1000 and _fobCrate.details.unit == "FOB" then
            _fobMsg = _fobMsg .. string.format("FOB Crate - %d m - %d o'clock\n", _fobCrate.dist, ctld.getClockDirection(_heli, _fobCrate.crateUnit))
        end
    end

    if _message ~= "" or _fobMsg ~= "" then

        local _txt = ""

        if _message ~= "" then
            _txt = "Nearby Crates:\n" .. _message
        end

        if _fobMsg ~= "" then

            if _message ~= "" then
                _txt = _txt .. "\n\n"
            end

            _txt = _txt .. "Nearby FOB Crates (Not Slingloadable):\n" .. _fobMsg
        end

        ctld.displayMessageToGroup(_heli, _txt, 20)

    else
        --no crates nearby

        local _txt = "No Nearby Crates"

        ctld.displayMessageToGroup(_heli, _txt, 20)
    end
end

function ctld.listFOBS(_args)

    local _msg = "FOB Positions:"

    local _heli = ctld.getTransportUnit(_args[1])

    if _heli == nil then

        return -- no heli!
    end

    -- get fob positions

    local _fobs = ctld.getSpawnedFobs(_heli)

    -- now check spawned fobs
    for _, _fob in ipairs(_fobs) do
        _msg = string.format("%s\nFOB @ %s", _msg, ctld.getFOBPositionString(_fob))
    end

    if _msg == "FOB Positions:" then
        ctld.displayMessageToGroup(_heli, "Sorry, there are no active FOBs!", 20)
    else
        ctld.displayMessageToGroup(_heli, _msg, 20)
    end
end

function ctld.getFOBPositionString(_fob)

    local _lat, _lon = coord.LOtoLL(_fob:getPosition().p)

    local _latLngStr = mist.tostringLL(_lat, _lon, 3, ctld.location_DMS)

    --   local _mgrsString = mist.tostringMGRS(coord.LLtoMGRS(coord.LOtoLL(_fob:getPosition().p)), 5)

    local _message = _latLngStr

    local _beaconInfo = ctld.fobBeacons[_fob:getName()]

    if _beaconInfo ~= nil then
        _message = string.format("%s - %.2f KHz ", _message, _beaconInfo.vhf / 1000)
        _message = string.format("%s - %.2f MHz ", _message, _beaconInfo.uhf / 1000000)
        _message = string.format("%s - %.2f MHz ", _message, _beaconInfo.fm / 1000000)
    end

    return _message
end

function ctld.displayMessageToGroup(_unit, _text, _time, _clear)

    local _groupId = ctld.getGroupId(_unit)
    if _groupId then
        if _clear == true then
            trigger.action.outTextForGroup(_groupId, _text, _time, _clear)
        else
            trigger.action.outTextForGroup(_groupId, _text, _time)
        end
    end
end

function ctld.heightDiff(_unit)

    local _point = _unit:getPoint()

    -- ctld.logInfo("heightunit " .. _point.y)
    --ctld.logInfo("heightland " .. land.getHeight({ x = _point.x, y = _point.z }))

    return _point.y - land.getHeight({ x = _point.x, y = _point.z })
end

--includes fob crates!
function ctld.getCratesAndDistance(_heli)

    local _crates = {}

    local _allCrates
    if _heli:getCoalition() == 1 then
        _allCrates = ctld.spawnedCratesRED
    else
        _allCrates = ctld.spawnedCratesBLUE
    end

    for _crateName, _details in pairs(_allCrates) do

        --get crate
        local _crate = ctld.getCrateObject(_crateName)

        --in air seems buggy with crates so if in air is true, get the height above ground and the speed magnitude
        if _crate ~= nil and _crate:getLife() > 0
                and (ctld.inAir(_crate) == false) then

            local _dist = ctld.getDistance(_crate:getPoint(), _heli:getPoint())

            local _crateDetails = { crateUnit = _crate, dist = _dist, details = _details }

            table.insert(_crates, _crateDetails)
        end
    end

    local _fobCrates
    if _heli:getCoalition() == 1 then
        _fobCrates = ctld.droppedFOBCratesRED
    else
        _fobCrates = ctld.droppedFOBCratesBLUE
    end

    for _crateName, _details in pairs(_fobCrates) do

        --get crate
        local _crate = ctld.getCrateObject(_crateName)

        if _crate ~= nil and _crate:getLife() > 0 then

            local _dist = ctld.getDistance(_crate:getPoint(), _heli:getPoint())

            local _crateDetails = { crateUnit = _crate, dist = _dist, details = { unit = "FOB" }, }

            table.insert(_crates, _crateDetails)
        end
    end

    return _crates
end

function ctld.getClosestCrate(_heli, _crates, _type)

    local _closetCrate = nil
    local _shortestDistance = -1
    local _distance = 0

    for _, _crate in pairs(_crates) do

        if (_crate.details.unit == _type or _type == nil) then
            _distance = _crate.dist

            if _distance ~= nil and (_shortestDistance == -1 or _distance < _shortestDistance) then
                _shortestDistance = _distance
                _closetCrate = _crate
            end
        end
    end

    return _closetCrate
end

function ctld.findNearestGroupSystem(_heli, _groupSystem)

    local _closestGroup = nil
    local _shortestDistance = -1
    local _distance = 0

    for _groupName, _groupDetails in pairs(ctld.completeGroupSystems) do

        local _group = Group.getByName(_groupName)

        --  ctld.logInfo(_groupName..": "..mist.utils.tableShow(_hawkDetails))
        if _group ~= nil and _group:getCoalition() == _heli:getCoalition() and _groupDetails[1].system.name == _groupSystem.name then

            local _units = _group:getUnits()

            for _, _leader in pairs(_units) do

                if _leader ~= nil and _leader:getLife() > 0 then

                    _distance = ctld.getDistance(_leader:getPoint(), _heli:getPoint())

                    if _distance ~= nil and (_shortestDistance == -1 or _distance < _shortestDistance) then
                        _shortestDistance = _distance
                        _closestGroup = _group
                    end

                    break
                end
            end
        end
    end

    if _closestGroup ~= nil then
        return { group = _closestGroup, dist = _shortestDistance }
    end
    return nil
end

function ctld.getCrateObject(_name)
    local _crate

    if ctld.staticBugWorkaround then
        _crate = Unit.getByName(_name)
    else
        _crate = StaticObject.getByName(_name)
    end
    return _crate
end

function ctld.dropAndUnpackCrates(_arguments)
    local _unitName = _arguments[1]
    local needCheck = _arguments[2]
    local _heli = ctld.getTransportUnit(_unitName)
    if _heli == nil then return end
    if not ctld.inAir(_heli) then
        local _currentCrates = ctld.inTransitSlingLoadCrates[_unitName] or {}
        local _crateCount = #_currentCrates + 1

        if _crateCount == 0 then
            ctld.displayMessageToGroup(_heli, "你目前没有运输任何箱子。", 10)
            return
        end

        for i = 1, _crateCount do
            timer.scheduleFunction(ctld.dropSlingCrate, _arguments, timer.getTime() + 0.2 * (i-1))
        end
        
        -- Schedule the unpack to run after the last crate has been dropped, with a small buffer.
        local unpackDelay = 0.2 * (_crateCount - 1) + 0.5
        timer.scheduleFunction(ctld.unpackCrates, _arguments, timer.getTime() + unpackDelay)
    else
        ctld.displayMessageToGroup(_heli, "你的离地高度大于"..ctld.airDropHeight.."米，无法卸货！", 10, true)
    end
end

function ctld.crateAddPoint(_heli,_num)
    local _name = _heli:getPlayerName()           --平常用
    if _name == nil then
        return
    end
    local _ucid = SourceObj.playerInfo[_name]
    if _ucid == nil then
        return
    end

    SourceObj.playerSource[_ucid]["point"] = SourceObj.playerSource[_ucid]["point"] + SourceObj.addCrate*_num
    SourceObj.SaveSourcePoint()
    local text = string.format("吊箱子奖励%d点", SourceObj.addCrate*_num)
    ctld.displayMessageToGroup(_heli, text, 20)
    trigger.action.outSoundForGroup(_heli, "war-thunder-kill.ogg")
end

function ctld.unpackCrates(_arguments)--_arguments

    local _status, _err = pcall(function(_args)

        -- trigger.action.outText("Unpack Crates".._args[1],10)

        local _heli = ctld.getTransportUnit(_args[1])
        local needCheck = _args[2]
        local inAirCheck = ctld.inAir(_heli)
        if not needCheck then inAirCheck = false end 
        if _heli and not ctld.inAir(_heli) then

            local _crates = ctld.getCratesAndDistance(_heli)
            local _crate = ctld.getClosestCrate(_heli, _crates)

            if ctld.inLogisticsZone(_heli, ctld.IsCheckfarEnoughFromLogisticZone) == true or ctld.farEnoughFromLogisticZone(_heli, ctld.minimumDeployDistance, ctld.IsCheckfarEnoughFromLogisticZone) == false then
                --ctld.displayMessageToGroup(_heli, "You can't unpack that here! Take it to where it's needed!", 20)
                ctld.displayMessageToGroup(_heli, "你不能在这里部署！把箱子带到更远的地方！", 20)
                return
            end

            if _crate ~= nil and _crate.dist < 750
                    and (_crate.details.unit == "FOB" or _crate.details.unit == "FOB-SMALL") then
                ctld.unpackFOBCrates(_crates, _heli)
                return

            elseif _crate ~= nil and _crate.dist < 200 and _crate.details.isShip==true then
                ctld.unpackSHIPs(_crate,_crates, _heli)
                return

            elseif _crate ~= nil and _crate.dist < 200 then

                if ctld.forceCrateToBeMoved and ctld.crateMove[_crate.crateUnit:getName()] then
                    --ctld.displayMessageToGroup(_heli, "Sorry you must move this crate before you unpack it!", 20)
                    ctld.displayMessageToGroup(_heli, "抱歉，你必须在打开箱子之前把它搬走！", 20)
                    return
                end
                ctld.logDebug(string.format("开始Unpacking crate %s", ctld.p(_crate.details)))
                local _groupTemplate = ctld.getGroupTemplate(_crate.details.unit)

                if _groupTemplate then
                    ctld.logDebug(string.format("Found group template for %s", ctld.p(_crate.details.unit)))
                    if _crate.details.unit == _groupTemplate.repair then
                        ctld.repairGroupSystem(_heli, _crate, _groupTemplate)
                    else
                        ctld.unpackGroupSystem(_heli, _crate, _crates, _groupTemplate)
                    end

                    return -- stop processing
                    -- is multi crate?

                    --我们一般不会用到不是一个组，又需要多个箱子的情况，这个可以不用管
                elseif _crate.details.cratesRequired ~= nil and _crate.details.cratesRequired > 1 then
                    -- multicrate
                    ctld.logDebug(string.format("Unpacking multi crate %s", ctld.p(_crate.details)))
                    ctld.unpackMultiCrate(_heli, _crate, _crates)
                    return

                else
                    -- single crate
                    ctld.logDebug(string.format("Unpacking single crate %s", ctld.p(_crate.details)))
                    local _cratePoint = _crate.crateUnit:getPoint()
                    local _crateName = _crate.crateUnit:getName()

                    -- ctld.spawnCrateStatic( _heli:getCoalition(),ctld.getNextUnitId(),{x=100,z=100},_crateName,100)

                    --remove crate
                    --  if ctld.slingLoad == false then

                    -- end

                    local _spawnedGroups = ctld.spawnCrateGroup(_heli, { _cratePoint }, { _crate.details.unit })
                    if _spawnedGroups == nil then
                        return
                    end

                    _crate.crateUnit:destroy()
                    if _heli:getCoalition() == 1 then
                        ctld.spawnedCratesRED[_crateName] = nil
                    else
                        ctld.spawnedCratesBLUE[_crateName] = nil
                    end

                    ctld.crateAddPoint(_heli,1)
                    ctld.processCallback({ unit = _heli, crate = _crate, spawnedGroup = _spawnedGroups, action = "unpack" })

                    if _crate.details.unit == "1L13 EWR" then
                        ctld.addEWRTask(_spawnedGroups)

                        --       ctld.logInfo("Added EWR")
                    end

                    --trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " successfully deployed " .. _crate.details.desc .. " to the field", 10)
                    trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " 成功部署 " .. _crate.details.desc .. " 到战区 ", 10)

                    if ctld.isJTACUnitType(_crate.details.unit) and ctld.JTAC_dropEnabled then
                        local _code = table.remove(ctld.jtacGeneratedLaserCodes, 1)
                        --put to the end
                        table.insert(ctld.jtacGeneratedLaserCodes, _code)
                        --ctld.logTrace('_spawnedGroups:' .. ctld.formatTable(_spawnedGroups).."~~~")
                        --ctld.logTrace('_spawnedGroups name:' .. ctld.formatTable(_spawnedGroups):getName().."~~~")
                        ctld.JTACAutoLase(_spawnedGroups:getName(), _code) --(_jtacGroupName, _laserCode, _smoke, _lock, _colour)
                    end
                end

            else

                --ctld.displayMessageToGroup(_heli, "No friendly crates close enough to unpack", 20)
                ctld.displayMessageToGroup(_heli, "附近没有箱子可展开！", 20)
            end
        else
            ctld.displayMessageToGroup(_heli, "你的离地高度大于"..ctld.airDropHeight.."米，无法展开箱子！", 20)
        end
    end, _arguments)

    if (not _status) then
        env.error(string.format("CTLD ERROR: %s", _err))
    end
end


-- builds a fob!
function ctld.unpackFOBCrates(_crates, _heli)
    if not _heli then return end
    if ctld.farEnoughFromLogisticZone(_heli, ctld.minimumDistanceBetweenFobs) == false then
        ctld.displayMessageToGroup(_heli, "野战FOB以及CC之间必须至少间隔" .. ctld.minimumDistanceBetweenFobs, 20)
        return
    end

    -- unpack multi crate
    local _nearbyMultiCrates = {}

    local _bigFobCrates = 0
    local _smallFobCrates = 0
    local _totalCrates = 0

    for _, _nearbyCrate in pairs(_crates) do

        if _nearbyCrate.dist < 750 then

            if _nearbyCrate.details.unit == "FOB" then
                _bigFobCrates = _bigFobCrates + 1
                table.insert(_nearbyMultiCrates, _nearbyCrate)
            elseif _nearbyCrate.details.unit == "FOB-SMALL" then
                _smallFobCrates = _smallFobCrates + 1
                table.insert(_nearbyMultiCrates, _nearbyCrate)
            end

            --catch divide by 0
            if _smallFobCrates > 0 then
                _totalCrates = _bigFobCrates + (_smallFobCrates / 3.0)
            else
                _totalCrates = _bigFobCrates
            end

            if _totalCrates >= ctld.cratesRequiredForFOB then
                break
            end
        end
    end

    --- check crate count
    if _totalCrates >= ctld.cratesRequiredForFOB then

        -- destroy crates

        local _points = {}

        for _, _crate in pairs(_nearbyMultiCrates) do

            if _heli:getCoalition() == 1 then
                ctld.droppedFOBCratesRED[_crate.crateUnit:getName()] = nil
                ctld.spawnedCratesRED[_crate.crateUnit:getName()] = nil
            else
                ctld.droppedFOBCratesBLUE[_crate.crateUnit:getName()] = nil
                ctld.spawnedCratesBLUE[_crate.crateUnit:getName()] = nil
            end

            table.insert(_points, _crate.crateUnit:getPoint())

            --destroy
            _crate.crateUnit:destroy()
        end

        local _centroid = ctld.getCentroid(_points)

        timer.scheduleFunction(function(_args)

            local _unitId = ctld.getNextUnitId()
            local _name = "Deployed FOB #" .. _unitId

            local _fob = ctld.spawnFOB(_args[2], _unitId, _args[1], _name)

            --make it able to deploy crates
            --table.insert(ctld.logisticUnits, _fob:getName())
            --储存fob位置
            local _logistic = StaticObject.getByName(_fob:getName())
            table.insert(ctld.fobLocation, { point = _logistic:getPoint(), obj = _fob })
            --
            timer.scheduleFunction(dsave.recordAllCCsElements, nil, timer.getTime() + 20)
            --不需要塔康信标
            --[[
                        ctld.beaconCount = ctld.beaconCount + 1
                        local _radioBeaconName = "FOB Beacon #" .. ctld.beaconCount
                        local _radioBeaconDetails = ctld.createRadioBeacon(_args[1], _args[3], _args[2], _radioBeaconName, nil, true)
                        ctld.fobBeacons[_name] = { vhf = _radioBeaconDetails.vhf, uhf = _radioBeaconDetails.uhf, fm = _radioBeaconDetails.fm }
            ]]

            if ctld.troopPickupAtFOB == true then
                table.insert(ctld.builtFOBS, _fob:getName())
                --trigger.action.outTextForCoalition(_args[3], "Finished building FOB! Crates and Troops can now be picked up.", 10)
                trigger.action.outTextForCoalition(_args[3], "FOB建造完成，可在附近调出箱子.", 10)
            else
                --trigger.action.outTextForCoalition(_args[3], "Finished building FOB! Crates can now be picked up.", 10)
                trigger.action.outTextForCoalition(_args[3], "FOB建造完成.", 10)
            end

            local _heli = _args[4]
            local _playerName = _heli:getPlayerName()
            if ctld.UnitLimitPlayerInfo[_playerName] == nil then
                ctld.UnitLimitPlayerInfo[_playerName] = {}
            end
            if ctld.UnitLimitPlayerInfo[_playerName]["FOB"] == nil then
                ctld.UnitLimitPlayerInfo[_playerName]["FOB"] = {}
            end
            local _aliveFOBs = 0
            ctld.logDebug("生成新FOB前，玩家FOB列表"..ctld.formatTable(ctld.UnitLimitPlayerInfo[_playerName]["FOB"]))
            for i = #ctld.UnitLimitPlayerInfo[_playerName]["FOB"], 1, -1 do
                local _fobName = ctld.UnitLimitPlayerInfo[_playerName]["FOB"][i]
                if _fobName then
                    _aliveFOBs = _aliveFOBs + 1
                else
                    table.remove(ctld.UnitLimitPlayerInfo[_playerName]["FOB"], i)
                end
            end
            ctld.logDebug("当前_aliveFOBs:".._aliveFOBs)
            if _aliveFOBs >= ctld.FOBLimit then
                local _toDeleteName = table.remove(ctld.UnitLimitPlayerInfo[_playerName]["FOB"], 1)
                local _toDeleteStatic = StaticObject.getByName(_toDeleteName)
                if _toDeleteStatic then _toDeleteStatic:destroy() end
                ctld.displayMessageToGroup(_heli, "你已经超过 FOB 限制，最早的 FOB 被销毁: " .. _toDeleteName, 10)
            end
            table.insert(ctld.UnitLimitPlayerInfo[_playerName]["FOB"], _name)


        end, { _centroid, _heli:getCountry(), _heli:getCoalition(), _heli }, timer.getTime() + ctld.buildTimeFOB)

        --local _txt = string.format("%s started building FOB using %d FOB crates, it will be finished in %d seconds.\nPosition marked with smoke.", ctld.getPlayerNameOrType(_heli), _totalCrates, ctld.buildTimeFOB)
        local _txt = string.format("%s 正在使用 %d 箱子搭建FOB, 将在 %d 秒内完成建造.\n烟雾标记中...", ctld.getPlayerNameOrType(_heli), _totalCrates, ctld.buildTimeFOB)

        ctld.crateAddPoint(_heli,ctld.cratesRequiredForFOB)
        ctld.processCallback({ unit = _heli, position = _centroid, action = "fob" })
        trigger.action.smoke({x=_centroid.x+60,y=_centroid.y,z=_centroid.z+60}, trigger.smokeColor.Green)
        trigger.action.outTextForCoalition(_heli:getCoalition(), _txt, 10)
    else
        --local _txt = string.format("Cannot build FOB!\n\nIt requires %d Large FOB crates ( 3 small FOB crates equal 1 large FOB Crate) and there are the equivalent of %d large FOB crates nearby\n\nOr the crates are not within 750m of each other", ctld.cratesRequiredForFOB, _totalCrates)
        local _txt = string.format("FOB建造失败！\n\n需要 %d 个FOB箱子，附近有 %d 个箱子\n\n或者是箱子距离过远", ctld.cratesRequiredForFOB, _totalCrates)
        ctld.displayMessageToGroup(_heli, _txt, 20)
    end
end

function ctld.unpackSHIPs(_crate,_crates, _heli)
    if ctld.isInShipYard(_heli) == false then
        ctld.displayMessageToGroup(_heli, "你根本就不在造船厂，你搁哪呢（船类单位需要运送箱子到造船厂去部署）" , 20)
        return
    end

    local _category = ctld.checkPlayerAndCoalitionLimit(_heli, nil, _crate.details.unit)
    if _category == nil then
        return
    end

    local _nearbyMultiCrates = {}
    local _cratesNum = 0

    for _, _nearbyCrate in pairs(_crates) do
        if _nearbyCrate.dist < 750 then
            if _nearbyCrate.details.unit == _crate.details.unit then
                _cratesNum = _cratesNum + 1
                table.insert(_nearbyMultiCrates, _nearbyCrate)
                if _crate.details.cratesRequired== _cratesNum then
                    break
                end
            end
        end
    end

    if _cratesNum >= _crate.details.cratesRequired then
        for _, _crate in pairs(_nearbyMultiCrates) do
            if _heli:getCoalition() == 1 then
                ctld.spawnedCratesRED[_crate.crateUnit:getName()] = nil
            else
                ctld.spawnedCratesBLUE[_crate.crateUnit:getName()] = nil
            end
            _crate.crateUnit:destroy()
        end

        ctld.spawnShip(_heli,_crate.details.unit)
        ctld.displayMessageToGroup(_heli, "成功用".._crate.details.cratesRequired.."个箱箱部署了".._crate.details.unit, 20)
        ctld.crateAddPoint(_heli,_crate.details.cratesRequired)

        return
    end

    ctld.displayMessageToGroup(_heli, "箱子数量不足，部署".._crate.details.unit.."需要".._crate.details.cratesRequired.."个箱箱", 20)
end

function ctld.isInShipYard(_heli)
    local _heliPoint = _heli:getPoint()
    for _, _name in pairs(ctld.shipYards) do
        local _shipYard = StaticObject.getByName(_name)
        if _shipYard ~= nil and _shipYard:getCoalition() == _heli:getCoalition() then
            local _dist = ctld.getDistance(_heliPoint, _shipYard:getPoint())
            if _dist <= 500 then
                return true
            end
        end
    end
    return false
end


function ctld.spawnShip(_heli,unitType)
    local _id = ctld.getNextGroupId()
    local _groupName = _heli:getPlayerName() .. " " .. unitType .. " #" .. _id

    local _group = {
        ["visible"] = false,
        ["hidden"] = false,
        ["uncontrollable"] = false,
        ["units"] = {},
        ["name"] = _groupName,
        ["task"] = {},
    }

    local _unitId = ctld.getNextUnitId()
    local _details = { type = unitType, unitId = _unitId, name = string.format("Unpacked %s #%i", unitType, _unitId) }
    _group.units[1] = ctld.createUnit(_heli:getPoint().x - 0.5, _heli:getPoint().z - 6000, 120, _details)

    _group.country = _heli:getCountry()
    _group.category = Group.Category.SHIP
    local _spawnedGroup = Group.getByName(mist.dynAdd(_group).name)
    local _dest = _spawnedGroup:getUnit(1):getPoint()
    _dest = { x = _dest.x + 0.5, _y = _dest.y + 0.5, z = _dest.z + 0.5 }
    ctld.orderGroupToMoveToPoint(_spawnedGroup:getUnit(1), _dest)
    ctld.addUnitInfoToCoalition(_heli,"造船厂(SHIP)集装箱",_groupName)
end


--unloads the sling crate when the helicopter is on the ground or between 4.5 - 10 meters
function ctld.dropSlingCrate(_args)
    local _heliName = _args[1]
    local needCheck = _args[2]
    local _heli = ctld.getTransportUnit(_heliName)
    if _heli == nil then
        return
    end

    -- 获取所有在运输的箱子
    local _currentCrates = ctld.inTransitSlingLoadCrates[_heliName] or {}

    -- 检查是否有箱子可投放
    if #_currentCrates == 0 then
        if ctld.hoverPickup then
            ctld.displayMessageToGroup(_heli, "你目前没有运输任何箱子. \n\n要捡起，请在箱子上悬停 " .. ctld.hoverTime .. " 秒", 10)
        else
            ctld.displayMessageToGroup(_heli, "你目前没有运输任何箱子. \n\n拾取箱子-着陆并使用F10集装箱命令装载一个板条箱。", 10)
        end
        return
    end

    -- 总是投放最新的箱子（最后装载的）
    local _currentCrate = _currentCrates[#_currentCrates]
    table.remove(_currentCrates, #_currentCrates)
    ctld.inTransitSlingLoadCrates[_heliName] = _currentCrates

    -- 更新重量和货物
    ctld.adaptWeightToCargo(_heliName)

    local _point = _heli:getPoint()
    local _unitId = ctld.getNextUnitId()
    local _side = _heli:getCoalition()
    local _name = string.format("%s #%i", _currentCrate.desc, _unitId)
    local _heightDiff = ctld.heightDiff(_heli)

    -- 投放逻辑
    if needCheck == true then
        if ctld.inAir(_heli) == false then
            ctld.displayMessageToGroup(_heli, _currentCrate.desc .. " 箱子已放下，在你12点方向", 10)
            _point = ctld.getPointAt12Oclock(_heli, 40)
        elseif _heightDiff > ctld.airDropHeight and _heightDiff <= 40.0 then
            ctld.displayMessageToGroup(_heli, _currentCrate.desc .. " 箱子已经放在你下面了", 10)
            _point = ctld.getPointAt12Oclock(_heli, 5)
        else
            ctld.displayMessageToGroup(_heli, "你太高了！箱子已被毁", 10)
            return
        end
    else
        _point = ctld.getPointAt12Oclock(_heli, 40)
    end

    -- 生成箱子
    ctld.spawnCrateStatic(_heli:getCountry(), _unitId, _point, _name, _currentCrate.desc, _side)
end

--spawns a radio beacon made up of two units,
-- one for VHF and one for UHF
-- The units are set to to NOT engage
function ctld.createRadioBeacon(_point, _coalition, _country, _name, _batteryTime, _isFOB)

    local _uhfGroup = ctld.spawnRadioBeaconUnit(_point, _country, "UHF")
    local _vhfGroup = ctld.spawnRadioBeaconUnit(_point, _country, "VHF")
    local _fmGroup = ctld.spawnRadioBeaconUnit(_point, _country, "FM")

    local _freq = ctld.generateADFFrequencies()

    --create timeout
    local _battery

    if _batteryTime == nil then
        _battery = timer.getTime() + (ctld.deployedBeaconBattery * 60)
    else
        _battery = timer.getTime() + (_batteryTime * 60)
    end

    local _lat, _lon = coord.LOtoLL(_point)

    local _latLngStr = mist.tostringLL(_lat, _lon, 3, ctld.location_DMS)

    --local _mgrsString = mist.tostringMGRS(coord.LLtoMGRS(coord.LOtoLL(_point)), 5)

    local _message = _name

    if _isFOB then
        --  _message = "FOB " .. _message
        _battery = -1 --never run out of power!
    end

    _message = _message .. " - " .. _latLngStr

    --  ctld.logInfo("GEN UHF: ".. _freq.uhf)
    --  ctld.logInfo("GEN VHF: ".. _freq.vhf)

    _message = string.format("%s - %.2f KHz", _message, _freq.vhf / 1000)

    _message = string.format("%s - %.2f MHz", _message, _freq.uhf / 1000000)

    _message = string.format("%s - %.2f MHz ", _message, _freq.fm / 1000000)

    local _beaconDetails = {
        vhf = _freq.vhf,
        vhfGroup = _vhfGroup:getName(),
        uhf = _freq.uhf,
        uhfGroup = _uhfGroup:getName(),
        fm = _freq.fm,
        fmGroup = _fmGroup:getName(),
        text = _message,
        battery = _battery,
        coalition = _coalition,
    }
    ctld.updateRadioBeacon(_beaconDetails)

    table.insert(ctld.deployedRadioBeacons, _beaconDetails)

    return _beaconDetails
end

function ctld.generateADFFrequencies()

    if #ctld.freeUHFFrequencies <= 3 then
        ctld.freeUHFFrequencies = ctld.usedUHFFrequencies
        ctld.usedUHFFrequencies = {}
    end

    --remove frequency at RANDOM
    local _uhf = table.remove(ctld.freeUHFFrequencies, math.random(#ctld.freeUHFFrequencies))
    table.insert(ctld.usedUHFFrequencies, _uhf)

    if #ctld.freeVHFFrequencies <= 3 then
        ctld.freeVHFFrequencies = ctld.usedVHFFrequencies
        ctld.usedVHFFrequencies = {}
    end

    local _vhf = table.remove(ctld.freeVHFFrequencies, math.random(#ctld.freeVHFFrequencies))
    table.insert(ctld.usedVHFFrequencies, _vhf)

    if #ctld.freeFMFrequencies <= 3 then
        ctld.freeFMFrequencies = ctld.usedFMFrequencies
        ctld.usedFMFrequencies = {}
    end

    local _fm = table.remove(ctld.freeFMFrequencies, math.random(#ctld.freeFMFrequencies))
    table.insert(ctld.usedFMFrequencies, _fm)

    return { uhf = _uhf, vhf = _vhf, fm = _fm }
    --- return {uhf=_uhf,vhf=_vhf}
end

function ctld.spawnRadioBeaconUnit(_point, _country, _type)

    local _groupId = ctld.getNextGroupId()

    local _unitId = ctld.getNextUnitId()

    local _radioGroup = {
        ["visible"] = false,
        -- ["groupId"] = _groupId,
        ["hidden"] = false,
        ["units"] = {
            [1] = {
                ["y"] = _point.z,
                ["type"] = "TACAN_beacon",
                ["name"] = _type .. " Radio Beacon Unit #" .. _unitId,
                --   ["unitId"] = _unitId,
                ["heading"] = 0,
                ["playerCanDrive"] = true,
                ["skill"] = "Excellent",
                ["x"] = _point.x,
            }
        },
        --        ["y"] = _positions[1].z,
        --        ["x"] = _positions[1].x,
        ["name"] = _type .. " Radio Beacon Group #" .. _groupId,
        ["task"] = {},
        --added two fields below for MIST
        ["category"] = Group.Category.GROUND,
        ["country"] = _country
    }

    -- return coalition.addGroup(_country, Group.Category.GROUND, _radioGroup)
    return Group.getByName(mist.dynAdd(_radioGroup).name)
end

function ctld.updateRadioBeacon(_beaconDetails)

    local _vhfGroup = Group.getByName(_beaconDetails.vhfGroup)

    local _uhfGroup = Group.getByName(_beaconDetails.uhfGroup)

    local _fmGroup = Group.getByName(_beaconDetails.fmGroup)

    local _radioLoop = {}

    if _vhfGroup ~= nil and _vhfGroup:getUnits() ~= nil and #_vhfGroup:getUnits() == 1 then
        table.insert(_radioLoop, { group = _vhfGroup, freq = _beaconDetails.vhf, silent = false, mode = 0 })
    end

    if _uhfGroup ~= nil and _uhfGroup:getUnits() ~= nil and #_uhfGroup:getUnits() == 1 then
        table.insert(_radioLoop, { group = _uhfGroup, freq = _beaconDetails.uhf, silent = true, mode = 0 })
    end

    if _fmGroup ~= nil and _fmGroup:getUnits() ~= nil and #_fmGroup:getUnits() == 1 then
        table.insert(_radioLoop, { group = _fmGroup, freq = _beaconDetails.fm, silent = false, mode = 1 })
    end

    local _batLife = _beaconDetails.battery - timer.getTime()

    if (_batLife <= 0 and _beaconDetails.battery ~= -1) or #_radioLoop ~= 3 then
        -- ran out of batteries

        if _vhfGroup ~= nil then
            _vhfGroup:destroy()
        end
        if _uhfGroup ~= nil then
            _uhfGroup:destroy()
        end
        if _fmGroup ~= nil then
            _fmGroup:destroy()
        end

        return false
    end

    --fobs have unlimited battery life
    --    if _battery ~= -1 then
    --        _text = _text.." "..mist.utils.round(_batLife).." seconds of battery"
    --    end

    for _, _radio in pairs(_radioLoop) do

        local _groupController = _radio.group:getController()

        local _sound = ctld.radioSound
        if _radio.silent then
            _sound = ctld.radioSoundFC3
        end

        _sound = "l10n/DEFAULT/" .. _sound

        _groupController:setOption(AI.Option.Ground.id.ROE, AI.Option.Ground.val.ROE.WEAPON_HOLD)

        trigger.action.radioTransmission(_sound, _radio.group:getUnit(1):getPoint(), _radio.mode, false, _radio.freq, 1000)
        --This function doesnt actually stop transmitting when then sound is false. My hope is it will stop if a new beacon is created on the same
        -- frequency... OR they fix the bug where it wont stop.
        --        end

        --
    end

    return true

    --  trigger.action.radioTransmission(ctld.radioSound, _point, 1, true, _frequency, 1000)
end

function ctld.listRadioBeacons(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _message = ""

    if _heli ~= nil then

        for _x, _details in pairs(ctld.deployedRadioBeacons) do

            if _details.coalition == _heli:getCoalition() then
                _message = _message .. _details.text .. "\n"
            end
        end

        if _message ~= "" then
            ctld.displayMessageToGroup(_heli, "Radio Beacons:\n" .. _message, 20)
        else
            ctld.displayMessageToGroup(_heli, "No Active Radio Beacons", 20)
        end
    end
end

function ctld.dropRadioBeacon(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _message = ""

    if _heli ~= nil and ctld.inAir(_heli) == false then

        --deploy 50 m infront
        --try to spawn at 12 oclock to us
        local _point = ctld.getPointAt12Oclock(_heli, 50)

        ctld.beaconCount = ctld.beaconCount + 1
        local _name = "Beacon #" .. ctld.beaconCount

        local _radioBeaconDetails = ctld.createRadioBeacon(_point, _heli:getCoalition(), _heli:getCountry(), _name, nil, false)

        -- mark with flare?

        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " deployed a Radio Beacon.\n\n" .. _radioBeaconDetails.text, 20)

    else
        ctld.displayMessageToGroup(_heli, "You need to land before you can deploy a Radio Beacon!", 20)
    end
end

--remove closet radio beacon
function ctld.removeRadioBeacon(_args)

    local _heli = ctld.getTransportUnit(_args[1])
    local _message = ""

    if _heli ~= nil and ctld.inAir(_heli) == false then

        -- mark with flare?

        local _closetBeacon = nil
        local _shortestDistance = -1
        local _distance = 0

        for _x, _details in pairs(ctld.deployedRadioBeacons) do

            if _details.coalition == _heli:getCoalition() then

                local _group = Group.getByName(_details.vhfGroup)

                if _group ~= nil and #_group:getUnits() == 1 then

                    _distance = ctld.getDistance(_heli:getPoint(), _group:getUnit(1):getPoint())
                    if _distance ~= nil and (_shortestDistance == -1 or _distance < _shortestDistance) then
                        _shortestDistance = _distance
                        _closetBeacon = _details
                    end
                end
            end
        end

        if _closetBeacon ~= nil and _shortestDistance then
            local _vhfGroup = Group.getByName(_closetBeacon.vhfGroup)

            local _uhfGroup = Group.getByName(_closetBeacon.uhfGroup)

            local _fmGroup = Group.getByName(_closetBeacon.fmGroup)

            if _vhfGroup ~= nil then
                _vhfGroup:destroy()
            end
            if _uhfGroup ~= nil then
                _uhfGroup:destroy()
            end
            if _fmGroup ~= nil then
                _fmGroup:destroy()
            end

            trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " removed a Radio Beacon.\n\n" .. _closetBeacon.text, 20)
        else
            ctld.displayMessageToGroup(_heli, "No Radio Beacons within 500m.", 20)
        end

    else
        ctld.displayMessageToGroup(_heli, "You need to land before remove a Radio Beacon", 20)
    end
end

-- gets the center of a bunch of points!
-- return proper DCS point with height
function ctld.getCentroid(_points)
    local _tx, _ty = 0, 0
    for _index, _point in ipairs(_points) do
        _tx = _tx + _point.x
        _ty = _ty + _point.z
    end

    local _npoints = #_points

    local _point = { x = _tx / _npoints, z = _ty / _npoints }

    _point.y = land.getHeight({x = _point.x, y = _point.z})

    return _point
end

function ctld.getGroupTemplate(_unitName)

    for _, _system in pairs(ctld.GroupSystemTemplate) do

        if _system.repair == _unitName then
            return _system
        end

        if _system.sysName == _unitName then
            return _system
        end

        --for _,_part in pairs(_system.parts) do
        --
        --    if _unitName == _part.name  then
        --        return _system
        --    end
        --end

    end
    return nil
end

function ctld.getLauncherUnitFromAATemplate(_aaTemplate)
    local launchers = {}
    for _, _part in pairs(_aaTemplate.parts) do
        if _part.launcher then
            table.insert(launchers, _part.name)
        end
    end
    return launchers
end

function ctld.rearmAASystem(_heli, _nearestCrate, _nearbyCrates, _aaSystemTemplate)

    -- are we adding to existing aa system?
    -- check to see if the crate is a launcher
    local _launcherParts = ctld.getLauncherUnitFromAATemplate(_aaSystemTemplate)

    if ctld.tableContains(_launcherParts, _nearestCrate.details.unit) then

        -- find nearest COMPLETE AA system
        local _nearestSystem = ctld.findNearestGroupSystem(_heli, _aaSystemTemplate)

        if _nearestSystem ~= nil and _nearestSystem.dist < 300 then

            local _uniqueTypes = {} -- stores each unique part of system
            local _types = {}
            local _points = {}

            local _units = _nearestSystem.group:getUnits()

            if _units ~= nil and #_units > 0 then

                for x = 1, #_units do
                    if _units[x]:getLife() > 0 then

                        --this allows us to count each type once
                        _uniqueTypes[_units[x]:getTypeName()] = _units[x]:getTypeName()

                        table.insert(_points, _units[x]:getPoint())
                        table.insert(_types, _units[x]:getTypeName())
                    end
                end
            end

            -- do we have the correct number of unique pieces and do we have enough points for all the pieces
            if ctld.countTableEntries(_uniqueTypes) == _aaSystemTemplate.count and #_points >= _aaSystemTemplate.count then

                -- rearm aa system
                -- destroy old group
                ctld.completeGroupSystems[_nearestSystem.group:getName()] = nil

                _nearestSystem.group:destroy()

                local _spawnedGroup = ctld.spawnCrateGroup(_heli, _points, _types)

                ctld.completeGroupSystems[_spawnedGroup:getName()] = ctld.getGroupSystemDetails(_spawnedGroup, _aaSystemTemplate)

                ctld.processCallback({ unit = _heli, crate = _nearestCrate, spawnedGroup = _spawnedGroup, action = "rearm" })

                trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " successfully rearmed a full " .. _aaSystemTemplate.name .. " in the field", 10)

                if _heli:getCoalition() == 1 then
                    ctld.spawnedCratesRED[_nearestCrate.crateUnit:getName()] = nil
                else
                    ctld.spawnedCratesBLUE[_nearestCrate.crateUnit:getName()] = nil
                end

                -- remove crate
                --     if ctld.slingLoad == false then
                _nearestCrate.crateUnit:destroy()
                --  end

                return true -- all done so quit
            end
        end
    end

    return false
end

function ctld.getGroupSystemDetails(_hawkGroup, _aaSystemTemplate)

    local _units = _hawkGroup:getUnits()

    local _hawkDetails = {}

    for _, _unit in pairs(_units) do
        table.insert(_hawkDetails, { point = _unit:getPoint(), unit = _unit:getTypeName(), name = _unit:getName(), system = _aaSystemTemplate })
    end

    return _hawkDetails
end

function ctld.countTableEntries(_table)
    if _table == nil then
        return 0
    end
    local _count = 0
    for _key, _value in pairs(_table) do
        _count = _count + 1
    end
    return _count
end

function ctld.rollRandomTank(_nearestCrate)
    if _nearestCrate.details.unit == "Tank RandomGroup" then
        return true, ctld.getGroupTemplate(ctld.RandomTankPool[math.random(#ctld.RandomTankPool)])
    end
    return false, nil
end

function ctld.tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

function ctld.unpackGroupSystem(_heli, _nearestCrate, _nearbyCrates, _groupSystemTemplate)
    -- are there all the pieces close enough together
    ctld.logDebug('进去之前    ' .. ctld.formatTable(_groupSystemTemplate))
    local ok, _template = ctld.rollRandomTank(_nearestCrate)
    ctld.logDebug('_template    ' .. ctld.formatTable(_template))
    if ok then
        _groupSystemTemplate = _template
    end
    ctld.logDebug('进去之后  ' .. ctld.formatTable(_groupSystemTemplate))

    local _systemParts = {}

    --initialise list of parts
    for _, _part in pairs(_groupSystemTemplate.parts) do
        _systemParts[_part.name] = { name = _part.name, desc = _part.desc }
    end

    -- find all nearest crates and add them to the list if they're part of the AA System
    --local _crateCnt = 0
    ctld.logDebug('_nearbyCrates' .. ctld.formatTable(_nearbyCrates))
    local toBeDestoyedCrates = {}
    for _, _nearbyCrate in pairs(_nearbyCrates) do
        if _nearbyCrate.dist < ctld.multiCrateMaxDistance then
            if string.find(_groupSystemTemplate.sysName, _nearbyCrate.details.unit) ~= nil or _groupSystemTemplate.sysName == _nearbyCrate.details.unit then
                --_crateCnt = _crateCnt + 1
                table.insert(toBeDestoyedCrates, _nearbyCrate)
            end
        end
    end

    --ctld.logDebug('_crateCnt' .. _crateCnt)
    ctld.logDebug('_groupSystemTemplate.cratesRequired:' .. _groupSystemTemplate.cratesRequired .. '目前找到的箱子:' .. #toBeDestoyedCrates)
    if #toBeDestoyedCrates < _groupSystemTemplate.cratesRequired then
        local _txtCnt = string.format("该阵地需要 %d 个集装箱，目前有 %d 个", _groupSystemTemplate.cratesRequired, #toBeDestoyedCrates)
        ctld.displayMessageToGroup(_heli, "无法部署" .. _groupSystemTemplate.name .. "!\n\n" .. _txtCnt .. "\n或者集装箱之间相距太远（超过" .. ctld.multiCrateMaxDistance .. "m）", 20)
        return
    end

    local _txt = ""
    local _point = _nearestCrate.crateUnit:getPoint()  -- 中心点
    local _xOffset, _yOffset = 0, 0
    local _posArray = {}
    local _typeArray = {}

    -- 分别计数发射器和非发射器
    local _launcherCount = 0
    local _nonLauncherCount = 0

    local _launcherParts = ctld.getLauncherUnitFromAATemplate(_groupSystemTemplate)
    -- 第一次遍历：统计数量
    for _name, _systemPart in pairs(_systemParts) do
        if ctld.tableContains(_launcherParts, _name) then
            _launcherCount = _launcherCount + _groupSystemTemplate.aaLaunchers
        else
            _nonLauncherCount = _nonLauncherCount + 1
        end
    end

    -- 第二次遍历：部署单位
    local _launcherIndex = 0  -- 发射器计数器
    local _nonLauncherIndex = 0  -- 非发射器计数器

    for _name, _systemPart in pairs(_systemParts) do
        if ctld.tableContains(_launcherParts, _name) then
            -- 发射器：半径35的圆环
            local _launchers = _groupSystemTemplate.aaLaunchers
            for _i = 1, _launchers do
                _launcherIndex = _launcherIndex + 1
                local _angle = math.pi * 2 * (_launcherIndex - 1) / _launcherCount
                _xOffset = math.cos(_angle) * 35
                _yOffset = math.sin(_angle) * 35
                local _newPoint = {
                    x = _point.x + _xOffset,
                    y = _point.y,
                    z = _point.z + _yOffset
                }
                table.insert(_posArray, _newPoint)
                table.insert(_typeArray, _name)
            end
        else
            -- 非发射器：半径12的圆环
            _nonLauncherIndex = _nonLauncherIndex + 1
            local _angle = math.pi * 2 * (_nonLauncherIndex - 1) / _nonLauncherCount
            _xOffset = math.cos(_angle) * 12
            _yOffset = math.sin(_angle) * 12
            local _newPoint = {
                x = _point.x + _xOffset,
                y = _point.y,
                z = _point.z + _yOffset
            }
            table.insert(_posArray, _newPoint)
            table.insert(_typeArray, _name)
        end
    end

    if _txt ~= "" then
        --ctld.displayMessageToGroup(_heli, "Cannot build " .. _groupSystemTemplate.name .. "\n" .. _txt .. "\n\nOr the crates are not close enough together", 20)
        ctld.displayMessageToGroup(_heli, "无法部署 " .. _groupSystemTemplate.name .. "\n" .. _txt .. "\n\n箱子间距过大", 20)
        return
    else


        local _spawnedGroup = ctld.spawnCrateGroup(_heli, _posArray, _typeArray, _groupSystemTemplate)
        if _spawnedGroup == nil then
            return
        end

        local count = 0
        for index = #toBeDestoyedCrates, 1, -1 do
            toBeDestoyedCrates[index].crateUnit:destroy()
            count = count + 1
            if count == _groupSystemTemplate.cratesRequired then
                break
            end
        end

        ctld.completeGroupSystems[_spawnedGroup:getName()] = ctld.getGroupSystemDetails(_spawnedGroup, _groupSystemTemplate)
        ctld.crateAddPoint(_heli,_groupSystemTemplate.cratesRequired)
        ctld.processCallback({ unit = _heli, crate = _nearestCrate, spawnedGroup = _spawnedGroup, action = "unpack" })

    end
end


--count the number of captured cities, sets the amount of allowed AA Systems
--红蓝和数字间的切换
--function ctld.getAllowedAASystems(_heli)
--
--    if _heli:getCoalition() == 1 then
--        return ctld.AASystemLimitBLUE
--    else
--        return ctld.AASystemLimitRED
--    end
--end

function ctld.countCompleteAASystems(_heli)

    local _count = 0

    for _groupName, _hawkDetails in pairs(ctld.completeGroupSystems) do

        local _hawkGroup = Group.getByName(_groupName)

        --  ctld.logInfo(_groupName..": "..mist.utils.tableShow(_hawkDetails))
        if _hawkGroup ~= nil and _hawkGroup:getCoalition() == _heli:getCoalition() then

            local _units = _hawkGroup:getUnits()

            if _units ~= nil and #_units > 0 then
                --get the system template
                local _aaSystemTemplate = _hawkDetails[1].system

                local _uniqueTypes = {} -- stores each unique part of system
                local _types = {}
                local _points = {}

                if _units ~= nil and #_units > 0 then

                    for x = 1, #_units do
                        if _units[x]:getLife() > 0 then

                            --this allows us to count each type once
                            _uniqueTypes[_units[x]:getTypeName()] = _units[x]:getTypeName()

                            table.insert(_points, _units[x]:getPoint())
                            table.insert(_types, _units[x]:getTypeName())
                        end
                    end
                end

                ---- do we have the correct number of unique pieces and do we have enough points for all the pieces
                --local _totalUnitsNumOfTemplate = ctld.countTableEntries(_aaSystemTemplate.parts) - 1 + _aaSystemTemplate.aaLaunchers --一个组的总数=parts单位数+aa数量-1
                --if _aaSystemTemplate.hasLimit and ctld.countTableEntries(_uniqueTypes) == _totalUnitsNumOfTemplate and #_points >= _totalUnitsNumOfTemplate then
                --    _count = _count + 1
                --end
            end
        end
    end

    return _count
end

function ctld.repairGroupSystem(_heli, _nearestCrate, _groupTemplate)
    ctld.logInfo('进入了repairGroupSystem,aa:' .. ctld.formatTable(_groupTemplate))
    -- find nearest COMPLETE AA system
    local _nearestGroup = ctld.findNearestGroupSystem(_heli, _groupTemplate)
    local lastRepairTime = ctld.lastRepairTimes[_nearestGroup.group:getName()]

    if lastRepairTime ~= nil and timer.getTime() - lastRepairTime < 1200 then
        ctld.displayMessageToGroup(_heli, "无法修复  " .. _groupTemplate.name .. ". 距离你上次维修" .. _groupTemplate.name .. " 没有超过20分钟！工兵太忙了！", 10)
    elseif _nearestGroup ~= nil and _nearestGroup.dist < 300 then

        local _oldGroup = ctld.completeGroupSystems[_nearestGroup.group:getName()]
        --remove old system
        ctld.completeGroupSystems[_nearestGroup.group:getName()] = nil
        _nearestGroup.group:destroy()

        --spawn new one
        local _types = {}
        local _points = {}

        for _, _part in pairs(_oldGroup) do
            table.insert(_points, _part.point)
            table.insert(_types, _part.unit)
        end
        ctld.logDebug('维修箱子 准备进入新生阶段')

        timer.scheduleFunction(function(_args)
            local _heli=_args[1]
            local _points=_args[2]
            local _types=_args[3]
            local _groupTemplate=_args[4]
            local _nearestCrate=_args[5]
            local _spawnedGroup = ctld.spawnCrateGroup(_heli, _points, _types,_groupTemplate)
            ctld.completeGroupSystems[_spawnedGroup:getName()] = ctld.getGroupSystemDetails(_spawnedGroup, _groupTemplate)
            ctld.processCallback({ unit = _heli, crate = _nearestCrate, spawnedGroup = _spawnedGroup, action = "repair" })
            --trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " successfully repaired a full " .. _groupTemplate.name .. " in the field", 10)
            trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " 成功修复了 " .. _groupTemplate.name .. " ", 10)
            if _heli:getCoalition() == 1 then
                ctld.spawnedCratesRED[_nearestCrate.crateUnit:getName()] = nil
            else
                ctld.spawnedCratesBLUE[_nearestCrate.crateUnit:getName()] = nil
            end
            _nearestCrate.crateUnit:destroy()
            ctld.lastRepairTimes[_spawnedGroup:getName()] = timer.getTime()
        end
        , {_heli,_points,_types,_groupTemplate,_nearestCrate } , timer.getTime() + 2)

    else
        --ctld.displayMessageToGroup(_heli, "Cannot repair  " .. _groupTemplate.name .. ". No damaged " .. _groupTemplate.name .. " within 300m", 10)
        ctld.displayMessageToGroup(_heli, "无法修复  " .. _groupTemplate.name .. ". 没有损坏的 " .. _groupTemplate.name .. " 在300m内", 10)
    end
end

function ctld.unpackMultiCrate(_heli, _nearestCrate, _nearbyCrates)
    ctld.logError('错误！箱子生成触发了unpackMultiCrate，箱子:' .. ctld.formatTable(_nearestCrate))
    -- unpack multi crate
    local _nearbyMultiCrates = {}

    for _, _nearbyCrate in pairs(_nearbyCrates) do

        if _nearbyCrate.dist < 300 then

            if _nearbyCrate.details.unit == _nearestCrate.details.unit then

                table.insert(_nearbyMultiCrates, _nearbyCrate)

                if #_nearbyMultiCrates == _nearestCrate.details.cratesRequired then
                    break
                end
            end
        end
    end

    --- check crate count
    if #_nearbyMultiCrates == _nearestCrate.details.cratesRequired then

        local _point = _nearestCrate.crateUnit:getPoint()

        -- destroy crates
        for _, _crate in pairs(_nearbyMultiCrates) do

            if _point == nil then
                _point = _crate.crateUnit:getPoint()
            end

            if _heli:getCoalition() == 1 then
                ctld.spawnedCratesRED[_crate.crateUnit:getName()] = nil
            else
                ctld.spawnedCratesBLUE[_crate.crateUnit:getName()] = nil
            end

            --destroy
            --   if ctld.slingLoad == false then
            _crate.crateUnit:destroy()
            --   end
        end

        local _spawnedGroup = ctld.spawnCrateGroup(_heli, { _point }, { _nearestCrate.details.unit })

        ctld.processCallback({ unit = _heli, crate = _nearestCrate, spawnedGroup = _spawnedGroup, action = "unpack" })

        --local _txt = string.format("%s successfully deployed %s to the field using %d crates", ctld.getPlayerNameOrType(_heli), _nearestCrate.details.desc, #_nearbyMultiCrates)
        local _txt = string.format("%s 成功部署 %s 到战区，使用 %d 箱子", ctld.getPlayerNameOrType(_heli), _nearestCrate.details.desc, #_nearbyMultiCrates)

        trigger.action.outTextForCoalition(_heli:getCoalition(), _txt, 10)

    else

        --local _txt = string.format("Cannot build %s!\n\nIt requires %d crates and there are %d \n\nOr the crates are not within 300m of each other", _nearestCrate.details.desc, _nearestCrate.details.cratesRequired, #_nearbyMultiCrates)
        local _txt = string.format("无法生成 %s!\n\n需要 %d 个箱子！现只有 %d \n\n或者箱子之间的距离不在300米以内", _nearestCrate.details.desc, _nearestCrate.details.cratesRequired, #_nearbyMultiCrates)

        ctld.displayMessageToGroup(_heli, _txt, 20)
    end
end

function ctld.spawnCrateGroup(_heli, _positions, _types, _groupSystemTemplate)
    local _id = ctld.getNextGroupId()
    local _groupName = _heli:getPlayerName() .. " " .. _types[1] .. " #" .. _id
    local _side = _heli:getCoalition()
    -- angle
    local anglePos = _heli:getPosition()
    local _angle = math.atan2(anglePos.x.z, anglePos.x.x)

    --TODO 限制参数添加到动态保存中
    ctld.logDebug('ctld.checkPlayerLimit(_heli,_groupSystemTemplate)    ' .. ctld.formatTable(_groupSystemTemplate))
    local _category = ctld.checkPlayerAndCoalitionLimit(_heli, _groupSystemTemplate, _types[1])
    if _category == nil then
        return nil
    end

    local _group = {
        --["PlayerName"] = tostring(initName),
        ["visible"] = false,
        -- ["groupId"] = _id,
        ["hidden"] = false,
        ["units"] = {},
        --        ["y"] = _positions[1].z,
        --        ["x"] = _positions[1].x,
        ["name"] = _groupName,
        ["task"] = {},
        ["playerCanDrive"] = true,
    }

    if #_positions == 1 then
        local _unitId = ctld.getNextUnitId()
        local _details = { type = _types[1], unitId = _unitId, name = string.format("Unpacked %s #%i", _types[1], _unitId) }
        _group.units[1] = ctld.createUnit(_positions[1].x + 5, _positions[1].z + 5, _angle, _details)
    else
        for _i, _pos in ipairs(_positions) do
            local _unitId = ctld.getNextUnitId()
            local _details = { type = _types[_i], unitId = _unitId, name = string.format("Unpacked %s #%i", _types[_i], _unitId) }
            _group.units[_i] = ctld.createUnit(_pos.x + 5, _pos.z + 5, _angle, _details)
        end
    end

    local _spawnedGroup
    if _types[1] == "RQ-1A Predator" then
        --之前问题出在mist上，改用dcs自己的生成方法 --TODO 把这里的判断抽象
        _group = ctld.groupToPlanes(_group, _positions[1].x + 1000, _positions[1].z + 1000)
        local _countryID
        if _side == 1 then
            _countryID = country.id.CJTF_RED
        else
            _countryID = country.id.CJTF_BLUE
        end
        coalition.addGroup(_countryID, Group.Category.AIRPLANE, _group)
        _spawnedGroup = Group.getByName(_groupName)
    else
        _group.country = _heli:getCountry()
        _group.category = Group.Category.GROUND
        _spawnedGroup = Group.getByName(mist.dynAdd(_group).name)
        local _dest = _spawnedGroup:getUnit(1):getPoint()

        local offset = 50
        local heading  = mist.getHeading(_heli)
        ctld.logInfo("Unpack heading is"..heading)
        local new_x = _dest.x + offset * math.cos(heading)
        local new_z = _dest.z + offset * math.sin(heading)

        _dest = { x = new_x, _y = _dest.y + 0.5, z = new_z }
        ctld.orderGroupToMoveToPoint(_spawnedGroup:getUnit(1), _dest)
    end

    ctld.logDebug('Limit的类别_category:'.._category)
    if _category == '阵营级大杀器' then
        ctld.addUnitInfoToCoalition(_heli, _category, _groupName)
    elseif ctld.needCheckPlayerLimit(_category) then
        ctld.addUnitInfoToPlayer(_heli, _category, _groupName)
    end

    return _spawnedGroup
end

function ctld.needCheckPlayerLimit(_category)
    for _categoryName, _ in pairs(ctld.UnitLimitPerPlayer) do
        if _categoryName == _category then
            return true
        end
    end

    return false
end

function ctld.addUnitInfoToCoalition(_heli, _category, _groupName)
    if _category == nil then
        return
    end

    if ctld.UnitLimitCoalitionInfo[_heli:getCoalition()] == nil then
        ctld.UnitLimitCoalitionInfo[_heli:getCoalition()] = {}
    end
    local side
    if _heli:getCoalition() == 1 then
        side = 'red'
    else
        side = 'blue'
    end
    table.insert(ctld.UnitLimitCoalitionInfo[_heli:getCoalition()], _groupName)
    local _leftNum = ctld.CoalitionKillerLimit - #ctld.UnitLimitCoalitionInfo[_heli:getCoalition()]
    local _message = string.format("%s成了%s, 阵营还可以生成%d组大杀器。超过的话不能再部署", side, _groupName, _leftNum)
    trigger.action.outTextForCoalition(_heli:getCoalition(), _message, 10)
    ctld.logInfo(_heli:getPlayerName() .. '新加了' .. _category .. '类别的' .. _groupName)
end

function ctld.addUnitInfoToPlayer(_heli, _category, _groupName)
    if _category == nil then
        return
    end

    if ctld.UnitLimitPlayerInfo[_heli:getPlayerName()] == nil then
        ctld.UnitLimitPlayerInfo[_heli:getPlayerName()] = {}
    end
    if ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category] == nil then
        ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category] = {}
    end

    table.insert(ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category], _groupName)
    local _leftNum = ctld.UnitLimitPerPlayer[_category] - #ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category]

    local _message = string.format("你生成了%s, 你还可以生成%d组 %s 类型的单位。超过的话会按顺序回收", _groupName, _leftNum, _category)
    ctld.displayMessageToGroup(_heli, _message, 10)
    ctld.logInfo(_message)
end

function ctld.checkPlayerAndCoalitionLimit(_heli, _groupSystemTemplate, unitName)
    local _category

    for _, category in ipairs(ctld.spawnableCrates) do
        for _, _crate in ipairs(category.items) do
            
            -- 保留原逻辑判断
            if _groupSystemTemplate ~= nil and _groupSystemTemplate.sysName == _crate.unit then
                _category = category.name  -- 使用category.name替代_categoryName
                break
            end
            
            if unitName ~= nil and unitName == _crate.unit then
                _category = category.name  -- 使用category.name替代_categoryName
                break
            end
        end
    end

    --坦克 ctld.RandomTankPool
    for _, _tankGroupName in pairs(ctld.RandomTankPool) do
        if _groupSystemTemplate ~= nil and _groupSystemTemplate.sysName == _tankGroupName then
            _category = "主战坦克(Tank)" --找到了对应的分类
        end
    end


    if _category == nil then
        ctld.displayMessageToGroup(_heli, '生成单位有问题，请找群管理汇报bug', 10)
        ctld.logError('严重错误，生成单位时找不到对应的类别！')
    elseif _category == "阵营级大杀器" or _category =="造船厂(SHIP)集装箱" then
        if ctld.handleCoalitionLimitInfo(_heli, _category) == nil then
            return nil
        else
            return _category
        end
    else
        ctld.handlePlayerLimitInfo(_heli, _category)
        return _category
    end

end
function ctld.ifGroupHasAliveUnits(_groupName)
    local _group = Group.getByName(_groupName)
    if _group ~= nil then
        local _units = _group:getUnits()
        if _units ~= nil and #_units > 0 then
            for x = 1, #_units do
                if _units[x]:getLife() > 1 then
                    return true
                end
            end
        end
    end
end

function ctld.handleCoalitionLimitInfo(_heli)
    local _sideInfo = ctld.UnitLimitCoalitionInfo[_heli:getCoalition()]
    if _sideInfo == nil then
        return true
    end
    local _aliveGroupNum = 0
    local side
    if _heli:getCoalition() == 1 then
        side = 'red'
    else
        side = 'blue'
    end
    for index = #_sideInfo, 1, -1 do
        local _groupName = _sideInfo[index]
        if ctld.ifGroupHasAliveUnits(_groupName) then
            _aliveGroupNum = _aliveGroupNum + 1
        else
            ctld.logInfo(side .. '的大杀器' .. _groupName .. '没血了，进行移除')
            table.remove(ctld.UnitLimitCoalitionInfo[_heli:getCoalition()], index)
        end
    end

    if _aliveGroupNum >= ctld.CoalitionKillerLimit then
        local _message = string.format("%s存活的大杀器数量已满%d辆，不允许再生成", side,ctld.CoalitionKillerLimit)
        trigger.action.outTextForCoalition(_heli:getCoalition(), _message, 10)
        ctld.logInfo(_message)
        return nil
    end
    return true
end

function ctld.handlePlayerLimitInfo(_heli, _category)
    local _playerInfo = ctld.UnitLimitPlayerInfo[_heli:getPlayerName()]
    if _playerInfo == nil or _playerInfo[_category] == nil then
        return
    end

    ctld.logDebug('开始计算已有的限制信息'..ctld.formatTable(ctld.UnitLimitPlayerInfo))

    local _aliveGroupNum = 0
    for index = #_playerInfo[_category], 1, -1 do
        local _groupName = _playerInfo[_category][index]
        if ctld.ifGroupHasAliveUnits(_groupName) then
            _aliveGroupNum = _aliveGroupNum + 1
        else
            ctld.logInfo(_heli:getPlayerName() .. '没血所以移除了' .. _category .. '类别的' .. ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category][index])
            table.remove(ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category], index)
        end
    end

    ctld.logDebug('存活组数：'.._aliveGroupNum)

    if _aliveGroupNum >= ctld.UnitLimitPerPlayer[_category] then
        local _toDeleteGroupName = table.remove(ctld.UnitLimitPlayerInfo[_heli:getPlayerName()][_category], 1)
        local _toDeleteGroup = Group.getByName(_toDeleteGroupName)
        --TODO 动态保存的时间到了吗
        _toDeleteGroup:destroy()
        local _message = string.format("你存活%d组 %s 单位，超过了限制数量%d组,自动为你销毁了最早的组:%s", _aliveGroupNum, _category, ctld.UnitLimitPerPlayer[_category], _toDeleteGroupName)
        ctld.displayMessageToGroup(_heli, _message, 10)
        ctld.logInfo(_heli:getPlayerName() .. '销毁了' .. _category .. '类别的' .. _toDeleteGroupName)
    end
end

function ctld.groupToPlanes(_group, _x, _y)
    _group.category = Group.Category.AIRPLANE
    _group.units[1].alt = 1000
    _group.units[1].speed = 82.222222222222
    _group.units[1].category = Unit.Category.AIRPLANE
    _group.units[1].task = "AFAC"
    _group.units[1].taskSelected = true

    _group.units[1].payload = {
        ["fuel"] = 1000,
        --["flare"] = 60,
        --["ammo_type"] = 5,
        --["chaff"] = 60,
        --["gun"] = 100,
    }
    _group.route = {
        ["points"] = {
            [1] = {
                ["alt"] = 1000,
                ["type"] = "Turning Point",
                ["action"] = "Turning Point",
                ["alt_type"] = "BARO",
                ["form"] = "Turning Point",
                ["speed"] = 82.222222222222,
                ["task"] = {
                    ["id"] = "ComboTask",
                    ["params"] = {
                        ["tasks"] = {
                            [1] = 
                            {
                                ["enabled"] = true,
                                ["auto"] = true,
                                ["id"] = "FAC",
                                ["number"] = 1,
                                ["params"] = 
                                {
                                    ["number"] = 1,
                                    ["designation"] = "Auto",
                                    ["modulation"] = 0,
                                    ["callname"] = 1,
                                    ["datalink"] = true,
                                    ["frequency"] = 133000000,
                                }, -- end of ["params"]
                            }, -- end of [1]
                            [2] = 
                            {
                                ["enabled"] = true,
                                ["auto"] = true,
                                ["id"] = "WrappedAction",
                                ["number"] = 2,
                                ["params"] = 
                                {
                                    ["action"] = 
                                    {
                                        ["id"] = "EPLRS",
                                        ["params"] = 
                                        {
                                        }, -- end of ["params"]
                                    }, -- end of ["action"]
                                }, -- end of ["params"]
                            }, -- end of [2]
                        }, -- end of ["tasks"]
                    }, -- end of ["params"]
                }, -- end of ["task"]
            }, -- end of [2]
        }, -- end of ["points"]
    }
    if _x then
        _group.route.points[1].x = _x + 1000
    end
    if _y then
        _group.route.points[1].y = _y + 1000
    end

    return _group
end


-- spawn normal group
function ctld.spawnDroppedGroup(_point, _details, _spawnBehind, _maxSearch)

    local _groupName = _details.groupName

    local _group = {
        ["visible"] = false,
        --  ["groupId"] = _details.groupId,
        ["hidden"] = false,
        ["units"] = {},
        --        ["y"] = _positions[1].z,
        --        ["x"] = _positions[1].x,
        ["name"] = _groupName,
        ["task"] = {},
    }

    if _spawnBehind == false then

        -- spawn in circle around heli

        local _pos = _point

        for _i, _detail in ipairs(_details.units) do

            local _angle = math.pi * 2 * (_i - 1) / #_details.units
            local _xOffset = math.cos(_angle) * 30
            local _yOffset = math.sin(_angle) * 30

            _group.units[_i] = ctld.createUnit(_pos.x + _xOffset, _pos.z + _yOffset, _angle, _detail)
        end

    else

        local _pos = _point

        --try to spawn at 6 oclock to us
        local _angle = math.atan2(_pos.z, _pos.x)
        local _xOffset = math.cos(_angle) * -30
        local _yOffset = math.sin(_angle) * -30

        for _i, _detail in ipairs(_details.units) do
            _group.units[_i] = ctld.createUnit(_pos.x + (_xOffset + 10 * _i), _pos.z + (_yOffset + 10 * _i), _angle, _detail)
        end
    end

    --switch to MIST
    _group.category = Group.Category.GROUND;
    _group.country = _details.country;

    local _spawnedGroup = Group.getByName(mist.dynAdd(_group).name)

    --local _spawnedGroup = coalition.addGroup(_details.country, Group.Category.GROUND, _group)


    -- find nearest enemy and head there
    if _maxSearch == nil then
        _maxSearch = ctld.maximumSearchDistance
    end

    --local _wpZone = ctld.inWaypointZone(_point, _spawnedGroup:getCoalition())
    --if _wpZone.inZone then
    --    ctld.orderGroupToMoveToPoint(_spawnedGroup:getUnit(1), _wpZone.point)
    --    ctld.logInfo("Heading to waypoint - In Zone " .. _wpZone.name)
    --else
    --    local _enemyPos = ctld.findNearestEnemy(_details.side, _point, _maxSearch)
    --    ctld.orderGroupToMoveToPoint(_spawnedGroup:getUnit(1), _enemyPos)
    --end

    return _spawnedGroup
end

function ctld.findNearestEnemy(_side, _point, _searchDistance)

    local _closestEnemy = nil

    local _groups

    local _closestEnemyDist = _searchDistance

    local _heliPoint = _point

    if _side == 2 then
        _groups = coalition.getGroups(1, Group.Category.GROUND)
    else
        _groups = coalition.getGroups(2, Group.Category.GROUND)
    end

    for _, _group in pairs(_groups) do

        if _group ~= nil then
            local _units = _group:getUnits()

            if _units ~= nil and #_units > 0 then

                local _leader = nil

                -- find alive leader
                for x = 1, #_units do
                    if _units[x]:getLife() > 0 then
                        _leader = _units[x]
                        break
                    end
                end

                if _leader ~= nil then
                    local _leaderPos = _leader:getPoint()
                    local _dist = ctld.getDistance(_heliPoint, _leaderPos)
                    if _dist < _closestEnemyDist then
                        _closestEnemyDist = _dist
                        _closestEnemy = _leaderPos
                    end
                end
            end
        end
    end


    -- no enemy - move to random point
    if _closestEnemy ~= nil then

        -- ctld.logInfo("found enemy")
        return _closestEnemy
    else

        local _x = _heliPoint.x + math.random(0, ctld.maximumMoveDistance) - math.random(0, ctld.maximumMoveDistance)
        local _z = _heliPoint.z + math.random(0, ctld.maximumMoveDistance) - math.random(0, ctld.maximumMoveDistance)
        local _y = _heliPoint.y + math.random(0, ctld.maximumMoveDistance) - math.random(0, ctld.maximumMoveDistance)

        return { x = _x, z = _z, y = _y }
    end
end

function ctld.findNearestGroup(_heli, _groups)

    local _closestGroupDetails = {}
    local _closestGroup = nil

    local _closestGroupDist = ctld.maxExtractDistance

    local _heliPoint = _heli:getPoint()

    for _, _groupName in pairs(_groups) do

        local _group = Group.getByName(_groupName)

        if _group ~= nil then
            local _units = _group:getUnits()

            if _units ~= nil and #_units > 0 then

                local _leader = nil

                local _groupDetails = { groupId = _group:getID(), groupName = _group:getName(), side = _group:getCoalition(), units = {} }

                -- find alive leader
                for x = 1, #_units do
                    if _units[x]:getLife() > 0 then

                        if _leader == nil then
                            _leader = _units[x]
                            -- set country based on leader
                            _groupDetails.country = _leader:getCountry()
                        end

                        local _unitDetails = { type = _units[x]:getTypeName(), unitId = _units[x]:getID(), name = _units[x]:getName() }

                        table.insert(_groupDetails.units, _unitDetails)
                    end
                end

                if _leader ~= nil then
                    local _leaderPos = _leader:getPoint()
                    local _dist = ctld.getDistance(_heliPoint, _leaderPos)
                    if _dist < _closestGroupDist then
                        _closestGroupDist = _dist
                        _closestGroupDetails = _groupDetails
                        _closestGroup = _group
                    end
                end
            end
        end
    end

    if _closestGroup ~= nil then

        return { group = _closestGroup, details = _closestGroupDetails }
    else

        return nil
    end
end

function ctld.createUnit(_x, _y, _angle, _details)

    local _newUnit = {
        ["y"] = _y,
        ["type"] = _details.type,
        ["name"] = _details.name,
        --  ["unitId"] = _details.unitId,
        ["heading"] = _angle,
        ["playerCanDrive"] = true,
        ["skill"] = "Excellent",
        ["x"] = _x,
    }

    return _newUnit
end

function ctld.addEWRTask(_group)

    -- delayed 2 second to work around bug
    timer.scheduleFunction(function(_ewrGroup)
        local _grp = ctld.getAliveGroup(_ewrGroup)

        if _grp ~= nil then
            local _controller = _grp:getController();
            local _EWR = {
                id = 'EWR',
                auto = true,
                params = {
                }
            }
            _controller:setTask(_EWR)
        end
    end
    , _group:getName(), timer.getTime() + 2)

end

function ctld.orderGroupToMoveToPoint(_leader, _destination)

    local _group = _leader:getGroup()

    local _path = {}
    table.insert(_path, mist.ground.buildWP(_leader:getPoint(), 'Off Road', 50))
    table.insert(_path, mist.ground.buildWP(_destination, 'Off Road', 50))

    local _mission = {
        id = 'Mission',
        params = {
            route = {
                points = _path
            },
        },
    }

    local _grp = ctld.getAliveGroup(_group:getName())
    if _grp ~= nil then
        local _controller = _grp:getController();
        timer.scheduleFunction(function(_arg)
            Controller.setOption(_controller, AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.GREEN)
            Controller.setOption(_controller, AI.Option.Ground.id.ROE, AI.Option.Ground.val.ROE.OPEN_FIRE)
            _controller:setTask(_mission)
        end, {}, timer.getTime() + 2) -- delayed 2 second to work around bug
        timer.scheduleFunction(function(_arg)
            Controller.setOption(_controller, AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.RED)
        end, {}, timer.getTime() + 30)
    end


end

-- are we in pickup zone
function ctld.inPickupZone(_heli)
    ctld.logDebug(string.format("ctld.inPickupZone(_heli=%s)", ctld.p(_heli)))

    if ctld.inAir(_heli) then
        return { inZone = false, limit = -1, index = -1 }
    end

    local _heliPoint = _heli:getPoint()

    for _i, _zoneDetails in pairs(ctld.pickupZones) do
        ctld.logTrace(string.format("_zoneDetails=%s", ctld.p(_zoneDetails)))

        local _triggerZone = trigger.misc.getZone(_zoneDetails[1])

        if _triggerZone == nil then
            local _ship = ctld.getTransportUnit(_zoneDetails[1])

            if _ship then
                local _point = _ship:getPoint()
                _triggerZone = {}
                _triggerZone.point = _point
                _triggerZone.radius = 200 -- should be big enough for ship
            end

        end

        if _triggerZone ~= nil then

            --get distance to center

            local _dist = ctld.getDistance(_heliPoint, _triggerZone.point)
            ctld.logTrace(string.format("_dist=%s", ctld.p(_dist)))
            if _dist <= _triggerZone.radius then
                local _heliCoalition = _heli:getCoalition()
                if _zoneDetails[4] == 1 and (_zoneDetails[5] == _heliCoalition or _zoneDetails[5] == 0) then
                    return { inZone = true, limit = _zoneDetails[3], index = _i }
                end
            end
        end
    end

    local _fobs = ctld.getSpawnedFobs(_heli)

    -- now check spawned fobs
    for _, _fob in ipairs(_fobs) do

        --get distance to center

        local _dist = ctld.getDistance(_heliPoint, _fob:getPoint())

        if _dist <= 150 then
            return { inZone = true, limit = 10000, index = -1 };
        end
    end

    return { inZone = false, limit = -1, index = -1 };
end

function ctld.getSpawnedFobs(_heli)

    local _fobs = {}

    for _, _fobName in ipairs(ctld.builtFOBS) do

        local _fob = StaticObject.getByName(_fobName)

        if _fob ~= nil and _fob:isExist() and _fob:getCoalition() == _heli:getCoalition() and _fob:getLife() > 0 then

            table.insert(_fobs, _fob)
        end
    end

    return _fobs
end

-- are we in a dropoff zone
function ctld.inDropoffZone(_heli)

    if ctld.inAir(_heli) then
        return false
    end

    local _heliPoint = _heli:getPoint()

    for _, _zoneDetails in pairs(ctld.dropOffZones) do

        local _triggerZone = trigger.misc.getZone(_zoneDetails[1])

        if _triggerZone ~= nil and (_zoneDetails[3] == _heli:getCoalition() or _zoneDetails[3] == 0) then

            --get distance to center

            local _dist = ctld.getDistance(_heliPoint, _triggerZone.point)

            if _dist <= _triggerZone.radius then
                return true
            end
        end
    end

    return false
end

-- are we in a waypoint zone
function ctld.inWaypointZone(_point, _coalition)

    for _, _zoneDetails in pairs(ctld.wpZones) do

        local _triggerZone = trigger.misc.getZone(_zoneDetails[1])

        --right coalition and active?
        if _triggerZone ~= nil and (_zoneDetails[4] == _coalition or _zoneDetails[4] == 0) and _zoneDetails[3] == 1 then

            --get distance to center

            local _dist = ctld.getDistance(_point, _triggerZone.point)

            if _dist <= _triggerZone.radius then
                return { inZone = true, point = _triggerZone.point, name = _zoneDetails[1] }
            end
        end
    end

    return { inZone = false }
end

-- are we near friendly logistics zone
function ctld.inLogisticsZone(_heli, needcheck)
    if needcheck == false then
        return false
    end
    if ctld.inAir(_heli) then
        return false
    end

    local _heliPoint = _heli:getPoint()
    ctld.logDebug("[inLogisticsZone] logisticUnits:" .. ctld.formatTable(ctld.logisticUnits))
    for i = #ctld.logisticUnits, 1, -1 do
        local _name = ctld.logisticUnits[i]
        local _logistic = StaticObject.getByName(_name)
        if _logistic == nil or not Object.isExist(_logistic) or _logistic:getLife() <= 1 then
            ctld.logDebug("CC不存在或已死亡！name: \"".._name.."\"")
            --table.remove(ctld.logisticUnits, i)  -- 移除就占领不回来了
        elseif _logistic:getCoalition() == _heli:getCoalition() then
            local _dist = ctld.getDistance(_heliPoint, _logistic:getPoint())
            if _dist <= ctld.maximumDistanceLogistic then
                return true
            end
        end
    end

    for i = #ctld.fobLocation, 1, -1 do
        local fob = ctld.fobLocation[i]
        local fobObj = fob.obj
    
        if fobObj == nil or not Object.isExist(fobObj) then
            ctld.logInfo("[farEnoughFromLogisticZone] FOB对象为空或已不存在！fob: \"" .. ctld.formatTable(fob) .. "\"") --! For StaticObject, always use nil and isExist to check
        else
            -- 安全调用 getLife
            local ok, life = pcall(function() return fobObj:getLife() end)
            if not ok then
                ctld.logInfo("[farEnoughFromLogisticZone] FOB对象调用 getLife() 失败，可能已经失效！fob: \"" .. ctld.formatTable(fob) .. "\"")
            elseif life <= 1 then
                ctld.logInfo("[farEnoughFromLogisticZone] FOB生命值 <= 1，视为已死亡！fob: \"" .. ctld.formatTable(fob) .. "\"")
            elseif fobObj:getCoalition() == _heli:getCoalition() then
                local _dist = ctld.getDistance(_heliPoint, fob.point)
                if _dist <= ctld.maximumDistanceLogistic then
                    return true
                end
            end
        end
    end

    return false
end


-- are far enough from a friendly logistics zone
function ctld.farEnoughFromLogisticZone(_heli, distance, needcheck)
    if needcheck == false then
        return true
    end
    if ctld.inAir(_heli) then
        return false
    end
    local _heliPoint = _heli:getPoint()
    local _farEnough = true

    for i = #ctld.logisticUnits, 1, -1 do
        local _name = ctld.logisticUnits[i]
        local _logistic = StaticObject.getByName(_name)
        if _logistic == nil or not Object.isExist(_logistic) or _logistic:getLife() <= 0 then
            -- table.remove(ctld.logisticUnits, i)  -- 移除就占领不回来了
        elseif _logistic:getCoalition() == _heli:getCoalition() then
            local _dist = ctld.getDistance(_heliPoint, _logistic:getPoint())
            if _dist <= distance then
                _farEnough = false
            end
        end
    end

    for i = #ctld.fobLocation, 1, -1 do
        local fob = ctld.fobLocation[i]
        local fobObj = fob.obj
    
        if fobObj == nil or not Object.isExist(fobObj) then
            ctld.logInfo("[farEnoughFromLogisticZone] FOB对象为空或已不存在！fob: \"" .. ctld.formatTable(fob) .. "\"")
        else
            -- 安全调用 getLife
            local ok, life = pcall(function() return fobObj:getLife() end)
            if not ok then
                ctld.logInfo("[farEnoughFromLogisticZone] FOB对象调用 getLife() 失败，可能已经失效！fob: \"" .. ctld.formatTable(fob) .. "\"")
            elseif life <= 1 then
                ctld.logInfo("[farEnoughFromLogisticZone] FOB生命值 <= 1，视为已死亡！fob: \"" .. ctld.formatTable(fob) .. "\"")
            else
                local _dist = ctld.getDistance(_heliPoint, fob.point)
                if _dist <= distance then
                    _farEnough = false
                end
            end
        end
    end
    
    return _farEnough
end

function ctld.refreshSmoke()

    if ctld.disableAllSmoke == true then
        return
    end

    for _, _zoneGroup in pairs({ ctld.pickupZones, ctld.dropOffZones }) do

        for _, _zoneDetails in pairs(_zoneGroup) do

            local _triggerZone = trigger.misc.getZone(_zoneDetails[1])

            if _triggerZone == nil then
                local _ship = ctld.getTransportUnit(_triggerZone)

                if _ship then
                    local _point = _ship:getPoint()
                    _triggerZone = {}
                    _triggerZone.point = _point
                end

            end


            --only trigger if smoke is on AND zone is active
            if _triggerZone ~= nil and _zoneDetails[2] >= 0 and _zoneDetails[4] == 1 then

                -- Trigger smoke markers

                local _pos2 = { x = _triggerZone.point.x, y = _triggerZone.point.z }
                local _alt = land.getHeight(_pos2)
                local _pos3 = { x = _pos2.x, y = _alt, z = _pos2.y }

                trigger.action.smoke(_pos3, _zoneDetails[2])
            end
        end
    end

    --waypoint zones
    for _, _zoneDetails in pairs(ctld.wpZones) do

        local _triggerZone = trigger.misc.getZone(_zoneDetails[1])

        --only trigger if smoke is on AND zone is active
        if _triggerZone ~= nil and _zoneDetails[2] >= 0 and _zoneDetails[3] == 1 then

            -- Trigger smoke markers

            local _pos2 = { x = _triggerZone.point.x, y = _triggerZone.point.z }
            local _alt = land.getHeight(_pos2)
            local _pos3 = { x = _pos2.x, y = _alt, z = _pos2.y }

            trigger.action.smoke(_pos3, _zoneDetails[2])
        end
    end


    --refresh in 5 minutes
    timer.scheduleFunction(ctld.refreshSmoke, nil, timer.getTime() + 300)
end

function ctld.dropSmoke(_args)

    local _heli = ctld.getTransportUnit(_args[1])

    if _heli ~= nil then

        local _colour = ""

        if _args[2] == trigger.smokeColor.Red then

            _colour = "RED"
        elseif _args[2] == trigger.smokeColor.Blue then

            _colour = "BLUE"
        elseif _args[2] == trigger.smokeColor.Green then

            _colour = "GREEN"
        elseif _args[2] == trigger.smokeColor.Orange then

            _colour = "ORANGE"
        end

        local _point = _heli:getPoint()

        local _pos2 = { x = _point.x, y = _point.z }
        local _alt = land.getHeight(_pos2)
        local _pos3 = { x = _point.x, y = _alt, z = _point.z }

        trigger.action.smoke(_pos3, _args[2])

        trigger.action.outTextForCoalition(_heli:getCoalition(), ctld.getPlayerNameOrType(_heli) .. " dropped " .. _colour .. " smoke ", 10)
    end
end

function ctld.unitCanCarryVehicles(_unit)

    local _type = string.lower(_unit:getTypeName())

    for _, _name in ipairs(ctld.vehicleTransportEnabled) do
        local _nameLower = string.lower(_name)
        if string.match(_type, _nameLower) then
            return true
        end
    end

    return false
end

function ctld.isJTACUnitType(_type)

    _type = string.lower(_type)
    --ctld.logTrace('_type_________:' .._type.."~~~")
    for _, _name in ipairs(ctld.jtacUnitTypes) do
        local _nameLower = string.lower(_name)
        --ctld.logTrace('_nameLower__________:' .._type.."~~~")
        --ctld.logTrace('answer________:' .._type == _nameLower.."~~~")
        --ctld.logTrace('answer2:' ..string.match(_type,_nameLower).."~~~")
        if _type == _nameLower then
            return true
        end
    end

    return false
end

function ctld.updateZoneCounter(_index, _diff)

    if ctld.pickupZones[_index] ~= nil then

        ctld.pickupZones[_index][3] = ctld.pickupZones[_index][3] + _diff

        if ctld.pickupZones[_index][3] < 0 then
            ctld.pickupZones[_index][3] = 0
        end

        if ctld.pickupZones[_index][6] ~= nil then
            trigger.action.setUserFlag(ctld.pickupZones[_index][6], ctld.pickupZones[_index][3])
        end
        --  ctld.logInfo(ctld.pickupZones[_index][1].." = " ..ctld.pickupZones[_index][3])
    end
end

function ctld.processCallback(_callbackArgs)

    for _, _callback in pairs(ctld.callbacks) do

        local _status, _result = pcall(function()

            _callback(_callbackArgs)

        end)

        if (not _status) then
            env.error(string.format("CTLD Callback Error: %s", _result))
        end
    end
end


-- checks the status of all AI troop carriers and auto loads and unloads troops
-- as long as the troops are on the ground
function ctld.checkAIStatus()

    timer.scheduleFunction(ctld.checkAIStatus, nil, timer.getTime() + 2)

    for _, _unitName in pairs(ctld.transportPilotNames) do
        local status, error = pcall(function()

            local _unit = ctld.getTransportUnit(_unitName)

            -- no player name means AI!
            if _unit ~= nil and _unit:getPlayerName() == nil then
                local _zone = ctld.inPickupZone(_unit)
                --  env.error("Checking.. ".._unit:getName())
                if _zone.inZone == true and not ctld.troopsOnboard(_unit, true) then
                    --   env.error("in zone, loading.. ".._unit:getName())

                    if ctld.allowRandomAiTeamPickups == true then
                        -- Random troop pickup implementation
                        local _team = nil
                        if _unit:getCoalition() == 1 then
                            _team = math.floor((math.random(#ctld.redTeams * 100) / 100) + 1)
                            ctld.loadTroopsFromZone({ _unitName, true, ctld.loadableGroups[ctld.redTeams[_team]], true })
                        else
                            _team = math.floor((math.random(#ctld.blueTeams * 100) / 100) + 1)
                            ctld.loadTroopsFromZone({ _unitName, true, ctld.loadableGroups[ctld.blueTeams[_team]], true })
                        end
                    else
                        ctld.loadTroopsFromZone({ _unitName, true, "", true })
                    end

                elseif ctld.inDropoffZone(_unit) and ctld.troopsOnboard(_unit, true) then
                    --     env.error("in dropoff zone, unloading.. ".._unit:getName())
                    ctld.unloadTroops({ _unitName, true })
                end

                if ctld.unitCanCarryVehicles(_unit) then

                    if _zone.inZone == true and not ctld.troopsOnboard(_unit, false) then

                        ctld.loadTroopsFromZone({ _unitName, false, "", true })

                    elseif ctld.inDropoffZone(_unit) and ctld.troopsOnboard(_unit, false) then

                        ctld.unloadTroops({ _unitName, false })
                    end
                end
            end
        end)

        if (not status) then
            env.error(string.format("Error with ai status: %s", error), false)
        end
    end


end

function ctld.getTransportLimit(_unitType)

    if ctld.unitLoadLimits[_unitType] then

        return ctld.unitLoadLimits[_unitType]
    end

    return ctld.numberOfTroops

end

function ctld.getUnitActions(_unitType)

    if ctld.unitActions[_unitType] then
        return ctld.unitActions[_unitType]
    end

    return { crates = true, troops = false }
end


-- Adds menuitem to all heli units that are active
function ctld.addF10MenuOptions()

    for _, _groupTable in pairs(mist.DBs.dynGroupsAdded) do
        local _groupID = _groupTable.groupId
        local _groupName = _groupTable.name
        local _, _groupCategory = pcall(function() 
            local result =  Group.getByName(_groupName):getCategory()
            --env.info(string.format("%s group has category: %s", tostring(_groupName), tostring(result)), false)
            return result
        end)
        if _groupCategory == 2 and ctld.captureCommandAdded[_groupName] == nil then
            missionCommands.addCommandForGroup(_groupID, "占领", nil, NP.capture, _groupTable)
            ctld.captureCommandAdded[_groupName] = true
        end
    end

    local status, error = pcall(function()

        -- now do any player controlled aircraft that ARENT transport units
        if ctld.enabledRadioBeaconDrop then
            -- get all BLUE players
            ctld.addRadioListCommand(2)

            -- get all RED players
            ctld.addRadioListCommand(1)
        end

        if ctld.JTAC_jtacStatusF10 then
            -- get all BLUE players
            ctld.addJTACRadioCommand(2)

            -- get all RED players
            ctld.addJTACRadioCommand(1)
        end

    end)

    if (not status) then
        env.error(string.format("Error adding f10 to other players: %s", error), false)
    end

    timer.scheduleFunction(ctld.addF10MenuOptions, nil, timer.getTime() + ctld.F10RefreshTime)
end

function ctld.addF10MenuOptionsDynamic(_unitName)
    local status, error = pcall(function()

        ctld.logTrace(string.format("_unitName=%s",_unitName))
        local _unit = ctld.getTransportUnit(_unitName)
        if _unit ~= nil then

            local _groupId = ctld.getGroupId(_unit)
            env.info("[CTLD] group id is " .. _groupId)

            if _groupId then
                ctld.inTransitSlingLoadCrates[_unitName] = {}  --先清除上一个架次装载的箱子

                if ctld.addedCSARTo[tostring(_groupId)] == nil then
                    local _rootPath = missionCommands.addSubMenuForGroup(_groupId, "CSAR飞行员救援")
                    missionCommands.addCommandForGroup(_groupId, "捞人", _rootPath,  npcsar.loadPilots, { _unitName })
                    missionCommands.addCommandForGroup(_groupId, "放人", _rootPath,  npcsar.unpackPilots, { _unitName })
                    missionCommands.addCommandForGroup(_groupId, "机舱信息", _rootPath,  npcsar.loadedPilotInfo, { _unitName })
                    ctld.addedCSARTo[tostring(_groupId)]=true
                end

                if ctld.addedTo[tostring(_groupId)] == nil then

                    local _rootPath = missionCommands.addSubMenuForGroup(_groupId, "运输+部署")
                    local _deployPath = _rootPath

                    local _unitActions = ctld.getUnitActions(_unit:getTypeName())
                    ctld.logTrace(string.format("_unitActions=%s", ctld.p(_unitActions)))

                    --TODO
                    if _unitActions.troops then
                        local _troopCommandsPath = missionCommands.addSubMenuForGroup(_groupId, "Troop Transport", _rootPath)
                        missionCommands.addCommandForGroup(_groupId, "Unload / Extract Troops", _troopCommandsPath, ctld.unloadExtractTroops, { _unitName })

                        -- local _loadPath = missionCommands.addSubMenuForGroup(_groupId, "Load From Zone", _troopCommandsPath)
                        local _transportLimit = ctld.getTransportLimit(_unit:getTypeName())
                        ctld.logTrace(string.format("_transportLimit=%s", ctld.p(_transportLimit)))
                        for _,_loadGroup in pairs(ctld.loadableGroups) do
                            ctld.logTrace(string.format("_loadGroup=%s", ctld.p(_loadGroup)))
                            if not _loadGroup.side or _loadGroup.side == _unit:getCoalition() then
                                -- check size & unit
                                if _transportLimit >= _loadGroup.total then
                                    missionCommands.addCommandForGroup(_groupId, "Load ".._loadGroup.name, _troopCommandsPath, ctld.loadTroopsFromZone, { _unitName, true,_loadGroup,false })
                                end
                            end
                        end
                    end

                    if ctld.enableCrates and _unitActions.crates then
                        _rootPath = missionCommands.addSubMenuForGroup(_groupId, "集装箱", _rootPath)
                        if not ctld.unitCanCarryVehicles(_unit) then
                            for _, category in ipairs(ctld.spawnableCrates) do  -- 用ipairs保证顺序
                                local _cratePath = missionCommands.addSubMenuForGroup(_groupId, category.name, _rootPath)
                                for _, _crate in ipairs(category.items) do
                                    if (not ctld.isJTACUnitType(_crate.unit) or ctld.JTAC_dropEnabled) 
                                        and (_crate.side == nil or _crate.side == _unit:getCoalition()) then
                                        
                                        local _crateRadioMsg = _crate.desc

                                        --add in the number of crates required to build something
                                        -- if _crate.cratesRequired ~= nil and _crate.cratesRequired > 1 then
                                        --     _crateRadioMsg = _crateRadioMsg .. " (" .. _crate.cratesRequired .. ")"
                                        -- end

                                        missionCommands.addCommandForGroup(_groupId, _crateRadioMsg, _cratePath, ctld.spawnCrate, { _unitName, _crate.desc })
                                    end
                                end
                            end
                        end
                    end

                    if (ctld.enabledFOBBuilding or ctld.enableCrates) and _unitActions.crates then

                        local _crateCommands = missionCommands.addSubMenuForGroup(_groupId, "集装箱指令",_deployPath)

                        missionCommands.addCommandForGroup(_groupId, "卸下 AND 部署", _crateCommands, ctld.dropAndUnpackCrates, { _unitName, false })
                        missionCommands.addCommandForGroup(_groupId, "部署", _crateCommands, ctld.unpackCrates, { _unitName, true })

                        if ctld.slingLoad == false then
                            missionCommands.addCommandForGroup(_groupId, "卸下货物", _crateCommands, ctld.dropSlingCrate, { _unitName, true })
                        end
                        missionCommands.addCommandForGroup(_groupId, "装载货物", _crateCommands, ctld.loadNearbyCrate, _unitName)
                        missionCommands.addCommandForGroup(_groupId, "检查货物", _crateCommands, ctld.checkTroopStatus, { _unitName })

                        missionCommands.addCommandForGroup(_groupId, "列出附近箱子", _crateCommands, ctld.listNearbyCrates, { _unitName })
                        if ctld.enabledFOBBuilding then
                            missionCommands.addCommandForGroup(_groupId, "列出FOB", _crateCommands, ctld.listFOBS, { _unitName })
                        end
                    end

                    if ctld.enableSmokeDrop then
                        local _smokeMenu = missionCommands.addSubMenuForGroup(_groupId, "Smoke Markers", _rootPath)
                        missionCommands.addCommandForGroup(_groupId, "Drop Red Smoke", _smokeMenu, ctld.dropSmoke, { _unitName, trigger.smokeColor.Red })
                        missionCommands.addCommandForGroup(_groupId, "Drop Blue Smoke", _smokeMenu, ctld.dropSmoke, { _unitName, trigger.smokeColor.Blue })
                        missionCommands.addCommandForGroup(_groupId, "Drop Orange Smoke", _smokeMenu, ctld.dropSmoke, { _unitName, trigger.smokeColor.Orange })
                        missionCommands.addCommandForGroup(_groupId, "Drop Green Smoke", _smokeMenu, ctld.dropSmoke, { _unitName, trigger.smokeColor.Green })
                    end

                    if ctld.enabledRadioBeaconDrop then
                        local _radioCommands = missionCommands.addSubMenuForGroup(_groupId, "Radio Beacons", _rootPath)
                        missionCommands.addCommandForGroup(_groupId, "List Beacons", _radioCommands, ctld.listRadioBeacons, { _unitName })
                        missionCommands.addCommandForGroup(_groupId, "Drop Beacon", _radioCommands, ctld.dropRadioBeacon, { _unitName })
                        missionCommands.addCommandForGroup(_groupId, "Remove Closet Beacon", _radioCommands, ctld.removeRadioBeacon, { _unitName })
                    elseif ctld.deployedRadioBeacons ~= {} then
                        local _radioCommands = missionCommands.addSubMenuForGroup(_groupId, "Radio Beacons", _rootPath)
                        missionCommands.addCommandForGroup(_groupId, "List Beacons", _radioCommands, ctld.listRadioBeacons, { _unitName })
                    end

                    ctld.addedTo[tostring(_groupId)] = true
                end
            end
        else
        end
    end)

    if (not status) then
        env.error(string.format("Error adding f10 to transport: %s", error), false)
    end
end


function ctld.addF10MenuOptionsBomber(_unitName)
    local status, error = pcall(function()

        ctld.logTrace(string.format("_unitName=%s",_unitName))
        local _unit = ctld.getTransportUnit(_unitName)
        if _unit ~= nil then

            local _groupId = ctld.getGroupId(_unit)
            env.info("[CTLD] group id is " .. _groupId)

            if _groupId then
                if ctld.addedBomberTo[tostring(_groupId)] == nil then
                    local _rootPath = missionCommands.addSubMenuForGroup(_groupId, "轰炸机行动")
                    missionCommands.addCommandForGroup(_groupId, "呼叫超音速轰炸机("..Bomber.CostTable["Attack"].."分)", _rootPath,  Bomber.CallAttack, { _unitName , "Attack"})
                    missionCommands.addCommandForGroup(_groupId, "呼叫低空轰炸机("..Bomber.CostTable["LowBomber"].."分)", _rootPath,  Bomber.CallAttack, { _unitName , "LowBomber"})
                    missionCommands.addCommandForGroup(_groupId, "呼叫隐身轰炸机("..Bomber.CostTable["StealthBomber"].."分)", _rootPath,  Bomber.CallAttack, { _unitName , "StealthBomber"})
                    missionCommands.addCommandForGroup(_groupId, "呼叫远程轰炸机("..Bomber.CostTable["Bomber"].."分)", _rootPath,  Bomber.CallAttack, { _unitName , "Bomber"})
                    missionCommands.addCommandForGroup(_groupId, "!!呼叫核弹机!!("..Bomber.CostTable["Nuke"].."分)", _rootPath,  Bomber.CallAttack, { _unitName , "Nuke"})
                    ctld.addedBomberTo[tostring(_groupId)]=true
                end
            end
        end
    end)
end

function ctld.addF10MenuOptionsSupport(_unitName)
    local status, error = pcall(function()

        ctld.logTrace(string.format("_unitName=%s",_unitName))
        local _unit = ctld.getTransportUnit(_unitName)
        if _unit ~= nil then

            local _groupId = ctld.getGroupId(_unit)
            env.info("[CTLD] group id is " .. _groupId)

            if _groupId then
                if ctld.addedSupportTo[tostring(_groupId)] == nil then
                    local _rootPath = missionCommands.addSubMenuForGroup(_groupId, "后勤支援")
                    missionCommands.addCommandForGroup(_groupId, "呼叫侦查无人机("..Support.CostTable["Attack"].."分)", _rootPath,  Support.CallAttack, { _unitName , "Attack"})
                    missionCommands.addCommandForGroup(_groupId, "呼叫低空运输机("..Support.CostTable["LowBomber"].."分)", _rootPath,  Support.CallAttack, { _unitName , "LowBomber"})
                    missionCommands.addCommandForGroup(_groupId, "呼叫高空运输机("..Support.CostTable["StealthBomber"].."分)", _rootPath,  Support.CallAttack, { _unitName , "StealthBomber"})
                    ctld.addedSupportTo[tostring(_groupId)]=true
                end
            end
        end
    end)
end

AdditionalEventHandler = {}
function AdditionalEventHandler:onEvent(event)
    if (event.id == 15 and event.initiator and event.initiator.getPlayerName and event.initiator:getPlayerName() ~= nil) then
        local success, group = pcall(function()
            return event.initiator:getGroup()
        end)
        if success and group then
            ctld.RefreshConfig()
            local unitName = group:getUnit(1):getName()
            local unitType = group:getUnit(1):getTypeName()
            local availableUnitTypes = {"MosquitoFBMkVI", "TF-51D", "CH-47Fbl1", "Mi-8MT", "Ka-50", "Ka-50_3",
                                        "AH-64D_BLK_II", "Mi-24P", "OH58D", "UH-1H", "SA342M", "SA342L", "SA342Mistral",
                                        "SA342Minigun",
                                        "C-130J-30"}
            --trigger.action.outTextForUnit(event.initiator:getID(), "机型：" .. unitType .. "出生", 20, true) -- 出生时显示机型
            timer.scheduleFunction(ctld.addF10MenuOptionsBomber, unitName, timer.getTime() + 1)
            for _, typename in ipairs(availableUnitTypes) do
                if unitType == typename then
                    --ctld.addF10MenuOptionsDynamic(unitName)
                    timer.scheduleFunction(ctld.addF10MenuOptionsDynamic, unitName, timer.getTime() + 1)
                    break -- Exit loop once found to save time
                end
            end
        end
    end
end



--add to all players that arent transport
function ctld.addRadioListCommand(_side)

    local _players = coalition.getPlayers(_side)

    if _players ~= nil then

        for _, _playerUnit in pairs(_players) do

            local _groupId = ctld.getGroupId(_playerUnit)

            if _groupId then

                if ctld.addedTo[tostring(_groupId)] == nil then
                    missionCommands.addCommandForGroup(_groupId, "List Radio Beacons", nil, ctld.listRadioBeacons, { _playerUnit:getName() })
                    ctld.addedTo[tostring(_groupId)] = true
                end
            end
        end
    end
end

function ctld.addJTACRadioCommand(_side)
    local _players = coalition.getPlayers(_side)

    if _players ~= nil then
        for _, _playerUnit in pairs(_players) do
            local _groupId = ctld.getGroupId(_playerUnit)

            if _groupId then
                local newGroup = false
                if ctld.jtacRadioAdded[tostring(_groupId)] == nil then
                    --ctld.logDebug("ctld.addJTACRadioCommand - adding JTAC radio menu for unit [%s]", ctld.p(_playerUnit:getName()))
                    newGroup = true 
                    local JTACpath = missionCommands.addSubMenuForGroup(_groupId, ctld.jtacMenuName)
                    missionCommands.addCommandForGroup(_groupId, "JTAC 信息", JTACpath,
                        ctld.getJTACStatus, { _playerUnit:getName() })
                    ctld.jtacRadioAdded[tostring(_groupId)] = true
                end

                --fetch the time to check for a regular refresh
                local time = timer.getTime()

                --depending on the delay, this part of the radio menu will be refreshed less often or as often as the static JTAC status command, this is for better reliability for the user when navigating through the menus. New groups will get the lists regardless and if a new JTAC is added all lists will be refreshed regardless of the delay.
                if ctld.jtacLastRadioRefresh + ctld.jtacRadioRefreshDelay <= time or ctld.refreshJTACmenu[_side] or newGroup then
                    ctld.jtacLastRadioRefresh = time

                    --build the path to the CTLD JTAC menu
                    local jtacCurrentPagePath = { [1] = ctld.jtacMenuName }
                    --build the path for the NextPage submenu on the first page of the CTLD JTAC menu
                    local NextPageText = "下一页"
                    local MainNextPagePath = { [1] = ctld.jtacMenuName, [2] = NextPageText }
                    --remove it along with everything that's in it
                    missionCommands.removeItemForGroup(_groupId, MainNextPagePath)

                    --counter to know when to add the next page submenu to fit all of the JTAC group submenus
                    local jtacCounter = 0

                    for _jtacGroupName, jtacUnit in pairs(ctld.jtacUnits) do
                        --ctld.logTrace(string.format("JTAC - MENU - [%s] - processing menu", ctld.p(_jtacGroupName)))

                        --if the JTAC is on the same team as the group being considered
                        local jtacCoalition = ctld.jtacUnits[_jtacGroupName].side
                        if jtacCoalition and jtacCoalition == _side then
                            --only bother removing the submenus on the first page of the CTLD JTAC menu as the other pages were deleted entirely above
                            if ctld.jtacGroupSubMenuPath[_jtacGroupName] and #ctld.jtacGroupSubMenuPath[_jtacGroupName] == 2 then
                                missionCommands.removeItemForGroup(_groupId, ctld.jtacGroupSubMenuPath[_jtacGroupName])
                            end
                            --ctld.logTrace(string.format("JTAC - MENU - [%s] - jtacTargetsList = %s", ctld.p(_jtacGroupName), ctld.p(ctld.jtacTargetsList[_jtacGroupName])))
                            --ctld.logTrace(string.format("JTAC - MENU - [%s] - jtacCurrentTargets = %s", ctld.p(_jtacGroupName), ctld.p(ctld.jtacCurrentTargets[_jtacGroupName])))

                            local jtacActionMenu = false
                            for _, _specialOptionTable in pairs(ctld.jtacSpecialOptions) do
                                if _specialOptionTable.globalToggle then
                                    jtacActionMenu = true
                                    break
                                end
                            end

                            --if JTAC has at least one other target in sight or (if special options are available (NOTE : accessed through the JTAC's own menu also) and the JTAC has at least one target)
                            if (ctld.jtacTargetsList[_jtacGroupName] and #ctld.jtacTargetsList[_jtacGroupName] >= 1) or (ctld.jtacCurrentTargets[_jtacGroupName] and jtacActionMenu) then
                                local jtacGroupSubMenuName = string.format(_jtacGroupName .. " 目标选择")

                                jtacCounter = jtacCounter + 1
                                --F2 through F10 makes 9 entries possible per page, with one being the NextMenu submenu. F1 is taken by JTAC status entry.
                                if jtacCounter % 9 == 0 then
                                    --recover the path to the current page with space available for JTAC group submenus
                                    jtacCurrentPagePath = missionCommands.addSubMenuForGroup(_groupId, NextPageText,
                                        jtacCurrentPagePath)
                                end
                                --add the JTAC group submenu to the current page
                                ctld.jtacGroupSubMenuPath[_jtacGroupName] = missionCommands.addSubMenuForGroup(_groupId,
                                    jtacGroupSubMenuName, jtacCurrentPagePath)
                                --ctld.logTrace(string.format("JTAC - MENU - [%s] - jtacGroupSubMenuPath = %s", ctld.p(_jtacGroupName), ctld.p(ctld.jtacGroupSubMenuPath[_jtacGroupName])))

                                --make a copy of the JTAC group submenu's path to insert the target's list on as many pages as required. The JTAC's group submenu path only leads to the first page
                                local jtacTargetPagePath = mist.utils.deepCopy(ctld.jtacGroupSubMenuPath[_jtacGroupName])

                                --counter to know when to add the next page submenu to fit all of the targets in the JTAC's group submenu. SMay not actually start at 0 due to static items being present on the first page
                                local itemCounter = 0
                                local jtacSpecialOptPagePath = nil

                                if jtacActionMenu then
                                    --special options
                                    local SpecialOptionsCounter = 0

                                    for _, _specialOption in pairs(ctld.jtacSpecialOptions) do
                                        if _specialOption.globalToggle then
                                            if not jtacSpecialOptPagePath then
                                                itemCounter = itemCounter +
                                                1                                                                             --one item is added to the first JTAC target page
                                                jtacSpecialOptPagePath = missionCommands.addSubMenuForGroup(_groupId,"操作", jtacTargetPagePath)
                                            end

                                            SpecialOptionsCounter = SpecialOptionsCounter + 1

                                            if SpecialOptionsCounter % 10 == 0 then
                                                jtacSpecialOptPagePath = missionCommands.addSubMenuForGroup(_groupId,
                                                    NextPageText, jtacSpecialOptPagePath)
                                                SpecialOptionsCounter = SpecialOptionsCounter + 1                                               --Added Next Page item
                                            end

                                            if _specialOption.jtacs then
                                                if _specialOption.jtacs[_jtacGroupName] then
                                                    missionCommands.addCommandForGroup(_groupId,
                                                        "关闭 " .. _specialOption.message,
                                                        jtacSpecialOptPagePath, _specialOption.setter,
                                                        { jtacGroupName = _jtacGroupName, value = false })
                                                else
                                                    missionCommands.addCommandForGroup(_groupId,
                                                        "开启 " .. _specialOption.message,
                                                        jtacSpecialOptPagePath, _specialOption.setter,
                                                        { jtacGroupName = _jtacGroupName, value = true })
                                                end
                                            else
                                                missionCommands.addCommandForGroup(_groupId,
                                                    "请求 " .. _specialOption.message,
                                                    jtacSpecialOptPagePath, _specialOption.setter,
                                                    { jtacGroupName = _jtacGroupName, value = false })                                                                                                                                                                                                  --value is not used here
                                            end
                                        end
                                    end
                                end

                                if #ctld.jtacTargetsList[_jtacGroupName] >= 1 then
                                    --ctld.logTrace(string.format("JTAC - MENU - [%s] - adding targets menu", ctld.p(_jtacGroupName)))

                                    --add a reset targeting option to revert to automatic JTAC unit targeting
                                    missionCommands.addCommandForGroup(_groupId,
                                        "重置目标选择", jtacTargetPagePath,
                                        ctld.setJTACTarget, { jtacGroupName = _jtacGroupName, targetName = nil })

                                    itemCounter = itemCounter + 1                                     --one item is added to the first JTAC target page

                                    --indicator table to know which unitType was already added to the radio submenu
                                    local typeNameList = {}
                                    for _, target in pairs(ctld.jtacTargetsList[_jtacGroupName]) do
                                        local targetName = target.unit:getName()
                                        --check if the jtac has a current target before filtering it out if possible
                                        if (ctld.jtacCurrentTargets[_jtacGroupName] and targetName ~= ctld.jtacCurrentTargets[_jtacGroupName].name) then
                                            local targetType_name = target.unit:getTypeName()

                                            if targetType_name then
                                                if typeNameList[targetType_name] then
                                                    typeNameList[targetType_name].amount = typeNameList[targetType_name]
                                                    .amount + 1
                                                else
                                                    typeNameList[targetType_name] = {}
                                                    typeNameList[targetType_name].targetName =
                                                    targetName                                                                                                --store the first targetName
                                                    typeNameList[targetType_name].amount = 1
                                                end
                                            end
                                        end
                                    end

                                    for typeName, info in pairs(typeNameList) do
                                        local amount = info.amount
                                        local targetName = info.targetName
                                        itemCounter = itemCounter + 1

                                        --F1 through F10 makes 10 entries possible per page, with one being the NextMenu submenu.
                                        if itemCounter % 10 == 0 then
                                            jtacTargetPagePath = missionCommands.addSubMenuForGroup(_groupId,
                                                NextPageText, jtacTargetPagePath)
                                            itemCounter = itemCounter + 1                                             --added the next page item
                                        end

                                        missionCommands.addCommandForGroup(_groupId,
                                            string.format(typeName .. "(" .. amount .. ")"), jtacTargetPagePath,
                                            ctld.setJTACTarget, { jtacGroupName = _jtacGroupName, targetName = targetName })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if ctld.refreshJTACmenu[_side] then
            ctld.refreshJTACmenu[_side] = false
        end
    end
end

function ctld.getGroupId(_unit)

    --local _unitDB = mist.DBs.unitsById[tonumber(_unit:getID())]
    --if _unitDB ~= nil and _unitDB.groupId then
    --    return _unitDB.groupId
    --end

    if _unit then
        local groupSuccess, group = pcall(function() return _unit:getGroup() end)
        
        if groupSuccess and group then
            -- 安全地获取组的ID
            local idSuccess, id = pcall(function() return group:getID() end)
            
            if idSuccess then
                return id
            else
                -- 记录获取组ID失败的错误
                ctld.logTrace("[getGroupId] failed to get group ID")
            end
        else
            ctld.logTrace("[getGroupId] failed to get group")
        end
    end

    return nil
end

--get distance in meters assuming a Flat world
function ctld.getDistance(_point1, _point2)

    local xUnit = _point1.x
    local yUnit = _point1.z
    local xZone = _point2.x
    local yZone = _point2.z

    local xDiff = xUnit - xZone
    local yDiff = yUnit - yZone

    return math.sqrt(xDiff * xDiff + yDiff * yDiff)
end


------------ JTAC -----------


ctld.jtacMenuName = "JTAC 操作" --name of the CTLD JTAC radio menu
ctld.jtacLaserPoints = {}
ctld.jtacIRPoints = {}
ctld.jtacSmokeMarks = {}
ctld.jtacUnits = {}          -- list of JTAC units for f10 command
ctld.jtacStop = {}           -- jtacs to tell to stop lasing
ctld.jtacCurrentTargets = {}
ctld.jtacTargetsList = {}    --current available targets to each JTAC for lasing (targets from other JTACs are filtered out). Contains DCS unit objects with their methods and the distance to the JTAC {unit, dist}
ctld.jtacSelectedTarget = {} --currently user selected target if it contains a unit's name, otherwise contains 1 or nil (if not initialized)
ctld.jtacSpecialOptions = {  --list which contains the status of special options for each jtac, ordered for them to show up in the correct order in the corresponding radio menu
    standbyMode = {          --#1
        globalToggle = ctld.JTAC_allowStandbyMode,
        message = "Standby Mode",
        setter = nil,         --ctld.setStdbMode, will be set after declaration of said function
        jtacs = {
            --enable flag for each JTAC
        },
    },                  --disable designation by the JTAC
    smokeMarker = {     --#4
        globalToggle = ctld.JTAC_allowSmokeRequest,
        message = "Smoke on TGT",
        setter = nil,           --ctld.setSmokeOnTarget
    },                          --smoke marker on target
    laseSpotCorrections = {     --#2
        globalToggle = ctld.JTAC_laseSpotCorrections,
        message = "Speed Corrections",
        setter = nil,         --ctld.setLaseCompensation
        jtacs = {
            --enable flag for each JTAC
        },
    },             --target speed and wind compensation for laser spot
    _9Line = {     --#3
        globalToggle = ctld.JTAC_allow9Line,
        message = "9 Line",
        setter = nil,             --ctld.setJTAC9Line
    },                            --9Line message for JTAC
}
ctld.jtacRadioAdded = {}          --keeps track of who's had the radio command added
ctld.jtacGroupSubMenuPath = {}    --keeps track of which submenu contains each JTAC's target selection menu
ctld.jtacRadioRefreshDelay = 120  --determines how often in seconds the dynamic parts of the jtac radio menu (target lists) will be refreshed
ctld.jtacLastRadioRefresh = 0     -- time at which the target lists were refreshed for everyone at least
ctld.refreshJTACmenu = {}         --indicator to know when a new JTAC is added to a coalition in order to rebuild the corresponding target lists
ctld.jtacGeneratedLaserCodes = {} -- keeps track of generated codes, cycles when they run out
ctld.jtacLaserPointCodes = {}
ctld.jtacRadioData = {}

--[[
        Called when a new JTAC is spawned, it will wait one second for DCS to have time to fill the group with units, and then call ctld.JTACAutoLase.

        The goal here is to correct a bug: when a group is respawned (i.e. when any group with the name of a previously existing group is spawned),
        DCS spawns a group which exists (Group.getByName gets a valid table, and group:isExist returns true), but has no units (i.e. group:getUnits returns an empty table).
        This causes JTACAutoLase to call cleanupJTAC because it does not find the JTAC unit, and the JTAC to be put out of the JTACAutoLase loop, and never processed again.
        By waiting a bit, the group gets populated before JTACAutoLase is called, hence avoiding a trip to cleanupJTAC.
]]
function ctld.JTACStart(_jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio)
    mist.scheduleFunction(ctld.JTACAutoLase, { _jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio },
        timer.getTime() + 1)
end

function ctld.JTACAutoLase(_jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio)
    --ctld.logDebug(string.format("ctld.JTACAutoLase(_jtacGroupName=%s, _laserCode=%s", ctld.p(_jtacGroupName), ctld.p(_laserCode)))
    local _radio = _radio
    if not _radio then
        _radio = {}
        if _laserCode then
            local _laserCode = tonumber(_laserCode)
            if _laserCode and _laserCode >= 1111 and _laserCode <= 1688 then
                local _laserB = math.floor((_laserCode - 1000) / 100)
                local _laserCD = _laserCode - 1000 - _laserB * 100
                local _frequency = tostring(30 + _laserB + _laserCD * 0.05)
                --ctld.logTrace(string.format("_laserB=%s", ctld.p(_laserB)))
                --ctld.logTrace(string.format("_laserCD=%s", ctld.p(_laserCD)))
                --ctld.logTrace(string.format("_frequency=%s", ctld.p(_frequency)))
                _radio.freq = _frequency
                _radio.mod = "fm"
            end
        end
    end

    if _radio and not _radio.name then
        _radio.name = _jtacGroupName
    end

    if ctld.jtacStop[_jtacGroupName] == true then
        ctld.jtacStop[_jtacGroupName] = nil         -- allow it to be started again
        ctld.cleanupJTAC(_jtacGroupName)
        return
    end

    if _lock == nil then
        _lock = ctld.JTAC_lock
    end

    ctld.jtacLaserPointCodes[_jtacGroupName] = _laserCode
    ctld.jtacRadioData[_jtacGroupName] = _radio

    local _jtacGroup = ctld.getGroup(_jtacGroupName)
    local _jtacUnit

    if _jtacGroup == nil or #_jtacGroup == 0 then
        --check not in a heli
        if ctld.inTransitTroops then
            for _, _onboard in pairs(ctld.inTransitTroops) do
                if _onboard ~= nil then
                    if _onboard.troops ~= nil and _onboard.troops.groupName ~= nil and _onboard.troops.groupName == _jtacGroupName then
                        --jtac soldier being transported by heli
                        ctld.cleanupJTAC(_jtacGroupName)

                        ctld.logTrace(string.format(
                        "JTAC - LASE - [%s] - in transport, waiting - scheduling JTACAutoLase in %ss at %s",
                            ctld.p(_jtacGroupName), ctld.p(10), ctld.p(timer.getTime() + 10)))
                        timer.scheduleFunction(ctld.timerJTACAutoLase,
                            { _jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio }, timer.getTime() + 10)
                        return
                    end

                    if _onboard.vehicles ~= nil and _onboard.vehicles.groupName ~= nil and _onboard.vehicles.groupName == _jtacGroupName then
                        --jtac vehicle being transported by heli
                        ctld.cleanupJTAC(_jtacGroupName)

                        ctld.logTrace(string.format(
                        "JTAC - LASE - [%s] - in transport, waiting - scheduling JTACAutoLase in %ss at %s",
                            ctld.p(_jtacGroupName), ctld.p(10), ctld.p(timer.getTime() + 10)))
                        timer.scheduleFunction(ctld.timerJTACAutoLase,
                            { _jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio }, timer.getTime() + 10)
                        return
                    end
                end
            end
        end

        if ctld.jtacUnits[_jtacGroupName] ~= nil then
            ctld.notifyCoalition("JTAC群组 %1 阵亡!", _jtacGroupName, 10,
                ctld.jtacUnits[_jtacGroupName].side, _radio)
        end

        --remove from list
        ctld.cleanupJTAC(_jtacGroupName)

        return
    else
        _jtacUnit = _jtacGroup[1]
        local _jtacCoalition = _jtacUnit:getCoalition()
        --add to list
        ctld.jtacUnits[_jtacGroupName] = { name = _jtacUnit:getName(), side = _jtacCoalition, radio = _radio }

        --Targets list, special options and Selected target initialization
        if not ctld.jtacTargetsList[_jtacGroupName] then
            --Target list
            ctld.jtacTargetsList[_jtacGroupName] = {}
            if _jtacCoalition then ctld.refreshJTACmenu[_jtacCoalition] = true end

            --Special Options
            for _, _specialOption in pairs(ctld.jtacSpecialOptions) do
                if _specialOption.jtacs then
                    _specialOption.jtacs[_jtacGroupName] = false
                end
            end
        end

        if not ctld.jtacSelectedTarget[_jtacGroupName] then
            ctld.jtacSelectedTarget[_jtacGroupName] = 1
        end

        -- work out smoke colour
        if _colour == nil then
            if _jtacUnit:getCoalition() == 1 then
                _colour = ctld.JTAC_smokeColour_RED
            else
                _colour = ctld.JTAC_smokeColour_BLUE
            end
        end


        if _smoke == nil then
            if _jtacUnit:getCoalition() == 1 then
                _smoke = ctld.JTAC_smokeOn_RED
            else
                _smoke = ctld.JTAC_smokeOn_BLUE
            end
        end
    end


    -- search for current unit

    if _jtacUnit:isActive() == false then
        ctld.cleanupJTAC(_jtacGroupName)

        ctld.logTrace(string.format("JTAC - LASE - [%s] - not active, scheduling JTACAutoLase in 30s at %s",
            ctld.p(_jtacGroupName), ctld.p(timer.getTime() + 30)))
        timer.scheduleFunction(ctld.timerJTACAutoLase, { _jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio },
            timer.getTime() + 30)

        return
    end

    local _enemyUnit = ctld.getCurrentUnit(_jtacUnit, _jtacGroupName)
    --update targets list and store the next potential target if the selected one was lost
    local _defaultEnemyUnit = ctld.findNearestVisibleEnemy(_jtacUnit, _lock)

    -- if the JTAC sees a unit and a target was selected by users but is not the current unit, check if the selected target is in the targets list, if it is, then it's been reacquired
    if _enemyUnit and ctld.jtacSelectedTarget[_jtacGroupName] ~= 1 and ctld.jtacSelectedTarget[_jtacGroupName] ~= _enemyUnit:getName() then
        for _, target in pairs(ctld.jtacTargetsList[_jtacGroupName]) do
            if target then
                local targetUnit = target.unit
                local targetName = targetUnit:getName()

                if ctld.jtacSelectedTarget[_jtacGroupName] == targetName then
                    ctld.jtacCurrentTargets[_jtacGroupName] = { name = targetName, unitType = targetUnit:getTypeName(), unitId =
                    targetUnit:getID() }
                    _enemyUnit = targetUnit

                    local message = ctld.i18n_translate("%1, 选择的目标重新出现, %2", _jtacGroupName,
                        _enemyUnit:getTypeName())
                    local fullMessage = message ..
                    ctld.i18n_translate(". 激光编码: %1. 坐标: %2", _laserCode, ctld.getPositionString(_enemyUnit))
                    ctld.notifyCoalition(fullMessage, 10, _jtacUnit:getCoalition(), _radio, message)
                end
            end
        end
    end

    local targetDestroyed = false
    local targetLost = false
    local wasSelected = false

    if _enemyUnit == nil and ctld.jtacCurrentTargets[_jtacGroupName] ~= nil then
        local _tempUnitInfo = ctld.jtacCurrentTargets[_jtacGroupName]

        --            env.info("TEMP UNIT INFO: " .. tempUnitInfo.name .. " " .. tempUnitInfo.unitType)

        local _tempUnit = Unit.getByName(_tempUnitInfo.name)

        wasSelected = (ctld.jtacCurrentTargets[_jtacGroupName].name == ctld.jtacSelectedTarget[_jtacGroupName])

        if _tempUnit ~= nil and _tempUnit:getLife() > 0 and _tempUnit:isActive() == true then
            targetLost = true
            local markInfo = ctld.jtacMarkIDs[_tempUnit:getName()]
            if markInfo and markInfo.jtac == _jtacGroupName then
                pcall(function()
                    trigger.action.removeMark(markInfo.id)
                end)
                ctld.jtacMarkIDs[_tempUnit:getName()] = nil
            end
        else
            targetDestroyed = true
            ctld.jtacSelectedTarget[_jtacGroupName] = 1
            local markInfo = ctld.jtacMarkIDs[_tempUnit:getName()]
            if markInfo and markInfo.jtac == _jtacGroupName then
                pcall(function()
                    trigger.action.removeMark(markInfo.id)
                end)
                ctld.jtacMarkIDs[_tempUnit:getName()] = nil
            end
        end

        --remove from smoke list
        ctld.jtacSmokeMarks[_tempUnitInfo.name] = nil

        -- JTAC Unit: resume his route ------------
        trigger.action.groupContinueMoving(Group.getByName(_jtacGroupName))

        -- remove from target list
        ctld.jtacCurrentTargets[_jtacGroupName] = nil

        --stop lasing
        ctld.cancelLase(_jtacGroupName)
    end


    if _enemyUnit == nil then
        if _defaultEnemyUnit ~= nil then
            -- store current target for easy lookup
            ctld.jtacCurrentTargets[_jtacGroupName] = { name = _defaultEnemyUnit:getName(), unitType = _defaultEnemyUnit
            :getTypeName(), unitId = _defaultEnemyUnit:getID() }

            --add check for lasing or not
            local action = "新目标, "

            if ctld.jtacSpecialOptions.standbyMode.jtacs[_jtacGroupName] then
                action = ctld.i18n_translate("待命 %1", action)
            else
                action = ctld.i18n_translate("激光照射 %1", action)
            end

            if wasSelected and targetLost then
                action = ctld.i18n_translate(", 暂时 %1", action)
            else
                action = ", " .. action
            end

            if targetLost then
                action = "目标丢失" .. action
            elseif targetDestroyed then
                action = "目标已摧毁" .. action
            end

            if wasSelected then
                action = ctld.i18n_translate(", 已选择 %1", action)
            elseif targetLost or targetDestroyed then
                action = ", " .. action
            end
            wasSelected = false
            targetDestroyed = false
            targetLost = false

            local message = _jtacGroupName .. action .. _defaultEnemyUnit:getTypeName()
            local fullMessage = message ..
            '\n激光编码: ' .. _laserCode .. "\n坐标: " .. ctld.getPositionString(_defaultEnemyUnit)
            ctld.notifyCoalition(fullMessage, 10, _jtacUnit:getCoalition(), _radio, message)

            -- JTAC Unit stop his route -----------------
            trigger.action.groupStopMoving(Group.getByName(_jtacGroupName))             -- stop JTAC

            -- create smoke
            if _smoke == true then
                --create first smoke
                for _, target in pairs(ctld.jtacTargetsList[_jtacGroupName]) do
                    ctld.logInfo(string.format("ctld.setJTACTarget - listing target %s.", ctld.p(target.unit:getName())))
                end
                ctld.createSmokeMarker(_defaultEnemyUnit, _colour,_jtacGroupName)
            end
        end
    end

    if _enemyUnit ~= nil and not ctld.jtacSpecialOptions.standbyMode.jtacs[_jtacGroupName] then
        local refreshDelay = 15         --delay in between JTACAutoLase scheduled calls when a target is tracked
        local targetSpeedVec = _enemyUnit:getVelocity()
        local targetSpeed = math.sqrt(targetSpeedVec.x ^ 2 + targetSpeedVec.y ^ 2 + targetSpeedVec.z ^ 2)
        local maxUpdateDist = 5         --maximum distance the unit will be allowed to travel before the lase spot is updated again
        --ctld.logTrace(string.format("targetSpeed=%s", ctld.p(targetSpeed)))

        ctld.laseUnit(_enemyUnit, _jtacUnit, _jtacGroupName, _laserCode)

        --if the target is going sufficiently fast for it to wander off futher than the maxUpdateDist, schedule laseUnit calls to update the lase spot only (we consider that the unit lives and drives on between JTACAutoLase calls)
        if targetSpeed >= maxUpdateDist / refreshDelay then
            local updateTimeStep = maxUpdateDist /
            targetSpeed                                                  --calculate the time step so that the target is never more than maxUpdateDist from it's last lased position
            --ctld.logTrace(string.format("JTAC - LASE - [%s] - target is moving at %s m/s, schedulting lasing steps every %ss", ctld.p(_jtacGroupName), ctld.p(targetSpeed), ctld.p(updateTimeStep)))

            local i = 1
            while i * updateTimeStep <= refreshDelay - updateTimeStep do           --while the scheduled time for the laseUnit call isn't greater than the time between two JTACAutoLase() calls minus one time step (because at the next time step JTACAutoLase() should have been called and this in term also calls laseUnit())
                timer.scheduleFunction(ctld.timerLaseUnit, { _enemyUnit, _jtacUnit, _jtacGroupName, _laserCode },
                    timer.getTime() + i * updateTimeStep)
                i = i + 1
            end
            --ctld.logTrace(string.format("JTAC - LASE - [%s] - scheduled %s moving target lasing steps", ctld.p(_jtacGroupName), ctld.p(i)))
        end

        --ctld.logTrace(string.format("JTAC - LASE - [%s] - scheduling JTACAutoLase in %ss at %s", ctld.p(_jtacGroupName), ctld.p(refreshDelay), ctld.p(timer.getTime() + refreshDelay)))
        timer.scheduleFunction(ctld.timerJTACAutoLase, { _jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio },
            timer.getTime() + refreshDelay)

        if _smoke == true then
            local _nextSmokeTime = ctld.jtacSmokeMarks[_enemyUnit:getName()]

            --recreate smoke marker after 5 mins
            if _nextSmokeTime ~= nil and _nextSmokeTime < timer.getTime() then
                ctld.createSmokeMarker(_enemyUnit, _colour,_jtacGroupName)
            end
        end
    else
        --ctld.logDebug(string.format("JTAC - MODE - [%s] - No Enemies Nearby / Standby mode", ctld.p(_jtacGroupName)))

        -- stop lazing the old spot
        --ctld.logDebug(string.format("JTAC - LASE - [%s] - canceling lasing of the old spot", ctld.p(_jtacGroupName)))
        ctld.cancelLase(_jtacGroupName)

        --ctld.logTrace(string.format("JTAC - LASE - [%s] - scheduling JTACAutoLase in %ss at %s", ctld.p(_jtacGroupName), ctld.p(5), ctld.p(timer.getTime() + 5)))
        timer.scheduleFunction(ctld.timerJTACAutoLase, { _jtacGroupName, _laserCode, _smoke, _lock, _colour, _radio },
            timer.getTime() + 5)
    end

    local action = ", "
    if wasSelected then
        action = action .. "已选择 "
    end

    if targetLost then
        ctld.notifyCoalition(ctld.i18n_translate("%1 %2 目标丢失.", _jtacGroupName, action), 10,
            _jtacUnit:getCoalition(), _radio)
    elseif targetDestroyed then
        ctld.notifyCoalition(ctld.i18n_translate("%1 %2 目标已摧毁.", _jtacGroupName, action), 10,
            _jtacUnit:getCoalition(), _radio)
    end
end

function ctld.JTACAutoLaseStop(_jtacGroupName)
    ctld.jtacStop[_jtacGroupName] = true
end

-- used by the timer function
function ctld.timerJTACAutoLase(_args)

    ctld.JTACAutoLase(_args[1], _args[2], _args[3], _args[4], _args[5], _args[6])
end

function ctld.cleanupJTAC(_jtacGroupName)
    -- clear laser - just in case
    ctld.cancelLase(_jtacGroupName)

    -- Cleanup
    ctld.jtacCurrentTargets[_jtacGroupName] = nil

    ctld.jtacTargetsList[_jtacGroupName] = nil

    ctld.jtacSelectedTarget[_jtacGroupName] = nil

    for _, _specialOption in pairs(ctld.jtacSpecialOptions) do    --delete jtac specific settings for all special options
        if _specialOption.jtacs then
            _specialOption.jtacs[_jtacGroupName] = nil
        end
    end

    ctld.jtacRadioData[_jtacGroupName] = nil

    --remove the JTAC's group submenu and all of the target pages it potentially contained if the JTAC has or had a menu
    if ctld.jtacUnits[_jtacGroupName] and ctld.jtacUnits[_jtacGroupName].side and ctld.jtacGroupSubMenuPath[_jtacGroupName] then
        local _players = coalition.getPlayers(ctld.jtacUnits[_jtacGroupName].side)

        if _players ~= nil then
            for _, _playerUnit in pairs(_players) do
                local _groupId = ctld.getGroupId(_playerUnit)

                if _groupId then
                    missionCommands.removeItemForGroup(_groupId, ctld.jtacGroupSubMenuPath[_jtacGroupName])
                end
            end
        end
    end

    ctld.jtacUnits[_jtacGroupName] = nil

    ctld.jtacGroupSubMenuPath[_jtacGroupName] = nil
end

--- send a message to the coalition
--- if _radio is set, the message will be read out loud via SRS
function ctld.notifyCoalition(_message, _displayFor, _side, _radio, _shortMessage)
    trigger.action.outTextForCoalition(_side, _message, _displayFor)

    local _shortMessage = _shortMessage
    if _shortMessage == nil then
        _shortMessage = _message
    end

    if STTS and STTS.TextToSpeech and _radio and _radio.freq then
        local _freq = _radio.freq
        local _modulation = _radio.mod or "FM"
        local _volume = _radio.volume or "1.0"
        local _name = _radio.name or "JTAC"
        local _gender = _radio.gender or "male"
        local _culture = _radio.culture or "en-US"
        local _voice = _radio.voice
        local _googleTTS = _radio.googleTTS or false
        STTS.TextToSpeech(_shortMessage, _freq, _modulation, _volume, _name, _side, nil, 1, _gender, _culture, _voice,
            _googleTTS)
    else
        trigger.action.outSoundForCoalition(_side, "radiobeep.ogg")
    end
end

function ctld.RandomizePointByRadius(point,r)
    local radius = math.random() * r
    local theta = math.random() * 2 * math.pi
    local offsetX = radius * math.cos(theta)
    local offsetZ = radius * math.sin(theta)
    point.x = point.x + offsetX
    point.z = point.z + offsetZ
    return point    
end
function ctld.createSmokeMarker(_enemyUnit, _colour, _jtacGroupName)
    ctld.jtacMarkIDs = ctld.jtacMarkIDs or {}
    ctld.globalMarkCounter = ctld.globalMarkCounter or 0

    local unitName = _enemyUnit:getName()

    if ctld.jtacMarkIDs[unitName] and ctld.jtacMarkIDs[unitName].jtac == _jtacGroupName then
        local oldID = ctld.jtacMarkIDs[unitName].id
        pcall(function()
            trigger.action.removeMark(oldID)
        end)
    end

    ctld.globalMarkCounter = ctld.globalMarkCounter + 1

    local newID = _enemyUnit:getID() * 10000 + ctld.globalMarkCounter
    ctld.jtacMarkIDs[unitName] = {
        id = newID,
        jtac = _jtacGroupName
    }

    --recreate in 5 mins
    ctld.jtacSmokeMarks[_enemyUnit:getName()] = timer.getTime() + 300.0
    
    local _enemyPoint = _enemyUnit:getPoint()
    local _randomizedPoint = ctld.RandomizePointByRadius(_enemyPoint,100)

    local _enemyCoalition = _enemyUnit:getCoalition()
    local _coalition = (_enemyCoalition == 1) and 2 or 1

    trigger.action.markToCoalition(newID, _enemyUnit:getTypeName() , _randomizedPoint, _coalition,true)
    -- trigger.action.smoke({ x = _enemyPoint.x, y = _enemyPoint.y + 2.0, z = _enemyPoint.z }, _colour)
end

function ctld.cancelLase(_jtacGroupName)

    --local index = "JTAC_"..jtacUnit:getID()

    local _tempLase = ctld.jtacLaserPoints[_jtacGroupName]

    if _tempLase ~= nil then
        Spot.destroy(_tempLase)
        ctld.jtacLaserPoints[_jtacGroupName] = nil

        --      ctld.logInfo('Destroy laze  '..index)

        _tempLase = nil
    end

    local _tempIR = ctld.jtacIRPoints[_jtacGroupName]

    if _tempIR ~= nil then
        Spot.destroy(_tempIR)
        ctld.jtacIRPoints[_jtacGroupName] = nil

        --  ctld.logInfo('Destroy laze  '..index)

        _tempIR = nil
    end
end

-- used by the timer function
function ctld.timerLaseUnit(_args)
    ctld.laseUnit(_args[1], _args[2], _args[3], _args[4])
end

function ctld.laseUnit(_enemyUnit, _jtacUnit, _jtacGroupName, _laserCode)
    --cancelLase(jtacGroupName)
    --ctld.logTrace("ctld.laseUnit()")

    local _spots = {}

    if _enemyUnit:isExist() then
        local _enemyVector = _enemyUnit:getPoint()
        local _enemyVectorUpdated = { x = _enemyVector.x, y = _enemyVector.y + 2.0, z = _enemyVector.z }

        if ctld.jtacSpecialOptions.laseSpotCorrections.jtacs[_jtacGroupName] then
            local _enemySpeedVector = _enemyUnit:getVelocity()
            ctld.logTrace(string.format("_enemySpeedVector=%s", ctld.p(_enemySpeedVector)))

            local _WindSpeedVector = atmosphere.getWind(_enemyVectorUpdated)
            ctld.logTrace(string.format("_WindSpeedVector=%s", ctld.p(_WindSpeedVector)))

            --if target speed is greater than 0, calculated using absolute value norm
            if math.abs(_enemySpeedVector.x) + math.abs(_enemySpeedVector.y) + math.abs(_enemySpeedVector.z) > 0 then
                local CorrectionFactor = 1                 --correction factor in seconds applied to the target speed components to determine the lasing spot for a direct hit on a moving vehicle

                --correct in the direction of the movement
                _enemyVectorUpdated.x = _enemyVectorUpdated.x + _enemySpeedVector.x * CorrectionFactor
                _enemyVectorUpdated.y = _enemyVectorUpdated.y + _enemySpeedVector.y * CorrectionFactor
                _enemyVectorUpdated.z = _enemyVectorUpdated.z + _enemySpeedVector.z * CorrectionFactor
            end

            --if wind speed is greater than 0, calculated using absolute value norm
            if math.abs(_WindSpeedVector.x) + math.abs(_WindSpeedVector.y) + math.abs(_WindSpeedVector.z) > 0 then
                local CorrectionFactor = 1.05                 --correction factor in seconds applied to the wind speed components to determine the lasing spot for a direct hit in adverse conditions

                --correct to the opposite of the wind direction
                _enemyVectorUpdated.x = _enemyVectorUpdated.x - _WindSpeedVector.x * CorrectionFactor
                _enemyVectorUpdated.y = _enemyVectorUpdated.y -
                _WindSpeedVector.y *
                CorrectionFactor                                                                                      --not sure about correcting altitude but that component is always 0 in testing
                _enemyVectorUpdated.z = _enemyVectorUpdated.z - _WindSpeedVector.z * CorrectionFactor
            end
            --combination of both should result in near perfect accuracy if the bomb doesn't stall itself following fast vehicles or correcting for heavy winds, correction factors can be adjusted but should work up to 40kn of wind for vehicles moving at 90kph (beware to drop the bomb in a way to not stall it, facing which ever is larger, target speed or wind)
        end

        local _oldLase = ctld.jtacLaserPoints[_jtacGroupName]
        local _oldIR = ctld.jtacIRPoints[_jtacGroupName]

        if _oldLase == nil or _oldIR == nil then
            -- create lase

            local _status, _result = pcall(function()
                _spots['irPoint'] = Spot.createInfraRed(_jtacUnit, { x = 0, y = 2.0, z = 0 }, _enemyVectorUpdated)
                _spots['laserPoint'] = Spot.createLaser(_jtacUnit, { x = 0, y = 2.0, z = 0 }, _enemyVectorUpdated,
                    _laserCode)
                return _spots
            end)

            if not _status then
                env.error('ERROR: ' .. _result, false)
            else
                if _result.irPoint then
                    --        env.info(jtacUnit:getName() .. ' placed IR Pointer on '..enemyUnit:getName())

                    ctld.jtacIRPoints[_jtacGroupName] = _result.irPoint                     --store so we can remove after
                end
                if _result.laserPoint then
                    --    env.info(jtacUnit:getName() .. ' is Lasing '..enemyUnit:getName()..'. CODE:'..laserCode)

                    ctld.jtacLaserPoints[_jtacGroupName] = _result.laserPoint
                end
            end
        else
            -- update lase

            if _oldLase ~= nil then
                _oldLase:setPoint(_enemyVectorUpdated)
            end

            if _oldIR ~= nil then
                _oldIR:setPoint(_enemyVectorUpdated)
            end
        end
    end
end

-- get currently selected unit and check they're still in range
function ctld.getCurrentUnit(_jtacUnit, _jtacGroupName)
    local _unit = nil

    if ctld.jtacCurrentTargets[_jtacGroupName] ~= nil then
        _unit = Unit.getByName(ctld.jtacCurrentTargets[_jtacGroupName].name)
    end

    local _tempPoint = nil
    local _tempDist = nil
    local _tempPosition = nil
    local _jtacPosition = _jtacUnit:getPosition()
    local _jtacPoint = _jtacUnit:getPoint()

    if _unit ~= nil and _unit:getLife() > 0 and _unit:isActive() == true then
        -- calc distance
        _tempPoint = _unit:getPoint()
        --     tempPosition = unit:getPosition()

        _tempDist = ctld.getDistance(_unit:getPoint(), _jtacUnit:getPoint())
        if _tempDist < ctld.JTAC_maxDistance then
            -- calc visible

            -- check slightly above the target as rounding errors can cause issues, plus the unit has some height anyways
            local _offsetEnemyPos = { x = _tempPoint.x, y = _tempPoint.y + 2.0, z = _tempPoint.z }
            local _offsetJTACPos = { x = _jtacPoint.x, y = _jtacPoint.y + 2.0, z = _jtacPoint.z }

            if land.isVisible(_offsetEnemyPos, _offsetJTACPos) then
                return _unit
            end
        end
    end
    return nil
end

-- Find nearest enemy to JTAC that isn't blocked by terrain
function ctld.findNearestVisibleEnemy(_jtacUnit, _targetType, _distance)
    --local startTime = os.clock()
    local _maxDistance = _distance or ctld.JTAC_maxDistance
    local _nearestDistance = _maxDistance
    local _jtacGroupName = _jtacUnit:getGroup():getName()
    local _jtacPoint = _jtacUnit:getPoint()
    local _coa = _jtacUnit:getCoalition()
    local _offsetJTACPos = { x = _jtacPoint.x, y = _jtacPoint.y + 2.0, z = _jtacPoint.z }

    local _volume = {
        id = world.VolumeType.SPHERE,
        params = {
            point = _offsetJTACPos,
            radius = _maxDistance
        }
    }

    local _unitList = {}

    local _search = function(_unit, _coa)
        pcall(function()
            if _unit ~= nil
                and _unit:getLife() > 0
                and _unit:isActive()
                and _unit:getCoalition() ~= _coa
                and not _unit:inAir()
                and not ctld.alreadyTarget(_jtacUnit, _unit) then
                local _tempPoint = _unit:getPoint()
                local _offsetEnemyPos = { x = _tempPoint.x, y = _tempPoint.y + 2.0, z = _tempPoint.z }

                if land.isVisible(_offsetJTACPos, _offsetEnemyPos) then
                    local _dist = ctld.getDistance(_offsetJTACPos, _offsetEnemyPos)

                    if _dist < _maxDistance then
                        table.insert(_unitList, { unit = _unit, dist = _dist })
                    end
                end
            end
        end)

        return true
    end

    world.searchObjects(Object.Category.UNIT, _volume, _search, _coa)

    --log.info(string.format("JTAC Search elapsed time: %.4f\n", os.clock() - startTime))

    -- generate list order by distance & visible

    -- first check
    -- hpriority
    -- priority
    -- vehicle
    -- unit


    ctld.jtacTargetsList[_jtacGroupName] = _unitList
    --from the units in range, build the targets list, unsorted as to keep consistency between radio menu refreshes

    local _sort = function(a, b) return a.dist < b.dist end
    table.sort(_unitList, _sort)
    -- sort list

    -- check for hpriority
    for _, _enemyUnit in ipairs(_unitList) do
        local _enemyName = _enemyUnit.unit:getName()

        if string.match(_enemyName, "hpriority") then
            return _enemyUnit.unit
        end
    end

    for _, _enemyUnit in ipairs(_unitList) do
        local _enemyName = _enemyUnit.unit:getName()

        if string.match(_enemyName, "priority") then
            return _enemyUnit.unit
        end
    end

    local result = nil
    for _, _enemyUnit in ipairs(_unitList) do
        local _enemyName = _enemyUnit.unit:getName()
        --log.info(string.format("CTLD - checking _enemyName=%s", _enemyName))

        -- check for air defenses
        --log.info(string.format("CTLD - _enemyUnit.unit:getDesc()[attributes]=%s", ctld.p(_enemyUnit.unit:getDesc()["attributes"])))
        local airdefense = (_enemyUnit.unit:getDesc()["attributes"]["Air Defence"] ~= nil)
        --log.info(string.format("CTLD - airdefense=%s", tostring(airdefense)))

        if (_targetType == "vehicle" and ctld.isVehicle(_enemyUnit.unit)) or _targetType == "all" then
            if airdefense then
                return _enemyUnit.unit
            else
                result = _enemyUnit.unit
            end
        elseif (_targetType == "troop" and ctld.isInfantry(_enemyUnit.unit)) or _targetType == "all" then
            if airdefense then
                return _enemyUnit.unit
            else
                result = _enemyUnit.unit
            end
        end
    end

    return result
end

function ctld.listNearbyEnemies(_jtacUnit)
    local _maxDistance = ctld.JTAC_maxDistance

    local _jtacPoint = _jtacUnit:getPoint()
    local _coa = _jtacUnit:getCoalition()

    local _offsetJTACPos = { x = _jtacPoint.x, y = _jtacPoint.y + 2.0, z = _jtacPoint.z }

    local _volume = {
        id = world.VolumeType.SPHERE,
        params = {
            point = _offsetJTACPos,
            radius = _maxDistance
        }
    }
    local _enemies = nil

    local _search = function(_unit, _coa)
        pcall(function()
            if _unit ~= nil
                and _unit:getLife() > 0
                and _unit:isActive()
                and _unit:getCoalition() ~= _coa
                and not _unit:inAir() then
                local _tempPoint = _unit:getPoint()
                local _offsetEnemyPos = { x = _tempPoint.x, y = _tempPoint.y + 2.0, z = _tempPoint.z }

                if land.isVisible(_offsetJTACPos, _offsetEnemyPos) then
                    if not _enemies then
                        _enemies = {}
                    end

                    _enemies[_unit:getTypeName()] = _unit:getTypeName()
                end
            end
        end)

        return true
    end

    world.searchObjects(Object.Category.UNIT, _volume, _search, _coa)

    return _enemies
end

-- tests whether the unit is targeted by another JTAC
function ctld.alreadyTarget(_jtacUnit, _enemyUnit)
    for _, _jtacTarget in pairs(ctld.jtacCurrentTargets) do
        if _jtacTarget.unitId == _enemyUnit:getID() then
            -- env.info("ALREADY TARGET")
            return true
        end
    end

    return false
end

-- Returns only alive units from group but the group / unit may not be active
function ctld.getGroup(groupName)
    local _group = Group.getByName(groupName)

    local _filteredUnits = {}     --contains alive units
    local _x = 1

    if _group ~= nil then
        --ctld.logTrace(string.format("ctld.getGroup - %s - group ~= nil", ctld.p(groupName)))
        if _group:isExist() then
            --ctld.logTrace(string.format("ctld.getGroup - %s - group:isExist()", ctld.p(groupName)))
            local _groupUnits = _group:getUnits()

            if _groupUnits ~= nil and #_groupUnits > 0 then
                --ctld.logTrace(string.format("ctld.getGroup - %s - group has %s units", ctld.p(groupName), ctld.p(#_groupUnits)))
                for _x = 1, #_groupUnits do
                    if _groupUnits[_x]:getLife() > 0 then                        -- removed and _groupUnits[_x]:isExist() as isExist doesnt work on single units!
                        table.insert(_filteredUnits, _groupUnits[_x])
                    else
                        --ctld.logTrace(string.format("ctld.getGroup - %s - dead unit %s", ctld.p(groupName), ctld.p(_groupUnits[_x]:getName())))
                    end
                end
            end
        end
    end

    return _filteredUnits
end

function ctld.getAliveGroup(_groupName)
    local _group = Group.getByName(_groupName)

    if _group and _group:isExist() == true and #_group:getUnits() > 0 then
        return _group
    end

    return nil
end

-- gets the JTAC status and displays to coalition units
function ctld.getJTACStatus(_args)
    --returns the status of all JTAC units unless the status of a single JTAC is asked for (by inserting it's groupName in _args[2])

    local _playerUnit = ctld.getTransportUnit(_args[1])
    local _singleJtacGroupName = _args[2]

    if _playerUnit == nil and _singleJtacGroupName == nil then
        return
    end

    local _side = nil

    if _playerUnit == nil then
        _side = ctld.jtacUnits[_singleJtacGroupName].side
    else
        _side = _playerUnit:getCoalition()
    end

    local _jtacUnit = nil
    local hasJTAC = false
    local _message = ctld.i18n_translate("JTAC 信息: \n\n")

    for _jtacGroupName, _jtacDetails in pairs(ctld.jtacUnits) do
        --look up units
        if _singleJtacGroupName == nil or (_singleJtacGroupName and _singleJtacGroupName == _jtacGroupName) then         --if the status of a single JTAC or if the status of a single JTAC was asked and this is the correct JTAC we're going over in the loop
            _jtacUnit = Unit.getByName(_jtacDetails.name)

            if _jtacUnit ~= nil and _jtacUnit:getLife() > 0 and _jtacUnit:isActive() == true and _jtacUnit:getCoalition() == _side then
                hasJTAC = true

                local _enemyUnit = ctld.getCurrentUnit(_jtacUnit, _jtacGroupName)

                local _laserCode = ctld.jtacLaserPointCodes[_jtacGroupName]

                local _start = "->" .. _jtacGroupName
                if (_jtacDetails.radio) then
                    _start = _start ..
                    ctld.i18n_translate("\n 无线电频率 %1 %2,", _jtacDetails.radio.freq, _jtacDetails.radio.mod)
                end

                if _laserCode == nil then
                    _laserCode = ctld.i18n_translate("UNKNOWN")
                end

                if _enemyUnit ~= nil and _enemyUnit:getLife() > 0 and _enemyUnit:isActive() == true then
                    local action = ctld.i18n_translate("\n正在搜索目标 ")

                    if ctld.jtacSelectedTarget[_jtacGroupName] == _enemyUnit:getName() then
                        action = ctld.i18n_translate("\n锁定选择的目标: ")
                    else
                        if ctld.jtacSelectedTarget[_jtacGroupName] ~= 1 then
                            action = ctld.i18n_translate("\n正在寻找选择的目标, 目前暂时锁定: ")
                        end
                    end

                    if ctld.jtacSpecialOptions.standbyMode.jtacs[_jtacGroupName] then
                        action = action .. ctld.i18n_translate("(激光关闭) ")
                    end

                    _message = _message ..
                    "" ..
                    _start ..
                    action ..
                    _enemyUnit:getTypeName() .. "\n 激光代码: " .. _laserCode .. ctld.getPositionString(_enemyUnit) .. "\n"

                    local _list = ctld.listNearbyEnemies(_jtacUnit)

                    if _list then
                        _message = _message .. ctld.i18n_translate("同时目视: ")

                        for _, _type in pairs(_list) do
                            _message = _message .. _type .. ", "
                        end
                        _message = _message .. "\n"
                    end
                else
                    _message = _message ..
                    "" .. _start .. ctld.i18n_translate("\n 正在搜索目标\n当前坐标 %1", ctld.getPositionString(_jtacUnit))
                end
            end
        end
    end

    if not hasJTAC then
        ctld.notifyCoalition(ctld.i18n_translate("没有活动的JTAC"), 10, _side)
    else
        ctld.notifyCoalition(_message, 10, _side)
    end
end

function ctld.setJTACTarget(_args)
    if _args then
        local _jtacGroupName = _args.jtacGroupName
        local targetName = _args.targetName

        if _jtacGroupName and targetName and ctld.jtacSelectedTarget[_jtacGroupName] and ctld.jtacTargetsList[_jtacGroupName] then
            --look for the unit's (target) name in the Targets List, create the required data structure for jtacCurrentTargets and then assign it to the JTAC called _jtacGroupName
            for _, target in pairs(ctld.jtacTargetsList[_jtacGroupName]) do
                ctld.logInfo(string.format("ctld.setJTACTarget - checking target %s for match with %s", ctld.p(target.unit:getName()), ctld.p(targetName)))
                if target then
                    local listedTargetUnit = target.unit
                    local ListedTargetName = listedTargetUnit:getName()
                    if ListedTargetName == targetName then
                        local _colour
                        if ctld.jtacUnits[_jtacGroupName].side == 1 then
                            _colour = ctld.JTAC_smokeColour_RED
                        else
                            _colour = ctld.JTAC_smokeColour_BLUE
                        end

                        ctld.createSmokeMarker(listedTargetUnit, _colour,_jtacGroupName)
                        ctld.jtacSelectedTarget[_jtacGroupName] = targetName
                        ctld.jtacCurrentTargets[_jtacGroupName] = { name = targetName, unitType = listedTargetUnit
                        :getTypeName(), unitId = listedTargetUnit:getID() }

                        for unitName, info in pairs(ctld.jtacMarkIDs) do
                            if info.jtac == _jtacGroupName and unitName ~= targetName then
                                pcall(function()
                                    trigger.action.removeMark(info.id)
                                end)
                                ctld.jtacMarkIDs[unitName] = nil
                            end
                        end
                        
                        local message = _jtacGroupName ..
                        ctld.i18n_translate("\n 锁定选择的目标: %1", listedTargetUnit:getTypeName())
                        local fullMessage = message ..
                        ctld.i18n_translate("\n 激光编码: %1\n 坐标: %2", ctld.jtacLaserPointCodes[_jtacGroupName],
                            ctld.getPositionString(listedTargetUnit))
                        ctld.notifyCoalition(fullMessage, 10, ctld.jtacUnits[_jtacGroupName].side,
                            ctld.jtacRadioData[_jtacGroupName], message)
                        break
                    end
                end
            end
        elseif not targetName and ctld.jtacSelectedTarget[_jtacGroupName] ~= 1 then
            ctld.jtacSelectedTarget[_jtacGroupName] = 1
            ctld.jtacCurrentTargets[_jtacGroupName] = nil

            local message = _jtacGroupName .. ctld.i18n_translate(", 重置目标选择.")
            ctld.notifyCoalition(message, 10, ctld.jtacUnits[_jtacGroupName].side, ctld.jtacRadioData[_jtacGroupName])

            if ctld.jtacSpecialOptions.laseSpotCorrections.jtacs[_jtacGroupName] then
                ctld.setLaseCompensation({ jtacGroupName = _jtacGroupName, value = false })               --disable laser spot corrections
            end

            if ctld.jtacSpecialOptions.standbyMode.jtacs[_jtacGroupName] then
                ctld.setStdbMode({ jtacGroupName = _jtacGroupName, value = false })               --make the JTAC exit standby mode after either target selection or targeting selection reset
            end
        end

        ctld.refreshJTACmenu[ctld.jtacUnits[_jtacGroupName].side] = true
    end
end

--special option setters (make sure to affect the function pointer to the corresponding .setter in the special options table after declaration of said function)
function ctld.setSpecialOptionArgsCheck(_args)
    if _args then
        local _jtacGroupName = _args.jtacGroupName
        local _value = _args.value                --expected boolean
        local _notOutput = _args.noOutput         --expected boolean

        if _jtacGroupName then
            return { jtacGroupName = _jtacGroupName, value = _value, noOutput = _notOutput }
        end
    end

    return nil
end

function ctld.setStdbMode(_args)
    local parsedArgs = ctld.setSpecialOptionArgsCheck(_args)
    if parsedArgs then
        local _jtacGroupName = parsedArgs.jtacGroupName
        local _value = parsedArgs.value
        local _noOutput = parsedArgs.noOutput

        local message = ctld.i18n_translate("%1, 启用激光照射和烟雾标记", _jtacGroupName)
        if _value then
            message = ctld.i18n_translate("%1, 停用激光照射和烟雾标记", _jtacGroupName)
        end
        if not _noOutput then
            ctld.notifyCoalition(message, 10, ctld.jtacUnits[_jtacGroupName].side, ctld.jtacRadioData[_jtacGroupName])
        end

        ctld.jtacSpecialOptions.standbyMode.jtacs[_jtacGroupName] = _value
        ctld.refreshJTACmenu[ctld.jtacUnits[_jtacGroupName].side] = true
    end
end

ctld.jtacSpecialOptions.standbyMode.setter = ctld.setStdbMode

function ctld.setLaseCompensation(_args)
    local parsedArgs = ctld.setSpecialOptionArgsCheck(_args)
    if parsedArgs then
        local _jtacGroupName = parsedArgs.jtacGroupName
        local _value = parsedArgs.value
        local _noOutput = parsedArgs.noOutput

        local message = ctld.i18n_translate("%1, 启用激光照射点风偏和目标速度补偿", _jtacGroupName)
        if _value then
            message = ctld.i18n_translate("%1, 停用激光照射点风偏和目标速度补偿", _jtacGroupName)
        end
        if not _noOutput then
            ctld.notifyCoalition(message, 10, ctld.jtacUnits[_jtacGroupName].side, ctld.jtacRadioData[_jtacGroupName])
        end

        ctld.jtacSpecialOptions.laseSpotCorrections.jtacs[_jtacGroupName] = _value
        ctld.refreshJTACmenu[ctld.jtacUnits[_jtacGroupName].side] = true
    end
end

ctld.jtacSpecialOptions.laseSpotCorrections.setter = ctld.setLaseCompensation

function ctld.setSmokeOnTarget(_args)
    local parsedArgs = ctld.setSpecialOptionArgsCheck(_args)
    if parsedArgs then
        local _jtacGroupName = parsedArgs.jtacGroupName
        local _noOutput = parsedArgs.noOutput
        local _enemyUnit = Unit.getByName(ctld.jtacCurrentTargets[_jtacGroupName].name)

        if _enemyUnit then
            if not _noOutput then
                ctld.notifyCoalition(ctld.i18n_translate("%1, 目标已用白烟标记", _jtacGroupName), 10,
                    ctld.jtacUnits[_jtacGroupName].side, ctld.jtacRadioData[_jtacGroupName])
            end

            local _enemyPoint = _enemyUnit:getPoint()
            local randomCircleDiam = 30;
            trigger.action.smoke(
            { x = _enemyPoint.x + math.random(randomCircleDiam, -randomCircleDiam), y = _enemyPoint.y + 2.0, z =
            _enemyPoint.z + math.random(randomCircleDiam, -randomCircleDiam) }, 2)
        end
    end
end

ctld.jtacSpecialOptions.smokeMarker.setter = ctld.setSmokeOnTarget

function ctld.setJTAC9Line(_args)
    local parsedArgs = ctld.setSpecialOptionArgsCheck(_args)
    if parsedArgs then
        local _jtacGroupName = parsedArgs.jtacGroupName

        ctld.getJTACStatus({ nil, _jtacGroupName })
    end
end

ctld.jtacSpecialOptions._9Line.setter = ctld.setJTAC9Line

function ctld.isInfantry(_unit)

    local _typeName = _unit:getTypeName()

    --type coerce tostring
    _typeName = string.lower(_typeName .. "")

    local _soldierType = { "infantry", "paratrooper", "stinger", "manpad", "mortar" }

    for _key, _value in pairs(_soldierType) do
        if string.match(_typeName, _value) then
            return true
        end
    end

    return false
end

-- 只有地面载具才是Vehicle
function ctld.isVehicle(_unit)
    ctld.logDebug('检查载具类型:' .. _unit:getName() .. "|" .. _unit:getDesc()["category"])
    if _unit:getDesc()["category"] == 2 then
        return true
    else
        return false
    end
end

-- The entered value can range from 1111 - 1788,
-- -- but the first digit of the series must be a 1 or 2
-- -- and the last three digits must be between 1 and 8.
--  The range used to be bugged so its not 1 - 8 but 0 - 7.
-- function below will use the range 1-7 just incase
function ctld.generateLaserCode()

    ctld.jtacGeneratedLaserCodes = {}

    -- generate list of laser codes
    local _code = 1111

    local _count = 1

    while _code < 1777 and _count < 30 do

        while true do

            _code = _code + 1

            if not ctld.containsDigit(_code, 8)
                    and not ctld.containsDigit(_code, 9)
                    and not ctld.containsDigit(_code, 0) then

                table.insert(ctld.jtacGeneratedLaserCodes, _code)

                --ctld.logInfo(_code.." Code")
                break
            end
        end
        _count = _count + 1
    end
end

function ctld.containsDigit(_number, _numberToFind)

    local _thisNumber = _number
    local _thisDigit = 0

    while _thisNumber ~= 0 do

        _thisDigit = _thisNumber % 10
        _thisNumber = math.floor(_thisNumber / 10)

        if _thisDigit == _numberToFind then
            return true
        end
    end

    return false
end

-- 200 - 400 in 10KHz
-- 400 - 850 in 10 KHz
-- 850 - 1250 in 50 KHz
function ctld.generateVHFrequencies()

    --ignore list
    --list of all frequencies in KHZ that could conflict with
    -- 191 - 1290 KHz, beacon range
    local _skipFrequencies = {
        745, --Astrahan
        381,
        384,
        300.50,
        312.5,
        1175,
        342,
        735,
        300.50,
        353.00,
        440,
        795,
        525,
        520,
        690,
        625,
        291.5,
        300.50,
        435,
        309.50,
        920,
        1065,
        274,
        312.50,
        580,
        602,
        297.50,
        750,
        485,
        950,
        214,
        1025, 730, 995, 455, 307, 670, 329, 395, 770,
        380, 705, 300.5, 507, 740, 1030, 515,
        330, 309.5,
        348, 462, 905, 352, 1210, 942, 435,
        324,
        320, 420, 311, 389, 396, 862, 680, 297.5,
        920, 662,
        866, 907, 309.5, 822, 515, 470, 342, 1182, 309.5, 720, 528,
        337, 312.5, 830, 740, 309.5, 641, 312, 722, 682, 1050,
        1116, 935, 1000, 430, 577,
        326 -- Nevada
    }

    ctld.freeVHFFrequencies = {}
    local _start = 200000

    -- first range
    while _start < 400000 do

        -- skip existing NDB frequencies
        local _found = false
        for _, value in pairs(_skipFrequencies) do
            if value * 1000 == _start then
                _found = true
                break
            end
        end

        if _found == false then
            table.insert(ctld.freeVHFFrequencies, _start)
        end

        _start = _start + 10000
    end

    _start = 400000
    -- second range
    while _start < 850000 do

        -- skip existing NDB frequencies
        local _found = false
        for _, value in pairs(_skipFrequencies) do
            if value * 1000 == _start then
                _found = true
                break
            end
        end

        if _found == false then
            table.insert(ctld.freeVHFFrequencies, _start)
        end

        _start = _start + 10000
    end

    _start = 850000
    -- third range
    while _start <= 1250000 do

        -- skip existing NDB frequencies
        local _found = false
        for _, value in pairs(_skipFrequencies) do
            if value * 1000 == _start then
                _found = true
                break
            end
        end

        if _found == false then
            table.insert(ctld.freeVHFFrequencies, _start)
        end

        _start = _start + 50000
    end
end

-- 220 - 399 MHZ, increments of 0.5MHZ
function ctld.generateUHFrequencies()

    ctld.freeUHFFrequencies = {}
    local _start = 220000000

    while _start < 399000000 do
        table.insert(ctld.freeUHFFrequencies, _start)
        _start = _start + 500000
    end
end


-- 220 - 399 MHZ, increments of 0.5MHZ
--    -- first digit 3-7MHz
--    -- second digit 0-5KHz
--    -- third digit 0-9
--    -- fourth digit 0 or 5
--    -- times by 10000
--
function ctld.generateFMFrequencies()

    ctld.freeFMFrequencies = {}
    local _start = 220000000

    while _start < 399000000 do

        _start = _start + 500000
    end

    for _first = 3, 7 do
        for _second = 0, 5 do
            for _third = 0, 9 do
                local _frequency = ((100 * _first) + (10 * _second) + _third) * 100000 --extra 0 because we didnt bother with 4th digit
                table.insert(ctld.freeFMFrequencies, _frequency)
            end
        end
    end
end

function ctld.getPositionString(_unit)
    if ctld.JTAC_location == false then
        return ""
    end

    local _lat, _lon  = coord.LOtoLL(_unit:getPosition().p)
    local _latLngStr  = mist.tostringLL(_lat, _lon, 3, ctld.location_DMS)
    local _mgrsString = mist.tostringMGRS(coord.LLtoMGRS(coord.LOtoLL(_unit:getPosition().p)), 5)
    local _TargetAlti = land.getHeight(mist.utils.makeVec2(_unit:getPoint()))
    return " @ " ..
    _latLngStr ..
    "\n- MGRS " ..
    _mgrsString ..
    "\n- ALTI: " .. mist.utils.round(_TargetAlti, 0) .. " m / " .. mist.utils.round(_TargetAlti / 0.3048, 0) .. " ft"
end


-- ***************** SETUP SCRIPT ****************
function ctld.initialize(force)
    ctld.logInfo(string.format("Initializing version %s", ctld.Version))
    ctld.logTrace(string.format("ctld.alreadyInitialized=%s", ctld.p(ctld.alreadyInitialized)))
    ctld.logTrace(string.format("force=%s", ctld.p(force)))

    if ctld.alreadyInitialized and not force then
        ctld.logInfo(string.format("Bypassing initialization because ctld.alreadyInitialized = true"))
        return
    end

    assert(mist ~= nil, "\n\n** HEY MISSION-DESIGNER! **\n\nMiST has not been loaded!\n\nMake sure MiST 3.6 or higher is running\n*before* running this script!\n")

    ctld.captureCommandAdded = {}
    ctld.addedCSARTo= {}
    ctld.addedBomberTo= {}
    ctld.addedSupportTo= {}
    ctld.addedTo = {}
    ctld.spawnedCratesRED = {} -- use to store crates that have been spawned
    ctld.spawnedCratesBLUE = {} -- use to store crates that have been spawned

    ctld.droppedTroopsRED = {} -- stores dropped troop groups
    ctld.droppedTroopsBLUE = {} -- stores dropped troop groups

    ctld.droppedVehiclesRED = {} -- stores vehicle groups for c-130 / hercules
    ctld.droppedVehiclesBLUE = {} -- stores vehicle groups for c-130 / hercules

    ctld.inTransitTroops = {}

    ctld.inTransitFOBCrates = {}

    ctld.inTransitSlingLoadCrates = {} -- stores crates that are being transported by helicopters for alternative to real slingload

    ctld.droppedFOBCratesRED = {}
    ctld.droppedFOBCratesBLUE = {}

    ctld.builtFOBS = {} -- stores fully built fobs

    ctld.completeGroupSystems = ctld.completeGroupSystems or {} -- stores complete spawned groups from multiple crates

    ctld.fobBeacons = {} -- stores FOB radio beacon details, refreshed every 60 seconds

    ctld.deployedRadioBeacons = {} -- stores details of deployed radio beacons

    ctld.beaconCount = 1

    ctld.usedUHFFrequencies = {}
    ctld.usedVHFFrequencies = {}
    ctld.usedFMFrequencies = {}

    ctld.freeUHFFrequencies = {}
    ctld.freeVHFFrequencies = {}
    ctld.freeFMFrequencies = {}

    --used to lookup what the crate will contain
    ctld.crateLookupTable = {}

    ctld.extractZones = {} -- stored extract zones

    ctld.missionEditorCargoCrates = {} --crates added by mission editor for triggering cratesinzone
    ctld.hoverStatus = {} -- tracks status of a helis hover above a crate

    ctld.callbacks = {} -- function callback
    -- stored the infomation of groups the player spawned


    -- Remove intransit troops when heli / cargo plane dies
    --ctld.eventHandler = {}
    --function ctld.eventHandler:onEvent(_event)
    --
    --    if _event == nil or _event.initiator == nil then
    --        ctld.logInfo("CTLD null event")
    --    elseif _event.id == 9 then
    --        -- Pilot dead
    --        ctld.inTransitTroops[_event.initiator:getName()] = nil
    --
    --    elseif world.event.S_EVENT_EJECTION == _event.id or _event.id == 8 then
    --        -- ctld.logInfo("Event unit - Pilot Ejected or Unit Dead")
    --        ctld.inTransitTroops[_event.initiator:getName()] = nil
    --
    --        -- ctld.logInfo(_event.initiator:getName())
    --    end
    --
    --end

    -- create crate lookup table
    for _, category in ipairs(ctld.spawnableCrates) do
        for _, crate in ipairs(category.items) do
            -- 使用描述作为键，确保唯一性检查
            if ctld.crateLookupTable[crate.desc] == nil then
                ctld.crateLookupTable[crate.desc] = crate
            else
                env.error(string.format("[CTLD] 错误: 描述重复 '%s' (单位: %s)", 
                                        crate.desc, crate.unit))
            end
        end
    end


    --sort out pickup zones
    for _, _zone in pairs(ctld.pickupZones) do

        local _zoneName = _zone[1]
        local _zoneColor = _zone[2]
        local _zoneActive = _zone[4]

        if _zoneColor == "green" then
            _zone[2] = trigger.smokeColor.Green
        elseif _zoneColor == "red" then
            _zone[2] = trigger.smokeColor.Red
        elseif _zoneColor == "white" then
            _zone[2] = trigger.smokeColor.White
        elseif _zoneColor == "orange" then
            _zone[2] = trigger.smokeColor.Orange
        elseif _zoneColor == "blue" then
            _zone[2] = trigger.smokeColor.Blue
        else
            _zone[2] = -1 -- no smoke colour
        end

        -- add in counter for troops or units
        if _zone[3] == -1 then
            _zone[3] = 10000;
        end

        -- change active to 1 / 0
        if _zoneActive == "yes" then
            _zone[4] = 1
        else
            _zone[4] = 0
        end
    end

    --sort out dropoff zones
    for _, _zone in pairs(ctld.dropOffZones) do

        local _zoneColor = _zone[2]

        if _zoneColor == "green" then
            _zone[2] = trigger.smokeColor.Green
        elseif _zoneColor == "red" then
            _zone[2] = trigger.smokeColor.Red
        elseif _zoneColor == "white" then
            _zone[2] = trigger.smokeColor.White
        elseif _zoneColor == "orange" then
            _zone[2] = trigger.smokeColor.Orange
        elseif _zoneColor == "blue" then
            _zone[2] = trigger.smokeColor.Blue
        else
            _zone[2] = -1 -- no smoke colour
        end

        --mark as active for refresh smoke logic to work
        _zone[4] = 1
    end

    --sort out waypoint zones
    for _, _zone in pairs(ctld.wpZones) do

        local _zoneColor = _zone[2]

        if _zoneColor == "green" then
            _zone[2] = trigger.smokeColor.Green
        elseif _zoneColor == "red" then
            _zone[2] = trigger.smokeColor.Red
        elseif _zoneColor == "white" then
            _zone[2] = trigger.smokeColor.White
        elseif _zoneColor == "orange" then
            _zone[2] = trigger.smokeColor.Orange
        elseif _zoneColor == "blue" then
            _zone[2] = trigger.smokeColor.Blue
        else
            _zone[2] = -1 -- no smoke colour
        end

        --mark as active for refresh smoke logic to work
        -- change active to 1 / 0
        if _zone[3] == "yes" then
            _zone[3] = 1
        else
            _zone[3] = 0
        end
    end

    -- Sort out extractable groups
    for _, _groupName in pairs(ctld.extractableGroups) do

        local _group = Group.getByName(_groupName)

        if _group ~= nil then

            if _group:getCoalition() == 1 then
                table.insert(ctld.droppedTroopsRED, _group:getName())
            else
                table.insert(ctld.droppedTroopsBLUE, _group:getName())
            end
        end
    end


    -- Seperate troop teams into red and blue for random AI pickups
    if ctld.allowRandomAiTeamPickups == true then
        ctld.redTeams = {}
        ctld.blueTeams = {}
        for _, _loadGroup in pairs(ctld.loadableGroups) do
            if not _loadGroup.side then
                table.insert(ctld.redTeams, _)
                table.insert(ctld.blueTeams, _)
            elseif _loadGroup.side == 1 then
                table.insert(ctld.redTeams, _)
            elseif _loadGroup.side == 2 then
                table.insert(ctld.blueTeams, _)
            end
        end
    end

    -- add total count

    for _, _loadGroup in pairs(ctld.loadableGroups) do

        _loadGroup.total = 0
        if _loadGroup.aa then
            _loadGroup.total = _loadGroup.aa + _loadGroup.total
        end

        if _loadGroup.inf then
            _loadGroup.total = _loadGroup.inf + _loadGroup.total
        end

        if _loadGroup.mg then
            _loadGroup.total = _loadGroup.mg + _loadGroup.total
        end

        if _loadGroup.at then
            _loadGroup.total = _loadGroup.at + _loadGroup.total
        end

        if _loadGroup.mortar then
            _loadGroup.total = _loadGroup.mortar + _loadGroup.total
        end

    end


    -- Scheduled functions (run cyclically) -- but hold execution for a second so we can override parts

    --timer.scheduleFunction(ctld.checkAIStatus, nil, timer.getTime() + 1)
    timer.scheduleFunction(ctld.checkTransportStatus, nil, timer.getTime() + 10)

    timer.scheduleFunction(function()
        --timer.scheduleFunction(ctld.refreshRadioBeacons, nil, timer.getTime() + 5)
        timer.scheduleFunction(ctld.refreshSmoke, nil, timer.getTime() + 10)
        timer.scheduleFunction(ctld.addF10MenuOptions, nil, timer.getTime() + 30)

        if ctld.enableCrates == true and ctld.slingLoad == false and ctld.hoverPickup == true then
            timer.scheduleFunction(ctld.checkHoverStatus, nil, timer.getTime() + 1)
        end

    end, nil, timer.getTime() + 1)

    --event handler for deaths
    --world.addEventHandler(ctld.eventHandler)

    --ctld.logInfo("CTLD event handler added")


    ctld.logInfo("Generating Laser Codes")
    ctld.generateLaserCode()
    ctld.logInfo("Generated Laser Codes")

    ctld.logInfo("Generating UHF Frequencies")
    ctld.generateUHFrequencies()
    ctld.logInfo("Generated  UHF Frequencies")

    ctld.logInfo("Generating VHF Frequencies")
    ctld.generateVHFrequencies()
    ctld.logInfo("Generated VHF Frequencies")

    ctld.logInfo("Generating FM Frequencies")
    ctld.generateFMFrequencies()
    ctld.logInfo("Generated FM Frequencies")

    -- Search for crates
    -- Crates are NOT returned by coalition.getStaticObjects() for some reason
    -- Search for crates in the mission editor instead
    ctld.logInfo("Searching for Crates")
    for _coalitionName, _coalitionData in pairs(env.mission.coalition) do

        if (_coalitionName == 'red' or _coalitionName == 'blue')
                and type(_coalitionData) == 'table' then
            if _coalitionData.country then
                --there is a country table
                for _, _countryData in pairs(_coalitionData.country) do

                    if type(_countryData) == 'table' then
                        for _objectTypeName, _objectTypeData in pairs(_countryData) do
                            if _objectTypeName == "static" then

                                if ((type(_objectTypeData) == 'table')
                                        and _objectTypeData.group
                                        and (type(_objectTypeData.group) == 'table')
                                        and (#_objectTypeData.group > 0)) then

                                    for _groupId, _group in pairs(_objectTypeData.group) do
                                        if _group and _group.units and type(_group.units) == 'table' then
                                            for _unitNum, _unit in pairs(_group.units) do
                                                if _unit.canCargo == true then
                                                    local _cargoName = env.getValueDictByKey(_unit.name)
                                                    ctld.missionEditorCargoCrates[_cargoName] = _cargoName
                                                    ctld.logInfo("Crate Found: " .. _unit.name .. " - Unit: " .. _cargoName)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    ctld.logInfo("END search for crates")

    -- don't initialize more than once
    ctld.alreadyInitialized = true
    world.addEventHandler(AdditionalEventHandler)
    ctld.logInfo("CTLD READY")
end


-- initialize the random number generator to make it almost random
math.random();
math.random();
math.random()

--- Enable/Disable error boxes displayed on screen.
env.setErrorMessageBoxEnabled(false)

-- initialize CTLD in 2 seconds, so other scripts have a chance to modify the configuration before initialization
ctld.logInfo(string.format("Loading version %s in 2 seconds", ctld.Version))
timer.scheduleFunction(ctld.initialize, nil, timer.getTime() + 2)

--DEBUG FUNCTION
--        for key, value in pairs(getmetatable(_spawnedCrate)) do
--            ctld.logInfo(tostring(key))
--            ctld.logInfo(tostring(value))
--        end
