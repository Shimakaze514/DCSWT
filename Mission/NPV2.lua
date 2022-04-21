--[[
    NP占点脚本 By 紫花
    依赖ctld和mist

 ]]

--TODO 选边限制
--TODO 螺旋桨转载货物
--TODO 无人机有bug
--TODO fob的击杀更新
--TODO 被回收的单位会复活
NP = {}

NP.Id = "NP - "

NP.Version = "20220417"

net.log("LOAD - NP core script version "..NP.Version ..", script by VL")

NP.RefreshTime = 10

NP.CaptureDistance = 100

-- debug level, specific to this module
NP.Debug = true
-- trace level, specific to this module
NP.Trace = true

NP.blueAWACS = "blueAWACS"
NP.blueAWACS2 = "blueAWACS2"
NP.redAWACS = "redAWACS"
NP.redAWACS2 = "redAWACS2"
NP.timeStartMissionF = 0
NP.AWACS_TankerRepawnTime = 7200
NP.timeStartBlueAWACS = 0
NP.timeStartRedAWACS = 0
NP.needrespawnAWACS = false

function NP.logError(message)
    env.info("[NP] Err: "  .. message)
end

function NP.logInfo(message)
    env.info("[NP] Info: "  .. message)
end

function NP.logDebug(message)
    if message and ctld.Debug then
        env.info("[NP] Dbg: "  .. message)
    end
end

function NP.logTrace(message)
    if message and ctld.Trace then
        env.info("[NP] Trace: "  .. message)
    end
end


function NP.capture(_args)
    NP.logDebug('进入cap函数')
    local _unit = _args[1]
    NP.logDebug('开始找最近的cc')
    local _closeEnough,_logistic=NP.closeEnoughFromEnemyLogisticZone(_unit)
    if _closeEnough == false then
        NP.logDebug('不够进')
        --TODO 这个无法通知到人
        --trigger.action.outTextForGroup(ctld.getGroupId(_unit), "你附近有敌方cc吗就想占领，等你开到cc脚下了再按啊~", 10)
        trigger.action.outText('操作地面单位的指挥官，在靠近敌方cc后再占领。如果你乱按这个按钮，整个服务器都会被这个消息吵到',10)
        return
    end

    NP.logDebug('开始从mist获取数据')
    local _logisticData = NP.getLogisticData(_logistic)
    local _side = _logistic:getCoalition()
    local oppsiteCountryID
    local oppsiteSide
    local oppsiteCountry
    local oppsiteCountrySide
    --TODO 抽象这里
    if _side==2 then
        oppsiteCountryID =country.id.AGGRESSORS
        oppsiteCountrySide="red"
        oppsiteSide=1
        oppsiteCountry=country.name[oppsiteCountryID]
    else
        oppsiteCountryID =country.id.USA
        oppsiteCountrySide="blue"
        oppsiteSide=2
        oppsiteCountry=country.name[oppsiteCountryID]
    end

    _logisticData.groupName=_logisticData.groupName.. ' '
    _logisticData.name=_logisticData.groupName
    _logisticData.groupId=ctld.getNextGroupId()
    --_logisticData.groupId=nil

    _logisticData.countryId= oppsiteCountryID
    _logisticData.country= oppsiteCountry
    _logisticData.coalitionId= oppsiteSide
    _logisticData.coalition= oppsiteCountrySide

    _logisticData.units[1].groupName=_logisticData.groupName
    _logisticData.units[1].unitName=_logisticData.units[1].unitName..' '
    _logisticData.units[1].unitId= ctld.getNextUnitId()
    --_logisticData.units[1].unitId= nil
    _logisticData.units[1].groupId= _logisticData.groupId

    _logisticData.units[1].countryId= oppsiteCountryID
    _logisticData.units[1].country= oppsiteCountry
    _logisticData.units[1].coalition= oppsiteCountrySide
    _logisticData.units[1].coalitionId= oppsiteSide

    --_logisticData.units[1].alt=_logisticData.units[1].alt-5 --TODO cc浮空
    NP.logDebug('_logistic:'..ctld.p(_logistic))
    NP.logDebug('_logisticData:'..ctld.formatTable(_logisticData))
    NP.logDebug('_unit:'..ctld.p(_unit))
    _logistic:destroy()--把老一边的cc做掉
    mist.dynAddStatic(_logisticData)--生成另一阵营的新cc，同一位置
    timer.scheduleFunction(dsave.recordAllCCsElements, nil, timer.getTime() + 10)
    table.insert(ctld.logisticUnits, _logisticData.units[1].unitName)--新的单位加到cc的白名单
    NP.setRelatedZone(_logisticData.groupName,_logisticData.units[1].coalition)
    --maybe Done 把离这个最近的zone，所关联的红蓝直升机的flag值设置，让上飞机权限翻转
    NP.logInfo("战区".._logisticData.groupName.."被"..oppsiteCountrySide.."占领")
    trigger.action.outText("战区".._logisticData.groupName.."被"..oppsiteCountrySide.."占领", 20)
end

function NP.setRelatedZone(groupName,coalition)
    local ccname
    for k,v in pairs(ctld.logisticUnits) do
        if string.find(groupName, v) ~= nil then
            ccname = v
            break
        end
    end
    if ccname == nil then
        NP.logError('[setRelatedZone] 在ctld.logisticUnits数据表中找不到对应的cc: '..groupName ..'| 阵营:'..coalition)
        return
    end
    if  Unitlist[ccname] == nil then
        NP.logError('[setRelatedZone] 在Unitlist.list数据表中找不到对应cc的数据: '.. ccname..'| 阵营:'..coalition)
        return
    end

    for _,_Unit in pairs(Unitlist[ccname][coalition]) do
        NP.logInfo('[setRelatedZone] 翻转直升机机位: |'.. _Unit..'| flag为0(true)')
        trigger.action.setUserFlag(_Unit, 0)
    end

    local oppsitecoalition
    if coalition == 'red' then
       oppsitecoalition = 'blue'
    else
       oppsitecoalition = 'red'
    end
    for _,_Unit in pairs(Unitlist[ccname][oppsitecoalition]) do
        NP.logInfo('[setRelatedZone] 翻转直升机机位: |'.. _Unit..'| flag为100(false)')
        trigger.action.setUserFlag(_Unit, 100)
    end

    NP.logInfo('[setRelatedZone] 翻转直升机机位权限完成: '.. ccname..'| 阵营:'..coalition)
