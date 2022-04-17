flankerObj = {}

net.log("Loading - SIMPLE SLOT BLOCK modified by Flanker")

------------------------------------------------code by violet------------------------------------------------
local count = {}
--numbers of players
count.total = 0
count.red = 0
count.blue = 0
local Fix = {}
Fix.red = 0
Fix.blue = 0
local balance = {}
balance.leastworknumber = 5 --代码开始生效的红蓝双方最小人数和
balance.gate1 = 10 --红蓝总人数的阈值
balance.gate2 = 15
balance.gate3 = 20
balance.gate4 = 25
balance.gate5 = 30
balance.gate6 = 35
balance.gate7 = 40
balance.diff1 = 2 --阈值对应的红蓝最大人数差距
balance.diff2 = 3
balance.diff3 = 4
balance.diff4 = 5
balance.diff5 = 5
balance.diff6 = 5
balance.diff7 = 5
local Heli = {}
Heli.red = 0
Heli.blue = 0
local AC = {}
AC.red = 0
AC.blue = 0

------------------------------------------------Net infomation recorder------------------------------------------------

------------------------------------------------Life limitation system-------------------------------------------------
flankerObj.playerInfo = {}

function flankerObj.onGameEvent(eventName, arg1, arg2, arg3, arg4)
  if eventName == "connect" then
    local _ucid = net.get_player_info(arg1, "ucid")
    local _name = net.get_player_info(arg1, "name")
    if flankerObj.slotInfo[_ucid] == nil then
      local _timeIn = DCS.getRealTime()
      flankerObj.slotInfo[_ucid] = {coalition = 0, timeIn = -900, preside = 3, prepreside = 3}
    else
      flankerObj.slotInfo[_ucid].prepreside = flankerObj.slotInfo[_ucid].preside
      flankerObj.slotInfo[_ucid].preside = flankerObj.slotInfo[_ucid].coalition
      flankerObj.slotInfo[_ucid].coalition = 0
    end
    PlayerList = net.get_player_list()
    Fix.red = 0
    Fix.blue = 0

    for key, value in pairs(PlayerList) do
      local side = net.get_player_info(value, "side")

      if side == 1 then --red
        Fix.red = Fix.red + 1
      elseif side == 2 then --blue
        Fix.blue = Fix.blue + 1
      end
    end

    if (Fix.red ~= count.red) then
      count.red = Fix.red
      local _chatMessage = string.format("红方人数统计修正 Blue:%d  Red:%d", count.blue, count.red)
      net.send_chat(_chatMessage, true)
    end
    if (Fix.blue ~= count.blue) then
      count.blue = Fix.blue
      local _chatMessage = string.format("蓝方人数统计修正 Blue:%d  Red:%d", count.blue, count.red)
      net.send_chat(_chatMessage, true)
    end
  --]]--
  --------------------------------------------------------------------------------
  end

  if eventName == "disconnect" then
    if arg3 == 1 then --red
      count.red = count.red - 1
    elseif arg3 == 2 then --blue
      count.blue = count.blue - 1
    else
    end

    -----------------------------------------------------
    ----[[
    PlayerList = net.get_player_list()
    Fix.red = 0
    Fix.blue = 0

    for key, value in pairs(PlayerList) do
      local side = net.get_player_info(value, "side")

      if side == 1 then --red
        Fix.red = Fix.red + 1
      elseif side == 2 then --blue
        Fix.blue = Fix.blue + 1
      end
    end

    if (Fix.red ~= count.red) then
      count.red = Fix.red
      local _chatMessage = string.format("红方人数统计修正 Blue:%d  Red:%d", count.blue, count.red)
      net.send_chat(_chatMessage, true)
    end
    if (Fix.blue ~= count.blue) then
      count.blue = Fix.blue
      local _chatMessage = string.format("蓝方人数统计修正 Blue:%d  Red:%d", count.blue, count.red)
      net.send_chat(_chatMessage, true)
    end
  --]]--
  --------------------------------------------------------------------------------
  end
end
flankerObj.showEnabledMessage = false -- if set to true, the player will be told that the slot is enabled when switching to it
flankerObj.controlNonAircraftSlots = true -- if true, only unique DCS Player ids will be allowed for the Commander / GCI / Observer Slots

-- New addon version 1.1 -- kicking of players.
flankerObj.kickPlayers = false -- Change to false if you want to disable to kick players.
flankerObj.kickTimeInterval = 1 -- Change the amount of seconds if you want to shorten the interval time or make the interval time longer.
flankerObj.kickReset = true -- The slot will be automatically reset to open, after kicking the player.

flankerObj.enabledFlagValue = 0 -- what value to look for to enable a slot.

flankerObj.prefixes = {
  "some_clan_tag",
  "-=AnotherClan=-"
}

