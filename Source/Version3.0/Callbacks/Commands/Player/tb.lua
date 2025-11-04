local function handle(args, playerID, ucid)
  SLOT.resetSideSwitch(playerID, ucid)
end

return {
  handle = handle
}