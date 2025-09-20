AddEXPL = {}
AddEXPL.eventHandler = {}
function AddEXPL.eventHandler:onEvent(_event)
    local status, err = pcall(function()
        if not _event or not _event.id then return end
        if _event.id == world.event.S_EVENT_HIT then
            if _event.target and _event.target:getTypeName() == "CH-47Fbl1" then
                env.info("[AddEXPL] Info: 击中CH47的事件触发")
                if _event.weapon and _event.weapon.getDesc then
                    env.info("[AddEXPL] Info: 成功找到击中CH47的武器")
                    local weaponDesc = _event.weapon:getDesc()
                    if weaponDesc then
                        env.info("[AddEXPL] Info: 成功获取描述，击中CH47的武器是: " .. ctld.formatTable(weaponDesc))
                        local explMass = 100
                        if weaponDesc.warhead and weaponDesc.warhead.explosiveMass then
                            explMass = weaponDesc.warhead.explosiveMass * 12
                            env.info("[AddEXPL] Info: 使用武器的当量设置爆炸，原武器当量: " .. weaponDesc.warhead.explosiveMass .. "，设置爆炸当量: " .. explMass)
                        else
                        end
                        trigger.action.explosion(_event.target:getPoint(),explMass)
                    else
                        env.info("[AddEXPL] Info: 击中CH47的武器没有WeaponDesc，使用默认当量爆破")
                        trigger.action.explosion(_event.target:getPoint(),100)
                    end
                else
                    env.info("[AddEXPL] Info: 击中CH47的武器没有WeaponDesc，使用默认当量爆破")
                    trigger.action.explosion(_event.target:getPoint(),100)
                end
            end
        end
    end)

    if not status then
        env.info("[AddEXPL] Error: "  .. string.format("击中事件处理出错: %s", err))
    end
end
world.addEventHandler(AddEXPL.eventHandler)
net.log("LOAD SUCCESS - AddEXPL, script by SMKZ")