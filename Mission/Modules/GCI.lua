DependencyManager = {}
do
    DependencyManager.dependencies = {}

    function DependencyManager.register(name, dependency)
        DependencyManager.dependencies[name] = dependency
        env.info("DependencyManager - "..name.." registered")
    end

    function DependencyManager.get(name)
        return DependencyManager.dependencies[name]
    end
end

Utils = {}
do
	local JSON = (loadfile('Scripts/JSON.lua'))()

	function Utils.getPointOnSurface(point)
		return {x = point.x, y = land.getHeight({x = point.x, y = point.z}), z= point.z}
	end
	
	function Utils.getTableSize(tbl)
		local cnt = 0
		for i,v in pairs(tbl) do cnt=cnt+1 end
		return cnt
	end

	function Utils.isInArray(value, array)
		for _,v in ipairs(array) do
			if value == v then
				return true
			end
		end
	end

	Utils.cache = {}
	Utils.cache.groups = {}
	function Utils.getOriginalGroup(groupName)
		if Utils.cache.groups[groupName] then
			return Utils.cache.groups[groupName]
		end

		for _,coalition in pairs(env.mission.coalition) do
			for _,country in pairs(coalition.country) do
				local tocheck = {}
				table.insert(tocheck, country.plane)
				table.insert(tocheck, country.helicopter)
				table.insert(tocheck, country.ship)
				table.insert(tocheck, country.vehicle)
				table.insert(tocheck, country.static)

				for _, checkGroup in ipairs(tocheck) do
					for _,item in pairs(checkGroup.group) do
						Utils.cache.groups[item.name] = item
						if item.name == groupName then
							return item
						end
					end
				end
			end
		end
	end
	
	function Utils.getBearing(fromvec, tovec)
		local fx = fromvec.x
		local fy = fromvec.z
		
		local tx = tovec.x
		local ty = tovec.z
		
		local brg = math.atan2(ty - fy, tx - fx)
		
		
		if brg < 0 then
			 brg = brg + 2 * math.pi
		end
		
		brg = brg * 180 / math.pi
		

		return brg
	end

	function Utils.getHeadingDiff(heading1, heading2) -- heading1 + result == heading2
		local diff = heading1 - heading2
		local absDiff = math.abs(diff)
		local complementaryAngle = 360 - absDiff
	
		if absDiff <= 180 then 
			return -diff
		elseif heading1 > heading2 then
			return complementaryAngle
		else
			return -complementaryAngle
		end
	end
	
	function Utils.getAGL(object)
		local pt = object:getPoint()
		return pt.y - land.getHeight({ x = pt.x, y = pt.z })
	end

	function Utils.round(number)
		return math.floor(number+0.5)
	end
	
	function Utils.isLanded(unit, ignorespeed)
		--return (Utils.getAGL(unit)<5 and mist.vec.mag(unit:getVelocity())<0.10)
		
		if ignorespeed then
			return not unit:inAir()
		else
			return (not unit:inAir() and mist.vec.mag(unit:getVelocity())<1)
		end
	end

	function Utils.getEnemy(ofside)
		if ofside == 1 then return 2 end
		if ofside == 2 then return 1 end
	end
	
	function Utils.isGroupActive(group)
		if group and group:getSize()>0 and group:getController():hasTask() then 
			return not Utils.allGroupIsLanded(group, true)
		else
			return false
		end
	end
	
	function Utils.isInAir(unit)
		--return Utils.getAGL(unit)>5
		return unit:inAir()
	end
	
	function Utils.isInZone(unit, zonename)
		local zn = CustomZone:getByName(zonename)
		if zn then
			return zn:isInside(unit:getPosition().p)
		end
		
		return false
	end

	function Utils.isInCircle(point, center, radius)
		local dist = mist.utils.get2DDist(point, center)
		return dist<radius
	end
	
	function Utils.isCrateSettledInZone(crate, zonename)
		local zn = CustomZone:getByName(zonename)
		if zn and crate then
			return (zn:isInside(crate:getPosition().p) and Utils.getAGL(crate)<1)
		end
		
		return false
	end
	
	function Utils.someOfGroupInZone(group, zonename)
		for i,v in pairs(group:getUnits()) do
			if Utils.isInZone(v, zonename) then
				return true
			end
		end
		
		return false
	end
	
	function Utils.allGroupIsLanded(group, ignorespeed)
		for i,v in pairs(group:getUnits()) do
			if not Utils.isLanded(v, ignorespeed) then
				return false
			end
		end
		
		return true
	end
	
	function Utils.someOfGroupInAir(group)
		for i,v in pairs(group:getUnits()) do
			if Utils.isInAir(v) then
				return true
			end
		end
		
		return false
	end
	
	Utils.canAccessFS = true
	function Utils.saveTable(filename, data)
		if not Utils.canAccessFS then 
			return
		end
		
		if not io then
			Utils.canAccessFS = false
			trigger.action.outText('Persistance disabled', 30)
			return
		end
	
		local str = JSON:encode(data)
		-- local str = 'return (function() local tbl = {}'
		-- for i,v in pairs(data) do
		-- 	str = str..'\ntbl[\''..i..'\'] = '..Utils.serializeValue(v)
		-- end
		
		-- str = str..'\nreturn tbl end)()'
	
		local File = io.open(filename, "w")
		File:write(str)
		File:close()
	end
	
	function Utils.serializeValue(value)
		local res = ''
		if type(value)=='number' or type(value)=='boolean' then
			res = res..tostring(value)
		elseif type(value)=='string' then
			res = res..'\''..value..'\''
		elseif type(value)=='table' then
			res = res..'{ '
			for i,v in pairs(value) do
				if type(i)=='number' then
					res = res..'['..i..']='..Utils.serializeValue(v)..','
				else
					res = res..'[\''..i..'\']='..Utils.serializeValue(v)..','
				end
			end
			res = res:sub(1,-2)
			res = res..' }'
		end
		return res
	end
	
	function Utils.loadTable(filename)
		if not Utils.canAccessFS then 
			return
		end
		
		if not lfs then
			Utils.canAccessFS = false
			trigger.action.outText('Persistance disabled', 30)
			return
		end
		
		if lfs.attributes(filename) then
			local File = io.open(filename, "r")
			local str = File:read('*all')
			File:close()

			return JSON:decode(str)
		end
	end
	
	function Utils.merge(table1, table2)
		local result = {}
		for i,v in pairs(table1) do
			result[i] = v
		end
		
		for i,v in pairs(table2) do
			result[i] = v
		end
		
		return result
	end

	function Utils.log(func)
		return function(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
			local err, msg = pcall(func,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
			if not err then
				env.info("ERROR - callFunc\n"..msg)
				env.info('Traceback\n'..debug.traceback())
			end
		end
	end

	function Utils.getAmmo(group, type)
		local count = 0
		for _, u in ipairs(group:getUnits()) do
			if u:isExist() then
				local ammo = u:getAmmo()
				for i,v in pairs(ammo) do
					if v.desc.typeName == type then
						count = count + v.count
					end
				end
			end
		end

		return count
	end
end

MenuRegistry = {}
do
    MenuRegistry.listeners = {}
    function MenuRegistry:register(order, registerfunction, context)
        table.insert(MenuRegistry.listeners, {order = order, func = registerfunction, context = context})
        table.sort(MenuRegistry.listeners, function(a,b) return a.order < b.order end)
    end

    local ev = {}
    function ev:onEvent(event)
        if event.id == world.event.S_EVENT_BIRTH and event.initiator and event.initiator.getPlayerName then
            local player = event.initiator:getPlayerName()
            if player then
                env.info('MenuRegistry - creating menus for player: '..player)
                for i,v in ipairs(MenuRegistry.listeners) do
                    local err, msg = pcall(v.func, event, v.context)
                    if not err then
                        env.info("MenuRegistry - ERROR :\n"..msg)
                        env.info('Traceback\n'..debug.traceback())
                    end
                end
            end
        end
    end
    
    world.addEventHandler(ev)

    function MenuRegistry.showTargetZoneMenu(groupid, name, action, targetside, minDistToFront, data, includeCarriers, onlyRevealed)
		local zones = ZoneCommand.getAllZones()

        if targetside and type(targetside) == 'number' then
            targetside = { targetside }
        end

        local zns = {}
        for i,v in pairs(zones) do
            if not targetside or Utils.isInArray(v.side,targetside) then 
                if not minDistToFront or v.distToFront <= minDistToFront then
                    if not onlyRevealed or v.revealTime>0 then
                        table.insert(zns, v)
                    end
                end
            end
        end

        if includeCarriers then
            for i,v in pairs(CarrierCommand.getAllCarriers()) do
                if not targetside or Utils.isInArray(v.side,targetside) then 
                    table.insert(zns, v)
                end
            end
        end

        if #zns == 0 then return false end

        table.sort(zns, function(a,b) return a.name < b.name end)

        local executeAction = function(act, params)
			local err = act(params)
			if not err then
				missionCommands.removeItemForGroup(params.groupid, params.menu)
			end
		end

		local menu = missionCommands.addSubMenuForGroup(groupid, name)
		local sub1 = nil

		local count = 0
		for i,v in ipairs(zns) do
            count = count + 1
            if count<10 then
                missionCommands.addCommandForGroup(groupid, v.name, menu, executeAction, action, {zone = v, menu=menu, groupid=groupid, data=data})
            elseif count==10 then
                sub1 = missionCommands.addSubMenuForGroup(groupid, "More", menu)
                missionCommands.addCommandForGroup(groupid, v.name, sub1, executeAction, action, {zone = v, menu=menu, groupid=groupid, data=data})
            elseif count%9==1 then
                sub1 = missionCommands.addSubMenuForGroup(groupid, "More", sub1)
                missionCommands.addCommandForGroup(groupid, v.name, sub1, executeAction, action, {zone = v, menu=menu, groupid=groupid, data=data})
            else
                missionCommands.addCommandForGroup(groupid, v.name, sub1, executeAction, action, {zone = v, menu=menu, groupid=groupid, data=data})
            end
		end
		
		return menu
    end
end

GCI = {}

do
    function GCI:new(side)
        local o = {}
        o.side = side
        o.tgtSide = 0
        if side == 1 then
            o.tgtSide = 2
        elseif side == 2 then
            o.tgtSide = 1
        end

        o.radars = {}
        o.players = {}
        o.radarTypes = {
            'SAM SR',
            'EWR',
            'AWACS'
        }

        o.groupMenus = {}

        setmetatable(o, self)
		self.__index = self

        o:start()

		DependencyManager.register("GCI", o)
		return o
    end

    function GCI:registerPlayer(name, unit, warningRadius, metric)
        if warningRadius > 0 then
            local msg = "预警半径已设定为 "..warningRadius
            if metric then
                msg=msg.." 公里" 
            else
                msg=msg.." 海里"
            end
            
            local wRadius = 0
            if metric then
                wRadius = warningRadius * 1000
            else
                wRadius = warningRadius * 1852
            end
            
            self.players[name] = {
                unit = unit, 
                warningRadius = wRadius,
                metric = metric
            }
            
            trigger.action.outTextForUnit(unit:getID(), msg, 10)
            DependencyManager.get("PlayerTracker"):setPlayerConfig(name, "gci_warning_radius", warningRadius)
            DependencyManager.get("PlayerTracker"):setPlayerConfig(name, "gci_metric", metric)
        else
            self.players[name] = nil
            trigger.action.outTextForUnit(unit:getID(), "GCI 报告已禁用", 10)
            DependencyManager.get("PlayerTracker"):setPlayerConfig(name, "gci_warning_radius", nil)
            DependencyManager.get("PlayerTracker"):setPlayerConfig(name, "gci_metric", nil)
        end
    end

    function GCI:start()
        MenuRegistry:register(4, function(event, context)
			if event.id == world.event.S_EVENT_BIRTH and event.initiator and event.initiator.getPlayerName then
				local player = event.initiator:getPlayerName()
				if player then
                    if event.initiator:getCoalition() ~= context.side then
                        return
                    end
					local groupid = event.initiator:getGroup():getID()
                    local groupname = event.initiator:getGroup():getName()
                    local unit = event.initiator
                    local unitType = unit:getTypeName()
					
                    if context.groupMenus[groupid] then
                        missionCommands.removeItemForGroup(groupid, context.groupMenus[groupid])
                        context.groupMenus[groupid] = nil
                    end

                    if not context.groupMenus[groupid] then
                        
                        -- Check if unit is a CTLD transport
                        local isTransport = false
                        if ctld then
                            if ctld.availableUnitTypes then
                                for _, typename in ipairs(ctld.availableUnitTypes) do
                                    if unitType == typename then
                                            isTransport = true
                                        break
                                    end
                                end
                            end
                        end

                        if isTransport then
                            local menu = missionCommands.addSubMenuForGroup(groupid, 'GCI 预警')
                            local setWR = missionCommands.addSubMenuForGroup(groupid, '设置预警半径', menu)
                            local kmMenu = missionCommands.addSubMenuForGroup(groupid, '公制 (KM)', setWR)
                            local nmMenu = missionCommands.addSubMenuForGroup(groupid, '英制 (NM)', setWR)

                            missionCommands.addCommandForGroup(groupid, '10 公里',  kmMenu, Utils.log(context.registerPlayer), context, player, unit, 10, true)
                            missionCommands.addCommandForGroup(groupid, '25 公里',  kmMenu, Utils.log(context.registerPlayer), context, player, unit, 25, true)
                            missionCommands.addCommandForGroup(groupid, '50 公里',  kmMenu, Utils.log(context.registerPlayer), context, player, unit, 50, true)
                            missionCommands.addCommandForGroup(groupid, '100 公里', kmMenu, Utils.log(context.registerPlayer), context, player, unit, 100, true)
                            missionCommands.addCommandForGroup(groupid, '150 公里', kmMenu, Utils.log(context.registerPlayer), context, player, unit, 150, true)

                            missionCommands.addCommandForGroup(groupid, '5 海里',  nmMenu, Utils.log(context.registerPlayer), context, player, unit, 5, false)
                            missionCommands.addCommandForGroup(groupid, '10 海里', nmMenu, Utils.log(context.registerPlayer), context, player, unit, 10, false)
                            missionCommands.addCommandForGroup(groupid, '25 海里', nmMenu, Utils.log(context.registerPlayer), context, player, unit, 25, false)
                            missionCommands.addCommandForGroup(groupid, '50 海里', nmMenu, Utils.log(context.registerPlayer), context, player, unit, 50, false)
                            missionCommands.addCommandForGroup(groupid, '80 海里', nmMenu, Utils.log(context.registerPlayer), context, player, unit, 80, false)
                            missionCommands.addCommandForGroup(groupid, '禁用预警', menu, Utils.log(context.registerPlayer), context, player, unit, 0, false)

                            context.groupMenus[groupid] = menu
                            context:registerPlayer(player, unit, 20, false)
                        end
                    end
				end
            elseif (event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT or event.id == world.event.S_EVENT_DEAD) and event.initiator and event.initiator.getPlayerName then
                local player = event.initiator:getPlayerName()
				if player then
					local groupid = event.initiator:getGroup():getID()
					
                    if context.groupMenus[groupid] then
                        missionCommands.removeItemForGroup(groupid, context.groupMenus[groupid])
                        context.groupMenus[groupid] = nil
                    end
				end
            end
		end, self)

        timer.scheduleFunction(function(param, time)
            local self = param.context
            local allunits = coalition.getGroups(self.side)
  
            local radars = {}
            
            --env.info("GCI - EWR units are "..ctld.formatTable(ctld.EWRunits,4))
            for _,g in ipairs(ctld.EWRunits) do
                if g:isExist() and g:getCoalition() == self.side then
                    for _,u in ipairs(g:getUnits()) do
                        for _,a in ipairs(self.radarTypes) do
                            if u:hasAttribute(a) and u:isExist() then
                                table.insert(radars, u)
                                break
                            end
                        end
                    end
                end
            end

            self.radars = radars
            env.info("GCI - tracking "..#radars.." radar enabled units")

            return time+10
        end, {context = self}, timer.getTime()+1)

        timer.scheduleFunction(function(param, time)
            local self = param.context

            local plyCount = 0
            for i,v in pairs(self.players) do
                if not v.unit or not v.unit:isExist() then
                    self.players[i] = nil
                else
                    plyCount = plyCount + 1
                end
            end

            env.info("GCI - reporting to "..plyCount.." players")
            if plyCount >0 then
                local dect = {}
                local dcount = 0
                for _,u in ipairs(self.radars) do
                    if u:isExist() then
                        local detected = u:getController():getDetectedTargets(Controller.Detection.RADAR)
                        for _,d in ipairs(detected) do
                            if d and d.object and d.object.isExist and d.object:isExist() and 
                                Object.getCategory(d.object) == Object.Category.UNIT and
                                d.object.getCoalition and
                                d.object:getCoalition() == self.tgtSide and
                                d.object:inAir() then
                                
                                local velocityVec3 = d.object:getVelocity()
                                local velocity = ( velocityVec3.x ^ 2 + velocityVec3.y ^ 2 + velocityVec3.z ^ 2 ) ^ 0.5
                                local knots = velocity * 1.943844
                                --env.info("GCI - velocity is "..knots.." knots")
                                if knots >= 40 then
                                    if not dect[d.object:getName()] then
                                        dect[d.object:getName()] = d.object
                                        dcount = dcount + 1
                                    end
                                end
                                
                            end
                        end
                    end
                end
                
                env.info("GCI - aware of "..dcount.." enemy units")

                for name, data in pairs(self.players) do
                    if data.unit and data.unit:isExist() then
                        local closeUnits = {}

                        local wr = data.warningRadius
                        if wr > 0 then
                            for _,dt in pairs(dect) do
                                if dt:isExist() then
                                    local tgtPnt = dt:getPoint()
                                    local dist = mist.utils.get2DDist(data.unit:getPoint(), tgtPnt)
                                    if dist <= wr then
                                        local brg = math.floor(Utils.getBearing(data.unit:getPoint(), tgtPnt))

                                        local myPos = data.unit:getPosition()
                                        local tgtPos = dt:getPosition()
                                        local tgtHeading = math.deg(math.atan2(tgtPos.x.z, tgtPos.x.x))
                                        local tgtBearing = Utils.getBearing(tgtPos.p, myPos.p)
            
                                        local diff = math.abs(Utils.getHeadingDiff(tgtBearing, tgtHeading))
                                        local aspect = ''
                                        local priority = 1
                                        if diff <= 30 then
                                            aspect = "迎头" -- Hot
                                            priority = 1
                                        elseif diff <= 60 then
                                            aspect = "侧对" -- Flanking
                                            priority = 1
                                        elseif diff <= 120 then
                                            aspect = "横飞" -- Beaming
                                            priority = 2
                                        else
                                            aspect = "尾追" -- Cold
                                            priority = 3
                                        end

                                        table.insert(closeUnits, {
                                            type = dt:getDesc().typeName,
                                            bearing = brg,
                                            range = dist,
                                            altitude = tgtPnt.y,
                                            score = dist*priority,
                                            aspect = aspect
                                        })
                                    end
                                end
                            end
                        end

                        env.info("GCI - "..#closeUnits.." enemy units within "..wr.."m of "..name)
                        if #closeUnits > 0 then
                            table.sort(closeUnits, function(a, b) return a.range < b.range end)

                            local msg = "\n【GCI 战场信息报告】\n"
                            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                            msg = msg .. string.format("%-12s %-5s %-8s %-9s %s\n", "机型", "方位", "距离", "高度", "态势")
                            msg = msg .. "────────────────────────────────────\n"
                            
                            local count = 0
                            for _,tgt in ipairs(closeUnits) do
                                local typeStr = tgt.type
                                if #typeStr > 12 then typeStr = string.sub(typeStr, 1, 12) end -- 截断过长的机型名称
                                
                                local brgStr = string.format("%03d", tgt.bearing)
                                local rngStr = ""
                                local altStr = ""
                                
                                if data.metric then
                                    local km = tgt.range/1000
                                    if km < 1 then
                                        rngStr = "交汇" -- 中文：交汇 (MERGED)
                                        altStr = "----"
                                    else
                                        rngStr = string.format("%dkm", Utils.round(km))
                                        altStr = string.format("%dm", Utils.round(tgt.altitude/100)*100) -- 四舍五入到最近的100米
                                    end
                                else -- 英制
                                    local nm = tgt.range/1852
                                    if nm < 1 then
                                        rngStr = "交汇" -- 中文：交汇 (MERGED)
                                        altStr = "----"
                                    else
                                        rngStr = string.format("%dnm", Utils.round(nm))
                                        altStr = string.format("%dft", Utils.round((tgt.altitude/0.3048)/1000)*1000) -- 四舍五入到最近的1000英尺
                                    end
                                end
                                
                                -- 格式化行，aspect列为变长，放在最后
                                msg = msg .. string.format("%-12s %-5s %-8s %-9s %s\n", typeStr, brgStr, rngStr, altStr, tgt.aspect)
                                
                                count = count + 1
                                if count >= 10 then break end
                            end
                            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                            trigger.action.outTextForUnit(data.unit:getID(), msg, 19)
                        end
                    else
                        self.players[name] = nil
                    end
                end
            end

            return time+20
        end, {context = self}, timer.getTime()+6)
    end
    GCI:new(2)
    GCI:new(1)
end