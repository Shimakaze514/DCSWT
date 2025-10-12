Support = {}
Support.ActiveRequests = {}
Support.ActiveGroups = {}
Support.Debug = false
Support.Trace = false
Support.CostTable = {
    ["Attack"] = 200,  --记得在CTLD里更改描述（搜CallAttack
    ["Bomber"] = 700,
    ["LowBomber"] = 200,
    ["StealthBomber"] = 200,
    ["Nuke"] = 1000,
}
Support.RangeTable = {
    ["Attack"] = 25 * 1852,
    ["Bomber"] = 55 * 1852,
    ["LowBomber"] = 5 * 1852,
    ["StealthBomber"] = 10 * 1852,
    ["Nuke"] = 12 * 1852,
}
Support.MissileTable = {
    ["Attack"] = 5,  -- Tu22
    ["Bomber"] = 20,
    ["LowBomber"] = 15,
    ["StealthBomber"] = 2,
    ["Nuke"] = 1,
}
Support.TemplateTable = {
    ["Attack"] = "AttackTemplate",
    ["Bomber"] = "BomberTemplate",
    ["LowBomber"] = "LowBomberTemplate",
    ["StealthBomber"] = "StealthBomberTemplate",
    ["Nuke"] = "NukeTemplate",
}
Support.SearchRadius = {
    ["Attack"] = 1000,
    ["Bomber"] = 2000,
    ["LowBomber"] = 1500,
    ["StealthBomber"] = 1000,
    ["Nuke"] = 1000,
}
Support.MinimumNukePlayers = 4
Support.MaxCount = {
    ["Attack"] = 4,
    ["Bomber"] = 3,
    ["LowBomber"] = 3,
    ["StealthBomber"] = 5,
    ["Nuke"] = 5,

}
SourceObj = SourceObj or {}
function Support.logError(message)
    env.info("[Support] Err: "  .. message)
end

function Support.logInfo(message)
    env.info("[Support] Info: "  .. message)
end

function Support.logDebug(message)
    if message and Support.Debug then
        env.info("[Support] Dbg: "  .. message)
    end
end

function Support.logTrace(message)
    if message and Support.Trace then
        env.info("[Support] Trace: "  .. message)
    end
end

function Support.p(o, level)
    local MAX_LEVEL = 20
    if level == nil then
        level = 0
    end
    if level > MAX_LEVEL then
        Support.logError("max depth reached in ctld.p : " .. tostring(MAX_LEVEL))
        return ""
    end
    local text = ""
    if (type(o) == "table") then
        text = "\n"
        for key, value in pairs(o) do
            for i = 0, level do
                text = text .. " "
            end
            text = text .. "." .. key .. "=" .. Support.p(value, level + 1) .. "\n"
        end
    elseif (type(o) == "function") then
        text = "[function]"
    elseif (type(o) == "boolean") then
        if o == true then
            text = "[true]"
        else
            text = "[false]"
        end
    else
        if o == nil then
            text = "[nil]"
        else
            text = tostring(o)
        end
    end
    return text
end

Support.eventHandler = {}
function Support.eventHandler:onEvent(_event)
    local status, err = pcall(function(_event)
        if not _event or not _event.id then return end

        -- Marker 删除事件
        if _event.id == world.event.S_EVENT_MARK_REMOVED then
            local marker = _event.text
            local _pos = _event.pos
            local _coalition = _event.coalition
            local _playerName = _event.initiator and _event.initiator:getPlayerName()

            if not marker or not _playerName then return end

            local req = Support.ActiveRequests[_playerName]
            if req and string.find(marker, req.code) then
                Support.logInfo("玩家 " .. _playerName .. " 验证成功，生成轰炸机")

                local _point = { x = _pos.x, y = _pos.z }
                Support.addTask(req.coalition, req.unitName, _point)

                Support.ActiveRequests[_playerName] = nil -- 清理掉请求
            else
                Support.logDebug("Marker删除但未匹配任何请求: " .. tostring(marker))
            end
        elseif _event.id == world.event.S_EVENT_LAND then 
            Support.logDebug("出现降落事件.目前活跃的BomberGroup有："..Support.p(Support.ActiveGroups))
            local eventGroup = Unit.getGroup(_event.initiator)
            local eventGroupId = eventGroup:getID()
            for playerName, groupList in pairs(Support.ActiveGroups) do
                for i, groupInfo in ipairs(groupList) do
                    if eventGroupId == groupInfo.groupId then
                        Group.destroy(eventGroup)
                        table.remove(groupList, i)
                        Support.logDebug("已移除小组 " .. groupInfo.groupName .. " 对应的玩家: " .. playerName)
                        break
                    end
                end
            end
        end        
    end, _event)

    if not status then
        Support.logError(string.format("事件处理出错: %s", err))
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