end


function NP.getLogisticData(_logistic)
    for _, _group in pairs(mist.DBs.groupsByName) do
        for _key , _unitTable in pairs(_group.units) do
            if _unitTable.unitName==_logistic:getName() then
                return _group
            end
        end
    end
    return nil
end

function NP.closeEnoughFromEnemyLogisticZone(_unitObject)
    local _unitPoint = _unitObject:getPoint()

    local _closeEnough = false

    local _logistic
    for _, _name in pairs(ctld.logisticUnits) do
        _logistic = StaticObject.getByName(_name)
        if _logistic ~= nil and _logistic:getCoalition() ~= _unitObject:getCoalition()  then
            local _dist = ctld.getDistance(_unitPoint, _logistic:getPoint())
            if _dist <= NP.CaptureDistance then
                _closeEnough = true
                return _closeEnough,_logistic
            end
        end
    end

    return _closeEnough,_logistic
end


function NP.respawnAWACSOnlyFlanker()
    local timeGoesAWACSBlue = timer.getTime() - NP.timeStartBlueAWACS
    if timeGoesAWACSBlue > NP.AWACS_TankerRepawnTime then
        NP.blueAWACS = mist.respawnGroup(NP.blueAWACS, true).name
        NP.timeStartBlueAWACS = timer.getTime()
    end

    local timeGoesAWACSRed = timer.getTime() - NP.timeStartRedAWACS
    if timeGoesAWACSRed > NP.AWACS_TankerRepawnTime then
        NP.redAWACS = mist.respawnGroup(NP.redAWACS, true).name
        NP.timeStartRedAWACS = timer.getTime()
    end

    local timeGoesAWACSBlue = timer.getTime() - NP.timeStartBlueAWACS
    if timeGoesAWACSBlue > NP.AWACS_TankerRepawnTime then
        NP.blueAWACS2 = mist.respawnGroup(NP.blueAWACS2, true).name
        NP.timeStartBlueAWACS = timer.getTime()
    end

    local timeGoesAWACSRed = timer.getTime() - NP.timeStartRedAWACS
    if timeGoesAWACSRed > NP.AWACS_TankerRepawnTime then
        NP.redAWACS2 = mist.respawnGroup(NP.redAWACS2, true).name
        NP.timeStartRedAWACS = timer.getTime()
    end

    local AWACSBlueGroup = Group.getByName(NP.blueAWACS, NP.blueAWACS2)
    if AWACSBlueGroup ~= nil then
        local AWACSBlue = AWACSBlueGroup:getUnits()
        if AWACSBlue[1] ~= nil and AWACSBlue[1]:getLife() > 0 and AWACSBlue[1]:getPoint().y < 5000 then
            timer.scheduleFunction(
                    function(_args)
                        local _unit = Unit.getByName(_args[1])
                        if _unit ~= nil then
                            _unit:destroy()
                            NP.timeStartRedAWACS = timer.getTime() - (NP.AWACS_TankerRepawnTime - 600)
                            trigger.action.outText("蓝方预警机出现故障, 将在10分钟后重新上线", 20)
                        end
                    end,
                    {AWACSBlue[1]:getName()},
                    timer.getTime() + 60
            )
        end
    end

    local AWACSRedGroup = Group.getByName(NP.redAWACS, NP.redAWACS2)
    if AWACSRedGroup ~= nil then
        local AWACSRed = AWACSRedGroup:getUnits()
        if AWACSRed[1] ~= nil and AWACSRed[1]:getLife() > 0 and AWACSRed[1]:getPoint().y < 5000 then
            timer.scheduleFunction(
                    function(_args)
                        local _unit = Unit.getByName(_args[1])
                        if _unit ~= nil then
                            _unit:destroy()
                            NP.timeStartRedAWACS = timer.getTime() - (NP.AWACS_TankerRepawnTime - 600)
                            trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
                        end
                    end,
                    {AWACSRed[1]:getName()},
                    timer.getTime() + 60
            )
        end
    end
end
function NP.respawnTankerFlanker()
    local timeGoes, _ = math.fmod((timer.getTime() - NP.timeStartMissionF), NP.AWACS_TankerRepawnTime)
    if timeGoes < 10 then
        if NP.needrespawnTanker == false then
            NP.needrespawnTanker = true


            NP.blueAWACS = mist.respawnGroup(NP.blueAWACS, true).name
            NP.blueAWACS2 = mist.respawnGroup(NP.blueAWACS2, true).name

            NP.redAWACS = mist.respawnGroup(NP.redAWACS, true).name
            NP.redAWACS2 = mist.respawnGroup(NP.redAWACS2, true).name
            trigger.action.outText("加油机和预警机梯队没油了，后续梯队正在交接！", 10)
        end
    else
        NP.needrespawnTanker = false
    end
end

mist.scheduleFunction(NP.respawnTankerFlanker, {}, timer.getTime() + 300)
mist.scheduleFunction(NP.respawnAWACSOnlyFlanker, {}, timer.getTime() + 300)

net.log("LOAD SUCCESS - NP version "..NP.Version ..", script by VL")
