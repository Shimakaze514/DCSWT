--[[
    NP Configuration Data
    Loaded before NPV2.lua. Defines all static data tables used by the NP system.
    To add a new zone type: add an entry to NP.LevelConfigs and update NP.detectZoneType in NPV2.lua.
    To change coalition vehicles: edit NP.CoalitionConfig.
]]

NP = {}

NP.Id           = "NP - "
NP.Version      = "20220417"
NP.RefreshTime  = 10
NP.CaptureDistance = 200

-- Maps numeric DCS coalition side to string identifier used throughout the system.
NP.SideToStr = { [1] = "red", [2] = "blue" }

NP.AWACSList = {
    "blueAWACS",
    "blueAWACS-1",
    "blueAWACS-2",
    "blueAWACS-3",
    "redAWACS",
    "redAWACS2",
    "redAWACS-1",
    "redAWACS2-1",
}

-- NP.CoalitionConfig is defined in NPV2.lua because it references DCS runtime
-- values (country.id.*) that are safest to evaluate inside function scope.

--[[
    Defense unit configurations keyed by zone type and then by level (integer 1–3).
    NP.LevelConfigs[zoneType][level] = array of defense group definitions.

    Each definition:
      type    - string or array of strings (unit type names; cycled per unit if array)
      radius  - spawn radius from CC center (meters)
      count   - number of launcher/main units in this group
      suffix  - appended to the CC name to form the DCS group name (e.g. "_中程防空")
      support - array of support unit defs, each: { type, count, offset = {x, y} }
                support units spawn beside unit #1 of each group
]]
NP.LevelConfigs = {

    Home = {
        [1] = {
            { type = {"Tor 9A331"},                        radius = 2000, count = 4, suffix = "_中程防空",      support = {} },
            { type = {"CHAP_PantsirS1", "2S6 Tunguska"},  radius = 2500, count = 4, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger", "Strela-10M3"},    radius = 2500, count = 6, suffix = "_近程防空(红外)", support = {} },
            { type = "Hawk ln",                            radius = 1000, count = 6, suffix = "_远程防空(霍克)",
                support = {
                    { type = "Hawk tr",   count = 1, offset = {x =  100, y =  50} },
                    { type = "Hawk pcp",  count = 1, offset = {x =   50, y =   0} },
                    { type = "Hawk sr",   count = 1, offset = {x =  -50, y =   0} },
                    { type = "Hawk cwar", count = 1, offset = {x =  -50, y =  50} },
                    { type = "Hawk tr",   count = 1, offset = {x =  -50, y = -50} },
                    { type = "Hawk tr",   count = 1, offset = {x = -100, y = -50} },
                } },
            { type = {"M-2 Bradley", "ZBD04A", "Leclerc"}, radius = 1250, count = 5, suffix = "_坦克", support = {} },
        },
        [2] = {
            { type = {"HEMTT_C-RAM_Phalanx"},              radius =   80, count = 1, suffix = "_近防",          support = {} },
            { type = {"Tor 9A331", "CHAP_TorM2"},          radius = 2000, count = 6, suffix = "_中程防空",      support = {} },
            { type = {"CHAP_PantsirS1", "2S6 Tunguska"},  radius = 2500, count = 4, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger", "Strela-10M3"},    radius = 2500, count = 6, suffix = "_近程防空(红外)", support = {} },
            { type = "Hawk ln",                            radius = 1000, count = 6, suffix = "_远程防空(霍克)",
                support = {
                    { type = "Hawk tr",   count = 1, offset = {x =  100, y =  50} },
                    { type = "Hawk pcp",  count = 1, offset = {x =   50, y =   0} },
                    { type = "Hawk sr",   count = 1, offset = {x =  -50, y =   0} },
                    { type = "Hawk cwar", count = 1, offset = {x =  -50, y =  50} },
                    { type = "Hawk tr",   count = 1, offset = {x =  -50, y = -50} },
                    { type = "Hawk tr",   count = 1, offset = {x = -100, y = -50} },
                } },
            { type = {"ZBD04A", "Leclerc"},                radius = 1250, count = 5, suffix = "_坦克", support = {} },
        },
        [3] = {
            { type = {"HEMTT_C-RAM_Phalanx"},              radius =   80, count = 2, suffix = "_近防",          support = {} },
            { type = {"Tor 9A331", "CHAP_TorM2"},          radius = 2000, count = 8, suffix = "_中程防空",      support = {} },
            { type = {"CHAP_PantsirS1", "2S6 Tunguska"},  radius = 2500, count = 6, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger", "Strela-10M3"},    radius = 2500, count = 9, suffix = "_近程防空(红外)", support = {} },
            { type = "SA-11 Buk LN 9A310M1",              radius = 1000, count = 6, suffix = "_远程防空(山毛榉)",
                support = {
                    { type = "SA-11 Buk SR 9S18M1",  count = 1, offset = {x =  50, y = 0} },
                    { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} },
                } },
            { type = "SA-11 Buk LN 9A310M1",              radius = 1500, count = 6, suffix = "_远程防空(山毛榉)2",
                support = {
                    { type = "SA-11 Buk SR 9S18M1",  count = 1, offset = {x =  50, y = 0} },
                    { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} },
                } },
            { type = {"Leclerc", "ZBD04A"},                radius = 1250, count = 6, suffix = "_坦克", support = {} },
        },
    },

    Front = {
        [1] = {
            { type = {"Tor 9A331"},                              radius = 1500, count = 4, suffix = "_中程防空",      support = {} },
            { type = "Hawk ln",                                  radius = 1000, count = 6, suffix = "_远程防空(霍克)",
                support = {
                    { type = "Hawk tr",   count = 1, offset = {x =  100, y =  50} },
                    { type = "Hawk pcp",  count = 1, offset = {x =   50, y =   0} },
                    { type = "Hawk sr",   count = 1, offset = {x =  -50, y =   0} },
                    { type = "Hawk cwar", count = 1, offset = {x =  -50, y =  50} },
                    { type = "Hawk tr",   count = 1, offset = {x =  -50, y = -50} },
                    { type = "Hawk tr",   count = 1, offset = {x = -100, y = -50} },
                } },
            { type = {"2S6 Tunguska"},                           radius = 2000, count = 3, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger", "Strela-10M3"},          radius = 2000, count = 5, suffix = "_近程防空(红外)", support = {} },
            { type = {"Vulcan", "M-2 Bradley", "ZBD04A"},       radius = 1000, count = 5, suffix = "_坦克",          support = {} },
        },
        [2] = {
            { type = {"HEMTT_C-RAM_Phalanx"},                    radius =   80, count = 1, suffix = "_近防",          support = {} },
            { type = "Hawk ln",                                  radius = 1000, count = 6, suffix = "_远程防空(霍克)",
                support = {
                    { type = "Hawk tr",   count = 1, offset = {x =  100, y =  50} },
                    { type = "Hawk pcp",  count = 1, offset = {x =   50, y =   0} },
                    { type = "Hawk sr",   count = 1, offset = {x =  -50, y =   0} },
                    { type = "Hawk cwar", count = 1, offset = {x =  -50, y =  50} },
                    { type = "Hawk tr",   count = 1, offset = {x =  -50, y = -50} },
                    { type = "Hawk tr",   count = 1, offset = {x = -100, y = -50} },
                } },
            { type = {"Tor 9A331", "CHAP_TorM2"},               radius = 1500, count = 4, suffix = "_中程防空",      support = {} },
            { type = {"2S6 Tunguska", "CHAP_PantsirS1"},        radius = 2000, count = 3, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger", "Strela-10M3"},          radius = 2000, count = 5, suffix = "_近程防空(红外)", support = {} },
            { type = {"M-2 Bradley", "ZBD04A", "Leclerc"},      radius = 1000, count = 5, suffix = "_坦克",          support = {} },
        },
        [3] = {
            { type = {"HEMTT_C-RAM_Phalanx"},                    radius =   80, count = 2, suffix = "_近防",          support = {} },
            { type = "SA-11 Buk LN 9A310M1",                    radius = 1000, count = 3, suffix = "_远程防空(山毛榉)",
                support = {
                    { type = "SA-11 Buk SR 9S18M1",  count = 1, offset = {x =  50, y = 0} },
                    { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} },
                } },
            { type = "SA-11 Buk LN 9A310M1",                    radius = 1300, count = 3, suffix = "_远程防空(山毛榉)2",
                support = {
                    { type = "SA-11 Buk SR 9S18M1",  count = 1, offset = {x =  50, y = 0} },
                    { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} },
                } },
            { type = {"Tor 9A331", "CHAP_TorM2"},               radius = 1500, count = 6, suffix = "_中程防空",      support = {} },
            { type = {"2S6 Tunguska", "CHAP_PantsirS1"},        radius = 2000, count = 4, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger", "Strela-10M3"},          radius = 2000, count = 6, suffix = "_近程防空(红外)", support = {} },
            { type = {"ZBD04A", "Leclerc"},                      radius = 1000, count = 5, suffix = "_坦克",          support = {} },
        },
    },

    Middle = {
        [1] = {
            { type = {"2S6 Tunguska"},  radius = 1100, count = 2, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger"}, radius = 1200, count = 2, suffix = "_近程防空(红外)", support = {} },
            { type = {"Vulcan"},        radius = 1050, count = 2, suffix = "_机炮",           support = {} },
            { type = {"M-2 Bradley"},   radius =  500, count = 3, suffix = "_坦克",           support = {} },
        },
        [2] = {
            { type = {"HEMTT_C-RAM_Phalanx"},          radius =   80, count = 1, suffix = "_近防",          support = {} },
            { type = {"Tor 9A331"},                    radius =  100, count = 2, suffix = "_中程防空",      support = {} },
            { type = {"2S6 Tunguska"},                 radius = 1100, count = 2, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger"},                radius = 1200, count = 2, suffix = "_近程防空(红外)", support = {} },
            { type = {"Vulcan"},                       radius = 1050, count = 2, suffix = "_机炮",           support = {} },
            { type = {"M-2 Bradley"},                  radius =  500, count = 3, suffix = "_坦克",           support = {} },
            { type = {"M1A2C_SEP_V3"},                 radius =  500, count = 1, suffix = "_坦克2",          support = {} },
        },
        [3] = {
            { type = {"HEMTT_C-RAM_Phalanx"},          radius =   80, count = 2, suffix = "_近防",          support = {} },
            { type = {"Tor 9A331", "CHAP_TorM2"},      radius =  100, count = 3, suffix = "_中程防空",      support = {} },
            { type = {"2S6 Tunguska"},                 radius = 1100, count = 3, suffix = "_近程防空(雷达)", support = {} },
            { type = {"M1097 Avenger"},                radius = 1200, count = 3, suffix = "_近程防空(红外)", support = {} },
            { type = {"Vulcan"},                       radius = 1050, count = 3, suffix = "_机炮",           support = {} },
            { type = {"M-2 Bradley", "M1A2C_SEP_V3"}, radius =  500, count = 5, suffix = "_坦克",           support = {} },
        },
    },
}

net.log("LOAD - NP Config version " .. NP.Version)
