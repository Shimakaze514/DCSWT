SourceObj = SourceObj or {}
SourceObj.playerGroup = {}
SourceObj.playerUcidByGroup = {}
SourceObj.addedF10Menu = {}
SourceObj.pendingKillPoint = {}
-- SourceObj.killEnemy = 100
-- SourceObj.killFriend = -150
-- SourceObj.pilotDead = 150
SourceObj.addCrate = 50

dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceSystem/EventHandler.lua")
dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceSystem/F10Menu.lua")
dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceSystem/PlayerMessage.lua")
dofile(lfs.writedir() .. "Scripts/Source/Version3.0/Mission/SourceSystem/PointManager.lua")

SourceObj.onBirth = function(_unit)
    if _unit:getDesc().category ~= Unit.Category.AIRPLANE and
    _unit:getDesc().category ~= Unit.Category.HELICOPTER
    then return end
    local displayMsg = false
    local _typeName = _unit:getTypeName()
    if _typeName and AircraftPriceMap[_typeName] then
        displayMsg = true
    else
        env.info("[SourceObj.onBirth] 飞机不在价格表内，忽略资源系统")
        return
    end
    local _name = _unit:getPlayerName()
    if _name == nil then
        env.info("[SourceObj.onBirth] _unit:getPlayerName()无法获取玩家名字！")
        return
    end
    local _ucid = SourceObj.playerInfo[_name]
    if _ucid == nil then
        env.info("[SourceObj.onBirth] 玩家没有UCID！")
        return
    end
    local _groupId = SourceObj.getGroupId(_unit)
    if _groupId == nil then
        env.info("[SourceObj.onBirth] 玩家的unit没有GroupId！")
        return
    end

    SourceObj.playerGroup[_ucid] = _groupId
    SourceObj.playerUcidByGroup[_groupId] = _ucid
    SourceObj.addF10SourceMenu(_groupId,_unit,_ucid)

    SourceObj.playerSource[_ucid].birthTime = timer.getTime()

    timer.scheduleFunction(SourceObj.countdownMessage, {_ucid, _groupId}, timer.getTime() + 15)
end

env.info("资源系统事件处理加载完毕")