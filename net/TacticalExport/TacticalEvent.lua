local base = _G
tacticalExport = base.tacticalExport or {}

tacticalExport.eventHandler = tacticalExport.eventHandler or {}
tacticalExport.PlayerName = tacticalExport.PlayerName or {}

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"
local socket = require("socket")
local BACKEND_HOST = "localhost"
local BACKEND_PORT = 3001
local BACKEND_PATH = "/api/telemetry"

function tacticalExport.log(msg)
    local f = io.open(lfs.writedir().."Logs/TacticalExport.log","a")
    if f then
        f:write(os.date("%Y-%m-%d %H:%M:%S ") .. tostring(msg) .. "\n")
        f:close()
    end
end

local function httpPost(json)
    local tcp = socket.tcp()
    tcp:settimeout(1)
    local ok, err = tcp:connect(BACKEND_HOST, BACKEND_PORT)
    if not ok then 
        tacticalExport.log("TCP connect fail: "..tostring(err))
        return 
    end

    local req =
        "POST "..BACKEND_PATH.." HTTP/1.1\r\n" ..
        "Host: "..BACKEND_HOST.."\r\n" ..
        "Content-Type: application/json\r\n" ..
        "Content-Length: "..#json.."\r\n" ..
        "Connection: close\r\n\r\n" ..
        json

    tcp:send(req)
    local resp = tcp:receive("*a")
    tcp:close()
end

local function sendJsonPayload(data)
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

local function getUnitTypeName(_unit)
    local typeName = _unit:getTypeName()
    if _unit.getDesc then
        local displayName = _unit:getDesc().displayName or "No Display Name!"
        tacticalExport.log("Unit Type: "..typeName..", DisplayName: "..displayName)
    end
    return typeName
end

function tacticalExport.eventHandler:onEvent(event)
	status, err = pcall(onMissionEvent, event)
	if not status then
		env.warning('Error during MissionStatistics:onEvent(): ' .. err)
	end
end

local event_by_id = {
    [world.event.S_EVENT_SHOT]  = "SHOT",
    [world.event.S_EVENT_ENGINE_STARTUP]  = "STARTUP",
    [world.event.S_EVENT_TOOK_CONTROL]  = "STARTUP",
    [world.event.S_EVENT_BIRTH]  = "BIRTH",
    [world.event.S_EVENT_PLAYER_LEAVE_UNIT]  = "DESLOT",
    [world.event.S_EVENT_KILL]  = "KILL",
}

function onMissionEvent(event)
	if event == nil then
		return
	end

	local eventType = event_by_id[event.id]
    if not eventType then return end

	local payload = {
		type = eventType,
		pilot = 'AI',
		ucid = nil,
		airframe = '',
		target = '',
		target_ucid = nil,
		target_airframe = '',
		weapon = '',
		location = ''
	}

    if eventType == "BIRTH" then
        if event.initiator and event.initiator.getPlayerName and event.initiator:getPlayerName() ~= nil and event.initiator:inAir() == true then
            payload.type = "TAKEOFF"
            payload.location = "Air"
        else return end
    end
	if event.initiator then
		local initCat = Object.getCategory(event.initiator)

		if initCat == Object.Category.UNIT then
			local unit = event.initiator
			payload.pilot = unit:getPlayerName() or 'AI'
			payload.airframe = getUnitTypeName(unit) or ''
            --payload.unitId = unit:getID()

			-- if unit.getPoint then
			-- 	local p = unit:getPoint()
			-- 	if p then
			-- 		payload.location = string.format('%.3f,%.3f,%.3f', p.x, p.y, p.z)
			-- 	end
			-- end

            if eventType == "STARTUP" then
                if unit:inAir() == true then
                    payload.type = "TAKEOFF"
                    payload.location = "Air"
                else return end
            end
            if eventType == "DESLOT" then
                if unit:inAir() == true then
                    payload.type = "DEATH"
                else return end
            end

		elseif initCat == Object.Category.WEAPON then
			payload.pilot = 'AI'
			payload.airframe = event.initiator:getTypeName() or ''
		else
			payload.pilot = 'AI'
			if event.initiator.getTypeName then
				payload.airframe = event.initiator:getTypeName() or ''
			end
		end
	end

	if event.target then
		local tgtCat = Object.getCategory(event.target)

		if tgtCat == Object.Category.UNIT then
			local unit = event.target
			local targetName = unit:getPlayerName() or 'AI'
			local targetType = getUnitTypeName(unit) or ''

			payload.target = targetName
            payload.target_airframe = targetType

            if event.initiator and Object.getCategory(event.initiator) == Object.Category.UNIT then 
                if event.initiator:getCoalition() == unit:getCoalition() then 
                    payload.type = "FRIENDLY_FIRE"
                end
            end
            --payload.targetId = unit:getID()
		elseif tgtCat == Object.Category.WEAPON then
			payload.target = event.target:getTypeName() or 'Weapon'
		elseif
			tgtCat == Object.Category.STATIC or tgtCat == Object.Category.CARGO or tgtCat == Object.Category.BASE or
				tgtCat == Object.Category.SCENERY
		 then
			if event.target.getTypeName then
				payload.target = event.target:getTypeName() or 'Object'
			end
		end
	end

	if event.weapon then
        tacticalExport.log("Weapon category is: "..Object.getCategory(event.weapon))
        if Object.getCategory(event.weapon) == Object.Category.WEAPON then
            local weaponObj = event.weapon
            payload.weapon = event.weapon:getTypeName() or 'Unknown Weapon' -- weaponObj:getDesc().displayName
            tacticalExport.log("Weapon TypeName: ".. payload.weapon .. ", DisplayName: ".. weaponObj:getDesc().displayName)
        end
	-- elseif event.weapon_name then
	-- 	payload.weapon = event.weapon_name ~= '' and event.weapon_name or 'Gun'
	end

	sendJsonPayload(payload)
end

world.addEventHandler(tacticalExport.eventHandler)
