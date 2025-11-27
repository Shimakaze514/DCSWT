---Initialization script for the Mission lua Environment (SSE)
dofile('Scripts/ScriptingSystem.lua')
--不要随意切换顺序
dofile(lfs.writedir().."Scripts\\net\\TacticalExport\\TacticalEvent.lua")
local settingsPath = lfs.writedir() .. "Config\\serverSettings.lua"
dofile(settingsPath)
local serverName = cfg and cfg.name
if serverName then
    env.info("Server name is: " .. serverName)
else
    env.info("Unable to read server name")
end
if string.find(serverName, "TD动态战役", 1, true) then
    env.info("Loading TD env")
    dofile(lfs.writedir() .. 'Scripts/Mission/Libs/mist.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Libs/CTLD.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Core/DynamicSave.lua')
    dofile(lfs.writedir() .. 'Scripts/StaticDataBase/UnitsList.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Core/NPV2.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Modules/NPCSAR.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Modules/Bomber.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Modules/AddEXPL.lua')
    dofile(lfs.writedir() .. 'Scripts/Source/Version3.0/Mission/SourceInit.lua')
    dofile(lfs.writedir() .. 'Scripts/Mission/Modules/SweepDebris.lua')
    env.info("Loaded TD env")
end