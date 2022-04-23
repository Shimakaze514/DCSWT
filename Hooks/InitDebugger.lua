--仅在需要测试的时候解除注释
--启用这边的调试器，需要将隔壁的任务文件注释掉
--如果你看不懂，那你动什么动，问紫花去
--[[
  2022/4/24补充
  1.InitDebugger.lua相比InitNPGame.lua只是多了一个调试器
  可以在聊天窗口输入`debug 文件完整路径`来调试
  示例：`debug E:\\test.lua`
  也可以下载https://github.com/zzjtnb/DCS_World_Debugger的代码
  通过网页在线实时调试

  2.通过菜单调试
  首先把Scripts/Debug/Mission/Event.lua第23行路径改成你的文件完整路径
  然后在游戏中按“\”调出菜单选择“F11->其他->加载脚本”

  3.启用这个文件可以把InitNPGame.lua的代码全部注释掉
  Scripts/LoadMissionScript/MissionScripting.lua里面的内容复制到
  Scripts/Debug/LoadMissionScript/MissionScripting.lua里面对应的位置
--


--local status, error =
--pcall(
--        function()
--
--            net.log('[Debugger]开始加载Debugger')
--            dofile(lfs.writedir() .. 'Scripts/Debug/Init.lua')
--
--            dofile(lfs.writedir() .. 'Scripts/ServerData/init.lua')
--            dofile(lfs.writedir() .. 'Scripts/SlotAuth/SlotAuth.lua')
--            dofile(lfs.writedir() .. 'Scripts/Source/Version3.0/Callbacks/Init.lua')
--
--        end
--)
--if (not status) then
--    net.log(string.format('Hooks 加载出错:%s', error))
--else
--    net.log('Hooks 加载完成')
--end
