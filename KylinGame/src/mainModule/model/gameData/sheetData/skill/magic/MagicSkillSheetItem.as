package mainModule.model.gameData.sheetData.skill.magic
{	
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.skill.BaseSkillSheetItem;

	/**
	 * 法术数值表项 
	 * @author Edward
	 * 
	 */	
	public class MagicSkillSheetItem extends BaseSkillSheetItem
	{
		/**
		 * 技能等级
		 */
		public var level:uint;
		/**
		 * 持续时间 毫秒
		 */
		public var duration:uint;
		/**
		 * 法术使用积分
		 */
		public var rewardScore:uint;
		/**
		 * 法术释放方式 
		 * 0:点技能就释放
		 * 1：地图任意位置都可以释放
		 * 2：只能在路上放
		 * 3：只能作用于单体怪物
		 * 4:必须在路的中间位置释放 
		 */		
		public var releaseWay:int;
		/**
		 * 指针id，施放法术时显示
		 */
		public var cursorId:int;
		/**
		 * 图标id 
		 */		
		public var iconId:uint;
		/**
		 * 升级冷却时间  单位 秒
		 */		
		public var coolTime:int;
		/**
		 * 进阶冷却时间 单位 秒
		 */		
		public var adCoolTime:int;
		
		private var _objUpgradeCost:Object;
		
		private var _objAdvancedeCost:Object;
		
		public function MagicSkillSheetItem()
		{
			super();
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