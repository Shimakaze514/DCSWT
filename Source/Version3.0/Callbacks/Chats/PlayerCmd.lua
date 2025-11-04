local commands = {}

local commandFiles = {
  "h",
  "donatePoint",
  "tb"
}

for _, commandName in ipairs(commandFiles) do
  local command = dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Callbacks/Commands/Player/" .. commandName .. ".lua")
  commands[commandName] = command
  if command.aliases then
    for _, alias in ipairs(command.aliases) do
      commands[alias] = command
    end
  end
end

PlayerCmd = function(REXtext, playerID, ucid, name)
  local cmd = REXtext[1]
  
  if cmd == "help" or cmd == "h" then
    commands["h"].handle(REXtext, playerID, ucid, name)
  elseif cmd == "-donatePoint" then
    commands["donatePoint"].handle(REXtext, playerID, ucid, name)
  elseif cmd == "-tb" then
    commands["tb"].handle(REXtext, playerID, ucid, name)
  end
end