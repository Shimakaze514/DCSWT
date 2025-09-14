SourceObj = SourceObj or {}
SourceObj.playerGroup = {}
SourceObj.playerUcidByGroup = {}
SourceObj.addedF10Menu = {}
SourceObj.pendingKillPoint = {}
SourceObj.killEnemy = 100
SourceObj.killFriend = -250
SourceObj.pilotDead = 150
SourceObj.addCrate = 50
SourceObj.updateSourcePointsByEvent = function(_unit, _ucid, _event)
    SourceObj.playerSource[_ucid] = SourceObj.playerSource[_ucid] or {}
    if SourceObj.playerSource[_ucid].point == nil then
        SourceObj.playerSource[_ucid].point = SourceObj.sourceInitPoint
        SourceObj.SaveSourcePoint()
    end
    if _event == "takeoff" then
        local _groupId = SourceObj.getGroupId(_unit)
        local sourcePointChange, countInfo = SourceObj.getSourceObjChange(_unit)

        local ps = SourceObj.playerSource[_ucid] or {}
        if ps.birthTime and (timer.getTime() - ps.birthTime < 90) then
            local _groupId = SourceObj.getGroupId(_unit)
            trigger.action.outTextForGroup(_groupId, "你在出生后90秒内起飞，触发自爆！", 10, true)

            if ps.countdownTaskId then
                timer.removeFunction(ps.countdownTaskId)
                ps.countdownTaskId = nil
            end

            timer.scheduleFunction(SourceObj.unitExplosion, _unit, timer.getTime() + 5)
            return
        end
        -- if SourceObj.playerSource[_ucid]["deadLastTime"] == true then
        --   sourcePointChange=sourcePointChange + SourceObj.pilotDead
        --   countInfo=countInfo.."\n因为上一架次你的驾驶员死亡，所以加扣了"..SourceObj.pilotDead..'分。条件允许的话可以跳伞'
        --   SourceObj.playerSource[_ucid]["deadLastTime"] = nil
        -- end

        if SourceObj.playerSource[_ucid].point - sourcePointChange > 0 then
            SourceObj.playerSource[_ucid].point = SourceObj.playerSource[_ucid].point - sourcePointChange
            SourceObj.SaveSourcePoint()
            local text = string.format(
                "起飞成功,本次总共消耗私有资源点:%d,个人剩余:%d点.\n详细信息:%s",
                tostring(sourcePointChange), tostring(SourceObj.playerSource[_ucid].point), tostring(countInfo))
            trigger.action.outTextForGroup(_groupId, text, 20, true)
        else
            local text = string.format(
                "你的私有资源点剩余(%d),本次起飞需要:%d,即将自爆！请挂机等低保或改用低价挂载！",
                SourceObj.playerSource[_ucid].point, sourcePointChange)
            trigger.action.outTextForGroup(_groupId, text, 120, true)
            timer.scheduleFunction(SourceObj.unitExplosion, _unit, timer.getTime() + 10)
        end
    elseif _event == "landing" then
        -- SourceObj.eventAddPoint('降落成功', 30, _ucid, _groupId)
        local _groupId = SourceObj.getGroupId(_unit)
        local sourcePointChange, countInfo = SourceObj.getSourceObjChange(_unit)
        local totalReturn = sourcePointChange
        if SourceObj.pendingKillPoint[_ucid] then
            totalReturn = totalReturn + SourceObj.pendingKillPoint[_ucid]
            countInfo = countInfo .. string.format("\n击杀奖励结算:+%d", SourceObj.pendingKillPoint[_ucid])
            SourceObj.pendingKillPoint[_ucid] = nil
        end
        SourceObj.playerSource[_ucid].point = SourceObj.playerSource[_ucid].point + totalReturn
        SourceObj.SaveSourcePoint()
        local text = string.format("降落成功,结算添加资源点:%d,个人剩余:%d点.\n详细信息:%s",
            tostring(totalReturn), tostring(SourceObj.playerSource[_ucid].point), tostring(countInfo))
        trigger.action.outTextForGroup(_groupId, text, 10)
    elseif _event == "pilotDead" then
        local _groupId = SourceObj.getGroupId(_unit)
        local halfPoint = 0
        if SourceObj.pendingKillPoint[_ucid] then
            halfPoint = math.floor(SourceObj.pendingKillPoint[_ucid] / 2)
            SourceObj.pendingKillPoint[_ucid] = nil
        end
        SourceObj.playerSource[_ucid].point = SourceObj.playerSource[_ucid].point + halfPoint
        SourceObj.SaveSourcePoint()
        local text = string.format(
            "您已阵亡，获得资源点减半！\n结算添加资源点:%d，个人剩余:%d点",
            tostring(halfPoint), tostring(SourceObj.playerSource[_ucid].point))
        trigger.action.outTextForGroup(_groupId, text, 10)
        -- SourceObj.playerSource[_ucid]["deadLastTime"] = true
    elseif _event == "kill" then
        local _groupId = SourceObj.getGroupId(_unit.initiator)
        if _unit.initiator:getCoalition() ~= _unit.target:getCoalition() then
            local killPoint = SourceObj.getSourceKillChange(_unit.target)
            SourceObj.pendingKillPoint[_ucid] = (SourceObj.pendingKillPoint[_ucid] or 0) + killPoint
            trigger.action.outTextForGroup(_groupId, string.format(
                "击杀敌军，奖励已记录，将在降落后结算(+%d点)", killPoint), 10)
        else
            SourceObj.eventAddPoint("击杀友军:", -SourceObj.getSourceKillChange(_unit.target), _ucid, _groupId)
        end
    end
