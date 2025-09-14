SourceObj = SourceObj or {}
SourceObj.playerInfo = {}
SourceObj.playerSource = {}
SourceObj.sourceInitPoint = 1500 --初始资源点
SourceObj.sourceMaxPoint = 3000 --资源点上限
SourceObj.recoverPoint = 500 --低保的阈值，以及低保指标
SourceObj.realRecoverTime = 300
SourceObj.autoAddID = {}
-- SourceObj.landRecoverTime = 60 -- 以秒为单位
-- SourceObj.skyRecoverTime = 30 -- 以秒为单位
-- SourceObj.timeHasRun = 0

-- SourceObj.lua setUserCallbacks
SourceObj.updatePlayerInfo = function(_name, _ucid)
    SourceObj.playerInfo[_name] = _ucid
    SourceObj.playerSource[_ucid] = SourceObj.playerSource[_ucid] or {}

    if SourceObj.playerSource[_ucid].point == nil then
        SourceObj.playerSource[_ucid].point = SourceObj.sourceInitPoint
        SourceObj.SaveSourcePoint()
    end

    if SourceObj.autoAddID[_ucid] == nil then
        SourceObj.playerSource[_ucid].name = _name
        SourceObj.autoAddID[_ucid] = timer.scheduleFunction(SourceObj.autoAddSourcePoint, {_ucid,_name}, timer.getTime() + SourceObj.realRecoverTime)
        env.info("增加资源点自动任务，玩家:" .. _name .. ",  函数id:" .. SourceObj.autoAddID[_ucid])
    end

end
SourceObj.clearAutoAddSourcePoint = function(_ucid)
    env.info("取消资源点自动任务，id:"..SourceObj.autoAddID[_ucid])
    timer.removeFunction(tonumber(SourceObj.autoAddID[_ucid]))
    SourceObj.autoAddID[_ucid]=nil
end
SourceObj.autoAddSourcePoint = function(_args, time)
    local _ucid = _args[1]
    local _name = _args[2]

    local msg = ""
    if SourceObj.playerSource[_ucid].point and SourceObj.playerSource[_ucid].point < SourceObj.recoverPoint then
        SourceObj.playerSource[_ucid].point = SourceObj.recoverPoint
        --SourceObj.SaveSourcePoint()
        msg = string.format("触发低保，恢复到%d资源点", SourceObj.recoverPoint)
    end
    if SourceObj.playerSource[_ucid].point > SourceObj.sourceMaxPoint then
        SourceObj.playerSource[_ucid].point = SourceObj.sourceMaxPoint
        --SourceObj.SaveSourcePoint()
        msg = string.format("资源点到达上限，恢复到%d资源点", SourceObj.sourceMaxPoint)
    end

    if SourceObj.playerGroup[_ucid] and msg ~= "" then
        trigger.action.outTextForGroup(SourceObj.playerGroup[_ucid], msg, 10)
    end
    env.info("执行资源点平衡,msg:"..msg..",name:".._name)
    SourceObj.autoAddID[_ucid] = timer.scheduleFunction(SourceObj.autoAddSourcePoint, {_ucid,_name}, timer.getTime() + SourceObj.realRecoverTime)
end

SourceObj.is_include = function(value, tab)
    if tab then
        for k, v in pairs(tab) do
            if v == value then
                return true
            end
        end
    end
    return false
end

SourceObj.unitExplosion = function(_unit)
    if _unit ~= nil then
        local status, error = pcall(
                function(_unit)
                    _unit:getPoint()
                end,
                _unit
        )
        if status then
            trigger.action.explosion(_unit:getPoint(), 100)
        else
            env.error('资源点处理错误:unitExplosion->:' .. SourceObj.JSON:encode(_unit) .. ',' .. error)
        end
    end
end

SourceObj.getGroupId = function(_unit)
    local clientGroupId = _unit.getGroup(_unit):getID()
    if clientGroupId ~= nil then
        return clientGroupId
    end
    return nil
end

SourceObj.getSourceKillChange = function(_unit)
    local sourcePointChange = 0
    if _unit:getDesc().category == 0 then
        sourcePointChange = Category.AIRPLANE
    elseif _unit:getDesc().category == 1 then
        sourcePointChange = Category.HELICOPTER
    elseif _unit:getDesc().category == 2 then
        sourcePointChange = Category.GROUND_UNIT
    elseif _unit:getDesc().category == 3 then
        sourcePointChange = Category.SHIP
    end
    return sourcePointChange
end

local function strDisplayLen(str)
    local len = 0
    for uchar in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        if #uchar == 1 then
            len = len + 1 -- 英文/符号
        else
            len = len + 2 -- 中文
        end
    end
    return len
end

