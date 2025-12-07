SourceObj = SourceObj or {}
SourceObj.landASAP = SourceObj.landASAP or {}

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
        if ps.birthTime and (timer.getTime() - ps.birthTime < 120) then
            trigger.action.outSoundForGroup(_groupId, "overspeed.ogg")
            trigger.action.outSoundForGroup(_groupId, "descend-descend-now.ogg")
            for i = 0, 14 do
                timer.scheduleFunction(function(args)
                    local groupId = args[1]
                    trigger.action.outTextForGroup(groupId, "规则提示：您在出生后120秒内起飞。请立即返航并在" .. tostring(15-i) .. "秒内安全着陆，否则飞机将被销毁。", 15-i, true)
                end, {_groupId}, timer.getTime() + i)
            end
            SourceObj.landASAP[_groupId] = true
            timer.scheduleFunction(function(args)
                local groupId = args[1]
                local unit = args[2]
                if unit and Unit.isExist(unit) then
                    --local alt = _unit:getPoint().y
                    if unit:inAir() and (timer.getTime() - ps.birthTime < 120) then
                        trigger.action.outTextForGroup(groupId, "处罚：未在规定时间内着陆，飞机已被销毁。请遵守出生起飞规则。", 15, true)
                        SourceObj.unitExplosion(unit)
                        trigger.action.outSoundForGroup(groupId, "takeoff-config-warning.ogg")
                    else
                        trigger.action.outTextForGroup(groupId, "已及时降落，处罚已取消。感谢配合。", 15, true)
                        trigger.action.outSoundForGroup(groupId, "clear-of-conflict.ogg")
                    end
                    SourceObj.landASAP[groupId] = false
                end
            end, {_groupId,_unit}, timer.getTime() + 15)
            return
        end

        if SourceObj.playerSource[_ucid].point - sourcePointChange > 0 then
            SourceObj.playerSource[_ucid].point = SourceObj.playerSource[_ucid].point - sourcePointChange
            SourceObj.SaveSourcePoint()
            local text = string.format("起飞成功，祝您武运昌隆！\n消耗资源点: -%d\n当前余额: %d\n\n挂载详情: %s",
                sourcePointChange, SourceObj.playerSource[_ucid].point, countInfo)
            trigger.action.outTextForGroup(_groupId, text, 20, true)
            trigger.action.outSoundForGroup(_groupId, "ding.ogg")
            if SourceObj.pendingKillPoint[_ucid] then
                SourceObj.pendingKillPoint[_ucid] = nil
            end
        else
            local text = string.format("【警告：资源不足】\n当前资源点: %d\n本次起飞需要: %d\n\n若不更换挂载强行起飞，飞机将在10秒后自毁！\n提示: 可等待系统低保或更换更便宜的挂载。",
                SourceObj.playerSource[_ucid].point, sourcePointChange)
            trigger.action.outTextForGroup(_groupId, text, 120, true)
            trigger.action.outSoundForGroup(_groupId, "overspeed.ogg")
            trigger.action.outSoundForGroup(_groupId, "descend-descend-now.ogg")
            for i = 0, 14 do
                timer.scheduleFunction(function(args)
                    local groupId = args[1]
                    trigger.action.outTextForGroup(groupId, "规则提示：您的资源点不足，请立即返航并在 " .. tostring(15-i) .. " 秒内安全着陆，否则飞机将被销毁。", 15-i, true)
                end, {_groupId}, timer.getTime() + i)
            end
            SourceObj.landASAP[_groupId] = true
            timer.scheduleFunction(function(args)
                local groupId = args[1]
                local unit = args[2]
                if unit and Unit.isExist(unit) then
                    if unit:inAir() then
                        trigger.action.outTextForGroup(groupId, "处罚：因资源点不足且未在规定时间内着陆，飞机已被销毁。", 15, true)
                        SourceObj.unitExplosion(unit)
                        trigger.action.outSoundForGroup(groupId, "takeoff-config-warning.ogg")
                    else
                        trigger.action.outTextForGroup(groupId, "已及时降落，处罚已取消。请更换挂载或等待资源补充。", 15, true)
                        trigger.action.outSoundForGroup(groupId, "clear-of-conflict.ogg")
                    end
                    SourceObj.landASAP[groupId] = false
                end
            end, {_groupId, _unit}, timer.getTime() + 15)
        end
    elseif _event == "landing" then
        local _groupId = SourceObj.getGroupId(_unit)
        if SourceObj.landASAP[_groupId] == true then return end
        local sourcePointChange, countInfo = SourceObj.getSourceObjChange(_unit)
        local totalReturn = sourcePointChange
        if SourceObj.pendingKillPoint[_ucid] then
            totalReturn = totalReturn + SourceObj.pendingKillPoint[_ucid]
            countInfo = countInfo .. string.format("\n- 击杀奖励结算: +%d", SourceObj.pendingKillPoint[_ucid])
            SourceObj.pendingKillPoint[_ucid] = nil
        end
        SourceObj.playerSource[_ucid].point = SourceObj.playerSource[_ucid].point + totalReturn
        SourceObj.SaveSourcePoint()
        local text = string.format("降落成功，欢迎返航！\n\n【本次任务结算】\n总计获得资源点: +%d\n当前资源点余额: %d\n\n【结算详情】\n%s",
            totalReturn, SourceObj.playerSource[_ucid].point, countInfo)
        trigger.action.outTextForGroup(_groupId, text, 10)
        trigger.action.outSoundForGroup(_groupId, "chest-open.ogg")
    elseif _event == "pilotDead" then
        local _groupId = SourceObj.getGroupId(_unit)
        local halfPoint = 0
        if SourceObj.pendingKillPoint[_ucid] then
            halfPoint = math.floor(SourceObj.pendingKillPoint[_ucid] / 2)
            SourceObj.pendingKillPoint[_ucid] = nil
        end
        SourceObj.playerSource[_ucid].point = SourceObj.playerSource[_ucid].point + halfPoint
        SourceObj.SaveSourcePoint()
        local text = string.format("您已阵亡。本次任务积累的击杀奖励将减半结算。\n\n结算获得: +%d 点\n当前资源点余额: %d",
            halfPoint, SourceObj.playerSource[_ucid].point)
        trigger.action.outTextForGroup(_groupId, text, 10)
    elseif _event == "kill" then
        local _groupId = SourceObj.getGroupId(_unit.initiator)
        if _unit.initiator:getCoalition() ~= _unit.target:getCoalition() then
            local killPoint = SourceObj.getSourceKillChange(_unit.target)
            SourceObj.pendingKillPoint[_ucid] = (SourceObj.pendingKillPoint[_ucid] or 0) + killPoint
            trigger.action.outTextForGroup(_groupId, string.format(
                "击杀敌军！获得预结算奖励: +%d 点。\n请注意：安全返航降落后才能获得全部奖励，若阵亡则奖励减半！", killPoint), 10)
            trigger.action.outSoundForGroup(_groupId, "war-thunder-kill.ogg")
        else
            SourceObj.eventAddPoint("击杀友军:", -SourceObj.getSourceKillChange(_unit.target), _ucid, _groupId)
        end
    end
end