-- Auto-retart script from Asta, if any question, find me here: https://discord.gg/ZUZdMzQ
net.log("Begin script auto-restart server")

local SW = {}

function SW.onPlayerDisconnect(reason_msg, err_code)
    if DCS.getModelTime() > 28800 then -- Number of seconds
        local listPlayers = net.get_player_list()
        if #listPlayers == 1 then --1 because the dedicated server is also returned
            net.load_mission(DCS.getMissionFilename())
        end
    end
end

DCS.setUserCallbacks(SW)
 
net.log("End script auto-restart server")

-- put it here > C:\Users\yourNickname\Saved Games\DCS.openbeta\Scripts\Hooks