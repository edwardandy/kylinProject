package mainModule.model.gameData.sheetData.skill
{
	/**
	 * 拥有使用者的技能数据表项，除了法术外的英雄技能、塔技能和怪物技能 
	 * @author Edward
	 * 
	 */	
	public class BaseOwnerSkillSheetItem extends BaseSkillSheetItem implements IBaseOwnerSkillSheetItem
	{
		private var _targetType:uint;
		private var _weapon:uint;
		private var _weaponCount:uint;
		private var _explode:uint;
		private var _needChant:Boolean;
		private var _chantDuration:uint;
		private var _specialType:int = 0;
		private var _triggerType:int;
		private var _targetCount:int = 0;
		
		
		public function BaseOwnerSkillSheetItem()
		{
			super();
		}

		/**
		 * 作用对象的数量
		 */
		public function get targetCount():int
		{
			return _targetCount;
		}

		/**
		 * @private
		 */
		public function set targetCount(value:int):void
		{
			_targetCount = value;
		}

		/**
		 * 使用的触发条件
		 */
		public function get triggerType():int
		{
			return _triggerType;
		}

		/**
		 * @private
		 */
		public function set triggerType(value:int):void
		{
			_triggerType = value;
		}

		/**
		 * 特殊类型
		 * 0或不填表示非特殊类型
		 * 1表示普通攻击时会附带buff
		 * 2表示只要cd时间一到就必定使用
		 */
		public function get specialType():int
		{
			return _specialType;
		}

		/**
		 * @private
		 */
		public function set specialType(value:int):void
		{
			_specialType = value;
		}

		/**
		 * 引导持续时间
		 */
		public function get chantDuration():uint
		{
			return _chantDuration;
		}

		/**
		 * @private
		 */
		public function set chantDuration(value:uint):void
		{
			_chantDuration = value;
		}

		/**
		 * 是否需要引导
		 */
		public function get needChant():Boolean
		{
			return _needChant;
		}

		/**
		 * @private
		 */
		public function set needChant(value:Boolean):void
		{
			_needChant = value;
		}

		/**
		 * 子弹到达目标后发生的爆炸效果，0表示子弹到达目标后直接造成伤害无爆炸
		 */
		public function get explode():uint
		{
			return _explode;
		}

		/**
		 * @private
		 */
		public function set explode(value:uint):void
		{
			_explode = value;
		}

		/**
		 * 子弹数量 0表示每个目标一个子弹
		 */
		public function get weaponCount():uint
		{
			return _weaponCount;
		}

		/**
		 * @private
		 */
		public function set weaponCount(value:uint):void
		{
			_weaponCount = value;
		}

		/**
		 * 子弹id
		 */
		public function get weapon():uint
		{
			return _weapon;
		}

		/**
		 * @private
		 */
		public function set weapon(value:uint):void
		{
			_weapon = value;
		}

		/**
		 * 作用对象类型 1:self;2:本方生物单位;4:敌方生物单位;8:对塔有效
		 */
		public function get targetType():uint
		{
			return _targetType;
		}

		/**
		 * @private
		 */
		public function set targetType(value:uint):void
		{
			_targetType = value;
		}

		/**
		 * 作用目标是否包含在SkillTargetTypeConst中枚举的某类对象
		 * @param uType SkillTargetTypeConst枚举值
		 * @return 
		 * 
		 */		
		public function hasTargetType(uType:uint):Boolean
		{
			return ((targetType & uType) == uType);
		}
	}
}