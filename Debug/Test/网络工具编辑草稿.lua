trigger.action.outText('加载成功(mission)', 10 , false)
--local staticObject = mist.makeUnitTable({'[static]'})
--local msg = ctld.p(ctld.)
--ctld.logError(msg)

--local msg = ctld.p(ctld.logisticUnits)
--ctld.logError(msg)

local _object=Object.getByName('logistic Blue #001-1-1')
local _cate= ctld.p(_object:getCategory())
--local msg = "cate".._cate
ctld.logError(_cate)

local _cate= ctld.p(ctld.jtacUnits)
ctld.logError(_cate)
_jtacUnit = Unit.getByName('Unpacked RQ-1A Predator #3')
local _cate= ctld.p(_jtacUnit)
ctld.logError(_cate)


ctld.listNearbyEnemies(_jtacUnit )


local _volume = {
    id = world.VolumeType.SPHERE,
    params = {
        point = _offsetJTACPos,
        radius = _maxDistance
    }
}


local _aliveGroupNum = 0
local _playerInfo=#ctld.UnitLimitPlayerInfo['BB']['步兵战车(IFV)']
local _category='步兵战车(IFV)'
for index, _groupName in pairs(_playerInfo[_category]) do
    local _group = Group.getByName(_groupName)
    local _groupAlive = false

    if _group ~= nil then
        local _units = _group:getUnits()
        if _units ~= nil and #_units > 0 then
            for x = 1, #_units do
                if _units[x]:getLife() > 0 then
                    _groupAlive = true
                end
            end
        end
    end

    if _groupAlive then
        _aliveGroupNum = _aliveGroupNum+1
    else
    end

end

for _, _group in pairs(mist.DBs.groupsByName) do
    local needSave = false
    for _key , _unitTable in pairs(_group.units) do
        if _unitTable.type~=nil and _unitTable.unitName~=nil and dsave.typeBelongsToCC(_unitTable.type) then
            local _unitObject = StaticObject.getByName(_unitTable.unitName)
            --dsave.logDebug("_unitObject"..ctld.formatTable(_unitObject))
            if _unitObject ~= nil and _unitObject:getLife() > 0 then
                needSave = true
                dsave.logDebug('_unitObject:getLife()'..ctld.formatTable(_unitTable))
            end
        end
    end
end


local _unitObject =StaticObject.getByName('logistic Blue #001-1-1`')
dsave.logDebug('_unitObject:getLife()'..ctld.formatTable(_unitObject))
dsave.logDebug('name'..ctld.formatTable(_unitObject:getName()))


for _, _name in pairs(ctld.logisticUnits) do
    local _logistic = StaticObject.getByName(_name)
    dsave.logDebug('_name'.._name)
    dsave.logDebug('name'..ctld.formatTable(_logistic))
    --if _logistic ~= nil and _logistic:getCoalition() == _heli:getCoalition() then
    --    local _dist = ctld.getDistance(_heliPoint, _logistic:getPoint())
    --    if _dist <= distance then
    --        _farEnough = false
    --    end
    --end
end



ctld.logTrace('_aliveGroupNum'.._aliveGroupNum)

