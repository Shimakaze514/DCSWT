local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    local id = Utils.Is_include(args[3], SourceCall.Admins)
    if id then
      SourceCall.less_admins({name = args[3], ucid = id}, playerID)
    else
      net.send_chat_to("removeAdmin:未找到该用户名相关的玩家", playerID)
    end
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}