flankerObj.instructorPlayerUCID = {
  --"7c97087882d2400431e1582fa84e521c", --Power
  --"53ef258f67939c3ef7f8af8be99c3605", --GS15
  "5779b29a3c40ed26bbc82529c83c8d89", --Killer
  --"54f64a25beed2f9e858c0820b8031b10", --Leafyyy
  --"cfe69a1ad3c14c13df965a521587d426", --707
  "f638e532a5489d1255f4c9dcea3d7ad2", --XZF
  --"438dcc14ab7e0354d0c7a8da5d058c43", --躲猫猫
  --"7bfce855f7659b70719406943d638681", --CYW（ACT）
  --"2834454fe35144ce8283ef2ac97c63ea", --烟雨焉（ACT）
  --"2fd51998f3534b2de242fe19a5fc1404", --E7-4（ACT）
  --"2ba36d92536c2b5b270dc31d92b2ec06", --CHINA096（ACT）
  "47b5d124a9fa7718bbfe820a57074e0d", --jacky
  "0110829137d2d76812b0bdac636d197c", --jacky2
  --"e1edb8eabd69354dba103dadcb7594a8", --GTX740
  --"34a4a2a6a8939621fc568bbef69bcad4", --Mobius118
  --"e13723cf908a5af20b6c0970c1dc8265", --
  --"e13723cf908a5af20b6c0970c1dc8265", --ling


  "bc5894bb75db1d2451ef5a7e95c3cd0f" --老三小号
}

flankerObj.observerPlayerUCID = {
  -- "7c97087882d2400431e1582fa84e521c", --Power
  -- "53ef258f67939c3ef7f8af8be99c3605", --GS15
   "5779b29a3c40ed26bbc82529c83c8d89", --Killer
  -- "54f64a25beed2f9e858c0820b8031b10", --Leafyyy
  -- "cfe69a1ad3c14c13df965a521587d426", --707
   "f638e532a5489d1255f4c9dcea3d7ad2", --XZF
  -- "438dcc14ab7e0354d0c7a8da5d058c43", --躲猫猫
   "47b5d124a9fa7718bbfe820a57074e0d", --jacky
   "0110829137d2d76812b0bdac636d197c", --jacky2
  -- "e13723cf908a5af20b6c0970c1dc8265", --ling
  -- "34a4a2a6a8939621fc568bbef69bcad4", --Mobius118
  -- "e1edb8eabd69354dba103dadcb7594a8", --GTX740



  "bc5894bb75db1d2451ef5a7e95c3cd0f" --老三小号
}