end
SourceObj.eventAddPoint = function(_event, _point, _ucid, _groupId)
    local sourcePointsTemp = SourceObj.playerSource[_ucid].point
    SourceObj.playerSource[_ucid].point = sourcePointsTemp + _point
    local text = ""
    if _point > 0 then
        text = string.format("%s,奖励:%s点,你的私有资源点剩余:%d点", _event, tostring(_point),
            tostring(SourceObj.playerSource[_ucid].point))
    else
        text = string.format("%s,惩罚:%s点,你的私有资源点剩余:%d点", _event, tostring(_point),
            tostring(SourceObj.playerSource[_ucid].point))
    end
    trigger.action.outTextForGroup(_groupId, text, 10)
end

SourceObj.onBirth = function(_unit)
    local displayMsg = false
    local _typeName = _unit:getTypeName()
    if _typeName and AircraftPriceMap[_typeName] then
        displayMsg = true
    end
    if not displayMsg then
        return
    end
    local _name = _unit:getPlayerName()
    if _name == nil then
        return
    end
    local _ucid = SourceObj.playerInfo[_name]
    if _ucid == nil then
        return
    end
    local _groupId = SourceObj.getGroupId(_unit)
    if _groupId == nil then
        return
    end

    SourceObj.playerGroup[_ucid] = _groupId
    SourceObj.playerUcidByGroup[_groupId] = _ucid
    SourceObj.addF10SourceMenu(_groupId)

    SourceObj.playerSource[_ucid].birthTime = timer.getTime()
    -- 如果已有旧的倒计时任务，先移除（避免重复）
    if SourceObj.playerSource[_ucid].countdownTaskId then
        timer.removeFunction(SourceObj.playerSource[_ucid].countdownTaskId)
        SourceObj.playerSource[_ucid].countdownTaskId = nil
    end
    SourceObj.playerSource[_ucid].countdownTaskId =
        timer.scheduleFunction(SourceObj.countdownMessage, {_ucid, _groupId}, timer.getTime() + 10)

    timer.scheduleFunction(SourceObj.initMessage, {_groupId, SourceObj.playerSource[_ucid].point},
        timer.getTime() + 15)
