package mainModule.model.gameData.sheetData.skill.towerSkill
{
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.skill.BaseOwnerSkillSheetItem;

	/**
	 * 塔技能数值表项 
	 * @author Edward
	 * 
	 */	
	public class TowerSkillSheetItem extends BaseOwnerSkillSheetItem implements ITowerSkillSheetItem
	{
		private var _objUpgradeCost:Object;
		
		private var _buyGold:uint;
		private var _coolTime:int;
		
		public function TowerSkillSheetItem()
		{
			super();
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
		 * 战斗内的升级价格
		 */
		public function get buyGold():uint
		{
			return _buyGold;
		}

		/**
		 * @private
		 */
		public function set buyGold(value:uint):void
		{
			_buyGold = value;
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