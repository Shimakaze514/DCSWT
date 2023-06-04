dclean = {}

dclean.Version = "20230526"

dclean.RefreshTime = 1200

net.log("LOAD - SWEEP DEBRIS version "..dclean.Version ..", script by SMKZ")

function dclean.logInfo(message)
    env.info("[SWEEP] Info: "  .. message)
end

function dclean.thatsHowTheyClean()
    local volS = {
        id = world.VolumeType.SPHERE,
        params = {
            point = {
                x = -248577,
                y = 8,
                z = 607722
            },
            radius = 300000}
        }

    world.removeJunk(volS)
    dclean.logInfo("已清扫垃圾")
    timer.scheduleFunction(dclean.thatsHowTheyClean, nil, timer.getTime() + dclean.RefreshTime)
    trigger.action.outText('已清理战场残骸',10)
end

timer.scheduleFunction(dclean.thatsHowTheyClean, nil, timer.getTime()+180)

net.log("LOAD SUCCESS - SWEEP DEBRIS version "..dclean.Version ..", script by SMKZ")