end
SourceObj.countdownMessage = function(args)
    local ucid, groupId = args[1], args[2]
    local ps = SourceObj.playerSource[ucid]
    -- 如果玩家数据不存在或没有 birthTime，清理并停止
    if not ps or not ps.birthTime then
        if ps and ps.countdownTaskId then
            timer.removeFunction(ps.countdownTaskId)
            ps.countdownTaskId = nil
        end
        return nil
    end

    local remaining = 90 - (timer.getTime() - ps.birthTime)
    if remaining > 0 then
        -- 每10秒提醒一次
        trigger.action.outTextForGroup(groupId,
            string.format("起飞倒计时剩余 %d 秒，请合理安排资源！", math.ceil(remaining)), 5, true)
        -- 返回下一次执行的时间（继续复用同一个定时器 id）
        return timer.getTime() + 10
    else
        -- 计时结束：主动移除定时器引用并停止
        if ps.countdownTaskId then
            timer.removeFunction(ps.countdownTaskId)
            ps.countdownTaskId = nil
        end
        return nil
    end
end
SourceObj.initMessage = function(_args)
    -- trigger.action.outTextForGroup(_args[1], "指挥官玩家请保持SRS正常通联,呼叫无回应者暂时取消权限。", 60, true)
    trigger.action.outTextForGroup(_args[1],
        "本服玩法需要团队配合，请您保持SRS无线电正常通联，以便于队友随时呼叫！\n频道列表：\n  ATC（起降协调）= 261.000\n  GCI（战斗通讯）= 124.800\n  公共频道 = 251.000（敌友都能听见！）\n若忘记频率，聊天框内输入\"-freq\"即可重新收到提示",
        90, true)
    local message = "*服务器已启用资源系统，请看下规则，避免起飞自爆" ..
                        '\n[1]服务器永久保存每位玩家的剩余资源点数,可通过通讯菜单F10查询;\n[2]飞机、弹药、吊舱等都消耗资源点,起飞后扣除.返场降落将根据余量返点;\n[3]击杀敌方单位、吊运、救援，值班GCI、ATC、OP都可获取点数;\n[4]起飞前请检查"余额"及挂载量、合理支配点数，如果资源点不足以支付消耗，强行起飞将会自爆;\n[5]点数耗尽的话,每隔一段时间会发放低保点数;\n\n' ..
                        "你当前私有点数: " .. tostring(_args[2])
    trigger.action.outTextForGroup(_args[1], message, 90)
end
SourceObj.addF10SourceMenu = function(groupId)
    if not SourceObj.addedF10Menu[groupId] then
        local status, err = pcall(function()
            local _rootPath = missionCommands.addSubMenuForGroup(groupId, "私有资源点")
            missionCommands.addCommandForGroup(groupId, "查询私有点数", _rootPath, SourceObj.getPointByGroupID,
                groupId)
        end)
        if (not status) then
            env.info("添加资源系统菜单时出错: %s", err)
        end
        SourceObj.addedF10Menu[groupId] = true
    end
end

SourceObj.getPointByGroupID = function(groupId)
    if groupId ~= nil then
        local _ucid = SourceObj.playerUcidByGroup[groupId]
        if _ucid then
            local currentPoint = tostring(SourceObj.playerSource[_ucid].point)
            local pending = tostring(SourceObj.pendingKillPoint[_ucid] or 0)
            local text = string.format(
                "你的私有资源点剩余:%s\n未结算的击杀奖励:%s\n你需要成功降落才能获得未结算奖励！",
                currentPoint, pending)
            trigger.action.outTextForGroup(groupId, text, 30)
            -- trigger.action.outTextForGroup(groupId, string.format("你的私有资源点剩余:%s", tostring(SourceObj.playerSource[_ucid].point)), 30)
        end
    end
end
env.info("资源系统事件处理加载完毕")
