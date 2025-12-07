SourceObj = SourceObj or {}

SourceObj.countdownMessage = function(args)
    local ucid, groupId, unit = args[1], args[2], args[3]
    local ps = SourceObj.playerSource[ucid]
    if not ps or not ps.birthTime then
        return nil
    end

    local remaining = 120 - (timer.getTime() - ps.birthTime)
    if remaining > 0 then
        -- 规则部分
        local rulesTbl = {
            "欢迎来到TD动态战役服务器。请阅读并遵守以下起飞与资源规则以获得最佳体验：",
            "1) 出生保护与起飞：出生后有120秒冷却（倒计时期间请勿起飞）。如误起飞，请在15秒内重新着陆。",
            "2) 私有资源点：起飞时扣除所选挂载的资源点，返场安全降落后按剩余返还；击杀、吊运、救援可获得点数奖励。",
            "3) 起飞前请通过 通讯菜单 -> F10 -> 私有资源点 查询本次消耗，合理分配挂载。",
            "4) 若资源点不足，请更换更便宜的挂载或等待系统发放低保（每5分钟400点）；强行起飞将导致飞机被销毁。",
            "5) 若在任务中阵亡，击杀奖励将减半。",
            "*服务器已启用出击冷却功能，在倒计时结束之前起飞将会自爆"
        }
        local rulesMsg = table.concat(rulesTbl, "\n")

        -- 玩法提示（根据机型/类别计算，防护性处理）
        local roleTip = "玩法提示：无法读取机位信息，如需详细玩法请使用 F10 菜单查询。"
        local loadoutInfo = "挂载信息：无法读取（请使用 F10->私有资源点 查询详细挂载）。"
        do
            local ok, tip, s = pcall(function()
                if not unit then error("无法读取单元") end
                local cost, detail = SourceObj.getSourceObjChange(unit)
                if not cost then error("无法计算消耗") end

                -- 挂载信息描述
                local loadoutStr
                if ps.point >= cost then
                    loadoutStr = string.format("当前私有点数：%d 点\n当前挂载消耗：%d 点（点数充足）。起飞后余额：%d 点。\n%s", ps.point, cost, ps.point - cost, detail)
                else
                    loadoutStr = string.format("当前私有点数：%d 点\n当前挂载消耗：%d 点（点数不足）。请改用更便宜的挂载或等待补偿。\n%s", ps.point, cost, detail)
                end

                -- 机型玩法提示
                local function inList(tbl, name)
                    if not tbl then return false end
                    for _, v in ipairs(tbl) do if v == name then return true end end
                    return false
                end
                local unitType = unit:getTypeName()
                local desc = unit:getDesc() or {}
                local tipStr = ""
                if NPAircraftList and inList(NPAircraftList.superiorityFighter, unitType) then
                    tipStr = "制空/护航为主：携带空对空武器为核心，可兼顾轻型对地挂载；可通过 F10 呼叫轰炸机支援（消耗点数）。"
                elseif NPAircraftList and inList(NPAircraftList.lightFighter, unitType) then
                    tipStr = "多面手：可执行对空或对地任务，注意挂载消耗并与队友分工。"
                elseif NPAircraftList and inList(NPAircraftList.attacker, unitType) then
                    tipStr = "对地/近距支援：优先携带精确炸弹或对地导弹；配合轰炸/侦察清除防御。"
                elseif (NPAircraftList and inList(NPAircraftList.helicopter, unitType)) or desc.category == 1 then
                    tipStr = "直升机：支持吊运、救援、部署/拾取箱子与建造 FOB（使用 F10->运输&部署）。"
                else
                    if string.find(unitType, "C%-130") or string.find(unitType, "Transport") then
                        tipStr = "运输机：可参与吊运/运输任务，使用 F10->运输&部署 查询可用操作。"
                    else
                        tipStr = "部分飞机支持吊运/救援/呼叫轰炸机等功能，详见 F10 菜单。"
                    end
                end

                return tipStr, loadoutStr
            end)

            if ok then
                roleTip = tip
                loadoutInfo = s
            end
        end

        -- 倒计时段
        local countdownMsg = string.format("倒计时剩余 %d 秒，请在倒计时结束后再安全起飞。", math.ceil(remaining))

        -- 合并为单条消息：规则 / 分割线 / 玩法 / 分割线 / 挂载信息 / 分割线 / 倒计时
        local mergedMsg = table.concat({
            rulesMsg,
            "--------------------------------",
            roleTip,
            "--------------------------------",
            loadoutInfo,
            "--------------------------------",
            countdownMsg
        }, "\n")

        trigger.action.outTextForGroup(groupId, mergedMsg, 25, true)

        return timer.getTime() + 15
    else
        trigger.action.outTextForGroup(groupId, "倒计时结束，您现在可以安全起飞。", 30, true)

        return nil
    end
end
