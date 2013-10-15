package mainModule.model.gameData.sheetData.skill.magic
{	
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.skill.BaseSkillSheetItem;

	/**
	 * 法术数值表项 
	 * @author Edward
	 * 
	 */	
	public class MagicSkillSheetItem extends BaseSkillSheetItem implements IMagicSkillSheetItem
	{
		private var _level:uint;
		private var _duration:uint;
		private var _rewardScore:uint;
		private var _releaseWay:int;
		private var _cursorId:int;
		private var _iconId:uint;
		private var _coolTime:int;
		private var _adCoolTime:int;
		private var _objUpgradeCost:Object;	
		private var _objAdvancedeCost:Object;
		
		public function MagicSkillSheetItem()
		{
			super();
		}

		/**
		 * 进阶冷却时间 单位 秒
		 */
		public function get adCoolTime():int
		{
			return _adCoolTime;
		}

		/**
		 * @private
		 */
		public function set adCoolTime(value:int):void
		{
			_adCoolTime = value;
		}

		/**
		 * 升级冷却时间  单位 秒
		 */
		public function get coolTime():int
		{
			return _coolTime;
		}

		/**
		 * @private
		 */
		public function set coolTime(value:int):void
		{
			_coolTime = value;
		}

		/**
		 * 图标id 
		 */
		public function get iconId():uint
		{
			return _iconId;
		}

		/**
		 * @private
		 */
		public function set iconId(value:uint):void
		{
			_iconId = value;
		}

		/**
		 * 指针id，施放法术时显示
		 */
		public function get cursorId():int
		{
			return _cursorId;
		}

		/**
		 * @private
		 */
		public function set cursorId(value:int):void
		{
			_cursorId = value;
		}

		/**
		 * 法术释放方式 
		 * 0:点技能就释放
		 * 1：地图任意位置都可以释放
		 * 2：只能在路上放
		 * 3：只能作用于单体怪物
		 * 4:必须在路的中间位置释放 
		 */
		public function get releaseWay():int
		{
			return _releaseWay;
		}

		/**
		 * @private
		 */
		public function set releaseWay(value:int):void
		{
			_releaseWay = value;
		}

		/**
		 * 法术使用积分
		 */
		public function get rewardScore():uint
		{
			return _rewardScore;
		}

		/**
		 * @private
		 */
		public function set rewardScore(value:uint):void
		{
			_rewardScore = value;
		}

		/**
		 * 持续时间 毫秒
		 */
		public function get duration():uint
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:uint):void
		{
			_duration = value;
		}

		/**
		 * 技能等级
		 */
		public function get level():uint
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:uint):void
		{
			_level = value;
		}

		/**
		 * 升级材料ID 格式 "888888:100;133046:1"
		 */
		public function set upgradeCostItems(cost:String):void
		{
			if(!cost)
				return;
			_objUpgradeCost = KylinStringUtil.parseCommaString(cost,";");
		}
		/**
		 * 升级材料ID 格式 {888888:100,133046:1}
		 */
		public function get objUpgradeCost():Object
		{
			return _objUpgradeCost;
		}
		/**
		 * 进阶材料ID 格式 "888888:100;133046:1"
		 */
		public function set advancedCostItems(cost:String):void
		{
			if(!cost)
				return;
			_objAdvancedeCost = KylinStringUtil.parseCommaString(cost,";");
		}
		/**
		 * 进阶材料ID 格式 {888888:100,133046:1}
		 */
		public function get objAdvancedeCost():Object
		{
			return _objAdvancedeCost;
		}
	}
}