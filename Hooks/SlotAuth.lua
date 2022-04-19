UserList = {
    commander = {
        "7c97087882d2400431e1582fa84e521c", --Power
        "53ef258f67939c3ef7f8af8be99c3605", --GS15
        "5779b29a3c40ed26bbc82529c83c8d89", --Killer
        "54f64a25beed2f9e858c0820b8031b10", --Leafyyy
        "cfe69a1ad3c14c13df965a521587d426", --707
        "bc5894bb75db1d2451ef5a7e95c3cd0f", --老三小号
        "e13723cf908a5af20b6c0970c1dc8265", --ling
        "2834454fe35144ce8283ef2ac97c63ea", --烟雨兮
        "b74bd82c6786a28b4a266332cfd73a78", --JG54_NF2
        "cda5196b39a41922664447ca5d355625", --=CNF=801
        "438dcc14ab7e0354d0c7a8da5d058c43", --躲猫猫
        "e1edb8eabd69354dba103dadcb7594a8", --GTX740
        "f638e532a5489d1255f4c9dcea3d7ad2", --XZF
        "ea354e953e367623a21e1fb0e380f163", --453
        "113b8f49955db71265fc0b9a314b11d0", --Akamu-LIN
        "e99d5cd57c2ebc8b33ac0193a9b7d37d", --TY-127
        "70bab935c8a142b867767578f8ee5d86", --时光（少尉）
        "47b5d124a9fa7718bbfe820a57074e0d", --jacky
        "0110829137d2d76812b0bdac636d197c", --jacky2
        "7bfce855f7659b70719406943d638681", --CYW（ACT）
        "2fd51998f3534b2de242fe19a5fc1404", --E7-4
        "370b4626a2d29f5d508025c3eb323fc0", --咸鱼48
        "b2aedd36524b343813ace0ea2e1ec557", --SharkFred-324
        "7fe81017d08d3ba2a867583bf05ed198", --TY-127_steam
        "715c9dbd0e28d6e609baadfe74e66502", --1527-2
        "34a4a2a6a8939621fc568bbef69bcad4", --Mobius118
        "86675e0445d196527d8cda5e8394b0c1", --CHL-124西瓜
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
        "dfdcc8c5e909c607a360b74c8026fd1b"--afarros045
    },
    admin={
        "5779b29a3c40ed26bbc82529c83c8d89", --Killer
        "f638e532a5489d1255f4c9dcea3d7ad2", --XZF
        "47b5d124a9fa7718bbfe820a57074e0d", --jacky
        "0110829137d2d76812b0bdac636d197c", --jacky2
        "bc5894bb75db1d2451ef5a7e95c3cd0f" --老三小号
    },
    observer={
        "5779b29a3c40ed26bbc82529c83c8d89", --Killer
        --"f638e532a5489d1255f4c9dcea3d7ad2", --XZF
        "47b5d124a9fa7718bbfe820a57074e0d", --jacky
        "0110829137d2d76812b0bdac636d197c", --jacky2
        "bc5894bb75db1d2451ef5a7e95c3cd0f" --老三小号
    },
};


SLOT = SLOT or {}
SLOT.callbacks = SLOT.callbacks or {}

function SLOT.callbacks.onPlayerTryChangeSlot(playerID, side, slotID)
    local _side=side
    local _slotID=slotID

    net.log('进入回调函数，准备进入allow')
    local result=SLOT.allowEnterSlot(playerID,_side,_slotID)
    if result==nil or result ==false then
        return false
    end
end


function SLOT.allowEnterSlot (_playerID,_side,_slotID)
    local _unitRole = DCS.getUnitType(_slotID)
    local _category = DCS.getUnitProperty(_slotID,DCS.UNIT_GROUPCATEGORY)
    local _groupName = DCS.getUnitProperty(_slotID,DCS.UNIT_GROUPNAME)
    local _unitName = DCS.getUnitProperty(_slotID,DCS.UNIT_NAME)
    local _ucid = net.get_player_info(_playerID, "ucid")

    if _category ~= nil and _category=='helicopter' then
        if SLOT.getFlagValue(_groupName) == 0 then
            return true
        else
            net.send_chat_to('该直升机不可选', _playerID)
            return false
        end
    end

    if _unitRole ~= nil and _unitRole == "instructor" then --游戏管理员
        return SLOT.findIDInTable(_playerID,_ucid,UserList.admin,'instructor')
    end
    if _unitRole ~= nil and _unitRole == "observer" then --观察员
        return SLOT.findIDInTable(_playerID,_ucid,UserList.observer,'observer')
    end
    if _unitRole ~= nil and _unitRole == "artillery_commander" then --CA
        return SLOT.findIDInTable(_playerID,_ucid,UserList.commander,'artillery_commander')
    end

    return true
end

function SLOT.getFlagValue(_flag)
    local _status, _error = net.dostring_in("server", ' return trigger.misc.getUserFlag("' .. _flag .. '"); ')
    if not _status and _error then
        return tonumber(0)
    else
        --disabled
        return tonumber(_status)
    end
end

function SLOT.findIDInTable(_playerID,_ucid,table,commander)
    local allowed = false
    for _, _value in pairs(table) do
        if _value == _ucid then
            allowed = true
            break
        end
    end

    if allowed then
        return true
    else
        net.send_chat_to('你没有选择这个位置的权限', _playerID)
        if commander=='artillery_commander' then
            net.send_chat_to('如果对CA和地面指挥感兴趣，可以向群管理提出申请', _playerID)
        end
        return false
    end
end

--设置用户callbacs,使用上面定义的功能映射DCS事件处理程序
DCS.setUserCallbacks(SLOT.callbacks)