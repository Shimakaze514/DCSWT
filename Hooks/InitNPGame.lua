local loadVersion = 'Version3.0'

--网络环境的加载和脚本Callbacks

dofile(lfs.writedir() .. 'Scripts/ServerData/init.lua')
dofile(lfs.writedir() .. 'Scripts/SlotAuth/SlotAuth.lua')
dofile(lfs.writedir() .. 'Scripts/Source/Version3.0/Callbacks/Init.lua')

--任务环境的加载和脚本
dofile(lfs.writedir() .. 'Scripts/LoadMissionScript/Config.lua')
