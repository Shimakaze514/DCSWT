AddEXPL = {}
AddEXPL.eventHandler = {}
function AddEXPL.eventHandler:onEvent(_event)
    local status, err = pcall(function(_event)
        if not _event or not _event.id then return end
        if _event.id == world.event.S_EVENT_HIT then
            if _event.target and _event.target:getTypeName() == "CH-47Fbl1" then
                trigger.action.explosion(_event.target:getPoint(),250)
            end
        end
    end, _event)

    if not status then
        env.info("[AddEXPL] Error: "  .. string.format("击中事件处理出错: %s", err))
    end
end
world.addEventHandler(AddEXPL.eventHandler)