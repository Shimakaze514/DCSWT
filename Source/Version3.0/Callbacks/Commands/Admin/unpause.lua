local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    SourceCall.pause_override = false
    SourceCall.pause_forced = false
    if DCS.getPause() then
      DCS.setPause(false)
    end
    net.send_chat_to("暂停已解除", playerID)
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}