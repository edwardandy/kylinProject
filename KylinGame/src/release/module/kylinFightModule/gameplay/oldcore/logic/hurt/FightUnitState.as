package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	
	import flash.utils.Dictionary;

	/**
	 * 战斗单位的状态，包括一些可能动态改变的属性
	 */
	public class FightUnitState implements IDisposeObject
	{
		/**
		 * 是否为飞行单位
		 */
		public var isFlyUnit:Boolean = false;
		/**
		 *最小攻击 
		 */
		private var _minAtk:int;
		public function set minAtk(atk:int):void
		{
			_minAtk = atk;
		}
		public function get minAtk():int
		{
			return _minAtk;
		}
		/**
		 *最大攻击 
		 */
		private var _maxAtk:int;
		public function set maxAtk(atk:int):void
		{
			_maxAtk = atk;
		}
		public function get maxAtk():int
		{
			return _maxAtk;
		}
		/**
		 *攻击范围 
		 */
		public var baseAtkArea:int;
		/**
		 * 额外增加的攻击范围 
		 */		
		public var extraAtkArea:int;
		public function get atkArea():int
		{
			return baseAtkArea + extraAtkArea;
		}
		/**
		 *搜索范围 
		 */
		public var searchArea:int;
		/**
		 *区域攻击的影响范围
		 */
		public var range:int;
		/**
		 *攻击类型 1：物理 2：魔法
		 */
		public var atkType:int = 1;
		/**
		 * 攻击速度
		 *多长时间攻击一次 
		 * 单位 毫秒
		 */
		public var cdTime:int;
		/**
		 * 英雄或援兵的重生时间
		 */
		public var rebirthTime:uint;
		/**
		 * 减少的重生时间,单位百分比
		 */
		public var extraRebirthTime:int;
		/**
		 * 技能伤害加成万分比
		 */
		public var skillAtk:uint;
		/**
		 * 最大血量
		 */
		public var maxlife:uint;
		/**
		 * 当前血量
		 */
		private var _curLife:int;	
		/**
		 *物理防御力 
		 */
		public var physicDefense:int;
		/**
		 *法术防御力 
		 */
		public var magicDefense:int;
		/**
		 *技能cd减少百分比 id=>pct,id=>pct... id为0则所有技能cd都减少
		 */
		public var rdcSkillCd:Dictionary = new Dictionary;

		/**
		 * 当前要使用的技能id
		 */
		public var curUseSkillId:uint;
	
		//********************************动态添加的状态***********************************//
		/**
		 * 子弹
		 */
		public var weapon:uint;
		/**
		 * 无敌
		 */
		public var bInvincible:Boolean;
		/**
		 * 定身，无法移动
		 */
		public var bStun:Boolean;	
		/**
		 * 动态增加或减少的攻击速度百分比
		 */
		public var extraAtkSpdPct:int = 0;
		/**
		 * 动态增加的攻击力
		 */
		public var extraAtk:int;
		/**
		 * 动态增加的攻击力百分比
		 */
		public var extraAtkPct:int;
		/**
		 * 动态增加的最大血量
		 */
		private var _extraMaxlife:int;
		/**
		 * 动态增加的物理防御
		 */
		public var extraPhysicDefense:int;
		/**
		 * 由于血量减少而增加的护甲，buff的效果
		 */
		public var lifeRdcToPhysicDef:int;
		/**
		 *动态增加的魔法防御
		 */
		public var extraMagicDefense:int;
		/**
		 * 普通攻击时增加攻击百分比 如普通攻击有20%概率造成双倍伤害（远程造成1.5倍伤害
		 */
		public var hugeDmgState:HugeDmgState = new HugeDmgState;	
		/**
		 *  安全弹射装置  safeLaunch:伤害范围-伤害值-自己昏迷时间  使用过之后必须dispose
		 */
		//未实现
		public var safeLaunchState:SafeLaunchState = new SafeLaunchState;
		/**
		 * 被影响的次数，一个士兵可能被多个英雄增加攻防 
		 */		
		public var addedAtkCnt:int = 0;
		/**
		 * 增加周围塔的攻击力百分比  影响范围-增加的攻击百分比
		 */
		public var addTowerAtk:AddTowerAtkState = new AddTowerAtkState;
		/**
		 *  巨匠技能 
		 */		
		public var extraAddTowerAtk:ExtraAddTowerAtkState = new ExtraAddTowerAtkState;
		/**
		 * 增加周围士兵的攻击防御等
		 */
		public var addSoldierState:AddSoldierState = new AddSoldierState;
		/**
		 * 被魅惑后的阵营
		 */
		public var betrayState:BetrayState =  new BetrayState;	
		/**
		 *  巨兽之怒 beastAngry:血量下限百分比-变为区域攻击的范围-攻击速度加成-移动速度加成
		 */
		public var beastState:BeastAngryState =  new BeastAngryState;
		/**
		 * 连续攻击同一目标造成累计伤害
		 */
		public var weaknessAtkState:WeaknessAtkState =  new WeaknessAtkState;
		/**
		 * 对于不同体型的目标的伤害加成
		 */
		public var dmgPctBySizeState:DmgPctBySizeState =  new DmgPctBySizeState;
		/**
		 * 生命值下降到一定百分比以下所受到的伤害减少百分比
		 */
		public var rdcDmgByLifeDownState:RdcDmgByLifeDownState =  new RdcDmgByLifeDownState;
		/**
		 * 添加行走的特殊效果，比如留下火焰、黑烟、粉尘
		 */
		public var groundEffcetState:GroundEffectState = new GroundEffectState;
		/**
		 *格挡状态   使用过之后必须置为false
		 */
		public var bBlock:Boolean = false;
		/**
		 * 格挡成功后对周围敌人的伤害百分比 
		 */		
		public var iBlockAtkPct:int;
		/**
		 *是否可复活   使用过之后必须置为false
		 */
		public var bCanRebirth:Boolean = false;
		/**
		 *多连击次数   使用过之后必须置为0
		 */
		public var iMultyAtk:int = 0;
		
		/**
		 *反弹伤害百分比
		 */
		public var iReboundDmgPct:int = 0;
		/**
		 * 吸血，普通攻击转换成生命值的比率
		 */
		public var iAtkToLifePct:int = 0;
		/**
		 * 免疫移动减速
		 */
		public var bImmuneRdcMoveSpd:Boolean = false;
		/**
		 * 变为最大雪球状态 不能被阻挡
		 */
		//未实现
		public var bMaxSnowball:Boolean = false;
		/**
		 * 攻击自己的敌人的攻击速度百分比降低
		 */
		public var iReflectRdcAtkSpd:int = 0;
		/**
		 * 对自己挑衅的目标
		 */
		//未实现
		public var provokeTarget:BasicOrganismElement;
		
		/**
		 * 减少受到某一类目标的伤害 rdcDmgByCategory:SubjectCategory常量类型-30
		 */
		public var iRdcDmgFromCategory:int;
		public var iDmgFromCategoryPct:int = 0;
		/**
		 * 受到龙息塔攻击伤害加成百分比
		 */
		public var iFireMoreDmgPct:int = 0;
		/**
		 * 寒冰盾护甲值
		 */
		public var iIceShield:int = 0;
		/**
		 * 增加所受伤害的百分比
		 */
		public var iDmgUnderAtkPct:int = 0;
		/**
		 * 变成羊，不能攻击，不能使用技能，没有护甲
		 */
		public var bSheep:Boolean = false;
		/**
		 * 隐身
		 */
		public var bInvisible:Boolean = false;
		/**
		 * 装备带的吸血值百分比
		 */		
		public var equipBloodValuePct:int;
		/**
		 *  装备带的暴击几率百分比
		 */		
		public var equipCritValuePct:int;
		/**
		 * 英雄亲手杀死怪物所获得的物资提高百分比 
		 */		
		public var addGoodsPct:int;
		/**
		 * 普通攻击对方时忽略对方的护甲 
		 */		
		public var bIgnoreNormalDef:Boolean;
		/**
		 *  对空中单位增加的伤害百分比
		 */		
		public var iDmgFlyPct:int;
		
		private var _owner:ISkillOwner;
		
		public function FightUnitState(owner:ISkillOwner)
		{
			_owner = owner;
		}
		
		public function getRealMaxLife():uint
		{
			return maxlife + extraMaxlife;
		}
		
		public function getCurLifePct():int
		{
			return _curLife*100/getRealMaxLife();
		}
		
		public function addLife(value:int):Boolean
		{
			if(0 == value)
				return false;
			if(value >0 && _curLife == getRealMaxLife())
				return false;
			_curLife += value;	
			if(_curLife<0)
				_curLife = 0;
			else if(_curLife > getRealMaxLife())
				_curLife = getRealMaxLife();
			if(_owner)
				_owner.notifyTriggerSkillAndBuff(TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED);
			return true;
		}
		
		public function get curLife():int
		{
			return _curLife;
		}
		
		public function set curLife(life:int):void
		{
			if(life != _curLife)
			{
				_curLife = life;
				_owner.notifyTriggerSkillAndBuff(TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED);
			}
		}
		
		public function get extraMaxlife():int
		{
			return _extraMaxlife;
		}
		
		public function set extraMaxlife(life:int):void
		{
			if(life != _extraMaxlife)
			{
				_extraMaxlife = life;
				_owner.notifyTriggerSkillAndBuff(TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED);
			}
		}
		
		public function get totalPhysicDefense():int
		{
			var def:int = physicDefense + extraPhysicDefense + lifeRdcToPhysicDef;
			return def>100 ? 100 : def;
		}
		
		public function get totalMagicDefense():int
		{
			var def:int = magicDefense + extraMagicDefense + lifeRdcToPhysicDef;
			return def>100 ? 100 : def;
		}
		
		public function get realMinAtk():int
		{
			return _minAtk + extraAtk + _minAtk*extraAtkPct/100;
		}
		
		public function get realMaxAtk():int
		{
			return _maxAtk + extraAtk + _maxAtk*extraAtkPct/100;
		}
		
		public function dispose():void
		{
			hugeDmgState.dispose();
			hugeDmgState = null;
		}
		/**
		 * 获得由于攻速提高而减少的cd时间
		 */
		public function get extraCdTime():int
		{
			return cdTime * extraAtkSpdPct/100;
		}
	}
}