package mainModule.model.gameData.sheetData.skill.towerSkill
{
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.skill.BaseOwnerSkillSheetItem;

	/**
	 * 塔技能数值表项 
	 * @author Edward
	 * 
	 */	
	public class TowerSkillSheetItem extends BaseOwnerSkillSheetItem
	{
		private var _objUpgradeCost:Object;
		
		/**
		 * 战斗内的升级价格
		 */
		public var buyGold:uint;
		/**
		 * 升级冷却时间  单位 秒
		 */		
		public var coolTime:int;
		
		public function TowerSkillSheetItem()
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
	}
}