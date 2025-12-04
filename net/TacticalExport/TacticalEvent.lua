local base = _G
tacticalExport = base.tacticalExport or {}

tacticalExport.eventHandler = tacticalExport.eventHandler or {}
tacticalExport.PlayerName = tacticalExport.PlayerName or {}

package.path  = package.path..";.\\LuaSocket\\?.lua;"
package.cpath = package.cpath..";.\\LuaSocket\\?.dll;"
local socket = require("socket")
local BACKEND_HOST = "localhost"
local BACKEND_PORT = 3002
-- local BACKEND_PATH = "/api/telemetry"

function tacticalExport.log(msg)
    local f = io.open(lfs.writedir().."Logs/TacticalExport.log","a")
    if f then
        f:write(os.date("%Y-%m-%d %H:%M:%S ") .. tostring(msg) .. "\n")
        f:close()
    end
end

local DICT_FILE_PATH = lfs.writedir() .. "Logs/WeaponDict.txt"

tacticalExport.loggedWeapons = {}

local function loadExistingDict()
    local f = io.open(DICT_FILE_PATH, "r")
    if f then
        tacticalExport.log("Loading existing weapon dictionary...")
        for line in f:lines() do
            local key = line:match("^'([^']+)'")
            if key then
                tacticalExport.loggedWeapons[key] = true
            end
        end
        f:close()
        tacticalExport.log("Dictionary loaded. Cached " .. 
            (table.count and table.count(tacticalExport.loggedWeapons) or "some") .. " weapons.")
    end
end

loadExistingDict()

function tacticalExport.registerWeapon(weaponObj)
    if not weaponObj or not weaponObj:isExist() then return end
    
    local typeName = weaponObj:getTypeName()
    if not typeName or typeName == "" then return end

    if tacticalExport.loggedWeapons[typeName] then return end

    local desc = weaponObj:getDesc()
    local displayName = desc.displayName or typeName
    local enumType = "WeaponType.GUN" -- 默认值

    if desc then
        -- 0:SHELL, 1:MISSILE, 2:ROCKET, 3:BOMB
        if desc.category == 2 then enumType = "WeaponType.ROCKET"
        elseif desc.category == 3 then enumType = "WeaponType.BOMB"
        elseif desc.category == 1 then
            local missCat = desc.missileCategory
            -- 1:AAM, 2:SAM, 3:BM, 4:ANTI_SHIP, 5:CRUISE, 6:OTHER
            if missCat == 1 then enumType = "WeaponType.AAM"
            elseif missCat == 2 then enumType = "WeaponType.SAM"
            elseif missCat == 3 then enumType = "WeaponType.SSM"
            elseif missCat == 4 then enumType = "WeaponType.AGM"
            elseif missCat == 5 then enumType = "WeaponType.AGM"
            elseif missCat == 6 then enumType = "WeaponType.AGM" 
            end
        end
    end

    local f = io.open(DICT_FILE_PATH, "a")
    if f then
        local safeName = displayName:gsub("'", "\\'")
        
        local line = string.format("'%s': { name: '%s', type: %s },\n", typeName, safeName, enumType)
        
        f:write(line)
        f:close()
        
        tacticalExport.loggedWeapons[typeName] = true
        tacticalExport.log("Exported NEW weapon: " .. typeName .. " [" .. enumType .. "]")
    else
        tacticalExport.log("Error: Could not open dictionary file for writing.")
    end
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
			-- payload.pilot = 'AI'
			-- if event.initiator.getTypeName then
			-- 	payload.airframe = event.initiator:getTypeName() or ''
			-- end
            return
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
        else
			local targetName = '' --Ground
			local targetType = '' --Ground
			payload.target = targetName
            payload.target_airframe = targetType
            --payload.targetId = unit:getID()
		-- elseif tgtCat == Object.Category.WEAPON then
		-- 	payload.target = event.target:getTypeName() or 'Weapon'
		-- elseif
		-- 	tgtCat == Object.Category.STATIC or tgtCat == Object.Category.CARGO or tgtCat == Object.Category.BASE or
		-- 		tgtCat == Object.Category.SCENERY
		--  then
		-- 	if event.target.getTypeName then
		-- 		payload.target = event.target:getTypeName() or 'Object'
		-- 	end
		end
	end

	if event.weapon and event.weapon.isExist and event.weapon:isExist() then 
        tacticalExport.log("Weapon category is: "..Object.getCategory(event.weapon))
        if Object.getCategory(event.weapon) == Object.Category.WEAPON then
            local weaponObj = event.weapon
            payload.weapon = event.weapon:getTypeName() or ''
            tacticalExport.registerWeapon(weaponObj)
        end
	elseif event.weapon_name then  --! this is typename!
		payload.weapon = (event.weapon_name ~= '' and event.weapon_name) or ''
	end

	sendJsonPayload(payload)
end

world.addEventHandler(tacticalExport.eventHandler)
