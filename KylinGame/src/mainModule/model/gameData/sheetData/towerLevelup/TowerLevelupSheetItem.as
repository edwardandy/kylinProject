package mainModule.model.gameData.sheetData.towerLevelup
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;
	/**
	 * 塔升级的数值表 
	 * @author Edward
	 * 
	 */	
	public class TowerLevelupSheetItem extends BaseSheetItem
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
		 * 获得塔升级前所需的cd时间 
		 * @param iType
		 * @return 
		 * 
		 */		
		public function getLevelupCdTime(iType:int):uint
		{
			return this["cdTime"+iType];
		}
		/**
		 * 获得塔升级后的成长值，兵营为攻击力和生命值，其他塔是攻击力和射程 
		 * @param iType
		 * @return 
		 * 
		 */		
		public function getLevelupGrowth(iType:int):Array
		{
			return [this["grow1_"+iType],this["grow2_"+iType]];
		}
		/**
		 * 获得塔升级所需的消耗 
		 * @param iType
		 * @return itemId:num;itemId:num...
		 * 
		 */		
		public function getLevelupCost(iType:int):String
		{
			return this["cost"+iType];
		}
	}
}