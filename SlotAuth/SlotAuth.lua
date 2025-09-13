SLOT = SLOT or {}
SLOT.callbacks = SLOT.callbacks or {}

SLOT.FilePath = lfs.writedir() .. [[SourceData/]] .. '动态槽位限制.json'
SLOT.AuthDataCache = {}
SLOT.teamBalenceCoefficient = 0.25
SLOT.UseNewDynamicSystem = true
SLOT.LastSideSwitch = {}
SLOT.SideSwitchCooldown = 300

function SLOT.callbacks.onPlayerTryChangeSlot(playerID, side, slotID)
    local _side = side
    local _playerInfo = net.get_player_info(playerID)
    local _ucid = net.get_player_info(playerID , 'ucid')
    local sideAvail = SLOT.allowSideSwitch(side, playerID)
    --local balance = SLOT.teamBalance(_side, playerID)
    local balance = true
    local _slotID = slotID
    local slotAvail = SLOT.allowEnterSlotDynamic(playerID, _side, _slotID)

    SLOT.LastSideSwitch[_ucid] = SLOT.LastSideSwitch[_ucid] or {}

    if sideAvail == true and balance == true and slotAvail == true then
        if _playerInfo ~= nil and _playerInfo.side ~= side then
            if _side ~= 0 and SLOT.LastSideSwitch[_ucid].side ~= _side then
                SLOT.LastSideSwitch[_ucid].time = os.time()
                SLOT.LastSideSwitch[_ucid].side = _side
            end
        end
        net.log('[SLOTAUTH] 玩家 ' .. tostring(_playerInfo and _playerInfo.name or playerID) .. ' 成功切换至阵营 ' .. tostring(_side))
        return true
    end

    if SLOT.backDoor(playerID) then
        net.log('[SLOTAUTH] 玩家 ' .. tostring(_playerInfo and _playerInfo.name or playerID) .. ' 使用后门权限进入阵营 ' .. tostring(_side))
        net.send_chat_to('后门权限已启用', playerID)
        return true
    end
    net.log('[SLOTAUTH] 玩家 ' .. tostring(_playerInfo and _playerInfo.name or playerID) .. ' 切换阵营被拒绝，sideAvail=' .. tostring(sideAvail) .. ', balance=' .. tostring(balance) .. ', slotAvail=' .. tostring(slotAvail))
    
    local sideNames = { [1] = "红方", [2] = "蓝方" }
    local lastSwitchEntry = SLOT.LastSideSwitch[_ucid]
    local sideName = sideNames[(lastSwitchEntry and lastSwitchEntry.side) or _playerInfo.side] or "中立"
    local oppositeSideName = sideNames[ (_playerInfo and (_playerInfo.side == 1 and 2 or 1)) ] or "中立"
    local kickMsg
    local ChatMsg
    if sideAvail ~= true then
        local lastSwitch = lastSwitchEntry.time
        local allowedAt = lastSwitch + (SLOT.SideSwitchCooldown or 600)
        local at = os.date("*t", allowedAt)
        kickMsg = string.format(
            "你因在冷却期内频繁切换阵营而被踢出。你可以重新进入服务器并加入 %s 。若要切换至 %s ，请等待至 %d月%d日 %02d时%02d分%02d秒 之后再尝试。",
            sideName, oppositeSideName,
            at.month, at.day, at.hour, at.min, at.sec
        )              
        ChatMsg = string.format(
            "禁止在%d秒内频繁切换阵营！你可以重新加入 %s 。若要切换至 %s ，请等待至 %d月%d日 %02d时%02d分%02d秒 之后再尝试。",
            SLOT.SideSwitchCooldown,sideName, oppositeSideName,
            at.month, at.day, at.hour, at.min, at.sec
        )   
        net.send_chat_to(ChatMsg, playerID)
        net.log('[SLOTAUTH] 玩家 ' .. tostring(_playerInfo and _playerInfo.name or playerID) .. ' 被踢，信息是 ' .. kickMsg)
        
        --net.kick(playerID , kickMsg)
    elseif balance ~= true and _playerInfo.side ~= side then
        if side == 1 then 
            side = 2
        end
        sideName = sideNames[side]
        kickMsg = "由于人数不平衡，你需要加入 "..sideName.." 以获得最好的游戏体验。现在你可以重新加入服务器！你的跳边冷却已清空"
        SLOT.LastSideSwitch[_ucid] = nil
        ChatMsg = "由于人数不平衡，你需要加入 "..sideName.." 以获得最好的游戏体验。你的跳边冷却已清空"
        net.send_chat_to(ChatMsg, playerID)
        net.log('[SLOTAUTH] 玩家 ' .. tostring(_playerInfo and _playerInfo.name or playerID) .. ' 被踢，信息是 ' .. kickMsg)
        --net.kick(playerID , kickMsg)
    end
    
    net.force_player_slot(playerID, 0, '')
    return false