flankerObj.commanderPlayerUCID = {
   "7c97087882d2400431e1582fa84e521c", --Power
   "53ef258f67939c3ef7f8af8be99c3605", --GS15
   "5779b29a3c40ed26bbc82529c83c8d89", --Killer
   "54f64a25beed2f9e858c0820b8031b10", --Leafyyy
   "cfe69a1ad3c14c13df965a521587d426", --707
   "bc5894bb75db1d2451ef5a7e95c3cd0f", --老三小号
   "e13723cf908a5af20b6c0970c1dc8265", --ling
  -- "bb43cf810930a7da6ca06fd66022e0cb", --BFA-SIR
   "2834454fe35144ce8283ef2ac97c63ea", --烟雨兮
  -- "bc44055c29043ef394b55c527c1d34ac", --topworker
  -- "28231375a464e605549bcbad586d6adf", --勇士-03/冰箱
  -- "70851dd3018186dc58b9c0417e468c59", --黑蛇-99/老油条
  -- "fa711baad5d9becf3b9954eb764150b1", --seafox
   "b74bd82c6786a28b4a266332cfd73a78", --JG54_NF2
  -- "92128647e1f1c3824f0639a1468aed87", --Needle
  -- "09cce0cbb24a007fa44ad091fa16a493", --solo
  -- "b96c10e850802b0d6da81d385b137777", --yanyu
  -- "c03bea9b1408200a2857c9053c6c5e61", --=CNF=101
  -- "fdcdf87fc9f76a2121e8707daddadc16", --=CNF=405
   "cda5196b39a41922664447ca5d355625", --=CNF=801
  -- "f1d20ddfd5f19c20e58d79f7839fde8c", --TG-790/LingYun
  -- "9c385a36f8df68ac0bc8b27af328799d", --3GO*SN-1911
  -- "ed3cadf3d6a8e1574116f9493b4a4d38", --1027
  -- "42a4c3feef1500df35d6153ed5fdf84c", --大大怪将军
   "438dcc14ab7e0354d0c7a8da5d058c43", --躲猫猫
  -- "4e0e11b27ebb3db35283af9a3c817756", --Jet
   "e1edb8eabd69354dba103dadcb7594a8", --GTX740
  -- "a6ad8b1ba824c909956426a849c76df7", --tree8418
   "f638e532a5489d1255f4c9dcea3d7ad2", --XZF
  -- "8e0d8501900ec802e1fd37eb31487cec", --inSky_1979
  -- "b5dd5119a13a773718969019a8294cca", --inSky_1155
  -- "95b25ae7b1d6fbdc3f142f302f9b0b30", --5G
  -- "2ce1b0acd6384623152fd70a3ce38d18", --inSky_1821
  -- "c0c3f039b781b06d66f50bcc1b7dc23f", --lunzi
  -- "1544538a4aa76f113cc809a2b0ccc812", --靶机5号
  -- "2e62443d6baa779d9f51139270e8255f", --L9493(来之不易服务器成员)

   "ea354e953e367623a21e1fb0e380f163", --453
   "113b8f49955db71265fc0b9a314b11d0", --Akamu-LIN
  -- "1af829a04058bded13ccd50f91ad866c", --hardrian
  -- "c2e6ed1fce9133b957e4cbf4412824a8", --逍
   "e99d5cd57c2ebc8b33ac0193a9b7d37d", --TY-127
  -- --"c178de5e261dde37bdc2ae05adad9d0e", --Lau-Hornet--打自己家载具
   "70bab935c8a142b867767578f8ee5d86", --时光（少尉）
  -- "eae6f83ee3693287e92229d7eeab25b3", --nerf on board
  -- "7233fef166e3ed8bab060f91b0391cd0", --17
  -- "091ad3d350257a38880d2d972aac2f91", --Hanson
  -- "ed51e834169636fb1d19c2cf9eed1dc8", --MAC28
   "47b5d124a9fa7718bbfe820a57074e0d", --jacky
   "0110829137d2d76812b0bdac636d197c", --jacky2
  -- "41b992a2b5169fb3a572813af9fb1641", --608
  -- "edce540eb574ca8ebd9661bd103325a4", --大兔兔（狐狸）
  -- "3530d77a525afcec161b9f1b23a602b9", --噬魂真龙
  -- "f3ac0edaf417b2d42313d38a83bc0f96", --702
   "7bfce855f7659b70719406943d638681", --CYW（ACT）
  -- "2e8d44d1b41597ce8c87cd693c99f17d", --foxmate
   "2fd51998f3534b2de242fe19a5fc1404", --E7-4
  -- "2cff00d1c05f84bb44c67fe2771d413f", --shenhao
   "370b4626a2d29f5d508025c3eb323fc0", --咸鱼48
  -- "4f9d041e551426a59368c2a1803a45a4", --QFAN
  -- "97a83017053e3a77fb330779d2d8d311", --Libertyboy
  -- "f5ff4acbf6caf8d90d57429dc98b0dbe", --liebestraum
  -- "d8c04a6e3d3d37fcd3b4b1c4fd6cac8f", --MengYing
  -- "4de6c0e8ee50859dafb22654b7246ced", --拉普兰德是条傻狗
   "b2aedd36524b343813ace0ea2e1ec557", --SharkFred-324
  -- "a33b6fd07e57b319a0d0c9f58920fc7c", --blacklotus
  -- "1bf8bab423d10b5d4c59aa666418525a", --FTXZ
   "7fe81017d08d3ba2a867583bf05ed198", --TY-127_steam
   "715c9dbd0e28d6e609baadfe74e66502", --1527-2
  -- "fe03b50934b07bad9fac1d3458657835", --lkyfly1957
  -- "6a409da661221e29ec730ff838a8f902", --企鹅046
  -- "da5ead5090a19373c05935faa01f0069", --silver-LYN
  -- "b3ef7e5892b76bc1e348cf10c7c45747", --银河天路
  -- "228cee4ad5a9657ba34d339b47781314", --Blingbling
  -- "bfb6a797d141c39b2ffedb63fee31b8e", --transizirco
  -- "007d24ed33d403b6a6bfa200fc46c8e1", --caesar36(SDL-036雷龙)
  -- "1d4da3b6a91d7f56c43fb4a73944c446", --mackurt
  -- "0ed82e5f077c8cce5b2eff7c59469c7e", --会飞小狐狸的浮莲子
  -- "29df88dec3911ff0baed5ff8bffda309", --M117
  -- "d5910be629d54e82f4fd67965bc78456", --ANA6047
  -- "1882bd06cd73423f4bce5b4bfe0c3285", --S-FC-GiantRat
  -- "f11c85e8e10cedce3c44719e41e227b6", --happy
  -- "f5e4723eeacd8eaa090ab173761141a7", --蒙大拿
  -- "7fc7e9e5668e5e01f6c9a7f9444d8807", --creeper
  -- "124c92f96034a940f72633215a4d06a3", --S-FC-神奇飞船
  -- "a69b60ed4a565811db5c0cac08e55ff7", --203同时也是Gs.Fhuidao1942(集装箱杀手)是否同一人未知
  -- "0dbc28ee7f2f1a30999ba7bb011512ea", --acc
   "34a4a2a6a8939621fc568bbef69bcad4", --Mobius118
  -- "31eefe9527fa79d7a7119f6c1cff1935", --lanfeng123
  -- "b9c3f9f7d49122fb35c131b7c831e5f6", --Black Shadow
  -- "759acd7e72e6a016618ad8e8c8d9b9e9", --白满川
  -- "f9b693cde53ed126c51dbbb861f143f3", --Hawk
  -- "eec424c726973330eef5f5ea28c3603a", --Taiho
  -- "e51ce8bae0583541c57083e4d700da63", --暗星一号
  -- "3de7696ebf0d54f4c5aa60e34a0eec81", --flankerjun
  -- "dbc3cb45ac9d5d75d85ff5e3090605d2", --马桶里翻滚(ooo)
  -- --"d0abffeaa72a8e8576a1d26373e70175", --Yukikaze(NP小屁孩)
  "86675e0445d196527d8cda5e8394b0c1", --CHL-124西瓜
  -- "984adc972a43a806870bc63b47b2e200", --O_O (qq:491073474)
  -- "2cf7dd1260c9f167e389b315332ae1cc", --RedNeck-白石清kb
  -- "83d77298eb43d5af4f3084dd404ba63e", --BLUE(qq:22260222)
  "ba83f771724995a3be7d25427c6c2541", --thunder(qq:1483254940)
  "26181d97dd4b19537da03d18d465df59", --新手进场好烦(qq:873098104)
  "0ac5550518c7ecdc46e34442fc1eec1f", --雨夜的闯荡(qq:743464405)
  "1544538a4aa76f113cc809a2b0ccc812", --靶机5号
  "eb5f98699e844bb272d10bc02f034be1", --曲奇(qq:2386121067)
  "a643a9ee3173db772bb420ee2c4e23bd", --THUNDER(qq:1483254940)
  "f9d2d661f13390c288654f90da33a79b", --岛风
  "99aab1602a64a671c7a3bd5f6f7e058a", --ZED
  "007d24ed33d403b6a6bfa200fc46c8e1", --Z
  "cc850a077b1aee252e6a57751f270877", --OUO
  "e31a756a7d4484f3911e65b2dbd50243", --WOWC
  "085c423be54bc7720bdb32a90081e486", --Song.Head
  "f28679c0be5b30c5a951ce98f24c25df", --Song.Head[VR]
  "28f70d2fd5ba8c062a54a01154acdd76", --问号
  "ed8d418195a084541e9471778ac2e22e", --地摊飞行器
  "69d60e1a0fe1c86bc3e81792458dba61", --E-TF[105] Cookie
  "308cf6da94f78ec5873b26668e5b99ed", --西瓜2
  "3fc48e56d51910f3dfe75d06c777ad3c", --mob
  "22f34afb133ae9bc8637f96e105c23aa", --萌新开飞机
  "2abea9f8e286b3fa5ebca1c8b3705ca6", --咸某小号
  "1882bd06cd73423f4bce5b4bfe0c3285", --大老鼠
  "c931d2c32f894a9c134591c14ed0616b", --555

  "dfdcc8c5e909c607a360b74c8026fd1b" 
  --afarros045
}

