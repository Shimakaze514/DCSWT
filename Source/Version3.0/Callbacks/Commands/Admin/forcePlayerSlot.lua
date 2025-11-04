local function handle(args, playerID, ucid)
  if playerID == 1 or SourceCall.Admins[ucid] then
    if SourceCall.PlayerInfo[SourceCall.PlayerName[args[3]]]["id"] then
      net.force_player_slot(SourceCall.PlayerInfo[SourceCall.PlayerName[args[3]]]["id"], 0, "")
    end
  else
    Utils.admin_caveat(ucid, 100, playerID)
  end
end

return {
  handle = handle
}