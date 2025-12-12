--[[
    NP占点脚本 By 紫花
    依赖ctld和mist

 ]]
--TODO 选边限制
--TODO fob的击杀更新
--阵营级大杀器
--箱子

NP = {}

local weaponTemplate = {}
local liquidsTemplate = {}

NP.Id = "NP - "

NP.Version = "20220417"

net.log("LOAD - NP core script version "..NP.Version ..", script by VL")

NP.RefreshTime = 10

NP.CaptureDistance = 200

NP.AWACSList = {
    "blueAWACS",
    "blueAWACS-1",
    "blueAWACS-2",
    "blueAWACS-3",
    "redAWACS",
    "redAWACS2",
    "redAWACS-1",
    "redAWACS2-1"
}

NP.CCStatus = {} -- Stores current level, crates delivered, and upgrade status for each CC.
-- { [ccName] = { level = X, crates = Y, upgrading = false/true, upgradeStartTime = time } }


NP.LevelConfigs = {
    Home_L1 = {
        { type = {"Tor 9A331"}, radius = 2000, count = 4, suffix = "_中程防空", support = {} },
        { type = {"CHAP_PantsirS1","2S6 Tunguska"}, radius = 2500, count = 4, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger", "Strela-10M3"}, radius = 2500, count = 6, suffix = "_近程防空(红外)", support = {} },
        { type = "Hawk ln", radius = 1000, count = 6, suffix = "_远程防空(霍克)",
            support = {
                { type = "Hawk tr", count = 1, offset = {x = 100, y = 50} }, -- 指挥车
                { type = "Hawk pcp", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "Hawk sr", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
                { type = "Hawk cwar", count = 1, offset = {x = -50, y = 50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -50, y = -50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -100, y = -50} }, -- 指挥车
            } },
        { type = {"M-2 Bradley", "ZBD04A", "Leclerc"}, radius = 1250, count = 5, suffix = "_坦克", support = {} },
    },
    Home_L2 = {
        { type = {"HEMTT_C-RAM_Phalanx"}, radius = 80, count = 1, suffix = "_近防", support = {} },
        { type = {"Tor 9A331","CHAP_TorM2"}, radius = 2000, count = 6, suffix = "_中程防空", support = {} },
        { type = {"CHAP_PantsirS1","2S6 Tunguska"}, radius = 2500, count = 4, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger", "Strela-10M3"}, radius = 2500, count = 6, suffix = "_近程防空(红外)", support = {} },
        { type = "Hawk ln", radius = 1000, count = 6, suffix = "_远程防空(霍克)",
            support = {
                { type = "Hawk tr", count = 1, offset = {x = 100, y = 50} }, -- 指挥车
                { type = "Hawk pcp", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "Hawk sr", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
                { type = "Hawk cwar", count = 1, offset = {x = -50, y = 50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -50, y = -50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -100, y = -50} }, -- 指挥车
            } },
        { type = {"ZBD04A", "Leclerc"}, radius = 1250, count = 5, suffix = "_坦克", support = {} },
    },
    Home_L3 = {
        { type = {"HEMTT_C-RAM_Phalanx"}, radius = 80, count = 2, suffix = "_近防", support = {} },
        { type = {"Tor 9A331","CHAP_TorM2"}, radius = 2000, count = 8, suffix = "_中程防空", support = {} },
        { type = {"CHAP_PantsirS1","2S6 Tunguska"}, radius = 2500, count = 6, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger", "Strela-10M3"}, radius = 2500, count = 9, suffix = "_近程防空(红外)", support = {} },
        { type = "SA-11 Buk LN 9A310M1", radius = 1000, count = 6, suffix = "_远程防空(山毛榉)",
            support = {
                { type = "SA-11 Buk SR 9S18M1", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
            } },
        { type = "SA-11 Buk LN 9A310M1", radius = 1500, count = 6, suffix = "_远程防空(山毛榉)2",
            support = {
                { type = "SA-11 Buk SR 9S18M1", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
            } },
        { type = {"Leclerc", "ZBD04A"}, radius = 1250, count = 6, suffix = "_坦克", support = {} },
    },

    Front_L1 = {
        { type = {"Tor 9A331"}, radius = 1500, count = 4, suffix = "_中程防空", support = {} },
        { type = "Hawk ln", radius = 1000, count = 6, suffix = "_远程防空(霍克)",
            support = {
                { type = "Hawk tr", count = 1, offset = {x = 100, y = 50} }, -- 指挥车
                { type = "Hawk pcp", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "Hawk sr", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
                { type = "Hawk cwar", count = 1, offset = {x = -50, y = 50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -50, y = -50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -100, y = -50} }, -- 指挥车
            } },
        { type = {"2S6 Tunguska"}, radius = 2000, count = 3, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger", "Strela-10M3"}, radius = 2000, count = 5, suffix = "_近程防空(红外)", support = {} },
        {
            type = {"Vulcan", "M-2 Bradley", "ZBD04A"},
            radius = 1000,
            count = 5,
            suffix = "_坦克",
            support = {}
        },
    },
    Front_L2 = {
        { type = {"HEMTT_C-RAM_Phalanx"}, radius = 80, count = 1, suffix = "_近防", support = {} },
        { type = "Hawk ln", radius = 1000, count = 6, suffix = "_远程防空(霍克)",
            support = {
                { type = "Hawk tr", count = 1, offset = {x = 100, y = 50} }, -- 指挥车
                { type = "Hawk pcp", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "Hawk sr", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
                { type = "Hawk cwar", count = 1, offset = {x = -50, y = 50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -50, y = -50} }, -- 指挥车
                { type = "Hawk tr", count = 1, offset = {x = -100, y = -50} }, -- 指挥车
            } },
        { type = {"Tor 9A331","CHAP_TorM2"}, radius = 1500, count = 4, suffix = "_中程防空", support = {} },
        { type = {"2S6 Tunguska","CHAP_PantsirS1"}, radius = 2000, count = 3, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger", "Strela-10M3"}, radius = 2000, count = 5, suffix = "_近程防空(红外)", support = {} },
        {
            type = {"M-2 Bradley", "ZBD04A", "Leclerc"},
            radius = 1000,
            count = 5,
            suffix = "_坦克",
            support = {}
        },
    },
    Front_L3 = {
        { type = {"HEMTT_C-RAM_Phalanx"}, radius = 80, count = 2, suffix = "_近防", support = {} },
        { type = "SA-11 Buk LN 9A310M1", radius = 1000, count = 3, suffix = "_远程防空(山毛榉)",
            support = {
                { type = "SA-11 Buk SR 9S18M1", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
            } },
        { type = "SA-11 Buk LN 9A310M1", radius = 1300, count = 3, suffix = "_远程防空(山毛榉)2",
            support = {
                { type = "SA-11 Buk SR 9S18M1", count = 1, offset = {x = 50, y = 0} },   -- 雷达车
                { type = "SA-11 Buk CC 9S470M1", count = 1, offset = {x = -50, y = 0} }, -- 指挥车
            } },
        { type = {"Tor 9A331","CHAP_TorM2"}, radius = 1500, count = 6, suffix = "_中程防空", support = {} },
        { type = {"2S6 Tunguska","CHAP_PantsirS1"}, radius = 2000, count = 4, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger", "Strela-10M3"}, radius = 2000, count = 6, suffix = "_近程防空(红外)", support = {} },
        {
            type = { "ZBD04A", "Leclerc" },
            radius = 1000,
            count = 5,
            suffix = "_坦克",
            support = {}
        },
    },

    Middle_L1 = {
        { type = {"2S6 Tunguska"}, radius = 1100, count = 2, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger"}, radius = 1200, count = 2, suffix = "_近程防空(红外)", support = {} },
        { type = {"Vulcan"}, radius = 1050, count = 2, suffix = "_机炮", support = {} },
        { type = {"M-2 Bradley"}, radius = 500, count = 3, suffix = "_坦克", support = {} },
    },
    Middle_L2 = {
        { type = {"HEMTT_C-RAM_Phalanx"}, radius = 80, count = 1, suffix = "_近防", support = {} },
        { type = {'Tor 9A331'}, radius = 100, count = 2, suffix = "_中程防空", support = {} },
        { type = {"2S6 Tunguska"}, radius = 1100, count = 2, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger"}, radius = 1200, count = 2, suffix = "_近程防空(红外)", support = {} },
        { type = {"Vulcan"}, radius = 1050, count = 2, suffix = "_机炮", support = {} },
        { type = {"M-2 Bradley"}, radius = 500, count = 3, suffix = "_坦克", support = {} },
        { type = {"M1A2C_SEP_V3"}, radius = 500, count = 1, suffix = "_坦克", support = {} },
    },
    Middle_L3 = {
        { type = {"HEMTT_C-RAM_Phalanx"}, radius = 80, count = 2, suffix = "_近防", support = {} },
        { type = {'Tor 9A331',"CHAP_TorM2"}, radius = 100, count = 3, suffix = "_中程防空", support = {} },
        { type = {"2S6 Tunguska"}, radius = 1100, count = 3, suffix = "_近程防空(雷达)", support = {} },
        { type = {"M1097 Avenger"}, radius = 1200, count = 3, suffix = "_近程防空(红外)", support = {} },
        { type = {"Vulcan"}, radius = 1050, count = 3, suffix = "_机炮", support = {} },
        { type = {"M-2 Bradley","M1A2C_SEP_V3"}, radius = 500, count = 5, suffix = "_坦克", support = {} },
    },
}

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

function NP.findUnitControlByPlayer(_groupTable)
    local _playerUnits = {}
    for _, _unitsTable in pairs(_groupTable.units) do
        local _unit = ctld.getAddGroupUnit(_unitsTable.unitName)
        if _unit ~= nil then
            local playerName = _unit:getPlayerName()
            if playerName~=nil then
                _playerUnits[playerName]=_unit
            end
        end
    end
    return _playerUnits
end


function NP.capture(_args)
    NP.logDebug('进入cap函数')
    local _playerUnits = NP.findUnitControlByPlayer(_args)
    NP.logDebug('开始找最近的cc')
    local _hasCloseEnough, _targetLogistic,_capturedPlayerName, _capUsingUnit
    for _playerName,_unit in pairs(_playerUnits) do
        local _closeEnough,_logistic=NP.closeEnoughFromEnemyLogisticZone(_unit)
        if _closeEnough then
            _hasCloseEnough=true
            _targetLogistic=_logistic
            _capturedPlayerName=_playerName
            _capUsingUnit = _unit
        end
    end

    if _hasCloseEnough == nil then
        NP.logInfo('占点不够近')
        trigger.action.outText('提示：请使用地面指挥官控制单位靠近敌方指挥中心（CC）后再执行占领操作；未靠近时无法占领。',10)
        return
    end

    local _logisticData = NP.getLogisticData(_targetLogistic)
    if not _logisticData then
        NP.logError("无法获取目标CC的数据，无法占领。CC名称: " .. _targetLogistic:getName())
        return
    end
    local _side = _capUsingUnit:getCoalition()

    -- Determine initial level and defense behavior
    local initialLevel
    local skipDefenses = false
    local oldCCName = _targetLogistic:getName()
    local oldStatus = NP.CCStatus[oldCCName]
    local oldLevel = oldStatus and oldStatus.level or 3 -- Default to 3 if unknown (shouldn't happen often for existing CCs)

    -- Check if it's a friendly recapture (same coalition but old CC was destroyed/dead)
    if _logisticData.coalitionId == _side then
        initialLevel = oldLevel -- Keep existing level for friendly repair
        skipDefenses = true -- Only respawn CC, do not add/remove units
        NP.logInfo("Friendly recapture/repair detected for: " .. _logisticData.groupName .. ". Keeping Level " .. initialLevel .. ", skipping defense spawn.")
    else
        initialLevel = 2 -- Enemy capture resets to Level 2
        skipDefenses = false -- Spawn new defenses
        NP.logInfo("Enemy/Neutral capture detected for: " .. _logisticData.groupName .. ". Setting to Level 2.")
    end

    if _logisticData.coalitionId ~= _side then
        local defList
        -- When capturing an enemy base, defenses must be cleared first.
        -- We check against the current level's defense config.
        -- If oldStatus is missing, assume L3 to be safe (hardest check).
        local checkLevel = oldStatus and oldStatus.level or 3

        if string.find(_logisticData.groupName, "本场") then
            defList = (checkLevel == 1 and NP.LevelConfigs.Home_L1) or (checkLevel == 2 and NP.LevelConfigs.Home_L2) or NP.LevelConfigs.Home_L3
        elseif string.find(_logisticData.groupName, "中场") then
             defList = (checkLevel == 1 and NP.LevelConfigs.Middle_L1) or (checkLevel == 2 and NP.LevelConfigs.Middle_L2) or NP.LevelConfigs.Middle_L3
        elseif string.find(_logisticData.groupName, "前线") then
             defList = (checkLevel == 1 and NP.LevelConfigs.Front_L1) or (checkLevel == 2 and NP.LevelConfigs.Front_L2) or NP.LevelConfigs.Front_L3
        end

        -- Fallback if defList is somehow nil
        if not defList then defList = NP.LevelConfigs.Home_L3 end

        for idx, def in ipairs(defList) do
            local groupName = _logisticData.groupName .. def.suffix
            local old = Group.getByName(groupName)
            if old then
                local _units = old:getUnits()

                for _, _leader in pairs(_units) do

                        if _leader ~= nil and _leader:getCoalition() ~= _side and _leader:getLife() > 1 then
                        NP.logInfo('占点之前未清除所有防御单位，活着的单位是: '.._leader:getName())
                        trigger.action.outText('占领失败：目标区域仍有存活的防御单位，请先清除残余部队，或使用JTAC/侦察单位协助搜索。',10)
                        return
                    end
                end
            end
        end
    end

    NP.logDebug('开始从mist获取数据')
    local CountryID,Side,Country,CountrySide
    --TODO 抽象这里
    if _side==1 then
        CountryID =country.id.CJTF_RED
        CountrySide="red"
        Side=1
        Country=country.name[CountryID]
    else
        CountryID =country.id.CJTF_BLUE
        CountrySide="blue"
        Side=2
        Country=country.name[CountryID]
    end

    _logisticData.groupName=_logisticData.groupName.. ' '
    _logisticData.name=_logisticData.groupName
    _logisticData.groupId=ctld.getNextGroupId()
    --_logisticData.groupId=nil

    _logisticData.countryId= CountryID
    _logisticData.country= Country
    _logisticData.coalitionId= Side
    _logisticData.coalition= CountrySide

    _logisticData.units[1].groupName=_logisticData.groupName
    _logisticData.units[1].unitName=_logisticData.groupName  -- ..' '  --! Static的name是groupName,放进查找表里的是UnitName,所以两个要一致.
    _logisticData.units[1].unitId= ctld.getNextUnitId()
    --_logisticData.units[1].unitId= nil
    _logisticData.units[1].groupId= _logisticData.groupId

    _logisticData.units[1].countryId= CountryID
    _logisticData.units[1].country= Country
    _logisticData.units[1].coalition= CountrySide
    _logisticData.units[1].coalitionId= Side

    --_logisticData.units[1].alt= land.getHeight({x = _logisticData.units[1].x, y = _logisticData.units[1].y}) - 7
    NP.logDebug('_logistic:'..ctld.p(_targetLogistic))
    NP.logDebug('_logisticData:'..ctld.formatTable(_logisticData))
    --NP.logDebug('_unit:'..ctld.p(_logisticData.units[1]))

    _targetLogistic:destroy()--把老一边的cc做掉
    for index=#ctld.logisticUnits,1,-1 do
        if ctld.logisticUnits[index] == _targetLogistic:getName() then
            table.remove(ctld.logisticUnits,index)
        end
    end


    --mist.dynAddStatic(_logisticData)--生成另一阵营的新cc，同一位置
    timer.scheduleFunction(mist.dynAddStatic, _logisticData, timer.getTime() + 1)
    timer.scheduleFunction(dsave.recordAllCCsElements, nil, timer.getTime() + 20)
    table.insert(ctld.logisticUnits, _logisticData.units[1].unitName)--新的单位加到cc的白名单

    -- Initialize CCStatus for the newly created CC
    NP.CCStatus[_logisticData.units[1].unitName] = {
        level = initialLevel,
        crates = 0,
        upgrading = false,
        upgradeStartTime = 0,
        type = "unknown" -- Placeholder, will be determined by setRelatedZone
    }

    NP.setRelatedZone(_logisticData,_logisticData.units[1].unitName,_logisticData.units[1].coalition, skipDefenses, initialLevel)
    NP.logInfo("战区 ".._logisticData.groupName.." 已被 "..CountrySide.." 阵营占领，操作者：".._capturedPlayerName)
    NP.logDebug("占领后的logisticUnits是："..ctld.p(ctld.logisticUnits))
    trigger.action.outText("战区 ".._logisticData.groupName.." 已被 "..CountrySide.." 阵营占领。操作者：".._capturedPlayerName, 20)
end

function NP.updateCCMarker(ccname, coalition, level, x, y)
    -- Remove existing markers
    mist.marker.remove(ccname)
    mist.marker.remove(ccname .. "_outer")
    mist.marker.remove(ccname .. "_inner")

    local drawColor
    local drawFillColor
    if coalition == "blue" then
        drawColor = {0.1, 0.1, 0.9, 1}
        drawFillColor = {0, 0, 1, 0.3} -- Reduced opacity for circles
    else
        drawColor = {0.9, 0.1, 0.1, 1}
        drawFillColor = {1, 0, 0, 0.3}
    end

    -- Process name: remove "本场", "中场", "前线" and subsequent text
    local displayName = ccname
    local s, e = string.find(displayName, "本场")
    if s then displayName = string.sub(displayName, 1, s - 1) end
    s, e = string.find(displayName, "中场")
    if s then displayName = string.sub(displayName, 1, s - 1) end
    s, e = string.find(displayName, "前线")
    if s then displayName = string.sub(displayName, 1, s - 1) end

    local text = displayName
    if level then
        text = text .. "\nLevel " .. level
    end

    -- Text Marker (Center)
    local textMarker = {
        pos = {x=x+800, z=y+800, y=0},
        name = ccname,
        markType = 5, -- Text
        --radius = 100, -- Small radius for the center point/text anchor
        text = text,
        color = drawColor,
        fillColor = {drawColor[1], drawColor[2], drawColor[3], 0.05},
        lineType = 1,
        readOnly = true,
        fontSize = 16,
    }
    mist.marker.add(textMarker)

    -- Outer Circle (Logistic Distance)
    local innerRadius = ctld.maximumDistanceLogistic or 200
    local innerMarker = {
        pos = {x=x, z=y, y=0},
        name = ccname .. "_outer",
        markType = 2, -- Circle
        radius = innerRadius,
        color = drawColor,
        fillColor = drawFillColor, -- Transparent fill
        lineType = 1, -- Solid line
        readOnly = true,
    }
    mist.marker.add(innerMarker)

    -- Inner Circle (Deploy Distance + 50)
    local outerRadius = (ctld.minimumDeployDistance or 1000) + 50
    local outerMarker = {
        pos = {x=x, z=y, y=0},
        name = ccname .. "_inner",
        markType = 2, -- Circle
        radius = outerRadius,
        color = drawColor,
        fillColor = drawFillColor, -- Transparent fill
        lineType = 2, -- Dashed line for inner? Or solid. Default 1.
        readOnly = true,
    }
    mist.marker.add(outerMarker)
end

function NP.setRelatedZone(static, unitName, coalition, firsttime, level)
    local originalCCname
    --NP.logDebug("[setRelatedZone] 所有的logisticUnits如下: "..ctld.p(ctld.logisticUnits))
    for k,v in pairs(ctld.logisticUnits) do
        if string.find(unitName, v) ~= nil then
            originalCCname = v
            break
        end
    end

    if originalCCname == nil then
        NP.logError('[setRelatedZone] 在ctld.logisticUnits数据表中找不到对应的cc: '..unitName ..'| 阵营:'..coalition)
        return
    end

    local ccname = string.gsub(originalCCname, "%s+", "")
    NP.logInfo('[setRelatedZone] 将cc后面的空格去掉，原cc名称: |'..originalCCname ..'| 参与翻转的cc名称:|'..ccname.."|")

    if  Unitlist[ccname] == nil then
        NP.logError('[setRelatedZone] 在Unitlist.list数据表中找不到对应cc的数据: '.. ccname..'| 阵营:'..coalition)
        return
    end

    -- If level is not provided (e.g. from legacy save load or other calls), try to retrieve it from Status or default to 1? 
    -- Actually for save load, we will update it to pass level. 
    -- If it's missing, we default to 1.
    if not level then
        if NP.CCStatus[unitName] then
            level = NP.CCStatus[unitName].level
        else
            level = 3 -- Default to 3
        end
    end

    -- Ensure status is tracked if not already
    if not NP.CCStatus[unitName] then
         NP.CCStatus[unitName] = {
            level = level,
            crates = 0,
            upgrading = false,
            upgradeStartTime = 0
        }
    end
    -- Update level in status just in case
    NP.CCStatus[unitName].level = level


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
    for _,_Unit in pairs(Unitlist[ccname][coalition]) do
        NP.logInfo('[setRelatedZone] 翻转直升机机位: |'.. _Unit..'| flag为0(true)')
        trigger.action.setUserFlag(_Unit, 0)
    end

    timer.scheduleFunction(function(_args)
        local static, _coalition, _oppsitecoalition, ccname, level = _args[1],_args[2],_args[3],_args[4], _args[5]

        NP.logDebug('传进生成补给的函数的值：'..ctld.p(static).."|".._coalition.."|".._oppsitecoalition)
        local CCunit = static.units[1]

        if 	Unit.getByName(ccname..'_Ammo') ~= nil then
            Unit.getByName(ccname..'_Ammo'):destroy()
        else
            NP.logError('[setRelatedZone] 没有找到要销毁的Ammo: '.. ccname..'_Ammo')
        end
        if 	Unit.getByName(ccname..'_Fuel') ~= nil then
            Unit.getByName(ccname..'_Fuel'):destroy()
        else
            NP.logError('[setRelatedZone] 没有找到要销毁的Fuel: '.. ccname..'_Fuel')
        end
        if 	Unit.getByName(ccname..'_Command') ~= nil then
            Unit.getByName(ccname..'_Command'):destroy()
        else
            NP.logError('[setRelatedZone] 没有找到要销毁的Command: '.. ccname..'_Command')
        end

        local sep_h = 20
        local sep_v = 10

        local rad = CCunit.heading * math.pi / 180
        local left_dx = math.cos(rad + math.pi/2)
        local left_dy = math.sin(rad + math.pi/2)
        local fwd_dx = math.cos(rad)
        local fwd_dy = math.sin(rad)

        local mid_x = CCunit.x + left_dx * sep_h
        local mid_y = CCunit.y + left_dy * sep_h
        local front_x = mid_x + fwd_dx * sep_v
        local front_y = mid_y + fwd_dy * sep_v
        local back_x = mid_x - fwd_dx * sep_v
        local back_y = mid_y - fwd_dy * sep_v


        if StaticObject.getByName(ccname..'_invisibleFarp') == nil then
            local vars =
            {
            type = 'Invisible FARP',
            shape_name = "invisiblefarp",
            country = CCunit.country,
            category = 'Heliports',
            x = CCunit.x,
            y = CCunit.y,
            name = ccname..'_invisibleFarp',
            heading = CCunit.heading,
            --clone = true,
            dead =false,
            }

            mist.dynAddStatic(vars)
        else
            NP.logError('[setRelatedZone] Invisible Farp已存在，无需新建: '.. ccname..'_invisibleFarp')
        end

        timer.scheduleFunction(function()
            local bases = world.getAirbases()
            for _, base in pairs(bases) do
                local desc = Airbase.getDesc(base)
                if desc and desc.typeName == "Invisible FARP" then
                    local invisWH = base:getWarehouse()
                    if invisWH then
                        invisWH:setLiquidAmount(0, 1073741823)
                        invisWH:setLiquidAmount(1, 1073741823)
                        invisWH:setLiquidAmount(2, 1073741823)
                        invisWH:setLiquidAmount(3, 1073741823)
                        for itemId,_ in pairs(weaponTemplate) do
                            invisWH:setItem(itemId, 1073741823)
                        end
                        local invisIV = invisWH:getInventory()
                        NP.logDebug("[setRelatedZone] Invisible FARP的Inventory: " .. ctld.p(invisIV))
                    end
                end
            end
        end, {}, timer.getTime()+5)

        -- local vars2 = 
        -- {
        -- type = 'FARP Ammo Dump Coating', 
        -- country = CCunit.country, 
        -- category = 'Fortifications', 
        -- x = front_x, 
        -- y = front_y,
        -- name = ccname..'_Ammo', 
        -- heading = CCunit.heading,
        -- --clone = true,
        -- dead =false,
        -- }

        -- mist.dynAddStatic(vars2)

        -- local vars3 = 
        -- {
        -- type = 'FARP Fuel Depot', 
        -- country = CCunit.country, 
        -- category = 'Fortifications', 
        -- x = back_x, 
        -- y = back_y,
        -- name = ccname..'_Fuel', 
        -- heading = CCunit.heading,
        -- --clone = true,
        -- dead =false,
        -- }

        -- mist.dynAddStatic(vars3)

        -- local vars4 = 
        -- {
        -- type = 'FARP CP Blindage', 
        -- country = CCunit.country, 
        -- category = 'Fortifications', 
        -- x = mid_x, 
        -- y = mid_y,
        -- name = ccname..'_Command', 
        -- heading = CCunit.heading,
        -- --clone = true,
        -- dead =false,
        -- }

        -- mist.dynAddStatic(vars4)

        local unitCommand = {
            ["y"] = mid_y,
            ["x"] = mid_x,
            ["name"] = ccname..'_Command',
            ["heading"] = CCunit.heading,
            ["playerCanDrive"] = false,
            ["skill"] = "Excellent",
        }
        local unitAmmo = {
            ["y"] = front_y,
            ["x"] = front_x,
            ["name"] = ccname..'_Ammo',
            ["heading"] = CCunit.heading,
            ["playerCanDrive"] = false,
            ["skill"] = "Excellent",
        }
        local unitFuel = {
            ["y"] = back_y,
            ["x"] = back_x,
            ["name"] = ccname..'_Fuel',
            ["heading"] = CCunit.heading,
            ["playerCanDrive"] = false,
            ["skill"] = "Excellent",
        }
        if _coalition == "blue" then
            unitCommand.type = "Hummer"
            unitAmmo.type = "M 818"
            unitFuel.type = "M978 HEMTT Tanker"
        else
            unitCommand.type = "SKP-11"
            unitAmmo.type = "ZIL-135"
            unitFuel.type = "ATZ-10"
        end
        local _group = {
            ["visible"] = false,
            ["hiddenOnPlanner"] = true,
            ["uncontrollable"] = true,
            ["hiddenOnMFD"] = true,
            ["hidden"] = true,
            ["country"] = CCunit.country,
            ["units"] = {},
            -- ["y"] = mid_x,
            -- ["x"] = mid_y,
            -- ["name"] = ccname..'_Command',
            ["heading"] = CCunit.heading,
            ["task"] = {},
        }
        _group.units[1] = unitCommand
        _group.units[2] = unitFuel
        _group.units[3] = unitAmmo
        _group.category = Group.Category.GROUND
        local _spawnedGroup = Group.getByName(mist.dynAdd(_group).name)
        Controller.setCommand(_spawnedGroup:getController(), {
            id = 'SetImmortal',
            params = {
                value = true
            }
        })
        Controller.setCommand(_spawnedGroup:getController(), {
            id = 'SetInvisible',
            params = {
                value = true
            }
        })
        _spawnedGroup:getController():setOption(8,false)

        NP.updateCCMarker(ccname, _coalition, level, CCunit.x, CCunit.y)

    end, {static,coalition,oppsitecoalition,ccname, level} , timer.getTime()+5)

    NP.logInfo('[setRelatedZone] 占领CC的流程完成: '.. ccname..'| 阵营:'..coalition)
    if not firsttime then
        -- Use the updated spawn function which handles selecting the right config based on level
        NP.spawnDefenseFromUnitlist(static, level, coalition, ccname)
    else
        NP.logInfo('[setRelatedZone] 有保存的存档，不重新生成防御单位：'.. ccname..'| 阵营:'..coalition)
    end
end

function NP.spawnDefenseFromUnitlist(static, level, coalition, ccName)
    local CCunit = static.units[1]
    local country = CCunit.country

    -- Default to level 1 if not provided (should be provided)
    if not level then level = 1 end

    local defTable = nil
    if string.find(ccName, "本场") then
        if level == 1 then defTable = NP.LevelConfigs.Home_L1
        elseif level == 2 then defTable = NP.LevelConfigs.Home_L2
        else defTable = NP.LevelConfigs.Home_L3 end
    elseif string.find(ccName, "中场") then
        if level == 1 then defTable = NP.LevelConfigs.Middle_L1
        elseif level == 2 then defTable = NP.LevelConfigs.Middle_L2
        else defTable = NP.LevelConfigs.Middle_L3 end
    elseif string.find(ccName, "前线") then
        if level == 1 then defTable = NP.LevelConfigs.Front_L1
        elseif level == 2 then defTable = NP.LevelConfigs.Front_L2
        else defTable = NP.LevelConfigs.Front_L3 end
    end

    if not defTable then
        NP.logError("[spawnDefenseFromUnitlist] Could not determine defense configuration for: " .. ccName .. " Level: " .. level)
        return
    end

    local groupCount = #defTable
    local totalUnits = 0
    for _, def in ipairs(defTable) do
        totalUnits = totalUnits + def.count
    end

    for idx, def in ipairs(defTable) do
        local groupName = ccName .. def.suffix

        -- 已存在就销毁
        local old = Group.getByName(groupName)
        if old then
            NP.logInfo(string.format("[spawnDefenseFromUnitlist] 已存在同名群组，先销毁: %s", groupName))
            old:destroy()
        end

        local group = {
            visible = false,
            hidden = false,
            units = {},
            name = groupName,
            task = {},
            playerCanDrive = false,
            country = country,
            category = Group.Category.GROUND
        }

        -- 每个群组在圆周上的起始角度均分
        local groupStartAngle = 2 * math.pi * (idx - 1) / totalUnits
        local angleStep = 2 * math.pi / def.count  -- 群组内部单位均分 360°

        for i = 1, def.count do
            local angleBase = groupStartAngle + (i - 1) * angleStep

            -- Randomize Phase: Range is pi/2 (+/- pi/4)
            local angleRandom = (math.random() - 0.5) * (math.pi / 2)
            local finalAngle = angleBase + angleRandom

            -- Randomize Radius: Range is 50% of radius (+/- 25%)
            local radiusRandomFactor = 1 + (math.random() - 0.5) * 0.5
            local finalRadius = def.radius * radiusRandomFactor

            local x = CCunit.x + math.cos(finalAngle) * finalRadius
            local y = CCunit.y + math.sin(finalAngle) * finalRadius

            local launcherName = string.format("%s_unit%d", groupName, i)
            local unitType
            if type(def.type) == "table" then
                -- def.type 是数组，按索引循环取
                unitType = def.type[((i-1) % #def.type) + 1]
            else
                -- def.type 是单个字符串
                unitType = def.type
            end
            table.insert(group.units, {
                type = unitType,
                --unitId = ctld.getNextUnitId(), --! 操你妈，没事别赋值unitId，会导致机位选不了（跟slotId冲突）
                name = launcherName,
                x = x,
                y = y,
                heading = finalAngle,
                skill = "High"
            })

            -- 支援单位只生成在每组第一辆主力旁边
            if def.support and #def.support > 0 and i == 1 then
                for _, sup in ipairs(def.support) do
                    for r = 1, sup.count do
                        table.insert(group.units, {
                            type = sup.type,
                            --unitId = ctld.getNextUnitId(),
                            name = string.format("%s_support_%s_%d", groupName, sup.type, r),
                            x = x + (sup.offset and sup.offset.x or 0) + (r-1) * 10,
                            y = y + (sup.offset and sup.offset.y or 0),
                            heading = finalAngle,
                            skill = "High"
                        })
                    end
                end
            end
        end

        -- 生成群组
        local newGroup = mist.dynAdd(group)
        if newGroup then
            NP.logInfo(string.format("[spawnDefenseFromUnitlist] 生成群组: %s (主力 %d + 支援 %d)",
                groupName, def.count, def.support and #def.support or 0))
        else
            NP.logError("[spawnDefenseFromUnitlist] 生成失败: " .. groupName)
        end
    end
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
        if _logistic ~= nil and ((_logistic:getCoalition() ~= _unitObject:getCoalition()) or _logistic:getLife() <= 0)  then
            local _dist = ctld.getDistance(_unitPoint, _logistic:getPoint())
            if _dist <= NP.CaptureDistance then
                _closeEnough = true
                return _closeEnough,_logistic
            end
        end
    end

    return _closeEnough,_logistic
end

function NP.RespawnAwacs()
    for _, _plane in pairs(NP.AWACSList) do
        local _grp = Group.getByName(_plane)
        local AWCAS = _grp and _grp:getUnit(1)
        if AWCAS ~= nil then
            local _found = false
            for _, _existingEWR in pairs(ctld.EWRunits) do
                if _existingEWR and _existingEWR:isExist() and _existingEWR:getName() == _grp:getName() then
                    _found = true
                    break
                end
            end
            if not _found then
                table.insert(ctld.EWRunits,_grp)
            end

            if Unit.getFuel(AWCAS) < 0.3 then
                mist.respawnGroup(_plane, true)
                NP.logInfo(_plane.."油量低，重生")
                trigger.action.outText("预警机梯队没油了，后续梯队正在交接！", 10)
            end
        else
            NP.logError('[RespawnAwacs]检测预警机时找不到该预警机单位'.._plane.."|")
        end
    end
    timer.scheduleFunction(NP.RespawnAwacs, {}, timer.getTime() + 900)
end

function NP.InitInvisTemplate()
    local bases = world.getAirbases()
    for _, base in pairs(bases) do
        local desc = Airbase.getDesc(base)
        if Airbase.getUnit(base) then
            local unitName = Airbase.getUnit(base):getName()
            if unitName == "invisTemplate" then
                weaponTemplate = base:getWarehouse():getInventory().weapon
                liquidsTemplate = base:getWarehouse():getInventory().liquids
                NP.logDebug("获取到Invisible FARP的仓库模板"..ctld.p(weaponTemplate))
            end
        end
    end
end

timer.scheduleFunction(NP.InitInvisTemplate, {}, timer.getTime() + 5)

timer.scheduleFunction(NP.RespawnAwacs, {}, timer.getTime() + 90)
net.log("LOAD SUCCESS - NP version "..NP.Version ..", script by VL")
