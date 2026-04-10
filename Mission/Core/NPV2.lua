--[[
    NP占点脚本 By 紫花
    Logic module. Requires NPConfig.lua to be loaded first (provides NP.LevelConfigs,
    NP.CoalitionConfig, NP.AWACSList, NP.SideToStr, and version constants).
    依赖ctld和mist
]]

NP = NP or {}   -- NPConfig.lua already created NP = {}; extend it here.

-- Coalition runtime config. Defined here (not NPConfig.lua) because country.id.*
-- constants are DCS runtime values that must be evaluated inside the SSE environment,
-- not at dofile() load time from a config-only file.
NP.CoalitionConfig = {
    red = {
        side      = 1,
        countryId = country.id.CJTF_RED,
        vehicles  = { command = "SKP-11", ammo = "ZIL-135", fuel = "ATZ-10" },
    },
    blue = {
        side      = 2,
        countryId = country.id.CJTF_BLUE,
        vehicles  = { command = "Hummer", ammo = "M 818", fuel = "M978 HEMTT Tanker" },
    },
}

-- Module-level locals for FARP inventory templates (populated by NP.InitInvisTemplate).
local weaponTemplate  = {}
local liquidsTemplate = {}

net.log("LOAD - NP core logic version " .. NP.Version .. ", script by VL")

-- Runtime state per CC. Keyed by the unit name string (may have trailing spaces).
-- Fields: level (int), zoneType (string), crates (int), upgrading (bool), upgradeStartTime (number)
NP.CCStatus = {}

-- ─── Logging ─────────────────────────────────────────────────────────────────

function NP.logError(message)
    env.info("[NP] Err: " .. message)
end

function NP.logInfo(message)
    env.info("[NP] Info: " .. message)
end

function NP.logDebug(message)
    if message and ctld.Debug then
        env.info("[NP] Dbg: " .. message)
    end
end

function NP.logTrace(message)
    if message and ctld.Trace then
        env.info("[NP] Trace: " .. message)
    end
end

-- ─── Zone-type Utilities ──────────────────────────────────────────────────────

-- Infer zone type from a CC name using the naming convention embedded in the name.
-- Returns "Home", "Middle", "Front", or nil on failure.
-- Call this ONCE per CC lifecycle; store the result in CCStatus.zoneType.
function NP.detectZoneType(ccName)
    local stripped = string.gsub(ccName, "%s+", "")
    if string.find(stripped, "本场") then return "Home"
    elseif string.find(stripped, "中场") then return "Middle"
    elseif string.find(stripped, "前线") then return "Front"
    end
    NP.logError("[detectZoneType] No known zone type in CC name: " .. tostring(ccName))
    return nil
end

-- Return the defense config array for a given CC name and level.
-- Accepts names with or without trailing spaces.
-- Prefers the cached zoneType in CCStatus; falls back to detectZoneType.
function NP.getDefenseConfig(ccName, level)
    local stripped = string.gsub(ccName, "%s+", "")
    -- CCStatus may be keyed by either the spaced or stripped form
    local status = NP.CCStatus[ccName] or NP.CCStatus[stripped]
    local zoneType = (status and status.zoneType) or NP.detectZoneType(stripped)
    if not zoneType then
        NP.logError("[getDefenseConfig] Cannot determine zone type for: " .. tostring(ccName))
        return nil
    end
    -- Cache for next time if we had to detect it
    if status and not status.zoneType then
        status.zoneType = zoneType
    end
    local cfg = NP.LevelConfigs[zoneType] and NP.LevelConfigs[zoneType][level]
    if not cfg then
        NP.logError(string.format("[getDefenseConfig] No config for zoneType=%s level=%s",
            tostring(zoneType), tostring(level)))
        return nil
    end
    return cfg
end

-- ─── General Utilities ───────────────────────────────────────────────────────

function NP.findUnitControlByPlayer(_groupTable)
    local _playerUnits = {}
    for _, _unitsTable in pairs(_groupTable.units) do
        local _unit = ctld.getAddGroupUnit(_unitsTable.unitName)
        if _unit ~= nil then
            local playerName = _unit:getPlayerName()
            if playerName ~= nil then
                _playerUnits[playerName] = _unit
            end
        end
    end
    return _playerUnits
