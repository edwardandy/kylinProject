package mainModule.model.gameData.sheetData.tower
{
	import mainModule.model.gameData.sheetData.BaseFighterSheetItem;
	/**
	 * 塔数值表项  
	 * @author Edward
	 * 
	 */	
	public class TowerSheetItem extends BaseFighterSheetItem
	{
		/**
		 * 1兵营
		 * 2箭塔
		 * 3魔法塔
		 * 4炮塔
		 */
		public var type:int;
		/**
		 * 塔的进阶等级(非动态升级等级)
		 */
		public var level:int;
		/**
		 * 前置塔
		 */
		public var preTowerId:uint;
		
		private var _arrNextTowerIds:Array;
		/**
		 * 士兵配置
		 */
		public var soldierId:int;
		/**
		 * 战斗内的升级价格
		 */
		public var buyGold:uint;
			
		private var _vecUpgradeCostItems:Vector.<Array>;
		/**
		 * 解锁后的冷却时间 
		 */		
		public var coolTime:int;
		public function TowerSheetItem()
		{
			super();
		}
		
		/**
		 * 后置 塔ID
		 * "111004:111005:111006"
		 */
		public function set nextTowerId(ids:String):void
		{
			if(!ids)
				return;
			_arrNextTowerIds = ids.split(":");
		}
		/**
		 * 后置 塔ID
		 * "111004:111005:111006"
		 */
		public function get nextTowerIds():Array
		{
			return _arrNextTowerIds;
		}
		/**
		 * 解锁消耗材料(包括金币或钻石)
		 * “888888:100;133059:10”
		 */
		public function set upgradeCostItems(cost:String):void
		{
			if(!cost)
				return;
			_vecUpgradeCostItems = new Vector.<Array>;
			var arrCost:Array = cost.split(";");
			for each(var strCost:String in arrCost)
			{
				_vecUpgradeCostItems.push(strCost.split(":"));
			}
		}
		/**
		 * 解锁消耗材料(包括金币或钻石)
		 * [[888888,100],[133059,10]]
		 */
		public function get vecUpgradeCostItems():Vector.<Array>
		{
			return _vecUpgradeCostItems;
		}
	}
}