local messageTimers = {}  -- To track the timers for each player
local function sendMessage(unitID, code, duration, interval, playerName, timeElapsed)
    -- 如果玩家的请求已经完成，停止发送消息
    if Support.ActiveRequests[playerName] == nil then
        Support.logError("活动请求为空")
        if messageTimers[playerName] then
            timer.removeFunction(messageTimers[playerName])  -- 停止该玩家的定时器
            messageTimers[playerName] = nil  -- 从列表中移除定时器
        end
        return
    end

    trigger.action.outTextForUnit(unitID,
        "呼叫空中支援！请在F10地图创建标记，并输入代码 [" .. code .. "]，然后删除标记以确认。",
        5)  -- 每次显示5秒

    -- 更新已用时间
    timeElapsed = timeElapsed + interval

    -- 如果达到指定时间，停止发送
    if timeElapsed >= duration then
        Support.logError("2分钟提示时长已到达，玩家：" .. playerName)
        if messageTimers[playerName] then
            timer.removeFunction(messageTimers[playerName])  -- 停止该玩家的定时器
            messageTimers[playerName] = nil  -- 从列表中移除定时器
        end
    else
        local timerHandle = timer.scheduleFunction(
            function() sendMessage(unpack({unitID, code, duration, interval, playerName, timeElapsed})) end,
            {},
            timer.getTime() + interval
        )--! 不能直接以赋值的方式运行！
        if timerHandle then
            Support.logDebug("Timer scheduled successfully for player: " .. playerName)
            messageTimers[playerName] = timerHandle  -- Store the handle
        else
            Support.logError("Failed to schedule timer for player: " .. playerName)
        end
    end
end

-- 周期性发送消息的函数
local function sendMessagePeriodically(unitID, code, duration, interval, playerName)
    local timeElapsed = 0  -- 初始化时间
    sendMessage(unitID, code, duration, interval, playerName, timeElapsed)  -- 立即执行第一次发送
    Support.logDebug("成功设置提示计时器，玩家：" .. playerName)
end

local function calculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
function Support.searchGroundUnitsInRange(centerPos, SearchRadius,_coalitionId)
    -- 用于存储所有符合条件的地面单位坐标
    local groundUnitPositions = {}
    local allUnits = {}
    local Groups = coalition.getGroups(_coalitionId, Group.Category.GROUND)
    for _, group in pairs(Groups) do
        -- 获取当前小组的所有单位
        local units = group:getUnits()
    
        -- 将每个单位加入到allUnits表中
        for _, unit in pairs(units) do
            table.insert(allUnits, unit)
        end
    end
    -- 遍历所有单位
    for _, unit in pairs(allUnits) do
        -- 确保单位是地面单位，并且已经初始化
        if unit:isExist() then
            -- 获取该单位的位置
            local unitPos = unit:getPoint()
            -- 计算单位和目标点之间的距离
            local distance = calculateDistance(centerPos.x, centerPos.y, unitPos.x, unitPos.z)
            --Support.logDebug("获取"..Support.p(unit:getName()).."的位置："..Support.p(unitPos).."，距离为"..distance)

            -- 如果距离在指定半径内，添加到返回表格中
            if distance <= SearchRadius then
                table.insert(groundUnitPositions, {x = unitPos.x, y = unitPos.z, distance = distance})
            end
        end
    end

    table.sort(groundUnitPositions, function(a, b)
        return a.distance < b.distance
    end)
    --Support.logDebug("找到的地面单位："..Support.p(groundUnitPositions))
    return groundUnitPositions
