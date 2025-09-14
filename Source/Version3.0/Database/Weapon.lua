Weapon = {}
--------------------------------AA---------------------------------
Weapon.AA_newARH = {
  "AIM_120C",
}
Weapon.AA_newARHPoint = 25

Weapon.AA_oldARH = {
  "AIM_54C_Mk47",
  "AIM_54C_Mk60",
  "AIM_120", --B
}
Weapon.AA_oldARHPoint = 15

Weapon.AA_SARH = {
}
Weapon.AA_SARHPoint = 10

Weapon.AA_newIR = {
  "AIM_9X",
}
Weapon.AA_newIRPoint = 10

Weapon.AA_oldIR = {
  "AIM_9",
}
Weapon.AA_oldIRPoint = 5


-----------------------------------AG----------------------------------
Weapon.AG_SmartMissile = {
  "AGM_88",
  "AGM_65D",
}
Weapon.AG_SmartMissilePoint = 35

Weapon.AG_SmartBomb = {
  "GBU_31",
  "GBU_38",
}
Weapon.AG_SmartBombPoint = 20

Weapon.AG_Laser = {
  "GBU_12",
  "GBU_10",
  "S_25L",
  "Vikhr_M",
}
Weapon.AG_LaserPoint = 15

Weapon.AG_Dumb = {
}
Weapon.AG_DumbPoint = 5

----------------------吊舱-------------------
Weapon.ATGPod = {
  "AN/AAQ-28 LITENING 瞄准吊舱",
  "ALQ-184 电子对抗吊舱",
  "ALQ-131 电子对抗吊舱",
  "MPS-410 电子对抗吊舱",
  "AN/ALQ-164 电子对抗吊舱",
  "L-081 Fantasmagoria 电子情报吊舱",
  "Mercury 微光电视吊舱",
  "WMD7 吊舱",
  "数据链指令吊舱",
  "自保护干扰吊舱",
}
Weapon.ATGPodPoint = 50

-- ----------------------油箱-------------------------
Weapon.mailbox = {
  "1100升副油箱",
  "800升副油箱",
  "800升机翼副油箱",
  --25t
  "RPL 522 1300升 副油箱",
  "RPL 541 2000升 副油箱",
  "370加仑副油箱",
  "AERO 1D 300加仑 副油箱",
  --8B
  "300加仑副油箱",
  "330加仑副油箱",
  --备
  "FPU-8A 330加仑副油箱",
  "610加仑副油箱",
  "FT600 副油箱"
}
Weapon.mailboxPoint = 15

-- ---------- 在 Weapon 定义之后，建立映射表（只运行一次） ----------
WeaponPriceMap = {}

local function addToMap(list, point)
    if not list then return end
    for _, name in ipairs(list) do
        if name and type(name) == "string" then
            WeaponPriceMap[name] = point
        end
    end
end

-- 把各个分类加入映射
addToMap(Weapon.AA_newARH ,   Weapon.AA_newARHPoint)
addToMap(Weapon.AA_oldARH ,   Weapon.AA_oldARHPoint)
addToMap(Weapon.AA_SARH   ,   Weapon.AA_SARHPoint)
addToMap(Weapon.AA_newIR  ,   Weapon.AA_newIRPoint)
addToMap(Weapon.AA_oldIR  ,   Weapon.AA_oldIRPoint)

addToMap(Weapon.AG_SmartMissile ,   Weapon.AG_SmartMissilePoint)
addToMap(Weapon.AG_SmartBomb    ,   Weapon.AG_SmartBombPoint)
addToMap(Weapon.AG_Laser        ,   Weapon.AG_LaserPoint)
addToMap(Weapon.AG_Dumb         ,   Weapon.AG_DumbPoint)

addToMap(Weapon.ATGPod  ,   Weapon.ATGPodPoint)
addToMap(Weapon.mailbox ,   Weapon.mailboxPoint)

env.info("武器信息已添加")
