net.set_name('ThunderDCS')
local res = net.start_server(serverSettings)
if res ~= 0 then
  log.write('专用服务器', log.DEBUG, '无法以代码启动服务器:', res)
end