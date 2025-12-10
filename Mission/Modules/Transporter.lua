Transporter = {}
Transporter.ActiveRequests = {}
Transporter.ActiveGroups = {} 
Transporter.Debug = false
Transporter.Trace = false
Transporter.UpgradeCrates = {} -- Track our crates: [crateName] = true

-- Config
Transporter.CostTable = {
    ["Deploy"] = 300,
    ["Upgrade"] = 800,
}

Transporter.TemplateTable = {
    ["Deploy"] = "TransportDeployTemplate",
    ["Upgrade"] = "TransportUpgradeTemplate",
}

Transporter.MaxCount = {
    ["Deploy"] = 5,
    ["Upgrade"] = 5,
}

Transporter.UpgradeRadius = 1000
Transporter.UpgradeTime = 600

Transporter.DeployUnits = {
    Blue = {
        { type = "M 818", xOffset = 0, yOffset = 0 },
        { type = "Soldier M4", xOffset = 10, yOffset = 10 },
        { type = "Soldier M4", xOffset = -10, yOffset = 10 },
        { type = "Soldier M4", xOffset = 10, yOffset = -10 },
        { type = "Soldier M4", xOffset = -10, yOffset = -10 },
    },
    Red = {
        { type = "KRAZ6322", xOffset = 0, yOffset = 0 },
        { type = "Infantry AK", xOffset = 10, yOffset = 10 },
        { type = "Infantry AK", xOffset = -10, yOffset = 10 },
        { type = "Infantry AK", xOffset = 10, yOffset = -10 },
        { type = "Infantry AK", xOffset = -10, yOffset = -10 },
    }
}

-- Logging
function Transporter.logError(message) env.info("[TRANSPORTER] Err: "  .. message) end
function Transporter.logInfo(message) env.info("[TRANSPORTER] Info: "  .. message) end
function Transporter.logDebug(message) if Transporter.Debug then env.info("[TRANSPORTER] Dbg: "  .. message) end end