end


--[[ function SLOT.callbacks.onPlayerTryConnect(addr, name, ucid, playerId)
    --net.log('addr'..addr.."ucid"..ucid.."name"..name.."playerId"..playerId)
    if string.find(name, " ") ~= nil or string.find(name, "　") ~= nil then
    --if string.find(name, "　") ~= nil then
        return false, "ID不允许带空格"
    end

    return true
end ]]

function SLOT.callbacks.onPlayerDisconnect(playerId)
    local ucid = net.get_player_info(playerId, 'ucid')
    local entry = SLOT.LastSideSwitch[ucid]
    if entry and entry.time then
        local ts = entry.time
        local now = os.time()
        local ttl = SLOT.SideSwitchCooldown + 1
        if now - ts > ttl then
            SLOT.LastSideSwitch[net.get_player_info(playerId ,'ucid')] = nil
            net.log('[SLOTAUTH] 清理过期 LastSideSwitch 条目 for player ' .. net.get_player_info(playerId ,'ucid'))
        end
    end
end

function SLOT.callbacks.onPlayerTrySendChat(id, msg, all)
    if msg == 'refreshadmin' then
        net.log('SLOTAUTH 动态管理员信息加载完成')
        net.send_chat_to('SLOTAUTH 动态管理员信息加载完成', id)
        SLOT.AuthDataCache = SLOT.LoadFile(SLOT.FilePath)

        net.log('SLOTAUTH 管理员信息')
        for _role, _roleTable in pairs(SLOT.AuthDataCache) do
            net.log('------------载入角色' .. _role .. '-----------------------')
            for _ucid, extra in pairs(_roleTable) do
                net.log('载入ucid:' .. _ucid .. '| 玩家:' .. extra.ID)
            end
        end
    end
end

function SLOT.getFlagValue(_flag)
    local _status, _error = net.dostring_in('server', ' return trigger.misc.getUserFlag("' .. _flag .. '"); ')
    if not _status and _error then
        return tonumber(0)
    else
        --disabled
        return tonumber(_status)
    end
end

function SLOT.teamBalance(_side,_playerID)
    local Players = net.get_player_list()
    local _teamMap = {}
    _teamMap[1] = 0
    _teamMap[2] = 0

    for PlayerIDIndex, playerID in pairs(Players) do
        -- is player still in a valid slot
        local _playerDetails = net.get_player_info(playerID)
        if _playerDetails ~= nil and _playerDetails.side ~= 0 and _playerDetails.slot ~= "" and _playerDetails.slot ~= nil then
            _teamMap[_playerDetails.side] = _teamMap[_playerDetails.side] + 1
        end
    end

    local space = (_teamMap[1] + _teamMap[2]) * SLOT.teamBalenceCoefficient

    if _teamMap[1] + _teamMap[2]<5 then
        net.send_chat_to('总人数少，允许不平衡', _playerID)
        return true
    end
 
    local _playerDetails = net.get_player_info(_playerID)

    if _playerDetails.side ~= 0 then
        if _side == 1 and _playerDetails.side == 2 then
            if _teamMap[1] - _teamMap[2] + 2 > space then
                return false
            end
        elseif _side == 2  and _playerDetails.side == 1 then
            if _teamMap[2] - _teamMap[1] + 2 > space then
                return false
            end
        end
    elseif _playerDetails.side == 0 then
        if _side == 1 then
            if _teamMap[1] - _teamMap[2] + 1 > space then
                return false
            end
        elseif _side == 2 then
            if _teamMap[2] - _teamMap[1] + 1 > space then
                return false
            end
        end
    end

    return true
end

function SLOT.allowSideSwitch(side, playerID)
    local _playerInfo = net.get_player_info(playerID)
    if not _playerInfo then
        net.log('[SLOTAUTH] _playerInfo为空，检查SideSwitchCooldown失败 for player ' .. net.get_player_info(playerID ,'ucid'))
        return false
    end

    local ucid = net.get_player_info(playerID, 'ucid')
    local lastSwitchEntry = SLOT.LastSideSwitch[ucid]
    local lastSwitch = lastSwitchEntry and lastSwitchEntry.time or nil
    local lastSide   = lastSwitchEntry and lastSwitchEntry.side or nil
    local now = os.time()

    -- 如果没有历史切换记录、或当前是观战、或并不是真正切换阵营（去同一阵营），则允许
    if lastSwitch == nil or lastSide == nil or side == 0 or _playerInfo.side == side or lastSide == side then
        return true
    end

    local elapsed = now - lastSwitch
    if elapsed >= SLOT.SideSwitchCooldown then
        return true
    end

    local remaining = math.max(0, math.floor(SLOT.SideSwitchCooldown - elapsed))
    net.send_chat_to('切换阵营冷却中，请等待 ' .. remaining .. ' 秒', playerID)
    net.log('[SLOTAUTH] 玩家 ' .. _playerInfo.name .. ' 尝试切换阵营，但仍在冷却中（剩余 ' .. remaining .. ' 秒）')
    return false
