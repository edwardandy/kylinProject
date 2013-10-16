package mainModule.model.gameData.sheetData.towerLevelup
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;
	/**
	 * 塔升级的数值表 
	 * @author Edward
	 * 
	 */	
	public class TowerLevelupSheetItem extends BaseSheetItem implements ITowerLevelupSheetItem
	{
		/**
		 * 升级前的冷却时间 
		 */		
		public var cdTime1:uint;
		public var cdTime2:uint;
		public var cdTime3:uint;
		public var cdTime4:uint;
		/**
		 * 升级后的成长 
		 */
		public var grow1_1:uint;
		public var grow2_1:uint;
		public var grow1_2:uint;
		public var grow2_2:uint;
		public var grow1_3:uint;
		public var grow2_3:uint;
		public var grow1_4:uint;
		public var grow2_4:uint;
		/**
		 * 升级所需的消耗 
		 */		
		public var cost1:String;
		public var cost2:String;
		public var cost3:String;
		public var cost4:String;
		
		public function TowerLevelupSheetItem()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */	
		public function getLevelupCdTime(iType:int):uint
		{
			return this["cdTime"+iType];
		}
		/**
		 * @inheritDoc
		 */		
		public function getLevelupGrowth(iType:int):Array
		{
			return [this["grow1_"+iType],this["grow2_"+iType]];
		}
		/**
		 * @inheritDoc
		 */		
		public function getLevelupCost(iType:int):String
		{
			return this["cost"+iType];
		}
	}
}