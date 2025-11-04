local function handle(args, playerID, ucid)
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
end

return {
  aliases = {"help"},
  handle = handle
}