-- Time interval determing if a player can change to the oppsite side
flankerObj.allowChangeSideTime = 900
flankerObj.slotInfo = {}

flankerObj.version = "1.1"

-- Logic for determining if player is allowed in a slot
function flankerObj.shouldAllowAircraftSlot(_playerID, _slotID)
  local _groupName = flankerObj.getGroupName(_slotID)
  if _groupName == nil or _groupName == "" then
    return true
  end

  _groupName = flankerObj.trimStr(_groupName)

  if not flankerObj.checkClanSlot(_playerID, _groupName) then
    return false
  end

  -- check flag value
  local _flag = flankerObj.getFlagValue(_groupName)

  if _flag == flankerObj.enabledFlagValue then
    return true
  end

  return false
end

-- Logic to allow a player in a slot
function flankerObj.allowAircraftSlot(_playerID, _slotID) -- _slotID == Unit ID unless its multi aircraft in which case slotID is unitId_seatID (added by FlightControl)
  local _groupName = flankerObj.getGroupName(_slotID)
  if _groupName == nil or _groupName == "" then
    return true
  end
  _groupName = flankerObj.trimStr(_groupName)

  if not flankerObj.checkClanSlot(_playerID, _groupName) then
    return false
  end

  -- check flag value
  local _result = flankerObj.setFlagValue(_groupName, 0)

  return _result