-- 左对齐填充到指定宽度
local function padRight(str, width)
    local len = strDisplayLen(str)
    if len < width then
        return str .. string.rep(" ", width - len)
    else
        return str
    end
end

SourceObj.getSourceObjChange = function(_unit)
    local countInfo = {}
    local sourcePointChange = 0
    local _unitType = _unit:getTypeName()
    local planePoint = 0

    -------------------------------------------机型点数----------------------------------------
    planePoint = AircraftPriceMap[_unitType] or 0
    sourcePointChange = sourcePointChange + planePoint
    countInfo[1] = { ["飞机花费"] = planePoint }

    -------------------------------------------武器点数----------------------------------------
    local AmmoInfo = _unit:getAmmo()
    if AmmoInfo ~= nil then
        for i = 1, #AmmoInfo do
            local ammo = AmmoInfo[i]
            if ammo.desc and ammo.desc.typeName then
                local typeName = string.match(ammo.desc.typeName, "[^.]+$")
                local ammoPoint = 0
                ammoPoint = WeaponPriceMap[typeName] or 0
                env.info("[AmmoInfo] 单位 ".._unitType.." 挂载了 "..typeName.." , 消耗点数"..ammoPoint)

                if ammoPoint > 0 then
                    sourcePointChange = sourcePointChange + ammoPoint * ammo.count
                    countInfo[#countInfo + 1] = {
                        ["挂载"] = ammo.desc.displayName,
                        ["单价"] = ammoPoint,
                        ["数量"] = ammo.count
                    }
                end
            end
        end
        -- SaveData.WeaponData(SourceObj.JSON:encode(countInfo) .. '\n')
    end
        ---------------------- 格式化输出 ----------------------
    local prettyStr = "\n========= 出击消耗明细 =========\n"
    for i, item in ipairs(countInfo) do
        if item["飞机花费"] then
            prettyStr = prettyStr .. string.format("飞机花费: %d 分\n", item["飞机花费"])
        elseif item["挂载"] then
            prettyStr = prettyStr .. string.format("挂载: %s | 单价: %3d | 数量: %2d | 小计: %4d\n",
            padRight(item["挂载"], 20), item["单价"], item["数量"], item["单价"] * item["数量"])
        end
    end
    prettyStr = prettyStr .. "--------------------------------\n"
    prettyStr = prettyStr .. string.format("合计消耗: %d 分\n", sourcePointChange)
    prettyStr = prettyStr .. "================================\n"

    return sourcePointChange, prettyStr
end

SourceObj.getLoadout = function(_args)
    local groupId = _args[1]
    local unit = _args[2]
    if not unit then return end
    local ucid = _args[3]
    if not ucid then return end

    local ps = SourceObj.playerSource[ucid]
    if not ps or not ps.point then
        return
    end

    local cost, detail = SourceObj.getSourceObjChange(unit)

    local ruleMsg = "\n========= 挂载规则 =========\n" ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("制空战斗机", 16), Aircraft.superiorityFighterPoint,
                        padRight("轻型战斗机", 16), Aircraft.lightFighterPoint) ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("对地攻击机", 16), Aircraft.attackerPoint,
                        padRight("直升机", 16), Aircraft.helicopterPoint) ..
                    "--------------------------------\n" ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("现代主动弹", 16), Weapon.AA_newARHPoint, 
                        padRight("老旧主动弹", 16), Weapon.AA_oldARHPoint) ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("半主动弹", 16), Weapon.AA_SARHPoint,
                        padRight("现代红外弹", 16), Weapon.AA_newIRPoint) ..
                    string.format("%s %4s\n", 
                        padRight("老旧红外弹", 16), Weapon.AA_oldIRPoint) ..
                    "--------------------------------\n" ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("对地导弹", 16), Weapon.AG_SmartMissilePoint, 
                        padRight("精确炸弹", 16), Weapon.AG_SmartBombPoint) ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("激光炸弹", 16), Weapon.AG_LaserPoint, 
                        padRight("无制导炸弹", 16), Weapon.AG_DumbPoint) ..
                    "--------------------------------\n" ..
                    string.format("%s %4s    %s %4s\n", 
                        padRight("吊舱", 16), Weapon.ATGPodPoint, 
                        padRight("副油箱", 16), Weapon.mailboxPoint)

    local finalMsg = ruleMsg .. detail ..
                     string.format("你的当前资源点数: %d\n", ps.point)

    if ps.point >= cost then
        finalMsg = finalMsg .. "点数充足，可以起飞！"
    else
        finalMsg = finalMsg .. string.format("点数不足，需要 %d 点，当前仅有 %d 点。请使用更便宜的挂载！",
                                             cost, ps.point)
    end

    trigger.action.outTextForGroup(groupId, finalMsg, 30, true)
end

env.info("公用工具已添加")