end

function NP.getLogisticData(_logistic)
    for _, _group in pairs(mist.DBs.groupsByName) do
        for _key, _unitTable in pairs(_group.units) do
            if _unitTable.unitName == _logistic:getName() then
                return _group
            end
        end
    end
    return nil
end

function NP.closeEnoughFromEnemyLogisticZone(_unitObject)
    local _unitPoint  = _unitObject:getPoint()
    local _closeEnough = false
    local _logistic
    for _, _name in pairs(ctld.logisticUnits) do
        _logistic = StaticObject.getByName(_name)
        if _logistic ~= nil
            and ((_logistic:getCoalition() ~= _unitObject:getCoalition()) or _logistic:getLife() <= 0)
        then
            local _dist = ctld.getDistance(_unitPoint, _logistic:getPoint())
            if _dist <= NP.CaptureDistance then
                _closeEnough = true
                return _closeEnough, _logistic
            end
        end
    end
    return _closeEnough, _logistic
end

-- ─── Map Markers ─────────────────────────────────────────────────────────────

function NP.updateCCMarker(ccname, coalition, level, x, y)
    mist.marker.remove(ccname)
    mist.marker.remove(ccname .. "_outer")
    mist.marker.remove(ccname .. "_inner")

    local drawColor, drawFillColor
    if coalition == "blue" then
        drawColor     = {0.1, 0.1, 0.9, 1}
        drawFillColor = {0, 0, 1, 0.3}
    else
        drawColor     = {0.9, 0.1, 0.1, 1}
        drawFillColor = {1, 0, 0, 0.3}
    end

    -- Trim zone-type keyword and everything after it from the display name
    local displayName = string.gsub(ccname, "%s+", "")
    for _, keyword in ipairs({"本场", "中场", "前线"}) do
        local s = string.find(displayName, keyword)
        if s then
            displayName = string.sub(displayName, 1, s - 1)
            break
        end
    end

    local text = level and (displayName .. "\nLevel " .. level) or displayName

    mist.marker.add({
        pos      = {x = x + 800, z = y + 800, y = 0},
        name     = ccname,
        markType = 5,
        text     = text,
        color    = drawColor,
        fillColor = {drawColor[1], drawColor[2], drawColor[3], 0.05},
        lineType = 1,
        readOnly = true,
        fontSize = 16,
    })
    mist.marker.add({
        pos       = {x = x, z = y, y = 0},
        name      = ccname .. "_outer",
        markType  = 2,
        radius    = ctld.maximumDistanceLogistic or 200,
        color     = drawColor,
        fillColor = drawFillColor,
        lineType  = 1,
        readOnly  = true,
    })
    mist.marker.add({
        pos       = {x = x, z = y, y = 0},
        name      = ccname .. "_inner",
        markType  = 2,
        radius    = (ctld.minimumDeployDistance or 1000) + 50,
        color     = drawColor,
        fillColor = drawFillColor,
        lineType  = 2,
        readOnly  = true,
    })
end

-- ─── Zone Setup: Internal Helpers ────────────────────────────────────────────

-- Flip helicopter slot-access flags when a CC changes hands.
function NP._flipSlotFlags(ccname, coalition, oppositeCoalition)
    if not Unitlist[ccname] then return end
    if Unitlist[ccname][oppositeCoalition] then
        for _, slotGroup in pairs(Unitlist[ccname][oppositeCoalition]) do
            NP.logInfo('[_flipSlotFlags] 关闭对方机位: |' .. slotGroup .. '|')
            trigger.action.setUserFlag(slotGroup, 100)
        end
    end
    if Unitlist[ccname][coalition] then
        for _, slotGroup in pairs(Unitlist[ccname][coalition]) do
            NP.logInfo('[_flipSlotFlags] 开放己方机位: |' .. slotGroup .. '|')
            trigger.action.setUserFlag(slotGroup, 0)
        end
    end
end

-- Destroy the three named support units for a CC (safe when they do not exist).
function NP._destroySupportUnits(ccname)
    for _, suffix in ipairs({"_Ammo", "_Fuel", "_Command"}) do
        local u = Unit.getByName(ccname .. suffix)
        if u ~= nil then
            u:destroy()
        else
            NP.logError('[_destroySupportUnits] 找不到要销毁的支援单位: ' .. ccname .. suffix)
        end
    end
