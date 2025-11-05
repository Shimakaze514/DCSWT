local commands = {}

local commandFiles = {
  "h",
  "addAdmin",
  "removeAdmin",
  "addPoint",
  "lessPoint",
  "ban",
  "unban",
  "pause",
  "unpause",
  "emptyPause",
  "unEmptyPause",
  "forcePlayerSlot",
  "addTeamPoint",
  "lessTeamPoint",
  "tb"
}

for _, commandName in ipairs(commandFiles) do
  local command = dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Callbacks/Commands/Admin/" .. commandName .. ".lua")
  commands[commandName] = command
  if command.aliases then
    for _, alias in ipairs(command.aliases) do
      commands[alias] = command
    end
  end
end

AdminCmd = function(REXtext, playerID, ucid, name)
  local commandName = REXtext[2]
  if REXtext[1] == "-admin" then
    if commands[commandName] then
      commands[commandName].handle(REXtext, playerID, ucid, name)
      return true
    end
  elseif REXtext[1] == "-tb" then
    if commands["tb"] then
      commands["tb"].handle(REXtext, playerID, ucid, name)
      return true
    end
  end
end