SourceObj = SourceObj or {}

SourceObj.eventAddPoint = function(_event, _point, _ucid, _groupId)
    local sourcePointsTemp = SourceObj.playerSource[_ucid].point
    SourceObj.playerSource[_ucid].point = sourcePointsTemp + _point
    local text = ""
    if _point > 0 then
        text = string.format("%s,奖励:%d点,你的私有资源点剩余:%d点", _event, _point, SourceObj.playerSource[_ucid].point)
    else
        text = string.format("%s,惩罚:%d点,你的私有资源点剩余:%d点", _event, _point, SourceObj.playerSource[_ucid].point)
    end
    trigger.action.outTextForGroup(_groupId, text, 10)
end