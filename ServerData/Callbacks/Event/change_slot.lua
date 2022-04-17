ServerData.onEvent.change_slot = function(eventName, playerID, arg2, arg3, arg4, arg5, arg6, arg7)
  --net.log("onEvent.change_slot eventName"..eventName)
  --net.log("onEvent.change_slot playerID"..playerID)
  --net.log("onEvent.change_slot arg2"..arg2)
  --net.log("onEvent.change_slot arg3"..arg3)
  --
  --local _side=arg3
  --local _slotID=arg2
  --
  --local result=ServerData.allowEnterSlot(playerID,_side,_slotID)
  --if result==nil or result ==false then
  --  return false
  --end

  local _master_type, _master_slot, _sub_slot = ServerData.GetMulticrewAllParameters(playerID)
  if _sub_slot == nil then
    _sub_slot = ''
  else
    _sub_slot = ' (' .. _sub_slot .. ')  '
  end
  local ucid = net.get_player_info(playerID, 'ucid')
  local name = net.get_player_info(playerID, 'name')
  ServerData.LogStatsCount(playerID, 'init')
  ServerData.PlayersTableCache['p' .. playerID] = net.get_player_info(playerID)
  local content = ServerData.SideID2Name(net.get_player_info(playerID, 'side')) .. '玩家' .. name .. '更换' .. _master_type .. _sub_slot

  ServerData.LogEvent(eventName, ucid, name, content)
end


function ServerData.allowEnterSlot (_playerID,_side,_slotID)
  local _unitRole = DCS.getUnitType(_slotID)
--1 blue
  local _category = DCS.getUnitProperty(_slotID, DCS.UNIT_GROUPCATEGORY)
  local _unitName = DCS.getUnitProperty(_slotID, DCS.UNIT_NAME)
  local _unit =Unit.getByName(_unitName)

--TODO
  if _category ~= nil and _category=='helicopter' then
    if _unit == nil then
      return false
    end

    local ok = ServerData.closeEnoughFromLogisticZone(_unit)

  end

  local UnitSide  = DCS.getUnitProperty(_slotID, DCS.UNIT_COALITION)



  if _unitRole ~= nil and _unitRole == "instructor" then

  end


end

function ServerData.closeEnoughFromLogisticZone(_unitObject)
  local _unitPoint = _unitObject:getPoint()

  local _closeEnough = false

  local _logistic
  for _, _name in pairs(ctld.logisticUnits) do
    _logistic = StaticObject.getByName(_name)
    if _logistic ~= nil and _logistic:getCoalition() == _unitObject:getCoalition()  then
      net.log("onEvent.change_slot _logistic".._logistic)
      net.log("onEvent.change_slot _unitObject".._unitObject)
      local _dist = ctld.getDistance(_unitPoint, _logistic:getPoint())
      if _dist <= 5000 then
        _closeEnough = true
        return _closeEnough,_logistic
      end
    end
  end

  return _closeEnough,_logistic
end