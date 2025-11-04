SourceObj = SourceObj or {}

SourceObj.countdownMessage = function(args)
    local ucid, groupId = args[1], args[2]
    local ps = SourceObj.playerSource[ucid]
    if not ps or not ps.birthTime then
        return nil
    end

    local remaining = 120 - (timer.getTime() - ps.birthTime)
    if remaining > 0 then
        local mergedMsg = table.concat({
            "本服需要团队配合以获得最佳体验，请您保持SRS或TS在线，以便队友联系！",
            "频道列表：ATC(起降协调): 261 | GCI(战斗通讯): 124.8 | 公共频道:251",
            '若忘记频率，聊天框内输入 "-freq" 即可重新收到提示。',
            '您也可以下载TeamSpeak软件并加入101.37.13.29(同本服IP)',
            '欢迎来TS服务器挂机/聊天/等人/玩别的游戏~',
            "",
            "*服务器已启用资源系统，请阅系统介绍：",
            "[1] 服务器永久保存您的资源点，可通过 通讯菜单(\"->F10->私有资源点 查询;",
            "[2] 飞机和弹药都消耗资源点，起飞后扣除；返场降落将根据余量返还点数;",
            "[3] 击杀敌方单位，吊运，救援，值班GCI、ATC、OP都可获取点数;",
            '[4] 起飞前请点击 通讯菜单->F10->查询挂载信息 确认点数消耗，合理分配挂载;',
            '[5] 若资源点不足以支付消耗，请更换更便宜的挂载，强行起飞将会自爆;',
            "[6] 若点数耗尽，每隔一段时间会发放低保点数;",
            "[7] 若在任务中阵亡，该架次获取的点数将减半。",
            "",
            "你当前私有点数: " .. tostring(ps.point),
            "--------------------------------",
            "*服务器已启用出击冷却功能，在倒计时结束之前起飞将会自爆",
            string.format("倒计时剩余 %d 秒，请在结束之后再起飞", math.ceil(remaining))
        }, "\n")

        trigger.action.outTextForGroup(groupId, mergedMsg, 14, true)

        return timer.getTime() + 15
    else
        trigger.action.outTextForGroup(groupId, "倒计时结束，您现在可以安全起飞。", 30, true)

        return nil
    end
end