end

-- Compute world positions for the three support vehicles around the CC unit.
-- Returns three {x, y} tables: command (left), ammo (left-forward), fuel (left-back).
local function computeSupportPositions(CCunit)
    local sep_h, sep_v = 20, 10
    local rad     = CCunit.heading * math.pi / 180
    local left_dx = math.cos(rad + math.pi / 2)
    local left_dy = math.sin(rad + math.pi / 2)
    local fwd_dx  = math.cos(rad)
    local fwd_dy  = math.sin(rad)
    local mid_x   = CCunit.x + left_dx * sep_h
    local mid_y   = CCunit.y + left_dy * sep_h
    return
        {x = mid_x,                         y = mid_y},
        {x = mid_x + fwd_dx * sep_v,        y = mid_y + fwd_dy * sep_v},
        {x = mid_x - fwd_dx * sep_v,        y = mid_y - fwd_dy * sep_v}
end

-- Fill every Invisible FARP warehouse with maximum ammo and fuel.
-- Scheduled ~5 s after the FARP static is placed so the airbase object exists.
function NP._fillFarpWarehouse(_args)
    for _, base in pairs(world.getAirbases()) do
        local desc = Airbase.getDesc(base)
        if desc and desc.typeName == "Invisible FARP" then
            local wh = base:getWarehouse()
            if wh then
                for liquid = 0, 3 do wh:setLiquidAmount(liquid, 1073741823) end
                for itemId, _ in pairs(weaponTemplate) do wh:setItem(itemId, 1073741823) end
                NP.logDebug("[_fillFarpWarehouse] Inventory: " .. ctld.p(wh:getInventory()))
            end
        end
    end
end

-- Spawn the Invisible FARP static at the CC position (idempotent: skipped if already present).
-- Triggers a warehouse fill 5 s after spawning.
function NP._ensureInvisibleFarp(CCunit, ccname)
    if StaticObject.getByName(ccname .. '_invisibleFarp') ~= nil then
        NP.logError('[_ensureInvisibleFarp] Invisible FARP已存在，无需新建: ' .. ccname .. '_invisibleFarp')
        return
    end
    mist.dynAddStatic({
        type       = 'Invisible FARP',
        shape_name = "invisiblefarp",
        country    = CCunit.country,
        category   = 'Heliports',
        x          = CCunit.x,
        y          = CCunit.y,
        name       = ccname .. '_invisibleFarp',
        heading    = CCunit.heading,
        dead       = false,
    })
    timer.scheduleFunction(NP._fillFarpWarehouse, {}, timer.getTime() + 5)
end

-- Spawn the coalition-appropriate Command / Ammo / Fuel vehicle group at the CC.
-- Vehicles are set immortal and invisible (functional support role only).
function NP._spawnSupportVehicles(CCunit, ccname, coalition)
    local cmdPos, ammoPos, fuelPos = computeSupportPositions(CCunit)
    local v = NP.CoalitionConfig[coalition].vehicles
    local _group = {
        visible         = false,
        hiddenOnPlanner = true,
        uncontrollable  = true,
        hiddenOnMFD     = true,
        hidden          = true,
        country         = CCunit.country,
        heading         = CCunit.heading,
        task            = {},
        category        = Group.Category.GROUND,
        units = {
            {
                type           = v.command,
                name           = ccname .. '_Command',
                x              = cmdPos.x,  y = cmdPos.y,
                heading        = CCunit.heading,
                playerCanDrive = false,
                skill          = "Excellent",
            },
            {
                type           = v.fuel,
                name           = ccname .. '_Fuel',
                x              = fuelPos.x, y = fuelPos.y,
                heading        = CCunit.heading,
                playerCanDrive = false,
                skill          = "Excellent",
            },
            {
                type           = v.ammo,
                name           = ccname .. '_Ammo',
                x              = ammoPos.x, y = ammoPos.y,
                heading        = CCunit.heading,
                playerCanDrive = false,
                skill          = "Excellent",
            },
        },
    }
    local spawnedGroup = Group.getByName(mist.dynAdd(_group).name)
    local ctrl = spawnedGroup:getController()
    Controller.setCommand(ctrl, {id = 'SetImmortal',  params = {value = true}})
    Controller.setCommand(ctrl, {id = 'SetInvisible', params = {value = true}})
    ctrl:setOption(8, false)
