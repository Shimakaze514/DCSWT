-- Auto-retart script from Asta, if any question, find me here: https://discord.gg/ZUZdMzQ
net.log("[auto-restart] Begin script auto-restart server")

local SW = {}

function SW.onPlayerDisconnect(reason_msg, err_code)
    if DCS.getModelTime() > 21600 then -- Number of seconds
        net.log("[auto-restart] It's time! restarting if possible")
        net.load_mission(DCS.getMissionFilename())
        -- local listPlayers = net.get_player_list()
        -- if #listPlayers <= 2 then --1 because the dedicated server is also returned
        --     net.load_mission(DCS.getMissionFilename())
        -- end
    end
end

DCS.setUserCallbacks(SW)
 
net.log("[auto-restart] End script auto-restart server")

-- put it here > C:\Users\yourNickname\Saved Games\DCS.openbeta\Scripts\Hooks