end

function Support.createBombingTasks(_point, groundUnitPositions, missileCount)
    local DCStasks = {}
    local targetCount = #groundUnitPositions

    if targetCount == 0 then
        table.insert(DCStasks, {
            id='Bombing', params={
                point=_point, x=_point.x, y=_point.y,
                groupAttack=false, expend="All", attackQtyLimit=false,
                attackQty=1, directionEnabled=false, direction=0,
                altitudeEnabled=false, altitude=2000, weaponType=1073741822
            }
        })
        return DCStasks
    end

    -- 将数量拆解成合法 expend 字符串，只生成一次
    local function toExpends(n)
        local expends = {}
        while n >= 4 do table.insert(expends,"Four"); n = n-4 end
        if n >= 2 then table.insert(expends,"Two"); n = n-2 end
        if n >= 1 then table.insert(expends,"One"); n = n-1 end
        return expends
    end

    -- 分配每个目标导弹数量
    local remaining = {}
    local expendLists = {}
    local base = math.floor(missileCount / targetCount)
    for i = 1, targetCount do
        remaining[i] = base
    end
    local rem = missileCount - base * targetCount
    for i = 1, rem do
        remaining[i] = remaining[i] + 1
    end

    -- 每个目标只调用一次 toExpends
    for i, pos in ipairs(groundUnitPositions) do
        expendLists[i] = toExpends(remaining[i])
    end

    -- 按轮次生成任务
    local tasksLeft = true
    while tasksLeft do
        tasksLeft = false
        for i, pos in ipairs(groundUnitPositions) do
            local exps = expendLists[i]
            if #exps > 0 then
                local taskExpend = table.remove(exps, 1)
                table.insert(DCStasks, {
                    id='Bombing', params={
                        point={x=pos.x, y=pos.y}, x=pos.x, y=pos.y,
                        groupAttack=false, expend=taskExpend,
                        attackQtyLimit=false, attackQty=1,
                        directionEnabled=false, direction=0,
                        altitudeEnabled=false, altitude=2000,
                        weaponType=1073741822
                    }
                })
                if #exps > 0 then tasksLeft = true end
            end
        end
    end

    return DCStasks
end

