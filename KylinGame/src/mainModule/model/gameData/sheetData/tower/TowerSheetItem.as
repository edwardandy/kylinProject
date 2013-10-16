package mainModule.model.gameData.sheetData.tower
{
	import mainModule.model.gameData.sheetData.BaseFighterSheetItem;
	/**
	 * 塔数值表项  
	 * @author Edward
	 * 
	 */	
	public class TowerSheetItem extends BaseFighterSheetItem implements ITowerSheetItem
	{
		private var _type:int;
		private var _level:int;
		private var _preTowerId:uint;
		private var _soldierId:int;
		private var _buyGold:uint;
		private var _coolTime:int;
		private var _arrNextTowerIds:Array;
		private var _vecUpgradeCostItems:Vector.<Array>;
		
		public function TowerSheetItem()
		{
			super();
		}
		
		/**
		 * 解锁后的冷却时间 
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
		 * 士兵配置
		 */
		public function get soldierId():int
		{
			return _soldierId;
		}

		/**
		 * @private
		 */
		public function set soldierId(value:int):void
		{
			_soldierId = value;
		}

		/**
		 * 前置塔
		 */
		public function get preTowerId():uint
		{
			return _preTowerId;
		}

		/**
		 * @private
		 */
		public function set preTowerId(value:uint):void
		{
			_preTowerId = value;
		}

		/**
		 * 塔的进阶等级(非动态升级等级)
		 */
		public function get level():int
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:int):void
		{
			_level = value;
		}

		/**
		 * 1兵营
		 * 2箭塔
		 * 3魔法塔
		 * 4炮塔
		 */
		public function get type():int
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:int):void
		{
			_type = value;
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