end

function flankerObj.checkClanSlot(_playerID, _unitName)
  for _, _value in pairs(flankerObj.prefixes) do
    if string.find(_unitName, _value, 1, true) ~= nil then
      local _playerName = net.get_player_info(_playerID, "name")
      if _playerName ~= nil and string.find(_playerName, _value, 1, true) then
        return true
      end
      return false
    end
  end

  return true
end

function flankerObj.getFlagValue(_flag)
  local _status, _error = net.dostring_in("server", ' return trigger.misc.getUserFlag("' .. _flag .. '"); ')

  if not _status and _error then
    return tonumber(flankerObj.enabledFlagValue)
  else
    --disabled
    return tonumber(_status)
  end
end

function flankerObj.setFlagValue(_flag, _number) -- Added by FlightControl
  local _status, _error = net.dostring_in("server", ' return trigger.action.setUserFlag("' .. _flag .. '", ' .. _number .. "); ")

  if not _status and _error then
    return false
  end
  return true
end

function flankerObj.getUnitId(_slotID)
  local _unitId = tostring(_slotID)
  if string.find(tostring(_unitId), "_", 1, true) then
    _unitId = string.sub(_unitId, 1, string.find(_unitId, "_", 1, true))
  end
  return tonumber(_unitId)
end

function flankerObj.getGroupName(_slotID)
  local _name = DCS.getUnitProperty(_slotID, DCS.UNIT_GROUPNAME)
  return _name
end

function flankerObj.exitProc()
  local hour = tonumber(os.date("%H"), 10)
  if hour > 3 and hour < 17 then
    DCS.exitProcess()
  end
end

--- For each simulation frame, check if a player needs to be kicked.
flankerObj.onSimulationFrame = function()
  if DCS.getPause() then
    local list = net.get_player_list()
    local cnt = table.getn(list)
    if cnt < 2 and DCS.getRealTime() > 72000 then
      flankerObj.exitProc()
    end
  end