local function updateRoutePoints(newGroupData, _point, planeType)
    -- 获取原有的route.points
    local route = newGroupData.route
    local _coalitionId = newGroupData.coalitionId
    local targetCoalitionId = 0
    if _coalitionId == 1 then targetCoalitionId = 2 elseif _coalitionId == 2 then targetCoalitionId = 1 end

    local R = Support.RangeTable[planeType]
    local missileCount = Support.MissileTable[planeType]
    -- 只处理最后一个点
    local lastPoint = route[#route]  -- 获取最后一个点
    if lastPoint then
        -- 复制整个点的表
        local newPoint = {}
        for k, v in pairs(lastPoint) do
            newPoint[k] = v
        end

        local x1, y1 = lastPoint.x, lastPoint.y
        local x2, y2 = _point.x, _point.y

        -- 计算两点之间的直线距离
        local distance = calculateDistance(x1, y1, x2, y2)

        if distance > 0 then
            local ratio = R / distance  -- 比例因子，确定在这条线上的新位置
            local newX = x1
            local newY = y1
            if ratio < 0.85 then
                newX = x2 + (x1 - x2) * ratio
                newY = y2 + (y1 - y2) * ratio
            end

            -- 更新新点的坐标
            newPoint.x = newX
            newPoint.y = newY

            if planeType == "Nuke" then
                local dx, dy = x2 - x1, y2 - y1
                local len = math.sqrt(dx*dx + dy*dy)
                local ratio = (len + 2000) / len  -- 延长1000米
                _point.x = x1 + dx * ratio
                _point.y = y1 + dy * ratio
                newPoint.alt = 6705.6
            end

            -- 将新的点添加到points中
            local unitsInRange = {}
            if planeType ~= "Nuke" then
                unitsInRange = Support.searchGroundUnitsInRange(_point, Support.SearchRadius[planeType], targetCoalitionId)
            end    
            
            local DCStasks = Support.createBombingTasks(_point,unitsInRange, missileCount)
            newPoint.task = Bomber:TaskCombo(DCStasks)
            -- for _, task in ipairs(DCStasks) do
            --     Support.logDebug("任务 ID: " .. task.id .. ", expend: " .. task.params.expend)
            -- end
            table.insert(route, newPoint)
            Support.logDebug("更新后的Point和task是"..Support.p(newPoint.task))
        end
    end
end
-- function Bomber:SetTaskWaypoint(Waypoint, Task)
--     -- 使用 TaskCombo 方法组合任务
--     Waypoint.task = Bomber:TaskCombo({Task})

--     -- 可选：调试输出，查看 waypoint 的任务内容
--     Support.logInfo("Waypoint任务已设置: " .. Support.p(Waypoint.task))

--     -- 返回设置后的任务
--     return Waypoint.task
-- end
function Bomber:TaskCombo(DCSTasks)
    local DCSTaskCombo = {
        id = 'ComboTask',
        params = {
            tasks = DCSTasks
        }
    }
    return DCSTaskCombo
end


function Support.CallAttack(_args)
    local _unitName = _args[1]
    local _planeType = _args[2]
    Support.logInfo("CallAttack: _unitName是" .. tostring(_unitName))
    local _unit = ctld.getTransportUnit(_unitName)
    if not _unit then
        Support.logError("CallAttack: 找不到unit " .. tostring(_unitName))
        return
    end
    local _playerName = _unit:getPlayerName()
    if not _playerName then
        Support.logError("CallAttack: " .. _unitName .. " 不是玩家")
        return
    end

    local _ucid = SourceObj.playerInfo[_playerName]
    if not _ucid then
        Support.logError("Support.CallAttack: 找不到 UCID")
        return
    end
    if not SourceObj.playerSource[_ucid] then
        Support.logError("Support.CallAttack: 玩家 UCID 没有初始化资源点")
        return
    end
    local _groupId = SourceObj.getGroupId(_unit)

    
    if _planeType == "Nuke" then
        local Players = net.get_player_list()
        local totalPlayers = 0
        for PlayerIDIndex, playerID in pairs(Players) do
            -- is player still in a valid slot
            local _playerDetails = net.get_player_info(playerID)
            if _playerDetails ~= nil and _playerDetails.side ~= 0 and _playerDetails.slot ~= "" and _playerDetails.slot ~= nil then
                totalPlayers = totalPlayers + 1
            end
        end
        if totalPlayers <= Support.MinimumNukePlayers then
            Support.logInfo("CallAttack: 禁止核弹机生成，总人数为" .. tostring(totalPlayers))
            trigger.action.outTextForGroup(_groupId,
            "当前服务器内红蓝双方玩家合计不超过"..Support.MinimumNukePlayers.."人，为避免玩家偷偷趁服务器没人疯狂吊运然后种蘑菇把整个服务器炸平，暂时禁止核弹机生成！",
            15)
            return
        end
    end

    local bomberCount = 0
    for _, request in pairs(Support.ActiveRequests) do
        if request.coalition == _unit:getCoalition() and request.planeType == _planeType then
            bomberCount = bomberCount + 1
        end
    end
    if bomberCount >= Support.MaxCount[_planeType] then
        Support.logInfo("CallAttack: 同一阵营的轰炸机数量已达到"..Support.MaxCount[_planeType].."架，无法再呼叫！")
        trigger.action.outTextForGroup(_groupId,
        "当前本阵营的轰炸机数量已达到"..Support.MaxCount[_planeType].."架，为避免生成54188发导弹使服务器崩溃，暂时禁止轰炸机生成！",
        15)
        return
    end
    
    -- 如果该玩家已有激活请求，先清掉
    if Support.ActiveRequests[_playerName] then
        Support.logInfo("玩家 " .. _playerName .. " 已有激活请求，覆盖旧的。")
    end

    -- 随机码
    local code = generateRandomCode()
    Support.ActiveRequests[_playerName] = {
        code = code,
        unitName = _unitName,
        coalition = _unit:getCoalition(),
        time = timer.getTime(),
        ucid = _ucid,
        playerName = _playerName,
        groupId = _groupId,
        planeType = _planeType
    }

    -- 处理资源点
    local cost = Support.CostTable[_planeType]
    local _unit = ctld.getTransportUnit(_unitName)
    local _name = _unit:getPlayerName()
    local currentPoints = SourceObj.playerSource[_ucid].point
    local playerSource = SourceObj.playerSource[_ucid]
    if not playerSource or not playerSource["point"] then
        Support.logError("CallAttack: 玩家 " .. _name .. " 的资源点未初始化")
        return
    end
    Support.logInfo("CallAttack: 玩家 " .. _name .. " 的UCID是".._ucid.." ,剩余点数"..playerSource["point"].." !")
    Support.logInfo("CallAttack: 呼叫的飞机类型是".._planeType.."!")
    Support.logInfo("CallAttack: 需要的点数是"..cost.."!")
    if currentPoints < cost then
        trigger.action.outTextForGroup(_groupId,
            string.format("你的私有资源点不足 (%d)，无法呼叫 %s（需要 %d 点）！",
                currentPoints, _planeType, cost),
            15)
        Support.ActiveRequests[_playerName] = nil
        return
    end

    -- trigger.action.outTextForUnit(_unit:getID(),
    --     "呼叫空中支援！请在F10地图创建标记，并输入代码 [" .. code .. "]，然后删除标记以确认。",
    --     120)
    sendMessagePeriodically(_unit:getID(), code, 120, 5,_playerName)
    Support.logInfo("生成攻击代码 ["..code.."] 给玩家 ".._playerName)
end

function Support.addTask(_coalition, _unitName, _point)
    -- 找到玩家请求
    local req
    for pname, r in pairs(Support.ActiveRequests) do
        if r.unitName == _unitName then
            req = r
            break
        end
    end
    if not req then
        Support.logError("Support.addTask: 找不到对应的请求")
        return
    end
    Support.logDebug("Active request for " .. _unitName .. ": " .. Support.p(req))
    local planeType = req.planeType

    local bomberTemplate = Support.TemplateTable[planeType] or "BomberTemplate"
    local _country = "CJTF Blue"
    if _coalition == 1 then
        bomberTemplate = bomberTemplate .. "Red"
        _country = "CJTF Red"
    end

    if _point.x >= -135000 then
        Support.logDebug("Target point LAT: " .. _point.x .. ". Using north spawn")
        bomberTemplate = bomberTemplate .. "North"
    end

    -- 确认点数消耗
    local cost = Support.CostTable[planeType]
    local _unit = ctld.getTransportUnit(_unitName)
    local _name = _unit:getPlayerName()
    local _ucid = SourceObj.playerInfo[_name]
    local _groupId = req.groupId
    local currentPoints = SourceObj.playerSource[_ucid].point
    local playerSource = SourceObj.playerSource[_ucid]
    if not playerSource or not playerSource["point"] then
        Support.logError("CallAttack: 玩家 " .. _name .. " 的资源点未初始化")
        return
    end
    -- Support.logInfo("CallAttack: 玩家 " .. _name .. " 的UCID是".._ucid.." ,剩余点数"..playerSource["point"].." !")
    -- Support.logInfo("CallAttack: 呼叫的飞机类型是"..planeType.."!")
    -- Support.logInfo("CallAttack: 需要的点数是"..cost.."!")
    -- if currentPoints < cost then
    --     trigger.action.outTextForGroup(_groupId,
    --         string.format("你的私有资源点不足 (%d)，无法呼叫 %s（需要 %d 点）！",
    --             currentPoints, planeType, cost),
    --         15)
    --     Support.ActiveRequests[req.playerName] = nil
    --     return
    -- end

    -- 克隆飞机模板
    --local newGroupData = mist.cloneGroup(bomberTemplate,true)

    local newGroup = mist.getGroupData(bomberTemplate,true)
    --Support.logInfo("群组已获取，内容是："..Support.p(newGroup))
    if newGroup and newGroup.route then
        updateRoutePoints(newGroup, _point, planeType)
    else
        Support.logError("未找到有效的route数据")
    end
    newGroup.clone = true
    --Support.logInfo("群组已更改，route的内容是："..Support.p(newGroup.route))
    local newGroupData = mist.dynAdd(newGroup)


    --Support.logInfo("MIST生成群组，内容是："..Support.p(newGroupData))
    if not newGroupData then
        Support.logError("Support.addTask: 克隆模板失败 " .. bomberTemplate)
        trigger.action.outTextForGroup(_groupId,
            string.format("%s 模板不存在，呼叫失败，未扣除点数。", planeType),
            15)
        Support.ActiveRequests[req.playerName] = nil
        return
    end

    local spawnGroup = Group.getByName(newGroupData.name)
    if not spawnGroup then
        Support.logError("Support.addTask: 生成群组失败")
        trigger.action.outTextForGroup(_groupId,
            string.format("%s 生成失败，未扣除点数。", planeType),
            15)
        Support.ActiveRequests[req.playerName] = nil
        return
    end
    trigger.action.activateGroup(spawnGroup)

    -- 到这里说明生成成功 → 扣点
    SourceObj.playerSource[_ucid].point = currentPoints - cost
    SourceObj.SaveSourcePoint()
    trigger.action.outTextForGroup(_groupId,
        string.format("成功呼叫 %s，消耗 %d 点，你的剩余资源点：%d",
            planeType, cost, SourceObj.playerSource[_ucid].point),
        15)

    -- local BombingTask = {
    --     id = 'Bombing',
    --     params = {
    --       point            = _point,
    --       x                = _point.x,
    --       y                = _point.y,
    --       groupAttack      = false,
    --       expend           = "All",
    --       attackQtyLimit   = false,
    --       attackQty        = 1,
    --       directionEnabled = false,
    --       direction        = 0,
    --       altitudeEnabled  = false,
    --       altitude         = 2000,
    --       weaponType       = 1073741822,
    --       attackType       = nil,
    --       },
    --   }
    -- local controller = spawnGroup:getController()
    -- if controller then
    --     controller:pushTask(BombingTask)
    --     timer.scheduleFunction(function() 
    --         controller:pushTask(BombingTask)  -- Schedule the task for the controller
    --     end, {}, timer.getTime() + 3)  -- Delay the execution by 3 seconds
    --     trigger.action.outTextForCoalition(_coalition,
    --         string.format("%s 已起飞，攻击坐标 (%.0f, %.0f)",
    --             planeType, _point.x, _point.y),
    --         15)
    -- else
    --     Support.logError("Support.addTask: 无法获取控制器")
    --     trigger.action.outTextForGroup(_groupId,
    --         string.format("%s 呼叫失败，未扣除点数。", planeType),
    --         15)
    --     Support.ActiveRequests[req.playerName] = nil
    --     return
    -- end

    -- 清理请求
    Support.ActiveRequests[req.playerName] = nil

    if Support.ActiveGroups[req.playerName] == nil then
        -- 如果玩家没有小组，初始化为一个空列表
        Support.ActiveGroups[req.playerName] = {}
    end
    table.insert(Support.ActiveGroups[req.playerName], {
    groupName = newGroupData.name,    -- 记录生成的群组名称
    groupId = newGroupData.groupId,   -- 记录群组ID
    playerName = req.playerName       -- 记录玩家名
    })
end

world.addEventHandler(Support.eventHandler)
net.log("LOAD SUCCESS - Bomber, script by SMKZ")