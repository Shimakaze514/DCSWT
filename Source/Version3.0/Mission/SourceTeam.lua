SourceObj = SourceObj or {}
SourceObj.addTeamF10Menu = {}
SourceObj.REDPOINT = SourceConfig.Team.redInitPoint
SourceObj.BLUEPOINT = SourceConfig.Team.blueInitPoint
SourceObj.updateTeamSourcePointsByEvent = function(_unit, _ucid, _event)
    if _event == "takeoff" then
        local _groupId = SourceObj.getGroupId(_unit)
        if SourceObj.landASAP[_groupId] == true then return end
        local sourcePointChange = SourceObj.getSourceObjChange(_unit)
        if SourceObj.playerSource[_ucid]["point"] - sourcePointChange > 0 then
            if _unit:getCoalition() == 1 then
                SourceObj.REDPOINT = SourceObj.REDPOINT - sourcePointChange
                trigger.action.outTextForGroup(_groupId, string.format("红方阵营消耗点数:%d,当前阵营剩余:%d点",
                    sourcePointChange, SourceObj.REDPOINT), 20)
                env.info("红方点数:" .. tostring(SourceObj.REDPOINT))
                if SourceObj.REDPOINT < 0 then
                    NP.declarePointDefeat("red")
                    return
                end
            end
            if _unit:getCoalition() == 2 then
                SourceObj.BLUEPOINT = SourceObj.BLUEPOINT - sourcePointChange
                trigger.action.outTextForGroup(_groupId, string.format("蓝方阵营消耗点数:%d,当前阵营剩余:%d点",
                    sourcePointChange, SourceObj.BLUEPOINT), 20)
                env.info("蓝方点数:" .. tostring(SourceObj.BLUEPOINT))
                if SourceObj.BLUEPOINT < 0 then
                    NP.declarePointDefeat("blue")
                    return
                end
            end
        end
    elseif _event == "landing" then
        local _groupId = SourceObj.getGroupId(_unit)
        if SourceObj.landASAP[_groupId] == true then return end
        local sourcePointChange = SourceObj.getSourceObjChange(_unit)
        if _unit:getCoalition() == 1 then
            SourceObj.REDPOINT = SourceObj.REDPOINT + sourcePointChange
            trigger.action.outTextForGroup(_groupId, string.format("红方阵营返还点数:%d,当前阵营剩余:%d点",
                sourcePointChange, SourceObj.REDPOINT), 20)
            env.info("红方点数:" .. tostring(SourceObj.REDPOINT))
        end
        if _unit:getCoalition() == 2 then
            SourceObj.BLUEPOINT = SourceObj.BLUEPOINT + sourcePointChange
            trigger.action.outTextForGroup(_groupId, string.format("蓝方阵营返还点数:%d,当前阵营剩余:%d点",
                sourcePointChange, SourceObj.BLUEPOINT), 20)
            env.info("蓝方点数:" .. tostring(SourceObj.BLUEPOINT))
        end
        -- Landing returns points; re-check in case a bankruptcy countdown can now be cancelled.
        timer.scheduleFunction(NP.checkVictoryCondition, {}, timer.getTime() + 1)
    elseif _event == "kill" then
        local _groupId = SourceObj.getGroupId(_unit.initiator)
        local sourcePointChange = SourceObj.getTeamSourceKillChange(_unit.target)
        if _unit.target:getCoalition() == 1 then
            SourceObj.REDPOINT = SourceObj.REDPOINT - sourcePointChange
            local text
            if _unit.target:getDesc().category == 2 then
                text = string.format("地面单位被摧毁扣阵营点数:%d,当前阵营剩余:%d点",
                    sourcePointChange, SourceObj.REDPOINT)
            elseif _unit.target:getDesc().category == 3 then
                text = string.format("海上船只被摧毁扣阵营点数:%d,当前阵营剩余:%d点",
                    sourcePointChange, SourceObj.REDPOINT)
            end
            if text then trigger.action.outTextForCoalition(coalition.side.RED, text, 10) end
            env.info("红方点数:" .. tostring(SourceObj.REDPOINT))
            if SourceObj.REDPOINT < 0 then
                NP.declarePointDefeat("red")
                return
            end
        end
        if _unit.target:getCoalition() == 2 then
            SourceObj.BLUEPOINT = SourceObj.BLUEPOINT - sourcePointChange
            local text
            if _unit.target:getDesc().category == 2 then
                text = string.format("地面单位被摧毁扣阵营点数:%d,当前阵营剩余:%d点",
                    sourcePointChange, SourceObj.BLUEPOINT)
            elseif _unit.target:getDesc().category == 3 then
                text = string.format("海上船只被摧毁扣阵营点数:%d,当前阵营剩余:%d点",
                    sourcePointChange, SourceObj.BLUEPOINT)
            end
            if text then trigger.action.outTextForCoalition(coalition.side.BLUE, text, 10) end
            env.info("蓝方点数:" .. tostring(SourceObj.BLUEPOINT))
            if SourceObj.BLUEPOINT < 0 then
                NP.declarePointDefeat("blue")
                return
            end
        end
        -- if _unit.initiator:getCoalition() ~= _unit.target:getCoalition() then
        --   SourceObj.eventAddPoint("击杀敌军", SourceObj.getTeamSourceKillChange(_unit.target), _ucid, _groupId)
        -- else
        --   SourceObj.eventAddPoint("击杀友军:", -SourceObj.getTeamSourceKillChange(_unit.target), _ucid, _groupId)
        -- end
    end
