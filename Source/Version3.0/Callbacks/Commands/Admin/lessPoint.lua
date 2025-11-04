local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    if SourceCall.PlayerName[args[3]] then
      local fun_str = [[a_do_script('SourceObj.lessSourcePoint("]] .. SourceCall.PlayerName[args[3]] .. '",' .. args[4] .. [[')]]
      net.dostring_in("mission", fun_str)
      net.send_chat_to(string.format("%s资源点已减少%d点", args[3], args[4]), playerID)
    else
      net.send_chat_to("lessPoint:未找到该用户名相关的玩家", playerID)
    end
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}