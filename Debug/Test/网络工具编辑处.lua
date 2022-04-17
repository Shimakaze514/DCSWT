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


local gp = mist.getCurrentGroupData('=CNF=011(BB) RQ-1A Predator  #2')
ctld.logTrace(ctld.p(gp))

local gp = mist.getCurrentGroupData('=CNF=011(BB) RQ-1A Predator #1')
gp.groupName= 'test'
gp.groupId= nil
gp.units[1].unitName= nil
gp.units[1].name= 'test'
--[[mist.dynAdd(gp)]]
coalition.addGroup(country.id.USA, Group.Category.AIRPLANE, gp)

    .name=RQ-1A Predator group name #1
        .groupId=1111
.category=0
.hidden=[false]
.groupName=RQ-1A Predator group name #1
.units=
.1=
    .alt=1998.5656157159
    .point=
    .y=683227.36406189
    .x=-286740.98958442

    .alt_type=BARO
    .livery_id=USAF Standard
    .onboard_num=010
    .category=plane
    .unitName=RQ-1A Predator pilot #1
    .type=RQ-1A Predator
    .country=usa
    .psi=2.3229198981179
    .groupId=1111
    .groupName=RQ-1A Predator group name #1
    .callsign=
    .1=1
    .2=1
    .3=1
    .name=Enfield11

    .countryId=2
    .x=-286740.98958442
    .skill=High
    .heading=3.9602552563917
    .unitId=2164
    .y=683227.36406189
    .coalition=blue
    .speed=32.297272058816


.name==CNF=011(BB) Hummer  #2
.groupId=7002
.category=vehicle
.hidden=[false]
.groupName==CNF=011(BB) Hummer  #2
.units=
    .1=
    .alt=43.29908743485
    .point=
    .y=683985.93750345
    .x=-286388.12500386

    .coalitionId=2
    .skill=Excellent
    .category=vehicle
    .speed=5.8207660913467e-09
    .heading=0.61947892294892
    .country=cjtf_blue
    .groupName==CNF=011(BB) Hummer  #2
    .y=683985.93750345
    .x=-286388.12500386
    .coalition=blue
    .type=Hummer
    .groupId=7002
    .unitId=7002
    .unitName=Unpacked Hummer #3
    .countryId=80


local staticObject = mist.makeUnitTable({'[static]'})
local msg = ctld.p(ctld.)
ctld.logError(msg)


.1=
.groupId=7001
.coalitionId=2
.hidden=[false]
.groupName=悍马吉普 JTAC(侦察） #2
.units=
.1=
.alt=43
.point=
.y=683981
.x=-286393

.coalitionId=2
.mass=801
.category=static
.canCargo=[false]
.shape_name=GeneratorF
.heading=0
.unitId=7001
.groupName=悍马吉普 JTAC(侦察） #2
.countryId=80
.x=-286393
.country=cjtf_blue
.y=683981
.type=GeneratorF
.groupId=7001
.coalition=blue
.unitName=悍马吉普 JTAC(侦察） #2


.countryId=80
.coalition=blue
.timeAdded=23449.79
.category=static
.country=cjtf_blue
.startTime=0
.name=悍马吉普 JTAC(侦察） #2
.uncontrolled=[false]

.2=
.country=cjtf_blue
.coalitionId=2
.groupId=7002
.hidden=[false]
.units=
.1=
.alt=43
.point=
.y=683986
.x=-286388

.coalitionId=2
.skill=Excellent
.category=vehicle
.speed=0
.type=Hummer
.groupId=7002
.groupName=BB Hummer #2
.countryId=80
.x=-286388
.y=683986
.heading=0.61947905461399
.country=cjtf_blue
.unitName=Unpacked Hummer #3
.unitId=7002
.coalition=blue


.countryId=80
.name=BB Hummer #2
.timeAdded=23459.19
.category=vehicle
.coalition=blue
.startTime=0
.task=

.groupName=BB Hummer #2

.3=
.groupId=7003
.coalitionId=2
.hidden=[false]
.groupName=悍马吉普 JTAC(侦察） #4
.units=
.1=
.alt=43
.point=
.y=683981
.x=-286393

.coalitionId=2
.mass=801
.category=static
.canCargo=[false]
.shape_name=GeneratorF
.heading=0
.unitId=7003
.groupName=悍马吉普 JTAC(侦察） #4
.countryId=80
.x=-286393
.country=cjtf_blue
.y=683981
.type=GeneratorF
.groupId=7003
.coalition=blue
.unitName=悍马吉普 JTAC(侦察） #4


.countryId=80
.coalition=blue
.timeAdded=23596.79
.category=static
.country=cjtf_blue
.startTime=0
.name=悍马吉普 JTAC(侦察） #4
.uncontrolled=[false]

.4=
.country=cjtf_blue
.coalitionId=2
.groupId=7004
.hidden=[false]
.units=
.1=
.alt=43
.point=
.y=683986
.x=-286388

.coalitionId=2
.skill=Excellent
.category=vehicle
.speed=0
.type=Hummer
.groupId=7004
.groupName=BB Hummer #3
.countryId=80
.x=-286388
.y=683986
.heading=0.61947905461399
.country=cjtf_blue
.unitName=Unpacked Hummer #5
.unitId=7004
.coalition=blue


.countryId=80
.name=BB Hummer #3
.timeAdded=23601.59
.category=vehicle
.coalition=blue
.startTime=0
.task=

.groupName=BB Hummer #3
_jtacUnit = Group.getByName('悍马吉普 JTAC(')
local _cate= ctld.p(:getCategory())

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
local needSave = false
for _key , _unitTable in pairs(_group.units) do
if _unitTable.type~=nil and _unitTable.unitName~=nil and NP.typeBelongsToCC(_unitTable.type) then
local _unitObject = Unit.getByName(_unitTable.unitName)
NP.logDebug('_unitObject : '..ctld.formatTable(_unitObject))
if _unitObject ~= nil and _unitObject:getLife() > 0 then
needSave = true
end
end
end

if needSave == true then
dsave.saveToCache(_group)
end
end