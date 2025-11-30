AddEXPL = {}
AddEXPL.eventHandler = {}
function AddEXPL.eventHandler:onEvent(_event)
	local status, err =
		pcall(
		function()
			if not _event or not _event.id then
				return
			end
			if _event.id == world.event.S_EVENT_HIT and _event.target and _event.target.getDesc then
				if
					_event.target:getDesc().category == Unit.Category.AIRPLANE or
						_event.target:getDesc().category == Unit.Category.HELICOPTER
				 then
                    local life = _event.target:getLife() / _event.target:getDesc().life
                    env.info('[AddEXPL] Info: 当前血量'.._event.target:getLife().."，最大血量".._event.target:getDesc().life.."，血量分数"..life)
                    if _event.weapon and type(_event.weapon) == 'table' and _event.weapon.isExist and _event.weapon:isExist() then
                        local weaponObj = _event.weapon
                        env.info('[AddEXPL] Info: 成功找到击毁目标的武器')
                        local weaponDesc = weaponObj.getDesc and weaponObj:getDesc()
                        if weaponDesc then
                            env.info('[AddEXPL] Info: 成功获取描述，击毁目标的武器是: ' .. ctld.formatTable(weaponDesc))
                            if weaponDesc.warhead then
                                if life <= 0.5 then
                                    env.info('[AddEXPL] Info: 单位血量小于爆炸临界，血量分数(0,1)为' .. life)
                                    trigger.action.explosion(_event.target:getPoint(), 50)
                                end
                                if _event.target:getTypeName() == "CH-47Fbl1" then
                                    env.info('[AddEXPL] Info: CH-47Fbl1被击中')
                                    trigger.action.explosion(_event.target:getPoint(), weaponDesc.warhead.mass * 8)
                                    return
                                end
                            end
                        else
                            env.info('[AddEXPL] Info: 击毁目标的武器没有WeaponDesc')
                        end
                    else
                        env.info('[AddEXPL] Info: 击毁目标的武没有Weapon对象信息')
                    end
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
