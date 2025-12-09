local base  	= _G
-- register dcsbot in the global scope
base.tacticalExport = {}

tacticalExport = base.tacticalExport

tacticalExport.PlayerName = tacticalExport.PlayerName or {}
tacticalExport.PlayerId = tacticalExport.PlayerId or {}
--------------------------------------------------------------------
-- HTTP sender (socket.tcp)
--------------------------------------------------------------------
local socket = require("socket")
local BACKEND_HOST = "stats.insky.cn"
local BACKEND_PORT = 3002
-- local BACKEND_PATH = "/api/telemetry"

function tacticalExport.log(msg)
    local f = io.open(lfs.writedir().."Logs/TacticalExport.log","a")
    if f then
        f:write(os.date("%Y-%m-%d %H:%M:%S ") .. tostring(msg) .. "\n")
        f:close()
    end
end

function receiveEvent(json)
    httpPost(json)
end

local udp = socket.udp()
udp:settimeout(0)
udp:setpeername(BACKEND_HOST, BACKEND_PORT)
local function httpPost(json)
    -- local tcp = socket.tcp()
    -- tcp:settimeout(1)
    -- local ok, err = tcp:connect(BACKEND_HOST, BACKEND_PORT)
    -- if not ok then 
    --     tacticalExport.log("TCP connect fail: "..tostring(err))
    --     return 
    -- end

    -- local req =
    --     "POST "..BACKEND_PATH.." HTTP/1.1\r\n" ..
    --     "Host: "..BACKEND_HOST.."\r\n" ..
    --     "Content-Type: application/json\r\n" ..
    --     "Content-Length: "..#json.."\r\n" ..
    --     "Connection: close\r\n\r\n" ..
    --     json

    -- tcp:send(req)
    -- --local resp = tcp:receive("*a")
    -- tcp:close()
    udp:send(json)
end

