local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    local fun_str = [[a_do_script('SourceObj.lessSourceTeamPoint("]] .. args[3] .. '",' .. args[4] .. [[')]]
    net.dostring_in("mission", fun_str)
    net.send_chat_to(string.format("蓝方资源点已减少%d点", args[4]), playerID)
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}