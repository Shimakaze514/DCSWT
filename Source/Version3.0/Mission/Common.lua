SourceObj = SourceObj or {}
SourceObj.playerInfo = {}
SourceObj.playerSource = {}
SourceObj.sourceInitPoint = 1000
SourceObj.sourceMaxPoint = 1000
SourceObj.recoverPoint = 200
SourceObj.realRecoverTime = 600
SourceObj.autoAddID = {}
-- SourceObj.landRecoverTime = 60 -- 以秒为单位
-- SourceObj.skyRecoverTime = 30 -- 以秒为单位
-- SourceObj.timeHasRun = 0

-- SourceObj.lua setUserCallbacks
SourceObj.updatePlayerInfo = function(_name, _ucid)
  SourceObj.playerInfo[_name] = _ucid
  SourceObj.playerSource[_ucid] = SourceObj.playerSource[_ucid] or {}
  if SourceObj.playerSource[_ucid]["point"] == nil then
    SourceObj.playerSource[_ucid]["point"] = SourceObj.sourceInitPoint
    SourceObj.SaveSourcePoint()
  end
  SourceObj.playerSource[_ucid]["name"] = _name
  SourceObj.autoAddID[_ucid] = timer.scheduleFunction(SourceObj.autoAddSourcePoint, _ucid, timer.getTime() + SourceObj.realRecoverTime)
  env.info("自动增加资源点计时器ID:" .. SourceObj.autoAddID[_ucid])
end
SourceObj.clearAutoAddSourcePoint = function(_ucid)
  timer.removeFunction(SourceObj.autoAddID[_ucid])
end
SourceObj.autoAddSourcePoint = function(_ucid, time)
  SourceObj.timeHasRun = time + SourceObj.realRecoverTime
  env.info("自动增加资源点执行时间: " .. timer.getTime() .. ",具有以下参数:" .. _ucid .. ",已经运行时间:" .. SourceObj.timeHasRun)
  if SourceObj.playerGroup[_ucid] then
    if SourceObj.playerSource[_ucid]["point"] and SourceObj.playerSource[_ucid]["point"] < SourceObj.sourceMaxPoint then
      SourceObj.playerSource[_ucid]["point"] = SourceObj.playerSource[_ucid]["point"] + SourceObj.recoverPoint
      SourceObj.SaveSourcePoint()
      local restored = string.format("执勤奖励%d资源点", SourceObj.recoverPoint)
      if SourceObj.playerSource[_ucid]["point"] > SourceObj.sourceMaxPoint then
        local countRestored = tostring(SourceObj.playerSource[_ucid]["point"] - SourceObj.sourceMaxPoint)
        restored = string.format("执勤奖励%d资源点", countRestored)
        SourceObj.playerSource[_ucid]["point"] = SourceObj.sourceMaxPoint
        SourceObj.SaveSourcePoint()
      end
      trigger.action.outTextForGroup(SourceObj.playerGroup[_ucid], restored, 10)
    end
  end
  return time + SourceObj.realRecoverTime
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
SourceObj.is_includeTable = function(value, tab)
  if tab then
    for k1, v1 in pairs(tab) do
      if type(v1) == "table" then
        for k2, v2 in pairs(v1) do
          if v2 == value then
            return true
          end
        end
      end
    end
  end
  return false
end

SourceObj.unitExplosion = function(_unit)
  if _unit ~= nil then
    local status, error =
      pcall(
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
SourceObj.AIM_54 = function(_unit, text)
  local _groupId = SourceObj.getGroupId(_unit)
  trigger.action.outTextForGroup(_groupId, text, 10)
  timer.scheduleFunction(SourceObj.unitExplosion, _unit, timer.getTime() + 10)
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
SourceObj.getSourceObjChange = function(_unit)
  local sourcePointChange = 0
  local _unitType = _unit:getTypeName()
  -------------------------------------------机型点数----------------------------------------
  if SourceObj.is_include(_unitType, Aircraft.superiorityFighter) then
    sourcePointChange = sourcePointChange + Aircraft.superiorityFighterPoint
  elseif SourceObj.is_include(_unitType, Aircraft.lightFighter) then
    sourcePointChange = sourcePointChange + Aircraft.lightFighterPoint
  elseif SourceObj.is_include(_unitType, Aircraft.attacker) then
    sourcePointChange = sourcePointChange + Aircraft.attackerPoint
  elseif SourceObj.is_include(_unitType, Aircraft.helicopter) then
    sourcePointChange = sourcePointChange + Aircraft.helicopterPoint
  end
  -------------------------------------------武器点数----------------------------------------
  local countInfo = {}
  if _unit:getAmmo() ~= nil then
    for i = 1, #_unit:getAmmo() do
      local ammo = _unit:getAmmo()[i]
      if ammo.desc and ammo.desc.typeName then
        local typeName = ammo.desc.displayName

        if SourceObj.is_include(typeName, Weapon.ATA_One) then
          sourcePointChange = sourcePointChange + Weapon.ATA_OnePoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.ATA_Two) then
          sourcePointChange = sourcePointChange + Weapon.ATA_TwoPoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.ATA_Three) then
          sourcePointChange = sourcePointChange + Weapon.ATA_ThreePoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.ATA_Four) then
          sourcePointChange = sourcePointChange + Weapon.ATA_FourPoint * ammo.count

        --elseif SourceObj.is_include(typeName, Weapon.ATA_Zero) then
          --sourcePointChange = sourcePointChange + Weapon.ATA_ZeroPoint * ammo.count        ----AA弹平衡性调整

        end
        if SourceObj.is_include(typeName, Weapon.ATG_One) then
          sourcePointChange = sourcePointChange + Weapon.ATG_OnePoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.ATG_Two) then
          sourcePointChange = sourcePointChange + Weapon.ATG_TwoPoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.ATG_Three) then
          sourcePointChange = sourcePointChange + Weapon.ATG_ThreePoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.ATG_Zero) then                        ---------临时限制
          sourcePointChange = sourcePointChange + Weapon.ATG_ZeroPoint * ammo.count
        end
        if SourceObj.is_include(typeName, Weapon.ATGPod) then
          sourcePointChange = sourcePointChange + Weapon.ATGPodPoint * ammo.count
        elseif SourceObj.is_include(typeName, Weapon.mailbox) then
          sourcePointChange = sourcePointChange + Weapon.mailboxPoint * ammo.count
        end
         --[[if ammo.desc.typeName == "ADM_141A"  then
           local text = string.format("你携带了ADM-141A空射诱饵（将会导致服务器bug）, 马上就爆炸了~BOOM")
           SourceObj.AIM_54(_unit, text)
         end]]

        if SourceObj.is_includeTable(typeName, Weapon) then
          countInfo[i] = {["挂载"] = ammo.desc.displayName, ["数量"] = ammo.count}
          --countInfo[i] = {displayName = ammo.desc.displayName, count = ammo.count}
        end
      end
    end
  -- SaveData.WeaponData(SourceObj.JSON:encode(countInfo) .. '\n')
  end

  return sourcePointChange, SourceObj.JSON:encode(countInfo)
end

env.info("公用工具已添加")



