AddEXPL = {}
AddEXPL.eventHandler = {}
function AddEXPL.eventHandler:onEvent(_event)
    local status, err = pcall(function()
        if not _event or not _event.id then return end
        if _event.id == world.event.S_EVENT_HIT and _event.target then
            if not _event.target:getDesc().category == Unit.Category.AIRPLANE or _event.target:getDesc().category == Unit.Category.HELICOPTER then return end
            local life = _event.target:getLife()/_event.target:getLife0()
            if life <= 0.5 then
                env.info("[AddEXPL] Info: 单位血量小于爆炸临界，血量分数(0,1)为"..life)
                if _event.weapon and type(_event.weapon) == "table" and _event.weapon.isExist and _event.weapon:isExist() then
                    local weaponObj = _event.weapon
                    env.info("[AddEXPL] Info: 成功找到击毁目标的武器")
                    local weaponDesc = weaponObj.getDesc and weaponObj:getDesc()
                    if weaponDesc then
                        env.info("[AddEXPL] Info: 成功获取描述，击毁目标的武器是: " .. ctld.formatTable(weaponDesc))
                    else
                        env.info("[AddEXPL] Info: 击毁目标的武器没有WeaponDesc")
                    end
                    trigger.action.explosion(_event.target:getPoint(),50)
                else
                    env.info("[AddEXPL] Info: 击毁目标的武没有Weapon对象信息")
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