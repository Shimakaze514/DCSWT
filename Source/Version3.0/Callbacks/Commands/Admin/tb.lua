local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    local targetName = table.concat(args, " ", 2)
    local targetUCID = SourceCall.PlayerName[targetName]
    if not targetUCID then
        net.send_chat_to("玩家UCID不存在: " .. targetName, playerID)
        return
    end
    local targetPlayerID = nil
    for id, info in pairs(SourceCall.clients) do
        if info.ucid == targetUCID then
          targetPlayerID = id
            break
        end
    end
    if not targetPlayerID then
        net.send_chat_to("玩家ID不存在: " .. targetUCID, playerID)
        return
    end
    SLOT.resetSideSwitch(targetPlayerID, targetUCID)
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}