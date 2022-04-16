--Initialization script for the Mission lua Environment (SSE)
dofile("Scripts/ScriptingSystem.lua")
-- -- Add LuaSocket to the LUAPATH, so that it can be found.
-- package.path = package.path .. ';.\\LuaSocket\\?.lua;'
-- package.cpath = package.cpath .. ';.\\LuaSocket\\?.dll'
-- local socket = require('socket')
-- -- Connect to the debugger, first require it.
-- local initconnection = require('debugger')
-- -- Now make the connection..
-- -- "127.0.0.1" is the localhost.
-- -- 1000 is the timeout in ms on IP level.
-- -- "dcsserver" is the name of the server. Ensure the same name is used at the Debug Configuration panel!
-- -- nil (is for transport protocol, but not using this)
-- -- "win" don't touch. But is important to indicate that we are in a windows environment to the debugger script.
-- initconnection('127.0.0.1', 10000, 'dcsserver', nil, 'win', 'D:\\Office\\Java\\workspace\\DCS World')

-----------------------------------------------------清理任务脚本环境----------------------------------------------------
--Sanitize Mission Scripting environment
--This makes unavailable some unsecure functions.
--Mission downloaded from server to client may contain potentialy harmful lua code that may use these functions.
--You can remove the code below and make availble these functions at your own risk.

-- local function sanitizeModule(name)
--   _G[name] = nil
--   package.loaded[name] = nil
-- end
-- do
--   sanitizeModule('os')
--   sanitizeModule('io')
--   sanitizeModule('lfs')
--   sanitizeModule('debug') -- 恶意任务无法脱离沙盒并使用LuaSocket。
--   require = nil
--   loadlib = nil
-- end

----------------------------------------------------任务环境脚本----------------------------------------------------
dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceInit.lua")
--------------------------------------------------测试脚本从这里开始.-----------------------------------------------------
dofile(lfs.writedir() .. "Scripts/MissionFlanker/mist.lua")
dofile(lfs.writedir() .. "Scripts/MissionFlanker/CTLD.lua")
--dofile(lfs.writedir() .. "Scripts/MissionFlanker/DD.lua")
--dofile(lfs.writedir() .. "Scripts/MissionFlanker/CSAR.lua") --救援

