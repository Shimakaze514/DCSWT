local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    SourceCall.pause_override = true
    if not DCS.getPause() then
      DCS.setPause(true)
    end
    net.send_chat_to("已暂停", playerID)
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}