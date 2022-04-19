ServerData.onEvent.change_slot = function(eventName, playerID, arg2, arg3, arg4, arg5, arg6, arg7)
  --net.log("onEvent.change_slot eventName"..eventName)
  --net.log("onEvent.change_slot playerID"..playerID)
  --net.log("onEvent.change_slot arg2"..arg2)
  --net.log("onEvent.change_slot arg3"..arg3)
  --
  local _side=arg3
  local _slotID=arg2
  net.log('进入回调函数，准备进入allwo')
  local result=ServerData.allowEnterSlot(playerID,_side,_slotID)
  if result==nil or result ==false then
    return false
  end

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

--TODO
  if _category ~= nil and _category=='helicopter' then
    if ServerData.getFlagValue(_unitName) == 0 then
      return true
    else
      return false
    end
  end


end

function ServerData.getFlagValue(_flag)
  local _status, _error = net.dostring_in("server", ' return trigger.misc.getUserFlag("' .. _flag .. '"); ')
  net.log('[getFlagValue] _status'.._status)
  if _error then
    net.log('[getFlagValue] _error true')
  else
    net.log('[getFlagValue] _error false')
  end

  if not _status and _error then
    return tonumber(0)
  else
    --disabled
    return tonumber(_status)
  end
end