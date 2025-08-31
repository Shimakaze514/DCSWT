Bomber = {}
Bomber.ActiveRequests = {}
Bomber.Debug = true
Bomber.Trace = false
Bomber.CostTable = {
    ["Attack"] = 200,
    ["Bomber"] = 300,
    ["StealthBomber"] = 300
}
function Bomber.logError(message)
    env.info("[BOMBER] Err: "  .. message)
end

function Bomber.logInfo(message)
    env.info("[BOMBER] Info: "  .. message)
end

function Bomber.logDebug(message)
    if message and Bomber.Debug then
        env.info("[BOMBER] Dbg: "  .. message)
    end
end

function Bomber.logTrace(message)
    if message and Bomber.Trace then
        env.info("[BOMBER] Trace: "  .. message)
    end
end

Bomber.eventHandler = {}
function Bomber.eventHandler:onEvent(_event)
    local status, err = pcall(function(_event)
        if not _event or not _event.id then return end

        -- Marker 删除事件
        if _event.id == world.event.S_EVENT_MARK_REMOVED then
            local marker = _event.text
            local _pos = _event.pos
            local _coalition = _event.coalition
            local _playerName = _event.initiator and _event.initiator:getPlayerName()

            if not marker or not _playerName then return end

            local req = Bomber.ActiveRequests[_playerName]
            if req and string.find(marker, req.code) then
                Bomber.logInfo("玩家 " .. _playerName .. " 验证成功，生成轰炸机")

                local _point = { x = _pos.x, y = _pos.z }
                Bomber.addTask(req.coalition, req.unitName, _point)

                Bomber.ActiveRequests[_playerName] = nil -- 清理掉请求
            else
                Bomber.logDebug("Marker删除但未匹配任何请求: " .. tostring(marker))
            end
        end
    end, _event)

    if not status then
        Bomber.logError(string.format("事件处理出错: %s", err))
    end
end


local function generateRandomCode()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local code = ""
    for i=1,5 do
        local rand = math.random(1, #chars)
        code = code .. string.sub(chars, rand, rand)
    end
    return code
end

function Bomber.CallAttack(_unitNameTable, _planeType)
    local _unitName = _unitNameTable[1]
    Bomber.logInfo("CallAttack: _unitName是" .. tostring(_unitName))
    local _unit = ctld.getTransportUnit(_unitName)
    if not _unit then
        Bomber.logError("CallAttack: 找不到unit " .. tostring(_unitName))
        return
    end
    local _playerName = _unit:getPlayerName()
    if not _playerName then
        Bomber.logError("CallAttack: " .. _unitName .. " 不是玩家")
        return
    end

    local _ucid = SourceObj.playerInfo[_playerName]
    if not _ucid then
        env.error("Bomber.CallAttack: 找不到 UCID")
        return
    end
    if not SourceObj.playerSource[_ucid] then
        env.error("Bomber.CallAttack: 玩家 UCID 没有初始化资源点")
        return
    end
    local _groupId = SourceObj.getGroupId(_unit)

    -- 如果该玩家已有激活请求，先清掉
    if Bomber.ActiveRequests[_playerName] then
        Bomber.logInfo("玩家 " .. _playerName .. " 已有激活请求，覆盖旧的。")
    end

    -- 随机码
    local code = generateRandomCode()
    Bomber.ActiveRequests[_playerName] = {
        code = code,
        unitName = _unitName,
        coalition = _unit:getCoalition(),
        time = timer.getTime(),
        ucid = _ucid,
        playerName = _playerName,
        groupId = _groupId,
        planeType = _planeType
    }

    trigger.action.outTextForUnit(_unit:getID(),
        "呼叫空中支援！请在F10地图创建标记，并输入代码 [" .. code .. "]，然后删除标记以确认。",
        15)

    Bomber.logInfo("生成攻击代码 ["..code.."] 给玩家 ".._playerName)
end


function Bomber.callBomber(_unit, _point)
end

function Bomber.CallStealthBomber(_unitName)
end


function Bomber.addTask(_coalition, _unitName, _point, planeType)
    local templateTable = {
        ["Attack"] = "AttackTemplate",
        ["Bomber"] = "BomberTemplate",
        ["StealthBomber"] = "StealthBomberTemplate"
    }

    local bomberTemplate = templateTable[planeType] or "BomberTemplate"
    if _coalition == 1 then
        bomberTemplate = bomberTemplate .. "Red"
    end
    -- 找到玩家请求
    local req
    for pname, r in pairs(Bomber.ActiveRequests) do
        if r.unitName == _unitName then
            req = r
            break
        end
    end
    if not req then
        env.error("Bomber.addTask: 找不到对应的请求")
        return
    end

    -- 确认点数消耗
    local cost = Bomber.CostTable[planeType] or Bomber.AttackCost
    local _ucid = req.ucid
    local _groupId = req.groupId
    local currentPoints = SourceObj.playerSource[_ucid]["point"]

    if currentPoints < cost then
        trigger.action.outTextForGroup(_groupId,
            string.format("你的私有资源点不足 (%d)，无法呼叫 %s（需要 %d 点）！",
                currentPoints, planeType, cost),
            15)
        Bomber.ActiveRequests[req.playerName] = nil
        return
    end

    -- 克隆飞机模板
    local newGroupData = mist.cloneGroup(bomberTemplate, true, 1000)
    if not newGroupData then
        env.error("Bomber.addTask: 克隆模板失败 " .. bomberTemplate)
        trigger.action.outTextForGroup(_groupId,
            string.format("%s 模板不存在，呼叫失败，未扣除点数。", planeType),
            15)
        Bomber.ActiveRequests[req.playerName] = nil
        return
    end

    local spawnGroup = Group.getByName(newGroupData.name)
    if not spawnGroup then
        env.error("Bomber.addTask: 生成群组失败")
        trigger.action.outTextForGroup(_groupId,
            string.format("%s 生成失败，未扣除点数。", planeType),
            15)
        Bomber.ActiveRequests[req.playerName] = nil
        return
    end

    -- 到这里说明生成成功 → 扣点
    SourceObj.playerSource[_ucid]["point"] = currentPoints - cost
    SourceObj.SaveSourcePoint()
    trigger.action.outTextForGroup(_groupId,
        string.format("成功呼叫 %s，消耗 %d 点，你的剩余资源点：%d",
            planeType, cost, SourceObj.playerSource[_ucid]["point"]),
        15)

    local AttackMapObject = {
        id = 'AttackMapObject',
        params = {
            direction = 0,
            attackQtyLimit = false,
            attackQty = 999,
            expend = "All",
            point = _point,
            directionEnabled = false,
            groupAttack = false,
            altitude = 2000,
            altitudeEnabled = false,
            weaponType = 4030478
        }
    }
    local controller = spawnGroup:getController()
    if controller then
        Controller.setTask(_controller, AttackMapObject)
        trigger.action.outTextForCoalition(_coalition,
            string.format("%s 已起飞，攻击坐标 (%.0f, %.0f)",
                planeType, _point.x, _point.z),
            15)
    else
        env.error("Bomber.addTask: 无法获取控制器")
        trigger.action.outTextForGroup(_groupId,
            string.format("%s 呼叫失败，未扣除点数。", planeType),
            15)
        Bomber.ActiveRequests[req.playerName] = nil
        return
    end

    -- 清理请求
    Bomber.ActiveRequests[req.playerName] = nil
end


world.addEventHandler(Bomber.eventHandler)
net.log("LOAD SUCCESS - Bomber, script by SMKZ")