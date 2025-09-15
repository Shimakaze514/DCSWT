Weapon = {}
--------------------------------AA---------------------------------
Weapon.AA_newARH = {
  "AIM_120C",
  "SD-10",
  "PL-12",
}
Weapon.AA_newARHPoint = 25

Weapon.AA_oldARH = {
  "AIM_54C_Mk47",
  "AIM_54C_Mk60",
  "AIM_120", --B
  "P_77",
  
  "P_27TE",
  "P_27PE",
}
Weapon.AA_oldARHPoint = 15

Weapon.AA_SARH = {
  "AIM-7P",
  "AIM-7MH",
  "AIM_7", --M
  "AIM-7F",
  "P_27P",
  "P_27T",
  "Matra Super 530D",
}
Weapon.AA_SARHPoint = 10

Weapon.AA_newIR = {
  "AIM_9X",
  "P_73",
}
Weapon.AA_newIRPoint = 10

Weapon.AA_oldIR = {
  "AIM_9", --M
  "AIM-9L",
  "P_60",
  "PL-5EII",

  "OH58D_FIM_92",
  "Mistral"
}
Weapon.AA_oldIRPoint = 5


-----------------------------------AG----------------------------------
Weapon.AG_SmartMissile = {
  "AGM_88",
  "AGM_65D",
  "AGM_65E",
  "AGM_65F",
  "AGM_65G",
  "AGM_65H",
  "AGM_65K",
  "AGM_84D",
  "AGM_84E",
  "AGM_84H",

  "LD-10",
  "C_701IR",
  "C_701T",
  "C_802AK",
  "CM_802AKG",
  
  "AGM_114",
}
Weapon.AG_SmartMissilePoint = 35

Weapon.AG_SmartBomb = {
  "GBU_31",
  "GBU_31_V_2B",
  "GBU_31_V_3B",
  "GBU_31_V_4B",
  "GBU_38",
  "GBU_32_V_2B",
  "GBU_54_V_1B",
  "AGM_154A",
  "AGM_154", --C

  "ADM_141A",

  "GB-6",
  "GB-6-HE",
  "GB-6-SFW",
  "LS_6",
  "LS_6_500",

  "X_29T",
  "X_25MP",
  "Kh25MP_PRGS1VP",  --MPU
  "X_58",
}
Weapon.AG_SmartBombPoint = 20

Weapon.AG_Laser = {
  "GBU_10",
  "GBU_12",
  "GBU_16",
  "GBU_24",
  "X_25ML",
  "X_29L",
  "S_25L",
  
  "AGM_114K",

  "Ataka_9M120",
  "Ataka_9M120F",
  "Ataka_9M220",
}
Weapon.AG_LaserPoint = 15

Weapon.AG_Dumb = {
  "Mk_82",
  "Mk_82Y",
  "MK_82AIR",
  "MK_82SNAKEYE",
  "Mk_83",
  "Mk_84",
  "Mk_84AIR_TP",
  "Mk_84AIR_GP",
  "CBU_99",
  "ROCKEYE",

  "FAB_100",
  "FAB_250",
  "FAB-250-M62",
  "FAB_500",
  "BetAB_500",
  "BetAB_500ShP",
  "RBK_250_275_AO_1SCH",
  "RBK_500AO",
  "RBK_500U",  --255
  "RBK_500U_OAB_2_5RT",  --real U
  
  "C_24",
  "C_25",
  "S-25-O",  --OFM
}
Weapon.AG_DumbPoint = 5

----------------------吊舱-------------------
-- Weapon.ATGPod = {
--   "AN/AAQ-28 LITENING 瞄准吊舱",
--   "ALQ-184 电子对抗吊舱",
--   "ALQ-131 电子对抗吊舱",
--   "MPS-410 电子对抗吊舱",
--   "AN/ALQ-164 电子对抗吊舱",
--   "L-081 Fantasmagoria 电子情报吊舱",
--   "Mercury 微光电视吊舱",
--   "WMD7 吊舱",
--   "数据链指令吊舱",
--   "自保护干扰吊舱",
-- }
-- Weapon.ATGPodPoint = 50

-- ----------------------油箱-------------------------
-- Weapon.mailbox = {
--   "1100升副油箱",
--   "800升副油箱",
--   "800升机翼副油箱",
--   --25t
--   "RPL 522 1300升 副油箱",
--   "RPL 541 2000升 副油箱",
--   "370加仑副油箱",
--   "AERO 1D 300加仑 副油箱",
--   --8B
--   "300加仑副油箱",
--   "330加仑副油箱",
--   --备
--   "FPU-8A 330加仑副油箱",
--   "610加仑副油箱",
--   "FT600 副油箱"
-- }
-- Weapon.mailboxPoint = 15

-- ---------- 在 Weapon 定义之后，建立映射表（只运行一次） ----------
WeaponPriceMap = {}

local function addToMap(list, point, perCount)
    if not list then return end
    perCount = perCount or 1  -- 默认每发计1点
    for _, name in ipairs(list) do
        if name and type(name) == "string" then
            WeaponPriceMap[name] = { point = point, perCount = perCount }
        end
    end
end

addToMap(Weapon.AA_newARH ,   Weapon.AA_newARHPoint)
addToMap(Weapon.AA_oldARH ,   Weapon.AA_oldARHPoint)
addToMap(Weapon.AA_SARH   ,   Weapon.AA_SARHPoint)
addToMap(Weapon.AA_newIR  ,   Weapon.AA_newIRPoint)
addToMap(Weapon.AA_oldIR  ,   Weapon.AA_oldIRPoint)

addToMap(Weapon.AG_SmartMissile ,   Weapon.AG_SmartMissilePoint)
addToMap(Weapon.AG_SmartBomb    ,   Weapon.AG_SmartBombPoint)
addToMap(Weapon.AG_Laser        ,   Weapon.AG_LaserPoint)
addToMap(Weapon.AG_Dumb         ,   Weapon.AG_DumbPoint)

-- addToMap(Weapon.ATGPod  ,   Weapon.ATGPodPoint)
-- addToMap(Weapon.mailbox ,   Weapon.mailboxPoint)

-- 特殊多发挂架
addToMap({"Vikhr_M"}, Weapon.AG_LaserPoint, 8)  -- 最后一个参数是几发算一组
addToMap({"BRM-1_90MM"}, Weapon.AG_LaserPoint, 16)

env.info("武器信息已添加")
