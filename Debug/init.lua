net.log('INFO: Lua调试器-->正在加载...')

local status, error =
  pcall(
  function()
    dofile(lfs.writedir() .. 'Scripts/Debug/Common/Config.lua')
    dofile(lfs.writedir() .. 'Scripts/Debug/Common/Tools.lua')
    dofile(lfs.writedir() .. 'Scripts/Debug/Common/Logger.lua')
    dofile(lfs.writedir() .. 'Scripts/Debug/TCP/Client.lua')
    dofile(lfs.writedir() .. 'Scripts/Debug/TCP/Server.lua')
    dofile(lfs.writedir() .. 'Scripts/Debug/Callbacks/TCP.lua')
  end
)
if (not status) then
  net.log(string.format('ERROR: Lua调试器加载失败:'), error)
else
  net.log('INFO: Lua调试器-->全部加载完毕...')
end