end
flankerObj.onPlayerTryChangeSlot = function(playerID, side, slotID)
  local _ucid = net.get_player_info(playerID, "ucid")

  if DCS.isServer() and DCS.isMultiplayer() then
    if (side == 0) then
      local _ucid = net.get_player_info(playerID, "ucid")
      local _playerName = net.get_player_info(playerID, "name")

      if flankerObj.slotInfo[_ucid] ~= nil then
        _sideFrom = flankerObj.slotInfo[_ucid].coalition
      else
        _sideFrom = 0
      end
      local _timeIn = DCS.getRealTime()

      flankerObj.slotInfo[_ucid].prepreside = flankerObj.slotInfo[_ucid].preside
      flankerObj.slotInfo[_ucid].preside = _sideFrom
      flankerObj.slotInfo[_ucid].coalition = side

      if _sideFrom == 1 then --red
        count.red = count.red - 1
      elseif _sideFrom == 2 then --blue
        count.blue = count.blue - 1
      else
      end

      return
    elseif (side ~= 0 and slotID ~= "" and slotID ~= nil) and flankerObj.slotBlockEnabled() then
      local _ucid = net.get_player_info(playerID, "ucid")
      local _playerName = net.get_player_info(playerID, "name")

      if _playerName == nil then
        _playerName = ""
      end

      local _unitRole = DCS.getUnitType(slotID)

      if _unitRole ~= nil and _unitRole == "instructor" then --游戏管理员
        local _allow = false
        if flankerObj.controlNonAircraftSlots and flankerObj.slotBlockEnabled() then
          for _, _value in pairs(flankerObj.instructorPlayerUCID) do
            if _value == _ucid then
              _allow = true
              break
            end
          end

          if not _allow then
            flankerObj.rejectMessage(playerID)
            return false
          end
        end
        local _sideFrom = flankerObj.slotInfo[_ucid].coalition
        if _sideFrom == 1 then --red
          count.red = count.red - 1
        elseif _sideFrom == 2 then --blue
          count.blue = count.blue - 1
        else
        end

        if side == 1 then --red
          count.red = count.red + 1
        elseif side == 2 then --blue
          count.blue = count.blue + 1
        else
        end

        local _timeIn = DCS.getRealTime()
        --flankerObj.slotInfo[_ucid] = { coalition = side, timeIn = _timeIn }
        flankerObj.slotInfo[_ucid].prepreside = flankerObj.slotInfo[_ucid].preside
        flankerObj.slotInfo[_ucid].preside = _sideFrom
        flankerObj.slotInfo[_ucid].coalition = side
        return
      elseif _unitRole ~= nil and _unitRole == "observer" then
        local _allow = false
        if flankerObj.controlNonAircraftSlots and flankerObj.slotBlockEnabled() then
          for _, _value in pairs(flankerObj.observerPlayerUCID) do
            if _value == _ucid then
              _allow = true
              break
            end
          end

          if not _allow then
            flankerObj.rejectMessage(playerID)
            return false
          end
        end

        local _sideFrom = flankerObj.slotInfo[_ucid].coalition
        if _sideFrom == 1 then --red
          count.red = count.red - 1
        elseif _sideFrom == 2 then --blue
          count.blue = count.blue - 1
        else
        end

        if side == 1 then --red
          count.red = count.red + 1
        elseif side == 2 then --blue
          count.blue = count.blue + 1
        else
        end

        local _chatMessage = string.format("evet observer blue:%d  red:%d", count.blue, count.red)
        net.send_chat(_chatMessage, true)
        local _chatMessage = string.format("test FixBlue:%d  FixRed:%d", Fix.blue, Fix.red)
        net.send_chat(_chatMessage, true)
        local _chatMessage = string.format("acr:%d acb:%d hlr:%d hlb:%d", AC.red, AC.blue, Heli.red, Heli.blue)
        net.send_chat(_chatMessage, true)

        local _timeIn = DCS.getRealTime()
        --flankerObj.slotInfo[_ucid] = { coalition = side, timeIn = _timeIn }
        flankerObj.slotInfo[_ucid].prepreside = flankerObj.slotInfo[_ucid].preside
        flankerObj.slotInfo[_ucid].preside = _sideFrom
        flankerObj.slotInfo[_ucid].coalition = side
        return
      elseif _unitRole ~= nil and _unitRole == "artillery_commander" then
        local _allow = false
        if flankerObj.controlNonAircraftSlots and flankerObj.slotBlockEnabled() then
          for _, _value in pairs(flankerObj.commanderPlayerUCID) do
            if _value == _ucid then
              _allow = true
              break
            end
          end

          if not _allow then
            flankerObj.rejectMessage(playerID)
            return false
          end
        end
      else
        local _allow = flankerObj.shouldAllowAircraftSlot(playerID, slotID)
        if not _allow then
          flankerObj.rejectAirBaseMessage(playerID)
          return false
        end
      end

      -----------------------CA部分的人数平衡--------------------------------
      if _unitRole ~= nil and (_unitRole == "Ka-50" or _unitRole == "Mi-8MT" or _unitRole == "UH-1H" or _unitRole == "artillery_commander") then
        local _ucid = net.get_player_info(playerID, "ucid")
        local _sideFrom = flankerObj.slotInfo[_ucid].coalition
        local fm_slotID = net.get_player_info(PlayerID, "slot")
        local fm_unitRole = DCS.getUnitType(fm_slotID)
        PlayerList = net.get_player_list()
        --

        Heli.red = 0
        Heli.blue = 0

        AC.red = 0
        AC.blue = 0

        for key, value in pairs(PlayerList) do
          local tp_side = net.get_player_info(value, "side")
          local tp_slotID = net.get_player_info(value, "slot")
          local tp_unitRole = DCS.getUnitType(tp_slotID)

          if tp_side == 1 then --red
            if (tp_unitRole == "Ka-50" or tp_unitRole == "Mi-8MT" or tp_unitRole == "UH-1H") then
              if (value ~= playerID) then
                Heli.red = Heli.red + 1
              end
            elseif (tp_unitRole == "artillery_commander") then
              if (value ~= playerID) then
                AC.red = AC.red + 1
              end
            end
          elseif tp_side == 2 then --blue
            if (tp_unitRole == "Ka-50" or tp_unitRole == "Mi-8MT" or tp_unitRole == "UH-1H") then
              if (value ~= playerID) then
                Heli.blue = Heli.blue + 1
              end
            elseif (tp_unitRole == "artillery_commander") then
              if (value ~= playerID) then
                AC.blue = AC.blue + 1
              end
            end
          end
        end

        if (_unitRole == "Ka-50" or _unitRole == "Mi-8MT" or _unitRole == "UH-1H") then
          if side == 1 then --选的红方直升机
            if Heli.red - Heli.blue >= 2 or (Heli.red - Heli.blue >= 0 and _sideFrom == 2 and (fm_unitRole == "Ka-50" or fm_unitRole == "Mi-8MT" or fm_unitRole == "UH-1H")) then
              local _chatMessage = string.format("红方直升机偏多，不允跳边")
              --net.send_chat_to(_chatMessage, playerID)
              return true
            else
            end
          elseif side == 2 then
            if Heli.blue - Heli.red >= 2 or (Heli.blue - Heli.red >= 0 and _sideFrom == 1 and (fm_unitRole == "Ka-50" or fm_unitRole == "Mi-8MT" or fm_unitRole == "UH-1H")) then
              local _chatMessage = string.format("蓝方直升机偏多，不允跳边")
              --net.send_chat_to(_chatMessage, playerID)
              return true
            else
            end
          end
        elseif _unitRole == "artillery_commander" then
          if side == 1 then
            if AC.red - AC.blue >= 3 or (AC.red - AC.blue >= 0 and _sideFrom == 2 and (fm_unitRole == "artillery_commander")) then
              local _chatMessage = string.format("红方指挥官偏多，不允跳边")
              --net.send_chat_to(_chatMessage, playerID)
              return true
            else
            end
          elseif side == 2 then
            if AC.blue - AC.red >= 3 or (AC.blue - AC.red >= 0 and _sideFrom == 1 and (fm_unitRole == "artillery_commander")) then
              local _chatMessage = string.format("蓝方指挥官偏多，不允跳边")
              --net.send_chat_to(_chatMessage, playerID)
              return true
            else
            end
          end
        end

        if _sideFrom == 1 then --red
          count.red = count.red - 1
        elseif _sideFrom == 2 then --blue
          count.blue = count.blue - 1
        else
        end

        if side == 1 then --red
          count.red = count.red + 1
        elseif side == 2 then --blue
          count.blue = count.blue + 1
        else
        end

        flankerObj.slotInfo[_ucid].prepreside = flankerObj.slotInfo[_ucid].preside
        flankerObj.slotInfo[_ucid].preside = _sideFrom
        flankerObj.slotInfo[_ucid].coalition = side
        return true

      --flankerObj.slotInfo[_ucid].preside
      end

      if _unitRole ~= nil and ((_unitRole ~= "observer" and _unitRole ~= "instructor") or _unitRole == "artillery_commander") then --ca指挥和飞机
        local _sideFrom = side
        if flankerObj.slotInfo[_ucid] ~= nil then
          _sideFrom = flankerObj.slotInfo[_ucid].coalition
        else --第一次进服
          local _timeIn = DCS.getRealTime()

          _sideFrom = 0

          local _timeIn = DCS.getRealTime()
          flankerObj.slotInfo[_ucid] = {coalition = _sideFrom, timeIn = _timeIn}
        end
        if _sideFrom ~= side then --选择的前后边不一样
          if flankerObj.slotInfo[_ucid] ~= nil then
            local _allowChangeSide = flankerObj.shouldAllowChangeSide(flankerObj.slotInfo[_ucid].timeIn, playerID, _playerName, side, _sideFrom, flankerObj.slotInfo[_ucid].preside, flankerObj.slotInfo[_ucid].prepreside)
            if not _allowChangeSide then
              return false
            end
          end
        end
      end
    ------------------------changing side limitation------------------------
    end
  end

  local _sideFrom = flankerObj.slotInfo[_ucid].coalition

  if _sideFrom == 1 then --red
    count.red = count.red - 1
  elseif _sideFrom == 2 then --blue
    count.blue = count.blue - 1
  else
  end

  if side == 1 then --red
    count.red = count.red + 1
  elseif side == 2 then --blue
    count.blue = count.blue + 1
  else
  end

  local preside = flankerObj.slotInfo[_ucid].preside
  local prepreside = flankerObj.slotInfo[_ucid].prepreside

  if (side ~= _sideFrom and preside ~= side and preside ~= 0) or ((_sideFrom == 0 and preside == 0) and (prepreside ~= side)) or (side ~= 0 and _sideFrom ~= 0 and side ~= _sideFrom) then
    local _timeIn = DCS.getRealTime()
    flankerObj.slotInfo[_ucid].timeIn = _timeIn
  end

  flankerObj.slotInfo[_ucid].prepreside = flankerObj.slotInfo[_ucid].preside
  flankerObj.slotInfo[_ucid].preside = _sideFrom
  flankerObj.slotInfo[_ucid].coalition = side

  return
