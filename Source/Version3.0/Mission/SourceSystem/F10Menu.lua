SourceObj = SourceObj or {}

SourceObj.addF10SourceMenu = function(groupId,_unit,_ucid)
    if not SourceObj.addedF10Menu[groupId] then
        local status, err = pcall(function()
            missionCommands.addCommandForGroup(groupId, "查询挂载信息", nil, SourceObj.getLoadout, {groupId,_unit, _ucid})
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
                "你的私有资源点剩余:%s\n未结算的击杀奖励:%s\n若在任务中阵亡，击杀奖励将减半！",
                currentPoint, pending)
            trigger.action.outTextForGroup(groupId, text, 30)
        end
    end
end

