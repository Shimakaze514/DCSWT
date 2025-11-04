---Initialization script for the Mission lua Environment (SSE)
doofile('Scripts/ScriptingSystem.lua')

--启动测试环境，不知道的话勿动lse)
--dofile(lfs.writedir() .. 'Scripts/Debug/Mission/Init.lua')

--不要随意切换顺序
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