end

-- Timer callback (runs ~5 s after capture/load): destroy old support units,
-- spawn FARP, spawn new coalition support vehicles, update the map marker.
function NP._deferredZoneSetup(args)
    local static, coalition, ccname, level = args[1], args[2], args[3], args[4]
    local CCunit = static.units[1]
    NP.logDebug('[_deferredZoneSetup] ' .. ctld.p(static) .. ' | ' .. coalition)
    NP._destroySupportUnits(ccname)
    NP._ensureInvisibleFarp(CCunit, ccname)
    NP._spawnSupportVehicles(CCunit, ccname, coalition)
    NP.updateCCMarker(ccname, coalition, level, CCunit.x, CCunit.y)
end

-- ─── Zone Setup: Public API ───────────────────────────────────────────────────

--[[
    Initialize or re-initialize all zone elements for a CC after capture or save-load.

    Parameters:
      static       - mist group data table containing the CC static unit (units[1])
      unitName     - current runtime name of the CC unit (may have trailing spaces)
      coalition    - "red" or "blue"
      skipDefenses - true to skip defense respawn (save-load restore or friendly repair)
      level        - defense level 1–3; falls back to CCStatus or defaults to 3 if nil
]]
function NP.setRelatedZone(static, unitName, coalition, skipDefenses, level)

    -- 1. Resolve canonical CC name from logisticUnits via substring match
    local originalCCname
    for _, v in pairs(ctld.logisticUnits) do
        if string.find(unitName, v) ~= nil then
            originalCCname = v
            break
        end
    end
    if originalCCname == nil then
        NP.logError('[setRelatedZone] CC not found in logisticUnits: ' .. unitName .. ' | coalition:' .. coalition)
        return
    end
    local ccname = string.gsub(originalCCname, "%s+", "")  -- strip all spaces
    NP.logInfo('[setRelatedZone] 原cc名称: |' .. originalCCname .. '| 规范化后: |' .. ccname .. '|')

    -- 2. Validate against Unitlist (slot-flag registry)
    if Unitlist[ccname] == nil then
        NP.logError('[setRelatedZone] CC not in Unitlist: ' .. ccname .. ' | coalition:' .. coalition)
        return
    end

    -- 3. Resolve level and initialize CCStatus if not already present
    if not level then
        level = NP.CCStatus[unitName] and NP.CCStatus[unitName].level or 3
    end
    if not NP.CCStatus[unitName] then
        NP.CCStatus[unitName] = {level = level, crates = 0, upgrading = false, upgradeStartTime = 0}
    end
    NP.CCStatus[unitName].level = level

    -- 4. Store zone type once so subsequent lookups avoid string.find
    if not NP.CCStatus[unitName].zoneType then
        NP.CCStatus[unitName].zoneType = NP.detectZoneType(ccname)
    end

    -- 5. Flip helicopter slot-access flags
    local oppositeCoalition = coalition == 'red' and 'blue' or 'red'
    NP._flipSlotFlags(ccname, coalition, oppositeCoalition)

    -- 6. Deferred zone setup: wait for the new CC static object to settle in DCS
    timer.scheduleFunction(NP._deferredZoneSetup, {static, coalition, ccname, level}, timer.getTime() + 5)

    NP.logInfo('[setRelatedZone] 占领CC的流程完成: ' .. ccname .. ' | 阵营:' .. coalition)

    -- 7. Spawn defense units (skipped when restoring from a save file)
    if not skipDefenses then
        NP.spawnDefenseFromUnitlist(static, level, coalition, ccname)
    else
        NP.logInfo('[setRelatedZone] skipDefenses=true，不重新生成防御单位：' .. ccname)
    end
end

-- ─── Defense Spawning ────────────────────────────────────────────────────────

