dclean = {}

dclean.Version = "20250612"

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
                y = land.getHeight({x = -248577, y = 607722}),
                z = 607722
            },
            radius = 200000}
        }

    world.removeJunk(volS)
    dclean.logInfo('The World Coordinates of volS are: X: ' .. volS.params.point.x .. ' Y: ' .. volS.params.point.y .. ' Z: ' .. volS.params.point.z)
    dclean.logInfo("已清扫垃圾")
    timer.scheduleFunction(dclean.thatsHowTheyClean, nil, timer.getTime() + dclean.RefreshTime)
    trigger.action.outText('已清理战场残骸',10)
end

timer.scheduleFunction(dclean.thatsHowTheyClean, nil, timer.getTime()+180)

net.log("LOAD SUCCESS - SWEEP DEBRIS version "..dclean.Version ..", script by SMKZ")