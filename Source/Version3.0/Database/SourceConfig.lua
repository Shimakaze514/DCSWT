--[[
    SourceConfig.lua — 资源点系统集中配置

    加载顺序: SourceInit.lua 中第一个加载，早于 AircraftList / Category / WeaponList / Common 等。

    注意: Bomber.CostTable 和 Transporter.CostTable 定义在各自模块中（加载早于 SourceInit），
    因此它们的花费配置仍保留在 Mission/Modules/Bomber.lua 和 Transporter.lua 顶部。
]]

SourceConfig = {}

---------------------------------------------------------------------------
-- 1. 玩家个人资源点
---------------------------------------------------------------------------
SourceConfig.Player = {
    initPoint       = 1500,   -- 新玩家初始资源点
    maxPoint        = 3000,   -- 资源点上限（每周期自动削减到此值）
    recoverPoint    = 500,    -- 低保阈值（低于此值时恢复到此值）
    recoverInterval = 600,    -- 低保/封顶检查周期（秒）
}

---------------------------------------------------------------------------
-- 2. 击杀奖励（个人，pending 机制：降落全额结算，阵亡减半）
---------------------------------------------------------------------------
SourceConfig.KillReward = {
    AIRPLANE    = 200,
    HELICOPTER  = 150,
    GROUND_UNIT = 80,
    TROOPER     = 5,    -- ignoredTargets 列表中的步兵类单位
    SHIP        = 200,
    STRUCTURE   = 200,
}

-- 阵亡时 pending 击杀奖励的结算比例（0.5 = 减半）
SourceConfig.PilotDeathPendingRatio = 0.5

---------------------------------------------------------------------------
-- 3. 友军击杀惩罚
---------------------------------------------------------------------------
-- 击杀友军时扣除的点数 = 该单位对应的 KillReward 值（取负）
-- 友军击杀是立即结算，不走 pending

---------------------------------------------------------------------------
-- 4. 起飞花费 — 机型价格
---------------------------------------------------------------------------
SourceConfig.AircraftPrice = {
    superiorityFighter = 100,   -- 制空战斗机
    lightFighter       = 80,    -- 轻型战斗机
    attacker           = 60,    -- 对地攻击机
    helicopter         = 50,    -- 直升机 / 螺旋桨 / 教练机
}

---------------------------------------------------------------------------
-- 5. 起飞花费 — 武器价格（每组）
---------------------------------------------------------------------------
SourceConfig.WeaponPrice = {
    -- 空对空
    AA_newARH       = 25,   -- 先进主动弹 (AIM-120C, SD-10, PL-12)
    AA_oldARH       = 15,   -- 早期主动弹 (AIM-54, AIM-120B, R-77, R-27)
    AA_SARH         = 10,   -- 半主动弹 (AIM-7, R-27P/T, Super 530D)
    AA_newIR        = 10,   -- 先进红外弹 (AIM-9X, R-73)
    AA_oldIR        = 5,    -- 早期红外弹 (AIM-9M/L, R-60, PL-5, Mistral)
    -- 空对地
    AG_NLOS         = 100,  -- 人在回路/防区外 (AGM-84E/H, CM-802AKG)
    AG_SmartMissile = 35,   -- 精确制导导弹 (AGM-88/65/84D, LD-10, C-701/802, AGM-114)
    AG_SmartBomb    = 20,   -- 精确炸弹 (GBU-31/38/32, AGM-154, GB-6, LS-6, X-29T)
    AG_Laser        = 15,   -- 激光制导 (GBU-10/12/16/24, X-25ML, Ataka)
    AG_Dumb         = 5,    -- 无制导炸弹/火箭 (Mk-82/83/84, FAB, RBK, S-25)
}

---------------------------------------------------------------------------
-- 6. 阵营（联合）资源点
---------------------------------------------------------------------------
SourceConfig.Team = {
    redInitPoint    = 80000,    -- 红方初始阵营资源点
    blueInitPoint   = 80000,    -- 蓝方初始阵营资源点
}

-- 阵营击杀扣点（从被摧毁方的阵营池中扣除）
SourceConfig.TeamKillCost = {
    GROUND_UNIT = 80,   -- 地面单位被摧毁
    SHIP        = 300,  -- 舰船被摧毁
}
-- 阵营点降至 0 以下时触发 NP.declarePointDefeat

---------------------------------------------------------------------------
-- 7. 起飞规则
---------------------------------------------------------------------------
SourceConfig.TakeoffRule = {
    birthGracePeriod    = 120,  -- 出生后多少秒内起飞视为违规（秒）
    destroyCountdown    = 15,   -- 违规/资源不足后多少秒销毁飞机（秒）
}

---------------------------------------------------------------------------
-- 8. 忽略的步兵单位（击杀奖励按 TROOPER 而非 GROUND_UNIT 计算）
---------------------------------------------------------------------------
SourceConfig.IgnoredTargets = {
    ["Soldier stinger"]        = true,
    ["SA-18 Igla manpad"]      = true,
    ["Soldier M4"]             = true,
    ["Soldier AK"]             = true,
    ["Soldier M249"]           = true,
    ["Paratrooper AKS-74"]     = true,
    ["Paratrooper RPG-16"]     = true,
    ["2B11 mortar"]            = true,
}

env.info("[SourceConfig] 资源点配置加载完成")
