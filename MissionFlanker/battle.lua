SourceObj = SourceObj or {}

do
    aDuration = 0
    bDuration = 0
    cDuration = 0
    Occupy_Duration = 300--时间
    pointaisblue = 0
    pointaisred = 0
    pointbisblue = 0
    pointbisred = 0
    pointcisblue = 0
    pointcisred = 0
    abattle = 0
    bbattle = 0
    cbattle = 0
    ta = 0
    tb = 0
    tc = 0
    astop = 0
    bstop = 0
    cstop = 0
    _aOccupied = nil
    _bOccupied = nil
    _cOccupied = nil

    function battleA()
        local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
        local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

        local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"pointa"})
        local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"pointa"})

        if pointaisblue == 0 and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
            --trigger.action.setUserFlag(1, false)
            --trigger.action.setUserFlag(2, true)
            if _aOccupied ~= coalition.side.BLUE then
                if _aOccupied == coalition.side.RED then
                  _aOccupied = coalition.side.BLUE
                  aDuration = 0 - aDuration 
                  pointaisred = 0
                else
                  _aOccupied = coalition.side.BLUE
                  aDuration = 0 
                end
                trigger.action.outText("蓝方正在占领A点", 15)
            else
                aDuration = aDuration + 1
                if (aDuration < Occupy_Duration) then
                    ta = aDuration / Occupy_Duration * 100
                    ta = ta-ta%0.01
                    astop = 0
                    --trigger.action.outText("蓝方正在占领A点，占领进度"..ta, 1)
                else                    
                    trigger.action.outText("蓝方已占领A点", 15) 
                    pointaisblue = 1
                end
            end
            if abattle == 1 then
                trigger.action.outText("蓝方正在占领A点", 15)
                abattle = 0
            end
        elseif pointaisred == 0 and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
            if _aOccupied ~= coalition.side.RED then
                if _aOccupied == coalition.side.BLUE then
                  _aOccupied = coalition.side.RED
                  aDuration = 0 - aDuration 
                  pointaisblue = 0
                else
                  _aOccupied = coalition.side.RED
                  aDuration = 0 
                end
                trigger.action.outText("红方正在占领A点", 15)
            else               
                aDuration = aDuration + 1
                if (aDuration < Occupy_Duration) then
                    ta = aDuration / Occupy_Duration * 100
                    ta = ta-ta%0.01
                    astop = 0
                    --trigger.action.outText("红方正在占领A点，占领进度"..ta, 1)
                else
                    trigger.action.outText("红方已占领A点", 15)
                    pointaisred = 1
                end
            end
            if abattle == 1 then
                trigger.action.outText("红方正在占领A点", 15)
                abattle = 0
            end
        elseif abattle == 0 and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) > 0 then
            trigger.action.outText("双方正在争夺A点", 15) 
            abattle = 1
        elseif table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) == 0 and pointaisred ~= 1 and pointaisblue ~= 1 then
            if _aOccupied == coalition.side.BLUE then
                if astop == 0 then
                  trigger.action.outText("蓝方停止占领A点", 15)
                  astop = 1
                end
                if aDuration > 0 then
                    aDuration = aDuration - 1
                end
                if aDuration < 0 then
                    aDuration = aDuration + 1
                end
            elseif _aOccupied == coalition.side.RED then
                if astop == 0 then
                    trigger.action.outText("红方停止占领A点", 15)
                    astop = 1
                end
                if aDuration > 0 then
                    aDuration = aDuration - 1
                end
                if aDuration < 0 then
                    aDuration = aDuration + 1
                end
            end
        end
    end
    
    function battleB()
        local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
        local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

        local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"pointb"})
        local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"pointb"})

        if pointbisblue == 0 and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
            --trigger.action.setUserFlag(1, false)
            --trigger.action.setUserFlag(2, true)
            if _bOccupied ~= coalition.side.BLUE then
                if _bOccupied == coalition.side.RED then
                  _bOccupied = coalition.side.BLUE
                  bDuration = 0 - bDuration
                  pointbisred = 0 
                else
                  _bOccupied = coalition.side.BLUE
                  bDuration = 0 
                end
                trigger.action.outText("蓝方正在占领B点", 15)
            else
                bDuration = bDuration + 1
                if (bDuration < Occupy_Duration) then
                    tb = bDuration / Occupy_Duration * 100
                    tb = tb-tb%0.01
                    bstop = 0
                    --trigger.action.outText("蓝方正在占领A点，占领进度"..ta, 1)
                else                    
                    trigger.action.outText("蓝方已占领B点", 15) 
                    pointbisblue = 1
                end
            end
            if bbattle == 1 then
                trigger.action.outText("蓝方正在占领B点", 15)
                bbattle = 0
            end
        elseif pointbisred == 0 and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
            if _bOccupied ~= coalition.side.RED then
                if _bOccupied == coalition.side.BLUE then
                  _bOccupied = coalition.side.RED
                  bDuration = 0 - bDuration 
                  pointbisblue = 0
                else
                  _bOccupied = coalition.side.RED
                  bDuration = 0 
                end
                trigger.action.outText("红方正在占领B点", 15)
            else
                bDuration = bDuration + 1
                if (bDuration < Occupy_Duration) then
                    tb = bDuration / Occupy_Duration * 100
                    tb = tb-tb%0.01
                    bstop = 0
                    --trigger.action.outText("红方正在占领A点，占领进度"..ta, 1)
                else
                    trigger.action.outText("红方已占领B点", 15)
                    pointbisred = 1
                end
            end
            if bbattle == 1 then
                trigger.action.outText("红方正在占领B点", 15)
                bbattle = 0
            end
        elseif bbattle == 0 and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) > 0 then
            trigger.action.outText("双方正在争夺B点", 15) 
            bbattle = 1
        elseif table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) == 0 and pointbisred ~= 1 and pointbisblue ~= 1 then
            if _bOccupied == coalition.side.BLUE then
                if bstop == 0 then
                    trigger.action.outText("蓝方停止占领B点", 15)
                    bstop = 1
                end
                if bDuration > 0 then
                    bDuration = bDuration - 1
                end
                if bDuration < 0 then
                    bDuration = bDuration + 1
                end
            elseif _bOccupied == coalition.side.RED then
                if bstop == 0 then
                    trigger.action.outText("红方停止占领B点", 15)
                    bstop = 1
                end
                if bDuration > 0 then
                    bDuration = bDuration - 1
                end
                if bDuration < 0 then
                    bDuration = bDuration + 1
                end
            end
        end
    end

    function battleC()
        local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
        local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

        local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"pointc"})
        local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"pointc"})

        if pointcisblue == 0 and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
            --trigger.action.setUserFlag(1, false)
            --trigger.action.setUserFlag(2, true)
            if _cOccupied ~= coalition.side.BLUE then
                if _cOccupied == coalition.side.RED then
                  _cOccupied = coalition.side.BLUE
                  cDuration = 0 - cDuration
                  pointcisred = 0 
                else
                  _cOccupied = coalition.side.BLUE
                  cDuration = 0 
                end
                trigger.action.outText("蓝方正在占领C点", 15)
            else
                cDuration = cDuration + 1
                if (cDuration < Occupy_Duration) then
                    tc = cDuration / Occupy_Duration * 100
                    tc = tc-tc%0.01
                    cstop = 0
                    --trigger.action.outText("蓝方正在占领A点，占领进度"..ta, 1)
                else                    
                    trigger.action.outText("蓝方已占领C点", 15) 
                    pointcisblue = 1
                end
            end
            if cbattle == 1 then
                trigger.action.outText("蓝方正在占领C点", 15)
                cbattle = 0
            end
        elseif pointcisred == 0 and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
            if _cOccupied ~= coalition.side.RED then
                if _cOccupied == coalition.side.BLUE then
                  _cOccupied = coalition.side.RED
                  cDuration = 0 - cDuration 
                  pointcisblue = 0
                else
                  _cOccupied = coalition.side.RED
                  cDuration = 0 
                end
                trigger.action.outText("红方正在占领C点", 15)
            else
                cDuration = cDuration + 1
                if (cDuration < Occupy_Duration) then
                    tc = cDuration / Occupy_Duration * 100
                    tc = tc-tc%0.01
                    cstop = 0
                    --trigger.action.outText("红方正在占领A点，占领进度"..ta, 1)
                else
                    trigger.action.outText("红方已占领C点", 15)
                    pointcisred = 1
                end
            end
            if cbattle == 1 then
                trigger.action.outText("红方正在占领C点", 15)
                cbattle = 0
            end
        elseif cbattle == 0 and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) > 0 then
            trigger.action.outText("双方正在争夺C点", 15) 
            cbattle = 1
        elseif table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) == 0 and pointcisred ~= 1 and pointcisblue ~= 1 then
            if _cOccupied == coalition.side.BLUE then
                if cstop == 0 then
                    trigger.action.outText("蓝方停止占领C点", 15)
                    cstop = 1
                end
                if cDuration > 0 then
                    cDuration = cDuration - 1
                end
                if cDuration < 0 then
                    cDuration = cDuration + 1
                end
            elseif _cOccupied == coalition.side.RED then
                if cstop == 0 then
                    trigger.action.outText("红方停止占领C点", 15)
                    cstop = 1
                end
                if cDuration > 0 then
                  cDuration = cDuration - 1
                end
                if cDuration < 0 then
                    cDuration = cDuration + 1
                end
            end
        end
    end

    function checkbattle()
        if pointaisred == 0 and _aOccupied == coalition.side.RED then
            trigger.action.outText("红方正在占领A点，占领进度"..ta.."%", 15)
        elseif pointaisblue == 0 and _aOccupied == coalition.side.BLUE then
            trigger.action.outText("蓝方正在占领A点，占领进度"..ta.."%", 15)
        elseif pointaisblue == 1 then
            trigger.action.outText("蓝方已占领A点", 15)
        elseif pointaisred == 1 then
            trigger.action.outText("红方已占领A点", 15)
        elseif abattle == 1 then
            trigger.action.outText("双方正在争夺A点", 15)
        else
            trigger.action.outText("无人占领A点", 15)
        end

        if pointbisred == 0 and _bOccupied == coalition.side.RED then
            trigger.action.outText("红方正在占领B点，占领进度"..tb.."%", 15)
        elseif pointbisblue == 0 and _bOccupied == coalition.side.BLUE then
            trigger.action.outText("蓝方正在占领B点，占领进度"..tb.."%", 15)
        elseif pointbisblue == 1 then
            trigger.action.outText("蓝方已占领B点", 15)
        elseif pointbisred == 1 then
            trigger.action.outText("红方已占领B点", 15)
        elseif bbattle == 1 then
            trigger.action.outText("双方正在争夺B点", 15)
        else
            trigger.action.outText("无人占领B点", 15)
        end

        if pointcisred == 0 and _cOccupied == coalition.side.RED then
            trigger.action.outText("红方正在占领C点，占领进度"..tc.."%", 15)
        elseif pointcisblue == 0 and _cOccupied == coalition.side.BLUE then
            trigger.action.outText("蓝方正在占领C点，占领进度"..tc.."%", 15)
        elseif pointcisblue == 1 then
            trigger.action.outText("蓝方已占领C点", 15)
        elseif pointcisred == 1 then
            trigger.action.outText("红方已占领C点", 15)
        elseif cbattle == 1 then
            trigger.action.outText("双方正在争夺C点", 15)
        else
            trigger.action.outText("无人占领C点", 15)
        end
    end

    function lessticket()
        if pointaisred + pointbisred + pointcisred > pointaisblue + pointbisblue + pointcisblue then
           SourceObj.BLUEPOINT = SourceObj.BLUEPOINT - 5*((pointaisred + pointbisred + pointcisred)-(pointaisblue + pointbisblue + pointcisblue))
        elseif pointaisred + pointbisred + pointcisred < pointaisblue + pointbisblue + pointcisblue then
            SourceObj.REDPOINT = SourceObj.REDPOINT - 5*((pointaisblue + pointbisblue + pointcisblue)-(pointaisred + pointbisred + pointcisred))
        end
    end

    function displayticket()
        trigger.action.outText(string.format("红方拥有资源点:%s  蓝方拥有资源点:%s", tostring(SourceObj.REDPOINT), tostring(SourceObj.BLUEPOINT)), 15)
    end

    local displayRequests = missionCommands.addSubMenu( "战场查询")
    missionCommands.addCommand("查询战场态势", displayRequests , checkbattle, {})

    mist.scheduleFunction(battleA, {}, timer.getTime() + 5 ,1)
    mist.scheduleFunction(battleB, {}, timer.getTime() + 5 ,1)
    mist.scheduleFunction(battleC, {}, timer.getTime() + 5 ,1)
    mist.scheduleFunction(lessticket, {}, timer.getTime() + 5 ,1)
    mist.scheduleFunction(checkbattle, {}, timer.getTime() + 5, 60)
    mist.scheduleFunction(displayticket, {}, timer.getTime() + 5 ,90)
    
end

    
            
      
            