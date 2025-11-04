local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    if SourceCall.PlayerName[args[3]] then
      SourceCall.add_admins({name = args[3], ucid = SourceCall.PlayerName[args[3]]}, playerID)
    else
      net.send_chat_to("addAdmin:未找到该用户名相关的玩家", playerID)
    end
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}