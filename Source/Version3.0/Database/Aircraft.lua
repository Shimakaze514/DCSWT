Aircraft = {}
Aircraft.superiorityFighter = {"F-15C", "J-11A", "Su-33",  "FA-18C_hornet", "JF-17", "F-14B", "F-14A", "F-16C_50","F-15ESE"}
Aircraft.superiorityFighterPoint = 100

Aircraft.lightFighter = {"Su-27", "MiG-29S", "MiG-29G", "MiG-29A", "M-2000C", "AJS37"}
Aircraft.lightFighterPoint = 80

Aircraft.attacker = {"A-10A", "A-10C", "Ka-50", "A-10C_2", "AV-8B", "Su-25", "Su-25T","SA342Mistral"}
Aircraft.attackerPoint = 60

Aircraft.helicopter = {"Mi-8MTV2", "Mi-8MT", "UH-1H", "MosquitoFBMkVI", "TF-51D","AH-64D_BLK_II","SA342M", "SA342L","Mi-24P"}
Aircraft.helicopterPoint = 50

local AircraftPriceMap = {}

local function addAircraftToMap(list, point)
    if not list then return end
    for _, name in ipairs(list) do
        AircraftPriceMap[name] = point
    end
end

-- 初始化
addAircraftToMap(Aircraft.superiorityFighter, Aircraft.superiorityFighterPoint)
addAircraftToMap(Aircraft.lightFighter,       Aircraft.lightFighterPoint)
addAircraftToMap(Aircraft.attacker,           Aircraft.attackerPoint)
addAircraftToMap(Aircraft.helicopter,         Aircraft.helicopterPoint)

env.info("飞机信息已添加")