local a =ctld.getGroupTemplate(ctld.RandomTankPool[math.random(#ctld.RandomTankPool)])
ctld.logInfo(ctld.formatTable(a))

local gp = mist.getCurrentGroupData('=CNF=011(BB) RQ-1A Predator  #2')
ctld.logTrace(ctld.p(gp))

local gp = mist.getCurrentGroupData('=CNF=011(BB) RQ-1A Predator #1')
gp.groupName= 'test'
gp.groupId= nil
gp.units[1].unitName= nil
gp.units[1].name= 'test'
--[[mist.dynAdd(gp)]]
coalition.addGroup(country.id.USA, Group.Category.AIRPLANE, gp)

--    .name=RQ-1A Predator group name #1
--        .groupId=1111
--.category=0
--.hidden=[false]
--.groupName=RQ-1A Predator group name #1
--.units=
--.1=
--    .alt=1998.5656157159
--    .point=
--    .y=683227.36406189
--    .x=-286740.98958442
--
--    .alt_type=BARO
--    .livery_id=USAF Standard
--    .onboard_num=010
--    .category=plane
--    .unitName=RQ-1A Predator pilot #1
--    .type=RQ-1A Predator
--    .country=usa
--    .psi=2.3229198981179
--    .groupId=1111
--    .groupName=RQ-1A Predator group name #1
--    .callsign=
--    .1=1
--    .2=1
--    .3=1
--    .name=Enfield11
--
--    .countryId=2
--    .x=-286740.98958442
--    .skill=High
--    .heading=3.9602552563917
--    .unitId=2164
--    .y=683227.36406189
--    .coalition=blue
--    .speed=32.297272058816
--
--
--.name==CNF=011(BB) Hummer  #2
--.groupId=7002
--.category=vehicle
--.hidden=[false]
--.groupName==CNF=011(BB) Hummer  #2
--.units=
--    .1=
--    .alt=43.29908743485
--    .point=
--    .y=683985.93750345
--    .x=-286388.12500386
--
--    .coalitionId=2
--    .skill=Excellent
--    .category=vehicle
--    .speed=5.8207660913467e-09
--    .heading=0.61947892294892
--    .country=cjtf_blue
--    .groupName==CNF=011(BB) Hummer  #2
--    .y=683985.93750345
--    .x=-286388.12500386
--    .coalition=blue
--    .type=Hummer
--    .groupId=7002
--    .unitId=7002
--    .unitName=Unpacked Hummer #3
--    .countryId=80
--

local staticObject = mist.makeUnitTable({'[static]'})
local msg = ctld.p(ctld.)
ctld.logError(msg)
--
--
--.1=
--.groupId=7001
--.coalitionId=2
--.hidden=[false]
--.groupName=悍马吉普 JTAC(侦察） #2
--.units=
--.1=
--.alt=43
--.point=
--.y=683981
--.x=-286393
--
--.coalitionId=2
--.mass=801
--.category=static
--.canCargo=[false]
--.shape_name=GeneratorF
--.heading=0
--.unitId=7001
--.groupName=悍马吉普 JTAC(侦察） #2
--.countryId=80
--.x=-286393
--.country=cjtf_blue
--.y=683981
--.type=GeneratorF
--.groupId=7001
--.coalition=blue
--.unitName=悍马吉普 JTAC(侦察） #2
--
--
--.countryId=80
--.coalition=blue
--.timeAdded=23449.79
--.category=static
--.country=cjtf_blue
--.startTime=0
--.name=悍马吉普 JTAC(侦察） #2
--.uncontrolled=[false]
--
--.2=
--.country=cjtf_blue
--.coalitionId=2
--.groupId=7002
--.hidden=[false]
--.units=
--.1=
--.alt=43
--.point=
--.y=683986
--.x=-286388
--
--.coalitionId=2
--.skill=Excellent
--.category=vehicle
--.speed=0
--.type=Hummer
--.groupId=7002
--.groupName=BB Hummer #2
--.countryId=80
--.x=-286388
--.y=683986
--.heading=0.61947905461399
--.country=cjtf_blue
--.unitName=Unpacked Hummer #3
--.unitId=7002
--.coalition=blue
--
--
--.countryId=80
--.name=BB Hummer #2
--.timeAdded=23459.19
--.category=vehicle
--.coalition=blue
--.startTime=0
--.task=
--
--.groupName=BB Hummer #2
--
--.3=
--.groupId=7003
--.coalitionId=2
--.hidden=[false]
--.groupName=悍马吉普 JTAC(侦察） #4
--.units=
--.1=
--.alt=43
--.point=
--.y=683981
--.x=-286393
--
--.coalitionId=2
--.mass=801
--.category=static
--.canCargo=[false]
--.shape_name=GeneratorF
--.heading=0
--.unitId=7003
--.groupName=悍马吉普 JTAC(侦察） #4
--.countryId=80
--.x=-286393
--.country=cjtf_blue
--.y=683981
--.type=GeneratorF
--.groupId=7003
--.coalition=blue
--.unitName=悍马吉普 JTAC(侦察） #4
--
--
--.countryId=80
--.coalition=blue
--.timeAdded=23596.79
--.category=static
--.country=cjtf_blue
--.startTime=0
--.name=悍马吉普 JTAC(侦察） #4
--.uncontrolled=[false]
--
--.4=
--.country=cjtf_blue
--.coalitionId=2
--.groupId=7004
--.hidden=[false]
--.units=
--.1=
--.alt=43
--.point=
--.y=683986
--.x=-286388
--
--.coalitionId=2
--.skill=Excellent
--.category=vehicle
--.speed=0
--.type=Hummer
--.groupId=7004
--.groupName=BB Hummer #3
--.countryId=80
--.x=-286388
--.y=683986
--.heading=0.61947905461399
--.country=cjtf_blue
--.unitName=Unpacked Hummer #5
--.unitId=7004
--.coalition=blue
--
--
--.countryId=80
--.name=BB Hummer #3
--.timeAdded=23601.59
--.category=vehicle
--.coalition=blue
--.startTime=0

local _jtacUnit = Group.getByName('悍马吉普 JTAC(')
local _cate= ctld.p(getCategory())

ctld.logTrace('ctld.p(mist.DBs.dynGroupsAdded)')
ctld.logTrace(ctld.p(mist.DBs.dynGroupsAdded))

local _jtacUnit = Group.getByName('悍马吉普 JTAC(')
local _cate= ctld.p(_jtacUnit :getCategory())
ctld.logTrace(ctld:printTable(_group ))

ctld.logInfo(ctld.formatTable(mist.DBs.dynGroupsAdded))
dsave.getAllElements(mist.DBs.groupsByName)

local logistic = StaticObject.getByName(_name)
local _logisticData = mist.getGroupData(_logistic:getGroup())
NP.logDebug('_logisticData : '..ctld.formatTable(_logisticData))


for _, _group in pairs(mist.DBs.groupsByName) do
for _key , _unitTable in pairs(_group.units) do
if _unitTable.type~=nil and _unitTable.unitName~=nil and NP.typeBelongsToCC(_unitTable.type) then
local _unitObject = Unit.getByName(_unitTable.unitName)
NP.logDebug('_unitObject : '..ctld.formatTable(_unitObject))
end
end

if needSave == true then
dsave.saveToCache(_group)
end
end

for _, _group in pairs(mist.DBs.groupsByName) do
    for _key , _unitTable in pairs(_group.units) do
        if _unitTable.type~=nil and _unitTable.unitName~=nil then
        local _unitObject = Unit.getByName(_unitTable.unitName)
        NP.logDebug('_unitObject : '..ctld.formatTable(_unitObject))
        end
    end
end
NP.logDebug(Unitlist.list['苏呼米前线CC']['red'])

for k,v in pairs(Unitlist.list['苏呼米前线CC']['red']) do
NP.logDebug(v)
end

for k,_Units in pairs(Unitlist.list['科尔奇前线CC']['blue']) do
NP.logDebug(_Units)
NP.logDebug(k)
    --for _,_unit in pairs(_Units) do
    --    NP.logDebug(ctld.p(_unit))
    --end
end

for _, _name in pairs(ctld.logisticUnits) do
local _logistic = StaticObject.getByName(_name)
if _logistic ~= nil and _logistic:getLife() > 0 then
NP.logDebug(ctld.p(_logistic))
end
end

NP.logDebug(trigger.action.getUserFlag('【科尔奇】雌鹿（对地+运输）B1-2'))
NP.logDebug(trigger.action.getUserFlag('【苏呼米】黑鲨（对地+运输）B1-2'))
NP.logDebug(ctld.formatTable(ctld.UnitLimitPlayerInfo))


--:["groupId"] = 2 ["coalitionId"] = 2, ["hidden"] = false, ["groupName"] = "logistic Blue #001-1-1`", ["units"] = { [1] = { ["alt"] = 44, ["point"] = { ["y"] = 684015, ["x"] = -286045, } ["categoryStatic"] = "Fortifications" ["coalitionId"] = 1 ["category"] = "static" ["unitName"] = "logistic Blue #001-1-1`" ["shape_name"] = "ComCenter" ["heading"] = 0 ["groupId"] = 2163, ["groupName"] = "logistic Blue #001-1-1", ["countryId"] = 80, ["x"] = -286045, ["country"] = "CJTF_BLUE", ["type"] = ".Command Center", ["y"] = 684015, ["coalition"] = "blue", ["unitId"] = 2, } } ["countryId"] = 80, ["coalition"] = "red", ["timeAdded"] = 23402.19, ["category"] = "static", ["country"] = "CJTF_BLUE", ["startTime"] = 0, ["name"] = "logistic Blue #001-1-1", ["uncontrolled"] = false,
if Unitlist['科尔奇前线CC']['ships']==nil then
    NP.logInfo('true')
end

NP.logInfo(Unitlist['科尔奇前线CC']['ships']==nil)
NP.logInfo('Unitlist[ccname][\'ships\']'..ctld.formatTable(Unitlist['科尔奇前线CC']['ships']))