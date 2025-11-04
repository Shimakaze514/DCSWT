local function handle(args, playerID, ucid)
    if playerID == 1 or SourceCall.Admins[ucid] then
      local text =
        string.format(
        "管理员命令\n                               1.增加管理员\n  -admin addAdmin name\n                    2.删除管理员\n  -admin removeAdmin name\n              3.给玩家增加资源点\n  -admin addPoint name point\n   4.给玩家减少资源点\n  -admin lessPoint name point\n  5.封禁玩家\n   -admin ban name 备注(可不填)\n            6.解封玩家\n   -admin unban name\n                            7.暂停游戏\n   -admin pause\n                                     8.解除暂停\n   -admin unpause\n                                9. 启用空服务器自动暂停\n    -admin emptyPause\n        10.禁用空服务器自动暂停\n   -admin unEmptyPause\n   11.移动玩家到观众席   -admin forcePlayerSlot name"
      )
      net.send_chat_to(text, playerID)
    else
      Utils.admin_caveat(ucid, 100, playerID)
    end
end

return {
  aliases = {"help"},
  handle = handle
}