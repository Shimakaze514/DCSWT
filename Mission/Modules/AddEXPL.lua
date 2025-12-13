AddEXPL = {}
AddEXPL.eventHandler = {}
AddEXPL.warheadMass = AddEXPL.warheadMass or {}
function AddEXPL.eventHandler:onEvent(_event)
	local status, err =
		pcall(
		function()
			if not _event or not _event.id then
				return
			end
			if _event.id == world.event.S_EVENT_HIT and _event.target and _event.target.getDesc then
                timer.scheduleFunction(
                function(_args)
                    local target, weapon = _args[1], _args[2]
                    if not target then
                        env.info('[AddEXPL] Warning: 单位在定时器执行前已不可用。')
                        return
                    elseif not target:isExist() then
                        env.info('[AddEXPL] Warning: 单位在定时器执行前已被摧毁？')
                        return
                    end
                    local currentHP = target:getLife()
                    local maxLife = target:getDesc().life
                    local lifeRatio = currentHP / maxLife
                    if currentHP <= 1 then
                        trigger.action.explosion(target:getPoint(), 80)
                        env.info('[AddEXPL] Info:单位血量小于等于1，执行爆破')
                    elseif weapon and weapon ~= "" then
                        local weaponTypeName = weapon
                        env.info('[AddEXPL] Info: 击中目标的武器是: ' .. weaponTypeName)
                        local warheadMass = AddEXPL.warheadMass[weaponTypeName]
                        
                        if warheadMass then
                            local unitCategory = target:getDesc().category
                            
                            if unitCategory == Unit.Category.AIRPLANE or
                            unitCategory == Unit.Category.HELICOPTER
                            then
                                if lifeRatio <= 0.9 then
                                    env.info('[AddEXPL] Info: 单位血量小于爆炸临界0.9，血量分数(0,1)为' .. lifeRatio)
                                    trigger.action.explosion(target:getPoint(), math.min(warheadMass * 10,80))
                                end
                                if target:getTypeName() == "CH-47Fbl1" then
                                    env.info('[AddEXPL] Info: CH-47Fbl1被击中')
                                    trigger.action.explosion(target:getPoint(), warheadMass * 10)
                                    return
                                end
                            -- elseif lifeRatio <= 0.1 then
                            --     env.info('[AddEXPL] Info: 单位是地面或海面目标，单位血量小于爆炸临界0.1，血量分数(0,1)为' .. lifeRatio)
                            --     trigger.action.explosion(target:getPoint(), 100)
                            end
                        else
                            env.info('[AddEXPL] Info: AddEXPL.warheadMass中没有对应的weaponTypeName')
                        end
                    else
                        env.info('[AddEXPL] Info: 击中目标的武器没有Weapon对象信息')
                    end
                end,
                {_event.target,_event.weapon_name},
                timer.getTime() + 0.06
                )
			elseif _event.id == world.event.S_EVENT_SHOT and _event.weapon and _event.weapon.isExist and _event.weapon:isExist() and Object.getCategory(_event.weapon) == Object.Category.WEAPON then 
                local weaponObj = _event.weapon
                local weaponTypeName = weaponObj:getTypeName()
                local weaponDesc = weaponObj.getDesc and weaponObj:getDesc()
                if weaponDesc and weaponTypeName and weaponDesc.warhead then
                    AddEXPL.warheadMass[weaponTypeName] = weaponDesc.warhead.mass
                    env.info('[AddEXPL] Info: 记录发射事件，weaponTypeName是'..weaponTypeName.."，弹头质量是"..weaponDesc.warhead.mass)
                else
                    env.info('[AddEXPL] Info: 击中目标的武器没有weaponTypeName或weaponDesc.warhead')
                end
            end          
		end
	)

	if not status then
		env.info('[AddEXPL] Error: ' .. string.format('击中事件处理出错: %s', err))
	end
end
world.addEventHandler(AddEXPL.eventHandler)
net.log('LOAD SUCCESS - AddEXPL, script by SMKZ')
