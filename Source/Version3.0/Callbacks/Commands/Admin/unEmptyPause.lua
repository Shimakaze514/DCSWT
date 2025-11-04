local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    SourceCall.pause_when_empty = false
    net.send_chat_to("已禁用空时服务器将自动暂停.", playerID)
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}