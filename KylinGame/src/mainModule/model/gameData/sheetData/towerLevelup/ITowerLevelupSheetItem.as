package mainModule.model.gameData.sheetData.towerLevelup
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	/**
	 * 塔升级的数值表 
	 * @author Edward
	 * 
	 */
	public interface ITowerLevelupSheetItem extends IBaseSheetItem
	{
		/**
		 * 获得塔升级前所需的cd时间 
		 * @param iType
		 * @return 
		 * 
		 */		
		function getLevelupCdTime(iType:int):uint;
		/**
		 * 获得塔升级后的成长值，兵营为攻击力和生命值，其他塔是攻击力和射程 
		 * @param iType
		 * @return 
		 * 
		 */		
		function getLevelupGrowth(iType:int):Array;
		/**
		 * 获得塔升级所需的消耗 
		 * @param iType
		 * @return itemId:num;itemId:num...
		 * 
		 */		
		function getLevelupCost(iType:int):String;
	}
}