--------------------------------------------------------------------
-- Helper: JSON Builder with Schema Enforcement
--------------------------------------------------------------------
function sendJsonPayload(data)
    -- Define the strict schema required by INSERT INTO events_v2
    -- Default values are empty strings or "Unknown" to prevent SQL errors on missing keys
    if not data.ucid then
        data.ucid = tacticalExport.PlayerName[data.pilot] or ""
    end
    if not data.target_ucid then
        data.target_ucid = tacticalExport.PlayerName[data.target] or ""
    end

    local finalPayload = {
        type            = data.type             or "UNKNOWN EVENT",
        pilot           = data.pilot            or "AI",
        ucid            = data.ucid             or "",
        airframe        = data.airframe         or "",
        target          = data.target           or "",
        target_ucid     = data.target_ucid      or "",
        target_airframe = data.target_airframe  or "",
        weapon          = data.weapon           or "",
        location        = data.location         or ""
    }

    local json = "{"
    local first = true
    -- Iterate specifically over the defined keys to ensure order and presence (though pairs order isn't guaranteed in Lua)
    -- We use a list to ensure we process all keys we want
    local keys = {"type", "pilot", "ucid", "airframe", "target", "target_ucid", "target_airframe", "weapon", "location"}
    
    for _, k in ipairs(keys) do
        if not first then json = json .. ", " end
        local val = tostring(finalPayload[k]):gsub('"', '\\"') -- Escape quotes
        json = json .. '"' .. k .. '": "' .. val .. '"'
        first = false
    end
    json = json .. "}"
    
    tacticalExport.log("Event Payload: " .. json)
    httpPost(json)
end

--------------------------------------------------------------------
-- Helper: Get Player Info
--------------------------------------------------------------------
local function getPlayerName(id)
    return net.get_player_info(id, "name") or "AI"
end

local function getPlayerUCID(id)
    return net.get_player_info(id, "ucid") or ""
end

--------------------------------------------------------------------
-- Helper: Cross-Environment Unit Lookup
--------------------------------------------------------------------
local function getUnitTypeName(playerID)
    if not playerID then return "Unknown" end
    local typeName = DCS.getUnitProperty(
        net.get_player_info(playerID, "slot"),
        DCS.UNIT_TYPE)
    if not typeName then 
        tacticalExport.log("Failed to get typeName")
    end
    return typeName
end

--------------------------------------------------------------------
-- Player connect/disconnect
--------------------------------------------------------------------
function tacticalExport.onPlayerConnect(id)
    sendJsonPayload({
        type = "CONNECT",
        pilot = getPlayerName(id),
        ucid = getPlayerUCID(id),
        -- location, weapon, target etc will default to "" via sendJsonPayload
    })
end

function tacticalExport.onPlayerStart(id)
    local name = getPlayerName(id)
    local ucid = getPlayerUCID(id)
    tacticalExport.PlayerId[id] = name
    tacticalExport.PlayerName[name] = ucid
    local fun_str = string.format(
        [=[a_do_script('tacticalExport.PlayerName[%q] = %q')]=], 
        name, 
        ucid)
    net.dostring_in("mission", fun_str)
end


function tacticalExport.onPlayerDisconnect(id, err)
    local _pilot = tacticalExport.PlayerId[id]
    local _ucid = tacticalExport.PlayerName[_pilot]
    sendJsonPayload({
        type = "DISCONNECT",
        pilot = _pilot,
        ucid = _ucid,
    })
    if tacticalExport.PlayerName[_pilot] == _ucid then
        tacticalExport.PlayerName[_pilot] = nil
        local fun_str = string.format(
            [=[a_do_script('tacticalExport.PlayerName[%q] = nil')]=], 
            _pilot)
        net.dostring_in("mission", fun_str)
    end
end

--------------------------------------------------------------------
-- Game Event Handler
--------------------------------------------------------------------
function tacticalExport.onGameEvent(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    
    if not eventName then return end

    local payload = {}
    local shouldSend = false

    -- Base Info (Initiator)
    payload.pilot = getPlayerName(arg1)
    payload.ucid = getPlayerUCID(arg1)
    
    -- Side helper
    local side = 0
    if arg1 and arg1 ~= 0 then
        side = net.get_player_info(arg1, "side")
    end

    -------------------------------------------------------
    -- EVENT: KILL
    -------------------------------------------------------
    -- if eventName == "kill" then
    --     shouldSend = true
    --     payload.type = "KILL"
    --     tacticalExport.log("KILLER TYPE IS: "..arg2)
    --     payload.airframe = arg2 or getUnitTypeName(arg1)
        
    --     -- Victim Info
    --     local victimName = getPlayerName(arg4)
    --     local victimType = arg5 or getUnitTypeName(arg4)
    --     payload.target = victimName
    --     payload.target_airframe = victimType
    --     payload.target_ucid = getPlayerUCID(arg4)
        
    --     -- Weapon
    --     payload.weapon = arg7 or "Unknown"

    -------------------------------------------------------
    -- EVENT: FRIENDLY FIRE
    -------------------------------------------------------
    -- elseif eventName == "friendly_fire" then
    --     shouldSend = true
    --     payload.type = "FRIENDLY_FIRE"
    --     payload.airframe = getUnitTypeName(arg1)
        
    --     -- Victim Info
    --     -- arg3: victimID
    --     payload.target = getPlayerName(arg3)
    --     payload.target_ucid = getPlayerUCID(arg3)
        
    --     -- arg2: weaponName
    --     payload.weapon = arg2

    -------------------------------------------------------
    -- EVENTS: TAKEOFF / LANDING
    -------------------------------------------------------
    if eventName == "takeoff" then
        shouldSend = true
        payload.type = "TAKEOFF"
        payload.airframe = getUnitTypeName(arg1)
        payload.location = arg3

    elseif eventName == "landing" then
        shouldSend = true
        payload.type = "LANDING"
        payload.airframe = getUnitTypeName(arg1)
        payload.location = arg3

    -------------------------------------------------------
    -- EVENTS: CRASH / EJECT / PILOT_DEAD
    -------------------------------------------------------
    elseif eventName == "crash" then
        shouldSend = true
        payload.type = "CRASH"
        payload.airframe = getUnitTypeName(arg1)

    elseif eventName == "eject" then
        shouldSend = true
        payload.type = "EJECTION"
        payload.airframe = getUnitTypeName(arg1)

    elseif eventName == "pilot_death" then
        shouldSend = true
        payload.type = "PILOT_DEAD"
        payload.airframe = getUnitTypeName(arg1)
    
    -------------------------------------------------------
    -- EVENT: MISSION END
    -------------------------------------------------------
    elseif eventName == "mission_end" then
        shouldSend = true
        payload.type = "MISSION_END"
    end

    if shouldSend then
        sendJsonPayload(payload)
    end
end

DCS.setUserCallbacks(tacticalExport)
tacticalExport.log("TacticalExport Hooks Loaded - DB Schema Ready (v2)")