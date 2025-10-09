local net = require('net')
local lfs = require('lfs')
net.set_name('ThunderDCS')
local mpConfig = dofile(lfs.writedir()..'Config/serverSettings.lua')
if mpConfig and mpConfig.cfg then
  mpConfig.cfg["name"] = "：：：【TD动态战役】空地联合PvP现代战场：：："
end
local res = net.start_server(serverSettings)
if res ~= 0 then
  log.write('专用服务器', log.DEBUG, '无法以代码启动服务器:', res)
end