PlayerCmd = function(REXtext, playerID, ucid)
  local cmd = REXtext[1]

  -- 获取玩家名字的辅助函数
  local function getPlayerName(id)
      return net.get_player_info(id, "name") or "未知玩家"
  end

  -- 发送帮助信息
  if cmd == "help" or cmd == "h" then
    local helpLines = {
      "玩家命令",
      "1. 转增资源点",
      "   -donatePoint name pointNum",
      "      示例: -donatePoint Admin 100",
      "2. 跳边（只能跳一次！）",
      "   -tb"
  }
  
  -- 拼接成字符串发送
  local helpText = table.concat(helpLines, "\n")
  net.send_chat_to(helpText, playerID)

  -- 转增资源点命令
  elseif cmd == "-donatePoint" then
      local targetName = REXtext[2]
      local pointNum = tonumber(REXtext[3])

      if not targetName or not pointNum then
          net.send_chat_to("命令格式错误！示例: -donatePoint Admin 100", playerID)
          return
      end

      local targetUCID = SourceCall.PlayerName[targetName]
      if not targetUCID then
          net.send_chat_to("玩家不存在: " .. targetName, playerID)
          return
      end

      local senderName = getPlayerName(playerID)
      if ucid == targetUCID then
          -- 扣自己资源点
          net.dostring_in("mission", string.format(
              "a_do_script('SourceObj.lessSourcePoint(\"%s\", %d)')", ucid, pointNum))
          net.send_chat_to(senderName .. " 乱玩指令扣" .. pointNum .. "资源点", playerID)
      else
          -- 转增给其他玩家
          net.dostring_in("mission", string.format(
              "a_do_script('SourceObj.donatePoint(\"%s\",\"%s\", %d)')",
              ucid, targetUCID, pointNum))
          net.send_chat_to(string.format("已将 %d 资源点转给 %s", pointNum, targetName), playerID)
      end

  -- 占位的 -tb 功能
--   elseif cmd == "-tb" then
--      SLOT.resetSideSwitch(playerID, ucid)
  end
end