do
  centerIsRed = false
  centerIsBlue = false
  center2IsRed = false
  center2IsBlue = false
  center3IsRed = false
  center3IsBlue = false
  center4IsRed = false
  center4IsBlue = false
  center5IsRed = false
  center5IsBlue = false
  center6IsRed = false
  center6IsBlue = false
  blueHasFront = false
  redHasFront = false
  --blueHasFront2 = false
  --redHasFront2 = false

  blueRefuel_1 = "Blue Refuel_1"
  blueRefuel_2 = "Blue Refuel_2"
  blueAWACS = "Blue AWACS"
  blueAWACS2 = "Blue KJ2000 #001"
  redRefuel_1 = "Red Refuel_1"
  redRefuel_2 = "Red Refuel_2"
  redAWACS = "Red AWACS"
  redAWACS2 = "Red KJ2000 #001"

  timeStartMissionF = 0
  AWACS_TankerRepawnTime = 14400
  timeStartBlueAWACS = 0
  timeStartRedAWACS = 0
  needrespawnAWACS = false

  function activateBlueCenterFlight()
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #002", 0)

    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Blue #002", 0)

    trigger.action.setUserFlag("苏呼米(中间) UH-1H Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) UH-1H Blue #002", 0)

    trigger.action.setUserFlag("苏呼米(中间) SA342Mistral Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) SA342L Blue #001", 0)
  end

  function activateRedCenterFlight()
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #002", 0)

    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Red #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Red #002", 0)

    trigger.action.setUserFlag("苏呼米(中间) UH-1H Red #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) UH-1H Red #002", 0)

    trigger.action.setUserFlag("苏呼米(中间) SA342Mistral Red #001", 0)
    trigger.action.setUserFlag("苏呼米(中间) SA342L Red #001", 0)
  end

  function activateBlueCenter2Flight()
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #003", 0)
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #004", 0)

    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Blue #003", 0)
    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Blue #004", 0)

    trigger.action.setUserFlag("科尔奇(中间) UH-1H Blue #003", 0)
    trigger.action.setUserFlag("科尔奇(中间) UH-1H Blue #004", 0)

    trigger.action.setUserFlag("科尔奇(中间) SA342Mistral Blue #001", 0)
    trigger.action.setUserFlag("科尔奇(中间) SA342L Blue #001", 0)
  end

  function activateRedCenter2Flight()
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #003", 0)
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #004", 0)

    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Red #003", 0)
    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Red #004", 0)

    trigger.action.setUserFlag("科尔奇(中间) UH-1H Red #003", 0)
    trigger.action.setUserFlag("科尔奇(中间) UH-1H Red #004", 0)

    trigger.action.setUserFlag("科尔奇(中间) SA342Mistral Red #001", 0)
    trigger.action.setUserFlag("科尔奇(中间) SA342L Red #001", 0)
  end

  function deactivateBlueCenterFlight()
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #002", 100)

    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Blue #002", 100)

    trigger.action.setUserFlag("苏呼米(中间) UH-1H Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) UH-1H Blue #002", 100)

    trigger.action.setUserFlag("苏呼米(中间) SA342Mistral Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) SA342L Blue #001", 100)
  end

  function deactivateRedCenterFlight()
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #002", 100)

    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Red #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) Mi-8MTV2 Red #002", 100)

    trigger.action.setUserFlag("苏呼米(中间) UH-1H Red #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) UH-1H Red #002", 100)

    trigger.action.setUserFlag("苏呼米(中间) SA342Mistral Red #001", 100)
    trigger.action.setUserFlag("苏呼米(中间) SA342L Red #001", 100)
  end

  function deactivateBlueCenter2Flight()
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #003", 100)
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #004", 100)

    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Blue #003", 100)
    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Blue #004", 100)

    trigger.action.setUserFlag("科尔奇(中间) UH-1H Blue #003", 100)
    trigger.action.setUserFlag("科尔奇(中间) UH-1H Blue #004", 100)

    trigger.action.setUserFlag("科尔奇(中间) SA342Mistral Blue #001", 100)
    trigger.action.setUserFlag("科尔奇(中间) SA342L Blue #001", 100)
  end

  function deactivateRedCenter2Flight()
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #003", 100)
    trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #004", 100)

    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Red #003", 100)
    trigger.action.setUserFlag("科尔奇(中间) Mi-8MTV2 Red #004", 100)

    trigger.action.setUserFlag("科尔奇(中间) UH-1H Red #003", 100)
    trigger.action.setUserFlag("科尔奇(中间) UH-1H Red #004", 100)

    trigger.action.setUserFlag("科尔奇(中间) SA342Mistral Red #001", 100)
    trigger.action.setUserFlag("科尔奇(中间) SA342L Red #001", 100)
  end

  function activateBlueCenter3Flight()
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #002", 0)
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #003", 0)
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #004", 0)

    trigger.action.setUserFlag("苏呼米(本场) Mi-8MTV2 Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(本场) Mi-8MTV2 Blue #002", 0)

    trigger.action.setUserFlag("苏呼米(本场) UH-1H Blue #001", 0)
    trigger.action.setUserFlag("苏呼米(本场) UH-1H Blue #002", 0)
  end

  function activateRedCenter3Flight()
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #001", 0)
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #002", 0)
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #003", 0)
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #004", 0)

    trigger.action.setUserFlag("科尔奇(本场) Mi-8MTV2 Red #001", 0)
    trigger.action.setUserFlag("科尔奇(本场) Mi-8MTV2 Red #002", 0)

    trigger.action.setUserFlag("科尔奇(本场) UH-1H Red #001", 0)
    trigger.action.setUserFlag("科尔奇(本场) UH-1H Red #002", 0)
  end

  function deactivateRedCenter3Flight()
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #001", 100)
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #002", 100)
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #003", 100)
    trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #004", 100)

    trigger.action.setUserFlag("科尔奇(本场) Mi-8MTV2 Red #001", 100)
    trigger.action.setUserFlag("科尔奇(本场) Mi-8MTV2 Red #002", 100)

    trigger.action.setUserFlag("科尔奇(本场) UH-1H Red #001", 100)
    trigger.action.setUserFlag("科尔奇(本场) UH-1H Red #002", 100)
  end

  function deactivateBlueCenter3Flight()
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #002", 100)
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #003", 100)
    trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #004", 100)

    trigger.action.setUserFlag("苏呼米(本场) Mi-8MTV2 Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(本场) Mi-8MTV2 Blue #002", 100)

    trigger.action.setUserFlag("苏呼米(本场) UH-1H Blue #001", 100)
    trigger.action.setUserFlag("苏呼米(本场) UH-1H Blue #002", 100)
  end

  function activateBlueFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) A-10C Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) A-10C Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) A-10C Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) A-10C Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) SA342M Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) SA342M Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) SA342M Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) SA342M Blue #004", 0)

    trigger.action.setUserFlag("主战区(前线) Su-25 Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25 Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #004", 0)
  end

  function activateRedFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) A-10C Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) A-10C Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) A-10C Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) A-10C Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) AJS37 Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) AJS37 Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) AJS37 Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) AJS37 Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) AV-8B Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) AV-8B Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) AV-8B Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) AV-8B Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) UH-1H Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) UH-1H Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) UH-1H Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) UH-1H Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) SA342M Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) SA342M Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) SA342M Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) SA342M Red #004", 0)

    trigger.action.setUserFlag("主战区(前线) Su-25 Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25 Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #004", 0)
  end

  function deactivateBlueFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) A-10C Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) A-10C Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) A-10C Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) A-10C Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) AJS37 Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) AV-8B Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) UH-1H Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) SA342M Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) SA342M Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) SA342M Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) SA342M Blue #004", 100)

    trigger.action.setUserFlag("主战区(前线) Su-25 Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25 Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Blue #004", 100)
  end

  function deactivateRedFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) A-10C Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) A-10C Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) A-10C Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) A-10C Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) AJS37 Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) AJS37 Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) AJS37 Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) AJS37 Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) AV-8B Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) AV-8B Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) AV-8B Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) AV-8B Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) F/A-18C Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) Ka-50 Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) Mi-8MTV2 Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) UH-1H Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) UH-1H Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) UH-1H Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) UH-1H Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) SA342M Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) SA342M Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) SA342M Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) SA342M Red #004", 100)

    trigger.action.setUserFlag("主战区(前线) Su-25 Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25 Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) Su-25T Red #004", 100)
  end

  function deactivateBlueFront3Flight()
    trigger.action.setUserFlag("主战区(本场) F/A-18C #001Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #002Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #003Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #004Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #005Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #006Blue", 100)

    trigger.action.setUserFlag("主战区(本场) F-14B #001Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F-14B #002Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F-14B #003Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F-14B #004Blue", 100)

    trigger.action.setUserFlag("主战区(本场) Su-33 #001Blue", 100)
    trigger.action.setUserFlag("主战区(本场) Su-33 #002Blue", 100)
  end

  function deactivateRedFront3Flight()
    trigger.action.setUserFlag("主战区(本场) F/A-18C #001Red", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #002Red", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #003Red", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #004Red", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #005BRed", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #006Red", 100)

    trigger.action.setUserFlag("主战区(本场) F-14B #001Red", 100)
    trigger.action.setUserFlag("主战区(本场) F-14B #002Red", 100)
    trigger.action.setUserFlag("主战区(本场) F-14B #003Red", 100)
    trigger.action.setUserFlag("主战区(本场) F-14B #004Red", 100)

    trigger.action.setUserFlag("主战区(本场) Su-33 #001Red", 100)
    trigger.action.setUserFlag("主战区(本场) Su-33 #002Red", 100)
  end

  function removeStaticObjF(Obj)
    if Obj then
      Obj:destroy()
    end
  end

  function missionScriptsInitFlanker()
    trigger.action.setUserFlag("Block", 100)

    timeStartMissionF = timer.getTime()
    timeStartBlueAWACS = timeStartMissionF
    timeStartRedAWACS = timeStartMissionF

    blueNoWeaponZoneF = trigger.misc.getZone("noWeaponBlueZone")
    redNoWeaponZoneF = trigger.misc.getZone("noWeaponRedZone")
    searchVolSBlueF = {
      id = world.VolumeType.SPHERE,
      params = {
        point = blueNoWeaponZoneF.point,
        radius = blueNoWeaponZoneF.radius
      }
    }
    searchVolSRedF = {
      id = world.VolumeType.SPHERE,
      params = {
        point = redNoWeaponZoneF.point,
        radius = redNoWeaponZoneF.radius
      }
    }

    logisticBlue1 = "logistic Blue #001"
    logisticBlue1S = "logistic Blue #001"

    logisticBlue2 = "logistic Blue #002"
    logisticBlue2S = "logistic Blue #002"
    removeStaticObjF(StaticObject.getByName(logisticBlue2))

    logisticBlue3 = "logistic Blue #003"
    logisticBlue3S = "logistic Blue #003"
    removeStaticObjF(StaticObject.getByName(logisticBlue3))

    logisticBlue4 = "logistic Blue #004"
    logisticBlue4S = "logistic Blue #004"
    removeStaticObjF(StaticObject.getByName(logisticBlue4))

    logisticBlue5 = "logistic Blue #005"
    logisticBlue5S = "logistic Blue #005"
    removeStaticObjF(StaticObject.getByName(logisticBlue5))

    logisticRed1 = "logistic Red #001"
    logisticRed1S = "logistic Red #001"

    logisticRed2 = "logistic Red #002"
    logisticRed2S = "logistic Red #002"
    removeStaticObjF(StaticObject.getByName(logisticRed2))

    logisticRed3 = "logistic Red #003"
    logisticRed3S = "logistic Red #003"
    removeStaticObjF(StaticObject.getByName(logisticRed3))

    logisticRed4 = "logistic Red #004"
    logisticRed4S = "logistic Red #004"
    removeStaticObjF(StaticObject.getByName(logisticRed4))

    logisticRed5 = "logistic Red #005"
    logisticRed5S = "logistic Red #005"
    removeStaticObjF(StaticObject.getByName(logisticRed5))

    deactivateBlueFrontFlight()
    deactivateRedFrontFlight()
    --deactivateBlueFront2Flight()
    --deactivateRedFront2Flight()
    deactivateBlueCenterFlight()
    deactivateRedCenterFlight()
    deactivateBlueCenter2Flight()
    deactivateRedCenter2Flight()
    deactivateBlueCenter3Flight()
    deactivateRedCenter3Flight()
  end

  function baseCaptureFlanker()
    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"科尔奇前线停机坪"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"科尔奇前线停机坪"})

    if center2IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      --trigger.action.setUserFlag(1, false)
      --trigger.action.setUserFlag(2, true)
      removeStaticObjF(StaticObject.getByName(logisticBlue5S))
      logisticBlue5S = mist.respawnGroup(logisticBlue5, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed5S))

      activateBlueCenter2Flight()
      deactivateRedCenter2Flight()

      center2IsBlue = true
      center2IsRed = false
      trigger.action.outText("蓝方已夺取科尔奇前线停机坪！", 30, false)

      mist.respawnGroup("Blue RearmCenter #002", true)
    elseif center2IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      --trigger.action.setUserFlag(1, true)
      --trigger.action.setUserFlag(2, false)
      removeStaticObjF(StaticObject.getByName(logisticRed5S))
      logisticRed5S = mist.respawnGroup(logisticRed5, false).name
      removeStaticObjF(StaticObject.getByName(logisticBlue5S))

      activateRedCenter2Flight()
      deactivateBlueCenter2Flight()

      center2IsRed = true
      center2IsBlue = false
      trigger.action.outText("红方已夺取科尔奇前线停机坪！", 30, false)

      mist.respawnGroup("Red RearmCenter #002", true)
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"苏呼米前线停机坪"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"苏呼米前线停机坪"})

    if centerIsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      --trigger.action.setUserFlag(1, false)
      --trigger.action.setUserFlag(2, true)
      removeStaticObjF(StaticObject.getByName(logisticBlue3S))
      logisticBlue3S = mist.respawnGroup(logisticBlue3, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed3S))

      activateBlueCenterFlight()
      deactivateRedCenterFlight()

      centerIsBlue = true
      centerIsRed = false
      trigger.action.outText("蓝方已夺取苏呼米前线停机坪！向前！向前！向前冲！", 30, false)

      mist.respawnGroup("Blue RearmCenter #001", true)
    elseif centerIsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      --trigger.action.setUserFlag(1, true)
      --trigger.action.setUserFlag(2, false)
      removeStaticObjF(StaticObject.getByName(logisticRed3S))
      logisticRed3S = mist.respawnGroup(logisticRed3, false).name
      removeStaticObjF(StaticObject.getByName(logisticBlue3S))

      activateRedCenterFlight()
      deactivateBlueCenterFlight()

      centerIsRed = true
      centerIsBlue = false
      trigger.action.outText("红方已夺取苏呼米前线停机坪！向前！向前！向前冲！", 30, false)

      mist.respawnGroup("Red RearmCenter #001", true)
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"苏呼米机场"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"苏呼米机场"})

    if center3IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      --trigger.action.setUserFlag(1, false)
      --trigger.action.setUserFlag(2, true)
      removeStaticObjF(StaticObject.getByName(logisticBlue4S))
      logisticBlue4S = mist.respawnGroup(logisticBlue4, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed2S))

      activateBlueCenter3Flight()
      deactivateRedFrontFlight()

      center3IsBlue = true
      center3IsRed = false
      trigger.action.outText("蓝方已夺取红方前线机场：苏呼米，同志们，为了胜利和荣耀，向古达乌塔冲锋！", 30, false)

      mist.respawnGroup("Blue RearmFront #001", true)
    elseif center3IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      --trigger.action.setUserFlag(1, true)
      --trigger.action.setUserFlag(2, false)
      removeStaticObjF(StaticObject.getByName(logisticRed2S))
      logisticRed2S = mist.respawnGroup(logisticRed2, false).name
      removeStaticObjF(StaticObject.getByName(logisticBlue4S))

      activateRedFrontFlight()
      deactivateBlueCenter3Flight()

      center3IsRed = true
      center3IsBlue = false
      trigger.action.outText("红方已拥有苏呼米机场！", 30, false)

      mist.respawnGroup("Red RearmFront #001", true)
      mist.respawnGroup("Red RearmFront #002", true)
      mist.respawnGroup("Red RearmFront #003", true)
      mist.respawnGroup("Red RearmFront #004", true)
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"科尔奇机场"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"科尔奇机场"})

    if center4IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue2S))
      logisticBlue2S = mist.respawnGroup(logisticBlue2, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed4S))

      activateBlueFrontFlight()
      deactivateRedCenter3Flight()

      center4IsBlue = true
      center4IsRed = false
      trigger.action.outText("蓝方已拥有其前线机场：塞纳基-科尔奇！！", 30, false)
    elseif center4IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed4S))
      logisticRed4S = mist.respawnGroup(logisticRed4, false).name
      removeStaticObjF(StaticObject.getByName(logisticBlue2S))

      activateRedCenter3Flight()
      deactivateBlueFrontFlight()

      center4IsRed = true
      center4IsBlue = false
      trigger.action.outText("红方已夺取蓝方前线机场：塞纳基-科尔奇，同志们，为了胜利和荣耀，向库塔伊西冲锋！", 30, false)

      mist.respawnGroup("Red RearmFront #005", true)
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"库塔伊西"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"库塔伊西"})

    if center5IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue1S))
      logisticBlue1S = mist.respawnGroup(logisticBlue1, false).name

      center5IsBlue = true
      center5IsRed = false
      trigger.action.outText("蓝方已开启全面联合战役！！！", 60, false)
    elseif center5IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue1S))

      deactivateBlueFront3Flight()

      center5IsRed = true
      center5IsBlue = false
      trigger.action.outText("红方已夺取全面胜利，感谢红方所有战斗人员的辛勤付出，加QQ群511466821,来感受联合战役的激情吧！请联系管理员重新开服", 1000, false)
    end

    local _CC1Blue = StaticObject.getByName(logisticBlue1S)
    if _CC1Blue ~= nil and _CC1Blue:getLife() <= 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue1S))
      logisticBlue1S = mist.respawnGroup(logisticBlue2, false).name
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"古达乌塔"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"古达乌塔"})

    if center6IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed1S))

      deactivateRedFront3Flight()

      center6IsBlue = true
      center6IsRed = false
      trigger.action.outText("蓝方已夺取全面胜利，感谢红方所有战斗人员的辛勤付出，加QQ群511466821,来感受联合战役的激情吧！请联系管理员重新开服", 1000, false)
    elseif center6IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed1S))
      logisticRed1S = mist.respawnGroup(logisticRed1, false).name

      center6IsRed = true
      center6IsBlue = false
      trigger.action.outText("红方已开启全面联合战役！！！", 60, false)
    end

    local _CC1Red = StaticObject.getByName(logisticRed1S)
    if _CC1Red ~= nil and _CC1Red:getLife() <= 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed1S))
      logisticRed1S = mist.respawnGroup(logisticRed2, false).name
    end
  end

  function respawnAWACSOnlyFlanker()
    local timeGoesAWACSBlue = timer.getTime() - timeStartBlueAWACS
    if timeGoesAWACSBlue > AWACS_TankerRepawnTime then
      blueAWACS = mist.respawnGroup(blueAWACS, true).name
      timeStartBlueAWACS = timer.getTime()
    end

    local timeGoesAWACSRed = timer.getTime() - timeStartRedAWACS
    if timeGoesAWACSRed > AWACS_TankerRepawnTime then
      redAWACS = mist.respawnGroup(redAWACS, true).name
      timeStartRedAWACS = timer.getTime()
    end

    local timeGoesAWACSBlue = timer.getTime() - timeStartBlueAWACS
    if timeGoesAWACSBlue > AWACS_TankerRepawnTime then
      blueAWACS2 = mist.respawnGroup(blueAWACS2, true).name
      timeStartBlueAWACS = timer.getTime()
    end

    local timeGoesAWACSRed = timer.getTime() - timeStartRedAWACS
    if timeGoesAWACSRed > AWACS_TankerRepawnTime then
      redAWACS2 = mist.respawnGroup(redAWACS2, true).name
      timeStartRedAWACS = timer.getTime()
    end

    local AWACSBlueGroup = Group.getByName(blueAWACS, blueAWACS2)
    if AWACSBlueGroup ~= nil then
      local AWACSBlue = AWACSBlueGroup:getUnits()
      if AWACSBlue[1] ~= nil and AWACSBlue[1]:getLife() > 0 and AWACSBlue[1]:getPoint().y < 5000 then
        timer.scheduleFunction(
          function(_args)
            local _unit = Unit.getByName(_args[1])
            if _unit ~= nil then
              _unit:destroy()
              timeStartRedAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
              trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
            end
          end,
          {AWACSBlue[1]:getName()},
          timer.getTime() + 60
        )

      --AWACSBlue[1]:destroy()
      --timeStartBlueAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
      --trigger.action.outText("蓝方预警机出现故障, 将在10分钟后重新上线", 20)
      end
    end

    local AWACSRedGroup = Group.getByName(redAWACS, redAWACS2)
    if AWACSRedGroup ~= nil then
      local AWACSRed = AWACSRedGroup:getUnits()
      if AWACSRed[1] ~= nil and AWACSRed[1]:getLife() > 0 and AWACSRed[1]:getPoint().y < 5000 then
        timer.scheduleFunction(
          function(_args)
            local _unit = Unit.getByName(_args[1])
            if _unit ~= nil then
              _unit:destroy()
              timeStartRedAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
              trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
            end
          end,
          {AWACSRed[1]:getName()},
          timer.getTime() + 60
        )

      --AWACSRed[1]:destroy()
      --timeStartRedAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
      --trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
      end
    end

    --[[if timeStartBlueAWACS
		if not waitingForRedAWACSRespawn then
			local AWACSRed = Group.getByName(redAWACS):getUnits()
			if AWACSRed[1] == nil or AWACSRed[1]:getLife() <= 0 or AWACSRed[1]:getPoint().y < 7000 then
				local fn = function()
					redAWACS = mist.respawnGroup(redAWACS, true).name
					waitingForRedAWACSRespawn = false
				end
				if AWACSRed[1] != nil and AWACSRed[1]:getLife() > 0 then
					--trigger.action.outTextForCoalition(1, "我方预警机将在3分钟后重新上线", 20)
					mist.scheduleFunction(fn, {}, timer.getTime() + 180)
					waitingForRedAWACSRespawn = true
				elseif AWACSRed[1] == nil or (AWACSRed[1] != nil and AWACSRed[1]:getLife() <= 0) then
					trigger.action.outTextForCoalition(1, "我方预警机将在30分钟后重新上线", 20)
					mist.scheduleFunction(fn, {}, timer.getTime() + 1800)
					waitingForRedAWACSRespawn = true
				end

			end
		end]]
    --
  end

  function respawnTankerFlanker()
    local timeGoes, _ = math.fmod((timer.getTime() - timeStartMissionF), AWACS_TankerRepawnTime)
    if timeGoes < 10 then
      if needrespawnTanker == false then
        needrespawnTanker = true

        blueRefuel_1 = mist.respawnGroup(blueRefuel_1, true).name
        blueRefuel_2 = mist.respawnGroup(blueRefuel_2, true).name
        blueAWACS = mist.respawnGroup(blueAWACS, true).name
        blueAWACS2 = mist.respawnGroup(blueAWACS2, true).name
        redRefuel_1 = mist.respawnGroup(redRefuel_1, true).name
        redRefuel_2 = mist.respawnGroup(redRefuel_2, true).name
        redAWACS = mist.respawnGroup(redAWACS, true).name
        redAWACS2 = mist.respawnGroup(redAWACS2, true).name
        trigger.action.outText("加油机和预警机梯队没油了，后续梯队正在交接！", 10)
      end
    else
      needrespawnTanker = false
    end
  end

  function ifFoundWeaponF(foundItem, val)
    local weapon = foundItem:getTypeName()
    --trigger.action.outText(weapon, 10)
    if weapon == "weapons.missiles.AGM_154" or weapon == "weapons.bombs.GBU_31" or weapon == "CM-802AKG" or weapon == "weapons.missiles.CM-802AKG" or weapon == "weapons.bombs.GBU_31_V_3B" or weapon == "weapons.bombs.GBU_38" or weapon == "weapons.missiles.LD-10" then
      trigger.action.explosion(foundItem:getPoint(), 100)
    --foundItem:destroy()
    end
    return true
  end

  function noWeaponZoneFlanker()
    world.searchObjects(Object.Category.WEAPON, searchVolSBlueF, ifFoundWeaponF)
    world.searchObjects(Object.Category.WEAPON, searchVolSRedF, ifFoundWeaponF)
  end

  function missionScriptsLoopFlanker()
    baseCaptureFlanker()
    respawnTankerFlanker()
    respawnAWACSOnlyFlanker()
    noWeaponZoneFlanker()

    mist.scheduleFunction(missionScriptsLoopFlanker, {}, timer.getTime() + 5)
  end

  function missionScheduleScripts5Min()
    --trigger.action.outText("大家注意: 由于目前AIM-54有严重的bug, 因此每个架次的F-14B被限制为最多只能携带4枚AIM-54C, 禁止携带AIM-54A, 否则无法起飞", 20)
    --trigger.action.outText("大家注意: 由于目前AIM-54有严重的bug, 因此每个架次的F-14B被限制为最多只能携带2枚AIM-54A_MK47, 禁止携带AIM-54A_MK60和AIM-54C, 否则无法起飞", 20)
    mist.scheduleFunction(missionScheduleScripts5Min, {}, timer.getTime() + 360)
  end

  function delayForLoadingFlanker()
    --sanitizeModule('os')
    --sanitizeModule('io')
    --sanitizeModule('lfs')
    --require = nil
    --loadlib = nil
    dofile(lfs.writedir() .. "Scripts/MissionFlanker/Moose.lua")
    dofile(lfs.writedir() .. "Scripts/MissionFlanker/SGS.lua")

    mist.scheduleFunction(missionScriptsInitFlanker, {}, timer.getTime() + 1)
    mist.scheduleFunction(missionScriptsLoopFlanker, {}, timer.getTime() + 5)
    --mist.scheduleFunction(missionScheduleScripts5Min, {}, timer.getTime() + 60)
  end

  mist.scheduleFunction(delayForLoadingFlanker, {}, timer.getTime() + 1)
end
