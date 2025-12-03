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
                local life = _event.target:getLife() / _event.target:getDesc().life
                env.info('[AddEXPL] Info: 当前血量'.._event.target:getLife().."，最大血量".._event.target:getDesc().life.."，血量分数"..life)
                if _event.target:getLife() <= 1 then
                    trigger.action.explosion(_event.target:getPoint(), 50)
                elseif _event.weapon_name and _event.weapon_name ~= "" then
                    local weaponTypeName = _event.weapon_name
                    if weaponTypeName then
                        env.info('[AddEXPL] Info: 击中目标的武器是: ' .. weaponTypeName)
                        local warheadMass = AddEXPL.warheadMass[weaponTypeName]
                        if warheadMass then
                            if _event.target:getDesc().category == Unit.Category.AIRPLANE or
                                _event.target:getDesc().category == Unit.Category.HELICOPTER
                            then
                                if life <= 0.5 then
                                    env.info('[AddEXPL] Info: 单位血量小于爆炸临界0.5，血量分数(0,1)为' .. life)
                                    trigger.action.explosion(_event.target:getPoint(), 50)
                                end
                                if _event.target:getTypeName() == "CH-47Fbl1" then
                                    env.info('[AddEXPL] Info: CH-47Fbl1被击中')
                                    trigger.action.explosion(_event.target:getPoint(), warheadMass * 10)
                                    return
                                end
                            elseif life <= 0.1 then
                                env.info('[AddEXPL] Info: 单位是地面或海面目标，单位血量小于爆炸临界0.1，血量分数(0,1)为' .. life)
                                trigger.action.explosion(_event.target:getPoint(), 100)
                            end
                        else
                            env.info('[AddEXPL] Info: AddEXPL.warheadMass中没有对应的weaponTypeName')
                        end
                    else
                        env.info('[AddEXPL] Info: 击中目标的武器没有WeaponDesc')
                    end
                else
                    env.info('[AddEXPL] Info: 击中目标的武器没有Weapon对象信息')
                end
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