--[[
    Spawn all defense groups for a CC at the given level.
    Groups are arranged in equal angular sectors around the CC position.
    Existing groups with the same name are destroyed before respawning.
]]
function NP.spawnDefenseFromUnitlist(static, level, coalition, ccName)
    local CCunit = static.units[1]
    if not level then level = 1 end

    local defTable = NP.getDefenseConfig(ccName, level)
    if not defTable then
        NP.logError("[spawnDefenseFromUnitlist] No defense config for: " .. tostring(ccName) .. " L" .. tostring(level))
        return
    end

    -- Strip spaces so group names are consistent regardless of how ccName was passed
    local strippedName = string.gsub(ccName, "%s+", "")
    local groupCount   = #defTable

    for idx, def in ipairs(defTable) do
        local groupName = strippedName .. def.suffix

        -- Destroy pre-existing group with the same name
        local old = Group.getByName(groupName)
        if old then
            NP.logInfo(string.format("[spawnDefenseFromUnitlist] 销毁已存在的群组: %s", groupName))
            old:destroy()
        end

        local group = {
            visible        = false,
            hidden         = false,
            name           = groupName,
            task           = {},
            playerCanDrive = false,
            country        = CCunit.country,
            category       = Group.Category.GROUND,
            units          = {},
        }

        -- Each group gets an equal 360°/groupCount sector; units spread within that sector
        local groupStartAngle = 2 * math.pi * (idx - 1) / groupCount
        local angleStep       = 2 * math.pi / def.count

        for i = 1, def.count do
            local angleBase   = groupStartAngle + (i - 1) * angleStep
            local finalAngle  = angleBase + (math.random() - 0.5) * (math.pi / 2)
            local finalRadius = def.radius * (1 + (math.random() - 0.5) * 0.5)
            local x = CCunit.x + math.cos(finalAngle) * finalRadius
            local y = CCunit.y + math.sin(finalAngle) * finalRadius

            local unitType
            if type(def.type) == "table" then
                unitType = def.type[((i - 1) % #def.type) + 1]
            else
                unitType = def.type
            end

            table.insert(group.units, {
                type    = unitType,
                name    = string.format("%s_unit%d", groupName, i),
                x       = x,
                y       = y,
                heading = finalAngle,
                skill   = "High",
            })

            -- Support units (e.g. radar/command vehicles) spawn beside unit #1 of each group
            if def.support and #def.support > 0 and i == 1 then
                for _, sup in ipairs(def.support) do
                    for r = 1, sup.count do
                        table.insert(group.units, {
                            type    = sup.type,
                            name    = string.format("%s_support_%s_%d", groupName, sup.type, r),
                            x       = x + (sup.offset and sup.offset.x or 0) + (r - 1) * 10,
                            y       = y + (sup.offset and sup.offset.y or 0),
                            heading = finalAngle,
                            skill   = "High",
                        })
                    end
                end
            end
        end

        local newGroup = mist.dynAdd(group)
        if newGroup then
            NP.logInfo(string.format("[spawnDefenseFromUnitlist] 生成群组: %s (主力 %d + 支援 %d)",
                groupName, def.count, def.support and #def.support or 0))
        else
            NP.logError("[spawnDefenseFromUnitlist] 生成失败: " .. groupName)
        end
    end
end

-- ─── Capture ─────────────────────────────────────────────────────────────────

function NP.capture(_args)
    NP.logDebug('进入cap函数')
    local _playerUnits = NP.findUnitControlByPlayer(_args)
    NP.logDebug('开始找最近的cc')

    local _hasCloseEnough, _targetLogistic, _capturedPlayerName, _capUsingUnit
    for _playerName, _unit in pairs(_playerUnits) do
        local _closeEnough, _logistic = NP.closeEnoughFromEnemyLogisticZone(_unit)
        if _closeEnough then
            _hasCloseEnough     = true
            _targetLogistic     = _logistic
            _capturedPlayerName = _playerName
            _capUsingUnit       = _unit
        end
    end

    if _hasCloseEnough == nil then
        NP.logInfo('占点不够近')
        trigger.action.outText('提示：请使用地面指挥官控制单位靠近敌方指挥中心（CC）后再执行占领操作；未靠近时无法占领。', 10)
        return
    end

    local _logisticData = NP.getLogisticData(_targetLogistic)
    if not _logisticData then
        NP.logError("无法获取目标CC的数据，无法占领。CC名称: " .. _targetLogistic:getName())
        return
    end

    local _side    = _capUsingUnit:getCoalition()
    local oldCCName = _targetLogistic:getName()
    local oldStatus = NP.CCStatus[oldCCName]
    local oldLevel  = oldStatus and oldStatus.level or 3

    local initialLevel, skipDefenses
    if _logisticData.coalitionId == _side then
        -- Friendly recapture / repair: keep existing level, skip defense respawn
        initialLevel = oldLevel
        skipDefenses = true
        NP.logInfo("Friendly recapture for: " .. _logisticData.groupName .. ". Keeping Level " .. initialLevel)
    else
        -- Enemy capture: reset to Level 2, spawn fresh defenses
        initialLevel = 2
        skipDefenses = false
        NP.logInfo("Enemy capture for: " .. _logisticData.groupName .. ". Setting to Level 2.")
    end

    -- Pre-capture check: all defense units at the old level must be dead
    if _logisticData.coalitionId ~= _side then
        local checkLevel = oldStatus and oldStatus.level or 3
        local defTable   = NP.getDefenseConfig(oldCCName, checkLevel)
        if not defTable then
            -- Fallback to hardest check if config can't be resolved
            defTable = NP.LevelConfigs.Home[3]
        end

        -- Use the stripped name so group lookup matches how groups were spawned
        local strippedOldName = string.gsub(_logisticData.groupName, "%s+", "")
        for _, def in ipairs(defTable) do
            local groupName = strippedOldName .. def.suffix
            local old = Group.getByName(groupName)
            if old then
                for _, _leader in pairs(old:getUnits()) do
                    if _leader ~= nil and _leader:getCoalition() ~= _side and _leader:getLife() > 1 then
                        NP.logInfo('占点之前未清除所有防御单位，活着的单位是: ' .. _leader:getName())
                        trigger.action.outText('占领失败：目标区域仍有存活的防御单位，请先清除残余部队，或使用JTAC/侦察单位协助搜索。', 10)
                        return
                    end
                end
            end
        end
    end

    -- Resolve coalition data from the config table
    local coalitionStr = NP.SideToStr[_side]
    local coalCfg      = NP.CoalitionConfig[coalitionStr]
    local CountryID    = coalCfg.countryId
    local Country      = country.name[CountryID]

    NP.logDebug('开始从mist获取数据')
    NP.logDebug('_logistic:' .. ctld.p(_targetLogistic))
    NP.logDebug('_logisticData:' .. ctld.formatTable(_logisticData))

    -- Append a space to create a unique name for the new CC static object
    _logisticData.groupName    = _logisticData.groupName .. ' '
    _logisticData.name         = _logisticData.groupName
    _logisticData.groupId      = ctld.getNextGroupId()
    _logisticData.countryId    = CountryID
    _logisticData.country      = Country
    _logisticData.coalitionId  = _side
    _logisticData.coalition    = coalitionStr

    _logisticData.units[1].groupName   = _logisticData.groupName
    _logisticData.units[1].unitName    = _logisticData.groupName  -- Static name == unit name
    _logisticData.units[1].unitId      = ctld.getNextUnitId()
    _logisticData.units[1].groupId     = _logisticData.groupId
    _logisticData.units[1].countryId   = CountryID
    _logisticData.units[1].country     = Country
    _logisticData.units[1].coalition   = coalitionStr
    _logisticData.units[1].coalitionId = _side

    -- Destroy old CC, remove from logistic registry, spawn new CC
    _targetLogistic:destroy()
    for index = #ctld.logisticUnits, 1, -1 do
        if ctld.logisticUnits[index] == _targetLogistic:getName() then
            table.remove(ctld.logisticUnits, index)
        end
    end

    timer.scheduleFunction(mist.dynAddStatic, _logisticData, timer.getTime() + 1)
    timer.scheduleFunction(dsave.recordAllCCsElements, nil, timer.getTime() + 20)
    table.insert(ctld.logisticUnits, _logisticData.units[1].unitName)

    -- Initialize CCStatus for the newly spawned CC
    local newName = _logisticData.units[1].unitName
    NP.CCStatus[newName] = {
        level            = initialLevel,
        zoneType         = NP.detectZoneType(_logisticData.groupName),
        crates           = 0,
        upgrading        = false,
        upgradeStartTime = 0,
    }

    NP.setRelatedZone(_logisticData, newName, coalitionStr, skipDefenses, initialLevel)
    NP.logInfo("战区 " .. _logisticData.groupName .. " 已被 " .. coalitionStr .. " 阵营占领，操作者：" .. _capturedPlayerName)
    trigger.action.outText("战区 " .. _logisticData.groupName .. " 已被 " .. coalitionStr .. " 阵营占领。操作者：" .. _capturedPlayerName, 20)

    -- Delay 3 s so mist.dynAddStatic (scheduled at t+1) has time to register the
    -- new CC object in world before we query StaticObject.getByName().
    timer.scheduleFunction(NP.checkVictoryCondition, {}, timer.getTime() + 3)
end

-- ─── AWACS Management ────────────────────────────────────────────────────────

function NP.RespawnAwacs()
    for _, _plane in pairs(NP.AWACSList) do
        local _grp  = Group.getByName(_plane)
        local AWCAS = _grp and _grp:getUnit(1)
        if AWCAS ~= nil then
            local _found = false
            for _, _existingEWR in pairs(ctld.EWRunits) do
                if _existingEWR and _existingEWR:isExist() and _existingEWR:getName() == _grp:getName() then
                    _found = true
                    break
                end
            end
            if not _found then
                table.insert(ctld.EWRunits, _grp)
            end
            if Unit.getFuel(AWCAS) < 0.3 then
                mist.respawnGroup(_plane, true)
                NP.logInfo(_plane .. " 油量低，重生")
                trigger.action.outText("预警机梯队没油了，后续梯队正在交接！", 10)
            end
        else
            NP.logError('[RespawnAwacs] 找不到预警机单位: ' .. _plane)
        end
    end
    timer.scheduleFunction(NP.RespawnAwacs, {}, timer.getTime() + 900)
end

-- Capture the weapon/liquid template from the "invisTemplate" Invisible FARP in the mission.
-- Called once 5 s after mission load.
function NP.InitInvisTemplate()
    for _, base in pairs(world.getAirbases()) do
        local desc = Airbase.getDesc(base)
        if Airbase.getUnit(base) then
            local unitName = Airbase.getUnit(base):getName()
            if unitName == "invisTemplate" then
                weaponTemplate  = base:getWarehouse():getInventory().weapon
                liquidsTemplate = base:getWarehouse():getInventory().liquids
                NP.logDebug("获取到Invisible FARP的仓库模板: " .. ctld.p(weaponTemplate))
            end
        end
    end
end

-- ─── Victory Condition ───────────────────────────────────────────────────────

local VICTORY_COUNTDOWN_SEC = 300  -- 5 minutes

NP.victory = {
    timerHandle   = nil,
    pendingWinner = nil,  -- "red" or "blue" while countdown is active, nil otherwise
}

-- Scan all live CCs and determine if one coalition holds them all.
-- NP.CCStatus accumulates stale keys (old names from before captures); they are
-- harmlessly filtered out because StaticObject.getByName() returns nil for destroyed objects.
-- FOBs never enter NP.CCStatus (they fail the Unitlist check in setRelatedZone), so
-- iterating CCStatus gives Command Centers only.
function NP.checkVictoryCondition()
    local counts = { red = 0, blue = 0 }
    for unitName, _ in pairs(NP.CCStatus) do
        local obj = StaticObject.getByName(unitName)
        if obj and obj:isExist() then
            local sideStr = NP.SideToStr[obj:getCoalition()]
            if sideStr then
                counts[sideStr] = counts[sideStr] + 1
            end
        end
    end

    local total = counts.red + counts.blue
    if total == 0 then
        NP.logError("[checkVictoryCondition] No live CCs found — skipping check.")
        return
    end

    -- A side loses if it holds no CCs.
    -- Point-based defeat is handled separately in SourceTeam via NP.declarePointDefeat.
    local redLosing  = counts.red  == 0
    local blueLosing = counts.blue == 0

    if redLosing and not blueLosing then
        NP.startVictoryCountdown("blue")
    elseif blueLosing and not redLosing then
        NP.startVictoryCountdown("red")
    else
        NP.cancelVictoryCountdown()
    end
end

-- Start a 5-minute countdown for winner coalition.
-- No-ops if the same winner is already counting down.
function NP.startVictoryCountdown(winner)
    if NP.victory.pendingWinner == winner then return end

    -- Cancel any existing countdown (e.g. if the winner switched — shouldn't normally happen)
    if NP.victory.timerHandle then
        timer.removeFunction(NP.victory.timerHandle)
        NP.victory.timerHandle = nil
    end

    NP.victory.pendingWinner = winner
    local winnerStr = winner == "red" and "红方" or "蓝方"
    local loserStr  = winner == "red" and "蓝方" or "红方"
    trigger.action.outText(string.format(
        "【警报】%s阵营已占领全部指挥中心！\n%s阵营还有5分钟夺回至少一处阵地，否则将宣告失败！",
        winnerStr, loserStr), 30)
    NP.logInfo("[Victory] Countdown started, pending winner: " .. winner)

    NP.victory.timerHandle = timer.scheduleFunction(
        NP.declareVictory, winner, timer.getTime() + VICTORY_COUNTDOWN_SEC)
end

-- Cancel a pending countdown when the losing side recaptures at least one CC.
function NP.cancelVictoryCountdown()
    if NP.victory.timerHandle == nil then return end

    timer.removeFunction(NP.victory.timerHandle)
    NP.victory.timerHandle   = nil
    NP.victory.pendingWinner = nil

    trigger.action.outText("【战局逆转】战线已重新分裂，决战将继续！", 20)
    NP.logInfo("[Victory] Countdown cancelled — losing side recaptured a CC.")
end

-- Called when the 5-minute countdown expires with no recapture by the losing side.
function NP.declareVictory(winner)
    NP.victory.timerHandle   = nil
    NP.victory.pendingWinner = nil

    local winnerStr = winner == "red" and "红方" or "蓝方"
    trigger.action.outText(string.format(
        "【任务结束】%s阵营全面胜利！恭喜！\n任务将在30秒后重置，存档将被清除。",
        winnerStr), 60)
    NP.logInfo("[Victory] " .. winner .. " wins. Scheduling reset in 30 s.")

    timer.scheduleFunction(NP._missionReset, {}, timer.getTime() + 30)
end

-- Called when a team's resource points drop below zero.
-- Immediately announces defeat and restarts after 1 minute (no 5-min countdown).
function NP.declarePointDefeat(loserSide)
    local winnerStr = loserSide == "red" and "蓝方" or "红方"
    local loserStr  = loserSide == "red" and "红方" or "蓝方"
    trigger.action.outText(string.format(
        "【任务结束】%s阵营资源点耗尽，%s阵营全面胜利！\n任务将在1分钟后重置，存档将被清除。",
        loserStr, winnerStr), 60)
    NP.logInfo("[Victory] " .. loserSide .. " ran out of points. Scheduling reset in 60 s.")

    -- Cancel any CC-based countdown that might be running
    NP.cancelVictoryCountdown()

    timer.scheduleFunction(NP._missionReset, {}, timer.getTime() + 60)
end

-- Delete the two save files and restart the mission.
-- net.dostring_in calls into the server (GameGUI) environment where net.load_next_mission lives.
-- Fallback if this doesn't work: write a flag file that InitNPGame.lua polls, or use
-- trigger.action.setUserFlag + a mission-editor trigger to call net.load_next_mission().
function NP._missionReset()
    NP.logInfo("[Victory] Deleting save files and restarting mission.")
    os.remove(dsave.DSaveGroupsFilePath)
    os.remove(dsave.DSaveCCsFilePath)
    net.dostring_in('server', [[
        local mn = DCS.getMissionFilename()
        net.log("NP Victory: restarting mission: " .. tostring(mn))
        local ok = net.load_mission(mn)
        if not ok then
            net.log("NP Victory: FAILED to load mission: " .. tostring(mn))
        end
    ]])
end

-- ─── Startup Timers ──────────────────────────────────────────────────────────

timer.scheduleFunction(NP.InitInvisTemplate, {}, timer.getTime() + 5)
timer.scheduleFunction(NP.RespawnAwacs,      {}, timer.getTime() + 90)

net.log("LOAD SUCCESS - NP version " .. NP.Version .. ", script by VL")
