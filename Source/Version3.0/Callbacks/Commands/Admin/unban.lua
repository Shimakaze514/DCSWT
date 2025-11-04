local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    if SourceCall.BannedClients[args[3]] then
      SourceCall.BannedClients[args[3]] = nil
      FileData.SaveData(SourceCall.BannedClientsFile, net.lua2json(SourceCall.BannedClients))
      net.send_chat_to("玩家:" .. args[3] .. "已解封", playerID)
    else
      net.send_chat_to("unban:未找到该用户名相关的玩家", playerID)
    end
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}