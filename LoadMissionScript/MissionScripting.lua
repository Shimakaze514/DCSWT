---Initialization script for the Mission lua Environment (SSE)
dofile("Scripts/ScriptingSystem.lua")


----------------------------------------------------任务环境脚本----------------------------------------------------
--dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Callbacks/Init.lua")
--dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceInit.lua")
dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceInit.lua")
--------------------------------------------------测试脚本从这里开始.-----------------------------------------------------
dofile(lfs.writedir() .. "Scripts/MissionFlanker/mist.lua")

dofile(lfs.writedir() .. "Scripts/MissionFlanker/CTLD.lua")

dofile(lfs.writedir() .. "Scripts/MissionFlanker/DynamicSave.lua")

dofile(lfs.writedir() .. "Scripts/MissionFlanker/NPV2.lua")

--dofile(lfs.writedir() .. 'Scripts/ServerData/init.lua')
--dofile(lfs.writedir() .. 'Scripts/ServerData/init.lua')





