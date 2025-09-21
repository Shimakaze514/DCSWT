AddEXPL = {}
AddEXPL.eventHandler = {}
function AddEXPL.eventHandler:onEvent(_event)
    local status, err = pcall(function()
        if not _event or not _event.id then return end
        if _event.id == world.event.S_EVENT_HIT then
            if _event.target and _event.target:getTypeName() == "CH-47Fbl1" then
                --env.info("[AddEXPL] Info: 击中CH47的事件触发: "..ctld.p(_event))
                if _event.weapon and type(_event.weapon) == "table" and _event.weapon.isExist and _event.weapon:isExist() then
                    local weaponObj = _event.weapon
                    env.info("[AddEXPL] Info: 成功找到击中CH47的武器")
                    local weaponDesc = weaponObj.getDesc and weaponObj:getDesc()
                    if weaponDesc then
                        env.info("[AddEXPL] Info: 成功获取描述，击中CH47的武器是: " .. ctld.formatTable(weaponDesc))
                        local explMass = 50
                        if weaponDesc.warhead and weaponDesc.warhead.explosiveMass then
                            explMass = weaponDesc.warhead.explosiveMass * 6
                            env.info("[AddEXPL] Info: 使用武器的当量设置爆炸，原武器当量: " .. weaponDesc.warhead.explosiveMass .. "，设置爆炸当量: " .. explMass)
                        else
                        end
                        trigger.action.explosion(_event.target:getPoint(),explMass)
                    else
                        env.info("[AddEXPL] Info: 击中CH47的武器没有WeaponDesc，使用默认当量爆破")
                        trigger.action.explosion(_event.target:getPoint(),50)
                    end
                else
                    env.info("[AddEXPL] Info: 击中CH47的武器没有Weapon对象信息，使用默认当量爆破")
                    trigger.action.explosion(_event.target:getPoint(),50)
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