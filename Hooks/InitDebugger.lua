--仅在需要测试的时候解除注释
--启用这边的调试器，需要将隔壁的任务文件注释掉
--如果你看不懂，那你动什么动，问紫花去


local status, error =
pcall(
        function()

            net.log('[Debugger]开始加载Debugger')
            dofile(lfs.writedir() .. 'Scripts/Debug/Hooks/Main.lua')
            --dofile(lfs.writedir() .. 'Scripts/ServerData/init.lua')
            dofile(lfs.writedir() .. 'Scripts/Debug/LoadMissionScript/Main.lua')

        end
)
if (not status) then
    net.log(string.format('Hooks 加载出错:%s', error))
else
    net.log('Hooks 加载完成')
end
