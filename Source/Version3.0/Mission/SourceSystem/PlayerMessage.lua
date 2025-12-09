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
            "【服务器核心规则】",
            "1. [出生/起飞]: 出生后有120秒冷却，期间请勿起飞。若误操作起飞，请在15秒内降落，否则飞机将自毁。",
            "2. [私有资源点]: 每次起飞会根据挂载消耗资源点。安全降落后，未使用的武器资源将返还。",
            "3. [获取资源]: 可通过击杀敌军、完成吊运/救援任务或等待系统低保（每5分钟400点）来获得资源点。",
            "4. [特殊任务]: 战斗机可挂载吊舱侦察后在F10地图标圈，并消耗点数呼叫AI轰炸机; 直升机与运输机可执行地面单位部署任务。",
            "5. [物资部署]: 指挥中心(CC)旁有大小圈标识(详见F10地图)。请在小圈内呼叫箱子,并吊运至大圈外展开部署。",
            "6. [查询与规划]: 起飞前，请查看挂载信息，检查开销，避免因点数不足导致起飞后飞机自毁。",
            "7. [阵亡惩罚]: 若在任务中被击落或阵亡，本次任务中积累的未结算击杀奖励将减半。",
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
                    loadoutStr = string.format("【当前挂载开销】\n当前私有点数: %d\n本次挂载消耗: %d (点数充足)\n起飞后预计剩余: %d %s", ps.point, cost, ps.point - cost, detail)
                else
                    loadoutStr = string.format("【当前挂载开销】\n当前私有点数: %d\n本次挂载消耗: %d (点数不足!)\n\n[警告] 请更换便宜的挂载方案，或等待资源点补充，否则强行起飞将在10秒后自毁！ %s", ps.point, cost, detail)
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
                    tipStr = "【本机玩法提示】\n定位: [制空战斗机]\n任务: 夺取空中优势、为友军护航。建议携带空对空导弹。\n你可以通过 F10 菜单呼叫AI轰炸机来打击地面目标。"
                elseif NPAircraftList and inList(NPAircraftList.lightFighter, unitType) then
                    tipStr = "【本机玩法提示】\n定位: [多用途战斗机]\n任务: 可执行对空或对地打击，请根据战局需要合理选择挂载，与队友协同作战。\n你可以通过 F10 菜单呼叫AI轰炸机来打击地面目标。"
                elseif NPAircraftList and inList(NPAircraftList.attacker, unitType) then
                    tipStr = "【本机玩法提示】\n定位: [攻击机]\n任务: 摧毁地面/海面目标。请携带炸弹或对地导弹，与执行制空任务的队友保持沟通。\n你可以通过 F10 菜单呼叫AI轰炸机来打击地面目标。"
                elseif (NPAircraftList and inList(NPAircraftList.helicopter, unitType)) or desc.category == 1 then
                    tipStr = "【本机玩法提示】\n定位: [直升机]\n任务: 可以进行对地攻击，也可以运输与救援。\n使用 F10 -> [运输&部署] 菜单呼叫箱子，部署防空、火炮和FOB等地面单位，为团队获取地面和低空优势。"
                else
                    if string.find(unitType, "C%-130") or string.find(unitType, "Transport") then
                        tipStr = "【本机玩法提示】\n定位: [运输机]\n任务: 通过 F10 -> [运输&部署] 菜单执行大规模物资运输任务。"
                    else
                        tipStr = "【本机玩法提示】\n玩法多样，请打开 F10 菜单探索本机支持的特殊功能（如呼叫轰炸机、运输等）。"
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
        local countdownMsg = string.format("%d 秒后可安全起飞，祝您武运昌隆！", math.ceil(remaining))

        -- 合并为单条消息：规则 / 分割线 / 玩法 / 分割线 / 挂载信息 / 分割线 / 倒计时
        -- local mergedMsg = table.concat({
        --     rulesMsg,
        --     "================================",
        --     roleTip,
        --     "================================",
        --     loadoutInfo,
        --     countdownMsg
        -- }, "\n")

        trigger.action.outTextForGroup(groupId, rulesMsg, 25, false)
        trigger.action.outTextForGroup(groupId, roleTip, 25, false)
        trigger.action.outTextForGroup(groupId, loadoutInfo, 25, false)
        trigger.action.outTextForGroup(groupId, countdownMsg, 25, false)

        return timer.getTime() + 15
    else
        trigger.action.outTextForGroup(groupId, "倒计时结束，您现在可以安全起飞。", 30, true)

        return nil
    end
end
