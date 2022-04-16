
do
  centerIsRed = false
  centerIsBlue = false
  center2IsRed = false
  center2IsBlue = false
  center3IsRed = false
  center3IsBlue = false
  center4IsRed = false
  center4IsBlue = false
  center5IsRed = false
  center5IsBlue = false
  center6IsRed = false
  center6IsBlue = false
  blueHasFront = false
  redHasFront = false
  --blueHasFront2 = false
  --redHasFront2 = false

  blueAWACS = "blueAWACS"
  blueAWACS2 = "blueAWACS2"
  
  redAWACS = "redAWACS"
  redAWACS2 = "redAWACS2"

  timeStartMissionF = 0
  AWACS_TankerRepawnTime = 7200
  timeStartBlueAWACS = 0
  timeStartRedAWACS = 0
  needrespawnAWACS = false

  function activateBlueCenterFlight()
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #001", 0)
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #002", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-4", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-4", 0)

    
  end


  function activateRedCenterFlight()
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #001", 0)
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #002", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-4", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-4", 0)

    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-1", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-2", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-3", 0)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-4", 0)

  end

  function activateBlueCenter2Flight()
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #003", 0)
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #004", 0)

    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-4", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-4", 0)

  end

  function activateRedCenter2Flight()
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #003", 0)
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #004", 0)

    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-4", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-4", 0)

    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-1", 0)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-2", 0)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-3", 0)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-4", 0)


    
  end

  function deactivateBlueCenterFlight()
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #001", 100)
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Blue #002", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）B1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）B1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B1-4", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）B2-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）B1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）B1-4", 100)

  end

  function deactivateRedCenterFlight()
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #001", 100)
    -- trigger.action.setUserFlag("苏呼米(中间) Ka-50 Red #002", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】黑鲨（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】雌鹿（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】阿帕奇（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】河马（运输）R1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】休伊（运输）R1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R1-4", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】小羚羊（支援+运输）R2-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】野驴（运输）R1-4", 100)

    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-1", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-2", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-3", 100)
    trigger.action.setUserFlag("【奥恰姆奇拉】蚊子（运输）R1-4", 100)

  end

  function deactivateBlueCenter2Flight()
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #003", 100)
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Blue #004", 100)

    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）B1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）B1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B1-4", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）B2-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）B1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）B1-4", 100)



  end

  function deactivateRedCenter2Flight()
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #003", 100)
    -- trigger.action.setUserFlag("科尔奇(中间) Ka-50 Red #004", 100)

    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】黑鲨（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】雌鹿（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】阿帕奇（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】河马（运输）R1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】休伊（运输）R1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R1-4", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】小羚羊（支援+运输）R2-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】野驴（运输）R1-4", 100)

    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-1", 100)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-2", 100)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-3", 100)
    trigger.action.setUserFlag("【阿纳克里厄】蚊子（运输）R1-4", 100)



  end

  function activateBlueCenter3Flight()
    -- trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #001", 0)
    -- trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #002", 0)

    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-4", 0)

    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-4", 0)

    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-4", 0)

    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-4", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-1", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-2", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-3", 0)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-4", 0)

    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-4", 0)

    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-1", 0)
    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-2", 0)
    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-3", 0)
    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-4", 0)


  end

  function activateRedCenter3Flight()
    -- trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #001", 0)
    -- trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #002", 0)

    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-4", 0)

    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-4", 0)

    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-4", 0)

    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-4", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-1", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-2", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-3", 0)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-4", 0)

    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-4", 0)

    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-1", 0)
    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-2", 0)
    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-3", 0)
    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-4", 0)


  end

  function deactivateRedCenter3Flight()
    -- trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #001", 100)
    -- trigger.action.setUserFlag("科尔奇(本场) Ka-50 Red #002", 100)

    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】黑鲨（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】雌鹿（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】阿帕奇（对地+运输）R1-4", 100)

    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】河马（运输）R1-4", 100)

    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】休伊（运输）R1-4", 100)

    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R1-4", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-1", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-2", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-3", 100)
    trigger.action.setUserFlag("【科尔奇】小羚羊（支援+运输）R2-4", 100)

    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】野驴（运输）R1-4", 100)

    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-1", 100)
    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-2", 100)
    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-3", 100)
    trigger.action.setUserFlag("【科尔奇】蚊子（运输）R1-4", 100)

  end

  function deactivateBlueCenter3Flight()
    -- trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #001", 100)
    -- trigger.action.setUserFlag("苏呼米(本场) Ka-50 Blue #002", 100)

    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】黑鲨（对地+运输）B1-4", 100)
    
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】雌鹿（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】阿帕奇（对地+运输）B1-4", 100)

    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】河马（运输）B1-4", 100)

    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】休伊（运输）B1-4", 100)

    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B1-4", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-1", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-2", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-3", 100)
    trigger.action.setUserFlag("【苏呼米】小羚羊（支援+运输）B2-4", 100)

    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】野驴（运输）B1-4", 100)

    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-1", 100)
    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-2", 100)
    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-3", 100)
    trigger.action.setUserFlag("【苏呼米】蚊子（运输）B1-4", 100)

  end

  function activateBlueFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #001", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #002", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #003", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #004", 0)

  end

  function activateRedFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Red #001", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #002", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #003", 0)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #004", 0)

  end

  function deactivateBlueFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #001", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #002", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #003", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Blue #004", 100)

  end

  function deactivateRedFrontFlight()
    trigger.action.setUserFlag("主战区(前线) A-10A Red #001", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #002", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #003", 100)
    trigger.action.setUserFlag("主战区(前线) A-10A Red #004", 100)

  end

  function deactivateBlueFront3Flight()
    trigger.action.setUserFlag("主战区(本场) F/A-18C #001Blue", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #002Blue", 100)

  end

  function deactivateRedFront3Flight()
    trigger.action.setUserFlag("主战区(本场) F/A-18C #001Red", 100)
    trigger.action.setUserFlag("主战区(本场) F/A-18C #002Red", 100)

  end

  function removeStaticObjF(Obj)
    if Obj then
      Obj:destroy()
    end
  end

  function missionScriptsInitFlanker()
    trigger.action.setUserFlag("Block", 100)

    timeStartMissionF = timer.getTime()
    timeStartBlueAWACS = timeStartMissionF
    timeStartRedAWACS = timeStartMissionF

    blueNoWeaponZoneF = trigger.misc.getZone("noWeaponBlueZone")
    redNoWeaponZoneF = trigger.misc.getZone("noWeaponRedZone")
    searchVolSBlueF = {
      id = world.VolumeType.SPHERE,
      params = {
        point = blueNoWeaponZoneF.point,
        radius = blueNoWeaponZoneF.radius
      }
    }
    searchVolSRedF = {
      id = world.VolumeType.SPHERE,
      params = {
        point = redNoWeaponZoneF.point,
        radius = redNoWeaponZoneF.radius
      }
    }

    logisticBlue1 = "logistic Blue #001"
    logisticBlue1S = "logistic Blue #001"

    logisticBlue2 = "logistic Blue #002"
    logisticBlue2S = "logistic Blue #002"
    removeStaticObjF(StaticObject.getByName(logisticBlue2))

    logisticBlue3 = "logistic Blue #003"
    logisticBlue3S = "logistic Blue #003"
    removeStaticObjF(StaticObject.getByName(logisticBlue3))

    logisticBlue4 = "logistic Blue #004"
    logisticBlue4S = "logistic Blue #004"
    removeStaticObjF(StaticObject.getByName(logisticBlue4))

    logisticBlue5 = "logistic Blue #005"
    logisticBlue5S = "logistic Blue #005"
    removeStaticObjF(StaticObject.getByName(logisticBlue5))

    

    logisticRed1 = "logistic Red #001"
    logisticRed1S = "logistic Red #001"

    logisticRed2 = "logistic Red #002"
    logisticRed2S = "logistic Red #002"
    removeStaticObjF(StaticObject.getByName(logisticRed2))

    logisticRed3 = "logistic Red #003"
    logisticRed3S = "logistic Red #003"
    removeStaticObjF(StaticObject.getByName(logisticRed3))

    logisticRed4 = "logistic Red #004"
    logisticRed4S = "logistic Red #004"
    removeStaticObjF(StaticObject.getByName(logisticRed4))

    logisticRed5 = "logistic Red #005"
    logisticRed5S = "logistic Red #005"
    removeStaticObjF(StaticObject.getByName(logisticRed5))

    

    deactivateBlueFrontFlight()
    deactivateRedFrontFlight()
    --deactivateBlueFront2Flight()
    --deactivateRedFront2Flight()
    deactivateBlueCenterFlight()
    deactivateRedCenterFlight()
    deactivateBlueCenter2Flight()
    deactivateRedCenter2Flight()
    deactivateBlueCenter3Flight()
    deactivateRedCenter3Flight()
  end

  function baseCaptureFlanker()
    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"科尔奇前线停机坪"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"科尔奇前线停机坪"})

    if center2IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      --trigger.action.setUserFlag(1, false)
      --trigger.action.setUserFlag(2, true)
      removeStaticObjF(StaticObject.getByName(logisticBlue5S))
      logisticBlue5S = mist.respawnGroup(logisticBlue5, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed5S))
      mist.respawnGroup('071blue1',true)
      local myGroup = Group.getByName('071red2')
      if myGroup ~= nil then
        Group.destroy(myGroup)
      end
      
      activateBlueCenter2Flight()
      deactivateRedCenter2Flight()

      center2IsBlue = true
      center2IsRed = false
      trigger.action.outText("蓝方已夺取科尔奇前线停机坪！", 30, false)

      mist.respawnGroup("Blue RearmCenter #002", true)
    elseif center2IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      --trigger.action.setUserFlag(1, true)
      --trigger.action.setUserFlag(2, false)
      removeStaticObjF(StaticObject.getByName(logisticRed5S))
      logisticRed5S = mist.respawnGroup(logisticRed5, false).name      
      removeStaticObjF(StaticObject.getByName(logisticBlue5S))
      mist.respawnGroup('071red2',true)
      local myGroup = Group.getByName('071blue1')
      if myGroup ~= nil then
        Group.destroy(myGroup)
      end
      
      

      activateRedCenter2Flight()
      deactivateBlueCenter2Flight()

      center2IsRed = true
      center2IsBlue = false
      trigger.action.outText("红方已夺取科尔奇前线停机坪！", 30, false)

      mist.respawnGroup("Red RearmCenter #002", true)
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"苏呼米前线停机坪"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"苏呼米前线停机坪"})

    if centerIsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      --trigger.action.setUserFlag(1, false)
      --trigger.action.setUserFlag(2, true)
      removeStaticObjF(StaticObject.getByName(logisticBlue3S))
      logisticBlue3S = mist.respawnGroup(logisticBlue3, false).name      
      removeStaticObjF(StaticObject.getByName(logisticRed3S))
      mist.respawnGroup('071blue2',true)
      local myGroup = Group.getByName('071red1')
      if myGroup ~= nil then
        Group.destroy(myGroup)
      end

      activateBlueCenterFlight()
      deactivateRedCenterFlight()

      centerIsBlue = true
      centerIsRed = false
      trigger.action.outText("蓝方已夺取苏呼米前线停机坪！", 30, false)

      mist.respawnGroup("Blue RearmCenter #001", true)
    elseif centerIsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      --trigger.action.setUserFlag(1, true)
      --trigger.action.setUserFlag(2, false)
      removeStaticObjF(StaticObject.getByName(logisticRed3S))
      logisticRed3S = mist.respawnGroup(logisticRed3, false).name      
      removeStaticObjF(StaticObject.getByName(logisticBlue3S))
      mist.respawnGroup('071red1',true)
      local myGroup = Group.getByName('071blue2')
      if myGroup ~= nil then
        Group.destroy(myGroup)
      end
           

      activateRedCenterFlight()
      deactivateBlueCenterFlight()

      centerIsRed = true
      centerIsBlue = false
      trigger.action.outText("红方已夺取苏呼米前线停机坪！", 30, false)

      mist.respawnGroup("Red RearmCenter #001", true)
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"苏呼米机场"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"苏呼米机场"})

    if center3IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      --trigger.action.setUserFlag(1, false)
      --trigger.action.setUserFlag(2, true)
      removeStaticObjF(StaticObject.getByName(logisticBlue4S))
      logisticBlue4S = mist.respawnGroup(logisticBlue4, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed2S))

      activateBlueCenter3Flight()
      deactivateRedFrontFlight()

      center3IsBlue = true
      center3IsRed = false
      trigger.action.outText("蓝方已夺取红方前线机场-【苏呼米】，同志们，为了胜利和荣耀，向古达乌塔冲锋！", 30, false)

      
    elseif center3IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      --trigger.action.setUserFlag(1, true)
      --trigger.action.setUserFlag(2, false)
      removeStaticObjF(StaticObject.getByName(logisticRed2S))
      logisticRed2S = mist.respawnGroup(logisticRed2, false).name
      removeStaticObjF(StaticObject.getByName(logisticBlue4S))

      activateRedFrontFlight()
      deactivateBlueCenter3Flight()

      center3IsRed = true
      center3IsBlue = false
      trigger.action.outText("红方已拥有苏呼米机场！", 30, false)

      
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"科尔奇机场"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"科尔奇机场"})

    if center4IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue2S))
      logisticBlue2S = mist.respawnGroup(logisticBlue2, false).name
      removeStaticObjF(StaticObject.getByName(logisticRed4S))

      activateBlueFrontFlight()
      deactivateRedCenter3Flight()

      center4IsBlue = true
      center4IsRed = false
      trigger.action.outText("蓝方已拥有科尔奇机场！", 30, false)
    elseif center4IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed4S))
      logisticRed4S = mist.respawnGroup(logisticRed4, false).name
      removeStaticObjF(StaticObject.getByName(logisticBlue2S))

      activateRedCenter3Flight()
      deactivateBlueFrontFlight()

      center4IsRed = true
      center4IsBlue = false
      trigger.action.outText("红方已夺取蓝方前线机场-【科尔奇】，同志们，为了胜利和荣耀，向库塔伊西冲锋！", 30, false)

      
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"库塔伊西"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"库塔伊西"})

    if center5IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue1S))
      logisticBlue1S = mist.respawnGroup(logisticBlue1, false).name

      center5IsBlue = true
      center5IsRed = false
      trigger.action.outText("蓝方已开启联合战役！！！", 60, false)
    elseif center5IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue1S))

      deactivateBlueFront3Flight()

      center5IsRed = true
      center5IsBlue = false
      trigger.action.outText("红方获得本次战役胜利，感谢双方所有战斗人员的付出，请联系管理员重新开服", 1000, false)
    end

    local _CC1Blue = StaticObject.getByName(logisticBlue1S)
    if _CC1Blue ~= nil and _CC1Blue:getLife() <= 0 then
      removeStaticObjF(StaticObject.getByName(logisticBlue1S))
      logisticBlue1S = mist.respawnGroup(logisticBlue2, false).name
    end

    local blueVehicles = mist.makeUnitTable({"[blue][vehicle]"})
    local redVehicles = mist.makeUnitTable({"[red][vehicle]"})

    local blueVehicleUnits = mist.getUnitsInZones(blueVehicles, {"古达乌塔"})
    local redVehicleUnits = mist.getUnitsInZones(redVehicles, {"古达乌塔"})

    if center6IsBlue == false and table.getn(blueVehicleUnits) > 0 and table.getn(redVehicleUnits) == 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed1S))

      deactivateRedFront3Flight()

      center6IsBlue = true
      center6IsRed = false
      trigger.action.outText("蓝方获得本次战役胜利，感谢双方所有战斗人员的付出，请联系管理员重新开服", 1000, false)
    elseif center6IsRed == false and table.getn(blueVehicleUnits) == 0 and table.getn(redVehicleUnits) > 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed1S))
      logisticRed1S = mist.respawnGroup(logisticRed1, false).name

      center6IsRed = true
      center6IsBlue = false
      trigger.action.outText("红方已开启联合战役！！！", 60, false)
    end

    local _CC1Red = StaticObject.getByName(logisticRed1S)
    if _CC1Red ~= nil and _CC1Red:getLife() <= 0 then
      removeStaticObjF(StaticObject.getByName(logisticRed1S))
      logisticRed1S = mist.respawnGroup(logisticRed2, false).name
    end
  end

  function respawnAWACSOnlyFlanker()
    local timeGoesAWACSBlue = timer.getTime() - timeStartBlueAWACS
    if timeGoesAWACSBlue > AWACS_TankerRepawnTime then
      blueAWACS = mist.respawnGroup(blueAWACS, true).name
      timeStartBlueAWACS = timer.getTime()
    end

    local timeGoesAWACSRed = timer.getTime() - timeStartRedAWACS
    if timeGoesAWACSRed > AWACS_TankerRepawnTime then
      redAWACS = mist.respawnGroup(redAWACS, true).name
      timeStartRedAWACS = timer.getTime()
    end

    local timeGoesAWACSBlue = timer.getTime() - timeStartBlueAWACS
    if timeGoesAWACSBlue > AWACS_TankerRepawnTime then
      blueAWACS2 = mist.respawnGroup(blueAWACS2, true).name
      timeStartBlueAWACS = timer.getTime()
    end

    local timeGoesAWACSRed = timer.getTime() - timeStartRedAWACS
    if timeGoesAWACSRed > AWACS_TankerRepawnTime then
      redAWACS2 = mist.respawnGroup(redAWACS2, true).name
      timeStartRedAWACS = timer.getTime()
    end

    local AWACSBlueGroup = Group.getByName(blueAWACS, blueAWACS2)
    if AWACSBlueGroup ~= nil then
      local AWACSBlue = AWACSBlueGroup:getUnits()
      if AWACSBlue[1] ~= nil and AWACSBlue[1]:getLife() > 0 and AWACSBlue[1]:getPoint().y < 5000 then
        timer.scheduleFunction(
          function(_args)
            local _unit = Unit.getByName(_args[1])
            if _unit ~= nil then
              _unit:destroy()
              timeStartRedAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
              trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
            end
          end,
          {AWACSBlue[1]:getName()},
          timer.getTime() + 60
        )

      --AWACSBlue[1]:destroy()
      --timeStartBlueAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
      --trigger.action.outText("蓝方预警机出现故障, 将在10分钟后重新上线", 20)
      end
    end

    local AWACSRedGroup = Group.getByName(redAWACS, redAWACS2)
    if AWACSRedGroup ~= nil then
      local AWACSRed = AWACSRedGroup:getUnits()
      if AWACSRed[1] ~= nil and AWACSRed[1]:getLife() > 0 and AWACSRed[1]:getPoint().y < 5000 then
        timer.scheduleFunction(
          function(_args)
            local _unit = Unit.getByName(_args[1])
            if _unit ~= nil then
              _unit:destroy()
              timeStartRedAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
              trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
            end
          end,
          {AWACSRed[1]:getName()},
          timer.getTime() + 60
        )

      --AWACSRed[1]:destroy()
      --timeStartRedAWACS = timer.getTime() - (AWACS_TankerRepawnTime - 600)
      --trigger.action.outText("红方预警机出现故障, 将在10分钟后重新上线", 20)
      end
    end

    --[[if timeStartBlueAWACS
		if not waitingForRedAWACSRespawn then
			local AWACSRed = Group.getByName(redAWACS):getUnits()
			if AWACSRed[1] == nil or AWACSRed[1]:getLife() <= 0 or AWACSRed[1]:getPoint().y < 7000 then
				local fn = function()
					redAWACS = mist.respawnGroup(redAWACS, true).name
					waitingForRedAWACSRespawn = false
				end
				if AWACSRed[1] != nil and AWACSRed[1]:getLife() > 0 then
					--trigger.action.outTextForCoalition(1, "我方预警机将在3分钟后重新上线", 20)
					mist.scheduleFunction(fn, {}, timer.getTime() + 180)
					waitingForRedAWACSRespawn = true
				elseif AWACSRed[1] == nil or (AWACSRed[1] != nil and AWACSRed[1]:getLife() <= 0) then
					trigger.action.outTextForCoalition(1, "我方预警机将在30分钟后重新上线", 20)
					mist.scheduleFunction(fn, {}, timer.getTime() + 1800)
					waitingForRedAWACSRespawn = true
				end

			end
		end]]
    --
  end

  function respawnTankerFlanker()
    local timeGoes, _ = math.fmod((timer.getTime() - timeStartMissionF), AWACS_TankerRepawnTime)
    if timeGoes < 10 then
      if needrespawnTanker == false then
        needrespawnTanker = true

        
        blueAWACS = mist.respawnGroup(blueAWACS, true).name
        blueAWACS2 = mist.respawnGroup(blueAWACS2, true).name
        
        redAWACS = mist.respawnGroup(redAWACS, true).name
        redAWACS2 = mist.respawnGroup(redAWACS2, true).name
        trigger.action.outText("加油机和预警机梯队没油了，后续梯队正在交接！", 10)
      end
    else
      needrespawnTanker = false
    end
  end

  function ifFoundWeaponF(foundItem, val)
    local weapon = foundItem:getTypeName()
    --trigger.action.outText(weapon, 10)
    if weapon == "weapons.missiles.AGM_154" or weapon == "weapons.bombs.GBU_31" or weapon == "CM-802AKG" or weapon == "weapons.missiles.CM-802AKG" or weapon == "weapons.bombs.GBU_31_V_3B" or weapon == "weapons.bombs.GBU_38" or weapon == "weapons.missiles.LD-10" then
      trigger.action.explosion(foundItem:getPoint(), 100)
    --foundItem:destroy()
    end
    return true
  end

  function noWeaponZoneFlanker()
    world.searchObjects(Object.Category.WEAPON, searchVolSBlueF, ifFoundWeaponF)
    world.searchObjects(Object.Category.WEAPON, searchVolSRedF, ifFoundWeaponF)
  end

  function missionScriptsLoopFlanker()
    respawnTankerFlanker()
    respawnAWACSOnlyFlanker()
    noWeaponZoneFlanker()

    mist.scheduleFunction(missionScriptsLoopFlanker, {}, timer.getTime() + 5)
  end

  function delayForLoadingFlanker()
    
    --dofile(lfs.writedir() .. "Scripts/MissionFlanker/Moose.lua")--动态保存
    --dofile(lfs.writedir() .. "Scripts/MissionFlanker/SGS.lua")--动态保存

    mist.scheduleFunction(missionScriptsInitFlanker, {}, timer.getTime() + 1)
    mist.scheduleFunction(missionScriptsLoopFlanker, {}, timer.getTime() + 5)
    --mist.scheduleFunction(missionScheduleScripts5Min, {}, timer.getTime() + 60)
  end

  mist.scheduleFunction(delayForLoadingFlanker, {}, timer.getTime() + 1)
  mist.scheduleFunction(baseCaptureFlanker, {}, timer.getTime() + 1, 5)
end
