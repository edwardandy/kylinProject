package release.module.kylinFightModule.gameplay.constant.Skill
{
	public final class SkillResultTyps
	{
		/**
		 * 被动技能增加生命最大值
		 */
		public static const PASSIVE_MAXLIFE:String = "passiveMaxLife";
		/**
		 * 被动技能按百分比增加最大血量
		 */
		public static const PASSIVE_MAXLIFE_PCT:String = "passiveMaxLifePct";
		/**
		 * 被动技能增加魔法防御力
		 */
		public static const PASSIVE_MAGIC_DEF:String = "passiveMagicDef";
		/**
		 * 被动技能增加物理防御力
		 */
		public static const PASSIVE_DEF:String = "passiveDef";
		/**
		 * 被动技能增加攻击力
		 */
		public static const PASSIVE_ATK:String = "passiveAtk";
		/**
		 * 被动技能增加攻击力百分比
		 */
		public static const PASSIVE_ATK_PCT:String = "passiveAtkPct";
		/**
		 * 被动技能增加攻击距离百分比
		 */
		public static const PASSIVE_ATK_AREA_PCT:String = "passiveAtkAreaPct";
		/**
		 * 被动增加攻击距离点数
		 */
		public static const PASSIVE_ATK_AREA:String = "passiveAtkArea";
		/**
		 * 被动技能增加移动速度百分比
		 */
		public static const PASSIVE_MOVE_SPEED_PCT:String = "passiveMoveSpeedPct";
		/**
		 * 被动技能增加移动速度点数
		 */
		public static const PASSIVE_MOVE_SPEED:String = "passiveMoveSpeed";
		/**
		 * 被动技能增加攻击速度百分比
		 */
		public static const PASSIVE_ATK_SPD_PCT:String = "passiveAtkSpdPct";
		/**
		 * 被动技能减少英雄 援军重生时间百分比
		 */
		public static const PASSIVE_RDC_REBIRTH_PCT:String = "passiveRdcRebirthPct";
		/**
		 * 被动增加技能伤害百分比
		 */
		public static const PASSIVE_SKILL_ATK_PCT:String = "passiveSkillAtkPct";
		/**
		 * 被动减少技能cd时间百分比
		 */
		public static const PASSIVE_RDC_SKILL_CD_PCT:String = "passiveRdcSkillCdPct";
		/**
		 * 根据减少的血量增加额外的物理护甲
		 */
		public static const LIFE_TO_PHYSIC_DEF:String = "lifeToPhysicDef";
		
		/**
		 * 生命最大值
		 */
		public static const MAXLIFE:String = "maxLife";
		/**
		 * 造成物理伤害
		 */
		public static const DMG:String = "dmg";
		/**
		 * 加一定量的血
		 */
		public static const LIFE:String = "life";
		/**
		 * 召唤
		 */
		public static const SUMMON:String = "summon";
		/**
		 * 立即重生
		 */
		public static const REBIRTH:String = "rebirth";
		/**
		 * 死亡后感染周围目标
		 */
		public static const INFECT:String = "canInfect";
		/**
		 * 无敌
		 */
		public static const INVINCIBLE:String = "invincible";
		/**
		 * 定身/麻痹
		 */
		public static const STUN:String = "stun";
		/**
		 * 魔法伤害
		 */
		public static const MAGICDMG:String = "magicDmg";
		/**
		 * 增加物理防御
		 */
		public static const DEF:String = "def";
		/**
		 * 增加魔法防御
		 */
		public static const MAGICDEF:String = "magicDef";
		
		/**
		 * 普通攻击时增加攻击百分比 如普通攻击有20%概率造成双倍伤害（远程造成1.5倍伤害
		 */
		public static const HUGE_DMG__PCT:String = "hugeDmgPct";
		/**
		 * 格挡一次伤害
		 */
		public static const BLOCK:String = "block";
		/**
		 * 反弹伤害百分比
		 */
		public static const REBOUND_DMG_PCT:String = "reboundDmgPct";
		/**
		 * 对目标造成效果所有者的基础攻击的倍率伤害
		 */
		public static const DMG_ADDITION:String = "dmgAddition";
		/**
		 * 安全弹射装置
		 */
		public static const SAFE_LAUNCH:String = "safeLaunch";
		/**
		 * 多连击
		 */
		public static const MULTY_ATK:String = "multyAtk";
		/**
		 * 魅惑
		 */
		public static const BETRAY:String = "betray";
		/**
		 * 巨兽之怒 beastAngry:血量下限百分比-变为区域攻击的范围-攻击速度加成-移动速度加成
		 */
		public static const BEAST_ANGRY:String = "beastAngry";
		/**
		 * 恶魔雪人变到最大后不能被阻拦，且增加攻击力
		 */
		public static const SNOWBALL:String = "snowball";
		/**
		 * 攻击自己的敌人的攻击速度百分比降低
		 */
		public static const REFLECT_RDC_ATK_SPD:String = "reflectRdcAtkSpd";
		/**
		 * 每秒攻击周围一定范围的敌人
		 */
		public static const ATK_ROUND_ENEMY:String = "atkRoundEnemy";
		/**
		 * 增加周围塔的攻击力百分比
		 */
		public static const ADD_TOWER_ATK:String = "addTowerAtk";
		/**
		 * 动态增加或减少移动速度
		 */
		public static const MOVE_SPEED_PCT:String = "moveSpeedPct";
		/**
		 * 动态增加或减少攻击速度
		 */
		public static const ATK_SPEED_PCT:String = "atkSpeedPct";
		/**
		 * 受到龙息塔攻击伤害加成百分比
		 */
		public static const FIRE_MORE_DMG_PCT:String = "fireMoreDmgPct";
		/**
		 * 使怪物回退一定距离
		 */
		public static const ROLL_BACK:String = "rollBack";
		/**
		 * 变成羊，不能攻击，不能使用技能，没有护甲
		 */
		public static const SHEEP:String = "sheep";
		/**
		 * 动态增加攻击力点数
		 */
		public static const ADD_ATK:String = "addAtk";
		/**
		 * 寒冰盾
		 */
		public static const ICE_SHIELD:String = "iceShield";
		/**
		 * 增加英雄周围士兵的攻击百分比
		 */
		public static const ADD_SOLDIER_ATK:String = "addSoldierAtk";
		/**
		 * 增加英雄周围士兵的防御
		 */
		public static const ADD_SOLDIER_DEF:String = "addSoldierDef";
		/**
		 * 死亡后爆炸
		 */
		public static const EXPLODE_AFTER_DIE:String = "explodeAfterDie";
		/**
		 * 改变攻击所用的子弹
		 */
		public static const CHANGE_WEAPON:String = "changeWeapon";
		/**
		 *使用的子弹
		 */
		public static const WEAPON:String = "weapon";
		/**
		 * 免疫移动减速
		 */
		public static const IMMUNE_RDC_MOVE_SPD:String = "immuneRdcMoveSpd";
		/**
		 * 对目标的普通攻击伤害的百分比转换成自身生命值
		 */
		public static const TARGET_DMG_PCT_TO_LIFE:String = "targetDmgPctToLife";
		/**
		 * 被挑衅
		 */
		public static const PROVOKE:String = "provoke";
		/**
		 * 连续攻击同一目标造成累计伤害
		 */
		public static const WEAKNESS_ATK:String = "weaknessAtk";
		/**
		 * 对于不同体型的目标的伤害加成
		 */
		public static const DMG_PCT_BY_SIZE:String = "dmgPctBySize";
		/**
		 * 按最大血量的万分比增加或减少血量
		 */
		public static const ADD_MAX_LIFE_PCT:String = "addMaxLifePct";
		/**
		 * 生命值下降到一定百分比以下所受到的伤害减少百分比
		 */
		public static const RDC_DMG_BY_LIFE_DOWN:String = "rdcDmgByLifeDown";
		/**
		 * 添加行走的特殊效果，比如留下火焰、黑烟、粉尘
		 */
		public static const ADD_WALK_EFF:String = "addWalkEff";
		/**
		 * 减少受到某一类目标的伤害
		 */
		public static const RDC_DMG_BY_CATEGORY:String = "rdcDmgByCategory";
		/**
		 * 隐身
		 */
		public static const INVISIBLE:String = "invisible";
		/**
		 * 掉落物资箱
		 */
		public static const DROP_BOX:String = "dropBox";
		/**
		 * 被秒杀
		 */
		public static const SUDDEN_DEATH:String = "suddenDeath";
		/**
		 * 增加自身所受的伤害百分比
		 */
		public static const DMG_PCT:String = "dmgPct";
		/**
		 * 沉默玩家，无法使用战场法术
		 */
		public static const PLAYER_SILENT:String = "playerSilent";
		/**
		 * 死亡后召唤其他单位
		 */
		public static const SUMMON_AFTER_DIE:String = "summonAfterDie";
		/**
		 * 程序特殊处理
		 */
		public static const SPECIAL_PROCESS:String = "specialProcess";
		/**
		 * 增加一个地面特效
		 */
		public static const ADD_GROUND_EFF:String = "addGroundEff";
		/**
		 * 死亡后减少战场法术的cd
		 */
		public static const RDC_MAGIC_CD_AFTER_DIE:String = "rdcMagicCdAfterDie";
		/**
		 * 感电buff 对周围的所有生命单位每秒造成伤害 
		 */
		public static const SENSE_ELECT:String = "senseElect";
		/**
		 * 英雄通过装备获得的属性值加成提高的百分比 
		 */		
		public static const PASSIVE_EQUIP_PCT:String = "passiveEquipPct";
		/**
		 *  英雄亲手杀死怪物所获得的物资提高百分比
		 */		
		public static const ADD_GOODS_PCT:String = "addGoodsPct";
		/**
		 *  普通攻击对方时忽略对方的护甲  
		 */		
		public static const IGNORE_NORMAL_DEF:String = "ignoreNormalDef";
		/**
		 *  对空中单位增加的伤害百分比 
		 */		
		public static const DMG_FLY_PCT:String = "dmgFlyPct";
		/**
		 *  增加普通攻击的溅射范围 
		 */		
		public static const PASSIVE_ATK_RANGE:String = "passiveAtkRange";
		/**
		 *  巨匠维修工技能，提高工匠技能的影响范围和攻击力百分比 
		 */		
		public static const EXTRA_ADD_TOWER_ATK:String = "extraAddTowerAtk";
		/**
		 * 增加攻击距离
		 */
		public static const ADD_ATK_AREA:String = "addAtkArea";
	}
}