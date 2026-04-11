
WeaponPriceMap = {}
NPWeaponList = {}
--------------------------------AA---------------------------------
NPWeaponList.AA_newARH = {
  "AIM_120C",
  "SD-10",
  "PL-12",
}
NPWeaponList.AA_newARHPoint = SourceConfig.WeaponPrice.AA_newARH

NPWeaponList.AA_oldARH = {
  "AIM_54C_Mk47",
  "AIM_54C_Mk60",
  "AIM_120", --B
  "P_77",
  
  "P_27TE",
  "P_27PE",
}
NPWeaponList.AA_oldARHPoint = SourceConfig.WeaponPrice.AA_oldARH

NPWeaponList.AA_SARH = {
  "AIM-7P",
  "AIM-7MH",
  "AIM_7", --M
  "AIM-7F",
  "P_27P",
  "P_27T",
  "Matra Super 530D",
}
NPWeaponList.AA_SARHPoint = SourceConfig.WeaponPrice.AA_SARH

NPWeaponList.AA_newIR = {
  "AIM_9X",
  "P_73",
}
NPWeaponList.AA_newIRPoint = SourceConfig.WeaponPrice.AA_newIR

NPWeaponList.AA_oldIR = {
  "AIM_9", --M
  "AIM-9L",
  "P_60",
  "PL-5EII",

  "OH58D_FIM_92",
  "Mistral"
}
NPWeaponList.AA_oldIRPoint = SourceConfig.WeaponPrice.AA_oldIR


-----------------------------------AG----------------------------------
NPWeaponList.AG_NLOS = {
  "AGM_84E",
  "AGM_84H",
  "CM_802AKG",
}
NPWeaponList.AG_NLOSPoint = SourceConfig.WeaponPrice.AG_NLOS

NPWeaponList.AG_SmartMissile = {
  "AGM_88",
  "AGM_65D",
  "AGM_65E",
  "AGM_65F",
  "AGM_65G",
  "AGM_65H",
  "AGM_65K",
  "AGM_84D",

  "LD-10",
  "C_701IR",
  "C_701T",
  "C_802AK",
  
  "AGM_114",
}
NPWeaponList.AG_SmartMissilePoint = SourceConfig.WeaponPrice.AG_SmartMissile

NPWeaponList.AG_SmartBomb = {
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
NPWeaponList.AG_SmartBombPoint = SourceConfig.WeaponPrice.AG_SmartBomb

NPWeaponList.AG_Laser = {
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
NPWeaponList.AG_LaserPoint = SourceConfig.WeaponPrice.AG_Laser

NPWeaponList.AG_Dumb = {
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
NPWeaponList.AG_DumbPoint = SourceConfig.WeaponPrice.AG_Dumb

----------------------吊舱-------------------
-- NPWeaponList.ATGPod = {
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
-- NPWeaponList.ATGPodPoint = 50

-- ----------------------油箱-------------------------
-- NPWeaponList.mailbox = {
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
-- NPWeaponList.mailboxPoint = 15

-- ---------- 在 Weapon 定义之后，建立映射表（只运行一次） ----------

local function addToMap(list, point, perCount)
    if not list then return end
    perCount = perCount or 1  -- 默认每发计1点
    for _, name in ipairs(list) do
        if name and type(name) == "string" then
            WeaponPriceMap[name] = { point = point, perCount = perCount }
        end
    end
end

addToMap(NPWeaponList.AA_newARH ,   NPWeaponList.AA_newARHPoint)
addToMap(NPWeaponList.AA_oldARH ,   NPWeaponList.AA_oldARHPoint)
addToMap(NPWeaponList.AA_SARH   ,   NPWeaponList.AA_SARHPoint)
addToMap(NPWeaponList.AA_newIR  ,   NPWeaponList.AA_newIRPoint)
addToMap(NPWeaponList.AA_oldIR  ,   NPWeaponList.AA_oldIRPoint)

addToMap(NPWeaponList.AG_NLOS ,   NPWeaponList.AG_NLOSPoint)
addToMap(NPWeaponList.AG_SmartMissile ,   NPWeaponList.AG_SmartMissilePoint)
addToMap(NPWeaponList.AG_SmartBomb    ,   NPWeaponList.AG_SmartBombPoint)
addToMap(NPWeaponList.AG_Laser        ,   NPWeaponList.AG_LaserPoint)
addToMap(NPWeaponList.AG_Dumb         ,   NPWeaponList.AG_DumbPoint)

-- addToMap(NPWeaponList.ATGPod  ,   NPWeaponList.ATGPodPoint)
-- addToMap(NPWeaponList.mailbox ,   NPWeaponList.mailboxPoint)

-- 特殊多发挂架
addToMap({"Vikhr_M"}, NPWeaponList.AG_LaserPoint, 8)  -- 最后一个参数是几发算一组
addToMap({"BRM-1_90MM"}, NPWeaponList.AG_LaserPoint, 16)

env.info("武器信息已添加")
