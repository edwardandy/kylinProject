package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.BasicBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.logic.hurt.FightUnitState;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	
	public interface ISkillTarget extends IPositionUnit
	{
		/**
		 * 类型
		 * 陆地=1 飞行=2
		 */
		function get fightUnitType():int;
		/**
		 * 目标类型: 塔，怪物，英雄
		 */
		function get elemeCategory():String;
		/**
		 * SubjectCategory常量类型
		 */
		function get subjectCategory():int;
		/**
		 * 所在阵营
		 */
		function get campType():int;
		/**
		 * 对象id
		 */
		function get objId():uint;
		/**
		 * 是否为boss
		 */
		function get isBoss():Boolean;
		/**
		 * 是否活着
		 */
		function get isAlive():Boolean;
		/**
		 * 是否未激活状态
		 */
		function isFreezedState():Boolean;
		/**
		 * 是否满血
		 */
		function get isFullLife():Boolean;
		/**
		 * 攻击类型 1：物理 2：魔法
		 */
		function get atkType():int;
		
		/**
		 * 最小攻击
		 */
		function get minAtk():int;
		
		/**
		 * 最大攻击
		 */
		function get maxAtk():int;
		/**
		 * 获取对立阵营
		 */
		function get oppositeCampType():int
		/**
		 * 被命中是的判断高度
		 */
		function get hurtPositionHeight():Number;
		/**
		 * 获取战斗状态
		 */
		function get fightState():FightUnitState;
		/**
		 * 爆炎弹专用，爆炸后会跟一个地表特效，缓存了爆炸时的位置，用于定位地表特效 
		 */		
		function get lastExplosionPoint():PointVO;
		/**
		 * 是否可召唤
		 */
		function canSummon(uid:uint,maxCount:int,owner:ISkillOwner):Boolean;
		/**
		 * 是否可被魅惑
		 */
		function canBetray():Boolean;
		/**
		 * 是否可被挑衅
		 */
		function canBeProvoked(owner:ISkillOwner):Boolean;
		/**
		 * 是否已被眩晕
		 */
		function isStun():Boolean;
		/**
		 * 是否已经有寒冰盾
		 */
		function hasIceShield():Boolean;
		//buff
		/**
		 * 添加buff
		 */
		function notifyAttachBuffer(buffId:uint,param:Object,owner:ISkillOwner):void;
		/**
		 * 删除buff
		 */
		function notifyDettachBuffer(buffId:uint,bImmediate:Boolean = true):void;
		/**
		 * 添加buff的显示资源
		 */
		function notifyAddBuffRes(buffRes:BasicBufferResource,layer:int,offsetX:int,offsetY:int):void;
		/**
		 * 添加buff的显示资源
		 */
		function notifyRemoveBuffRes(buffRes:BasicBufferResource):void;
		/**
		 * 是否有buff
		 */
		function hasBuffer(buffId:uint):Boolean;
		/**
		 * 删除buff
		 */
		//function notifyDettachBuffer(buffId:uint):void;
		/**
		 * 通知触发条件
		 */
		function notifyTriggerSkillAndBuff(condition:int):void;
		
		//技能直接作用的接口
		/**
		 * 增加最大生命值
		 */
		function addMaxLife(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 造成物理/魔法伤害
		 */
		function hurtSelf(value:int,atkType:int,owner:ISkillOwner,dieType:int = 0,scaleValue:Number = 1,bNormalAttack:Boolean = true):Boolean;
		/**
		 * 对目标造成效果所有者的基础攻击的倍率伤害
		 */
		function dmgAddition(pct:int,owner:ISkillOwner,dieType:int = 0):Boolean;
		/**
		 * 增加物理防御
		 */
		function addPhysicDef(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 增加魔法防御
		 */
		function addMagicDef(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 增加攻击力
		 */
		function addAtk(value:int,owner:ISkillOwner):Boolean;	
		/**
		 * 按百分比增加攻击力
		 */
		function addAtkPct(value:int,owner:ISkillOwner):Boolean;	
		/**
		 * 增加攻击距离
		 */
		function addAtkArea(value:int,owner:ISkillOwner):Boolean;	
		/**
		 * 增加攻击速度百分比,负值则为降低速度
		 */
		function addAtkSpdPct(value:int,owner:ISkillOwner):Boolean;	
		/**
		 * 英雄亲手杀死怪物所获得的物资提高百分比
		 */
		function addGoodsPct(value:int,owner:ISkillOwner):Boolean;	
		/**
		 * 增加生命值
		 */
		function addLife(value:int,owner:ISkillOwner,hasAnim:Boolean = true):Boolean;
		/**
		 * 按最大血量的万分比增加或减少血量
		 */
		function addMaxLifePct(pct:int,atkType:int,owner:ISkillOwner,hasAnim:Boolean = true,dieType:int = 0):Boolean;
		/**
		 * 立即重生
		 */
		function rebirthNow(owner:ISkillOwner):Boolean;
		/**
		 * 多连击
		 */
		function setMultyAtkCount(count:int,owner:ISkillOwner):Boolean;
		/**
		 * 格挡一次
		 * @param atkPct 对周围敌人的伤害百分比
		 */
		function addBlockFlag(atkPct:int,owner:ISkillOwner):Boolean;
		/**
		 * 感染周围目标
		 * @param buffId: 使其他目标感染上的buff
		 * @param param:  buff的参数信息
		 * @param area:	  感染的范围
		 * @param infectCount: 感染的数量，如果为0则为范围内所有目标
		 * @param campType: 1:本方阵营;2:对方阵营;3:双方阵营
		 */
		function infectRoundUnits(buffId:uint,param:Object,area:uint,infectCount:int,campType:int,owner:ISkillOwner):Boolean;
		/**
		 * 无敌
		 */
		function invincibleSlef(bEnable:Boolean,owner:ISkillOwner):Boolean;
		/**
		 * 定身/麻痹
		 */
		function stunSlef(bEnable:Boolean,owner:ISkillOwner):Boolean;
		/**
		 * 反弹伤害百分比
		 */
		function setReboundDmg(bEnable:Boolean,iPct:int,owner:ISkillOwner):Boolean;	
		/**
		 * 普通攻击时增加攻击百分比 如普通攻击有20%概率造成双倍伤害（远程造成1.5倍伤害
		 */
		function hugeDmgEff(bAdd:Boolean,owner:ISkillOwner,odds:int,nearPct:int,farPct:int):Boolean;
		/**
		 * 添加安全弹射装置  safeLaunch:伤害范围-伤害值-自己昏迷时间-落地伤害范围-落地伤害值
		 */
		function addSafeLaunchFlag(atkArea:int,dmg:int,stunTime:int,fallAtkArea:int,fallDmg:int,owner:ISkillOwner):Boolean;
		/**
		 * 普通攻击造成伤害的百分比转换成生命值
		 */
		function addTargetDmgPctToLife(iPct:int,owner:ISkillOwner):Boolean;
		/**
		 * 受到龙息塔攻击伤害加成百分比
		 */
		function addFireMoreDmgPct(iPct:int,owner:ISkillOwner):Boolean;
		/**
		 * 改变移动速度加成
		 */
		function changeMoveSpeed(iPct:int,owner:ISkillOwner,bBuffEnd:Boolean = false):Boolean;
		/**
		 * 增加周围塔的攻击力百分比  影响范围-增加的攻击百分比
		 */
		function addTowerAtkFlag(bAdd:Boolean,iArea:int,iAtk:int,owner:ISkillOwner):Boolean;
		/**
		 * 增加英雄周围士兵的攻击百分比
		 */
		function addSoldierAtkFlag(bAdd:Boolean,iArea:int,iAtk:int,owner:ISkillOwner):Boolean;
		/**
		 * 增加英雄周围士兵的防御
		 */
		function addSoldierDefFlag(bAdd:Boolean,iArea:int,iDef:int,owner:ISkillOwner):Boolean;
		/**
		 * 免疫移动减速
		 */
		function addImmuneRdcMoveSpdFlag(bAdd:Boolean,owner:ISkillOwner):Boolean;	
		/**
		 * 被魅惑
		 */
		function setBetrayFlag(bBetray:Boolean,owner:ISkillOwner):Boolean;
		/**
		 * 根据减少的血量增加额外的物理护甲
		 */
		function lifeToPhysicDef(pct:int,def:int,owner:ISkillOwner):Boolean;
		/**
		 * 巨兽之怒 beastAngry:血量下限百分比-变为区域攻击的范围-攻击速度加成-移动速度加成
		 */
		function addBeastAngryFlag(pct:int,area:int,atkSpd:int,moveSpd:int,owner:ISkillOwner):Boolean;
		/**
		 * 恶魔雪人变到最大后不能被阻拦，且增加攻击力
		 */
		function SnowballMax(atk:int,owner:ISkillOwner):Boolean;
		/**
		 * 攻击自己的敌人的攻击速度百分比降低
		 */
		function addReflectRdcAtkSpdFlag(pct:int,owner:ISkillOwner):Boolean;
		/**
		 * 每秒攻击周围一定范围的单位 atkRoundUnits:范围(像素)-(攻击值)
		 */
		function atkRoundUnits(area:int,atk:int,camp:int,owner:ISkillOwner,dieType:int = 0):Boolean;
		/**
		 * 被挑衅
		 */
		function Provoked(bProvoked:Boolean,owner:ISkillOwner):Boolean;
		/**
		 * 连续攻击同一目标造成累计伤害
		 */
		function addWeaknessAtk(bAdd:Boolean,atk:int,owner:ISkillOwner):Boolean;
		/**
		 * 对于不同体型的目标的伤害加成
		 */
		function addDmgPctBySize(bAdd:Boolean,pctSmall:int,pctNormal:int,pctBig:int,owner:ISkillOwner):Boolean;
		/**
		 * 生命值下降到一定百分比以下所受到的伤害减少百分比
		 */
		function RdcDmgByLifeDown(bAdd:Boolean,lifeLimit:int,dmgRdc:int,owner:ISkillOwner):Boolean;
		/**
		 * 添加行走的特殊效果，比如留下火焰、黑烟、粉尘
		 */
		function addWalkEff(effId:uint,duration:uint,param:Array,owner:ISkillOwner):Boolean;
		/**
		 * 添加地面持续特效，比如龙之怒的火焰
		 */
		function addGroundEff(effId:uint,duration:uint,param:Array,owner:ISkillOwner):Boolean;
		/**
		 * 减少受到某一类目标的伤害 rdcDmgByCategory:SubjectCategory常量类型的位或值-30
		 */
		function rdcDmgByCategory(category:int,pct:int,owner:ISkillOwner):Boolean;
		/**
		 * 隐身
		 */
		function Invisible(bEnable:Boolean,owner:ISkillOwner):Boolean;
		/**
		 * 掉落物资箱 dropBox:xxxxx-1-2000-100
		 */
		function dropBox(itemId:uint,count:int,duration:int,money:uint,owner:ISkillOwner):Boolean;
		/**
		 * 被秒杀
		 */
		function suddenDeath(owner:ISkillOwner,dieType:int = 0):Boolean;
		/**
		 * 召唤
		 */
		function summon(uid:uint,count:int,maxCount:int,owner:ISkillOwner):Boolean;
		/**
		 * 回退一定距离
		 */
		function rollBack(range:uint,owner:ISkillOwner):Boolean;
		/**
		 * 变成羊，不能攻击，不能使用技能，没有护甲
		 */
		function changeToSheep(bChange:Boolean,owner:ISkillOwner):Boolean;
		/**
		 * 死亡后爆炸
		 */
		function explodeAfterDie(dmg:int,range:int,owner:ISkillOwner,dieType:int):Boolean;
		/**
		 * 改变攻击所用的子弹
		 */
		function changeWeapon(weapon:uint,owner:ISkillOwner):Boolean;
		/**
		 * 增加寒冰盾护甲
		 */
		function addIceShield(pct:int,owner:ISkillOwner):Boolean;
		/**
		 * 增加所受伤害的百分比
		 */
		function addDmgUnderAtkPct(pct:int,owner:ISkillOwner):Boolean;
		/**
		 * 死亡后召唤其他单位
		 */
		function summonAfterDie(uid:uint,duration:int,owner:ISkillOwner):Boolean;
		/***************************** 被动技能 ***********************************/
		
		/**
		 * 被动技能增加最大血量
		 */
		function addPassiveMaxLife(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能按百分比增加最大血量
		 */
		function addPassiveMaxLifePct(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加物理防御
		 */
		function addPassivePhysicDef(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加魔法防御
		 */
		function addPassiveMagicDef(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加攻击力
		 */
		function addPassiveAtk(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加攻击力百分比
		 */
		function addPassiveAtkPct(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加攻击距离百分比
		 */
		function addPassiveAtkAreaPct(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加攻击距离
		 */
		function addPassiveAtkArea(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加移动速度百分比
		 */
		function addPassiveMoveSpeedPct(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加移动速度点数
		 */
		function addPassiveMoveSpeed(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加攻击速度百分比
		 */
		function addPassiveAtkSpdPct(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动技能增加技能伤害百分比
		 */
		function addPassiveSkillAtkPct(value:int,owner:ISkillOwner):Boolean;	
		/**
		 * 被动技能减少英雄 援军重生时间百分比
		 */
		function rdcPassiveRebirthPct(value:int,owner:ISkillOwner):Boolean;
		/**
		 * 被动减少技能cd时间百分比
		 */
		function rdcPassiveSkillCdPct(value:int,skillId:uint,owner:ISkillOwner):Boolean;
		/**
		 * 英雄通过装备获得的生命值加成提高的百分比
		 */
		function addPassiveEquipPct(value:Array,owner:ISkillOwner):Boolean;
		/**
		 * 巨匠维修工技能，提高工匠技能的影响范围和攻击力百分比 
		 */
		function addExtraAddTowerAtk(value:Array,owner:ISkillOwner):Boolean;
	}
}