-- Helpers
local function generateRandomCode()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local code = ""
    for i=1,5 do
        local rand = math.random(1, #chars)
        code = code .. string.sub(chars, rand, rand)
    end
    return code
end

local messageTimers = {}
local function sendMessage(unitID, code, duration, interval, playerName, timeElapsed)
    if Transporter.ActiveRequests[playerName] == nil then
        if messageTimers[playerName] then timer.removeFunction(messageTimers[playerName]); messageTimers[playerName] = nil end
        return
    end
    trigger.action.outTextForUnit(unitID, "呼叫运输机支援！请在F10地图目标点创建标记，并输入代码 [" .. code .. "]，然后删除标记以确认。", 5)
    timeElapsed = timeElapsed + interval
    if timeElapsed >= duration then
        if messageTimers[playerName] then timer.removeFunction(messageTimers[playerName]); messageTimers[playerName] = nil end
    else
        local timerHandle = timer.scheduleFunction(function() sendMessage(unpack({unitID, code, duration, interval, playerName, timeElapsed})) end, {}, timer.getTime() + interval)
        if timerHandle then messageTimers[playerName] = timerHandle end
    end
end

local function sendMessagePeriodically(unitID, code, duration, interval, playerName)
    local timeElapsed = 0
    sendMessage(unitID, code, duration, interval, playerName, timeElapsed)
end

-- Event Handler
Transporter.eventHandler = {}
function Transporter.eventHandler:onEvent(_event)
    local status, err = pcall(function(_event)
        if not _event or not _event.id then return end
        if _event.id == world.event.S_EVENT_MARK_REMOVED then
            local marker = _event.text
            local _pos = _event.pos
            local _playerName = _event.initiator and _event.initiator:getPlayerName()
            if not marker or not _playerName then return end
            local req = Transporter.ActiveRequests[_playerName]
            if req and string.find(marker, req.code) then
                Transporter.logInfo("Player " .. _playerName .. " verified. Spawning Transporter.")
                local _point = { x = _pos.x, y = _pos.z }
                Transporter.addTask(req.coalition, req.unitName, _point)
                Transporter.ActiveRequests[_playerName] = nil
            end
        -- elseif _event.id == world.event.S_EVENT_LAND then
        --     local eventGroup = Unit.getGroup(_event.initiator)
        --     if eventGroup then
        --         local eventGroupId = eventGroup:getID()
        --         for playerName, groupList in pairs(Transporter.ActiveGroups) do
        --             for i, groupInfo in ipairs(groupList) do
        --                 if eventGroupId == groupInfo.groupId then
        --                     -- Logic for landing?
        --                     break
        --                 end
        --             end
        --         end
        --     end
        end        
    end, _event)
    if not status then Transporter.logError("Event Handler Error: " .. err) end
end

-- Call Request
function Transporter.CallTransport(_args)
    local _unitName = _args[1]
    local _transportType = _args[2]
    local _unit = ctld.getTransportUnit(_unitName)
    if not _unit then return end
    local _playerName = _unit:getPlayerName()
    if not _playerName then return end
    local _ucid = SourceObj.playerInfo[_playerName]
    if not _ucid or not SourceObj.playerSource[_ucid] then return end
    local _groupId = SourceObj.getGroupId(_unit)

    local count = 0
    for _, request in pairs(Transporter.ActiveRequests) do
        if request.coalition == _unit:getCoalition() and request.transportType == _transportType then count = count + 1 end
    end
    
    if count >= Transporter.MaxCount[_transportType] then
        trigger.action.outTextForGroup(_groupId, "Queue full for this type!", 15)
        return
    end

    local code = generateRandomCode()
    Transporter.ActiveRequests[_playerName] = {
        code = code, unitName = _unitName, coalition = _unit:getCoalition(),
        time = timer.getTime(), ucid = _ucid, playerName = _playerName,
        groupId = _groupId, transportType = _transportType
    }

    local cost = Transporter.CostTable[_transportType]
    local currentPoints = SourceObj.playerSource[_ucid].point
    if currentPoints < cost then
        trigger.action.outTextForGroup(_groupId, string.format("Not enough points (%d/%d)", currentPoints, cost), 15)
        Transporter.ActiveRequests[_playerName] = nil
        return
    end

    sendMessagePeriodically(_unit:getID(), code, 120, 5, _playerName)
    Transporter.logInfo("Generated code ["..code.."] for ".._playerName)
end

-- Update Route
function Transporter.updateRoutePoints(newGroupData, targetPoint, transportType)
    local route = newGroupData.route
    if not route then return end
    
    local lastPoint = route.points and route.points[#route.points]
    if not lastPoint then return end
    
    -- Clone last point
    local newPoint = mist.utils.deepCopy(lastPoint)
    
    -- Update Coordinates
    newPoint.x = targetPoint.x
    newPoint.y = targetPoint.y
    newPoint.alt = 2000 
    newPoint.action = "Turning Point"
    newPoint.speed_locked = true
    
    -- Add ScriptFile Task
    -- Points to l10n/DEFAULT/Transport_Arrival.lua
    local scriptPath = "Transport_Arrival.lua"
    
    local taskAction = {
        ["enabled"] = true,
        ["auto"] = false,
        ["id"] = "WrappedAction",
        ["number"] = 1,
        ["params"] = {
            ["action"] = {
                ["id"] = "ScriptFile",
                ["params"] = {
                    ["file"] = scriptPath
                }
            }
        }
    }
    
    newPoint.task = {
        ["id"] = "ComboTask",
        ["params"] = {
            ["tasks"] = { taskAction }
        }
    }
    
    table.insert(route.points, newPoint)
end

-- Add Task
function Transporter.addTask(_coalition, _unitName, _point)
    local req
    for pname, r in pairs(Transporter.ActiveRequests) do
        if r.unitName == _unitName then req = r; break end
    end
    if not req then return end

    local transportType = req.transportType
    local templateName = Transporter.TemplateTable[transportType] or "TransportTemplate"
    
    if _coalition == 1 then templateName = templateName .. "Red" end
    if _point.x >= -135000 then templateName = templateName .. "North" end

    local cost = Transporter.CostTable[transportType]
    local _ucid = req.ucid
    local currentPoints = SourceObj.playerSource[_ucid].point

    local newGroup = mist.getGroupData(templateName, true)
    if not newGroup then
        Transporter.logError("Template missing: " .. templateName)
        return
    end

    Transporter.updateRoutePoints(newGroup, _point, transportType)

    newGroup.clone = true
    local newGroupData = mist.dynAdd(newGroup)
    if not newGroupData then return end

    local spawnGroup = Group.getByName(newGroupData.name)
    trigger.action.activateGroup(spawnGroup)

    SourceObj.playerSource[_ucid].point = currentPoints - cost
    SourceObj.SaveSourcePoint()
    trigger.action.outTextForGroup(req.groupId, string.format("%s dispatched. Cost: %d.", transportType, cost), 15)

    Transporter.ActiveRequests[req.playerName] = nil
    if not Transporter.ActiveGroups[req.playerName] then Transporter.ActiveGroups[req.playerName] = {} end
    
    table.insert(Transporter.ActiveGroups[req.playerName], {
        groupName = newGroupData.name,
        groupId = newGroupData.groupId,
        playerName = req.playerName,
        targetPoint = _point,
        transportType = transportType,
        coalition = req.coalition
    })
end

-- OnArrival
function Transporter.OnArrival()
    Transporter.logInfo("OnArrival triggered!")
    
    for playerName, groups in pairs(Transporter.ActiveGroups) do
        for i, info in ipairs(groups) do
            local group = Group.getByName(info.groupName)
            if group then
                local unit = group:getUnit(1)
                if unit then
                    local pos = unit:getPoint()
                    local dist = mist.utils.get2DDist(pos, info.targetPoint)
                    
                    if dist < 5000 then 
                        Transporter.logInfo("Arrival verified for " .. info.groupName)
                        
                        if info.transportType == "Deploy" then
                            Transporter.PerformDeploy(info.targetPoint, info.coalition)
                        elseif info.transportType == "Upgrade" then
                            Transporter.PerformUpgrade(info.targetPoint, info.coalition)
                        end
                        
                        table.remove(groups, i) 
                        return
                    end
                end
            end
        end
    end
end

function Transporter.PerformDeploy(point, coalitionID)
    local sideStr = (coalitionID == 1) and "Red" or "Blue"
    local config = Transporter.DeployUnits[sideStr]
    if not config then return end
    
    local unitsData = {}
    local groupName = "Transport_Deploy_" .. math.random(1000,9999)
    local countryId = (coalitionID == 1) and country.id.CJTF_RED or country.id.CJTF_BLUE
    
    for i, uConf in ipairs(config) do
        table.insert(unitsData, {
            ["type"] = uConf.type,
            ["x"] = point.x + uConf.xOffset,
            ["y"] = point.y + uConf.yOffset,
            ["name"] = groupName .. "_u" .. i,
            ["heading"] = math.random(0, 6),
            ["skill"] = "High"
        })
    end

    local groupData = {
        ["visible"] = true,
        ["units"] = unitsData,
        ["name"] = groupName,
        ["category"] = Group.Category.GROUND,
        ["country"] = countryId
    }
    mist.dynAdd(groupData)
    trigger.action.outTextForCoalition(coalitionID, "Transport deployed units!", 10)
end

function Transporter.PerformUpgrade(point, coalitionID)
    local crateName = "UpgradeCrate_" .. math.random(1000,9999)
    local countryId = (coalitionID == 1) and country.id.CJTF_RED or country.id.CJTF_BLUE
    
    local _point = {x = point.x, z = point.y}
    local _crate

    -- Define Crate Type for CTLD tracking
    local crateType = {
        weight = 500,
        unit = "UpgradeCrate", -- Dummy unit name, or handled by hook
        name = "Command Upgrade",
        desc = "Command Upgrade Crate"
    }
    
    -- Register with CTLD
    Transporter.UpgradeCrates[crateName] = true
    if ctld then
        if coalitionID == 1 then
            ctld.spawnedCratesRED[crateName] = crateType
        else
            ctld.spawnedCratesBLUE[crateName] = crateType
        end
    end


    if ctld and ctld.spawnableCratesModel_load then
        if ctld.slingLoad then
            _crate = mist.utils.deepCopy(ctld.spawnableCratesModel_sling)
        else
            _crate = mist.utils.deepCopy(ctld.spawnableCratesModel_load)
        end
        _crate["canCargo"] = true
        _crate["mass"] = 500
    else
        _crate = {
            ["type"] = "Cargo1",
            ["category"] = "Cargos",
            ["canCargo"] = true,
            ["mass"] = 500
        }
    end

    _crate["y"] = _point.z
    _crate["x"] = _point.x
    _crate["name"] = crateName
    _crate["heading"] = 0
    _crate["country"] = countryId

    mist.dynAddStatic(_crate)
    
    -- Try to auto-upgrade immediately on drop (simulation of deployment)
    -- If it fails, the crate remains and can be unpacked later via CTLD
    Transporter.CheckAndStartUpgrade(point, coalitionID, crateName, true) 
end

function Transporter.CheckAndStartUpgrade(point, coalitionID, crateName, isAuto)
    local foundCC = nil
    for _, ccUnitName in pairs(ctld.logisticUnits) do
        local ccUnit = StaticObject.getByName(ccUnitName)
        if ccUnit and ccUnit:getLife() > 0 and ccUnit:getCoalition() == coalitionID then
            local ccPos = ccUnit:getPoint()
            local dist = mist.utils.get2DDist(point, ccPos)
            if dist <= Transporter.UpgradeRadius then foundCC = ccUnitName; break end
        end
    end

    if foundCC then
        trigger.action.outTextForCoalition(coalitionID, "CC Upgrade started for " .. foundCC, 20)
        
        -- Destroy Crate if successful (simulating unpack)
        local cObj = StaticObject.getByName(crateName) or Unit.getByName(crateName)
        if cObj then cObj:destroy() end
        
        -- Clean up from CTLD lists
        if ctld then
            ctld.spawnedCratesRED[crateName] = nil
            ctld.spawnedCratesBLUE[crateName] = nil
        end
        Transporter.UpgradeCrates[crateName] = nil

        if NP.CCStatus[foundCC] then
            NP.CCStatus[foundCC].upgrading = true
            NP.CCStatus[foundCC].upgradeStartTime = timer.getTime()
            local markerName = foundCC .. "_Upgrading"
            local ccObj = StaticObject.getByName(foundCC)
            local ccPos = ccObj:getPoint()
            local upgradeMarker = {
                pos = {x=ccPos.x, z=ccPos.z, y=0},
                name = markerName,
                markType = 5, text = "正在建设... (" .. Transporter.UpgradeTime .. "s)",
                color = {0, 1, 1, 1}, fillColor = {0, 0, 0, 0}, readOnly = true
            }
            mist.marker.add(upgradeMarker)
            timer.scheduleFunction(Transporter.FinishUpgrade, {ccName = foundCC, markerName = markerName}, timer.getTime() + Transporter.UpgradeTime)
        end
    else
        local msg = "Upgrade Crate deployed. No CC nearby. Move it closer and unpack to upgrade."
        if isAuto then msg = "Upgrade Crate dropped. No CC nearby. Move crate to CC and unpack." end
        trigger.action.outTextForCoalition(coalitionID, msg, 20)
    end
end

function Transporter.FinishUpgrade(args)
    local ccName = args.ccName
    local markerName = args.markerName
    mist.marker.remove(markerName)
    local ccObj = StaticObject.getByName(ccName)
    if not ccObj or ccObj:getLife() <= 0 then trigger.action.outText("建设失败: CC 在完成前已被摧毁.", 20); return end
    
    if NP.CCStatus[ccName] then
        local oldLevel = NP.CCStatus[ccName].level
        local newLevel = math.min(oldLevel + 1, 3)
        NP.CCStatus[ccName].level = newLevel
        NP.CCStatus[ccName].upgrading = false
        local ccPos = ccObj:getPoint()
        local coalitionID = ccObj:getCoalition()
        local countryID = ccObj:getCountry()
        local coalitionStr = (coalitionID == 1) and "red" or "blue"
        local fakeStatic = { units = { [1] = { x = ccPos.x, y = ccPos.z, country = countryID, heading = 0 } } }
        NP.spawnDefenseFromUnitlist(fakeStatic, newLevel, coalitionStr, ccName)
        NP.updateCCMarker(ccName, coalitionStr, newLevel, ccPos.x, ccPos.z)
        trigger.action.outText("CC " .. ccName .. " 完成建设！升级至等级 " .. newLevel, 20)
    end
end

-- CTLD Unpack Hook
if ctld and ctld.unpackCrates then
    local old_unpackCrates = ctld.unpackCrates
    ctld.unpackCrates = function(_unit)
        local _nearestCrate = ctld.getClosestCrate(_unit)
        if _nearestCrate then
            local _crateName = _nearestCrate:getName()
            if Transporter.UpgradeCrates[_crateName] then
                -- Intercept: Run our upgrade logic
                local pos = _nearestCrate:getPoint()
                Transporter.CheckAndStartUpgrade({x=pos.x, y=pos.z}, _unit:getCoalition(), _crateName, false)
                return -- Stop standard CTLD unpack
            end
        end
        return old_unpackCrates(_unit)
    end
    Transporter.logInfo("Hooked ctld.unpackCrates for Upgrade Crates.")
end

world.addEventHandler(Transporter.eventHandler)
net.log("LOAD SUCCESS - Transporter Module")
