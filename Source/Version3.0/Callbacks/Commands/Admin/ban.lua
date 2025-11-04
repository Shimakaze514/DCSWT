local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    if SourceCall.PlayerName[args[3]] then
      SourceCall.BannedClients[args[3]] = {
        ipaddr = SourceCall.PlayerInfo[SourceCall.PlayerName[args[3]]]["ipaddr"],
        ucid = SourceCall.PlayerInfo[SourceCall.PlayerName[args[3]]]["ucid"]
      }
      if args[4] then
        SourceCall.BannedClients[args[3]].reason = args[4]
        FileData.SaveData(SourceCall.BannedClientsFile, net.lua2json(SourceCall.BannedClients))
        net.kick(SourceCall.PlayerInfo[SourceCall.PlayerName[args[3]]]["id"], args[4])
      else
        FileData.SaveData(SourceCall.BannedClientsFile, net.lua2json(SourceCall.BannedClients))
        net.kick(SourceCall.PlayerInfo[SourceCall.PlayerName[args[3]]]["id"])
      end
      net.send_chat_to("玩家:" .. args[3] .. "已被封禁", playerID)
    else
      net.send_chat_to("ban:未找到该用户名相关的玩家", playerID)
    end
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}