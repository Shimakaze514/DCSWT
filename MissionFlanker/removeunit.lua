local removeshipEvent = {}
removeshipEvent.eventHandler = {}
function removeshipEvent.eventHandler:onEvent(event)
    local status, error =
    pcall(
    function(event)
        if event.id == world.event.S_EVENT_KILL or event.id == 29 then
            local targetship = event.target:getGroup()
            Group.destroy(targetship)
            end
        end
    end,
    event
  )
  if (not status) then
    env.error(string.format("移除残骸系统任务事件处理时出错:%s", error), false)
  end
end
    
    
    
world.addEventHandler(removeshipEvent.eventHandler)