end

function SLOT.backDoor(_playerID)
    return SLOT.findBackDoor(_playerID, net.get_player_info(_playerID, 'ucid'), SLOT.AuthDataCache.admin, 'instructor')
end

function SLOT.allowEnterSlotDynamic(_playerID, _side, _slotID)
    local _unitRole = DCS.getUnitType(_slotID)
    local _category = DCS.getUnitProperty(_slotID, DCS.UNIT_GROUPCATEGORY)
    local _groupName = DCS.getUnitProperty(_slotID, DCS.UNIT_GROUPNAME)
    local _unitName = DCS.getUnitProperty(_slotID, DCS.UNIT_NAME)
    local _ucid = net.get_player_info(_playerID, 'ucid')

    --TODO 检查教练机的flag
    if _unitRole ~= nil and _unitRole == 'instructor' then
        --游戏管理员
        return SLOT.findIDInTableDynamic(_playerID, _ucid, SLOT.AuthDataCache.admin, 'instructor')
    elseif _unitRole ~= nil and _unitRole == 'observer' then
        --观察员
        return SLOT.findIDInTableDynamic(_playerID, _ucid, SLOT.AuthDataCache.observer, 'observer')
    elseif _unitRole ~= nil and _unitRole == 'artillery_commander' then
        --CA
        return SLOT.findIDInTableDynamic(_playerID, _ucid, SLOT.AuthDataCache.commander, 'artillery_commander')
    else
        if SLOT.getFlagValue(_groupName) == 0 then
            return true
        else
            net.send_chat_to('该机位不可选', _playerID)
            return false
        end
    end

    return true
end

function SLOT.findIDInTableDynamic(_playerID, _inputUcid, table, commander)
    local allowed = false
    local info
    for _ucidValue, _extra in pairs(table) do
        if _ucidValue == _inputUcid then
            allowed = true
            info = _extra.comment
            break
        end
    end

    if allowed then
        return true
    elseif commander == 'instructor' or commander == 'observer' then
        net.send_chat_to('你没有选择这个位置的权限', _playerID)
        return false
    elseif commander == 'artillery_commander' then
        net.send_chat_to('你目前无权指挥联合武装单位。如果对CA和地面指挥感兴趣，可以向服务器Q群管理提出申请', _playerID)
        return false
    end
end

function SLOT.findBackDoor(_playerID, _inputUcid, table, commander)
    local allowed = false
    local info
    for _ucidValue, _extra in pairs(table) do
        if _ucidValue == _inputUcid then
            allowed = true
            info = _extra.comment
            break
        end
    end

    if allowed then
        return true
    else 
        return false
    end
end

function SLOT.SaveData(FilePath, data)
    local File = io.open(FilePath, 'w')
    if File then
        File:write(data)
        File:close()
    else
        net.log(FilePath .. '保存失败')
    end
end

function SLOT.CreatFile(FilePath)
    local File = io.open(FilePath, 'w')
    if File then
        local json = {}
        File:write(net.lua2json({}))
        File:close()
        File = nil
        net.log(FilePath .. '创建成功')
    else
        net.log(FilePath .. '创建失败')
    end
end

function SLOT.LoadFile(FilePath)
    local File = io.open(FilePath, 'r')
    if File then
        local FileText = File:read('*all')
        File:close()
        local status, retval = pcall(
                function()
                    return net.json2lua(FileText)
                end
        )
        if status and type(retval) == "table" then
            net.log(FilePath .. '加载成功')
            -- 确保基础字段存在
            retval.admin = retval.admin or {}
            retval.observer = retval.observer or {}
            retval.commander = retval.commander or {}
            return retval
        else
            net.log('数据格式错误,文件内容不是JSON格式，使用默认空权限表')
            -- 返回一个默认结构，避免上层 nil 问题
            return { admin = {}, observer = {}, commander = {} }
        end
    else
        net.log(FilePath .. '未找到,正在创建并返回默认权限表...')
        SLOT.CreatFile(FilePath) -- creates the file.
        return { admin = {}, observer = {}, commander = {} }
    end
end

--设置用户callbacs,使用上面定义的功能映射DCS事件处理程序
DCS.setUserCallbacks(SLOT.callbacks)
net.log('SLOTAUTH 回调设置完成')
SLOT.AuthDataCache = SLOT.LoadFile(SLOT.FilePath)
net.log('SLOTAUTH 动态槽位限制信息加载完成')
net.log('SLOTAUTH 权限脚本 加载完成')
net.log('SLOTAUTH v20230729rev4')