end

flankerObj.shouldAllowChangeSide = function(_timeFrom, _playerID, _playerName, side, _sideFrom, preside, prepreside)
  local timeNow = DCS.getRealTime()
  local timePast = timeNow - _timeFrom

  if timePast > flankerObj.allowChangeSideTime or timePast <= 0 then --时间到
    --return true
    if (flankerObj.BalanceJudge(side, _sideFrom) == 3) then --时间到了 平衡过了
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)

      local _chatMessage = string.format("总人数过小，随意跳边")
      net.send_chat_to(_chatMessage, _playerID)
      return true
    elseif (flankerObj.BalanceJudge(side, _sideFrom) == 0) then --时间到了 平衡不通过
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("人数差距过大，请去人少的一边")
      net.send_chat_to(_chatMessage, _playerID)
      return false
    elseif (flankerObj.BalanceJudge(side, _sideFrom) == 1) then --时间到了 平衡不通过
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("人数差距过大，特许跳边")
      net.send_chat_to(_chatMessage, _playerID)
      return true
    elseif (flankerObj.BalanceJudge(side, _sideFrom) == 2) then --时间到了 平衡不通过
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("人数平衡且时间到，允许跳边")
      net.send_chat_to(_chatMessage, _playerID)
      return true
    end
  else
    if (flankerObj.BalanceJudge(side, _sideFrom) == 3) then --时间没到 平衡关系过了
      --Disable chat message to user
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("总人数少，随意跳边")
      net.send_chat_to(_chatMessage, _playerID)

      return true
    elseif (flankerObj.BalanceJudge(side, _sideFrom) == 2) then ----时间没到 平衡不通过
      if (_sideFrom == 0 and (preside == side)) or ((_sideFrom == 0 and preside == 0) and (prepreside == side)) then --从观众席往红或蓝跳跃且人数平衡时，应该无视15分钟
        return 1
      end

      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("人数平衡,但还要再过%d分钟才能跳边!", timeRemain + 1)
      net.send_chat_to(_chatMessage, _playerID)

      return false
    elseif (flankerObj.BalanceJudge(side, _sideFrom) == 1) then
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("人数差距过大，特许跳边")
      net.send_chat_to(_chatMessage, _playerID)
      return true
    elseif (flankerObj.BalanceJudge(side, _sideFrom) == 0) then
      local timeInterval, _ = math.modf(flankerObj.allowChangeSideTime / 60)
      local timeRemain, _ = math.modf((flankerObj.allowChangeSideTime - timePast) / 60)
      local _chatMessage = string.format("人数差距过大，请去人少的一边")
      net.send_chat_to(_chatMessage, _playerID)
      return false
    end
  end
