AddEXPL = {}
AddEXPL.eventHandler = {}
function AddEXPL.eventHandler:onEvent(_event)
    local status, err = pcall(function()
        if not _event or not _event.id then return end
        if _event.id == world.event.S_EVENT_HIT then
            if _event.target and _event.target:getTypeName() == "CH-47Fbl1" then
                if _event.weapon ~= nil then
                    local weaponDesc = _event.weapon:getDesc()
                    if weaponDesc then
                        env.info("[AddEXPL] Info: 击中CH47的武器是: " .. ctld.formatTable(weaponDesc))
                        local explMass = 100
                        if weaponDesc.warhead and weaponDesc.warhead.explosiveMass then
                            explMass = weaponDesc.warhead.explosiveMass * 10
                        end
                        trigger.action.explosion(_event.target:getPoint(),explMass)
                    else
                        env.info("[AddEXPL] Info: 击中CH47的武器没有WeaponDesc，使用默认当量爆破")
                        trigger.action.explosion(_event.target:getPoint(),100)
                    end
                end
            end
        end
    end)

    if not status then
        env.info("[AddEXPL] Error: "  .. string.format("击中事件处理出错: %s", err))
    end
end
world.addEventHandler(AddEXPL.eventHandler)