end
SourceObj.lessSourceTeamPoint = function(team, point)
    env.info(team, tostring(point))
    if team == "RED" then
        SourceObj.REDPOINT = SourceObj.REDPOINT - point
        if SourceObj.REDPOINT < 0 then
            NP.declarePointDefeat("red")
        end
    elseif team == "BLUE" then
        SourceObj.BLUEPOINT = SourceObj.BLUEPOINT - point
        if SourceObj.BLUEPOINT < 0 then
            NP.declarePointDefeat("blue")
        end
    end
end
SourceObj.addSourceTeamPoint = function(team, point)
    env.info(team)
    env.info(tostring(point))
    env.info(tostring(SourceObj.BLUEPOINT))
    if team == "RED" then
        SourceObj.REDPOINT = SourceObj.REDPOINT + point
    elseif team == "BLUE" then
        SourceObj.BLUEPOINT = SourceObj.BLUEPOINT + point
    end
end
SourceObj.onTeamBirth = function(_unit)
    local displayMsg = false
    local _typeName = _unit:getTypeName()
    if _typeName and AircraftPriceMap[_typeName] then
        displayMsg = true
    end
    if not displayMsg then
        return
    end
    local _groupId = SourceObj.getGroupId(_unit)
    if _groupId == nil then
        return
    end
    local _team = _unit:getCoalition()
    SourceObj.addF10TeamSourceMenu(_groupId, _team)
end
SourceObj.addF10TeamSourceMenu = function(groupId, _team)
    if not SourceObj.addTeamF10Menu[groupId] then
        local status, err = pcall(function()
            local _rootPath = missionCommands.addSubMenuForGroup(groupId, "阵营资源点")
            if _team == 0 then
                missionCommands.addCommandForGroup(groupId, "查询阵营资源点", _rootPath, SourceObj.getTeamPoint,
                    groupId)
            end
            if _team == 1 then
                missionCommands.addCommandForGroup(groupId, "查询阵营资源点", _rootPath, SourceObj.getRedPoint,
                    groupId)
            end
            if _team == 2 then
                missionCommands.addCommandForGroup(groupId, "查询阵营资源点", _rootPath, SourceObj.getBluePoint,
                    groupId)
            end
        end)
        if (not status) then
            env.info("添加战役资源系统菜单时出错: %s", err)
        end
        SourceObj.addTeamF10Menu[groupId] = true
    end
end
SourceObj.getTeamPoint = function(groupId)
    if groupId ~= nil then
        local _ucid = SourceObj.playerUcidByGroup[groupId]
        if _ucid then
            trigger.action.outTextForGroup(groupId,
                string.format("当前阵营拥有资源点红方:%s,蓝方:%s", tostring(SourceObj.REDPOINT),
                    tostring(SourceObj.BLUEPOINT)), 30)
        end
    end
end
SourceObj.getRedPoint = function(groupId)
    if groupId ~= nil then
        local _ucid = SourceObj.playerUcidByGroup[groupId]
        if _ucid then
            trigger.action.outTextForGroup(groupId, string.format("当前阵营拥有资源点:%s",
                tostring(SourceObj.REDPOINT)), 30)
        end
    end
end
SourceObj.getBluePoint = function(groupId)
    if groupId ~= nil then
        local _ucid = SourceObj.playerUcidByGroup[groupId]
        if _ucid then
            trigger.action.outTextForGroup(groupId, string.format("当前阵营拥有资源点:%s",
                tostring(SourceObj.BLUEPOINT)), 30)
        end
    end
end

SourceObj.getTeamSourceKillChange = function(_unit)
    local sourcePointChange = 0
    if _unit:getDesc().category == 2 then
        sourcePointChange = SourceConfig.TeamKillCost.GROUND_UNIT
    elseif _unit:getDesc().category == 3 then
        sourcePointChange = SourceConfig.TeamKillCost.SHIP
    end
    return sourcePointChange
end
env.info("战役资源系统事件处理加载完毕")