end

flankerObj.BalanceJudge = function(side, _sideFrom)
  local playernumber = count.blue + count.red
  if playernumber <= balance.gate1 then
    diffThreshold = balance.diff1
  elseif playernumber <= balance.gate2 then
    diffThreshold = balance.diff2
  elseif playernumber <= balance.gate3 then
    diffThreshold = balance.diff3
  elseif playernumber <= balance.gate4 then
    diffThreshold = balance.diff4
  elseif playernumber <= balance.gate5 then
    diffThreshold = balance.diff5
  elseif playernumber <= balance.gate6 then
    diffThreshold = balance.diff6
  else
    diffThreshold = balance.diff7
  end

  local temp = count.red - count.blue

  if (playernumber <= balance.leastworknumber) then --人数小于 %d人不进行判定
    return 3
  else
    if _sideFrom ~= side then
      if side == 1 then --red
        if (count.red - count.blue) >= diffThreshold then --red is much more than blue
          return 0 --选红 红方人却太多
        elseif (count.blue - count.red) >= diffThreshold then --选红，蓝方人太多
          return 1
        else --选红 红蓝人数平等
          return 2
        end
      elseif side == 2 then --blue
        if (count.blue - count.red) >= diffThreshold then
          return 0 --选蓝 蓝方人太多
        elseif (count.red - count.blue) >= diffThreshold then --选蓝，红方人太多
          return 1
        else
          return 2
        end
      end
    else
      return 1
    end
  end
end

flankerObj.slotBlockEnabled = function()
  local _res = flankerObj.getFlagValue("Block") --SSB disabled by Default

  return _res == 100
end

flankerObj.rejectMessage = function(playerID)
  local _playerName = net.get_player_info(playerID, "name")

  if _playerName ~= nil then
    --Disable chat message to user
    local _chatMessage = string.format("%s, 这个位置目前无法选择!", _playerName)
    net.send_chat_to(_chatMessage, playerID)
  end
end

flankerObj.rejectAirBaseMessage = function(playerID)
  local _playerName = net.get_player_info(playerID, "name")

  if _playerName ~= nil then
    --Disable chat message to user
    local _chatMessage = string.format("%s, 目前无法选择这个位置, 需要先占领其所在的机场或停机坪!", _playerName)
    net.send_chat_to(_chatMessage, playerID)
  end
end

flankerObj.rejectPlayer = function(playerID)
  net.force_player_slot(playerID, 0, "")
  flankerObj.rejectMessage(playerID)
end

flankerObj.trimStr = function(_str)
  return string.format("%s", _str:match("^%s*(.-)%s*$"))
end

DCS.setUserCallbacks(flankerObj) -- here we set our callbacks

net.log("Loaded - SIMPLE SLOT BLOCK v" .. flankerObj.version .. " modified by Flanker")
